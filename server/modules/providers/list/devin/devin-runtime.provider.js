import { createInterface } from 'node:readline';
import fs from 'node:fs';
import { promises as fsAsync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import crossSpawn from 'cross-spawn';
import {
    createCompleteMessage,
    createNormalizedMessage,
    isDevinContinuationPrompt,
    isDevinSummaryArtifact,
    providerChildEnv,
    readJsonConfig,
    readObjectRecord,
    readOptionalString,
    readStringArray,
    readStringRecord,
} from '../../../../shared/utils.js';
import { DevinSessionsProvider } from './devin-sessions.provider.js';
import {
    appendFilesInputTag,
    isAllowedImageSourcePath,
    isImageAttachmentDescriptor,
    normalizeAttachmentDescriptors,
    resolveImageAbsolutePath,
    resolveImageMediaType,
    toPosixPath,
} from '../../../../shared/image-attachments.js';
import { sessionsDb } from '../../../../modules/database/index.js';

const activeDevinProcesses = new Map();
const devinPendingPermissions = new Map();
let globalRequestId = 1;

const DEVIN_USER_MCP_CONFIG_PATH = path.join(os.homedir(), '.config', 'devin', 'mcp_config.json');
const DEVIN_PROJECT_MCP_CONFIG_NAMES = ['mcp_config.json', 'mcp_config.local.json'];

const ACP_IMAGE_MEDIA_TYPES = new Set(['image/jpeg', 'image/png', 'image/gif', 'image/webp']);

const SUPPORTED_TEXT_APPLICATION_MIME_TYPES = new Set([
    'application/json',
    'application/javascript',
    'application/typescript',
    'application/xml',
    'application/x-yaml',
    'application/yaml',
    'application/x-sh',
    'application/x-httpd-php',
    'application/x-www-form-urlencoded',
    'application/x-toml',
    'application/toml',
    'application/x-ini',
]);

const SUPPORTED_TEXT_MIME_PREFIXES = ['text/'];

const TEXT_EXTENSION_TO_MIME = {
    '.txt': 'text/plain',
    '.md': 'text/markdown',
    '.markdown': 'text/markdown',
    '.json': 'application/json',
    '.js': 'application/javascript',
    '.mjs': 'application/javascript',
    '.cjs': 'application/javascript',
    '.ts': 'application/typescript',
    '.tsx': 'application/typescript',
    '.jsx': 'application/javascript',
    '.py': 'text/x-python',
    '.sh': 'application/x-sh',
    '.bash': 'application/x-sh',
    '.zsh': 'application/x-sh',
    '.yml': 'application/x-yaml',
    '.yaml': 'application/x-yaml',
    '.xml': 'application/xml',
    '.html': 'text/html',
    '.htm': 'text/html',
    '.css': 'text/css',
    '.scss': 'text/x-scss',
    '.less': 'text/x-less',
    '.sql': 'text/x-sql',
    '.csv': 'text/csv',
    '.log': 'text/plain',
    '.ini': 'text/plain',
    '.conf': 'text/plain',
    '.cfg': 'text/plain',
    '.toml': 'application/toml',
    '.r': 'text/x-r',
    '.rb': 'text/x-ruby',
    '.go': 'text/x-go',
    '.java': 'text/x-java',
    '.kt': 'text/x-kotlin',
    '.c': 'text/x-c',
    '.cpp': 'text/x-c++src',
    '.h': 'text/x-c',
    '.hpp': 'text/x-c++src',
    '.cs': 'text/x-csharp',
    '.php': 'application/x-httpd-php',
    '.swift': 'text/x-swift',
    '.rs': 'text/x-rust',
    '.vue': 'text/x-vue',
    '.svelte': 'text/x-svelte',
    '.properties': 'text/x-java-properties',
};

const DEFAULT_CONTROL_TIMEOUT_MS = 120000;
const PROMPT_INACTIVITY_TIMEOUT_MS = 21600000; // 6 hours
const STALL_THRESHOLD_MS = 60000; // brak zdarzeń przez 60 s = run uznany za zawieszony

const CONTINUATION_PROMPT = 'Please continue and provide a final response.';
const MAX_CONTINUATION_ROUNDS = 2;
const TASKMASTER_TASKS_JSON = '.taskmaster/tasks/tasks.json';
const MAX_TASKMASTER_CONINUATION_ROUNDS = 200;
const TASKMASTER_TOKEN_BUDGET_THRESHOLD = 0.85;

function nextRequestId() {
    return globalRequestId++;
}

function readNumber(value) {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : 0;
}

function tokenBudgetFromUsageUpdate(update) {
    const used = readNumber(update.used);
    const total = readNumber(update.size);
    const inputTokens = readNumber(update?._meta?.['cognition.ai/inputTokens']) || readNumber(update.used);
    const outputTokens = readNumber(update?._meta?.['cognition.ai/outputTokens']) || 0;
    if (used <= 0 && inputTokens <= 0 && outputTokens <= 0) return null;
    return {
        used,
        total,
        inputTokens,
        outputTokens,
        breakdown: { input: inputTokens, output: outputTokens },
    };
}

function extractTextContent(content) {
    if (typeof content === 'string') return content;
    const record = readObjectRecord(content);
    if (record && typeof record.text === 'string') return record.text;
    return '';
}

function extractThoughtContent(update) {
    if (typeof update?.content === 'string') return update.content;
    if (typeof update?.thought === 'string') return update.thought;
    if (typeof update?.text === 'string') return update.text;
    return extractTextContent(update?.content);
}

function appendTranscript(jsonlPath, record) {
    if (!jsonlPath) return;
    try {
        fs.mkdirSync(path.dirname(jsonlPath), { recursive: true });
        fs.appendFileSync(jsonlPath, JSON.stringify(record) + '\n');
    } catch (error) {
        console.error('[Devin] Failed to append transcript:', error instanceof Error ? error.message : String(error));
    }
}

/**
 * One normalized user turn for both the JSONL transcript and the live echo.
 *
 * The same record is written and broadcast, so the persisted row and the
 * websocket copy share an id the client can reconcile. Attachment descriptors
 * ride along: without them the transcript copy loses the pasted images the
 * composer showed optimistically.
 *
 * Exported for the runtime provider tests.
 */
export function createUserTurnMessage(promptText, options, sessionId) {
    const attachments = normalizeAttachmentDescriptors(options?.attachments);
    const images = attachments.filter(isImageAttachmentDescriptor);
    const files = attachments.filter((descriptor) => !isImageAttachmentDescriptor(descriptor));
    return createNormalizedMessage({
        kind: 'text',
        role: 'user',
        content: promptText,
        images: images.length > 0 ? images : undefined,
        files: files.length > 0 ? files : undefined,
        sessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    });
}
function sendStreamEnd(writer, state) {
    if (!writer || state.streamEnded) return;
    state.streamEnded = true;
    writer.send(createNormalizedMessage({
        kind: 'stream_end',
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
// ---------------------------
//----------------- LIVE STREAM FORWARDING ------------
/**
 * Relays one ACP assistant-text chunk to the client as a `stream_delta`.
 *
 * Devin sends `agent_message_chunk` notifications while the model is still
 * generating. Forwarding them makes the transcript grow in real time; the
 * accumulated text stays in `state.assistantBuffer` for the message-boundary
 * flush and for the end-of-run reconciliation against the canonical copy in
 * the Devin database.
 */
function sendAssistantDelta(state, text) {
    if (!text) return;
    state.assistantBuffer += text;
    state.liveStreamOpen = true;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'stream_delta',
        content: text,
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
/**
 * Relays one ACP reasoning chunk to the client as a `thought_delta`.
 *
 * The client renders it in the same collapsible thinking block used for
 * persisted `thinking` rows, so reasoning is visible while it happens instead
 * of only after a history refresh.
 */
function sendThoughtDelta(state, text) {
    if (!text) return;
    state.thoughtBuffer += text;
    state.liveThoughtOpen = true;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'thought_delta',
        content: text,
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
/**
 * Closes the open live rows on the client (message and reasoning).
 *
 * Called at every message boundary — before a tool call, between continuation
 * rounds and at the end of the run — so the next chunks start a fresh row
 * instead of being appended to the previous message.
 */
function finalizeLiveMessages(state) {
    if (!state.liveStreamOpen && !state.liveThoughtOpen) return;
    state.liveStreamOpen = false;
    state.liveThoughtOpen = false;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'stream_end',
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
/**
 * Persists the assistant message that just ended (narration before a tool call,
 * or the answer of an intermediate continuation round) to the ddagent JSONL
 * transcript.
 *
 * The JSONL is what the client reloads as history, so without this the text the
 * user watched stream would disappear on the next refresh. The canonical final
 * answer is persisted separately from the Devin database, which keeps its node
 * id and is deduplicated against this row by content.
 */
function persistLiveAssistantMessage(state) {
    const content = state.assistantBuffer;
    state.assistantBuffer = '';
    if (!content.trim()) return;
    state.persistedAssistantContents.add(content.trim());
    appendTranscript(state.jsonlPath, createNormalizedMessage({
        kind: 'text',
        role: 'assistant',
        content,
        sessionId: state.appSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
/**
 * Persists the reasoning that just ended to the ddagent JSONL transcript so
 * the thinking blocks survive a history reload exactly as they streamed.
 */
function persistLiveThoughtMessage(state) {
    const content = state.thoughtBuffer;
    state.thoughtBuffer = '';
    if (!content.trim()) return;
    appendTranscript(state.jsonlPath, createNormalizedMessage({
        kind: 'thinking',
        content,
        sessionId: state.appSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
async function fetchLatestAssistantMessage(state, options = {}) {
    if (!state.appSessionId || !state.devinSessionId) return null;
    const maxRetries = options.maxRetries ?? 120;
    const retryDelayMs = options.retryDelayMs ?? 500;
    const scanLimit = options.scanLimit ?? null;
    for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
        if (attempt > 0) {
            await new Promise((resolve) => setTimeout(resolve, retryDelayMs));
        }
        try {
            const sessionsProvider = new DevinSessionsProvider();
            // Read from the Devin DB, not the lagging ddagent JSONL, and find
            // the most recent assistant message that actually comes after the
            // last real user turn. This prevents replaying a stale final from a
            // previous turn when the current turn only produced tool calls or
            // is still being written.
            const { messages } = await sessionsProvider.fetchHistory(state.appSessionId, {
                providerSessionId: state.devinSessionId,
                limit: scanLimit,
                offset: 0,
                skipJsonl: true,
            });
            if (!Array.isArray(messages)) continue;
            let lastUserIndex = -1;
            let bestAssistant = null;
            let bestAfterPromptStart = null;
            for (let i = 0; i < messages.length; i += 1) {
                const msg = messages[i];
                if (!msg || typeof msg.kind !== 'string') continue;
                if (msg.kind === 'text' && msg.role === 'user' && typeof msg.content === 'string' && !isDevinContinuationPrompt(msg.content)) {
                    lastUserIndex = i;
                    continue;
                }
                if (msg.kind !== 'text' || msg.role !== 'assistant' || typeof msg.content !== 'string' || !msg.content.trim()) continue;
                const trimmed = msg.content.trim();
                if (msg.isCompactSummary) continue;
                if (isDevinSummaryArtifact(trimmed)) continue;
                if (lastUserIndex !== -1 && i > lastUserIndex) {
                    bestAssistant = { id: msg.id, content: trimmed };
                }
                // Post-compaction fallback: when a turn survives a context
                // compact, the real user prompt stays on the abandoned branch
                // and the new chain only carries a system-role summary node —
                // so no user anchor exists. Anchor on the prompt's send time
                // instead, which excludes finals from earlier turns.
                const msgTs = Date.parse(msg.timestamp ?? '');
                if (!Number.isNaN(msgTs) && msgTs >= state.promptStartedAt - 10000) {
                    bestAfterPromptStart = { id: msg.id, content: trimmed };
                }
            }
            const found = bestAssistant ?? bestAfterPromptStart;
            if (found) return found;
        } catch (error) {
            console.error('[Devin] Failed to fetch final assistant message:', error instanceof Error ? error.message : String(error));
        }
    }
    return null;
}
async function sendFinalAssistantMessage(writer, state, options = {}) {
    if (!writer || !state.appSessionId || !state.devinSessionId) return false;
    const finalMsg = await fetchLatestAssistantMessage(state, options);
    if (!finalMsg || !finalMsg.content) return false;
    if (finalMsg.id === state.lastFinalAssistantId) return true;
    const streamedText = state.assistantBuffer;
    state.assistantBuffer = '';
    // A message that already streamed and was persisted at a tool boundary is
    // the same row this fetch would add: sending or appending it again would
    // duplicate it in the transcript and in the UI.
    if (state.persistedAssistantContents.has(finalMsg.content.trim())) {
        state.lastFinalAssistantId = finalMsg.id;
        state.finalAssistantStreamSent = true;
        return true;
    }
    const assistantMessage = createNormalizedMessage({
        id: finalMsg.id,
        kind: 'text',
        role: 'assistant',
        content: finalMsg.content,
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    });
    // The live row is still open when the run ends with a streamed answer:
    // keep what the user already watched when it matches the canonical copy,
    // and correct it in place when it does not. Without a live row (chunks
    // never arrived) the canonical copy is the only rendering of the answer
    // and must be sent as a regular message.
    if (state.liveStreamOpen) {
        if (streamedText.trim() !== finalMsg.content.trim()) {
            writer.send(createNormalizedMessage({
                kind: 'stream_replace',
                content: finalMsg.content,
                sessionId: state.devinSessionId,
                provider: 'devin',
                timestamp: new Date().toISOString(),
            }));
        }
    } else {
        writer.send(assistantMessage);
    }
    appendTranscript(state.jsonlPath, {
        ...assistantMessage,
        sessionId: state.appSessionId,
    });
    state.lastFinalAssistantId = finalMsg.id;
    state.finalAssistantStreamSent = true;
    return true;
}

function resolveDevinPermission(requestId, decision) {
    const pending = devinPendingPermissions.get(String(requestId));
    if (!pending) return;
    devinPendingPermissions.delete(String(requestId));

    const { params, state } = pending;
    const options = Array.isArray(params?.options) ? params.options : [];
    let selected;

    if (!decision?.allow) {
        selected = options.find((o) => o.kind === 'deny')
            ?? options.find((o) => o.kind === 'reject')
            ?? options.find((o) => o.kind === 'reject_once')
            ?? options.find((o) => o.kind === 'reject_always')
            ?? options[0];
    } else if (decision.rememberEntry) {
        selected = options.find((o) => o.kind === 'allow_always')
            ?? options.find((o) => o.kind === 'allow')
            ?? options.find((o) => o.kind === 'allow_once')
            ?? options[0];
    } else {
        selected = options.find((o) => o.kind === 'allow_once')
            ?? options.find((o) => o.kind === 'allow')
            ?? options.find((o) => o.kind === 'allow_always')
            ?? options[0];
    }

    if (!selected) return;

    const response = {
        jsonrpc: '2.0',
        id: pending.acpId,
        result: { outcome: { outcome: 'selected', optionId: selected.optionId } },
    };

    if (state.child?.stdin?.writable && !state.child.stdin.destroyed) {
        state.child.stdin.write(JSON.stringify(response) + '\n');
    }
}

function clearDevinPendingForState(state) {
    for (const [requestId, pending] of devinPendingPermissions.entries()) {
        if (pending.state === state) {
            devinPendingPermissions.delete(requestId);
        }
    }
}

function listDevinPendingPermissions(sessionId) {
    const result = [];
    for (const [requestId, pending] of devinPendingPermissions.entries()) {
        if (pending.appSessionId === sessionId) {
            result.push({
                requestId,
                toolName: readOptionalString(pending.params.title) ?? 'Tool',
                input: pending.params.rawInput ?? {},
                context: { options: Array.isArray(pending.params.options) ? pending.params.options : [] },
                sessionId: pending.devinSessionId,
            });
        }
    }
    return result;
}

function toEnvArray(env) {
    const record = readObjectRecord(env);
    if (!record) return [];
    return Object.entries(record)
        .filter(([name]) => typeof name === 'string' && name.length > 0)
        .map(([name, value]) => ({ name, value: typeof value === 'string' ? value : String(value) }));
}

function toHttpHeaderArray(headers) {
    const record = readObjectRecord(headers);
    if (!record) return [];
    return Object.entries(record)
        .filter(([name]) => typeof name === 'string' && name.length > 0)
        .map(([name, value]) => ({ name, value: typeof value === 'string' ? value : String(value) }));
}

function convertMcpServerToAcp(name, serverConfig, agentCapabilities) {
    const record = readObjectRecord(serverConfig);
    if (!record) return null;

    const mcpCaps = readObjectRecord(agentCapabilities?.mcpCapabilities) ?? {};
    const command = readOptionalString(record.command);
    const url = readOptionalString(record.url);
    const explicitTransport = readOptionalString(record.transport);
    const args = readStringArray(record.args) ?? [];

    let transport;
    if (explicitTransport === 'stdio' || explicitTransport === 'http' || explicitTransport === 'sse' || explicitTransport === 'ws') {
        transport = explicitTransport;
    }

    if (!transport) {
        if (command || args.length > 0) {
            transport = 'stdio';
        } else if (url) {
            transport = 'http';
        }
    }

    if (!transport) {
        console.warn(`[Devin] Skipping MCP server "${name}": could not determine transport.`);
        return null;
    }

    if (transport === 'stdio') {
        const finalCommand = command || args[0];
        if (!finalCommand) {
            console.warn(`[Devin] Skipping MCP server "${name}": missing command.`);
            return null;
        }
        const finalArgs = command ? args : args.slice(1);
        const envRecord = readStringRecord(record.env) ?? readStringRecord(record.environment) ?? {};
        return { name, command: finalCommand, args: finalArgs, env: toEnvArray(envRecord) };
    }

    if (transport === 'http') {
        if (!url) {
            console.warn(`[Devin] Skipping MCP server "${name}": missing url.`);
            return null;
        }
        if (!mcpCaps?.http) {
            console.warn(`[Devin] Skipping MCP server "${name}": HTTP transport is not supported by this agent.`);
            return null;
        }
        return { type: 'http', name, url, headers: toHttpHeaderArray(record.headers) };
    }

    if (transport === 'sse') {
        if (!url) {
            console.warn(`[Devin] Skipping MCP server "${name}": missing url.`);
            return null;
        }
        if (!mcpCaps?.sse) {
            console.warn(`[Devin] Skipping MCP server "${name}": SSE transport is not supported by this agent.`);
            return null;
        }
        return { type: 'sse', name, url, headers: toHttpHeaderArray(record.headers) };
    }

    console.warn(`[Devin] Skipping MCP server "${name}": unsupported transport "${transport}".`);
    return null;
}

function convertMcpServersToAcpList(servers, agentCapabilities) {
    const record = readObjectRecord(servers);
    if (!record) return [];
    const result = [];
    for (const [name, serverConfig] of Object.entries(record)) {
        const acpServer = convertMcpServerToAcp(name, serverConfig, agentCapabilities);
        if (acpServer) result.push(acpServer);
    }
    return result;
}

async function loadMcpConfig(workingDir, agentCapabilities, context) {
    // Prefer a provider-scoped MCP lookup if the runtime context exposes one.
    if (typeof context?.getMcpConfig === 'function') {
        try {
            const merged = {};
            const scopes = ['user', 'local', 'project'];
            for (const scope of scopes) {
                const workspacePath = scope === 'user' ? undefined : workingDir;
                const result = await context.getMcpConfig(scope, workspacePath);
                Object.assign(merged, readObjectRecord(result?.mcpServers) ?? {});
            }
            return convertMcpServersToAcpList(merged, agentCapabilities);
        } catch (error) {
            console.warn('[Devin] context.getMcpConfig failed, falling back to file read:', error instanceof Error ? error.message : String(error));
        }
    }

    // Fall back to reading Devin MCP config files directly (mirrors DevinMcpProvider).
    const merged = {};
    try {
        const userConfig = await readJsonConfig(DEVIN_USER_MCP_CONFIG_PATH);
        Object.assign(merged, readObjectRecord(userConfig.mcpServers) ?? {});
    } catch (error) {
        console.warn('[Devin] Failed to read user MCP config:', error instanceof Error ? error.message : String(error));
    }

    for (const fileName of DEVIN_PROJECT_MCP_CONFIG_NAMES) {
        try {
            const projectConfig = await readJsonConfig(path.join(workingDir, '.devin', fileName));
            Object.assign(merged, readObjectRecord(projectConfig.mcpServers) ?? {});
        } catch (error) {
            console.warn(`[Devin] Failed to read project MCP config "${fileName}":`, error instanceof Error ? error.message : String(error));
        }
    }

    return convertMcpServersToAcpList(merged, agentCapabilities);
}

function guessTextMimeType(filePath) {
    const ext = path.extname(filePath).toLowerCase();
    return TEXT_EXTENSION_TO_MIME[ext] || null;
}

async function isTextContent(filePath, mimeType) {
    if (mimeType) {
        if (SUPPORTED_TEXT_MIME_PREFIXES.some((prefix) => mimeType.startsWith(prefix))) return true;
        if (SUPPORTED_TEXT_APPLICATION_MIME_TYPES.has(mimeType)) return true;
        if (mimeType.startsWith('image/') || mimeType.startsWith('audio/') || mimeType.startsWith('video/')) return false;
        if (mimeType.startsWith('application/')) {
            // Unknown binary-looking application mime type; sample the file to be sure.
        }
    }

    const fh = await fsAsync.open(filePath, 'r');
    try {
        const buffer = Buffer.alloc(4096);
        const { bytesRead } = await fh.read(buffer, 0, 4096, 0);
        const sample = buffer.subarray(0, bytesRead);
        return sample.indexOf(0) === -1;
    } finally {
        await fh.close();
    }
}

async function buildPromptBlocks(promptText, options, workingDir, agentCapabilities) {
    const capabilities = readObjectRecord(agentCapabilities?.promptCapabilities) ?? {};
    const blocks = [{ type: 'text', text: promptText }];

    const fileDescriptors = normalizeAttachmentDescriptors(options?.files);
    const imageDescriptors = normalizeAttachmentDescriptors(options?.images);

    if (fileDescriptors.length > 0) {
        if (capabilities.embeddedContext) {
            for (const descriptor of fileDescriptors) {
                const resolvedPath = resolveImageAbsolutePath(workingDir, descriptor.path);
                if (!isAllowedImageSourcePath(resolvedPath, workingDir)) {
                    console.warn(`[Devin] Skipping file attachment outside allowed roots: ${descriptor.path}`);
                    continue;
                }
                try {
                    const canonicalPath = await fsAsync.realpath(resolvedPath);
                    if (!isAllowedImageSourcePath(canonicalPath, workingDir)) {
                        console.warn(`[Devin] Skipping symlinked file attachment outside allowed roots: ${descriptor.path}`);
                        continue;
                    }
                    const mimeType = descriptor.mimeType || guessTextMimeType(canonicalPath);
                    if (!await isTextContent(canonicalPath, mimeType)) {
                        console.warn(`[Devin] Skipping non-text file attachment: ${descriptor.path}`);
                        continue;
                    }
                    const text = await fsAsync.readFile(canonicalPath, 'utf8');
                    blocks.push({
                        type: 'resource',
                        resource: {
                            uri: 'file://' + toPosixPath(canonicalPath),
                            mimeType: mimeType || 'text/plain',
                            text,
                        },
                    });
                } catch (error) {
                    console.warn(`[Devin] Failed to read file attachment ${descriptor.path}:`, error instanceof Error ? error.message : String(error));
                }
            }
        } else {
            blocks[0].text = appendFilesInputTag(promptText, fileDescriptors);
        }
    }

    if (imageDescriptors.length > 0) {
        if (!capabilities.image) {
            console.warn('[Devin] Agent does not advertise image prompt capability; skipping image attachments.');
        } else {
            for (const descriptor of imageDescriptors) {
                const mediaType = resolveImageMediaType(descriptor);
                if (!mediaType || !ACP_IMAGE_MEDIA_TYPES.has(mediaType)) {
                    console.warn(`[Devin] Skipping unsupported image attachment type: ${descriptor.path}`);
                    continue;
                }
                const resolvedPath = resolveImageAbsolutePath(workingDir, descriptor.path);
                if (!isAllowedImageSourcePath(resolvedPath, workingDir)) {
                    console.warn(`[Devin] Skipping image attachment outside allowed roots: ${descriptor.path}`);
                    continue;
                }
                try {
                    const canonicalPath = await fsAsync.realpath(resolvedPath);
                    if (!isAllowedImageSourcePath(canonicalPath, workingDir)) {
                        console.warn(`[Devin] Skipping symlinked image attachment outside allowed roots: ${descriptor.path}`);
                        continue;
                    }
                    const bytes = await fsAsync.readFile(canonicalPath);
                    blocks.push({ type: 'image', data: bytes.toString('base64'), mimeType: mediaType });
                } catch (error) {
                    console.warn(`[Devin] Failed to read image attachment ${descriptor.path}:`, error instanceof Error ? error.message : String(error));
                }
            }
        }
    }

    return blocks;
}

function mapDdagentPermissionModeToAcp(mode) {
    switch (mode) {
        case 'bypassPermissions':
            return 'bypass';
        case 'acceptEdits':
            return 'accept-edits';
        default:
            return null;
    }
}

function readTaskMasterTasks(workingDir) {
    const filePath = path.join(workingDir, TASKMASTER_TASKS_JSON);
    if (!fs.existsSync(filePath)) return null;
    try {
        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
        return data?.master?.tasks ?? null;
    } catch {
        return null;
    }
}

function isTaskUnfinished(task) {
    return task.status !== 'done' && task.status !== 'cancelled';
}

function countUnfinishedTasks(tasks) {
    if (!Array.isArray(tasks)) return 0;
    let count = 0;
    for (const task of tasks) {
        if (isTaskUnfinished(task)) count += 1;
        if (Array.isArray(task?.subtasks)) {
            count += countUnfinishedTasks(task.subtasks);
        }
    }
    return count;
}

function getTaskMasterUnfinishedCount(workingDir) {
    const tasks = readTaskMasterTasks(workingDir);
    return countUnfinishedTasks(tasks);
}

function buildTaskMasterContinuationPrompt(workingDir, unfinished) {
    return `There are ${unfinished} unfinished Task Master task(s). Use mcp_call_tool with server_name "task-master-ai" and projectRoot "${workingDir}": call the next_task tool, implement the returned task, then call set_task_status to mark it done. Keep going until all tasks are done or the token budget is exhausted.`;
}

function isEditPermissionRequest(params) {
    const title = String(params?.title ?? '').toLowerCase();
    const rawInput = params?.rawInput ?? {};
    const toolName = String(rawInput?.tool ?? rawInput?.tool_name ?? '').toLowerCase();
    const hasPath = rawInput && (rawInput.path !== undefined || rawInput.paths !== undefined || rawInput.file_path !== undefined);
    const editKeywords = ['edit', 'write', 'apply', 'replace', 'create', 'modify', 'save', 'patch', 'file'];
    if (editKeywords.some((kw) => title.includes(kw)) || editKeywords.some((kw) => toolName.includes(kw))) {
        return true;
    }
    if (hasPath && !title.includes('exec') && !title.includes('bash') && !title.includes('shell') && !title.includes('run')) {
        return true;
    }
    return false;
}


// Devin tags every session/update emitted inside an agent context with
// _meta['cognition.ai/subagent_context'].parentAgentId: 'root' for the main
// agent and the child agentId for subagent-internal events (its tool calls,
// tool results and usage). Those events belong to the subagent's side chain —
// forwarding them renders the subagent's stream inside the main conversation.
function readSubagentOwnerId(update) {
    const ctx = update?._meta?.['cognition.ai/subagent_context'];
    const parentAgentId = readOptionalString(ctx?.parentAgentId) ?? readOptionalString(ctx?.parent);
    return parentAgentId && parentAgentId !== 'root' ? parentAgentId : null;
}

// Subagent lifecycle is reported as tool_call_update rows keyed by the child
// agentId carrying _meta['cognition.ai/subagent_started' | 'subagent_completed'].
function readSubagentLifecycle(update) {
    const meta = update?._meta;
    if (meta?.['cognition.ai/subagent_started']) {
        return { started: true, info: meta['cognition.ai/subagent_started'] };
    }
    if (meta?.['cognition.ai/subagent_completed']) {
        return { started: false, info: meta['cognition.ai/subagent_completed'] };
    }
    return null;
}

function hasUnresolvedSubagent(jsonlPath) {
    try {
        if (!fs.existsSync(jsonlPath)) return false;
        const content = fs.readFileSync(jsonlPath, 'utf8');
        const lines = content.trim().split('\n');
        const tail = lines.slice(-120);
        let lastLaunch = -1;
        let lastResolution = -1;
        for (let i = 0; i < tail.length; i += 1) {
            const entry = tail[i];
            if (entry.includes('run_subagent') && entry.includes('tool_use')) lastLaunch = i;
            if (entry.includes('read_subagent') && entry.includes('Subagent completed.')) lastResolution = i;
            if (entry.includes('Subagent completed:')) lastResolution = i;
            if (entry.includes('completed successfully')) lastResolution = i;
            if (entry.includes('subagent_completion_notification')) lastResolution = i;
        }
        return lastLaunch >= 0 && lastLaunch > lastResolution;
    } catch {
        return false;
    }
}

// Reads the active model out of an ACP config-option payload (the
// `configOptions` array on a session/new, session/load or
// session/set_config_option result, or on a config_option_update update).
function readModelConfigValue(source) {
    const options = Array.isArray(source?.configOptions) ? source.configOptions : [];
    const modelOption = options.find((option) => option?.id === 'model' || option?.category === 'model');
    return readOptionalString(modelOption?.currentValue);
}

// `devin acp --model` only sets the default for a NEW ACP session: a resumed
// session keeps the model it was saved with, and a live child keeps the model
// it was spawned with. Pushing the composer's selection explicitly is what
// makes a model change actually apply — otherwise a session created with e.g.
// SWE-2 Max keeps running it while the UI shows the newly picked model.
async function applyModelToDevinSession(state, model) {
    if (!model || state.model === model) return;
    try {
        const applied = await state.sendRequest('session/set_config_option', {
            sessionId: state.devinSessionId,
            configId: 'model',
            value: model,
        });
        state.model = readModelConfigValue(applied) ?? model;
    } catch (error) {
        console.warn('[Devin] Failed to apply the selected model to the session:', error instanceof Error ? error.message : error);
    }
}

function createDevinProcess(sessionId, workingDir, model, ws, context, providerSessionId = null, permissionMode = 'default', extraEnv = null) {
    return new Promise((resolve, reject) => {
        const devinArgs = ['acp'];
        if (model) devinArgs.push('--model', String(model));

        // extraEnv carries multi-account overrides picked at session creation.
        const childEnv = providerChildEnv(extraEnv && typeof extraEnv === 'object' ? extraEnv : {});

        const child = crossSpawn('devin', devinArgs, {
            cwd: workingDir,
            stdio: ['pipe', 'pipe', 'pipe'],
            env: childEnv,
        });

        const pending = new Map();
        const state = {
            child,
            devinSessionId: null,
            initialized: false,
            terminated: false,
            busy: false,
            currentWriter: ws,
            workingDir,
            model,
            appSessionId: sessionId,
            jsonlPath: null,
            assistantBuffer: '',
            thoughtBuffer: '',
            // Trimmed contents of the assistant messages this run already
            // streamed and persisted, so the end-of-run fetch never re-sends
            // one of them.
            persistedAssistantContents: new Set(),
            // True while the client holds an open live row for the current
            // message / reasoning burst. Boundaries close them with stream_end.
            liveStreamOpen: false,
            liveThoughtOpen: false,
            streamEnded: false,
            finalAssistantStreamSent: false,
            completeSent: false,
            childExited: false,
            childExitCode: null,
            aborted: false,
            continuationRound: 0,
            promptStartedAt: Date.now(),
            tokenBudget: null,
            agentCapabilities: {},
            permissionMode,
            lastFinalAssistantId: null,
            activeSubagentIds: new Set(),
        };

        const sendCompact = (msg) => {
            if (!child.stdin.writable || child.stdin.destroyed) return;
            child.stdin.write(JSON.stringify(msg) + '\n');
        };

        const armRequestTimeout = (id, method, reject) => {
            const timeoutMs = method === 'session/prompt'
                ? PROMPT_INACTIVITY_TIMEOUT_MS
                : DEFAULT_CONTROL_TIMEOUT_MS;
            return setTimeout(() => {
                const stillPending = pending.get(id);
                if (stillPending) {
                    pending.delete(id);
                    reject(new Error(`ACP request timeout: ${method}`));
                }
            }, timeoutMs);
        };

        const resetPromptInactivityTimeout = () => {
            for (const [id, entry] of pending.entries()) {
                if (entry.method === 'session/prompt') {
                    clearTimeout(entry.timeout);
                    entry.timeout = armRequestTimeout(id, 'session/prompt', entry.reject);
                    break;
                }
            }
        };

        state.sendRequest = (method, params) => {
            if (state.terminated) {
                return Promise.reject(new Error('Devin ACP session is terminated'));
            }
            const id = nextRequestId();
            const req = { jsonrpc: '2.0', id, method, params };
            sendCompact(req);
            return new Promise((res, rej) => {
                // session/prompt can trigger long tool chains (subagents,
                // reads, file edits). Use an inactivity timeout that resets
                // on every session/update, so multi-hour tasks are allowed
                // as long as the ACP process is still producing progress.
                const timeout = armRequestTimeout(id, method, rej);
                pending.set(id, { resolve: res, reject: rej, timeout, method });
            });
        };

        state.sendNotification = (method, params) => {
            sendCompact({ jsonrpc: '2.0', method, params });
        };

        state.prompt = async (command, options, writer) => {
            if (state.terminated || !state.devinSessionId) {
                throw new Error('Devin ACP session is not ready');
            }
            state.busy = true;
            state.currentWriter = writer;
            if (options?.permissionMode !== undefined) {
                state.permissionMode = options.permissionMode;
            }
            state.assistantBuffer = '';
            state.thoughtBuffer = '';
            state.persistedAssistantContents.clear();
            state.liveStreamOpen = false;
            state.liveThoughtOpen = false;
            state.streamEnded = false;
            state.finalAssistantStreamSent = false;
            state.completeSent = false;
            state.continuationRound = 0;
            state.promptStartedAt = Date.now();
            const promptText = Array.isArray(command) ? command.join('\n') : String(command);
            const autoContinue = options?.autoContinueTasks === true;
            const skipTranscript = options?.skipTranscript === true;
            const userTurn = createUserTurnMessage(promptText, options, state.devinSessionId);
            if (!skipTranscript) {
                appendTranscript(state.jsonlPath, userTurn);
            }
            writer.send(userTurn);
            try {
                let round = 0;
                let stopReason = 'end_turn';
                let promptTextForRound = promptText;
                let optionsForRound = options;
                let unfinished = 0;
                while (true) {
                    if (round > 0) {
                        unfinished = getTaskMasterUnfinishedCount(state.workingDir);
                        const continuationText = autoContinue && unfinished > 0 ? buildTaskMasterContinuationPrompt(state.workingDir, unfinished) : CONTINUATION_PROMPT;
                        // Continuation prompts are internal — they must be sent to
                        // the Devin ACP as the next user turn, but should not appear
                        // in the UI transcript as messages typed by the user.
                        promptTextForRound = continuationText;
                        optionsForRound = {};
                    }
                    const prompt = await buildPromptBlocks(promptTextForRound, optionsForRound, state.workingDir, state.agentCapabilities);
                    const result = await state.sendRequest('session/prompt', {
                        sessionId: state.devinSessionId,
                        prompt,
                    });
                    stopReason = readOptionalString(result?.stopReason) ?? 'end_turn';
                    console.warn('[Devin] session/prompt stopReason:', stopReason);
                    if (stopReason === 'cancelled') break;
                    round += 1;
                    state.continuationRound = round;
                    unfinished = getTaskMasterUnfinishedCount(state.workingDir);
                    const tokenHigh = state.tokenBudget?.total > 0 && (state.tokenBudget.used / state.tokenBudget.total) > TASKMASTER_TOKEN_BUDGET_THRESHOLD;
                    const maxRounds = autoContinue && unfinished > 0 ? Math.min(unfinished + 5, MAX_TASKMASTER_CONINUATION_ROUNDS) : MAX_CONTINUATION_ROUNDS;
                    const shouldContinue = (stopReason !== 'end_turn' && round < maxRounds) || (stopReason === 'end_turn' && autoContinue && unfinished > 0 && round < maxRounds && !tokenHigh);
                    if (!shouldContinue) break;
                    // Another round follows: close and persist this round's
                    // streamed message so the next one starts a fresh row.
                    finalizeLiveMessages(state);
                    persistLiveThoughtMessage(state);
                    persistLiveAssistantMessage(state);
                }
                if (stopReason === 'cancelled') {
                    state.busy = false;
                    // Keep whatever already streamed — the user watched it.
                    finalizeLiveMessages(state);
                    persistLiveThoughtMessage(state);
                    persistLiveAssistantMessage(state);
                    sendStreamEnd(writer, state);
                    writer.send(createCompleteMessage({
                        provider: 'devin',
                        sessionId: state.devinSessionId,
                        exitCode: 0,
                        aborted: true,
                    }));
                    state.completeSent = true;
                    return;
                }
                state.busy = false;
                const subMaxWaitMs = 15 * 60 * 1000;
                const subStart = Date.now();
                let subLastSeen = Date.now();
                while (Date.now() - subStart < subMaxWaitMs) {
                    await new Promise((resolve) => setTimeout(resolve, 500));
                    if (state.terminated) break;
                    if (state.lastActivityAt > subLastSeen) {
                        subLastSeen = state.lastActivityAt;
                        continue;
                    }
                    const unresolved = state.activeSubagentIds.size > 0 || hasUnresolvedSubagent(state.jsonlPath);
                    const quiet = unresolved ? 150000 : 10000;
                    if (Date.now() - subLastSeen >= quiet) break;
                }
                const finalOptions = { maxRetries: 120, retryDelayMs: 500, scanLimit: null };
                // The final reasoning belongs above the final answer in history.
                persistLiveThoughtMessage(state);
                const finalFound = await sendFinalAssistantMessage(writer, state, finalOptions);
                finalizeLiveMessages(state);
                sendStreamEnd(writer, state);
                if (finalFound) {
                    writer.send(createCompleteMessage({
                        provider: 'devin',
                        sessionId: state.devinSessionId,
                        exitCode: 0,
                    }));
                } else {
                    writer.send(createNormalizedMessage({
                        kind: 'error',
                        content: 'Devin did not produce a final assistant response in the transcript before the timeout.',
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                    }));
                    writer.send(createCompleteMessage({
                        provider: 'devin',
                        sessionId: state.devinSessionId,
                        exitCode: 1,
                    }));
                }
                state.completeSent = true;
            } catch (error) {
                state.busy = false;
                state.assistantBuffer = '';
                state.thinkingBuffer = '';
                if (!state.completeSent && !state.aborted) {
                    writer.send(createNormalizedMessage({
                        kind: 'error',
                        content: error instanceof Error ? error.message : String(error),
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                    }));
                    writer.send(createCompleteMessage({
                        provider: 'devin',
                        sessionId: state.devinSessionId,
                        exitCode: state.childExited ? (state.childExitCode ?? 1) : 1,
                    }));
                    state.completeSent = true;
                }
            }
        };

        const handleResponse = (msg) => {
            const id = msg.id;
            const entry = pending.get(id);
            if (!entry) return;
            pending.delete(id);
            clearTimeout(entry.timeout);
            if (msg.error) {
                entry.reject(new Error(msg.error.message || 'ACP error'));
            } else {
                entry.resolve(msg.result);
            }
        };

        const handleNotification = (msg) => {
            const method = msg.method;
            const params = readObjectRecord(msg.params) ?? {};
            const sessionIdFromMsg = readOptionalString(params.sessionId) ?? state.devinSessionId;
            const update = readObjectRecord(params.update);

            if (method === '_cognition.ai/mcp/serversChanged') return;

            if (method === '_cognition.ai/agent_stopped') {
                // Do nothing. The final stream_end and complete are sent from
                // the session/prompt result, which also fetches the canonical
                // final text to complete any partial streaming.
                return;
            }

            if (method === 'session/update' && update) {
                // Any progress update (tool call, status, token budget, etc.)
                // resets the prompt inactivity timeout so long-running work can
                // continue for hours without being killed by a fixed cap.
                resetPromptInactivityTimeout();
                state.lastActivityAt = Date.now();

                const sessionUpdate = readOptionalString(update.sessionUpdate);
                const sid = sessionIdFromMsg || sessionId;

                // Suppress updates belonging to a subagent's side chain: the
                // child agent's internal tool calls, results and usage must not
                // render as main-agent activity. They still count as activity
                // for the inactivity timeout above.
                if (readSubagentOwnerId(update)) return;

                // Lifecycle rows (subagent_started / subagent_completed) are
                // keyed by the child agentId. Track them so the completion wait
                // below knows a subagent is still running, but never surface
                // them as ordinary tool rows.
                const lifecycle = readSubagentLifecycle(update);
                if (lifecycle) {
                    const agentId = readOptionalString(lifecycle.info?.agentId) ?? readOptionalString(update.toolCallId);
                    if (agentId) {
                        if (lifecycle.started) state.activeSubagentIds.add(agentId);
                        else state.activeSubagentIds.delete(agentId);
                    }
                    return;
                }
                const updateToolCallId = readOptionalString(update.toolCallId);
                if (updateToolCallId && state.activeSubagentIds.has(updateToolCallId)) return;

                if (sessionUpdate === 'agent_message_chunk') {
                    // Live: relay the chunk so the transcript grows while the
                    // model is still generating. The canonical copy is fetched
                    // from the Devin DB when the run ends and is reconciled
                    // against this stream in sendFinalAssistantMessage.
                    sendAssistantDelta(state, extractTextContent(update.content));
                    return;
                }
                else if (sessionUpdate === 'agent_thought_chunk') {
                    // Live reasoning: rendered in the collapsible thinking
                    // block while the model reasons, not only after a reload.
                    sendThoughtDelta(state, extractThoughtContent(update));
                    return;
                }
                else if (sessionUpdate === 'usage_update') {
                    const tokenBudget = tokenBudgetFromUsageUpdate(update);
                    if (tokenBudget) {
                        state.tokenBudget = tokenBudget;
                        const budgetMessage = createNormalizedMessage({
                            kind: 'status',
                            text: 'token_budget',
                            tokenBudget,
                            sessionId: sid,
                            provider: 'devin',
                            timestamp: new Date().toISOString(),
                        });
                        state.currentWriter?.send(budgetMessage);
                        appendTranscript(state.jsonlPath, budgetMessage);
                    }
                }
                else if (sessionUpdate === 'tool_call') {
                    // The assistant message that introduced this call is done:
                    // close its live rows and persist it before the tool rows,
                    // so history keeps the narration in the order it streamed.
                    finalizeLiveMessages(state);
                    persistLiveThoughtMessage(state);
                    persistLiveAssistantMessage(state);
                    const toolName = readOptionalString(update.title) ?? 'Tool';
                    const toolId = readOptionalString(update.toolCallId) ?? `devin_tool_${nextRequestId()}`;
                    const toolInput = update.rawInput ?? {};
                    const toolUseMessage = createNormalizedMessage({
                        id: toolId,
                        kind: 'tool_use',
                        toolName,
                        toolId,
                        toolInput,
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                        timestamp: new Date().toISOString(),
                    });
                    appendTranscript(state.jsonlPath, toolUseMessage);
                    state.currentWriter?.send(toolUseMessage);
                }
                else if (sessionUpdate === 'tool_call_update') {
                    const contentBlocks = Array.isArray(update.content)
                        ? update.content.map(c => extractTextContent(c.content ?? c)).filter(Boolean).join('\n')
                        : '';
                    const toolId = readOptionalString(update.toolCallId) ?? `devin_tool_${nextRequestId()}`;
                    const isError = update.status === 'failed';
                    const toolResultMessage = createNormalizedMessage({
                        id: `${toolId}__result`,
                        kind: 'tool_result',
                        toolId,
                        content: contentBlocks,
                        isError,
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                        timestamp: new Date().toISOString(),
                    });
                    appendTranscript(state.jsonlPath, toolResultMessage);
                    state.currentWriter?.send(toolResultMessage);
                }
                else if (sessionUpdate === 'session_info_update' && update.title !== undefined && update.title !== null) {
                    sessionsDb.updateSessionCustomName(state.appSessionId, String(update.title));
                }
                else if (sessionUpdate === 'config_option_update') {
                    // Keep the tracked model in step with what the ACP session
                    // actually runs, so a later turn only pushes a real change.
                    const activeModel = readModelConfigValue(update);
                    if (activeModel) state.model = activeModel;
                }
                return;
            }

            if (method === 'session/request_permission') {
                const requestId = String(msg.id);
                const acpOptions = Array.isArray(params.options) ? params.options : [];
                devinPendingPermissions.set(requestId, {
                    acpId: msg.id,
                    state,
                    appSessionId: state.appSessionId,
                    devinSessionId: state.devinSessionId,
                    params,
                });

                const mode = state.permissionMode || 'default';

                if (mode === 'bypassPermissions') {
                    resolveDevinPermission(requestId, { allow: true });
                    return;
                }

                if (mode === 'acceptEdits' && isEditPermissionRequest(params)) {
                    resolveDevinPermission(requestId, { allow: true });
                    return;
                }

                state.currentWriter?.send(createNormalizedMessage({
                    kind: 'permission_request',
                    requestId,
                    toolName: readOptionalString(params.title) ?? 'Tool',
                    input: params.rawInput ?? {},
                    context: { options: acpOptions },
                    sessionId: state.devinSessionId,
                    provider: 'devin',
                }));
            }
        };

        const rl = createInterface({
            input: child.stdout,
            crlfDelay: Infinity,
        });

        rl.on('line', (line) => {
            if (!line.trim()) return;
            let msg;
            try {
                msg = JSON.parse(line);
            } catch {
                console.error('[Devin] Non-JSON stdout line:', line.slice(0, 200));
                return;
            }

            if (msg.id !== undefined && msg.method === undefined) {
                handleResponse(msg);
            } else if (msg.method) {
                handleNotification(msg);
            }
        });

        const onError = (error) => {
            if (state.terminated || state.completeSent) return;
            state.terminated = true;
            state.completeSent = true;
            state.currentWriter?.send(createNormalizedMessage({
                kind: 'error',
                content: error instanceof Error ? error.message : String(error),
                sessionId: state.devinSessionId || sessionId,
                provider: 'devin',
            }));
            state.currentWriter?.send(createCompleteMessage({
                provider: 'devin',
                sessionId,
                exitCode: 1,
            }));
            child.kill();
            activeDevinProcesses.delete(sessionId);
            clearDevinPendingForState(state);
        };

        child.on('error', (err) => onError(err));

        child.on('close', (code) => {
            if (state.terminated || state.completeSent) return;
            state.childExited = true;
            state.childExitCode = code;
            state.terminated = true;
            rejectQueuedPrompts(state, 'Devin ACP process closed');
            for (const [id, entry] of Array.from(pending.entries())) {
                pending.delete(id);
                clearTimeout(entry.timeout);
                entry.reject(new Error('Devin ACP process closed'));
            }
            activeDevinProcesses.delete(sessionId);
            clearDevinPendingForState(state);
        });

        (async () => {
            const initResult = await state.sendRequest('initialize', {
                protocolVersion: 1,
                capabilities: {},
                info: { name: 'ddagent-devin', version: '1.0.0' },
            });
            state.initialized = true;
            state.agentCapabilities = readObjectRecord(initResult?.agentCapabilities) ?? {};

            const mcpServers = await loadMcpConfig(workingDir, state.agentCapabilities, context);

            // Never use the app session id as a Devin resume id; the service
            // layer is the source of truth and already validates psid.
            const resumeSessionId = (providerSessionId && providerSessionId !== sessionId) ? providerSessionId : null;
            let sessionResult;
            let didLoad = false;
            if (resumeSessionId) {
                try {
                    sessionResult = await state.sendRequest('session/load', {
                        sessionId: resumeSessionId,
                        cwd: workingDir,
                        mcpServers,
                    });
                    if (sessionResult) {
                        didLoad = true;
                    }
                } catch (error) {
                    // Resume mógł się nie udać (sesja Devina wygasła / nie istnieje).
                    // Nie wywalaj runu — wystartuj świeżą sesję (transkrypt ma historię).
                    console.warn(`[Devin] Resume failed for "${resumeSessionId}" — starting fresh:`, error instanceof Error ? error.message : error);
                }
            }

            if (!sessionResult) {
                sessionResult = await state.sendRequest('session/new', { cwd: workingDir, mcpServers });
            }

            const devinSessionId = readOptionalString(sessionResult?.sessionId) ?? resumeSessionId;
            if (!devinSessionId) {
                throw new Error('ACP session did not return sessionId');
            }
            if (devinSessionId === state.appSessionId) {
                throw new Error('Devin returned an invalid session id identical to the app session id');
            }
            state.devinSessionId = devinSessionId;
            state.jsonlPath = path.join(workingDir, '.ddagent', 'devin', `${devinSessionId}.jsonl`);
            fs.mkdirSync(path.dirname(state.jsonlPath), { recursive: true });
            sessionsDb.createSession(devinSessionId, 'devin', workingDir, null, null, null, state.jsonlPath);

            // Merge the devin-native transcript row into the original app-allocated row.
            if (state.appSessionId && state.appSessionId !== devinSessionId) {
                sessionsDb.assignProviderSessionId(state.appSessionId, devinSessionId);
            }

            // Sync the UI-selected permission mode to the Devin ACP session.
            const acpMode = mapDdagentPermissionModeToAcp(permissionMode);
            if (acpMode) {
                await state.sendRequest('session/set_mode', {
                    sessionId: state.devinSessionId,
                    modeId: acpMode,
                });
            }

            // `--model` only picks the model for a new ACP session; a resumed
            // session keeps its saved model (announced through the load result
            // or a config_option_update). Track what the session actually runs
            // so run() only pushes a model the user really chose.
            const loadedModel = readModelConfigValue(sessionResult);
            if (loadedModel) {
                state.model = loadedModel;
            } else if (didLoad) {
                // Resumed without a model report: unknown, so run() pushes the
                // chosen model instead of assuming the spawn flag applied.
                state.model = null;
            }

            if (typeof state.currentWriter?.setSessionId === 'function') {
                state.currentWriter.setSessionId(devinSessionId);
            }

            state.currentWriter?.send(createNormalizedMessage({
                kind: 'session_created',
                newSessionId: devinSessionId,
                sessionId: devinSessionId,
                provider: 'devin',
            }));

            // If we reloaded an existing session, write back the same transcript path so
            // subsequent turns can continue appending to it.
            if (didLoad && resumeSessionId !== devinSessionId) {
                sessionsDb.createSession(devinSessionId, 'devin', workingDir, null, null, null, state.jsonlPath);
                if (state.appSessionId && state.appSessionId !== devinSessionId) {
                    sessionsDb.assignProviderSessionId(state.appSessionId, devinSessionId);
                }
            }

            resolve(state);
        })().catch((err) => {
            onError(err);
            reject(err);
        });
    });
}

async function run(command, options = {}, ws, context) {
    const { sessionId, projectPath, cwd, model, permissionMode } = options;
    const workingDir = cwd || projectPath || process.cwd();
    let state;

    try {
        const installed = await context.isProviderInstalled();
        if (!installed) {
            throw new Error('Devin CLI is not installed or not authenticated');
        }

        const resolved = sessionId ? await context.resolveResumeModel(sessionId, model) : null;
        // An explicitly chosen model (session row or client) is pushed onto the
        // ACP session; the catalog fallback only ever seeds a new session.
        const requestedModel = resolved?.model || (typeof model === 'string' ? model.trim() : '') || null;
        const modelArg = requestedModel || 'swe-1-7';

        const key = sessionId || `devin-${Date.now()}`;
        state = activeDevinProcesses.get(key);
        // "Change workspace" repoints sessions.project_path between turns, but
        // the long-lived ACP child stays bound to the directory it spawned in.
        // A process rooted elsewhere is restarted so the next prompt runs in
        // the new workspace — session/load resumes the provider session there.
        if (state && !state.terminated && state.workingDir && path.resolve(state.workingDir) !== path.resolve(workingDir)) {
            try { state.sendNotification('session/cancel', { sessionId: state.devinSessionId }); } catch {}
            state.terminated = true;
            rejectQueuedPrompts(state, 'Devin session moved to another workspace');
            try { state.child.kill(); } catch {}
            clearDevinPendingForState(state);
            activeDevinProcesses.delete(key);
            state = null;
        }
        if (!state || state.terminated) {
            const providerSessionId = sessionId ? await context.resolveProviderSessionId(sessionId) : null;
            state = await createDevinProcess(key, workingDir, modelArg, ws, context, providerSessionId, permissionMode, options.env);
            activeDevinProcesses.set(key, state);
        } else if (state.busy) {
            // Prompt w trakcie — rozróżnij zdrowy run od deadlocku.
            const lastActivity = state.lastActivityAt || state.promptStartedAt || 0;
            const stalled = Date.now() - lastActivity > STALL_THRESHOLD_MS;
            if (stalled) {
                // Zawieszony run (np. współbieżne prompty): zabij i wystartuj świeży.
                try { state.sendNotification('session/cancel', { sessionId: state.devinSessionId }); } catch {}
                state.terminated = true;
                rejectQueuedPrompts(state, 'Devin run stalled and was restarted');
                try { state.child.kill(); } catch {}
                activeDevinProcesses.delete(key);
                const providerSessionId = sessionId ? await context.resolveProviderSessionId(sessionId) : null;
                state = await createDevinProcess(key, workingDir, modelArg, ws, context, providerSessionId, permissionMode, options.env);
                activeDevinProcesses.set(key, state);
            } else {
                // Zdrowy run — kolejkuj; wykona się po zakończeniu bieżącego promptu.
                await applyModelToDevinSession(state, requestedModel);
                appendTranscript(state.jsonlPath, createUserTurnMessage(String(command), options, state.devinSessionId));
                // Resolve only once this prompt has actually run: returning
                // early would let the server queue mark its row `sent` while
                // the message still sits in this in-memory queue — and it
                // dies silently if the process is killed before draining.
                await new Promise((resolve, reject) => {
                    (state.queue ??= []).push({ command, options, ws, skipTranscript: true, resolve, reject });
                });
                return;
            }
        }
        // `devin acp --model` only sets the model for a new ACP session: a
        // resumed session keeps its saved model and a live child keeps the one
        // it was spawned with. Push the chosen model so a switch in the
        // composer actually applies to this turn.
        await applyModelToDevinSession(state, requestedModel);
        await state.prompt(command, options, ws);
        // Opróżnij kolejkę promptów oczekujących na tej samej sesji.
        while (state.queue && state.queue.length > 0 && !state.terminated) {
            const next = state.queue.shift();
            try {
                await state.prompt(next.command, next.options, next.ws);
                next.resolve?.();
            } catch (error) {
                next.ws.send(createNormalizedMessage({
                    kind: 'error',
                    content: error instanceof Error ? error.message : String(error),
                    sessionId: key,
                    provider: 'devin',
                }));
                next.ws.send(createCompleteMessage({
                    provider: 'devin',
                    sessionId: key,
                    exitCode: 1,
                }));
                // Keep run()'s catch from re-sending error+complete; the
                // rejection still marks the server queue row failed.
                state.completeSent = true;
                next.reject?.(error);
            }
        }
    } catch (error) {
        if (state?.completeSent) return;
        const sid = sessionId || '';
        state?.currentWriter?.send(createNormalizedMessage({
            kind: 'error',
            content: error instanceof Error ? error.message : String(error),
            sessionId: sid,
            provider: 'devin',
        }));
        state?.currentWriter?.send(createCompleteMessage({
            provider: 'devin',
            sessionId: sid,
            exitCode: 1,
        }));
    }
}

/**
 * Fails every prompt still waiting in a state's in-memory queue, so their
 * dispatchers resolve (the server queue marks the row failed) instead of
 * hanging on a process that is already gone.
 */
function rejectQueuedPrompts(state, reason) {
    for (const pending of state.queue ?? []) {
        try { pending.reject?.(new Error(reason)); } catch {}
    }
    state.queue = [];
}

async function abort(sessionId) {
    const state = activeDevinProcesses.get(sessionId);
    if (!state || state.terminated) return false;
    try {
        state.sendNotification('session/cancel', { sessionId: state.devinSessionId });
        // Give the cancel frame a moment to flush before the process dies —
        // an instant kill can drop it, and the cloud session then keeps
        // running the turn the user just stopped.
        await new Promise((resolve) => setTimeout(resolve, 200));
        state.aborted = true;
        state.terminated = true;
        rejectQueuedPrompts(state, 'Devin session aborted');
        state.child.kill();
        clearDevinPendingForState(state);
        activeDevinProcesses.delete(sessionId);
    } catch {
        // ignore
    }
    return true;
}

export const devinRuntime = {
    run,
    abort,
    permissions: {
        resolve: resolveDevinPermission,
        listPending: listDevinPendingPermissions,
    },
};

export { run as queryDevin, abort as abortDevinSession };

// Exported for tests: the model handshake against a resumed ACP session.
export { applyModelToDevinSession, readModelConfigValue };

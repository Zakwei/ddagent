/**
 * Command Code ACP runtime
 * ========================
 *
 * Runs the Command Code CLI (`command-code acp`, aliases `cmd`/`cmdc`) as a
 * long-lived Agent Client Protocol agent over stdio — one JSON-RPC 2.0
 * message per line — mirroring the Devin ACP adapter. Unlike Devin, the CLI
 * already persists the canonical v3 transcript at
 * `~/.commandcode/projects/<slug>/<session-id>.jsonl` (slug =
 * `commandCodeProjectSlug(cwd)`), so this adapter keeps NO ddagent-owned
 * mirror: live rows stream over the websocket and history reconciles against
 * the CLI transcript via `CommandCodeSessionsProvider.fetchHistory`.
 *
 * Exposed as `commandCodeRuntime` ({run, abort, permissions,
 * setPermissionMode}) — the `IProviderRuntime` facet of CommandCodeProvider.
 */

import { createInterface } from 'node:readline';
import path from 'node:path';
import {
  existsSync as fsExistsSync,
  promises as fsAsync,
  readFileSync as fsReadFileSync,
} from 'node:fs';

import crossSpawn from 'cross-spawn';

import type {
  AnyRecord,
  ProviderRuntimeWriter,
  IProviderRuntime,
} from '@/shared/index.js';
import {
  commandCodeDir,
  commandCodeProjectsDir,
  commandCodeProjectSlug,
  createCompleteMessage,
  createNormalizedMessage,
  providerChildEnv,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  readStringArray,
  readStringRecord,
  resolveCommandCodeExecutable,
  appendFilesInputTag,
  isAllowedImageSourcePath,
  isImageAttachmentDescriptor,
  normalizeAttachmentDescriptors,
  resolveImageAbsolutePath,
  resolveImageMediaType,
  toPosixPath,
} from '@/shared/index.js';

import { sessionsDb } from "../../../database/index.js";

import { CommandCodeSessionsProvider } from './commandcode-sessions.provider.js';

const activeCommandCodeProcesses = new Map<any, any>();
const commandCodePendingPermissions = new Map<any, any>();
let globalRequestId = 1;

const COMMAND_CODE_USER_MCP_CONFIG_PATH = () => path.join(commandCodeDir(), 'mcp.json');

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

const SUPPORTED_TEXT_MIME_PREFIXES: any = ['text/'];

const TEXT_EXTENSION_TO_MIME: any = {
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
    '.yml': 'text/x-yaml',
    '.yaml': 'text/x-yaml',
    '.xml': 'application/xml',
    '.html': 'text/html',
    '.htm': 'text/html',
    '.css': 'text/css',
    '.scss': 'text/css',
    '.less': 'text/css',
    '.sql': 'text/x-sql',
    '.csv': 'text/csv',
    '.log': 'text/plain',
    '.ini': 'text/plain',
    '.conf': 'text/plain',
    '.cfg': 'text/plain',
    '.toml': 'text/x-toml',
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
    '.vue': 'text/plain',
    '.svelte': 'text/plain',
    '.properties': 'text/x-java-properties',
};

const DEFAULT_CONTROL_TIMEOUT_MS = 120000;
const PROMPT_INACTIVITY_TIMEOUT_MS = 21600000; // 6 hours
const STALL_THRESHOLD_MS = 60000; // no events for 60 s = run treated as stalled

const CONTINUATION_PROMPT = 'Please continue and provide a final response.';
const MAX_CONTINUATION_ROUNDS = 2;
const TASKMASTER_TASKS_JSON = '.taskmaster/tasks/tasks.json';
const MAX_TASKMASTER_CONINUATION_ROUNDS = 200;
const TASKMASTER_TOKEN_BUDGET_THRESHOLD = 0.85;

function nextRequestId() {
    return globalRequestId++;
}

function readNumber(value: any) {
    const parsed = Number(value);
    return Number.isFinite(parsed) ? parsed : 0;
}

function tokenBudgetFromUsageUpdate(update: any) {
    const used = readNumber(update.used);
    const total = readNumber(update.size);
    const inputTokens = readNumber(update?._meta?.['cognition.ai/inputTokens'])
        || readNumber(update.inputTokens)
        || readNumber(update.input_tokens)
        || readNumber(update.used);
    const outputTokens = readNumber(update?._meta?.['cognition.ai/outputTokens'])
        || readNumber(update.outputTokens)
        || readNumber(update.output_tokens);
    if (used <= 0 && inputTokens <= 0 && outputTokens <= 0) return null;
    return {
        used,
        total,
        inputTokens,
        outputTokens,
        breakdown: { input: inputTokens, output: outputTokens },
    };
}

function extractTextContent(content: any) {
    if (typeof content === 'string') return content;
    const record = readObjectRecord(content);
    if (record && typeof record.text === 'string') return record.text;
    return '';
}

function extractThoughtContent(update: any) {
    if (typeof update?.content === 'string') return update.content;
    if (typeof update?.thought === 'string') return update.thought;
    if (typeof update?.text === 'string') return update.text;
    return extractTextContent(update?.content);
}

/** True for the internal continuation prompts we inject as user turns. */
function isCommandCodeContinuationPrompt(text: any) {
    if (typeof text !== 'string') return false;
    return text === CONTINUATION_PROMPT || (text.startsWith('There are ') && text.includes('unfinished Task Master task'));
}

/**
 * One normalized user turn broadcast to the client (the CLI itself persists
 * the real user entry into its v3 transcript on `session/prompt`).
 */
export function createUserTurnMessage(promptText: any, options: any, sessionId: any) {
    const attachments = normalizeAttachmentDescriptors(options?.attachments);
    const images = attachments.filter(isImageAttachmentDescriptor);
    const files = attachments.filter((descriptor: any) => !isImageAttachmentDescriptor(descriptor));
    return createNormalizedMessage({
        kind: 'text',
        role: 'user',
        content: promptText,
        images: images.length > 0 ? images : undefined,
        files: files.length > 0 ? files : undefined,
        sessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    });
}

function sendStreamEnd(writer: any, state: any) {
    if (!writer || state.streamEnded) return;
    state.streamEnded = true;
    writer.send(createNormalizedMessage({
        kind: 'stream_end',
        sessionId: state.commandCodeSessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    }));
}

// ---------------------------
//----------------- LIVE STREAM FORWARDING ------------

/** Relays one ACP `agent_message_chunk` to the client as a `stream_delta`. */
function sendAssistantDelta(state: any, text: any) {
    if (!text) return;
    state.assistantBuffer += text;
    state.liveStreamOpen = true;
    // A new burst reopens the stream — the boundary stream_end already sent
    // must not suppress the terminal one.
    state.streamEnded = false;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'stream_delta',
        content: text,
        sessionId: state.commandCodeSessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    }));
}

/** Relays one ACP `agent_thought_chunk` to the client as a `thought_delta`. */
function sendThoughtDelta(state: any, text: any) {
    if (!text) return;
    state.thoughtBuffer += text;
    state.liveThoughtOpen = true;
    state.streamEnded = false;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'thought_delta',
        content: text,
        sessionId: state.commandCodeSessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    }));
}

/**
 * Closes the open live rows on the client (message and reasoning) at every
 * message boundary, so the next chunks start a fresh row instead of being
 * appended to the previous message.
 */
function finalizeLiveMessages(state: any) {
    if (!state.liveStreamOpen && !state.liveThoughtOpen) return;
    state.liveStreamOpen = false;
    state.liveThoughtOpen = false;
    state.streamEnded = true;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'stream_end',
        sessionId: state.commandCodeSessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    }));
}

/**
 * Re-reads the last assistant answer from the CLI's own v3 transcript, so the
 * run completes with the canonical text even when chunks never streamed (or
 * streamed differently). Anchors on the last real user turn — our injected
 * continuation prompts count as anchors too, so a turn that only produced
 * tool calls never replays a previous turn's final.
 */
async function fetchLatestAssistantMessage(state: any, options: any = {}) {
    if (!state.appSessionId || !state.commandCodeSessionId) return null;
    const maxRetries = options.maxRetries ?? 120;
    const retryDelayMs = options.retryDelayMs ?? 500;
    const scanLimit = options.scanLimit ?? null;
    for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
        // Stop polling once the run is gone — abort/restart makes the fetch
        // pointless and it would keep the dispatcher blocked for a minute.
        if (state.terminated) return null;
        if (attempt > 0) {
            await new Promise((resolve: any) => setTimeout(resolve, retryDelayMs));
        }
        try {
            const sessionsProvider = new CommandCodeSessionsProvider();
            const { messages } = await sessionsProvider.fetchHistory(state.appSessionId, {
                providerSessionId: state.commandCodeSessionId,
                limit: scanLimit,
                offset: 0,
            });
            if (!Array.isArray(messages)) continue;
            let lastUserIndex = -1;
            let bestAssistant: any = null;
            let bestAfterPromptStart: any = null;
            for (let i = 0; i < messages.length; i += 1) {
                const msg = messages[i];
                if (!msg || typeof msg.kind !== 'string') continue;
                if (msg.kind === 'text' && msg.role === 'user' && typeof msg.content === 'string' && !isCommandCodeContinuationPrompt(msg.content)) {
                    lastUserIndex = i;
                    continue;
                }
                if (msg.kind !== 'text' || msg.role !== 'assistant' || typeof msg.content !== 'string' || !msg.content.trim()) continue;
                const trimmed = msg.content.trim();
                if (msg.isCompactSummary) continue;
                if (lastUserIndex !== -1 && i > lastUserIndex) {
                    bestAssistant = { id: msg.id, content: trimmed };
                }
                // Post-compaction fallback: the real user prompt can sit on an
                // abandoned branch with no user anchor in this chain — anchor
                // on the prompt's send time instead.
                const msgTs = Date.parse(msg.timestamp ?? '');
                if (!Number.isNaN(msgTs) && msgTs >= state.promptStartedAt - 10000) {
                    bestAfterPromptStart = { id: msg.id, content: trimmed };
                }
            }
            const found = lastUserIndex !== -1 ? bestAssistant : bestAfterPromptStart;
            if (found) return found;
        } catch (error: any) {
            console.error('[CommandCode] Failed to fetch final assistant message:', error instanceof Error ? error.message : String(error));
        }
    }
    return null;
}

// Consumed by provider runtime services and lifecycle tests.
export async function sendFinalAssistantMessage(writer: any, state: any, options: any = {}) {
    if (!writer || !state.appSessionId || !state.commandCodeSessionId) return false;
    const finalMsg = await fetchLatestAssistantMessage(state, options);
    if (state.terminated || !finalMsg || !finalMsg.content) return false;
    // The only candidate is the previous turn's final — the run produced no
    // new assistant message (an empty `end_turn`). Reporting success would
    // send exitCode 0 with nothing to show for the prompt.
    if (finalMsg.id === state.lastFinalAssistantId) return false;
    const streamedText = state.assistantBuffer;
    state.assistantBuffer = '';
    // The content that streamed into the live row is the same answer this
    // fetch found: marking sent without re-sending avoids a duplicated row.
    if (streamedText.trim() === finalMsg.content.trim()) {
        state.lastFinalAssistantId = finalMsg.id;
        state.finalAssistantStreamSent = true;
        return true;
    }
    const assistantMessage = createNormalizedMessage({
        id: finalMsg.id,
        kind: 'text',
        role: 'assistant',
        content: finalMsg.content,
        sessionId: state.commandCodeSessionId,
        provider: 'commandcode',
        timestamp: new Date().toISOString(),
    });
    // Correct the open live row in place when the canonical copy diverges;
    // without a live row the canonical copy is the only rendering.
    if (state.liveStreamOpen) {
        writer.send(createNormalizedMessage({
            kind: 'stream_replace',
            content: finalMsg.content,
            sessionId: state.commandCodeSessionId,
            provider: 'commandcode',
            timestamp: new Date().toISOString(),
        }));
    } else {
        writer.send(assistantMessage);
    }
    state.lastFinalAssistantId = finalMsg.id;
    state.finalAssistantStreamSent = true;
    return true;
}

function resolveCommandCodePermission(requestId: any, decision: any) {
    const pending = commandCodePendingPermissions.get(String(requestId));
    if (!pending) return;
    commandCodePendingPermissions.delete(String(requestId));

    // The ask was answered on one client — every other viewer still shows
    // the prompt, so drop it session-wide, not just on the answering device.
    pending.state?.currentWriter?.send?.(createNormalizedMessage({
        kind: 'permission_cancelled',
        requestId: String(requestId),
        reason: 'resolved',
        sessionId: pending.commandCodeSessionId,
        provider: 'commandcode',
    }));

    const { params, state } = pending;
    const options = Array.isArray(params?.options) ? params.options : [];
    let selected;

    if (!decision?.allow) {
        selected = options.find((o: any) => o.kind === 'deny')
            ?? options.find((o: any) => o.kind === 'reject')
            ?? options.find((o: any) => o.kind === 'reject_once')
            ?? options.find((o: any) => o.kind === 'reject_always')
            ?? options[0];
    } else if (decision.rememberEntry) {
        selected = options.find((o: any) => o.kind === 'allow_always')
            ?? options.find((o: any) => o.kind === 'allow')
            ?? options.find((o: any) => o.kind === 'allow_once')
            ?? options[0];
    } else {
        selected = options.find((o: any) => o.kind === 'allow_once')
            ?? options.find((o: any) => o.kind === 'allow')
            ?? options.find((o: any) => o.kind === 'allow_always')
            ?? options[0];
    }

    if (!selected) return;

    const response: any = {
        jsonrpc: '2.0',
        id: pending.acpId,
        result: { outcome: { outcome: 'selected', optionId: selected.optionId } },
    };

    if (state.child?.stdin?.writable && !state.child.stdin!.destroyed) {
        state.child.stdin!.write(JSON.stringify(response) + '\n');
    }
}

function clearCommandCodePendingForState(state: any) {
    for (const [requestId, pending] of commandCodePendingPermissions.entries()) {
        if (pending.state === state) {
            commandCodePendingPermissions.delete(requestId);
        }
    }
}

function listCommandCodePendingPermissions(sessionId: any) {
    const result: any = [];
    for (const [requestId, pending] of commandCodePendingPermissions.entries()) {
        if (pending.appSessionId === sessionId) {
            result.push({
                requestId,
                toolName: readOptionalString(pending.params.title) ?? 'Tool',
                input: pending.params.rawInput ?? {},
                context: { options: Array.isArray(pending.params.options) ? pending.params.options : [] },
                sessionId: pending.commandCodeSessionId,
            });
        }
    }
    return result;
}

function toEnvArray(env: any) {
    const record = readObjectRecord(env);
    if (!record) return [];
    return Object.entries(record)
        .filter(([name]: any) => typeof name === 'string' && name.length > 0)
        .map(([name, value]: any) => ({ name, value: typeof value === 'string' ? value : String(value) }));
}

function toHttpHeaderArray(headers: any) {
    const record = readObjectRecord(headers);
    if (!record) return [];
    return Object.entries(record)
        .filter(([name]: any) => typeof name === 'string' && name.length > 0)
        .map(([name, value]: any) => ({ name, value: typeof value === 'string' ? value : String(value) }));
}

function convertMcpServerToAcp(name: any, serverConfig: any, agentCapabilities: any) {
    const record = readObjectRecord(serverConfig);
    if (!record) return null;

    const mcpCaps = readObjectRecord(agentCapabilities?.mcpCapabilities) ?? {};
    const command = readOptionalString(record.command);
    const url = readOptionalString(record.url);
    const explicitTransport = readOptionalString(record.transport) ?? readOptionalString(record.type);
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
        console.warn(`[CommandCode] Skipping MCP server "${name}": could not determine transport.`);
        return null;
    }

    if (transport === 'stdio') {
        const finalCommand = command || args[0];
        if (!finalCommand) {
            console.warn(`[CommandCode] Skipping MCP server "${name}": missing command.`);
            return null;
        }
        const finalArgs = command ? args : args.slice(1);
        const envRecord = readStringRecord(record.env) ?? readStringRecord(record.environment) ?? {};
        return { name, command: finalCommand, args: finalArgs, env: toEnvArray(envRecord) };
    }

    if (transport === 'http' || transport === 'sse') {
        if (!url) {
            console.warn(`[CommandCode] Skipping MCP server "${name}": missing url.`);
            return null;
        }
        // Command Code advertises mcpCapabilities {http:true, sse:false} —
        // SSE configs are dropped here (the CLI supports only stdio+http).
        if (!mcpCaps?.http) {
            console.warn(`[CommandCode] Skipping MCP server "${name}": HTTP transport is not supported by this agent.`);
            return null;
        }
        return { type: 'http', name, url, headers: toHttpHeaderArray(record.headers) };
    }

    console.warn(`[CommandCode] Skipping MCP server "${name}": unsupported transport "${transport}".`);
    return null;
}

function convertMcpServersToAcpList(servers: any, agentCapabilities: any) {
    const record = readObjectRecord(servers);
    if (!record) return [];
    const result: any = [];
    for (const [name, serverConfig] of Object.entries(record)) {
        const acpServer = convertMcpServerToAcp(name, serverConfig, agentCapabilities);
        if (acpServer) result.push(acpServer);
    }
    return result;
}

/**
 * Merges Command Code's three MCP scopes (user `~/.commandcode/mcp.json`,
 * project `<cwd>/.mcp.json`, local `~/.commandcode/projects/<slug>/mcp.json`,
 * weakest→strongest per the CLI's documented precedence) into the ACP
 * `mcpServers` list. The CLI also loads these files itself, so the ACP copy
 * is belt-and-braces for agents that only honor the wire list.
 */
async function loadMcpConfig(workingDir: any, agentCapabilities: any, context: any) {
    // Prefer a provider-scoped MCP lookup if the runtime context exposes one.
    if (typeof context?.getMcpConfig === 'function') {
        try {
            const merged: any = {};
            for (const scope of ['user', 'project', 'local']) {
                const workspacePath = scope === 'user' ? undefined : workingDir;
                const result = await context.getMcpConfig(scope, workspacePath);
                Object.assign(merged, readObjectRecord(result?.mcpServers) ?? {});
            }
            return convertMcpServersToAcpList(merged, agentCapabilities);
        } catch (error: any) {
            console.warn('[CommandCode] context.getMcpConfig failed, falling back to file read:', error instanceof Error ? error.message : String(error));
        }
    }

    const merged: any = {};
    const paths: any = [
        COMMAND_CODE_USER_MCP_CONFIG_PATH(),
        path.join(workingDir, '.mcp.json'),
        path.join(commandCodeProjectsDir(), commandCodeProjectSlug(workingDir), 'mcp.json'),
    ];
    for (const filePath of paths) {
        try {
            const config = await readJsonConfig(filePath);
            Object.assign(merged, readObjectRecord(config.mcpServers) ?? {});
        } catch (error: any) {
            const code = error?.code;
            if (code !== 'ENOENT') {
                console.warn(`[CommandCode] Failed to read MCP config "${filePath}":`, error instanceof Error ? error.message : String(error));
            }
        }
    }

    return convertMcpServersToAcpList(merged, agentCapabilities);
}

function guessTextMimeType(filePath: any) {
    const ext = path.extname(filePath).toLowerCase();
    return TEXT_EXTENSION_TO_MIME[ext] || null;
}

async function isTextContent(filePath: any, mimeType: any) {
    if (mimeType) {
        if (SUPPORTED_TEXT_MIME_PREFIXES.some((prefix: any) => mimeType.startsWith(prefix))) return true;
        if (SUPPORTED_TEXT_APPLICATION_MIME_TYPES.has(mimeType)) return true;
        if (mimeType.startsWith('image/') || mimeType.startsWith('audio/') || mimeType.startsWith('video/')) return false;
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

async function buildPromptBlocks(promptText: any, options: any, workingDir: any, agentCapabilities: any) {
    const capabilities = readObjectRecord(agentCapabilities?.promptCapabilities) ?? {};
    const blocks: any = [{ type: 'text', text: promptText }];

    const fileDescriptors = normalizeAttachmentDescriptors(options?.files);
    const imageDescriptors = normalizeAttachmentDescriptors(options?.images);

    if (fileDescriptors.length > 0) {
        if (capabilities.embeddedContext) {
            for (const descriptor of fileDescriptors) {
                const resolvedPath = resolveImageAbsolutePath(workingDir, descriptor.path);
                if (!isAllowedImageSourcePath(resolvedPath, workingDir)) {
                    console.warn(`[CommandCode] Skipping file attachment outside allowed roots: ${descriptor.path}`);
                    continue;
                }
                try {
                    const canonicalPath = await fsAsync.realpath(resolvedPath);
                    if (!isAllowedImageSourcePath(canonicalPath, workingDir)) {
                        console.warn(`[CommandCode] Skipping symlinked file attachment outside allowed roots: ${descriptor.path}`);
                        continue;
                    }
                    const mimeType = descriptor.mimeType || guessTextMimeType(canonicalPath);
                    if (!await isTextContent(canonicalPath, mimeType)) {
                        console.warn(`[CommandCode] Skipping non-text file attachment: ${descriptor.path}`);
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
                } catch (error: any) {
                    console.warn(`[CommandCode] Failed to read file attachment ${descriptor.path}:`, error instanceof Error ? error.message : String(error));
                }
            }
        } else {
            blocks[0].text = appendFilesInputTag(promptText, fileDescriptors);
        }
    }

    if (imageDescriptors.length > 0) {
        if (!capabilities.image) {
            console.warn('[CommandCode] Agent does not advertise image prompt capability; skipping image attachments.');
        } else {
            for (const descriptor of imageDescriptors) {
                const mediaType = resolveImageMediaType(descriptor);
                if (!mediaType || !ACP_IMAGE_MEDIA_TYPES.has(mediaType)) {
                    console.warn(`[CommandCode] Skipping unsupported image attachment type: ${descriptor.path}`);
                    continue;
                }
                const resolvedPath = resolveImageAbsolutePath(workingDir, descriptor.path);
                if (!isAllowedImageSourcePath(resolvedPath, workingDir)) {
                    console.warn(`[CommandCode] Skipping image attachment outside allowed roots: ${descriptor.path}`);
                    continue;
                }
                try {
                    const canonicalPath = await fsAsync.realpath(resolvedPath);
                    if (!isAllowedImageSourcePath(canonicalPath, workingDir)) {
                        console.warn(`[CommandCode] Skipping symlinked image attachment outside allowed roots: ${descriptor.path}`);
                        continue;
                    }
                    const bytes = await fsAsync.readFile(canonicalPath);
                    blocks.push({ type: 'image', data: bytes.toString('base64'), mimeType: mediaType });
                } catch (error: any) {
                    console.warn(`[CommandCode] Failed to read image attachment ${descriptor.path}:`, error instanceof Error ? error.message : String(error));
                }
            }
        }
    }

    return blocks;
}

/**
 * Maps a ddagent permission mode onto Command Code's ACP mode ids
 * (`default`, `plan`, `auto-accept`, `dont-ask`, `bypass`; the CLI's
 * `--permission-mode` also accepts `accept-edits`/`yolo` aliases).
 */
// Consumed by provider runtime services and lifecycle tests.
export function mapDdagentPermissionModeToCommandCode(mode: any) {
    switch (mode) {
        case 'bypassPermissions':
        case 'bypass':
        case 'yolo':
            return 'bypass';
        case 'acceptEdits':
        case 'accept-edits':
        case 'auto-accept':
            return 'auto-accept';
        case 'plan':
            return 'plan';
        case 'dont-ask':
            return 'dont-ask';
        case 'default':
            return 'default';
        default:
            return null;
    }
}

function readTaskMasterTasks(workingDir: any) {
    const filePath = path.join(workingDir, TASKMASTER_TASKS_JSON);
    if (!fsExistsSync(filePath)) return null;
    try {
        const data = JSON.parse(fsReadFileSync(filePath, 'utf8'));
        return data?.master?.tasks ?? null;
    } catch {
        return null;
    }
}

function isTaskUnfinished(task: any) {
    return task.status !== 'done' && task.status !== 'cancelled';
}

function countUnfinishedTasks(tasks: any) {
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

function getTaskMasterUnfinishedCount(workingDir: any) {
    const tasks = readTaskMasterTasks(workingDir);
    return countUnfinishedTasks(tasks);
}

function buildTaskMasterContinuationPrompt(workingDir: any, unfinished: any) {
    return `There are ${unfinished} unfinished Task Master task(s). Use mcp_call_tool with server_name "task-master-ai" and projectRoot "${workingDir}": call the next_task tool, implement the returned task, then call set_task_status to mark it done. Keep going until all tasks are done or the token budget is exhausted.`;
}

function isEditPermissionRequest(params: any) {
    const title = String(params?.title ?? '').toLowerCase();
    const rawInput = params?.rawInput ?? {};
    const toolName = String(rawInput?.tool ?? rawInput?.tool_name ?? '').toLowerCase();
    const hasPath = rawInput && (rawInput.path !== undefined || rawInput.paths !== undefined || rawInput.file_path !== undefined);
    const editKeywords: any = ['edit', 'write', 'apply', 'replace', 'create', 'modify', 'save', 'patch', 'file'];
    if (editKeywords.some((kw: any) => title.includes(kw)) || editKeywords.some((kw: any) => toolName.includes(kw))) {
        return true;
    }
    if (hasPath && !title.includes('exec') && !title.includes('bash') && !title.includes('shell') && !title.includes('run')) {
        return true;
    }
    return false;
}

// Reads the active model out of an ACP config-option payload (the
// `configOptions` array on a session/new, session/load or
// session/set_config_option result, or on a config_option_update update).
// Consumed by provider runtime services and lifecycle tests.
export function readModelConfigValue(source: any) {
    const options = Array.isArray(source?.configOptions) ? source.configOptions : [];
    const modelOption = options.find((option: any) => option?.id === 'model' || option?.category === 'model');
    return readOptionalString(modelOption?.currentValue);
}

/**
 * Pushes the composer's model selection onto the live ACP session —
 * `command-code acp` takes no `--model` flag, so the pick only ever applies
 * through `session/set_config_option` (falling back to `session/set_model`,
 * which Command Code also implements). A resumed session keeps its saved
 * model, so this only fires when the requested value actually differs.
 */
// Consumed by provider runtime services and lifecycle tests.
export async function applyModelToCommandCodeSession(state: any, model: any) {
    if (!model || state.model === model) return;
    let applied: any = null;
    try {
        applied = await state.sendRequest('session/set_config_option', {
            sessionId: state.commandCodeSessionId,
            configId: 'model',
            value: model,
        });
    } catch (error: any) {
        try {
            // Both key spellings ride along: Command Code's own handler reads
            // `model`, the ACP-spec variant reads `modelId`.
            applied = await state.sendRequest('session/set_model', {
                sessionId: state.commandCodeSessionId,
                modelId: model,
                model,
            });
        } catch (innerError: any) {
            console.warn('[CommandCode] Failed to apply the selected model to the session:', innerError instanceof Error ? innerError.message : innerError);
            return;
        }
    }
    state.model = readModelConfigValue(applied) ?? model;
}

/**
 * Pushes the session's reasoning effort through `session/set_config_option`
 * with `configId: 'effort'` — Command Code's ACP has no `session/set_effort`
 * method (that name only exists in its internal headless protocol); effort is
 * a select-type configOption alongside `model`. `default` means the
 * provider's own setting — nothing is sent for it.
 */
// Consumed by provider runtime services and lifecycle tests.
export async function applyEffortToCommandCodeSession(state: any, effort: any) {
    if (!effort || effort === 'default' || state.effort === effort) return;
    // ACP validates effort against a per-model select ('default'/'off'/
    // 'high'/'max' on 1.74); anything outside that set errors, so only known
    // Command Code ids go over the wire.
    const COMMAND_CODE_EFFORT_VALUES = new Set(['off', 'high', 'max']);
    if (!COMMAND_CODE_EFFORT_VALUES.has(effort)) {
        console.warn(`[CommandCode] Ignoring unsupported effort "${effort}" — valid: off, high, max`);
        return;
    }
    try {
        await state.sendRequest('session/set_config_option', {
            sessionId: state.commandCodeSessionId,
            configId: 'effort',
            value: effort,
        });
        state.effort = effort;
    } catch (error: any) {
        console.warn('[CommandCode] Failed to apply the selected effort to the session:', error instanceof Error ? error.message : error);
    }
}

/**
 * Pushes the UI permission mode onto the live ACP session via
 * `session/set_mode`, so a mid-session switch in settings applies to the
 * next tool call rather than needing a respawn.
 */
async function applyPermissionModeToCommandCodeSession(state: any, mode: any) {
    const acpMode = mapDdagentPermissionModeToCommandCode(mode);
    if (!acpMode || state.appliedAcpMode === acpMode) return;
    try {
        await state.sendRequest('session/set_mode', {
            sessionId: state.commandCodeSessionId,
            modeId: acpMode,
        });
        state.appliedAcpMode = acpMode;
    } catch (error: any) {
        console.warn('[CommandCode] Failed to apply the permission mode to the session:', error instanceof Error ? error.message : error);
    }
}

function createCommandCodeProcess(sessionId: any, workingDir: any, model: any, ws: any, context: any, providerSessionId: any = null, permissionMode: any = 'default', effort: any = null, extraEnv: any = null) {
    return new Promise((resolve: any, reject: any) => {
        const executable = resolveCommandCodeExecutable() ?? 'command-code';
        // `cmd acp` takes no options — model/effort/mode go through ACP calls.
        const child = crossSpawn(executable, ['acp'], {
            cwd: workingDir,
            stdio: ['pipe', 'pipe', 'pipe'],
            env: providerChildEnv(extraEnv && typeof extraEnv === 'object' ? extraEnv : {}),
        });

        const pending = new Map<any, any>();
        const state: any = {
            child,
            commandCodeSessionId: null,
            initialized: false,
            terminated: false,
            busy: false,
            currentWriter: ws,
            workingDir,
            model,
            effort,
            appSessionId: sessionId,
            transcriptPath: null,
            assistantBuffer: '',
            thoughtBuffer: '',
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
            lastActivityAt: Date.now(),
            tokenBudget: null,
            agentCapabilities: {},
            permissionMode,
            appliedAcpMode: null,
            lastFinalAssistantId: null,
        };

        const sendCompact = (msg: any) => {
            if (!child.stdin!.writable || child.stdin!.destroyed) return;
            child.stdin!.write(JSON.stringify(msg) + '\n');
        };

        const armRequestTimeout = (id: any, method: any, reject: any) => {
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

        // Cancellation must settle requests even if the child never emits close.
        state.rejectPendingRequests = (reason: string) => {
            for (const [id, entry] of pending) {
                pending.delete(id);
                clearTimeout(entry.timeout);
                entry.reject(new Error(reason));
            }
        };

        state.sendRequest = (method: any, params: any) => {
            if (state.terminated) {
                return Promise.reject(new Error('Command Code ACP session is terminated'));
            }
            const id = nextRequestId();
            const req: any = { jsonrpc: '2.0', id, method, params };
            sendCompact(req);
            return new Promise((res: any, rej: any) => {
                // session/prompt can trigger long tool chains; the inactivity
                // timeout resets on every session/update, so multi-hour tasks
                // are allowed as long as the ACP process produces progress.
                const timeout = armRequestTimeout(id, method, rej);
                pending.set(id, { resolve: res, reject: rej, timeout, method });
            });
        };

        state.sendNotification = (method: any, params: any) => new Promise<void>((resolve, reject) => {
            if (!child.stdin!.writable || child.stdin!.destroyed) {
                reject(new Error('ACP input is closed'));
                return;
            }
            child.stdin!.write(JSON.stringify({ jsonrpc: '2.0', method, params }) + '\n', (error) => {
                if (error) reject(error);
                else resolve();
            });
        });

        state.prompt = async (command: any, options: any, writer: any) => {
            if (state.terminated || !state.commandCodeSessionId) {
                throw new Error('Command Code ACP session is not ready');
            }
            state.busy = true;
            state.currentWriter = writer;
            if (options?.permissionMode !== undefined) {
                state.permissionMode = options.permissionMode;
            }
            await applyPermissionModeToCommandCodeSession(state, state.permissionMode);
            state.assistantBuffer = '';
            state.thoughtBuffer = '';
            state.liveStreamOpen = false;
            state.liveThoughtOpen = false;
            state.streamEnded = false;
            state.finalAssistantStreamSent = false;
            state.completeSent = false;
            state.continuationRound = 0;
            state.promptStartedAt = Date.now();
            const promptText = Array.isArray(command) ? command.join('\n') : String(command);
            const autoContinue = options?.autoContinueTasks === true;
            const userTurn = createUserTurnMessage(promptText, options, state.commandCodeSessionId);
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
                        // Continuation prompts are internal next user turns —
                        // they must not appear in the UI transcript as typed
                        // messages.
                        promptTextForRound = continuationText;
                        optionsForRound = {};
                    }
                    const prompt = await buildPromptBlocks(promptTextForRound, optionsForRound, state.workingDir, state.agentCapabilities);
                    const result = await state.sendRequest('session/prompt', {
                        sessionId: state.commandCodeSessionId,
                        prompt,
                    });
                    stopReason = readOptionalString(result?.stopReason) ?? 'end_turn';
                    if (stopReason === 'cancelled') break;
                    round += 1;
                    state.continuationRound = round;
                    unfinished = getTaskMasterUnfinishedCount(state.workingDir);
                    const tokenHigh = state.tokenBudget?.total > 0 && (state.tokenBudget.used / state.tokenBudget.total) > TASKMASTER_TOKEN_BUDGET_THRESHOLD;
                    const maxRounds = autoContinue && unfinished > 0 ? Math.min(unfinished + 5, MAX_TASKMASTER_CONINUATION_ROUNDS) : MAX_CONTINUATION_ROUNDS;
                    const shouldContinue = (stopReason !== 'end_turn' && round < maxRounds) || (stopReason === 'end_turn' && autoContinue && unfinished > 0 && round < maxRounds && !tokenHigh);
                    if (!shouldContinue) break;
                    // Another round follows: close this round's live rows so
                    // the next one starts a fresh row.
                    finalizeLiveMessages(state);
                }
                if (stopReason === 'cancelled') {
                    state.busy = false;
                    finalizeLiveMessages(state);
                    sendStreamEnd(writer, state);
                    writer.send(createCompleteMessage({
                        provider: 'commandcode',
                        sessionId: state.commandCodeSessionId,
                        exitCode: 0,
                        aborted: true,
                    }));
                    state.completeSent = true;
                    return;
                }
                state.busy = false;
                const finalOptions: any = { maxRetries: 120, retryDelayMs: 500, scanLimit: null };
                if (state.terminated) throw new Error('Command Code session terminated');
                const finalFound = await sendFinalAssistantMessage(writer, state, finalOptions);
                if (state.terminated) throw new Error('Command Code session terminated');
                finalizeLiveMessages(state);
                sendStreamEnd(writer, state);
                if (finalFound) {
                    writer.send(createCompleteMessage({
                        provider: 'commandcode',
                        sessionId: state.commandCodeSessionId,
                        exitCode: 0,
                    }));
                } else {
                    const finalError = createNormalizedMessage({
                        kind: 'error',
                        content: `Command Code did not produce a final assistant response in the transcript before the timeout (stopReason: ${stopReason}).`,
                        sessionId: state.commandCodeSessionId,
                        provider: 'commandcode',
                    });
                    writer.send(finalError);
                    writer.send(createCompleteMessage({
                        provider: 'commandcode',
                        sessionId: state.commandCodeSessionId,
                        exitCode: 1,
                    }));
                }
                state.completeSent = true;
            } catch (error: any) {
                state.busy = false;
                // Close the open live rows so a partial streamed answer is
                // finalized instead of dangling.
                finalizeLiveMessages(state);
                if (!state.completeSent && !state.aborted) {
                    const runError = createNormalizedMessage({
                        kind: 'error',
                        content: error instanceof Error ? error.message : String(error),
                        sessionId: state.commandCodeSessionId,
                        provider: 'commandcode',
                    });
                    writer.send(runError);
                    writer.send(createCompleteMessage({
                        provider: 'commandcode',
                        sessionId: state.commandCodeSessionId,
                        exitCode: state.childExited ? (state.childExitCode ?? 1) : 1,
                    }));
                    state.completeSent = true;
                }
            }
        };

        const handleResponse = (msg: any) => {
            const id = msg.id;
            const entry = pending.get(id);
            if (!entry) return;
            pending.delete(id);
            clearTimeout(entry.timeout);
            if (msg.error) {
                // Keep the JSON-RPC code/data on the rejection — ACP reports
                // errors like "not authenticated" through them.
                const acpError: Error & { code?: number; data?: unknown } = new Error(msg.error.message || 'ACP error');
                if (msg.error.code !== undefined) acpError.code = msg.error.code;
                if (msg.error.data !== undefined) acpError.data = msg.error.data;
                entry.reject(acpError);
            } else {
                entry.resolve(msg.result);
            }
        };

        const handleNotification = (msg: any) => {
            // The process can drain buffered stdout after Stop or completion.
            // Do not mutate transcript buffers or publish those old updates.
            if (state.terminated || state.completeSent) return;
            const method = msg.method;
            const params = readObjectRecord(msg.params) ?? {};
            const sessionIdFromMsg = readOptionalString(params.sessionId) ?? state.commandCodeSessionId;
            const update = readObjectRecord(params.update);

            if (method === 'session/update' && update) {
                // Any progress update resets the prompt inactivity timeout so
                // long-running work can continue for hours without being
                // killed by a fixed cap.
                resetPromptInactivityTimeout();
                state.lastActivityAt = Date.now();

                const sessionUpdate = readOptionalString(update.sessionUpdate);
                const sid = sessionIdFromMsg || sessionId;

                if (sessionUpdate === 'agent_message_chunk') {
                    // Live: relay the chunk so the transcript grows while the
                    // model is still generating. The canonical copy comes from
                    // the CLI transcript when the run ends.
                    sendAssistantDelta(state, extractTextContent(update.content));
                    return;
                }
                else if (sessionUpdate === 'agent_thought_chunk') {
                    sendThoughtDelta(state, extractThoughtContent(update));
                    return;
                }
                else if (sessionUpdate === 'usage_update') {
                    const tokenBudget = tokenBudgetFromUsageUpdate(update);
                    if (tokenBudget) {
                        state.tokenBudget = tokenBudget;
                        state.currentWriter?.send(createNormalizedMessage({
                            kind: 'status',
                            text: 'token_budget',
                            tokenBudget,
                            sessionId: sid,
                            provider: 'commandcode',
                            timestamp: new Date().toISOString(),
                        }));
                    }
                }
                else if (sessionUpdate === 'tool_call') {
                    // The assistant message that introduced this call is done:
                    // close its live row before the tool rows so the order is
                    // preserved.
                    finalizeLiveMessages(state);
                    const toolName = readOptionalString(update.title) ?? 'Tool';
                    const toolId = readOptionalString(update.toolCallId) ?? `commandcode_tool_${nextRequestId()}`;
                    const toolInput = update.rawInput ?? {};
                    state.currentWriter?.send(createNormalizedMessage({
                        id: toolId,
                        kind: 'tool_use',
                        toolName,
                        toolId,
                        toolInput,
                        sessionId: state.commandCodeSessionId,
                        provider: 'commandcode',
                        timestamp: new Date().toISOString(),
                    }));
                }
                else if (sessionUpdate === 'tool_call_update') {
                    const contentBlocks = Array.isArray(update.content)
                        ? update.content.map((c: any) => extractTextContent(c.content ?? c)).filter(Boolean).join('\n')
                        : '';
                    const toolId = readOptionalString(update.toolCallId) ?? `commandcode_tool_${nextRequestId()}`;
                    const isError = update.status === 'failed';
                    state.currentWriter?.send(createNormalizedMessage({
                        id: `${toolId}__result`,
                        kind: 'tool_result',
                        toolId,
                        content: contentBlocks,
                        isError,
                        sessionId: state.commandCodeSessionId,
                        provider: 'commandcode',
                        timestamp: new Date().toISOString(),
                    }));
                }
                else if (sessionUpdate === 'session_info_update' && update.title !== undefined && update.title !== null) {
                    sessionsDb.updateSessionCustomName(state.appSessionId, String(update.title));
                }
                else if (sessionUpdate === 'config_option_update') {
                    // Keep the tracked model in step with what the ACP session
                    // actually runs, so a later turn only pushes a real change.
                    const activeModel = readModelConfigValue(update);
                    if (activeModel) {
                        state.model = activeModel;
                    }
                }
                return;
            }

            if (method === 'session/request_permission') {
                const requestId = String(msg.id);
                const acpOptions = Array.isArray(params.options) ? params.options : [];
                commandCodePendingPermissions.set(requestId, {
                    acpId: msg.id,
                    state,
                    appSessionId: state.appSessionId,
                    commandCodeSessionId: state.commandCodeSessionId,
                    params,
                });

                const mode = state.permissionMode || 'default';

                if (mode === 'bypassPermissions' || mode === 'bypass' || mode === 'yolo') {
                    resolveCommandCodePermission(requestId, { allow: true });
                    return;
                }

                if ((mode === 'acceptEdits' || mode === 'auto-accept' || mode === 'accept-edits') && isEditPermissionRequest(params)) {
                    resolveCommandCodePermission(requestId, { allow: true });
                    return;
                }

                state.currentWriter?.send(createNormalizedMessage({
                    kind: 'permission_request',
                    requestId,
                    toolName: readOptionalString(params.title) ?? 'Tool',
                    input: params.rawInput ?? {},
                    context: { options: acpOptions },
                    sessionId: state.commandCodeSessionId,
                    provider: 'commandcode',
                }));
            }
        };

        const rl = createInterface({
            input: child.stdout!,
            crlfDelay: Infinity,
        });

        rl.on('line', (line: any) => {
            if (!line.trim()) return;
            let msg;
            try {
                msg = JSON.parse(line);
            } catch {
                console.error('[CommandCode] Non-JSON stdout line:', line.slice(0, 200));
                return;
            }

            if (msg.id !== undefined && msg.method === undefined) {
                handleResponse(msg);
            } else if (msg.method) {
                handleNotification(msg);
            }
        });

        const onError = (error: any) => {
            if (state.terminated || state.completeSent) return;
            state.terminated = true;
            state.rejectPendingRequests('Command Code ACP process failed');
            state.completeSent = true;
            const streamError = createNormalizedMessage({
                kind: 'error',
                content: error instanceof Error ? error.message : String(error),
                sessionId: state.commandCodeSessionId || sessionId,
                provider: 'commandcode',
            });
            state.currentWriter?.send(streamError);
            state.currentWriter?.send(createCompleteMessage({
                provider: 'commandcode',
                sessionId,
                exitCode: 1,
            }));
            child.kill();
            if (activeCommandCodeProcesses.get(sessionId) === state) {
                activeCommandCodeProcesses.delete(sessionId);
            }
            clearCommandCodePendingForState(state);
        };

        child.on('error', (err: any) => onError(err));

        child.on('close', (code: any) => {
            // Pending ACP requests must be rejected even when this close
            // follows an abort/onError that already flagged `terminated` —
            // otherwise a run awaiting `session/prompt` hangs until the
            // inactivity timeout (and its queue row sits `sending` forever).
            const alreadySettled = state.terminated || state.completeSent;
            state.childExited = true;
            state.childExitCode = code;
            state.terminated = true;
            rejectQueuedPrompts(state, 'Command Code ACP process closed');
            state.rejectPendingRequests('Command Code ACP process closed');
            if (alreadySettled) return;
            if (activeCommandCodeProcesses.get(sessionId) === state) {
                activeCommandCodeProcesses.delete(sessionId);
            }
            clearCommandCodePendingForState(state);
        });

        (async () => {
            const initResult = await state.sendRequest('initialize', {
                protocolVersion: 1,
                clientCapabilities: {},
                clientInfo: { name: 'ddagent', version: '1.0.0' },
            });
            state.initialized = true;
            state.agentCapabilities = readObjectRecord(initResult?.agentCapabilities) ?? {};

            const mcpServers = await loadMcpConfig(workingDir, state.agentCapabilities, context);

            // Never use the app session id as a provider resume id; the
            // service layer already validates psid.
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
                } catch (error: any) {
                    throw new Error(`Command Code could not resume session "${resumeSessionId}": ${error instanceof Error ? error.message : String(error)}`);
                }
                if (!sessionResult) {
                    throw new Error('Command Code resume returned no session; refusing to lose conversation context');
                }
            }

            if (!sessionResult) {
                sessionResult = await state.sendRequest('session/new', { cwd: workingDir, mcpServers });
            }

            const commandCodeSessionId = readOptionalString(sessionResult?.sessionId) ?? resumeSessionId;
            if (!commandCodeSessionId) {
                throw new Error('ACP session did not return sessionId');
            }
            if (commandCodeSessionId === state.appSessionId) {
                throw new Error('Command Code returned an invalid session id identical to the app session id');
            }
            state.commandCodeSessionId = commandCodeSessionId;
            // The CLI writes the canonical v3 transcript itself; registering
            // its path on the session row lets fetchHistory and the watcher
            // find it without a ddagent-owned mirror.
            state.transcriptPath = path.join(
                commandCodeProjectsDir(),
                commandCodeProjectSlug(workingDir),
                `${commandCodeSessionId}.jsonl`,
            );
            sessionsDb.createSession(commandCodeSessionId, 'commandcode', workingDir, undefined, undefined, undefined, state.transcriptPath);

            // Merge the provider-native session row into the app-allocated row.
            if (state.appSessionId && state.appSessionId !== commandCodeSessionId) {
                sessionsDb.assignProviderSessionId(state.appSessionId, commandCodeSessionId);
            }

            // Sync the UI-selected permission mode + effort to the session.
            await applyPermissionModeToCommandCodeSession(state, permissionMode);
            await applyEffortToCommandCodeSession(state, effort);

            // The session's own model pick (reported through configOptions on
            // load/new) wins over the spawn default; without a report a resumed
            // session keeps whatever it was saved with and run() pushes the
            // composer's choice explicitly.
            const loadedModel = readModelConfigValue(sessionResult);
            if (loadedModel) {
                state.model = loadedModel;
            } else if (didLoad) {
                state.model = null;
            }

            if (typeof state.currentWriter?.setSessionId === 'function') {
                state.currentWriter.setSessionId(commandCodeSessionId);
            }

            state.currentWriter?.send(createNormalizedMessage({
                kind: 'session_created',
                newSessionId: commandCodeSessionId,
                sessionId: commandCodeSessionId,
                provider: 'commandcode',
            }));

            // If we reloaded an existing session under a different id, write
            // the transcript path back so follow-up turns find it.
            if (didLoad && resumeSessionId !== commandCodeSessionId) {
                sessionsDb.createSession(commandCodeSessionId, 'commandcode', workingDir, undefined, undefined, undefined, state.transcriptPath);
                if (state.appSessionId && state.appSessionId !== commandCodeSessionId) {
                    sessionsDb.assignProviderSessionId(state.appSessionId, commandCodeSessionId);
                }
            }

            resolve(state);
        })().catch((err: any) => {
            onError(err);
            reject(err);
        });
    });
}

// Consumed by the provider registry to execute ACP turns.
export async function queryCommandCode(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
    const { sessionId, projectPath, cwd, model, permissionMode, effort } = options;
    const workingDir = cwd || projectPath || process.cwd();
    let state: any;

    try {
        const installed = await context.isProviderInstalled();
        if (!installed) {
            throw new Error('Command Code CLI is not installed or not authenticated (install: `npm i -g command-code`, login: `command-code login`)');
        }

        const resolved = sessionId ? await context.resolveResumeModel(sessionId, model) : null;
        // An explicitly chosen model (session row or client) is pushed onto
        // the ACP session; the catalog fallback only ever seeds a new session.
        const requestedModel = resolved?.model || (typeof model === 'string' ? model.trim() : '') || null;

        const key = sessionId || `commandcode-${Date.now()}`;
        state = activeCommandCodeProcesses.get(key);
        // "Change workspace" repoints sessions.project_path between turns, but
        // the long-lived ACP child stays bound to the directory it spawned in.
        // A process rooted elsewhere is restarted so the next prompt runs in
        // the new workspace — session/load resumes the provider session there.
        if (state && !state.terminated && state.workingDir && path.resolve(state.workingDir) !== path.resolve(workingDir)) {
            try { await state.sendNotification('session/cancel', { sessionId: state.commandCodeSessionId }); } catch {}
            state.terminated = true;
            rejectQueuedPrompts(state, 'Command Code session moved to another workspace');
            try { state.child.kill(); } catch {}
            clearCommandCodePendingForState(state);
            activeCommandCodeProcesses.delete(key);
            state = null;
        }
        if (!state || state.terminated) {
            const providerSessionId = sessionId ? await context.resolveProviderSessionId(sessionId) : null;
            state = await createCommandCodeProcess(key, workingDir, requestedModel, ws, context, providerSessionId, permissionMode, effort, options.env);
            activeCommandCodeProcesses.set(key, state);
        } else if (state.busy) {
            // Prompt in flight — tell apart a healthy run from a deadlock.
            const lastActivity = state.lastActivityAt || state.promptStartedAt || 0;
            const stalled = Date.now() - lastActivity > STALL_THRESHOLD_MS;
            if (stalled) {
                try { await state.sendNotification('session/cancel', { sessionId: state.commandCodeSessionId }); } catch {}
                state.terminated = true;
                rejectQueuedPrompts(state, 'Command Code run stalled and was restarted');
                try { state.child.kill(); } catch {}
                activeCommandCodeProcesses.delete(key);
                const providerSessionId = sessionId ? await context.resolveProviderSessionId(sessionId) : null;
                state = await createCommandCodeProcess(key, workingDir, requestedModel, ws, context, providerSessionId, permissionMode, effort, options.env);
                activeCommandCodeProcesses.set(key, state);
            } else {
                // Healthy run — queue; it executes once the current prompt ends.
                await applyModelToCommandCodeSession(state, requestedModel);
                await applyEffortToCommandCodeSession(state, effort);
                await new Promise((resolve: any, reject: any) => {
                    (state.queue ??= []).push({ command, options, ws, resolve, reject });
                });
                return;
            }
        }
        await applyModelToCommandCodeSession(state, requestedModel);
        await applyEffortToCommandCodeSession(state, effort);
        await state.prompt(command, options, ws);
        // Drain the prompt queue waiting on this same session.
        while (state.queue && state.queue.length > 0 && !state.terminated) {
            const next = state.queue.shift();
            try {
                await state.prompt(next.command, next.options, next.ws);
                next.resolve?.();
            } catch (error: any) {
                const queueError = createNormalizedMessage({
                    kind: 'error',
                    content: error instanceof Error ? error.message : String(error),
                    sessionId: key,
                    provider: 'commandcode',
                });
                next.ws.send(queueError);
                next.ws.send(createCompleteMessage({
                    provider: 'commandcode',
                    sessionId: key,
                    exitCode: 1,
                }));
                state.completeSent = true;
                next.reject?.(error);
            }
        }
    } catch (error: any) {
        if (state?.completeSent) return;
        // Failures before a process state exists (provider not installed,
        // resume-id resolution, spawn rejection) reported nothing — let the
        // dispatcher surface them instead of returning a silent ok.
        if (!state) throw error;
        const writer = state.currentWriter ?? ws;
        const sid = sessionId || '';
        writer.send(createNormalizedMessage({
            kind: 'error',
            content: error instanceof Error ? error.message : String(error),
            sessionId: sid,
            provider: 'commandcode',
        }));
        writer.send(createCompleteMessage({
            provider: 'commandcode',
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
function rejectQueuedPrompts(state: any, reason: any) {
    for (const pending of state.queue ?? []) {
        try { pending.reject?.(new Error(reason)); } catch {}
    }
    state.queue = [];
}

// Consumed by the WebSocket runtime service to cancel an ACP turn.
export async function abortCommandCodeSession(sessionId: any) {
    const state = activeCommandCodeProcesses.get(sessionId);
    if (!state || state.terminated) return false;
    try {
        await state.sendNotification('session/cancel', { sessionId: state.commandCodeSessionId });
        state.aborted = true;
        state.terminated = true;
        state.rejectPendingRequests?.('Command Code session aborted');
        // Give the cancel frame a moment to flush before the process dies —
        // an instant kill can drop it and the session then keeps running the
        // turn the user just stopped.
        await new Promise((resolve: any) => setTimeout(resolve, 200));
        rejectQueuedPrompts(state, 'Command Code session aborted');
        try { state.child.kill(); } catch (error) { console.warn('ACP process cleanup failed:', error); }
        clearCommandCodePendingForState(state);
        if (activeCommandCodeProcesses.get(sessionId) === state) {
            activeCommandCodeProcesses.delete(sessionId);
        }
    } catch (error: any) {
        console.warn('[Command Code] Cancellation failed:', error);
        return false;
    }
    return true;
}

/**
 * Live permission-mode update consumed by provider-runtime.service for the
 * `chat.set-permission-mode` websocket message — pushes `session/set_mode`
 * onto the running ACP session instead of waiting for the next run start.
 */
function setPermissionMode(sessionId: any, mode: any) {
    const state = activeCommandCodeProcesses.get(sessionId)
        ?? activeCommandCodeProcesses.get(sessionId && sessionsDb.getSessionById(sessionId)?.provider_session_id);
    if (!state || state.terminated) return;
    state.permissionMode = mode;
    void applyPermissionModeToCommandCodeSession(state, mode);
}

// Consumed by the provider registry for run, Stop and permission controls.
export const commandCodeRuntime: IProviderRuntime = {
    run: queryCommandCode,
    abort: abortCommandCodeSession,
    permissions: {
        resolve: resolveCommandCodePermission,
        listPending: listCommandCodePendingPermissions,
    },
    setPermissionMode,
};



// Exported for tests: model/effort application on a resumed ACP session and
// the end-of-run final-message reconciliation (empty-turn detection).

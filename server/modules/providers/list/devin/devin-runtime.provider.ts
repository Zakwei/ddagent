import { randomUUID } from 'node:crypto';
import { createInterface } from 'node:readline';
import fs, { promises as fsAsync } from 'node:fs';
import path from 'node:path';

import crossSpawn from 'cross-spawn';

import type {
  AnyRecord,
  ProviderRuntimeWriter,
  IProviderRuntime,
} from '@/shared/index.js';
import {
  createCompleteMessage,
  createNormalizedMessage,
  foldAcpToolResultSnapshot,
  devinConfigDir,
  isDevinContinuationPrompt,
  isDevinSummaryArtifact,
  providerChildEnv,
  readJsonConfig,
  readObjectRecord,
  readOptionalString,
  readStringArray,
  readStringRecord,
  appendFilesInputTag,
  isAllowedImageSourcePath,
  isImageAttachmentDescriptor,
  normalizeAttachmentDescriptors,
  resolveImageAbsolutePath,
  resolveImageMediaType,
  toPosixPath,
} from '@/shared/index.js';

import { orchestratorMessagesDb, sessionsDb } from "../../../database/index.js";

import { DevinSessionsProvider } from './devin-sessions.provider.js';

const activeDevinProcesses = new Map<any, any>();
const devinPendingPermissions = new Map<any, any>();
let globalRequestId = 1;

const DEVIN_USER_MCP_CONFIG_PATH = path.join(devinConfigDir(), 'mcp_config.json');
const DEVIN_PROJECT_MCP_CONFIG_NAMES: any = ['mcp_config.json', 'mcp_config.local.json'];

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
const STDERR_TAIL_CHARS = 8192;
// The Devin DB can lag the ACP stream by a moment; poll it only briefly.
// With a streamed answer one quick look is enough to reconcile — the streamed
// text is persisted as the answer when the DB has not caught up yet.
const FINAL_FETCH_STREAMED = { maxRetries: 1, retryDelayMs: 300, scanLimit: null };
const FINAL_FETCH_SILENT = { maxRetries: 4, retryDelayMs: 400, scanLimit: null };
// Stop reasons after which the turn is resumed with CONTINUATION_PROMPT.
// `refusal` is deliberately absent: re-prompting a refusal only repeats it.
const CONTINUABLE_STOP_REASONS = new Set(['max_tokens', 'max_turn_requests']);
const STOP_REASON_NOTICES: Record<string, string> = {
    refusal: 'Devin stopped: the model refused the request.',
    max_tokens: 'Devin hit the output token limit (max_tokens).',
    max_turn_requests: 'Devin hit the per-turn request limit (max_turn_requests).',
};

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

function extractTextContent(content: any) {
    if (typeof content === 'string') return content;
    const record = readObjectRecord(content);
    if (record && typeof record.text === 'string') return record.text;
    return '';
}

/**
 * Renders ACP tool call content blocks as text for the tool result card:
 * `content` blocks as their text, `diff` blocks as a -/+ hunk under the file
 * path. `terminal` blocks carry only an id (DDAgent hosts no terminals), so
 * their output comes from `rawOutput` when no block produced text.
 * Exported for tests.
 */
export function acpToolContentText(update: any) {
    const blocks = Array.isArray(update?.content) ? update.content : [];
    const parts = blocks.map((block: any) => {
        if (block?.type === 'diff') {
            const lines = [`--- ${block.path ?? ''}`, `+++ ${block.path ?? ''}`];
            if (typeof block.oldText === 'string' && block.oldText) lines.push(...block.oldText.split('\n').map((line: string) => `-${line}`));
            if (typeof block.newText === 'string' && block.newText) lines.push(...block.newText.split('\n').map((line: string) => `+${line}`));
            return lines.join('\n');
        }
        return extractTextContent(block?.content ?? block);
    }).filter(Boolean);
    if (parts.length) return parts.join('\n');
    const raw = update?.rawOutput;
    if (typeof raw === 'string') return raw;
    const record = readObjectRecord(raw);
    return [record?.output, record?.stdout, record?.stderr].filter((value) => typeof value === 'string' && value).join('\n');
}

/**
 * Folds an ACP `diff` content block into an edit tool's input as
 * file_path/old_string/new_string — the fields the client's edit card renders —
 * unless the raw input already carries them.
 */
function withDiffInput(toolInput: any, update: any) {
    const diff = (Array.isArray(update?.content) ? update.content : []).find((block: any) => block?.type === 'diff');
    const input = readObjectRecord(toolInput) ?? {};
    if (!diff || 'old_string' in input || 'new_string' in input) return toolInput;
    return {
        ...input,
        file_path: input.file_path ?? diff.path,
        old_string: diff.oldText ?? '',
        new_string: diff.newText ?? '',
    };
}

function extractThoughtContent(update: any) {
    if (typeof update?.content === 'string') return update.content;
    if (typeof update?.thought === 'string') return update.thought;
    if (typeof update?.text === 'string') return update.text;
    return extractTextContent(update?.content);
}

function appendTranscript(jsonlPath: any, record: any) {
    if (!jsonlPath) return;
    try {
        fs.mkdirSync(path.dirname(jsonlPath), { recursive: true });
        fs.appendFileSync(jsonlPath, JSON.stringify(record) + '\n');
    } catch (error: any) {
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
        provider: 'devin',
        timestamp: new Date().toISOString(),
    });
}
function sendStreamEnd(writer: any, state: any) {
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
function sendThoughtDelta(state: any, text: any) {
    if (!text) return;
    state.thoughtBuffer += text;
    state.liveThoughtOpen = true;
    state.streamEnded = false;
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
function finalizeLiveMessages(state: any) {
    if (!state.liveStreamOpen && !state.liveThoughtOpen) return;
    state.liveStreamOpen = false;
    state.liveThoughtOpen = false;
    // Mark the boundary stream_end so the terminal sendStreamEnd does not
    // emit a duplicate right after this one.
    state.streamEnded = true;
    state.currentWriter?.send(createNormalizedMessage({
        kind: 'stream_end',
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    }));
}
/**
 * Persists the assistant message that just ended (narration before a tool call,
 * or the answer of an intermediate continuation round) to the DDAgent JSONL
 * transcript.
 *
 * The JSONL is what the client reloads as history, so without this the text the
 * user watched stream would disappear on the next refresh. The canonical final
 * answer is persisted separately from the Devin database, which keeps its node
 * id and is deduplicated against this row by content.
 */
function persistLiveAssistantMessage(state: any) {
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
 * Persists the reasoning that just ended to the DDAgent JSONL transcript so
 * the thinking blocks survive a history reload exactly as they streamed.
 */
function persistLiveThoughtMessage(state: any) {
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
/**
 * Persists a run-level error to the DDAgent JSONL transcript next to its live
 * broadcast, so the message survives a history reload instead of living only
 * in the websocket replay buffer (which is evicted). Failures before the ACP
 * session exists have no `jsonlPath` and stay live-only.
 */
function persistErrorMessage(state: any, message: any) {
    if (!state?.jsonlPath) return;
    appendTranscript(state.jsonlPath, message);
}
/**
 * Sends a persistent informational line (C1 notice: retry, stop reason, model
 * switch failure, ...) live and into the JSONL transcript so it survives a
 * history reload.
 */
function sendNotice(state: any, text: string) {
    const notice = createNormalizedMessage({
        kind: 'status',
        text,
        notice: true,
        sessionId: state.devinSessionId,
        provider: 'devin',
        timestamp: new Date().toISOString(),
    });
    state.currentWriter?.send?.(notice);
    appendTranscript(state.jsonlPath, notice);
}
/** Appends the child's stderr tail to an error message so crashes show their cause. */
function withStderrTail(message: string, state: any) {
    const tail = String(state?.stderrTail ?? '').trim();
    return tail && !message.includes(tail) ? `${message}\n${tail}` : message;
}
async function fetchLatestAssistantMessage(state: any, options: any = {}) {
    if (!state.appSessionId || !state.devinSessionId) return null;
    const maxRetries = options.maxRetries ?? FINAL_FETCH_SILENT.maxRetries;
    const retryDelayMs = options.retryDelayMs ?? FINAL_FETCH_SILENT.retryDelayMs;
    const scanLimit = options.scanLimit ?? null;
    for (let attempt = 0; attempt <= maxRetries; attempt += 1) {
        // Stop polling once the run is gone — abort/restart makes the fetch
        // pointless and it would keep the dispatcher blocked for a minute.
        if (state.terminated) return null;
        if (attempt > 0) {
            await new Promise((resolve: any) => setTimeout(resolve, retryDelayMs));
        }
        try {
            const sessionsProvider = new DevinSessionsProvider();
            // Read from the Devin DB, not the lagging DDAgent JSONL, and find
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
            let bestAssistant: any = null;
            let bestAfterPromptStart: any = null;
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
                const msgTs = Date.parse(msg.timestamp ?? '');
                // A DB that has not written this turn's prompt yet anchors on
                // the previous prompt; its final predates this run.
                if (lastUserIndex !== -1 && i > lastUserIndex && (Number.isNaN(msgTs) || msgTs >= state.promptStartedAt - 2000)) {
                    bestAssistant = { id: msg.id, content: trimmed };
                }
                // Post-compaction fallback: when a turn survives a context
                // compact, the real user prompt stays on the abandoned branch
                // and the new chain only carries a system-role summary node —
                // so no user anchor exists. Anchor on the prompt's send time
                // instead, which excludes finals from earlier turns.
                if (!Number.isNaN(msgTs) && msgTs >= state.promptStartedAt - 10000) {
                    bestAfterPromptStart = { id: msg.id, content: trimmed };
                }
            }
            // The timestamp fallback only applies when no user anchor exists
            // at all (post-compaction chains). With an anchor present, an
            // assistant message that is not after it belongs to an earlier
            // turn — returning it would replay a stale final and let an
            // empty turn report exitCode 0.
            const found = lastUserIndex !== -1 ? bestAssistant : bestAfterPromptStart;
            if (found) return found;
        } catch (error: any) {
            console.error('[Devin] Failed to fetch final assistant message:', error instanceof Error ? error.message : String(error));
        }
    }
    return null;
}
// Consumed by provider runtime services and lifecycle tests.
export async function sendFinalAssistantMessage(writer: any, state: any, options: any = {}) {
    if (!writer || !state.appSessionId || !state.devinSessionId) return false;
    const finalMsg = await fetchLatestAssistantMessage(state, options);
    if (state.terminated || !finalMsg || !finalMsg.content) return false;
    // The only candidate is the previous turn's final — the run produced no
    // new assistant message (an empty `end_turn`). Reporting success would
    // send exitCode 0 with nothing to show for the prompt.
    if (finalMsg.id === state.lastFinalAssistantId) return false;
    const streamedText = state.assistantBuffer;
    state.assistantBuffer = '';
    // A message that already streamed and was persisted at a tool boundary is
    // the same row this fetch would add: sending or appending it again would
    // duplicate it in the transcript and in the UI.
    if (state.persistedAssistantContents.has(finalMsg.content.trim())) {
        // The fetch found an earlier, already persisted segment while text
        // streamed after it (the Devin DB had not caught up yet). That newer
        // text is the turn's real answer — persist it instead of dropping it.
        if (streamedText.trim() && streamedText.trim() !== finalMsg.content.trim()) {
            state.assistantBuffer = streamedText;
            persistLiveAssistantMessage(state);
        }
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


/**
 * "Always" is offered only when the agent itself has an `allow_always`
 * option; its label rides along as the rule shown to the user. Resolving
 * with a truthy rememberEntry then selects that option.
 */
function acpRememberContext(options: any[]) {
    const always = options.find((option: any) => option?.kind === 'allow_always');
    return always ? { rememberEntry: readOptionalString(always.name) ?? 'Always allow' } : {};
}

/**
 * Extracts an `ask_user_question` ask out of ACP `session/request_permission`
 * params. The CLI forwards one ACP request per question: `toolCall.rawInput`
 * carries `{question, options: [labels]}` while `params.options[i]` mirrors
 * each label as `{optionId: 'option_i', name: 'label: description'}` — a
 * shape a regular tool-permission ask never has. Returns null for those.
 */
function readQuestionAsk(params: any) {
    const toolCall = readObjectRecord(params?.toolCall);
    const rawInput = readObjectRecord(toolCall?.rawInput ?? params?.rawInput);
    const question = readOptionalString(rawInput?.question);
    const labels = Array.isArray(rawInput?.options)
        ? rawInput.options.filter((option: any) => typeof option === 'string')
        : [];
    if (!question || labels.length === 0) return null;
    const acpOptions = Array.isArray(params?.options) ? params.options : [];
    const options = labels.map((label: string, index: number) => {
        const name = readOptionalString(acpOptions[index]?.name) ?? '';
        const description = name.startsWith(`${label}: `) ? name.slice(label.length + 2) : undefined;
        return { label, description };
    });
    const title = readOptionalString(toolCall?.title) ?? '';
    const header = title !== question && title.endsWith(`: ${question}`)
        ? title.slice(0, title.length - question.length - 2)
        : undefined;
    return {
        question,
        header: header || undefined,
        options,
        multiSelect: rawInput?.multiple === true || undefined,
    };
}

/**
 * Maps the interactive panel's answer map back onto the ACP optionId the CLI
 * expects. `updatedInput.answers` keys on the question text and carries the
 * chosen label(s); unmatched input (custom "Other" text, empty answers from
 * Skip) returns null so the caller answers `cancelled` instead of fabricating
 * a selection the user never made.
 *
 * The panel joins multi-select labels with ", ", so a value that equals a
 * whole label must be kept intact — the label itself can contain ", " (e.g.
 * "Nic nie zmieniam, tylko przegląd"), and splitting it would drop the
 * selection. Only non-label input ("Other" text, joined labels) is split.
 */
// Exported for tests: mapping a picked label onto the ACP optionId.
export function questionAnswerOptionId(params: any, updatedInput: any) {
    const ask = readQuestionAsk(params);
    if (!ask) return null;
    const answers = readObjectRecord(readObjectRecord(updatedInput)?.answers);
    const raw = answers?.[ask.question];
    const values = Array.isArray(raw) ? raw.map(String) : typeof raw === 'string' ? [raw] : [];
    const picked = new Set<string>();
    for (const value of values) {
        if (ask.options.some((option: any) => option.label === value)) {
            picked.add(value);
        } else {
            for (const part of value.split(', ')) {
                const trimmed = part.trim();
                if (trimmed) picked.add(trimmed);
            }
        }
    }
    // ACP answers with exactly one optionId. Picking just one of several
    // selections would silently drop the rest, so a multi-pick is cancelled
    // and the client relays the full selection as the next message.
    const pickedLabels = ask.options.filter((option: any) => picked.has(option.label));
    if (pickedLabels.length > 1) return null;
    const acpOptions = Array.isArray(params?.options) ? params.options : [];
    for (let i = 0; i < ask.options.length; i += 1) {
        if (picked.has(ask.options[i].label)) {
            const optionId = readOptionalString(acpOptions[i]?.optionId);
            if (optionId) return optionId;
        }
    }
    return null;
}

/**
 * Delegated (orchestrator-spawned) child sessions have no one watching their
 * transcript: a forwarded question would wait forever for an answer that
 * cannot come, so those keep the non-interactive resolve path.
 */
function isDelegatedChildSession(appSessionId: any) {
    try {
        return Boolean(appSessionId && orchestratorMessagesDb.findDelegationByChildSessionId(String(appSessionId)));
    } catch {
        return false;
    }
}

/**
 * The tool input a permission card shows (C4): ACP `toolCall.rawInput` plus
 * the call's `kind` and `locations`, which say what the agent wants to touch.
 */
function permissionRequestInput(params: any) {
    const toolCall = readObjectRecord(params?.toolCall);
    const rawInput = readObjectRecord(toolCall?.rawInput) ?? readObjectRecord(params?.rawInput) ?? {};
    return {
        ...(toolCall?.kind ? { kind: toolCall.kind } : {}),
        ...(Array.isArray(toolCall?.locations) && toolCall.locations.length ? { locations: toolCall.locations } : {}),
        ...rawInput,
    };
}

/**
 * Writes an answered question as an AskUserQuestion tool row (+ result) into
 * the JSONL, so the read-only recap still renders after a history reload —
 * the live permission card only exists in the realtime stream.
 */
function persistQuestionRecap(state: any, requestId: string, ask: any, answers: any) {
    const toolId = `${requestId}_recap`;
    const picked = answers ? Object.values(answers).map(String).filter(Boolean).join(', ') : '';
    appendTranscript(state?.jsonlPath, createNormalizedMessage({
        id: toolId,
        kind: 'tool_use',
        toolName: 'AskUserQuestion',
        toolId,
        toolInput: { questions: [ask], ...(answers ? { answers } : {}) },
        sessionId: state.appSessionId,
        provider: 'devin',
    }));
    appendTranscript(state?.jsonlPath, createNormalizedMessage({
        id: `${toolId}__result`,
        kind: 'tool_result',
        toolId,
        content: picked ? `User answered: ${picked}` : 'Skipped',
        isError: false,
        sessionId: state.appSessionId,
        provider: 'devin',
    }));
}

/** Writes one JSON-RPC frame to the ACP child, ignoring a closed pipe. */
function writeToChild(state: any, frame: any) {
    if (state?.child?.stdin?.writable && !state.child.stdin.destroyed) {
        state.child.stdin.write(JSON.stringify(frame) + '\n');
    }
}

function resolveDevinPermission(requestId: any, decision: any) {
    const pending = devinPendingPermissions.get(String(requestId));
    if (!pending) return;
    devinPendingPermissions.delete(String(requestId));

    // The ask was answered on one client — every other viewer still shows
    // the prompt, so drop it session-wide, not just on the answering device.
    // Carry the picked answers so those other windows render the answer
    // instead of falling back to "Skipped".
    const answers = readObjectRecord(readObjectRecord(decision?.updatedInput)?.answers);
    pending.state?.currentWriter?.send?.(createNormalizedMessage({
        kind: 'permission_cancelled',
        requestId: String(requestId),
        reason: 'resolved',
        sessionId: pending.devinSessionId,
        provider: 'devin',
        ...(answers ? { answers } : {}),
    }));

    const { params, state } = pending;
    const options = Array.isArray(params?.options) ? params.options : [];

    // ask_user_question asks pick an optionId by position — never by the
    // allow/deny kind heuristic below (every question option is 'allow_once',
    // so it always collapses onto the first option).
    const questionAsk = readQuestionAsk(params);
    if (questionAsk) {
        const selectedOptionId = decision?.allow
            ? questionAnswerOptionId(params, decision?.updatedInput)
            : null;
        persistQuestionRecap(state, requestId, questionAsk, answers);
        const response: any = {
            jsonrpc: '2.0',
            id: pending.acpId,
            result: {
                outcome: selectedOptionId
                    ? { outcome: 'selected', optionId: selectedOptionId }
                    : { outcome: 'cancelled' },
            },
        };
        writeToChild(state, response);
        return;
    }

    let selected;

    if (!decision?.allow) {
        // "Always deny" arrives as a deny carrying rememberEntry.
        selected = (decision?.rememberEntry ? options.find((o: any) => o.kind === 'reject_always') : undefined)
            ?? options.find((o: any) => o.kind === 'deny')
            ?? options.find((o: any) => o.kind === 'reject')
            ?? options.find((o: any) => o.kind === 'reject_once')
            ?? options.find((o: any) => o.kind === 'reject_always');
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

    // No matching option (a denial without reject options, or an empty
    // option list) is answered as cancelled — the agent must always get a
    // reply, and falling back to options[0] would usually pick `allow_once`.
    const response: any = {
        jsonrpc: '2.0',
        id: pending.acpId,
        result: {
            outcome: selected
                ? { outcome: 'selected', optionId: selected.optionId }
                : { outcome: 'cancelled' },
        },
    };

    writeToChild(state, response);
}

function clearDevinPendingForState(state: any) {
    for (const [requestId, pending] of devinPendingPermissions.entries()) {
        if (pending.state === state) {
            devinPendingPermissions.delete(requestId);
            // A live agent (turn died on error/timeout) still awaits a reply.
            writeToChild(state, { jsonrpc: '2.0', id: pending.acpId, result: { outcome: { outcome: 'cancelled' } } });
            // The owning process is gone — nothing will ever answer these.
            // Without the cancelled frame clients keep the ask rendered
            // forever (and replays resurrect it on reconnect).
            state?.currentWriter?.send?.(createNormalizedMessage({
                kind: 'permission_cancelled',
                requestId: String(requestId),
                reason: 'process-exited',
                sessionId: pending.devinSessionId,
                provider: 'devin',
            }));
        }
    }
}

function listDevinPendingPermissions(sessionId: any) {
    const result: any = [];
    for (const [requestId, pending] of devinPendingPermissions.entries()) {
        if (pending.appSessionId === sessionId) {
            const questionAsk = readQuestionAsk(pending.params);
            const toolCall = readObjectRecord(pending.params?.toolCall);
            result.push({
                requestId,
                toolName: questionAsk
                    ? 'AskUserQuestion'
                    : readOptionalString(toolCall?.title) ?? readOptionalString(pending.params?.title) ?? 'Tool',
                input: questionAsk
                    ? { questions: [questionAsk] }
                    : permissionRequestInput(pending.params),
                context: {
                    options: Array.isArray(pending.params.options) ? pending.params.options : [],
                    ...acpRememberContext(Array.isArray(pending.params.options) ? pending.params.options : []),
                },
                // The client filters pending asks by the app session id, so the
                // ack must carry that id — not the provider-native one (which
                // never leaves the backend). See chat-websocket.service.ts.
                sessionId,
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

async function loadMcpConfig(workingDir: any, agentCapabilities: any, context: any) {
    // Prefer a provider-scoped MCP lookup if the runtime context exposes one.
    if (typeof context?.getMcpConfig === 'function') {
        try {
            const merged: any = {};
            const scopes: any = ['user', 'local', 'project'];
            for (const scope of scopes) {
                const workspacePath = scope === 'user' ? undefined : workingDir;
                const result = await context.getMcpConfig(scope, workspacePath);
                Object.assign(merged, readObjectRecord(result?.mcpServers) ?? {});
            }
            return convertMcpServersToAcpList(merged, agentCapabilities);
        } catch (error: any) {
            console.warn('[Devin] context.getMcpConfig failed, falling back to file read:', error instanceof Error ? error.message : String(error));
        }
    }

    // Fall back to reading Devin MCP config files directly (mirrors DevinMcpProvider).
    const merged: any = {};
    try {
        const userConfig = await readJsonConfig(DEVIN_USER_MCP_CONFIG_PATH);
        Object.assign(merged, readObjectRecord(userConfig.mcpServers) ?? {});
    } catch (error: any) {
        console.warn('[Devin] Failed to read user MCP config:', error instanceof Error ? error.message : String(error));
    }

    for (const fileName of DEVIN_PROJECT_MCP_CONFIG_NAMES) {
        try {
            const projectConfig = await readJsonConfig(path.join(workingDir, '.devin', fileName));
            Object.assign(merged, readObjectRecord(projectConfig.mcpServers) ?? {});
        } catch (error: any) {
            console.warn(`[Devin] Failed to read project MCP config "${fileName}":`, error instanceof Error ? error.message : String(error));
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
                } catch (error: any) {
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
                } catch (error: any) {
                    console.warn(`[Devin] Failed to read image attachment ${descriptor.path}:`, error instanceof Error ? error.message : String(error));
                }
            }
        }
    }

    return blocks;
}

// Devin's ACP session modes (devin 3000.x) are accept-edits (the session
// default), smart, ask, plan and bypass — not its CLI `--permission-mode`
// values: set_mode "auto"/"dangerous" are not offered. No ACP mode asks before
// workspace edits, so DDAgent "default" maps to accept-edits (still asks for
// execs); mapping it to an unoffered id would leave a session stuck in
// smart/bypass after the user switches back to default.
const DEVIN_ACP_MODE_BY_PERMISSION_MODE: Record<string, string> = {
    default: 'accept-edits',
    auto: 'smart',
    acceptEdits: 'accept-edits',
    bypassPermissions: 'bypass',
    plan: 'plan',
};

// Mirrors the ACP-side mode (current id and the ids the session offers) from a
// session/new|load result (`modes`) or a configOptions payload into `state`.
function syncDevinModeState(state: any, source: any) {
    const modes = readObjectRecord(source?.modes);
    const modeOption = (Array.isArray(source?.configOptions) ? source.configOptions : [])
        .find((option: any) => option?.id === 'mode' || option?.category === 'mode');
    const current = readOptionalString(modes?.currentModeId) ?? readOptionalString(modeOption?.currentValue);
    if (current) state.currentModeId = current;
    const ids = (Array.isArray(modes?.availableModes) ? modes.availableModes.map((mode: any) => mode?.id)
        : Array.isArray(modeOption?.options) ? modeOption.options.map((entry: any) => entry?.value) : [])
        .filter((id: any) => typeof id === 'string' && id);
    if (ids.length) state.availableModeIds = ids;
}

/**
 * Pushes the DDAgent permission mode onto the ACP session via session/set_mode
 * so the agent-side approval policy matches the local auto-approval. Used at
 * spawn, before each prompt and for live mode changes (C5). A mode the
 * session does not offer, or a failed switch, is surfaced as a notice.
 * Consumed by lifecycle tests.
 */
export async function applyPermissionModeToDevinSession(state: any, mode: any) {
    const target = DEVIN_ACP_MODE_BY_PERMISSION_MODE[mode] ?? DEVIN_ACP_MODE_BY_PERMISSION_MODE.default;
    if (!state.devinSessionId || state.currentModeId === target) return;
    const available: string[] = state.availableModeIds ?? [];
    if (available.length && !available.includes(target)) {
        sendNotice(state, `Devin does not offer the "${target}" permission mode; still using ${state.currentModeId ?? 'its current mode'}.`);
        return;
    }
    try {
        await state.sendRequest('session/set_mode', { sessionId: state.devinSessionId, modeId: target });
        state.currentModeId = target;
    } catch (error: any) {
        sendNotice(state, `Could not switch Devin to the "${target}" permission mode: ${error instanceof Error ? error.message : String(error)}`);
    }
}

function readTaskMasterTasks(workingDir: any) {
    const filePath = path.join(workingDir, TASKMASTER_TASKS_JSON);
    if (!fs.existsSync(filePath)) return null;
    try {
        const data = JSON.parse(fs.readFileSync(filePath, 'utf8'));
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

// acceptEdits trusts only the ACP tool kind: titles are free text ("Shell: rm file.txt"),
// so a missing or other kind falls through to a real permission prompt.
export function isEditPermissionRequest(params: any) {
    const kind = readObjectRecord(params?.toolCall)?.kind;
    return kind === 'edit' || kind === 'delete' || kind === 'move';
}


// Devin tags every session/update emitted inside an agent context with
// _meta['cognition.ai/subagent_context'].parentAgentId: 'root' for the main
// agent and the child agentId for subagent-internal events (its tool calls,
// tool results and usage). Those events belong to the subagent's side chain —
// forwarding them renders the subagent's stream inside the main conversation.
function readSubagentOwnerId(update: any) {
    const ctx = update?._meta?.['cognition.ai/subagent_context'];
    const parentAgentId = readOptionalString(ctx?.parentAgentId) ?? readOptionalString(ctx?.parent);
    return parentAgentId && parentAgentId !== 'root' ? parentAgentId : null;
}

// Subagent lifecycle is reported as tool_call_update rows keyed by the child
// agentId carrying _meta['cognition.ai/subagent_started' | 'subagent_completed'].
function readSubagentLifecycle(update: any) {
    const meta = update?._meta;
    if (meta?.['cognition.ai/subagent_started']) {
        return { started: true, info: meta['cognition.ai/subagent_started'] };
    }
    if (meta?.['cognition.ai/subagent_completed']) {
        return { started: false, info: meta['cognition.ai/subagent_completed'] };
    }
    return null;
}

function hasUnresolvedSubagent(jsonlPath: any) {
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

// Mirrors the ACP-side config (running model, thought_level and the model
// values the session accepts) from a configOptions payload into `state`.
// Fields absent from the payload are left untouched.
function syncDevinConfigState(state: any, source: any) {
    const options = Array.isArray(source?.configOptions) ? source.configOptions : [];
    const modelOption = options.find((option: any) => option?.id === 'model' || option?.category === 'model');
    const levelOption = options.find((option: any) => option?.id === 'thought_level');
    const model = readOptionalString(modelOption?.currentValue);
    if (model) state.model = model;
    if (levelOption) state.thoughtLevel = readOptionalString(levelOption.currentValue) ?? null;
    const modelValues = (Array.isArray(modelOption?.options) ? modelOption.options : [])
        .map((entry: any) => readOptionalString(entry?.value))
        .filter(Boolean);
    if (modelValues.length) state.modelOptions = modelValues;
    return { model, levelOption };
}

// Catalog ids encode the thinking level as a suffix, optionally followed by
// the 1M-context marker (`glm-5-3-flash-low`, `glm-5-2-max-1m`).
const DEVIN_THOUGHT_LEVEL_SUFFIX = /^(.*)-(none|minimal|low|medium|high|xhigh|max)(-1m)?$/;

function splitDevinThoughtLevel(id: string) {
    const match = DEVIN_THOUGHT_LEVEL_SUFFIX.exec(id);
    return match ? { base: match[1] + (match[3] ?? ''), level: match[2] } : { base: id, level: null };
}

// `devin models list` (the composer catalog) lists one id per thinking level,
// but ACP exposes a single `model` value per family plus a separate
// `thought_level` option — `glm-5-3-flash-low` is `glm-5-3-flash-max` with
// thought_level `low`. Sending a catalog id ACP does not list is rejected with
// "Invalid params", so map it onto the family's ACP value + level instead.
// Without a known ACP model list the id is passed through unchanged.
// Consumed by lifecycle tests.
export function resolveDevinAcpModel(requested: string, acpModels: string[] = []) {
    const { base, level } = splitDevinThoughtLevel(requested);
    if (!acpModels.length || acpModels.includes(requested)) {
        return { model: requested, thoughtLevel: acpModels.length ? level : null };
    }
    const familyModel = acpModels.find((value) => splitDevinThoughtLevel(value).base === base);
    return familyModel ? { model: familyModel, thoughtLevel: level } : { model: requested, thoughtLevel: null };
}

// `devin acp --model` only sets the default for a NEW ACP session: a resumed
// session keeps the model it was saved with, and a live child keeps the model
// it was spawned with. Pushing the composer's selection explicitly is what
// makes a model change actually apply — otherwise a session created with e.g.
// SWE-2 Max keeps running it while the UI shows the newly picked model.
// `state.model`/`state.thoughtLevel` track what ACP reports it runs, so a turn
// only pushes a real change.
// Consumed by provider runtime services and lifecycle tests.
export async function applyModelToDevinSession(state: any, model: any) {
    if (!model) return;
    const target = resolveDevinAcpModel(String(model), state.modelOptions);
    if (state.model === target.model && (!target.thoughtLevel || state.thoughtLevel === target.thoughtLevel)) return;
    try {
        if (state.model !== target.model) {
            const applied = await state.sendRequest('session/set_config_option', {
                sessionId: state.devinSessionId,
                configId: 'model',
                value: target.model,
            });
            state.model = target.model;
            const { levelOption } = syncDevinConfigState(state, applied);
            // A result without a thought_level option means the new model
            // has none; only an absent payload leaves the levels unknown.
            const levels = levelOption
                ? (Array.isArray(levelOption.options) ? levelOption.options.map((entry: any) => entry?.value) : null)
                : (Array.isArray(applied?.configOptions) ? [] : null);
            if (target.thoughtLevel && levels && !levels.includes(target.thoughtLevel)) {
                sendNotice(state, `Model ${target.model} has no "${target.thoughtLevel}" thinking level; keeping ${state.thoughtLevel ?? 'the default'}.`);
                return;
            }
        }
        if (target.thoughtLevel && state.thoughtLevel !== target.thoughtLevel) {
            await state.sendRequest('session/set_config_option', {
                sessionId: state.devinSessionId,
                configId: 'thought_level',
                value: target.thoughtLevel,
            });
            state.thoughtLevel = target.thoughtLevel;
        }
    } catch (error: any) {
        console.warn('[Devin] Failed to apply the selected model to the session:', error instanceof Error ? error.message : error);
        sendNotice(state, `Could not switch model to ${model}; still using ${state.model ?? 'the current model'}.`);
    }
}

function createDevinProcess(sessionId: any, workingDir: any, model: any, ws: any, context: any, providerSessionId: any = null, permissionMode: any = 'default', extraEnv: any = null) {
    return new Promise((resolve: any, reject: any) => {
        const devinArgs: any = ['acp'];
        if (model) devinArgs.push('--model', String(model));

        // extraEnv carries multi-account overrides picked at session creation.
        const childEnv = providerChildEnv(extraEnv && typeof extraEnv === 'object' ? extraEnv : {});

        const child = crossSpawn('devin', devinArgs, {
            cwd: workingDir,
            stdio: ['pipe', 'pipe', 'pipe'],
            env: childEnv,
        });

        const pending = new Map<any, any>();
        const state: any = {
            child,
            devinSessionId: null,
            initialized: false,
            terminated: false,
            busy: false,
            currentWriter: ws,
            workingDir,
            model,
            // ACP-side `thought_level` and accepted `model` values, mirrored
            // from configOptions payloads (see syncDevinConfigState).
            thoughtLevel: null,
            modelOptions: [],
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
            // ACP-side permission mode, mirrored by syncDevinModeState.
            currentModeId: null,
            availableModeIds: [],
            // Last STDERR_TAIL_CHARS of the child's stderr, quoted in errors.
            stderrTail: '',
            // True while session/load replays history as session/update.
            loadingSession: false,
            // Tool calls started but not finished — a silent long tool is
            // not a stalled run.
            openToolCalls: new Set(),
            lastActivityAt: Date.now(),
        };

        // Drain stderr continuously: an unread pipe fills up and blocks the
        // child, and its tail is the only clue when the process dies.
        child.stderr?.on('data', (chunk: any) => {
            state.stderrTail = (state.stderrTail + String(chunk)).slice(-STDERR_TAIL_CHARS);
        });
        // A write racing the child's exit emits EPIPE on stdin; unhandled, it
        // would crash the server.
        child.stdin?.on('error', () => {});
        // Registered before init so Stop can cancel a process that is still
        // starting or loading its session.
        activeDevinProcesses.set(sessionId, state);

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
                return Promise.reject(new Error('Devin ACP session is terminated'));
            }
            const id = nextRequestId();
            const req: any = { jsonrpc: '2.0', id, method, params };
            sendCompact(req);
            return new Promise((res: any, rej: any) => {
                // session/prompt can trigger long tool chains (subagents,
                // reads, file edits). Use an inactivity timeout that resets
                // on every session/update, so multi-hour tasks are allowed
                // as long as the ACP process is still producing progress.
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
            state.turnToolCount = 0;
            state.openToolCalls.clear();
            state.promptStartedAt = Date.now();
            const promptText = Array.isArray(command) ? command.join('\n') : String(command);
            const autoContinue = options?.autoContinueTasks === true;
            const skipTranscript = options?.skipTranscript === true;
            const userTurn = options?.userTurnEcho ?? createUserTurnMessage(promptText, options, state.devinSessionId);
            if (!skipTranscript) {
                appendTranscript(state.jsonlPath, userTurn);
            }
            writer.send(userTurn);
            try {
                await applyPermissionModeToDevinSession(state, state.permissionMode);
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
                    if (stopReason === 'cancelled') break;
                    round += 1;
                    state.continuationRound = round;
                    unfinished = getTaskMasterUnfinishedCount(state.workingDir);
                    const tokenHigh = state.tokenBudget?.total > 0 && (state.tokenBudget.used / state.tokenBudget.total) > TASKMASTER_TOKEN_BUDGET_THRESHOLD;
                    const maxRounds = autoContinue && unfinished > 0 ? Math.min(unfinished + 5, MAX_TASKMASTER_CONINUATION_ROUNDS) : MAX_CONTINUATION_ROUNDS;
                    const shouldContinue = (CONTINUABLE_STOP_REASONS.has(stopReason) && round < maxRounds) || (stopReason === 'end_turn' && autoContinue && unfinished > 0 && round < maxRounds && !tokenHigh);
                    if (STOP_REASON_NOTICES[stopReason]) {
                        // Close the streamed row first so the notice lands after it.
                        finalizeLiveMessages(state);
                        persistLiveThoughtMessage(state);
                        persistLiveAssistantMessage(state);
                        sendNotice(state, STOP_REASON_NOTICES[stopReason] + (shouldContinue ? ' Continuing automatically.' : ''));
                    }
                    if (!shouldContinue) break;
                    // Another round follows: close and persist this round's
                    // streamed message so the next one starts a fresh row.
                    finalizeLiveMessages(state);
                    persistLiveThoughtMessage(state);
                    persistLiveAssistantMessage(state);
                }
                if (stopReason === 'cancelled') {
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
                // ACP answers session/prompt after the turn's last update, so
                // only a still-running subagent is worth waiting for.
                state.finalizing = true;
                const subMaxWaitMs = 15 * 60 * 1000;
                const subStart = Date.now();
                let subLastSeen = Date.now();
                while (Date.now() - subStart < subMaxWaitMs && !state.terminated) {
                    if (state.activeSubagentIds.size === 0 && !hasUnresolvedSubagent(state.jsonlPath)) break;
                    await new Promise((resolve: any) => setTimeout(resolve, 500));
                    if (state.lastActivityAt > subLastSeen) {
                        subLastSeen = state.lastActivityAt;
                        continue;
                    }
                    if (Date.now() - subLastSeen >= 150000) break;
                }
                // The final reasoning belongs above the final answer in history.
                persistLiveThoughtMessage(state);
                if (state.terminated) throw new Error('Devin session terminated');
                const streamedAnswer = state.assistantBuffer.trim();
                const finalFound = await sendFinalAssistantMessage(writer, state, streamedAnswer ? FINAL_FETCH_STREAMED : FINAL_FETCH_SILENT);
                if (state.terminated) throw new Error('Devin session terminated');
                // The Devin DB has not caught up: the streamed text is the answer.
                if (!finalFound) persistLiveAssistantMessage(state);
                finalizeLiveMessages(state);
                sendStreamEnd(writer, state);
                // A tool-only turn is a real result; only a turn with no
                // output at all is an error.
                const producedOutput = finalFound || Boolean(streamedAnswer) || state.persistedAssistantContents.size > 0 || state.turnToolCount > 0;
                if (!producedOutput) {
                    const finalError = createNormalizedMessage({
                        kind: 'error',
                        content: `Devin finished without producing any output (stopReason: ${stopReason}).`,
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                    });
                    persistErrorMessage(state, finalError);
                    writer.send(finalError);
                }
                writer.send(createCompleteMessage({
                    provider: 'devin',
                    sessionId: state.devinSessionId,
                    exitCode: producedOutput ? 0 : 1,
                }));
                state.completeSent = true;
            } catch (error: any) {
                // The turn is dead (ACP error or inactivity timeout): cancel its
                // asks so a paired question the user still sees cannot outlive it.
                clearDevinPendingForState(state);
                // Close the open live rows and persist whatever streamed
                // before the failure — same treatment as the cancelled path,
                // otherwise the partial answer vanishes on a history reload.
                finalizeLiveMessages(state);
                persistLiveThoughtMessage(state);
                persistLiveAssistantMessage(state);
                if (!state.completeSent && !state.aborted) {
                    const runError = createNormalizedMessage({
                        kind: 'error',
                        content: error instanceof Error ? error.message : String(error),
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                    });
                    persistErrorMessage(state, runError);
                    writer.send(runError);
                    writer.send(createCompleteMessage({
                        provider: 'devin',
                        sessionId: state.devinSessionId,
                        // A failed turn never reports success, even when the
                        // child exited 0.
                        exitCode: state.childExited && state.childExitCode ? state.childExitCode : 1,
                    }));
                    state.completeSent = true;
                }
            } finally {
                // Held through finalization so a concurrent prompt queues
                // instead of overlapping this turn's end.
                state.busy = false;
                state.finalizing = false;
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
                // rate limiting through them, and the bare message text is
                // all upstream callers would otherwise have to classify on.
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

                const sessionUpdate = readOptionalString(update.sessionUpdate);
                const sid = sessionIdFromMsg || sessionId;

                if (sessionUpdate === 'current_mode_update') {
                    state.currentModeId = readOptionalString(update.currentModeId) ?? readOptionalString(update.modeId) ?? state.currentModeId;
                    return;
                }
                if (sessionUpdate === 'config_option_update') {
                    // Keep the tracked model/mode in step with what the ACP
                    // session actually runs, so a later turn only pushes a
                    // real change.
                    syncDevinConfigState(state, update);
                    syncDevinModeState(state, update);
                    return;
                }
                // session/load replays the stored history as session/update
                // notifications; it is already in the transcript and must not
                // stream into the new run as live rows.
                if (state.loadingSession) return;

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
                else if (sessionUpdate === 'plan') {
                    // ACP plan entries ({content, status, priority}) map onto the
                    // TodoWrite card the client renders for todo lists.
                    finalizeLiveMessages(state);
                    persistLiveThoughtMessage(state);
                    persistLiveAssistantMessage(state);
                    const entries = Array.isArray(update.entries) ? update.entries : [];
                    const toolId = `devin_plan_${randomUUID()}`;
                    const planMessages = [
                        createNormalizedMessage({
                            id: toolId,
                            kind: 'tool_use',
                            toolName: 'TodoWrite',
                            toolId,
                            toolInput: {
                                todos: entries.map((entry: any) => ({
                                    content: readOptionalString(entry?.content) ?? '',
                                    status: readOptionalString(entry?.status) ?? 'pending',
                                })),
                            },
                            sessionId: state.devinSessionId,
                            provider: 'devin',
                        }),
                        createNormalizedMessage({
                            id: `${toolId}__result`,
                            kind: 'tool_result',
                            toolId,
                            content: 'Plan updated',
                            isError: false,
                            sessionId: state.devinSessionId,
                            provider: 'devin',
                        }),
                    ];
                    for (const planMessage of planMessages) {
                        appendTranscript(state.jsonlPath, planMessage);
                        state.currentWriter?.send(planMessage);
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
                    const toolInput = withDiffInput(update.rawInput ?? {}, update);
                    state.turnToolCount = (state.turnToolCount ?? 0) + 1;
                    if (update.status !== 'completed' && update.status !== 'failed') state.openToolCalls.add(toolId);
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
                    const contentBlocks = acpToolContentText(update);
                    const toolId = readOptionalString(update.toolCallId) ?? `devin_tool_${nextRequestId()}`;
                    // An empty in-progress update carries nothing yet; as a
                    // tool_result it would flip the card to Completed.
                    const terminal = update.status === 'completed' || update.status === 'failed';
                    if (terminal) state.openToolCalls.delete(toolId);
                    if (!terminal && !contentBlocks.trim() && !state.toolResultSnapshots?.has(toolId)) return;
                    // Every snapshot shares one id, so emit the folded state
                    // of the call rather than this (often empty) update.
                    const folded = foldAcpToolResultSnapshot(
                        (state.toolResultSnapshots ??= new Map()),
                        toolId,
                        contentBlocks,
                        update.status === 'failed',
                    );
                    const toolResultMessage = createNormalizedMessage({
                        id: `${toolId}__result`,
                        kind: 'tool_result',
                        toolId,
                        content: folded.content,
                        isError: folded.isError,
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
                return;
            }

            if (method === 'session/request_permission') {
                // msg.id is the agent's own JSON-RPC counter — every ACP
                // child numbers from the same start, so it is not unique
                // across sessions. Pending asks live in one module-wide map
                // and the client keys cards by requestId; the JSON-RPC id
                // is kept as acpId for the reply.
                const requestId = `devin-perm-${randomUUID()}`;
                const acpOptions = Array.isArray(params.options) ? params.options : [];
                devinPendingPermissions.set(requestId, {
                    acpId: msg.id,
                    state,
                    appSessionId: state.appSessionId,
                    devinSessionId: state.devinSessionId,
                    params,
                });

                const mode = state.permissionMode || 'default';

                // ask_user_question is user input, not a tool permission:
                // bypass auto-approvals must not answer for the user. Only
                // headless delegated children resolve without the UI — there
                // is no one to render the panel to.
                const questionAsk = readQuestionAsk(params);
                if (questionAsk) {
                    if (isDelegatedChildSession(state.appSessionId)) {
                        resolveDevinPermission(requestId, { allow: false });
                        return;
                    }
                    state.currentWriter?.send(createNormalizedMessage({
                        kind: 'permission_request',
                        requestId,
                        toolName: 'AskUserQuestion',
                        input: { questions: [questionAsk] },
                        sessionId: state.devinSessionId,
                        provider: 'devin',
                    }));
                    return;
                }

                if (mode === 'bypassPermissions') {
                    resolveDevinPermission(requestId, { allow: true });
                    return;
                }

                if (mode === 'acceptEdits' && isEditPermissionRequest(params)) {
                    resolveDevinPermission(requestId, { allow: true });
                    return;
                }

                const toolCall = readObjectRecord(params.toolCall);
                state.currentWriter?.send(createNormalizedMessage({
                    kind: 'permission_request',
                    requestId,
                    toolName: readOptionalString(toolCall?.title) ?? readOptionalString(params.title) ?? 'Tool',
                    input: permissionRequestInput(params),
                    context: { options: acpOptions, ...acpRememberContext(acpOptions) },
                    sessionId: state.devinSessionId,
                    provider: 'devin',
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
                console.error('[Devin] Non-JSON stdout line:', line.slice(0, 200));
                return;
            }

            // Any agent traffic proves the run is alive (stall heuristic).
            state.lastActivityAt = Date.now();
            if (msg.id !== undefined && msg.method === undefined) {
                handleResponse(msg);
            } else if (msg.method) {
                if (msg.id !== undefined && msg.method !== 'session/request_permission') {
                    // An agent→client request this client does not implement
                    // still needs a reply, or the agent waits forever.
                    sendCompact({ jsonrpc: '2.0', id: msg.id, error: { code: -32601, message: `Method not found: ${msg.method}` } });
                    return;
                }
                if (msg.id !== undefined && (state.terminated || state.completeSent)) {
                    // No turn is left to show the ask: answer it cancelled.
                    sendCompact({ jsonrpc: '2.0', id: msg.id, result: { outcome: { outcome: 'cancelled' } } });
                    return;
                }
                handleNotification(msg);
            }
        });

        const onError = (error: any) => {
            // `terminated` alone is no reason to stay silent: a crash during
            // init flags it from the close handler before init rejects here.
            // Stop (aborted) has its own terminal frame.
            if (state.completeSent || state.aborted) return;
            state.terminated = true;
            state.rejectPendingRequests('Devin ACP process failed');
            state.completeSent = true;
            const message = error instanceof Error ? error.message : String(error);
            const streamError = createNormalizedMessage({
                kind: 'error',
                content: withStderrTail(message, state),
                sessionId: state.devinSessionId || sessionId,
                provider: 'devin',
            });
            persistErrorMessage(state, streamError);
            state.currentWriter?.send(streamError);
            state.currentWriter?.send(createCompleteMessage({
                provider: 'devin',
                sessionId,
                exitCode: 1,
            }));
            child.kill();
            if (activeDevinProcesses.get(sessionId) === state) {
                activeDevinProcesses.delete(sessionId);
            }
            clearDevinPendingForState(state);
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
            const reason = withStderrTail(`Devin ACP process closed (exit code ${code ?? 'unknown'})`, state);
            rejectQueuedPrompts(state, reason);
            state.rejectPendingRequests(reason);
            if (alreadySettled) return;
            if (activeDevinProcesses.get(sessionId) === state) {
                activeDevinProcesses.delete(sessionId);
            }
            clearDevinPendingForState(state);
        });

        // Settles (never rejects) once init finished either way, so a prompt
        // that arrives while the process is starting can wait for it.
        state.initPromise = (async () => {
            const initResult = await state.sendRequest('initialize', {
                protocolVersion: 1,
                clientCapabilities: {},
                clientInfo: { name: 'ddagent-devin', version: '1.0.0' },
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
                // Devin advertises no session/resume (sessionCapabilities only
                // has list/delete), so session/load it is — with its history
                // replay suppressed in handleNotification.
                state.loadingSession = true;
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
                    throw new Error(`Devin could not resume session "${resumeSessionId}": ${error instanceof Error ? error.message : String(error)}`);
                } finally {
                    state.loadingSession = false;
                }
                if (!sessionResult) {
                    throw new Error('Devin resume returned no session; refusing to lose conversation context');
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
            sessionsDb.createSession(devinSessionId, 'devin', workingDir, undefined, undefined, undefined, state.jsonlPath);

            // Merge the devin-native transcript row into the original app-allocated row.
            if (state.appSessionId && state.appSessionId !== devinSessionId) {
                sessionsDb.assignProviderSessionId(state.appSessionId, devinSessionId);
            }

            // Sync the UI-selected permission mode to the Devin ACP session —
            // always, so a resumed session saved in another mode is reset.
            syncDevinModeState(state, sessionResult);
            await applyPermissionModeToDevinSession(state, permissionMode);

            // `--model` only picks the model for a new ACP session; a resumed
            // session keeps its saved model (announced through the load result
            // or a config_option_update). Track what the session actually runs
            // so run() only pushes a model the user really chose.
            const { model: loadedModel } = syncDevinConfigState(state, sessionResult);
            if (!loadedModel && didLoad) {
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
                sessionsDb.createSession(devinSessionId, 'devin', workingDir, undefined, undefined, undefined, state.jsonlPath);
                if (state.appSessionId && state.appSessionId !== devinSessionId) {
                    sessionsDb.assignProviderSessionId(state.appSessionId, devinSessionId);
                }
            }

            resolve(state);
        })().catch((err: any) => {
            onError(err);
            // onError (or Stop) already told the client; queryDevin must not
            // report it a second time.
            if (err && typeof err === 'object') err.reportedToClient = true;
            reject(err);
        });
    });
}

// Consumed by the provider registry to execute ACP turns.
export async function queryDevin(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
    const { sessionId, projectPath, cwd, model, permissionMode } = options;
    const workingDir = cwd || projectPath || process.cwd();
    let state: any;

    try {
        const installed = await context.isProviderInstalled();
        if (!installed) {
            throw new Error('Devin CLI is not installed or not authenticated');
        }

        const resolved = sessionId ? await context.resolveResumeModel(sessionId, model) : null;
        // An explicitly chosen model (session row or client) is pushed onto the
        // ACP session; the catalog fallback only ever seeds a new session.
        const requestedModel = resolved?.model || (typeof model === 'string' ? model.trim() : '') || null;
        // Compound SWE-2 ids are not valid `devin acp --model` values either —
        // spawn with the base model and let applyModelToDevinSession push the
        // thought_level part through session/set_config_option.
        const modelArg = /^swe-2-(medium|high|max)$/.test(requestedModel ?? '')
            ? 'swe-2-high'
            : (requestedModel || 'swe-1-7');

        const key = sessionId || `devin-${Date.now()}`;
        state = activeDevinProcesses.get(key);
        // Still starting for an earlier prompt: wait for it instead of
        // spawning a second process (or prompting one without a session).
        if (state && !state.devinSessionId && !state.terminated) {
            await state.initPromise;
            state = activeDevinProcesses.get(key);
        }
        // "Change workspace" repoints sessions.project_path between turns, but
        // the long-lived ACP child stays bound to the directory it spawned in.
        // A process rooted elsewhere is restarted so the next prompt runs in
        // the new workspace — session/load resumes the provider session there.
        if (state && !state.terminated && state.workingDir && path.resolve(state.workingDir) !== path.resolve(workingDir)) {
            try { await state.sendNotification('session/cancel', { sessionId: state.devinSessionId }); } catch {}
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
            // Waiting on the user (pending ask), a long silent tool or the
            // end-of-turn subagent wait is not a deadlock.
            const waitingLegitimately = state.finalizing
                || state.openToolCalls.size > 0
                || [...devinPendingPermissions.values()].some((pending: any) => pending.state === state);
            const stalled = !waitingLegitimately && Date.now() - lastActivity > STALL_THRESHOLD_MS;
            if (stalled) {
                // Zawieszony run (np. współbieżne prompty): zabij i wystartuj świeży.
                try { await state.sendNotification('session/cancel', { sessionId: state.devinSessionId }); } catch {}
                state.terminated = true;
                // The old process is gone; cancel its asks so they don't linger
                // in the map (listPending would resurface a dead, unanswerable
                // prompt on the next subscribe).
                clearDevinPendingForState(state);
                rejectQueuedPrompts(state, 'Devin run stalled and was restarted');
                try { state.child.kill(); } catch {}
                activeDevinProcesses.delete(key);
                const providerSessionId = sessionId ? await context.resolveProviderSessionId(sessionId) : null;
                state = await createDevinProcess(key, workingDir, modelArg, ws, context, providerSessionId, permissionMode, options.env);
                activeDevinProcesses.set(key, state);
            } else {
                // Zdrowy run — kolejkuj; wykona się po zakończeniu bieżącego promptu.
                await applyModelToDevinSession(state, requestedModel);
                const queuedUserTurn = createUserTurnMessage(String(command), options, state.devinSessionId);
                appendTranscript(state.jsonlPath, queuedUserTurn);
                // Resolve only once this prompt has actually run: returning
                // early would let the server queue mark its row `sent` while
                // the message still sits in this in-memory queue — and it
                // dies silently if the process is killed before draining.
                await new Promise((resolve: any, reject: any) => {
                    // skipTranscript + userTurnEcho keep the drain from
                    // appending and broadcasting a second user turn under a
                    // fresh id — the persisted row and the echo must share it.
                    (state.queue ??= []).push({ command, options: { ...(options ?? {}), skipTranscript: true, userTurnEcho: queuedUserTurn }, ws, resolve, reject });
                });
                return;
            }
        }
        // `devin acp --model` only sets the model for a new ACP session: a
        // resumed session keeps its saved model and a live child keeps the one
        // it was spawned with. Push the chosen model so a switch in the
        // composer actually applies to this turn.
        state.currentWriter = ws;
        await applyModelToDevinSession(state, requestedModel);
        await state.prompt(command, options, ws);
        // Opróżnij kolejkę promptów oczekujących na tej samej sesji.
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
                    provider: 'devin',
                });
                persistErrorMessage(state, queueError);
                next.ws.send(queueError);
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
    } catch (error: any) {
        if (state?.completeSent || error?.reportedToClient) return;
        // Failures before a process state exists (provider not installed,
        // resume-id resolution, spawn rejection) reported nothing to anyone —
        // let the dispatcher surface them instead of returning a silent ok.
        if (!state) throw error;
        const writer = state.currentWriter ?? ws;
        const sid = sessionId || '';
        const outerError = createNormalizedMessage({
            kind: 'error',
            content: error instanceof Error ? error.message : String(error),
            sessionId: sid,
            provider: 'devin',
        });
        persistErrorMessage(state, outerError);
        writer.send(outerError);
        writer.send(createCompleteMessage({
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
function rejectQueuedPrompts(state: any, reason: any) {
    for (const pending of state.queue ?? []) {
        try { pending.reject?.(new Error(reason)); } catch {}
    }
    state.queue = [];
}

// Consumed by the WebSocket runtime service to cancel an ACP turn.
export async function abortDevinSession(sessionId: any) {
    const state = activeDevinProcesses.get(sessionId);
    if (!state || state.terminated) return false;
    try {
        // A process still starting has no ACP session to cancel yet — it is
        // simply killed below.
        if (state.devinSessionId) {
            await state.sendNotification('session/cancel', { sessionId: state.devinSessionId });
        }
        state.aborted = true;
        state.terminated = true;
        state.rejectPendingRequests?.('Devin session aborted');
        // Give the cancel frame a moment to flush before the process dies —
        // an instant kill can drop it, and the cloud session then keeps
        // running the turn the user just stopped.
        if (state.devinSessionId) await new Promise((resolve: any) => setTimeout(resolve, 200));
        rejectQueuedPrompts(state, 'Devin session aborted');
        try { state.child.kill(); } catch (error) { console.warn('ACP process cleanup failed:', error); }
        clearDevinPendingForState(state);
        if (activeDevinProcesses.get(sessionId) === state) {
            activeDevinProcesses.delete(sessionId);
        }
    } catch (error: any) {
        console.warn('[Devin] Cancellation failed:', error);
        return false;
    }
    return true;
}

/**
 * Live permission-mode change (C5), consumed by provider-runtime.service for
 * `chat.set-permission-mode`: updates the local auto-approval policy and pushes
 * session/set_mode onto the running ACP session.
 */
function setDevinPermissionMode(sessionId: string, mode: string) {
    const state = activeDevinProcesses.get(sessionId)
        ?? activeDevinProcesses.get(sessionId && sessionsDb.getSessionById(sessionId)?.provider_session_id);
    if (!state || state.terminated) return;
    state.permissionMode = mode;
    void applyPermissionModeToDevinSession(state, mode);
    // Asks already waiting fall under the new mode too.
    for (const [requestId, pending] of [...devinPendingPermissions.entries()]) {
        if (pending.state !== state || readQuestionAsk(pending.params)) continue;
        if (mode === 'bypassPermissions' || (mode === 'acceptEdits' && isEditPermissionRequest(pending.params))) {
            resolveDevinPermission(requestId, { allow: true });
        }
    }
}

// Consumed by the provider registry for run, Stop and permission controls.
export const devinRuntime: IProviderRuntime = {
    run: queryDevin,
    abort: abortDevinSession,
    permissions: {
        resolve: resolveDevinPermission,
        listPending: listDevinPendingPermissions,
    },
    setPermissionMode: setDevinPermissionMode,
};



// Exported for tests: the model handshake against a resumed ACP session and
// the end-of-run final-message reconciliation (empty-turn detection).

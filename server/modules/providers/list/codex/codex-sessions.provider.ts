import fsSync from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import readline from 'node:readline';

import { sessionsDb } from '@/modules/database/index.js';
import { parseFilesInputTag, toImageAttachments } from '@/shared/image-attachments.js';
import type { IProviderSessions } from '@/shared/interfaces.js';
import type { AnyRecord, FetchHistoryOptions, FetchHistoryResult, NormalizedMessage } from '@/shared/types.js';
import { AppError, createNormalizedMessage, generateMessageId, readObjectRecord, sliceTailPage } from '@/shared/utils.js';

const PROVIDER = 'codex';

type CodexHistoryResult =
  | AnyRecord[]
  | {
      messages?: AnyRecord[];
      total?: number;
      hasMore?: boolean;
      offset?: number;
      limit?: number | null;
      tokenUsage?: unknown;
    };

function isVisibleCodexUserMessage(payload: AnyRecord | null | undefined): boolean {
  if (!payload || payload.type !== 'user_message') {
    return false;
  }

  if (payload.kind && payload.kind !== 'plain') {
    return false;
  }

  return typeof payload.message === 'string' && payload.message.trim().length > 0;
}

// Context Codex injects as `role: user` response items (AGENTS.md, skills,
// environment) — never typed by the user.
const CODEX_INJECTED_USER_PREFIXES = [
  '<environment_context>',
  '<cwd>',
  '<user_instructions>',
  '<INSTRUCTIONS>',
  '<permissions instructions>',
  '<skill>',
  '<turn_aborted>',
  '# AGENTS.md instructions',
];

const UNIFIED_RULES_BLOCK = /^\s*<unified-rules>[\s\S]*?<\/unified-rules>\s*/;

function isInjectedCodexUserText(text: string): boolean {
  // The first prompt carries DDAgent's <unified-rules> prefix; only a prompt
  // that is nothing but that block is injected context.
  const normalized = text.replace(UNIFIED_RULES_BLOCK, '').trimStart();
  return !normalized || CODEX_INJECTED_USER_PREFIXES.some((prefix) => normalized.startsWith(prefix));
}

/**
 * Reads one user prompt from a rollout line. codex-cli <= 0.146 writes
 * `event_msg/user_message`; 0.160 writes `event_msg/item_completed` with a
 * `UserMessage` item. Both are the clean "typed by the user" channel
 * (`primary`). `response_item/message role=user` repeats each prompt next to
 * injected context, so it is only a `fallback` for rollouts with neither.
 *
 * Exported for tests.
 */
export function readCodexUserPrompt(
  entry: AnyRecord,
): { source: 'primary' | 'fallback'; text: string; images?: Array<{ path?: string; data?: string }> } | null {
  const payload = readObjectRecord(entry.payload);
  if (!payload) {
    return null;
  }

  if (entry.type === 'event_msg' && isVisibleCodexUserMessage(payload)) {
    return { source: 'primary', text: payload.message, images: extractCodexUserImages(payload) };
  }

  if (entry.type === 'event_msg' && payload.type === 'item_completed' && payload.item?.type === 'UserMessage') {
    const parts: AnyRecord[] = Array.isArray(payload.item.content) ? payload.item.content : [];
    const text = extractCodexTextContent(parts);
    const images = extractCodexUserImages({
      local_images: parts.filter((part) => part?.type === 'local_image').map((part) => part.path),
      images: parts.filter((part) => part?.type === 'image').map((part) => part.image_url ?? part.url),
    });
    if ((!text.trim() && !images) || isInjectedCodexUserText(text)) {
      return null;
    }
    return { source: 'primary', text, images };
  }

  if (entry.type === 'response_item' && payload.type === 'message' && payload.role === 'user') {
    const text = extractCodexTextContent(payload.content);
    if (!text.trim() || isInjectedCodexUserText(text)) {
      return null;
    }
    return { source: 'fallback', text };
  }

  return null;
}

/**
 * Maps Codex plan/todo items onto the client's `TodoWrite` todo shape.
 * Accepts the live SDK `todo_list` items (`{text, completed}`) and the
 * rollout `update_plan` steps (`{step, status}`).
 *
 * Exported for the Codex runtime (live todo snapshots) and tests.
 */
export function toCodexTodos(items: unknown): Array<{ content: string; status: string }> {
  if (!Array.isArray(items)) {
    return [];
  }
  return items.map((item: AnyRecord) => {
    const status = item?.status === 'completed' || item?.status === 'in_progress'
      ? item.status
      : item?.completed === true ? 'completed' : 'pending';
    return { content: String(item?.text ?? item?.step ?? item?.content ?? ''), status };
  });
}

// Every string literal assigned to `key:` inside an exec script.
function extractCodexScriptStrings(source: string, key: string): string[] {
  const pattern = new RegExp(
    `\\b${key}\\s*:\\s*("(?:\\\\.|[^"\\\\])*"|'(?:\\\\.|[^'\\\\])*'|\`(?:\\\\.|[^\`\\\\])*\`)`,
    'g',
  );
  return [...source.matchAll(pattern)].map((match) => decodeJavaScriptStringLiteral(match[1]));
}

// `tools.apply_patch("*** Begin Patch ...")` → the same `[{path, kind}]`
// list live `file_change` items carry.
function extractCodexPatchChanges(source: string): Array<{ path: string; kind: string }> {
  const changes: Array<{ path: string; kind: string }> = [];
  const patchPattern = /tools\.apply_patch\s*\(\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/g;
  const kinds: Record<string, string> = { Add: 'add', Update: 'update', Delete: 'delete' };
  for (const patch of source.matchAll(patchPattern)) {
    const text = decodeJavaScriptStringLiteral(patch[1]);
    for (const file of text.matchAll(/^\*\*\* (Add|Update|Delete) File: (.+)$/gm)) {
      changes.push({ path: file[2].trim(), kind: kinds[file[1]] });
    }
  }
  return changes;
}

/**
 * Reads the image attachments Codex records on `user_message` events.
 * Turns sent with `local_image` input items land in `local_images` as file
 * paths (verified against real rollout JSONL); the `images` array can carry
 * base64 data URLs, which are passed through as inline `data` attachments so
 * the UI can preview them without a file lookup.
 *
 * Exported for tests.
 */
export function extractCodexUserImages(
  payload: AnyRecord | null | undefined,
): Array<{ path?: string; data?: string }> | undefined {
  if (!payload) {
    return undefined;
  }

  const candidates = [
    ...(Array.isArray(payload.local_images) ? payload.local_images : []),
    ...(Array.isArray(payload.images) ? payload.images : []),
  ];

  const attachments: Array<{ path?: string; data?: string }> = [];
  for (const entry of candidates) {
    if (typeof entry !== 'string' || !entry.trim()) {
      continue;
    }
    if (entry.startsWith('data:')) {
      attachments.push({ data: entry });
    } else {
      attachments.push(...toImageAttachments([entry]));
    }
  }

  return attachments.length > 0 ? attachments : undefined;
}

function extractCodexTextContent(content: unknown): string {
  if (!Array.isArray(content)) {
    return typeof content === 'string' ? content : '';
  }

  return content
    .map((item) => {
      if (!item || typeof item !== 'object') {
        return '';
      }

      const record = item as AnyRecord;
      if (
        (record.type === 'input_text' || record.type === 'output_text' || record.type === 'text')
        && typeof record.text === 'string'
      ) {
        return record.text;
      }

      return '';
    })
    .filter(Boolean)
    .join('\n');
}

function extractCodexToolOutput(output: unknown): string {
  if (typeof output === 'string') {
    return output;
  }

  if (!Array.isArray(output)) {
    return output == null ? '' : JSON.stringify(output);
  }

  return output
    .map((item) => {
      const record = readObjectRecord(item);
      return typeof record?.text === 'string' ? record.text : '';
    })
    .filter(Boolean)
    .join('');
}

function readRunningExecOutput(output: string): { cellId: string; content: string } | null {
  const runningCell = /Script running with cell ID\s+(\S+)/i.exec(output);
  if (!runningCell) {
    return null;
  }

  const outputMarker = /\r?\nOutput:\r?\n/i.exec(output);
  return {
    cellId: runningCell[1],
    content: outputMarker ? output.slice((outputMarker.index || 0) + outputMarker[0].length) : '',
  };
}

function decodeJavaScriptStringLiteral(literal: string): string {
  if (literal.startsWith('"')) {
    try {
      return JSON.parse(literal) as string;
    } catch {
      return literal.slice(1, -1);
    }
  }

  return literal
    .slice(1, -1)
    .replace(/\\n/g, '\n')
    .replace(/\\r/g, '\r')
    .replace(/\\t/g, '\t')
    .replace(/\\([\\'`])/g, '$1');
}

function extractNestedCodexCommands(source: string): string[] {
  const commands: string[] = [];
  const commandPattern = /(?:["']command["']|\bcommand)\s*:\s*("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/gs;
  for (const match of source.matchAll(commandPattern)) {
    commands.push(decodeJavaScriptStringLiteral(match[1]));
  }

  if (commands.length === 0) {
    const arrayPattern = /\b(?:const|let|var)\s+([A-Za-z_$][\w$]*)\s*=\s*\[([\s\S]*?)\]\s*;/g;
    const stringPattern = /("(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|`(?:\\.|[^`\\])*`)/g;

    for (const arrayMatch of source.matchAll(arrayPattern)) {
      const arrayName = arrayMatch[1];
      if (!new RegExp(`\\b${arrayName}\\.map\\s*\\(`).test(source)) {
        continue;
      }
      for (const stringMatch of arrayMatch[2].matchAll(stringPattern)) {
        commands.push(decodeJavaScriptStringLiteral(stringMatch[1]));
      }
    }
  }

  return commands;
}

/**
 * Newer Codex rollouts persist the orchestration wrapper (`exec`) instead of
 * the nested tool name. Recover the useful UI-level operation so history does
 * not degrade into rows labelled only "exec / Parameters".
 */
function translateCodexExecInput(input: unknown): { toolName: string; toolInput: unknown } | null {
  const source = typeof input === 'string' ? input : String(input || '');
  if (/\btools\.(?:shell_command|exec_command)\s*\(/.test(source)) {
    const commands = extractNestedCodexCommands(source);
    if (commands.length > 0) {
      return {
        toolName: 'Bash',
        toolInput: JSON.stringify({ command: commands.join('\n') }),
      };
    }
  }

  if (/\btools\.apply_patch\s*\(/.test(source)) {
    const changes = extractCodexPatchChanges(source);
    if (changes.length > 0) {
      return { toolName: 'FileChanges', toolInput: changes };
    }
  }

  if (/\btools\.update_plan\s*\(/.test(source)) {
    // shortcut: pairs step/status literals by order; a computed plan stays raw.
    const steps = extractCodexScriptStrings(source, 'step');
    const statuses = extractCodexScriptStrings(source, 'status');
    if (steps.length > 0) {
      return {
        toolName: 'TodoWrite',
        toolInput: { todos: toCodexTodos(steps.map((step, index) => ({ step, status: statuses[index] }))) },
      };
    }
  }

  if (/\btools\.web__run\s*\(/.test(source)) {
    const queries = extractCodexScriptStrings(source, 'q');
    const targets = queries.length > 0 ? queries : extractCodexScriptStrings(source, 'ref_id');
    return { toolName: 'WebSearch', toolInput: { query: targets.join(' | ') } };
  }

  return null;
}

function humanizeCodexToolName(toolName: string): string {
  return toolName
    .replace(/__/g, ' ')
    .replace(/_/g, ' ')
    .replace(/\b\w/g, (character) => character.toUpperCase());
}

type CodexSubagentRecord = {
  toolCallId: string;
  message: AnyRecord;
  agentPath?: string;
  isComplete: boolean;
};

function parseCodexSubagentMessage(payload: AnyRecord): {
  author: string;
  messageType: string;
  result: string;
} | null {
  const text = extractCodexTextContent(payload.content);
  const header = /Message Type:\s*([^\r\n]+)[\s\S]*?Sender:\s*([^\r\n]+)[\s\S]*?Payload:\s*\r?\n([\s\S]*)/i.exec(text);
  const author = readNonEmptyString(payload.author) || header?.[2]?.trim();
  if (!author) {
    return null;
  }

  return {
    author,
    messageType: header?.[1]?.trim().toUpperCase() || 'MESSAGE',
    result: header?.[3]?.trim() || '',
  };
}

const CODEX_COLLABORATION_CONTROL_TOOLS = new Set([
  'followup_task',
  'interrupt_agent',
  'list_agents',
  'send_message',
  'wait_agent',
]);

function readNonEmptyString(value: unknown): string | undefined {
  return typeof value === 'string' && value.length > 0 ? value : undefined;
}

/** Reads a token counter, ignoring negatives, NaN and non-numeric values. */
function readTokenCount(value: unknown): number {
  const parsed = Number(value);
  return Number.isFinite(parsed) && parsed > 0 ? parsed : 0;
}

const ROLLOUT_TAIL_BYTES = 512 * 1024;

// Rollouts live in `<CODEX_HOME>/sessions/YYYY/MM/DD/rollout-<ts>-<threadId>.jsonl`
// (local date). An indexed session row knows its path; a brand-new thread is
// found under today's or yesterday's folder.
async function findCodexRolloutPath(appSessionId: string | null, threadId: string, codexHome: string) {
  let indexed: string | null | undefined = null;
  try {
    indexed = appSessionId ? sessionsDb.getSessionById(appSessionId)?.jsonl_path : null;
  } catch {
    // No session index (e.g. a standalone run); fall back to the date folders.
  }
  if (indexed) {
    return indexed;
  }
  for (const daysAgo of [0, 1]) {
    const day = new Date(Date.now() - daysAgo * 86_400_000);
    const directory = path.join(
      codexHome,
      'sessions',
      String(day.getFullYear()),
      String(day.getMonth() + 1).padStart(2, '0'),
      String(day.getDate()).padStart(2, '0'),
    );
    const names = await fsSync.promises.readdir(directory).catch(() => [] as string[]);
    const match = names.find((name) => name.endsWith(`-${threadId}.jsonl`));
    if (match) {
      return path.join(directory, match);
    }
  }
  return null;
}

/**
 * Reads the context size of the latest model request (`last_token_usage`)
 * and the model's effective window from the tail of a Codex rollout. The
 * live SDK `turn.completed` usage is the session-wide sum, so it cannot
 * drive the context gauge.
 *
 * Consumed by the Codex runtime for its live `token_budget` frame.
 */
export async function readCodexRolloutContextUsage(
  appSessionId: string | null,
  threadId: string,
  codexHome: string,
): Promise<{ used: number; total: number } | null> {
  try {
    const rolloutPath = await findCodexRolloutPath(appSessionId, threadId, codexHome);
    if (!rolloutPath) {
      return null;
    }
    const handle = await fsSync.promises.open(rolloutPath, 'r');
    let tail: string;
    try {
      const { size } = await handle.stat();
      const length = Math.min(size, ROLLOUT_TAIL_BYTES);
      const buffer = Buffer.alloc(length);
      await handle.read(buffer, 0, length, size - length);
      tail = buffer.toString('utf8');
    } finally {
      await handle.close();
    }
    const lines = tail.split('\n');
    for (let index = lines.length - 1; index >= 0; index -= 1) {
      if (!lines[index].includes('"token_count"')) {
        continue;
      }
      try {
        const info = (JSON.parse(lines[index]) as AnyRecord).payload?.info;
        const used = readTokenCount(info?.last_token_usage?.total_tokens);
        if (used > 0) {
          return { used, total: readTokenCount(info.model_context_window) };
        }
      } catch {
        // The first tail line is usually cut mid-record.
      }
    }
  } catch {
    // A missing or unreadable rollout just means no context reading.
  }
  return null;
}

async function getCodexSessionMessages(
  sessionId: string,
  limit: number | null = null,
  offset = 0,
): Promise<CodexHistoryResult> {
  try {
    const row = sessionsDb.getSessionById(sessionId);
    // A fresh thread is read (e.g. by another device on `complete`) before the
    // synchronizer records its path.
    // shortcut: only the default CODEX_HOME is searched; isolated-account threads wait for the synchronizer.
    const sessionFilePath = row?.jsonl_path
      ?? (row?.provider_session_id
        ? await findCodexRolloutPath(null, row.provider_session_id, process.env.CODEX_HOME || path.join(os.homedir(), '.codex'))
        : null);

    if (!sessionFilePath) {
      console.warn(`Codex session file not found for session ${sessionId}`);
      return { messages: [], total: 0, hasMore: false };
    }

    const messages: AnyRecord[] = [];
    let tokenUsage: AnyRecord | null = null;
    const ignoredToolCallIds = new Set<string>();
    const execToolCallIds = new Set<string>();
    const execCallByCellId = new Map<string, string>();
    const waitCallToExecCall = new Map<string, string>();
    const pendingExecOutput = new Map<string, string>();
    const completedExecCalls = new Set<string>();
    const subagentsByCallId = new Map<string, CodexSubagentRecord>();
    const subagentsByPath = new Map<string, CodexSubagentRecord>();
    const fallbackUserMessages: AnyRecord[] = [];
    let sawPrimaryUserMessage = false;
    const fileStream = fsSync.createReadStream(sessionFilePath);
    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity,
    });

    for await (const line of rl) {
      if (!line.trim()) {
        continue;
      }

      try {
        const entry = JSON.parse(line) as AnyRecord;
        if (entry.type === 'event_msg' && entry.payload?.type === 'token_count' && entry.payload?.info) {
          const info = entry.payload.info as AnyRecord;
          if (info.total_token_usage) {
            const usage = info.total_token_usage as AnyRecord;
            const reportedInput = readTokenCount(usage.input_tokens);
            const cacheReadTokens = readTokenCount(
              usage.cached_input_tokens ?? usage.cache_read_input_tokens,
            );
            const outputTokens = readTokenCount(usage.output_tokens);
            // Codex folds cached input into `input_tokens`; split it out so the
            // client bills cache reads at the cheap cache rate instead of the
            // full input rate.
            const inputTokens = Math.max(0, reportedInput - cacheReadTokens);
            tokenUsage = {
              // total_token_usage is the session-wide sum; the context the
              // gauge shows is the last request (`last_token_usage`).
              used: readTokenCount(info.last_token_usage?.total_tokens)
                || readTokenCount(usage.total_tokens)
                || inputTokens + cacheReadTokens + outputTokens,
              total: info.model_context_window || 200000,
              inputTokens,
              outputTokens,
              cacheReadTokens,
              breakdown: {
                input: inputTokens,
                output: outputTokens,
                cacheRead: cacheReadTokens,
              },
            };
          }
        }

        if (
          entry.type === 'event_msg'
          && entry.payload?.type === 'sub_agent_activity'
          && entry.payload.kind === 'started'
        ) {
          const eventId = readNonEmptyString(entry.payload.event_id);
          const agentPath = readNonEmptyString(entry.payload.agent_path);
          const subagent = eventId ? subagentsByCallId.get(eventId) : undefined;
          if (subagent && agentPath) {
            subagent.agentPath = agentPath;
            subagentsByPath.set(agentPath, subagent);
          }
        }

        const userPrompt = readCodexUserPrompt(entry);
        if (userPrompt) {
          const userMessage = {
            type: 'user',
            timestamp: entry.timestamp,
            message: { role: 'user', content: userPrompt.text },
            images: userPrompt.images,
          };
          (userPrompt.source === 'primary' ? messages : fallbackUserMessages).push(userMessage);
          sawPrimaryUserMessage ||= userPrompt.source === 'primary';
        }

        // Turn failures (usage limits, API errors) land on task_complete;
        // older rollouts persist a standalone `error` event.
        const failure = entry.type === 'event_msg'
          ? readNonEmptyString(entry.payload?.type === 'task_complete' ? entry.payload.error?.message : undefined)
            ?? readNonEmptyString(entry.payload?.type === 'error' ? entry.payload.message : undefined)
          : undefined;
        if (failure) {
          messages.push({ type: 'error', timestamp: entry.timestamp, content: failure });
        }

        if (
          entry.type === 'response_item' &&
          entry.payload?.type === 'message' &&
          entry.payload.role === 'assistant'
        ) {
          const textContent = extractCodexTextContent(entry.payload.content);
          if (textContent.trim()) {
            messages.push({
              type: 'assistant',
              timestamp: entry.timestamp,
              message: {
                role: 'assistant',
                content: textContent,
              },
            });
          }
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'reasoning') {
          const summaryText = Array.isArray(entry.payload.summary)
            ? entry.payload.summary
                .map((item: AnyRecord) => item?.text)
                .filter(Boolean)
                .join('\n')
            : '';

          if (summaryText.trim()) {
            messages.push({
              type: 'thinking',
              timestamp: entry.timestamp,
              message: {
                role: 'assistant',
                content: summaryText,
              },
            });
          }
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'agent_message') {
          const agentMessage = parseCodexSubagentMessage(entry.payload as AnyRecord);
          if (agentMessage && agentMessage.messageType === 'FINAL_ANSWER' && agentMessage.result) {
            let subagent = subagentsByPath.get(agentMessage.author);
            if (!subagent) {
              const fallbackCallId = entry.payload.id || generateMessageId('codex-subagent');
              const taskName = agentMessage.author.split('/').filter(Boolean).pop() || 'agent';
              const taskMessage: AnyRecord = {
                uuid: fallbackCallId,
                type: 'tool_use',
                timestamp: entry.timestamp,
                toolName: 'Task',
                toolInput: JSON.stringify({
                  subagent_type: 'Codex',
                  description: humanizeCodexToolName(taskName),
                }),
                toolCallId: fallbackCallId,
              };
              messages.push(taskMessage);
              subagent = {
                toolCallId: fallbackCallId,
                message: taskMessage,
                agentPath: agentMessage.author,
                isComplete: false,
              };
              subagentsByCallId.set(fallbackCallId, subagent);
              subagentsByPath.set(agentMessage.author, subagent);
            }

            if (!subagent.isComplete) {
              messages.push({
                type: 'tool_result',
                timestamp: entry.timestamp,
                toolCallId: subagent.toolCallId,
                output: agentMessage.result,
              });
              subagent.isComplete = true;
            }
          }
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'function_call') {
          let toolName = entry.payload.name;
          let toolInput = entry.payload.arguments;

          if (toolName === 'spawn_agent') {
            let taskName = 'agent';
            try {
              const args = JSON.parse(String(entry.payload.arguments || '{}')) as AnyRecord;
              taskName = readNonEmptyString(args.task_name) || taskName;
            } catch {
              // The activity event can still provide the canonical agent path.
            }

            const taskMessage: AnyRecord = {
              uuid: entry.payload.call_id,
              type: 'tool_use',
              timestamp: entry.timestamp,
              toolName: 'Task',
              toolInput: JSON.stringify({
                subagent_type: 'Codex',
                description: humanizeCodexToolName(taskName),
              }),
              toolCallId: entry.payload.call_id,
            };
            messages.push(taskMessage);
            subagentsByCallId.set(entry.payload.call_id, {
              toolCallId: entry.payload.call_id,
              message: taskMessage,
              isComplete: false,
            });
            ignoredToolCallIds.add(entry.payload.call_id);
            continue;
          }

          if (toolName === 'wait') {
            try {
              const args = JSON.parse(String(entry.payload.arguments || '{}')) as AnyRecord;
              const cellId = String(args.cell_id || '');
              const execCallId = execCallByCellId.get(cellId);
              if (execCallId) {
                waitCallToExecCall.set(entry.payload.call_id, execCallId);
              }
            } catch {
              // Suppress the orchestration wait even when its payload is malformed.
            }
            ignoredToolCallIds.add(entry.payload.call_id);
            continue;
          }

          if (CODEX_COLLABORATION_CONTROL_TOOLS.has(toolName)) {
            ignoredToolCallIds.add(entry.payload.call_id);
            continue;
          }

          if (toolName === 'shell_command') {
            toolName = 'Bash';
            try {
              const args = JSON.parse(entry.payload.arguments) as AnyRecord;
              toolInput = JSON.stringify({ command: args.command });
            } catch {
              // Keep original arguments when parsing fails.
            }
          }

          // Plan updates render as the client's todo list, like live todo_list items.
          if (toolName === 'update_plan') {
            try {
              const args = JSON.parse(String(entry.payload.arguments || '{}')) as AnyRecord;
              toolName = 'TodoWrite';
              toolInput = { todos: toCodexTodos(args.plan) };
            } catch {
              // Keep original arguments when parsing fails.
            }
          }

          if (toolName === 'request_user_input' || toolName === 'request_user_input_async') {
            try {
              const args = JSON.parse(String(entry.payload.arguments || '{}')) as AnyRecord;
              const questions: AnyRecord[] = Array.isArray(args.questions) ? args.questions : [];
              toolName = 'AskUserQuestion';
              toolInput = {
                questions: questions.map((question) => ({
                  header: question?.header,
                  question: question?.question ?? question?.title ?? '',
                  options: question?.options,
                })),
              };
            } catch {
              // Keep original arguments when parsing fails.
            }
          }

          messages.push({
            type: 'tool_use',
            timestamp: entry.timestamp,
            toolName,
            toolInput,
            toolCallId: entry.payload.call_id,
          });
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'function_call_output') {
          const waitExecCallId = waitCallToExecCall.get(entry.payload.call_id);
          if (waitExecCallId) {
            const output = extractCodexToolOutput(entry.payload.output);
            const runningOutput = readRunningExecOutput(output);
            const accumulatedOutput = `${pendingExecOutput.get(waitExecCallId) || ''}${runningOutput?.content ?? output}`;
            pendingExecOutput.set(waitExecCallId, accumulatedOutput);

            if (!runningOutput && !completedExecCalls.has(waitExecCallId)) {
              messages.push({
                type: 'tool_result',
                timestamp: entry.timestamp,
                toolCallId: waitExecCallId,
                output: accumulatedOutput,
              });
              completedExecCalls.add(waitExecCallId);
            }
            continue;
          }

          const subagent = subagentsByCallId.get(entry.payload.call_id);
          if (subagent) {
            const output = extractCodexToolOutput(entry.payload.output);
            try {
              const taskPath = readNonEmptyString((JSON.parse(output) as AnyRecord).task_name);
              if (taskPath) {
                subagent.agentPath = taskPath;
                subagentsByPath.set(taskPath, subagent);
              }
            } catch {
              // The sub_agent_activity event normally supplies the path.
            }
            continue;
          }

          if (ignoredToolCallIds.has(entry.payload.call_id)) {
            continue;
          }

          messages.push({
            type: 'tool_result',
            timestamp: entry.timestamp,
            toolCallId: entry.payload.call_id,
            output: extractCodexToolOutput(entry.payload.output),
          });
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'custom_tool_call') {
          let toolName = entry.payload.name || 'custom_tool';
          const input = entry.payload.input || '';
          let toolInput = input;

          if (toolName === 'exec') {
            const translated = translateCodexExecInput(input);
            if (translated) {
              toolName = translated.toolName;
              toolInput = translated.toolInput;
            }
            messages.push({
              type: 'tool_use',
              timestamp: entry.timestamp,
              toolName,
              toolInput,
              toolCallId: entry.payload.call_id,
            });
            execToolCallIds.add(entry.payload.call_id);
            continue;
          }

          if (toolName === 'apply_patch') {
            const fileMatch = String(input).match(/\*\*\* Update File: (.+)/);
            const filePath = fileMatch ? fileMatch[1].trim() : 'unknown';
            const lines = String(input).split('\n');
            const oldLines: string[] = [];
            const newLines: string[] = [];

            for (const lineContent of lines) {
              if (lineContent.startsWith('-') && !lineContent.startsWith('---')) {
                oldLines.push(lineContent.slice(1));
              } else if (lineContent.startsWith('+') && !lineContent.startsWith('+++')) {
                newLines.push(lineContent.slice(1));
              }
            }

            messages.push({
              type: 'tool_use',
              timestamp: entry.timestamp,
              toolName: 'Edit',
              toolInput: JSON.stringify({
                file_path: filePath,
                old_string: oldLines.join('\n'),
                new_string: newLines.join('\n'),
              }),
              toolCallId: entry.payload.call_id,
            });
          } else {
            messages.push({
              type: 'tool_use',
              timestamp: entry.timestamp,
              toolName,
              toolInput: input,
              toolCallId: entry.payload.call_id,
            });
          }
        }

        if (entry.type === 'response_item' && entry.payload?.type === 'custom_tool_call_output') {
          if (ignoredToolCallIds.has(entry.payload.call_id)) {
            continue;
          }

          const output = extractCodexToolOutput(entry.payload.output);
          if (execToolCallIds.has(entry.payload.call_id)) {
            const runningOutput = readRunningExecOutput(output);
            if (runningOutput) {
              execCallByCellId.set(runningOutput.cellId, entry.payload.call_id);
              pendingExecOutput.set(entry.payload.call_id, runningOutput.content);
              continue;
            }
            completedExecCalls.add(entry.payload.call_id);
          }

          messages.push({
            type: 'tool_result',
            timestamp: entry.timestamp,
            toolCallId: entry.payload.call_id,
            output,
          });
        }
      } catch {
        // Skip malformed lines.
      }
    }

    if (!sawPrimaryUserMessage) {
      messages.push(...fallbackUserMessages);
    }

    messages.sort(
      (a, b) => new Date(a.timestamp || 0).getTime() - new Date(b.timestamp || 0).getTime(),
    );
    const total = messages.length;

    if (limit !== null) {
      const startIndex = Math.max(0, total - offset - limit);
      const endIndex = total - offset;
      const paginatedMessages = messages.slice(startIndex, endIndex);
      const hasMore = startIndex > 0;

      return {
        messages: paginatedMessages,
        total,
        hasMore,
        offset,
        limit,
        tokenUsage,
      };
    }

    return { messages, tokenUsage };
  } catch (error) {
    // Only reached when a transcript path exists but could not be read (a
    // missing path returns early above). Rethrow so fetchHistory surfaces a
    // PROVIDER_HISTORY_UNAVAILABLE error instead of an empty transcript.
    console.error(`Error reading Codex session messages for ${sessionId}:`, error);
    throw error;
  }
}

// Live Codex tool items arrive only once, at `item.completed`, as a single
// tool_use row with no separate tool_result. The client treats a tool_use
// without `toolResult` as still running, so the outcome rides on the row.
function codexLiveToolResult(content: unknown, isError: boolean) {
  return { content: typeof content === 'string' ? content : '', isError };
}

// Rollout tool outputs carry no error flag — a failed command shows only as
// a non-zero exit code inside the output text (the exec result JSON, or the
// shell tool's "Process exited with code N" line). Live rows flag the same
// calls through `exitCode`, so history must agree.
function codexOutputReportsFailure(output: unknown): boolean {
  if (typeof output !== 'string') return false;
  const match = /"exit_code":\s*(-?\d+)/.exec(output)
    ?? /Process exited with code (-?\d+)/.exec(output)
    ?? /^Exit code: (-?\d+)/m.exec(output);
  return Boolean(match && match[1] !== '0');
}

// MCP results carry ACP-style content blocks; keep their text.
function codexMcpResultText(result: unknown): string {
  const blocks = readObjectRecord(result)?.content;
  if (!Array.isArray(blocks)) return '';
  return blocks
    .map((block: AnyRecord) => (typeof block?.text === 'string' ? block.text : ''))
    .filter(Boolean)
    .join('\n');
}

export class CodexSessionsProvider implements IProviderSessions {
  /**
   * Normalizes a persisted Codex JSONL entry.
   *
   * Live Codex SDK events are transformed before they reach normalizeMessage(),
   * while history entries already use a compact message/tool shape from projects.js.
   */
  private normalizeHistoryEntry(raw: AnyRecord, sessionId: string | null): NormalizedMessage[] {
    const ts = raw.timestamp || new Date().toISOString();
    const baseId = raw.uuid || generateMessageId('codex');

    if (raw.type === 'thinking' || raw.isReasoning) {
      const thinkingContent = typeof raw.message?.content === 'string'
        ? raw.message.content
        : '';
      if (!thinkingContent.trim()) {
        return [];
      }
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'thinking',
        content: thinkingContent,
      })];
    }

    if (raw.message?.role === 'user') {
      const content = typeof raw.message.content === 'string'
        ? raw.message.content
        : Array.isArray(raw.message.content)
          ? raw.message.content
              .map((part: string | AnyRecord) => typeof part === 'string' ? part : part?.text || '')
              .filter(Boolean)
              .join('\n')
          : String(raw.message.content || '');
      const parsedFiles = parseFilesInputTag(content);
      const rawImages = Array.isArray(raw.images) && raw.images.length > 0 ? raw.images : undefined;
      const files = parsedFiles.attachments.length > 0 ? parsedFiles.attachments : undefined;
      if (!parsedFiles.text.trim() && !rawImages && !files) {
        return [];
      }
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'text',
        role: 'user',
        content: parsedFiles.text,
        images: rawImages,
        files,
      })];
    }

    if (raw.message?.role === 'assistant') {
      const content = typeof raw.message.content === 'string'
        ? raw.message.content
        : Array.isArray(raw.message.content)
          ? raw.message.content
              .map((part: string | AnyRecord) => typeof part === 'string' ? part : part?.text || '')
              .filter(Boolean)
              .join('\n')
          : '';
      if (!content.trim()) {
        return [];
      }
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'text',
        role: 'assistant',
        content,
      })];
    }

    if (raw.type === 'tool_use' || raw.toolName) {
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'tool_use',
        toolName: raw.toolName || 'Unknown',
        toolInput: raw.toolInput,
        toolId: raw.toolCallId || baseId,
      })];
    }

    if (raw.type === 'error') {
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'error',
        content: raw.content,
      })];
    }

    if (raw.type === 'tool_result') {
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'tool_result',
        toolId: raw.toolCallId || '',
        content: raw.output || '',
        isError: Boolean(raw.isError) || codexOutputReportsFailure(raw.output),
      })];
    }

    return [];
  }

  /**
   * Normalizes either a Codex history entry or a transformed live SDK event.
   */
  normalizeMessage(rawMessage: unknown, sessionId: string | null): NormalizedMessage[] {
    const raw = readObjectRecord(rawMessage);
    if (!raw) {
      return [];
    }

    if (raw.message?.role) {
      return this.normalizeHistoryEntry(raw, sessionId);
    }

    const ts = raw.timestamp || new Date().toISOString();
    const baseId = raw.uuid || generateMessageId('codex');

    if (raw.type === 'item') {
      switch (raw.itemType) {
        case 'agent_message':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'text',
            role: 'assistant',
            content: raw.message?.content || '',
          })];
        case 'reasoning':
          if (!String(raw.message?.content ?? '').trim()) {
            return [];
          }
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'thinking',
            content: raw.message.content,
          })];
        case 'command_execution':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: 'Bash',
            toolInput: { command: raw.command },
            toolId: raw.itemId || baseId,
            output: raw.output,
            exitCode: raw.exitCode,
            status: raw.status,
            // A started command has no outcome yet; the runtime sends it later
            // as a tool_result under the same toolId.
            toolResult: raw.status === 'in_progress' ? undefined : codexLiveToolResult(
              raw.output,
              raw.status !== 'completed' || (typeof raw.exitCode === 'number' && raw.exitCode !== 0),
            ),
          })];
        case 'file_change':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: 'FileChanges',
            toolInput: raw.changes,
            toolId: raw.itemId || baseId,
            status: raw.status,
            toolResult: codexLiveToolResult(
              (Array.isArray(raw.changes) ? raw.changes : [])
                .map((change: AnyRecord) => `${change?.kind ?? 'update'} ${change?.path ?? ''}`.trim())
                .join('\n'),
              raw.status === 'failed',
            ),
          })];
        case 'mcp_tool_call':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: raw.tool || 'MCP',
            toolInput: raw.arguments,
            toolId: raw.itemId || baseId,
            server: raw.server,
            result: raw.result,
            error: raw.error,
            status: raw.status,
            toolResult: raw.status === 'in_progress' ? undefined : codexLiveToolResult(
              raw.error?.message ?? raw.error ?? codexMcpResultText(raw.result),
              raw.status === 'failed' || Boolean(raw.error),
            ),
          })];
        case 'web_search':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: 'WebSearch',
            toolInput: { query: raw.query },
            toolId: raw.itemId || baseId,
            toolResult: codexLiveToolResult('', false),
          })];
        case 'todo_list':
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: 'TodoWrite',
            toolInput: { todos: toCodexTodos(raw.items) },
            toolId: raw.itemId || baseId,
            toolResult: codexLiveToolResult('', false),
          })];
        case 'error':
          // ErrorItem is Codex's non-fatal error (e.g. a stream retry); the
          // fatal ones arrive as the top-level `error` / `turn.failed` events.
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'status',
            text: raw.text || 'Unknown error',
            notice: true,
          })];
        default:
          return [createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp: ts,
            provider: PROVIDER,
            kind: 'tool_use',
            toolName: raw.itemType || 'Unknown',
            toolInput: raw.item || raw,
            toolId: baseId,
          })];
      }
    }

    // `turn_complete` maps to nothing: the runtime sends the run's single
    // terminal `complete` after the token budget.
    if (raw.type === 'error') {
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'error',
        content: raw.message || 'Codex error',
      })];
    }
    if (raw.type === 'turn_failed') {
      return [createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'error',
        content: raw.error?.message || 'Turn failed',
      })];
    }

    return [];
  }

  /**
   * Loads Codex JSONL history and keeps token usage metadata when projects.js
   * provides it.
   */
  async fetchHistory(
    sessionId: string,
    options: FetchHistoryOptions = {},
  ): Promise<FetchHistoryResult> {
    const { limit = null, offset = 0 } = options;

    let result: CodexHistoryResult;
    try {
      // Load full history first so `total` reflects frontend-normalized messages,
      // not raw JSONL records.
      result = await getCodexSessionMessages(sessionId, null, 0);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn(`[CodexProvider] Failed to load session ${sessionId}:`, message);
      // An empty page reads as "authoritative empty transcript" downstream and
      // is even cached as such — surface the failure instead of faking it.
      throw new AppError(`Failed to load Codex session history: ${message}`, {
        code: 'PROVIDER_HISTORY_UNAVAILABLE',
        statusCode: 503,
      });
    }

    const rawMessages = Array.isArray(result) ? result : (result.messages || []);
    const tokenUsage = Array.isArray(result) ? undefined : result.tokenUsage;

    const normalized: NormalizedMessage[] = [];
    for (const raw of rawMessages) {
      normalized.push(...this.normalizeHistoryEntry(raw, sessionId));
    }

    const toolResultMap = new Map<string, NormalizedMessage>();
    for (const msg of normalized) {
      if (msg.kind === 'tool_result' && msg.toolId) {
        toolResultMap.set(msg.toolId, msg);
      }
    }
    for (const msg of normalized) {
      if (msg.kind === 'tool_use' && msg.toolId && toolResultMap.has(msg.toolId)) {
        const toolResult = toolResultMap.get(msg.toolId);
        if (toolResult) {
          msg.toolResult = { content: toolResult.content, isError: toolResult.isError };
        }
      }
    }

    let total = 0;
    for (const msg of normalized) {
      if (msg.kind !== 'tool_result') {
        total += 1;
      }
    }
    const normalizedOffset = Math.max(0, offset);
    const normalizedLimit = limit === null ? null : Math.max(0, limit);
    const { page, hasMore } = sliceTailPage(normalized, normalizedLimit, normalizedOffset);

    return {
      messages: page,
      total,
      hasMore,
      offset: normalizedOffset,
      limit: normalizedLimit,
      tokenUsage,
    };
  }
}

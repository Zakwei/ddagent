/**
 * Claude SDK Integration
 *
 * This module provides SDK-based integration with Claude using the @anthropic-ai/claude-agent-sdk.
 * It mirrors the interface of claude-cli.js but uses the SDK internally for better performance
 * and maintainability.
 *
 * Key features:
 * - Direct SDK integration without child processes
 * - Session management with abort capability
 * - Options mapping between CLI and SDK formats
 * - WebSocket message streaming
 */

import crypto from 'crypto';
import { promises as fs } from 'fs';
import os from 'os';
import path from 'path';

import { query } from '@anthropic-ai/claude-agent-sdk';

import type {
  AnyRecord,
  ProviderRuntimeWriter,
  IProviderRuntime,
} from '@/shared/index.js';
import {
  appendFilesInputTag,
  buildClaudeUserContent,
  normalizeImageDescriptors,
  resolveClaudeCodeExecutablePath,
  createCompleteMessage,
  createNormalizedMessage,
  providerChildEnv,
  readObjectRecord,
} from '@/shared/index.js';
import { CLAUDE_PREDEFINED_MODELS } from '@/modules/providers/list/claude/claude-models.provider.js';
import {
  recordClaudeContextWindow,
  rememberClaudeContextWindow,
  resolveClaudeContextWindow,
} from '@/modules/providers/services/provider-token-usage.service.js';
import { orchestratorMessagesDb, sessionsDb } from '@/modules/database/index.js';
import {
  createNotificationEvent,
  notifyBackgroundWorkCompleted,
  notifyRunFailed,
  notifyRunStopped,
  notifyUserIfEnabled,
} from '@/modules/notifications/index.js';

const activeSessions = new Map<any, any>();
const pendingToolApprovals = new Map<any, any>();
// Sessions cancelled via abort-session. The abort handler already sent the
// terminal `complete` (aborted: true) to the client, so the run loop must not
// emit a second one when its generator winds down.
const abortedInstances = new WeakSet();
// Query instances interrupted because a newer run took over their session id
// (see addSession). Their run loops must stay silent on wind-down: the map
// entry, the abort flag, and all client-facing events belong to the new run.
const supersededInstances = new WeakSet();

// Runs that have not registered their query yet (model lookup, MCP config,
// prompt build). An abort landing in that window is parked here and honoured
// right before the CLI would be spawned.
const startingRuns = new Set<string>();
const pendingAborts = new Set<string>();

// Not an SDK limit (the CLI waits on can_use_tool indefinitely, as the interactive asks show): long enough for a user to answer a prompt already on screen.
const TOOL_APPROVAL_TIMEOUT_MS = parseInt(process.env.CLAUDE_TOOL_APPROVAL_TIMEOUT_MS ?? '', 10) || 30 * 60 * 1000;

// How long background work is allowed to keep running after a turn ends. This drives
// two halves of the same behaviour:
//
//  1. Passed to the spawned CLI as CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS, which is how
//     long it waits for still-running background *agents* before killing them.
//  2. A backstop on how long we hold the SDK's stdin open after a turn's `result`.
//     The SDK closes stdin as soon as a turn ends, and the CLI reads that EOF as
//     "print wind-down" — killing background *shells* after a short grace period,
//     which the ceiling above does not cover. Holding stdin open also lets the CLI
//     push follow-up turns (background-task completions, Monitor notifications,
//     scheduled wake-ups).
//
// The hold normally ends long before this: a turn with nothing outstanding closes
// stdin immediately, background work releases it as soon as it reports back, and a
// new turn supersedes the previous hold. This ceiling only catches background work
// that never reports at all, so an abandoned session cannot leak a CLI process
// forever. The timer resets on every message, so it measures silence, not total time.
const BG_WAIT_CEILING_MS = 30 * 60 * 1000;

// How long stdin stays open after a turn during which a background task
// settled. The CLI reports that task in a follow-up turn it queues behind the
// current one; closing stdin at the current turn's `result` would cut that
// turn's permission channel ("Stream closed"). The follow-up turn's messages
// re-arm the hold, and its own `result` decides again.
const FOLLOW_UP_GRACE_MS = 60 * 1000;

const TOOLS_REQUIRING_INTERACTION = new Set(['AskUserQuestion', 'ExitPlanMode']);

// Tools that write files: their "Always" rule only covers the project directory.
const FILE_EDIT_TOOLS = new Set(['Edit', 'Write', 'MultiEdit', 'NotebookEdit']);

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

function resolveClaudeEffort(model: any, effort: any, modelsDefinition: any = CLAUDE_PREDEFINED_MODELS) {
  const selectedModel = modelsDefinition?.OPTIONS?.find((option: any) => option.value === model) || null;
  const allowedEfforts = selectedModel?.effort?.values
    ?.map((value: any) => value.value) || [];
  return typeof effort === 'string' && effort !== 'default' && allowedEfforts.includes(effort)
    ? effort
    : undefined;
}

function createRequestId() {
  if (typeof crypto.randomUUID === 'function') {
    return crypto.randomUUID();
  }
  return crypto.randomBytes(16).toString('hex');
}

function waitForToolApproval(requestId: any, options: any = {}) {
  const { timeoutMs = TOOL_APPROVAL_TIMEOUT_MS, signal, onCancel, metadata } = options;

  return new Promise<any>((resolve) => {
    let settled = false;

    const finalize = (decision: any) => {
      if (settled) return;
      settled = true;
      cleanup();
      resolve(decision);
    };

    let timeout: any;

    const cleanup = () => {
      pendingToolApprovals.delete(requestId);
      if (timeout) clearTimeout(timeout);
      if (signal && abortHandler) {
        signal.removeEventListener('abort', abortHandler);
      }
    };

    // timeoutMs 0 = wait indefinitely (interactive tools)
    if (timeoutMs > 0) {
      timeout = setTimeout(() => {
        onCancel?.('timeout');
        finalize(null);
      }, timeoutMs);
    }

    const abortHandler = () => {
      onCancel?.('cancelled');
      finalize({ cancelled: true });
    };

    if (signal) {
      if (signal.aborted) {
        onCancel?.('cancelled');
        finalize({ cancelled: true });
        return;
      }
      signal.addEventListener('abort', abortHandler, { once: true });
    }

    const resolver = (decision: any) => {
      finalize(decision);
    };
    // Attach metadata for getPendingApprovalsForSession lookup
    if (metadata) {
      Object.assign(resolver, metadata);
    }
    pendingToolApprovals.set(requestId, resolver);
  });
}

// Consumed by provider runtime services and lifecycle tests.
export function resolveToolApproval(requestId: any, decision: any) {
  const resolver = pendingToolApprovals.get(requestId);
  if (!resolver) {
    return;
  }
  const sessionId = resolver._sessionId;
  resolver(decision);
  // The ask was answered on one client — every other viewer still shows the
  // prompt, so drop it session-wide, not just on the answering device.
  // Carry the picked answers so those other windows render the answer instead
  // of falling back to "Skipped".
  const answers = readObjectRecord(readObjectRecord(decision?.updatedInput)?.answers);
  const writer = sessionId ? activeSessions.get(sessionId)?.writer : null;
  writer?.send?.(createNormalizedMessage({
    kind: 'permission_cancelled',
    requestId,
    reason: 'resolved',
    sessionId,
    provider: 'claude',
    ...(answers ? { answers } : {}),
  }));
}

/**
 * Settles every pending approval owned by one session.
 *
 * Interactive tools (AskUserQuestion, ExitPlanMode) wait with `timeoutMs: 0`,
 * so nothing else ever resolves them — an entry left behind leaks forever and
 * resurfaces as a phantom approval on every chat.subscribe. Resolving with
 * `{ cancelled: true }` runs the waiter's cleanup (map delete, listener
 * removal) and lets its canUseTool call finish with a deny.
 */
function cancelPendingToolApprovalsForSession(sessionId: any) {
  for (const [requestId, resolver] of pendingToolApprovals.entries()) {
    if (resolver._sessionId === sessionId) {
      resolver({ cancelled: true });
    }
  }
}

// Match stored permission entries against a tool + input combo.
// This only supports exact tool names and the Bash(command:*) shorthand
// used by the UI; it intentionally does not implement full glob semantics,
// introduced to stay consistent with the UI's "Allow rule" format.
function matchesToolPermission(entry: any, toolName: any, input: any) {
  if (!entry || !toolName) {
    return false;
  }

  if (entry === toolName) {
    return true;
  }

  // `Edit(//abs/dir/**)` — Claude Code's absolute-path rule, as built by
  // scopeRememberedRule: only paths inside that directory match.
  const scopedMatch = entry.match(/^(\w+)\(\/(\/.*)\/\*\*\)$/);
  if (scopedMatch && scopedMatch[1] === toolName && FILE_EDIT_TOOLS.has(toolName)) {
    const target = input?.file_path ?? input?.notebook_path;
    if (typeof target !== 'string' || !target) return false;
    const dir = scopedMatch[2];
    const resolved = path.resolve(dir, target);
    return resolved === dir || resolved.startsWith(`${dir}${path.sep}`);
  }

  const bashMatch = entry.match(/^Bash\((.+):\*\)$/);
  if (toolName === 'Bash' && bashMatch) {
    const allowedPrefix = bashMatch[1];
    let command = '';

    if (typeof input === 'string') {
      command = input.trim();
    } else if (input && typeof input === 'object' && typeof input.command === 'string') {
      command = input.command.trim();
    }

    if (!command) {
      return false;
    }

    // A prefix rule approves one command, never a chain riding on it
    // (`git status && rm -rf ~`), and `git status:*` must not match
    // `git statusx`.
    if (/[;&|`\n]|\$\(/.test(command)) {
      return false;
    }
    return command === allowedPrefix || command.startsWith(`${allowedPrefix} `);
  }

  return false;
}

// Rules approved with "Always", per app session. The client sends no
// persistent allowedTools, so without this an "Always" lasted one turn.
const sessionRememberedTools = new Map<string, Set<string>>();

/**
 * The rule an "Always" answer adds for one permission ask: Bash gets a
 * command-prefix rule (`Bash(git status:*)` — the command plus its
 * subcommand when there is one), every other tool its bare name. Interactive
 * tools and commands that cannot be expressed as a safe prefix get none, so
 * the client offers no "Always" button for them.
 */
// Exported for tests: the rule offered to the client.
export function claudeRememberEntry(toolName: any, input: any): string | null {
  if (!toolName || TOOLS_REQUIRING_INTERACTION.has(toolName)) return null;
  if (toolName !== 'Bash') return String(toolName);
  const command = typeof input?.command === 'string' ? input.command.trim() : '';
  if (!command || /[;&|`\n]|\$\(/.test(command)) return null;
  const words = command.split(/\s+/);
  const prefix = words.length > 1 && /^[a-z][\w:.-]*$/i.test(words[1]) ? `${words[0]} ${words[1]}` : words[0];
  return /^[\w./:@+-]+( [\w:.-]+)?$/.test(prefix) ? `Bash(${prefix}:*)` : null;
}

/**
 * The rule an "Always" answer actually stores. The client's entry is accepted
 * only when it is the one the server offered for that ask, and file-editing
 * tools are narrowed to the project directory so "Always allow Edit" never
 * covers files outside it.
 */
// Exported for tests.
export function scopeRememberedRule(offered: string | null, requested: unknown, toolName: string, cwd: unknown): string | null {
  if (!offered || requested !== offered) return null;
  if (!FILE_EDIT_TOOLS.has(toolName)) return offered;
  return typeof cwd === 'string' && cwd ? `${toolName}(/${path.resolve(cwd)}/**)` : null;
}

/**
 * Splits the app's permission mode into what the CLI runs with and whether
 * bypass is emulated in canUseTool. Interactive bypass stays OUT of the SDK
 * so canUseTool keeps gating interactive tools (AskUserQuestion/ExitPlanMode)
 * — in real bypass the SDK resolves approval at the permission-mode step and
 * never calls it, so the model would act on a generated answer. Headless
 * delegated children keep real bypass: nobody watches their transcript.
 */
function resolvePermissionModeState(permissionMode: any, skipPermissions: any, delegated: any) {
  const bypassRequested = permissionMode === 'bypassPermissions' || (skipPermissions && permissionMode !== 'plan');
  const interactiveBypass = Boolean(bypassRequested && !delegated);
  const sdkMode: string = interactiveBypass ? 'default' : (permissionMode || 'default');
  return { sdkMode, interactiveBypass };
}

const ASSISTANT_ERROR_TEXT: Record<string, string> = {
  authentication_failed: 'Claude authentication failed — log in again.',
  oauth_org_not_allowed: 'This Claude account\'s organization is not allowed.',
  billing_error: 'Claude billing error — check the account\'s plan or credits.',
  rate_limit: 'Claude usage limit reached.',
  overloaded: 'Claude API is overloaded.',
  invalid_request: 'Claude rejected the request as invalid.',
  model_not_found: 'The selected Claude model was not found.',
  server_error: 'Claude API server error.',
  max_output_tokens: 'The response hit the output token limit.',
};

const RESULT_SUBTYPE_TEXT: Record<string, string> = {
  error_max_turns: 'Stopped: reached the maximum number of turns.',
  error_max_budget_usd: 'Stopped: reached the maximum budget.',
  error_during_execution: 'Claude failed while running.',
  error_max_structured_output_retries: 'Stopped: could not produce valid structured output.',
};

/**
 * Readable error for a failed turn `result` (`is_error` or a non-success
 * subtype), or null when the turn succeeded. `assistantError` is the `error`
 * code of the turn's last assistant message, which names the API failure.
 */
// Exported for tests.
export function describeClaudeResultFailure(result: AnyRecord, assistantError: string | null): string | null {
  if (result?.is_error !== true && (!result?.subtype || result.subtype === 'success')) return null;
  const errors = Array.isArray(result.errors) ? result.errors.filter((e: unknown) => typeof e === 'string' && e) : [];
  const detail = errors.join('; ') || (typeof result.result === 'string' ? result.result.trim() : '');
  const denials = Array.isArray(result.permission_denials)
    ? [...new Set(result.permission_denials.map((d: AnyRecord) => d?.tool_name).filter(Boolean))]
    : [];
  return [
    (assistantError && ASSISTANT_ERROR_TEXT[assistantError]) || '',
    detail || RESULT_SUBTYPE_TEXT[result.subtype] || 'Claude run failed.',
    denials.length ? `Denied tools: ${denials.join(', ')}.` : '',
  ].filter(Boolean).join(' ');
}

function formatDuration(ms: number) {
  const minutes = Math.max(1, Math.round(ms / 60000));
  return minutes >= 60 ? `${Math.floor(minutes / 60)}h ${minutes % 60}m` : `${minutes}m`;
}

/**
 * The user-facing line for an SDK message that is worth a status row:
 * `notice: true` lines persist in the transcript (C1), the rest are ephemeral
 * activity labels. Null for every other message.
 */
// Exported for tests.
export function claudeStatusLine(message: AnyRecord): { text: string; notice: boolean } | null {
  if (message?.type === 'rate_limit_event') {
    const info = message.rate_limit_info || {};
    if (info.status !== 'rejected' && info.status !== 'allowed_warning') return null;
    const kind = info.rateLimitType ? ` (${String(info.rateLimitType).replace(/_/g, ' ')})` : '';
    const resets = Number(info.resetsAt) > 0 ? `, resets in ${formatDuration(Number(info.resetsAt) * 1000 - Date.now())}` : '';
    return info.status === 'rejected'
      ? { text: `Claude usage limit reached${kind}${resets}.`, notice: true }
      : { text: `Approaching the Claude usage limit${kind}${resets}.`, notice: true };
  }
  if (message?.type === 'result' && !describeClaudeResultFailure(message, null)) {
    if (message.stop_reason === 'refusal') return { text: 'Claude declined to continue (refusal).', notice: true };
    if (message.stop_reason === 'max_tokens') return { text: 'The response was cut off at the output token limit.', notice: true };
    return null;
  }
  if (message?.type !== 'system') return null;
  switch (message.subtype) {
    case 'api_retry': {
      const status = message.error_status ? ` ${message.error_status}` : '';
      const delay = Math.round(Number(message.retry_delay_ms) / 1000);
      return { text: `API error (${message.error || 'unknown'}${status}), retrying in ${delay}s — attempt ${message.attempt}/${message.max_retries}.`, notice: true };
    }
    case 'status':
      if (message.compact_result === 'failed') return { text: `Compaction failed: ${message.compact_error || 'unknown error'}.`, notice: true };
      if (message.compact_result === 'success') return { text: 'Conversation compacted.', notice: true };
      return message.status === 'compacting' ? { text: 'Compacting conversation…', notice: false } : null;
    case 'permission_denied':
      return { text: `${message.tool_name || 'Tool'} denied: ${message.decision_reason || message.message || 'not permitted'}.`, notice: true };
    default:
      return null;
  }
}

/**
 * Maps the provider-agnostic run options onto SDK query options.
 *
 * Exported for the runtime provider tests, which assert the streaming-related
 * options (notably `includePartialMessages`) without spawning the CLI.
 *
 * @param {Object} options - Run options (session, cwd, tools, model, effort)
 * @returns {Object} Options object accepted by the SDK's `query()`
 */
export function mapCliOptionsToSDK(options: any = {}): any {
  const { providerSessionId, cwd, toolsSettings, permissionMode, effort } = options;

  const sdkOptions: any = {};

  // Forward all host env vars (e.g. ANTHROPIC_BASE_URL) to the subprocess.
  // Since SDK 0.2.113, options.env replaces process.env instead of overlaying it.
  sdkOptions.env = providerChildEnv({
    CLAUDE_CODE_PRINT_BG_WAIT_CEILING_MS: String(BG_WAIT_CEILING_MS),
    // Multi-account: env overrides selected at session creation (e.g.
    // CLAUDE_CONFIG_DIR pointing at an isolated credential directory).
    ...(options.env && typeof options.env === 'object' ? options.env : {}),
  });

  // Resolve the executable eagerly on Windows because the SDK uses raw child_process.spawn,
  // which does not reliably follow npm's shell wrappers like cross-spawn does.
  sdkOptions.pathToClaudeCodeExecutable = resolveClaudeCodeExecutablePath(process.env.CLAUDE_CLI_PATH);

  if (cwd) {
    sdkOptions.cwd = cwd;
  }

  const settings = toolsSettings || {
    allowedTools: [],
    disallowedTools: [],
    skipPermissions: false
  };

  const { sdkMode, interactiveBypass } = resolvePermissionModeState(permissionMode, settings.skipPermissions, options.delegated);
  if (interactiveBypass) {
    sdkOptions.interactiveBypass = true;
  }

  if (sdkMode !== 'default') {
    sdkOptions.permissionMode = sdkMode;
  }
  // The SDK requires this opt-in for a real bypass (headless delegated children).
  if (sdkMode === 'bypassPermissions') {
    sdkOptions.allowDangerouslySkipPermissions = true;
  }

  let allowedTools: any = [...(settings.allowedTools || [])];

  if (permissionMode === 'plan') {
    const planModeTools: any = ['Read', 'Task', 'exit_plan_mode', 'TodoRead', 'TodoWrite', 'WebFetch', 'WebSearch'];
    for (const tool of planModeTools) {
      if (!allowedTools.includes(tool)) {
        allowedTools.push(tool);
      }
    }
  }

  sdkOptions.allowedTools = allowedTools;

  // Use the tools preset to make all default built-in tools available (including AskUserQuestion).
  // This was introduced in SDK 0.1.57. Omitting this preserves existing behavior (all tools available),
  // but being explicit ensures forward compatibility and clarity.
  sdkOptions.tools = { type: 'preset', preset: 'claude_code' };

  sdkOptions.disallowedTools = settings.disallowedTools || [];

  sdkOptions.model = options.model || CLAUDE_PREDEFINED_MODELS.DEFAULT;

  const resolvedEffort = resolveClaudeEffort(
    sdkOptions.model,
    effort,
    options.effortModels || CLAUDE_PREDEFINED_MODELS,
  );
  if (resolvedEffort) {
    sdkOptions.effort = resolvedEffort;
  }

  sdkOptions.systemPrompt = {
    type: 'preset',
    preset: 'claude_code'
  };

  sdkOptions.settingSources = ['project', 'user', 'local'];

  // Emit `stream_event` partial messages so the run loop can forward text and
  // thinking deltas to the client while the model is still generating. The
  // complete `assistant` message that follows each stream stays authoritative
  // (and is the only copy the CLI writes to the JSONL transcript).
  sdkOptions.includePartialMessages = true;

  // The SDK resumes with the provider-native session id, never the app id.
  if (providerSessionId) {
    sdkOptions.resume = providerSessionId;
  }

  return sdkOptions;
}

/**
 * Adds a session to the active sessions map
 * @param {string} sessionId - Session identifier
 * @param {Object} queryInstance - SDK query instance
 * @param {Object} writer - WebSocket writer for reconnect support
 * @param {Function} releaseInput - Closes the held stdin stream so the CLI can exit
 * @param {Function} injectTurn - Feeds a new user turn into this live process
 * @param {Function} steerTurn - Feeds a user message into the turn running now
 * @param {Function} applyPermissionMode - Switches the live process's permission mode
 */
function addSession(sessionId: any, queryInstance: any, writer: any = null, releaseInput: any = null, injectTurn: any = null, steerTurn: any = null, applyPermissionMode: any = null) {
  const existing = activeSessions.get(sessionId);
  // A different live instance under the same key means an earlier run was
  // superseded without being stopped (e.g. an abort that raced run setup and
  // found nothing to interrupt). Overwriting it here would strand its
  // generator forever — this map entry is the only handle for interrupting
  // it. Stop it directly rather than via abortClaudeSDKSession, whose
  // instance-owned abort flag would be consumed by the new run
  // and suppress its terminal `complete`.
  const superseding = Boolean(
    existing && existing.status === 'active' && existing.instance && existing.instance !== queryInstance
  );
  if (superseding) {
    supersededInstances.add(existing.instance);
    Promise.resolve()
      .then(() => existing.instance.interrupt())
      .catch((error: any) => {
        console.error(`Error interrupting superseded run for session ${sessionId}:`, error?.message || error);
      });
    existing.releaseInput?.();
  }
  const carried = existing?.instance === queryInstance ? existing : null;
  activeSessions.set(sessionId, {
    instance: queryInstance,
    startTime: carried?.startTime || Date.now(),
    status: 'active',
    writer,
    // Re-registered mid-run once the provider session id lands; keep the closer.
    releaseInput: releaseInput || carried?.releaseInput || null,
    injectTurn: injectTurn || carried?.injectTurn || null,
    steerTurn: steerTurn || carried?.steerTurn || null,
    applyPermissionMode: applyPermissionMode || carried?.applyPermissionMode || null
  });
}

/**
 * Removes a session from the active sessions map
 * @param {string} sessionId - Session identifier
 */
function removeSession(sessionId: any) {
  activeSessions.delete(sessionId);
  // Interactive approvals never time out, so any still waiting on this
  // session must be settled here — otherwise they leak as phantom approvals.
  cancelPendingToolApprovalsForSession(sessionId);
}

/**
 * Gets a session from the active sessions map
 * @param {string} sessionId - Session identifier
 * @returns {Object|undefined} Session data or undefined
 */
function getSession(sessionId: any) {
  return activeSessions.get(sessionId);
}

/**
 * Gets all active session IDs
 * @returns {Array<string>} Array of active session IDs
 */
function getAllSessions() {
  return Array.from(activeSessions.keys());
}

/**
 * Transforms SDK messages to WebSocket format expected by frontend
 * @param {Object} sdkMessage - SDK message object
 * @returns {Object} Transformed message ready for WebSocket
 */
function transformMessage(sdkMessage: any) {
  // Extract parent_tool_use_id for subagent tool grouping
  if (sdkMessage.parent_tool_use_id) {
    return {
      ...sdkMessage,
      parentToolUseId: sdkMessage.parent_tool_use_id
    };
  }
  return sdkMessage;
}

function readNumber(value: any) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

/**
 * Builds a `token_budget` snapshot from one API step's `message.usage`. Only
 * per-step usage measures the context: `result.usage`/`modelUsage` sum every
 * step of the turn and would overshoot the window on tool-heavy turns.
 */
function buildTokenBudget(messageUsage: AnyRecord, contextWindow: number) {
  const directInputTokens = readNumber(messageUsage.input_tokens ?? messageUsage.inputTokens);
  const cacheCreationTokens = readNumber(messageUsage.cache_creation_input_tokens ?? messageUsage.cacheCreationInputTokens ?? messageUsage.cacheCreationTokens);
  const cacheReadTokens = readNumber(messageUsage.cache_read_input_tokens ?? messageUsage.cacheReadInputTokens ?? messageUsage.cacheReadTokens);
  const cacheTokens = cacheCreationTokens + cacheReadTokens;
  const inputTokens = directInputTokens + cacheTokens;
  const outputTokens = readNumber(messageUsage.output_tokens ?? messageUsage.outputTokens);

  return {
    used: inputTokens + outputTokens,
    total: contextWindow,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheCreationTokens,
    cacheTokens,
    breakdown: {
      input: inputTokens,
      output: outputTokens,
    },
  };
}

// Tool calls that leave work running past the end of a turn. Bash only counts
// when it is explicitly backgrounded; the rest defer or watch work by nature.
const DEFERRED_WORK_TOOLS = new Set(['Monitor', 'ScheduleWakeup', 'CronCreate', 'TaskCreate']);

/**
 * Detects tool calls that keep working after the turn's `result` arrives.
 *
 * Only turns that start background work need their CLI process held open; every
 * other turn can let it exit immediately, as it did before the hold existed.
 *
 * @param {Object} sdkMessage - SDK stream message
 * @returns {boolean} True when the message launches work that outlives the turn
 */
function startsBackgroundWork(sdkMessage: any) {
  const content = sdkMessage?.message?.content;
  if (!Array.isArray(content)) {
    return false;
  }

  return content.some((block: any) => {
    if (block?.type !== 'tool_use') {
      return false;
    }
    if (block.name === 'Bash') {
      return block.input?.run_in_background === true;
    }
    return DEFERRED_WORK_TOOLS.has(block.name);
  });
}

const TERMINAL_TASK_STATUSES = new Set(['completed', 'failed', 'stopped', 'killed']);

/**
 * One running background task as the client lists it — the CLI's own
 * description ("Run the checkout tests") and kind (`local_bash`,
 * `local_agent`, …). Consumed by queryClaudeSDK and the runtime tests.
 */
export type BackgroundTask = { id: string; description: string; type: string | null };

/**
 * Keeps `outstanding` in sync with the SDK's task lifecycle events.
 *
 * The CLI reports every subagent, background shell and workflow it starts via
 * `task_started` and settles it with `task_notification` / a terminal
 * `task_updated`. stdin is the CLI's only channel back to us — permission asks
 * from those tasks travel over it — so it must stay open while any of them is
 * still running, not just while the latest turn launched something.
 * Ambient housekeeping tasks (`skip_transcript`) are ignored so they can't hold
 * the process open on their own.
 *
 * Consumed by queryClaudeSDK (hold decision) and the runtime tests.
 *
 * @param {Map<string, BackgroundTask>} outstanding - Running tasks by id; mutated in place
 * @param {Object} sdkMessage - SDK stream message
 */
export function trackBackgroundTask(outstanding: Map<string, BackgroundTask>, sdkMessage: any): void {
  if (sdkMessage?.type !== 'system' || typeof sdkMessage.task_id !== 'string') {
    return;
  }
  switch (sdkMessage.subtype) {
    case 'task_started':
      if (!sdkMessage.skip_transcript) {
        outstanding.set(sdkMessage.task_id, {
          id: sdkMessage.task_id,
          description: typeof sdkMessage.description === 'string' ? sdkMessage.description : '',
          type: typeof sdkMessage.task_type === 'string' ? sdkMessage.task_type : null,
        });
      }
      break;
    case 'task_notification':
      outstanding.delete(sdkMessage.task_id);
      break;
    case 'task_updated':
      if (TERMINAL_TASK_STATUSES.has(sdkMessage.patch?.status)) {
        outstanding.delete(sdkMessage.task_id);
      }
      break;
    default:
      break;
  }
}

/**
 * Builds the SDK user messages for one turn.
 *
 * Always returns SDKUserMessage records rather than a bare string: a string
 * prompt makes the SDK flag the query as single-turn and close stdin the moment
 * the turn's `result` arrives, which kills the CLI's background tasks. Plain
 * text turns carry string content; turns with image attachments carry the
 * prompt text plus one base64 `image` block per attachment (read from the
 * global `~/.ddagent/assets` folder).
 *
 * @param {string} command - User prompt
 * @param {Array} images - Image descriptors ({ path, name?, mimeType? })
 * @param {Array} files - Non-image attachment descriptors
 * @param {string} cwd - Project working directory attachment paths resolve against
 * @returns {Promise<Array<Object>>} SDKUserMessage records for the turn
 */
async function buildPromptMessages(command: any, images: any, files: any, cwd: any) {
  const promptWithFiles = appendFilesInputTag(command, files);
  const content = normalizeImageDescriptors(images).length === 0
    ? promptWithFiles
    : await buildClaudeUserContent(promptWithFiles, images, cwd);

  return [{
    type: 'user',
    message: {
      role: 'user',
      content
    },
    parent_tool_use_id: null,
    timestamp: new Date().toISOString()
  }];
}

/**
 * Wraps prompt messages in an async iterable that yields them and then parks.
 *
 * The SDK closes the CLI's stdin as soon as its input iterable is exhausted (and
 * immediately on `result` for string prompts). The CLI reads that EOF as the end
 * of the run and kills anything still going in the background, so the iterable
 * has to stay pending until we actually want the process gone.
 *
 * `push` feeds a later user turn into the same live process (see injectTurn in
 * queryClaudeSDK); it returns false once the stream has been released.
 *
 * @param {Array<Object>} messages - SDKUserMessage records to send
 * @returns {{ stream: AsyncIterable, release: () => void, push: (messages: Array<Object>) => boolean }}
 */
function createHeldPromptStream(messages: any) {
  const queue: any[] = [...messages];
  let released = false;
  let wake: (() => void) | null = null;
  const wakeUp = () => {
    const resolve = wake;
    wake = null;
    resolve?.();
  };

  const stream = (async function* () {
    while (true) {
      while (queue.length > 0) {
        yield queue.shift();
      }
      // Keeps stdin open — the CLI stays alive until release() is called.
      if (released) return;
      await new Promise<void>((resolve) => { wake = resolve; });
    }
  })();

  const release = () => {
    released = true;
    wakeUp();
  };
  const push = (more: any[]) => {
    if (released) return false;
    queue.push(...more);
    wakeUp();
    return true;
  };

  return { stream, release, push };
}

/**
 * Loads MCP server configurations from ~/.claude.json
 * @param {string} cwd - Current working directory for project-specific configs
 * @returns {Object|null} MCP servers object or null if none found
 */
async function loadMcpConfig(cwd: any) {
  try {
    const claudeConfigPath = path.join(os.homedir(), '.claude.json');

    // Check if config file exists
    try {
      await fs.access(claudeConfigPath);
    } catch (error: any) {
      // File doesn't exist, return null
      // No config file
      return null;
    }

    // Read and parse config file
    let claudeConfig;
    try {
      const configContent = await fs.readFile(claudeConfigPath, 'utf8');
      claudeConfig = JSON.parse(configContent);
    } catch (error: any) {
      console.error('Failed to parse ~/.claude.json:', error.message);
      return null;
    }

    // Extract MCP servers (merge global and project-specific)
    let mcpServers: any = {};

    // Add global MCP servers
    if (claudeConfig.mcpServers && typeof claudeConfig.mcpServers === 'object') {
      mcpServers = { ...claudeConfig.mcpServers };
      // Global MCP servers loaded
    }

    // Add/override with project-specific MCP servers
    if (claudeConfig.projects && cwd) {
      const projectConfig = claudeConfig.projects[cwd];
      if (projectConfig && projectConfig.mcpServers && typeof projectConfig.mcpServers === 'object') {
        mcpServers = { ...mcpServers, ...projectConfig.mcpServers };
        // Project MCP servers merged
      }
    }

    // Return null if no servers found
    if (Object.keys(mcpServers).length === 0) {
      return null;
    }
    return mcpServers;
  } catch (error: any) {
    console.error('Error loading MCP config:', error.message);
    return null;
  }
}

/**
 * Executes a Claude query using the SDK
 * @param {string} command - User prompt/command
 * @param {Object} options - Query options
 * @param {Object} ws - WebSocket connection
 * @param {Object} context - Provider-scoped model, session, and auth lookups
 * @returns {Promise<void>}
 */
// Consumed by provider runtime services and lifecycle tests.
export async function queryClaudeSDK(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
  const { sessionId, sessionSummary } = options;
  // Callers pass the stable app session id; the SDK only understands the
  // provider-native id recorded on the session row.
  const providerSessionId = context.resolveProviderSessionId(sessionId);
  // Provider-native id as the SDK reports it (starts as the resume id, or is
  // captured from the stream for brand-new sessions).
  let capturedSessionId = providerSessionId;
  let sessionCreatedSent = false;
  // Process-map key: the app session id when the caller supplied one, else
  // the provider-native id once captured (legacy/direct API callers).
  const sessionKey = () => sessionId || capturedSessionId || null;

  const emitNotification = (event: any) => {
    notifyUserIfEnabled({
      userId: ws?.userId || null,
      event
    });
  };

  // Closes the held stdin stream so the CLI can wind down. Replaced once the
  // stream exists; the finally block calls it no matter how the run ends.
  let releasePromptStream = () => {};
  // Feeds another user turn into the held stream; replaced alongside the closer.
  let pushPrompt = (_messages: any[]) => false;
  let idleReleaseTimer: any = null;
  // The client is told the turn is over as soon as `result` lands, even though
  // the process lingers, so the UI never waits out the idle hold.
  let turnCompleteSent = false;
  // The SDK may also throw on the CLI's non-zero exit after a failed `result`;
  // that throw repeats a failure the client already saw.
  let turnFailureReported = false;
  // Set when a turn starts background work, cleared when the next `result`
  // arrives — only turns with work still outstanding hold their process open.
  let backgroundWorkPending = false;
  // True while the process is being held open for background work, so a later
  // `result` can be recognised as that work reporting back.
  let heldForBackgroundWork = false;
  // Tasks (subagents, background shells, workflows) the CLI reported as started
  // and not yet settled — they can outlive several turns.
  const outstandingTasks = new Map<string, BackgroundTask>();
  // Last task count sent to the client, so it only hears about changes.
  let reportedTaskCount = 0;
  // A task settled since the last `result` — its report is still to come.
  let taskSettledThisTurn = false;
  // False between a turn's `result` and the next turn's first message.
  let turnActive = true;
  // True while the current turn was started by the CLI itself (a background
  // task reporting back, a scheduled wake-up) rather than by a user message.
  let turnIsFollowUp = false;
  // A user turn fed into this process by a later queryClaudeSDK call: it waits
  // in `pending` until the CLI replays its uuid, then becomes `active` until its
  // `result`. `settle` resolves the injecting call (false = run it elsewhere).
  type TurnInjection = { uuid: string; writer: ProviderRuntimeWriter; settle: (accepted: boolean) => void };
  let pendingInjection = null as TurnInjection | null;
  let activeInjection = null as TurnInjection | null;
  // Uuids of user messages steered into a running turn that the CLI has not
  // replayed yet. While any is outstanding at `result`, the CLI will run it as
  // a turn of its own, so stdin must stay open for it.
  const unreplayedSteers = new Set<string>();
  // Latest main-agent API step usage/model: the context gauge's source, re-sent
  // on `result` once the SDK has reported the model's real context window.
  let lastStepUsage: AnyRecord | null = null;
  let lastStepModel: string | null = null;
  // Context window this CLI process reported (`getContextUsage()` right after
  // spawn, then every `result.modelUsage`); 0 until it does. Without it the
  // first turn of a session — or any turn after a server restart — would be
  // sized against the 200k fallback until its `result` arrived.
  let reportedContextWindow = 0;

  // Sends the context gauge for the latest main-agent step, if there is one.
  const sendTokenBudget = () => {
    if (!lastStepUsage) return;
    const contextWindow = reportedContextWindow || resolveClaudeContextWindow(capturedSessionId, lastStepModel);
    const tokenBudget = buildTokenBudget(lastStepUsage, contextWindow);
    ws.send(createNormalizedMessage({ kind: 'status', text: 'token_budget', tokenBudget, sessionId: capturedSessionId || sessionId || null, provider: 'claude' }));
  };

  // Keeps a reported window for this run, REST snapshots, and the session row
  // (so the gauge still shows it after a server restart).
  const adoptContextWindow = (contextWindow: number, model: string | null) => {
    if (!(contextWindow > 0)) return;
    reportedContextWindow = contextWindow;
    recordClaudeContextWindow(capturedSessionId, model, contextWindow);
    if (!sessionId) return;
    try {
      sessionsDb.setSessionContextWindow(String(sessionId), contextWindow);
    } catch (error: any) {
      console.warn('[claude] Failed to persist the context window:', error?.message || error);
    }
  };

  // Sends the running background tasks (count plus what each one is) to the
  // writer of the current turn.
  const reportBackgroundTasks = () => {
    reportedTaskCount = outstandingTasks.size;
    ws.send(createNormalizedMessage({
      kind: 'background_tasks',
      count: reportedTaskCount,
      tasks: [...outstandingTasks.values()],
      sessionId: capturedSessionId || sessionId || null,
      provider: 'claude',
    }));
  };

  // Arms (or re-arms) the idle countdown that eventually closes stdin.
  const scheduleRelease = (delayMs = BG_WAIT_CEILING_MS) => {
    if (idleReleaseTimer) {
      clearTimeout(idleReleaseTimer);
      idleReleaseTimer = null;
    }
    idleReleaseTimer = setTimeout(() => {
      idleReleaseTimer = null;
      releasePromptStream();
    }, delayMs);
    // Never let the hold keep the server process alive on its own.
    idleReleaseTimer.unref?.();
  };

  // Hoisted above the try so the catch's cleanup can tell whether this run
  // still owns the activeSessions entry (or was superseded by a newer run).
  let queryInstance: any = null;
  // Whether the user stopped this run (the abort flag itself is consumed on wind-down).
  let stoppedByUser = false;
  // Key an early abort is parked under until the query is registered.
  const startKey = sessionKey();
  if (startKey) startingRuns.add(startKey);
  // `error` code of the latest main-agent assistant message (auth, rate limit…).
  let lastAssistantError: string | null = null;

  try {
    const resolvedModel = await context.resolveResumeModel(sessionId, options.model);
    let effortModels = CLAUDE_PREDEFINED_MODELS;
    try {
      effortModels = await context.getProviderModels();
    } catch (error: any) {
      console.warn('[Claude SDK] Unable to load provider models for effort validation:', error);
    }

    const delegated = isDelegatedChildSession(sessionId);
    const sdkOptions = mapCliOptionsToSDK({
      ...options,
      delegated,
      providerSessionId,
      model: resolvedModel || options.model,
      effortModels,
    });
    // Re-apply this session's "Always" rules to the new turn (same key they
    // were stored under, so legacy provider-id callers keep them too).
    for (const entry of sessionRememberedTools.get(sessionKey()) ?? []) {
      if (!sdkOptions.allowedTools.includes(entry)) sdkOptions.allowedTools.push(entry);
    }

    // Local bypass flag for interactive runs — never an SDK option, so strip
    // it before query() sees the bag.
    const interactiveBypass = sdkOptions.interactiveBypass === true;
    delete sdkOptions.interactiveBypass;

    const mcpServers = await loadMcpConfig(options.cwd);
    if (mcpServers) {
      sdkOptions.mcpServers = mcpServers;
    }

    // Every turn uses streaming input so stdin stays open past the turn's
    // `result`. The message list is reusable, but each query attempt needs its
    // own stream because an async generator cannot be replayed once consumed.
    const promptMessages = await buildPromptMessages(command, options.images, options.files, options.cwd);

    // Everything the CLI was spawned with, minus what may differ between turns
    // of one conversation without needing a new process: the resume id, the
    // allow-list (merged into the live run instead) and the permission mode
    // (switched live via setPermissionMode). Two runs with the same signature
    // can share a process.
    const { resume: _resume, allowedTools: _allowedTools, permissionMode: _permissionMode, ...spawnShape } = sdkOptions;
    const runSignature = JSON.stringify(spawnShape);

    // A process still held open for this session's background work (running
    // subagents, shells, watchers) takes the new turn on its stdin — spawning
    // a replacement would close that stdin and with it the only channel those
    // tasks have for permission asks. Falls back to a fresh process when the
    // held one can't take it (different model, mode, cwd, MCP config…).
    const heldSession = sessionKey() ? getSession(sessionKey()) : undefined;
    if (heldSession?.injectTurn) {
      const accepted = await heldSession.injectTurn({
        messages: promptMessages,
        writer: ws,
        signature: runSignature,
        allowedTools: sdkOptions.allowedTools,
        permissionMode: options.permissionMode,
      });
      if (accepted) return;
    }
    // Stopped while the run was still being set up: never spawn the CLI.
    if (startKey && pendingAborts.delete(startKey)) {
      stoppedByUser = true;
      return;
    }
    // Otherwise this turn supersedes any earlier one still holding the
    // session's process open, so held runs cannot stack up.
    if (sessionKey()) {
      getSession(sessionKey())?.releaseInput?.();
    }

    // Echo each user message back once the CLI starts processing it — the
    // echo's uuid tells an injected turn's output apart from whatever the
    // process was doing before.
    sdkOptions.extraArgs = { ...(sdkOptions.extraArgs || {}), 'replay-user-messages': null };

    sdkOptions.hooks = {
      Notification: [{
        matcher: '',
        hooks: [async (input: any) => {
          const message = typeof input?.message === 'string' ? input.message : 'Claude requires your attention.';
          // Notifications are app-facing, so they carry the app session id.
          emitNotification((createNotificationEvent as (input: any) => any)({
            provider: 'claude',
            sessionId: sessionId || capturedSessionId || null,
            kind: 'action_required',
            code: 'agent.notification',
            meta: { message, sessionName: sessionSummary },
            severity: 'warning',
            requiresUserAction: true,
            dedupeKey: `claude:hook:notification:${sessionId || capturedSessionId || 'none'}:${message}`
          }));
          return {};
        }]
      }]
    };

    // Interactive runs handle bypass inside this callback (non-interactive
    // tools auto-allow, AskUserQuestion/ExitPlanMode still reach the UI).
    // Caveat: in 'auto' mode and for headless delegated children the SDK
    // resolves approval at the permission-mode step and skips this callback —
    // interactive tools won't reach the UI there; the classifier/bypass
    // auto-approves them and the model acts on a generated answer.
    let bypassActive = interactiveBypass || sdkOptions.permissionMode === 'bypassPermissions';
    // The mode the CLI process is in right now (kept in sync with its status events).
    let liveSdkMode: string = sdkOptions.permissionMode || 'default';
    // Applies a permission-mode change to the running process instead of
    // respawning it; bypass stays emulated in canUseTool as at spawn.
    const applyPermissionMode = (mode: any) => {
      const next = resolvePermissionModeState(mode, options.toolsSettings?.skipPermissions, delegated);
      bypassActive = next.interactiveBypass || next.sdkMode === 'bypassPermissions';
      if (next.sdkMode === liveSdkMode || typeof queryInstance?.setPermissionMode !== 'function') return;
      const previous = liveSdkMode;
      liveSdkMode = next.sdkMode;
      Promise.resolve(queryInstance.setPermissionMode(next.sdkMode)).catch((error: any) => {
        // A rejected switch leaves the CLI where it was, so a later switch back is not skipped.
        if (liveSdkMode === next.sdkMode) liveSdkMode = previous;
        console.warn('[claude] Failed to switch the live permission mode:', error?.message || error);
      });
    };

    // A full elicitation form is out of scope: decline, but tell the user.
    sdkOptions.onElicitation = async (request: AnyRecord) => {
      ws.send(createNormalizedMessage({
        kind: 'status',
        text: `MCP server "${request?.serverName || 'unknown'}" asked for input${request?.message ? ` ("${request.message}")` : ''} — declined, not supported here.`,
        notice: true,
        sessionId: capturedSessionId || sessionId || null,
        provider: 'claude',
      }));
      return { action: 'decline' };
    };

    sdkOptions.canUseTool = async (toolName: any, input: any, context: any) => {
      const requiresInteraction = TOOLS_REQUIRING_INTERACTION.has(toolName);

      if (!requiresInteraction) {
        if (bypassActive) {
          return { behavior: 'allow', updatedInput: input };
        }

        const isDisallowed = (sdkOptions.disallowedTools || []).some((entry: any) =>
          matchesToolPermission(entry, toolName, input)
        );
        if (isDisallowed) {
          return { behavior: 'deny', message: 'Tool disallowed by settings' };
        }

        const isAllowed = (sdkOptions.allowedTools || []).some((entry: any) =>
          matchesToolPermission(entry, toolName, input)
        );
        if (isAllowed) {
          return { behavior: 'allow', updatedInput: input };
        }
      }

      const requestId = createRequestId();
      const rememberEntry = claudeRememberEntry(toolName, input);
      // The SDK's own prompt sentence ("Claude wants to read foo.txt") is the
      // card text; a subagent's ask is marked so it isn't mistaken for the
      // main agent's.
      const askContext = {
        ...(rememberEntry ? { rememberEntry } : {}),
        ...(typeof context?.agentID === 'string' && context.agentID ? { agentId: context.agentID } : {}),
      };
      const promptText = [context?.title, context?.decisionReason]
        .filter((part: unknown) => typeof part === 'string' && part.trim())
        .join(' — ');
      ws.send(createNormalizedMessage({
        kind: 'permission_request',
        requestId,
        toolName,
        input,
        ...(promptText ? { content: promptText } : {}),
        ...(Object.keys(askContext).length ? { context: askContext } : {}),
        sessionId: capturedSessionId || sessionId || null,
        provider: 'claude',
      }));
      emitNotification((createNotificationEvent as (input: any) => any)({
        provider: 'claude',
        sessionId: sessionId || capturedSessionId || null,
        kind: 'action_required',
        code: 'permission.required',
        meta: {
          toolName,
          sessionName: sessionSummary,
          // Remote approval channels (Telegram) need the requestId to resolve
          // the pending tool call; inputPreview gives the user a glanceable
          // summary without leaking the full input.
          requestId,
          inputPreview: (() => {
            try {
              const raw = typeof input === 'string' ? input : JSON.stringify(input);
              return raw && raw.length > 300 ? `${raw.slice(0, 297)}...` : raw;
            } catch {
              return null;
            }
          })(),
        },
        severity: 'warning',
        requiresUserAction: true,
        dedupeKey: `claude:permission:${sessionId || capturedSessionId || 'none'}:${requestId}`
      }));

      const decision = await waitForToolApproval(requestId, {
        timeoutMs: requiresInteraction ? 0 : undefined,
        signal: context?.signal,
        metadata: {
          // Keyed by the app session id so `chat.subscribe` can look pending
          // approvals up directly; provider id only for legacy callers.
          _sessionId: sessionId || capturedSessionId || null,
          _toolName: toolName,
          _input: input,
          _context: Object.keys(askContext).length ? askContext : undefined,
          _receivedAt: new Date(),
        },
        onCancel: (reason: any) => {
          ws.send(createNormalizedMessage({ kind: 'permission_cancelled', requestId, reason, sessionId: capturedSessionId || sessionId || null, provider: 'claude' }));
        }
      });
      if (!decision) {
        return { behavior: 'deny', message: 'Permission request timed out' };
      }

      if (decision.cancelled) {
        return { behavior: 'deny', message: 'Permission request cancelled' };
      }

      if (decision.allow) {
        const rule = scopeRememberedRule(rememberEntry, decision.rememberEntry, toolName, options.cwd);
        if (rule) {
          if (!sdkOptions.allowedTools.includes(rule)) {
            sdkOptions.allowedTools.push(rule);
          }
          const rememberKey = sessionKey();
          if (rememberKey) {
            const remembered = sessionRememberedTools.get(rememberKey) ?? new Set<string>();
            remembered.add(rule);
            sessionRememberedTools.set(rememberKey, remembered);
          }
          if (Array.isArray(sdkOptions.disallowedTools)) {
            sdkOptions.disallowedTools = sdkOptions.disallowedTools.filter((entry: any) => entry !== rule);
          }
        }
        // An approved plan takes the CLI out of plan mode; record that so the
        // next turn is not respawned with --permission-mode plan.
        if (toolName === 'ExitPlanMode' && liveSdkMode === 'plan') {
          liveSdkMode = 'default';
          if (sessionId) {
            try {
              sessionsDb.setSessionPermissionMode(String(sessionId), 'default');
            } catch (error: any) {
              console.warn('[claude] Failed to persist the post-plan permission mode:', error?.message || error);
            }
          }
        }
        return { behavior: 'allow', updatedInput: decision.updatedInput ?? input };
      }

      // The user's feedback (e.g. on a rejected plan) is what the model reads.
      return { behavior: 'deny', message: decision.message || 'User denied tool use' };
    };

    let heldPrompt = createHeldPromptStream(promptMessages);
    releasePromptStream = heldPrompt.release;
    pushPrompt = heldPrompt.push;
    try {
      queryInstance = query({
        prompt: heldPrompt.stream,
        options: sdkOptions
      });
    } catch (hookError: any) {
      // Older/newer SDK versions may not accept hook shapes yet.
      // Keep notification behavior operational via runtime events even if hook registration fails.
      console.warn('Failed to initialize Claude query with hooks, retrying without hooks:', hookError?.message || hookError);
      delete sdkOptions.hooks;
      // Discard the abandoned stream and build a fresh one for the retry.
      heldPrompt.release();
      heldPrompt = createHeldPromptStream(promptMessages);
      releasePromptStream = heldPrompt.release;
      pushPrompt = heldPrompt.push;
      queryInstance = query({
        prompt: heldPrompt.stream,
        options: sdkOptions
      });
    }

    // Called by a later queryClaudeSDK for this session (see heldSession
    // above). Resolves true once the injected turn has finished here, false
    // when this process can't take it and the caller must spawn its own.
    const injectTurn = (request: {
      messages: any[];
      writer: ProviderRuntimeWriter;
      signature: string;
      allowedTools: string[];
      permissionMode?: string;
    }): Promise<boolean> => {
      const unavailable = !heldForBackgroundWork
        || pendingInjection !== null
        || activeInjection !== null
        || request.signature !== runSignature
        || supersededInstances.has(queryInstance)
        || abortedInstances.has(queryInstance);
      if (unavailable) return Promise.resolve(false);

      const uuid = crypto.randomUUID();
      return new Promise<boolean>((resolve) => {
        pendingInjection = { uuid, writer: request.writer, settle: resolve };
        // The turn's mode reaches the CLI before its prompt (same stdin, in order).
        applyPermissionMode(request.permissionMode);
        if (!pushPrompt(request.messages.map((message) => ({ ...message, uuid })))) {
          pendingInjection = null;
          resolve(false);
          return;
        }
        // "Always" rules granted since this process started apply here too.
        for (const entry of request.allowedTools) {
          if (!sdkOptions.allowedTools.includes(entry)) sdkOptions.allowedTools.push(entry);
        }
        if (idleReleaseTimer) scheduleRelease();
      });
    };

    // Called by steerClaudeSDKSession: pushes a user message onto the live
    // stdin while a turn runs. The CLI folds it into that turn at its next
    // step (or, if the turn is already wrapping up, runs it right after).
    const steerTurn = (messages: any[]): boolean => {
      if (!turnActive
        || supersededInstances.has(queryInstance)
        || abortedInstances.has(queryInstance)) {
        return false;
      }
      const uuid = crypto.randomUUID();
      if (!pushPrompt(messages.map((message) => ({ ...message, uuid })))) return false;
      unreplayedSteers.add(uuid);
      return true;
    };

    // Points the run's output at the writer of the turn that is starting, so
    // its events reach the chat run the client is watching for that turn.
    const beginTurn = (writer: ProviderRuntimeWriter | null) => {
      turnActive = true;
      if (!writer) return;
      ws = writer;
      turnCompleteSent = false;
      turnFailureReported = false;
      const entry = sessionKey() ? getSession(sessionKey()) : undefined;
      if (entry?.instance === queryInstance) entry.writer = writer;
      // The new turn's run starts with the live task list, so the client never
      // keeps a count from a run it no longer listens to.
      reportBackgroundTasks();
    };

    // Track the query instance for abort capability
    if (sessionKey()) {
      addSession(sessionKey(), queryInstance, ws, releasePromptStream, injectTurn, steerTurn, applyPermissionMode);
    }
    // From here an abort finds the registered query directly.
    if (startKey) startingRuns.delete(startKey);
    // A fresh process has no background tasks yet. Saying so clears a count
    // a previous process left behind on the client (its own final 0 can be
    // dropped once a newer run owns the session).
    reportBackgroundTasks();

    // The CLI knows the model's window as soon as it starts; ask instead of
    // waiting for the turn's `result`. Never blocks the stream.
    if (typeof queryInstance.getContextUsage === 'function') {
      queryInstance.getContextUsage().then((usage: AnyRecord) => {
        adoptContextWindow(readNumber(usage?.rawMaxTokens || usage?.maxTokens), usage?.model || null);
        if (turnActive) sendTokenBudget();
      }).catch(() => {
        // The process may already be gone; `result.modelUsage` still reports it.
      });
    }

    // Process streaming messages
    console.log('Starting async generator loop for session:', capturedSessionId || 'NEW');
    for await (const message of queryInstance) {
      // Capture session ID from first message
      if (message.session_id && !capturedSessionId) {

        capturedSessionId = message.session_id;
        addSession(sessionKey(), queryInstance, ws, releasePromptStream, injectTurn, steerTurn, applyPermissionMode);

        // Set session ID on writer
        if (ws.setSessionId && typeof ws.setSessionId === 'function') {
          ws.setSessionId(capturedSessionId);
        }

        // Send session-created event only once for sessions with nothing to resume
        if (!providerSessionId && !sessionCreatedSent) {
          sessionCreatedSent = true;
          ws.send(createNormalizedMessage({ kind: 'session_created', newSessionId: capturedSessionId, sessionId: capturedSessionId, provider: 'claude' }));
        }
      } else {
        // session_id already captured
      }

      // The CLI echoes each user message as it starts processing it. The echo
      // of an injected turn hands the output over to that turn's writer; no
      // echo is forwarded — the client already shows what the user sent.
      if (message.type === 'user' && message.isReplay) {
        if (pendingInjection && message.uuid === pendingInjection.uuid) {
          activeInjection = pendingInjection;
          pendingInjection = null;
          turnIsFollowUp = false;
          beginTurn(activeInjection.writer);
        } else if (unreplayedSteers.delete(message.uuid)) {
          // A steered message has no client-side bubble yet (it came out of
          // the queue): stream it as a user row where the agent picked it up.
          // Echoed after the turn ended, it opens a run of its own.
          if (!turnActive) {
            turnIsFollowUp = false;
            beginTurn(typeof options.openFollowUpRun === 'function' ? options.openFollowUpRun() : null);
          }
          for (const msg of context.normalizeMessage(message, capturedSessionId || sessionId || null)) {
            ws.send(msg);
          }
        }
        continue;
      }

      // Output with no turn in progress is a turn the CLI started on its own:
      // a background task reporting back or a scheduled wake-up. Give it a
      // chat run of its own so the client shows it working and streams it —
      // the previous turn's run is already sealed. Without one (a newer run
      // owns the session) its output is dropped as before.
      if (!turnActive && !message.parent_tool_use_id
        && (message.type === 'assistant' || message.type === 'stream_event')) {
        turnIsFollowUp = true;
        beginTurn(typeof options.openFollowUpRun === 'function' ? options.openFollowUpRun() : null);
      }

      // Transform and normalize message via adapter
      const transformedMessage = transformMessage(message);
      const sid = capturedSessionId || sessionId || null;

      // Use adapter to normalize SDK events into NormalizedMessage[]
      const normalized = context.normalizeMessage(transformedMessage, sid);
      for (const msg of normalized) {
        // Preserve parentToolUseId from SDK wrapper for subagent tool grouping
        if (transformedMessage.parentToolUseId && !msg.parentToolUseId) {
          msg.parentToolUseId = transformedMessage.parentToolUseId;
        }
        ws.send(msg);
      }

      const statusLine = claudeStatusLine(message);
      if (statusLine) {
        ws.send(createNormalizedMessage({
          kind: 'status',
          text: statusLine.text,
          ...(statusLine.notice ? { notice: true } : {}),
          sessionId: sid,
          provider: 'claude',
        }));
      }
      // The CLI reports its own mode switches (e.g. leaving plan mode).
      if (message.type === 'system' && typeof message.permissionMode === 'string') {
        liveSdkMode = message.permissionMode;
      }
      if (message.type === 'assistant' && !message.parent_tool_use_id) {
        lastAssistantError = typeof message.error === 'string' ? message.error : null;
      }

      // Token budget: per-step usage of the main agent (subagent steps carry
      // `parent_tool_use_id` and have their own context), sized against the
      // window the CLI reported.
      if (message.type === 'assistant' && !message.parent_tool_use_id && message.message?.usage) {
        lastStepUsage = message.message.usage;
        lastStepModel = message.message.model || lastStepModel;
        sendTokenBudget();
      } else if (message.type === 'result') {
        adoptContextWindow(rememberClaudeContextWindow(capturedSessionId, lastStepModel, message.modelUsage), lastStepModel);
        sendTokenBudget();
      }

      if (startsBackgroundWork(message)) {
        backgroundWorkPending = true;
      }
      const runningBefore = outstandingTasks.size;
      trackBackgroundTask(outstandingTasks, message);
      // Only mid-turn: a task settling between turns is already reported by
      // the follow-up turn that is about to start.
      if (outstandingTasks.size < runningBefore && turnActive) {
        taskSettledThisTurn = true;
      }
      if (outstandingTasks.size !== reportedTaskCount) {
        reportBackgroundTasks();
      }

      if (message.type === 'result') {
        // The turn is done as far as the client is concerned.
        turnActive = false;
        const followUp = turnIsFollowUp;
        turnIsFollowUp = false;
        const abortPending = sessionKey() ? abortedInstances.has(queryInstance) : false;
        const failure = describeClaudeResultFailure(message, lastAssistantError);
        lastAssistantError = null;
        if (!turnCompleteSent && !abortPending) {
          turnCompleteSent = true;
          // C3: the error goes out before `complete`, which seals the run.
          if (failure) {
            turnFailureReported = true;
            ws.send(createNormalizedMessage({ kind: 'error', content: failure, sessionId: capturedSessionId || sessionId || null, provider: 'claude' }));
          }
          ws.send(createCompleteMessage({ provider: 'claude', sessionId: capturedSessionId || sessionId || null, exitCode: failure ? 1 : 0 }));
          if (failure) {
            notifyRunFailed({
              userId: ws?.userId || null,
              provider: 'claude',
              sessionId: sessionId || capturedSessionId || null,
              sessionName: sessionSummary,
              error: failure
            });
          } else if (followUp) {
            notifyBackgroundWorkCompleted({
              userId: ws?.userId || null,
              provider: 'claude',
              sessionId: sessionId || capturedSessionId || null,
              sessionName: sessionSummary
            });
          } else {
            notifyRunStopped({
              userId: ws?.userId || null,
              provider: 'claude',
              sessionId: sessionId || capturedSessionId || null,
              sessionName: sessionSummary,
              stopReason: 'completed'
            });
          }
        } else if (followUp && !abortPending) {
          // A result after the turn already reported complete means the work we
          // held the process open for has finished and pushed a follow-up turn.
          notifyBackgroundWorkCompleted({
            userId: ws?.userId || null,
            provider: 'claude',
            sessionId: sessionId || capturedSessionId || null,
            sessionName: sessionSummary
          });
        }
        if (backgroundWorkPending || outstandingTasks.size > 0) {
          // Work started during this turn — or an earlier one, e.g. a second
          // subagent still running when the first reports back — is still
          // going. Hold the process open so it can finish, ask for permissions
          // and report back in a follow-up turn; the ceiling is only a backstop
          // for work that never reports.
          backgroundWorkPending = false;
          heldForBackgroundWork = true;
          scheduleRelease();
        } else if (taskSettledThisTurn || unreplayedSteers.size > 0) {
          // A task finished while this turn ran, or a steered message arrived
          // too late to join it: the CLI still has to run a follow-up turn.
          // Keep stdin open for it; that turn's own `result` closes it once
          // nothing is left.
          heldForBackgroundWork = true;
          scheduleRelease(FOLLOW_UP_GRACE_MS);
        } else {
          // Either nothing was backgrounded, or the background work just
          // reported in — let the CLI exit now, as it always has.
          heldForBackgroundWork = false;
          releasePromptStream();
        }
        taskSettledThisTurn = false;
        // The injected turn is over — its caller can return like a normal run.
        if (activeInjection) {
          activeInjection.settle(true);
          activeInjection = null;
        }
      } else if (idleReleaseTimer) {
        // Background activity after the turn — push the countdown back out.
        scheduleRelease();
      }
    }

    // Clean up session on completion — only while this run still owns the map
    // entry. A superseding run may have replaced it, and deleting here would
    // strand that run.
    if (sessionKey() && getSession(sessionKey())?.instance === queryInstance) {
      removeSession(sessionKey());
    }

    // A superseded run winds down silently: the map entry, the abort flag,
    // and all client-facing events belong to the run that replaced it.
    const superseded = supersededInstances.has(queryInstance);

    // Send the terminal completion event — skipped for aborted runs, whose
    // terminal `complete` (aborted: true) was already sent by abort-session, and
    // for runs that already reported completion when their `result` arrived.
    const wasAborted = !superseded && sessionKey() ? abortedInstances.delete(queryInstance) : false;
    stoppedByUser = wasAborted;
    if (!turnCompleteSent && !superseded) {
      turnCompleteSent = true;
      if (!wasAborted) {
        ws.send(createCompleteMessage({ provider: 'claude', sessionId: capturedSessionId || sessionId || null, exitCode: 0 }));
      }
      notifyRunStopped({
        userId: ws?.userId || null,
        provider: 'claude',
        sessionId: sessionId || capturedSessionId || null,
        sessionName: sessionSummary,
        stopReason: wasAborted ? 'aborted' : 'completed'
      });
    }
    // Complete

  } catch (error: any) {
    console.error('SDK query error:', error);

    // Clean up session on error — only while this run still owns the map entry
    // (a superseding run may have replaced it).
    if (sessionKey() && getSession(sessionKey())?.instance === queryInstance) {
      removeSession(sessionKey());
    }

    if (supersededInstances.has(queryInstance)) {
      // Interrupted because a newer run took over this session id; that run
      // owns the abort flag and all further client-facing events.
      return;
    }

    const wasAborted = sessionKey() ? abortedInstances.delete(queryInstance) : false;
    stoppedByUser = wasAborted;
    if (wasAborted) {
      // The abort already produced the terminal complete; a generator throw
      // caused by interrupt() is expected noise, not a user-facing error.
      return;
    }

    if (turnCompleteSent && turnFailureReported) {
      return;
    }

    // Check if Claude CLI is installed for a clearer error message
    const installed = await context.isProviderInstalled();
    const errorContent = !installed
      ? 'Claude Code is not installed. Please install it first: https://docs.anthropic.com/en/docs/claude-code'
      : error.message;

    // Send error to WebSocket, then the terminal complete. A run that already
    // reported completion and then failed during its post-turn hold still
    // surfaces the error, but must not emit a second terminal complete.
    ws.send(createNormalizedMessage({ kind: 'error', content: errorContent, sessionId: capturedSessionId || sessionId || null, provider: 'claude' }));
    if (!turnCompleteSent) {
      ws.send(createCompleteMessage({ provider: 'claude', sessionId: capturedSessionId || sessionId || null, exitCode: 1 }));
    }
    notifyRunFailed({
      userId: ws?.userId || null,
      provider: 'claude',
      sessionId: sessionId || capturedSessionId || null,
      sessionName: sessionSummary,
      error
    });
  } finally {
    // A spawned run cleared its own entries on registration; by now they may
    // belong to the session's next turn, which is still being set up.
    if (startKey && !queryInstance) {
      startingRuns.delete(startKey);
      pendingAborts.delete(startKey);
    }
    // Always close stdin — otherwise an aborted or failed run leaves the CLI
    // process (and its MCP servers) alive until the server exits.
    if (idleReleaseTimer) {
      clearTimeout(idleReleaseTimer);
      idleReleaseTimer = null;
    }
    releasePromptStream();
    // The process is gone: an injected turn the CLI never started goes back to
    // its caller to run in a fresh process — unless the user stopped it, in
    // which case it must not come back to life. A started one already got its
    // terminal events from this run.
    if (pendingInjection) {
      pendingInjection.settle(stoppedByUser || Boolean(queryInstance && abortedInstances.has(queryInstance)));
      pendingInjection = null;
    }
    if (activeInjection) {
      activeInjection.settle(true);
      activeInjection = null;
    }
    if (reportedTaskCount > 0) {
      outstandingTasks.clear();
      reportBackgroundTasks();
    }
  }
}

/**
 * Feeds a user message into the session's running turn (mid-turn steering).
 * Resolves false when no turn is live in this server's process for the
 * session, so the caller delivers the message as the next turn instead.
 */
// Consumed by the provider registry (runtime.steer) for the queue's "send now".
export async function steerClaudeSDKSession(sessionId: string, content: string, options: AnyRecord) {
  const session = getSession(sessionId);
  if (!session?.steerTurn || session.status !== 'active') {
    return false;
  }
  const messages = await buildPromptMessages(content, options.images, options.files, options.cwd);
  return Boolean(session.steerTurn(messages));
}

/**
 * Aborts an active SDK session
 * @param {string} sessionId - Session identifier
 * @returns {boolean} True if session was aborted, false if not found
 */
// Consumed by provider runtime services and lifecycle tests.
export async function abortClaudeSDKSession(sessionId: any) {
  const session = getSession(sessionId);

  if (!session) {
    // The run is still being set up: it checks this right before spawning.
    if (startingRuns.has(sessionId)) {
      pendingAborts.add(sessionId);
      return true;
    }
    console.log(`Session ${sessionId} not found`);
    return false;
  }

  try {
    console.log(`Aborting SDK session: ${sessionId}`);

    // Mark before interrupting so the run loop knows not to emit its own
    // terminal complete (the abort handler sends the aborted one).
    abortedInstances.add(session.instance);

    // Call interrupt() on the query instance
    await session.instance.interrupt();

    // Release the held stdin stream; without this the CLI stays up for the rest
    // of the post-turn hold even though the user cancelled.
    session.releaseInput?.();

    // Update session status
    session.status = 'aborted';

    // Clean up session
    if (getSession(sessionId) === session) {
      removeSession(sessionId);
    }
    // A turn still being set up next to a held process would otherwise spawn
    // a fresh CLI after this Stop: park the abort for it as well.
    if (startingRuns.has(sessionId)) pendingAborts.add(sessionId);

    return true;
  } catch (error: any) {
    console.error(`Error aborting session ${sessionId}:`, error);
    // The run keeps going; let it emit its own terminal complete.
    abortedInstances.delete(session.instance);
    return false;
  }
}

/**
 * Checks if an SDK session is currently active
 * @param {string} sessionId - Session identifier
 * @returns {boolean} True if session is active
 */
// Consumed by provider runtime services and lifecycle tests.
export function isClaudeSDKSessionActive(sessionId: any) {
  const session = getSession(sessionId);
  return session && session.status === 'active';
}

/**
 * Gets all active SDK session IDs
 * @returns {Array<string>} Array of active session IDs
 */
// Consumed by provider runtime services and lifecycle tests.
export function getActiveClaudeSDKSessions() {
  return getAllSessions();
}

/**
 * Get pending tool approvals for a specific session.
 * @param {string} sessionId - The session ID
 * @returns {Array} Array of pending permission request objects
 */
// Consumed by provider runtime services and lifecycle tests.
export function getPendingApprovalsForSession(sessionId: any) {
  const pending: any = [];
  for (const [requestId, resolver] of pendingToolApprovals.entries()) {
    if (resolver._sessionId === sessionId) {
      pending.push({
        requestId,
        toolName: resolver._toolName || 'UnknownTool',
        input: resolver._input,
        context: resolver._context,
        sessionId,
        receivedAt: resolver._receivedAt || new Date(),
      });
    }
  }
  return pending;
}

/**
 * Reconnect a session's WebSocketWriter to a new raw WebSocket.
 * Called when client reconnects (e.g. page refresh) while SDK is still running.
 * @param {string} sessionId - The session ID
 * @param {Object} newRawWs - The new raw WebSocket connection
 * @returns {boolean} True if writer was successfully reconnected
 */
// Consumed by provider runtime services and lifecycle tests.
export function reconnectSessionWriter(sessionId: any, newRawWs: any) {
  const session = getSession(sessionId);
  if (!session?.writer?.updateWebSocket) return false;
  session.writer.updateWebSocket(newRawWs);
  console.log(`[RECONNECT] Writer swapped for session ${sessionId}`);
  return true;
}

/**
 * Switches a running session's permission mode in place (no respawn). A
 * session without a live process picks the mode up from its next run.
 */
function setClaudeSDKSessionPermissionMode(sessionId: string, mode: string) {
  getSession(sessionId)?.applyPermissionMode?.(mode);
}

// Consumed by the provider registry for run, Stop and permission controls.
export const claudeRuntime: IProviderRuntime = {
  run: queryClaudeSDK,
  abort: abortClaudeSDKSession,
  steer: steerClaudeSDKSession,
  setPermissionMode: setClaudeSDKSessionPermissionMode,
  permissions: {
    resolve: resolveToolApproval,
    listPending: getPendingApprovalsForSession,
  },
};

// Export public API

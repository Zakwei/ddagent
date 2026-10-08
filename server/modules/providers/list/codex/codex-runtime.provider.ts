/**
 * OpenAI Codex SDK Integration
 * =============================
 *
 * This module provides integration with the OpenAI Codex SDK for non-interactive
 * chat sessions. It mirrors the Claude runtime adapter for consistency.
 *
 * ## Usage
 *
 * - codexRuntime.run(command, options, writer, context) - Execute a streamed prompt
 * - abortCodexSession(sessionId) - Cancel an active session
 * - isCodexSessionActive(sessionId) - Check if a session is running
 * - getActiveCodexSessions() - List all active sessions
 */

import os from 'node:os';
import path from 'node:path';

import { Codex } from '@openai/codex-sdk';

import type {
  AnyRecord,
  ProviderRuntimeWriter,
  IProviderRuntime,
} from '@/shared/index.js';
import {
  appendFilesInputTag,
  buildCodexInputItems,
  normalizeImageDescriptors,
  createCompleteMessage,
  createNormalizedMessage,
  providerChildEnv,
} from '@/shared/index.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';

import { readCodexRolloutContextUsage } from './codex-sessions.provider.js';

const activeCodexSessions = new Map<any, any>();

function readUsageNumber(value: any) {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
}

/**
 * Builds the live token budget for a finished turn. `turn.completed.usage` is
 * the thread-wide token sum (it grows past the context window), so it only
 * feeds the input/output counters; `used`/`total` come from the rollout's last
 * request (`context`), falling back to the catalog's window when the rollout
 * cannot be read yet. Returns null when there is no context reading at all.
 */
function extractCodexTokenBudget(event: any, context: { used: number; total: number } | null, catalogWindow: number) {
  if (!context) {
    return null;
  }
  const usage = event?.usage && typeof event.usage === 'object' ? event.usage : {};
  const cacheReadTokens = readUsageNumber(usage.cached_input_tokens);
  // Codex folds cached input into input_tokens; split it out like history.
  const inputTokens = Math.max(0, readUsageNumber(usage.input_tokens) - cacheReadTokens);
  const outputTokens = readUsageNumber(usage.output_tokens);

  return {
    used: context.used,
    total: context.total || catalogWindow || 200000,
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

// codex exec cannot ask for approval, so under `untrusted` a command outside
// the trusted list is refused; the refusal only shows in the item.
function isCodexApprovalRefusal(item: any) {
  return item?.type === 'command_execution'
    && (item.status === 'declined'
      || /rejected by user|declined by user|approval settings/i.test(String(item.aggregated_output ?? '')));
}

/**
 * Transform Codex SDK event to WebSocket message format
 * @param {object} event - SDK event
 * @returns {object} - Transformed event for WebSocket
 */
function transformCodexEvent(event: any) {
  // Map SDK event types to a consistent format
  switch (event.type) {
    case 'item.started':
    case 'item.updated':
    case 'item.completed':
      const item = event.item;
      if (!item) {
        return { type: event.type, item: null };
      }

      // Transform based on item type
      switch (item.type) {
        case 'agent_message':
          return {
            type: 'item',
            itemType: 'agent_message',
            message: {
              role: 'assistant',
              content: item.text
            }
          };

        case 'reasoning':
          return {
            type: 'item',
            itemType: 'reasoning',
            // Top-level marker: CodexSessionsProvider.normalizeHistoryEntry
            // reads `isReasoning` from the event root to pick the `thinking`
            // kind, matching the rows the rollout history produces.
            isReasoning: true,
            message: {
              role: 'assistant',
              content: item.text,
              isReasoning: true
            }
          };

        case 'command_execution':
          return {
            type: 'item',
            itemType: 'command_execution',
            command: item.command,
            output: item.aggregated_output,
            exitCode: item.exit_code,
            status: item.status
          };

        case 'file_change':
          return {
            type: 'item',
            itemType: 'file_change',
            changes: item.changes,
            status: item.status
          };

        case 'mcp_tool_call':
          return {
            type: 'item',
            itemType: 'mcp_tool_call',
            server: item.server,
            tool: item.tool,
            arguments: item.arguments,
            result: item.result,
            error: item.error,
            status: item.status
          };

        case 'web_search':
          return {
            type: 'item',
            itemType: 'web_search',
            query: item.query
          };

        case 'todo_list':
          return {
            type: 'item',
            itemType: 'todo_list',
            items: item.items
          };

        case 'error':
          return {
            type: 'item',
            itemType: 'error',
            text: item.message
          };

        default:
          return {
            type: 'item',
            itemType: item.type,
            item: item
          };
      }

    case 'turn.started':
      return {
        type: 'turn_started'
      };

    case 'turn.completed':
      return {
        type: 'turn_complete',
        usage: event.usage
      };

    case 'turn.failed':
      return {
        type: 'turn_failed',
        error: event.error
      };

    case 'thread.started':
      return {
        type: 'thread_started',
        threadId: event.thread_id || event.id
      };

    case 'error':
      return {
        type: 'error',
        message: event.message
      };

    default:
      return {
        type: event.type,
        data: event
      };
  }
}

// ---------------------------
//----------------- LIVE STREAM FORWARDING ------------
/**
 * Live-frame bookkeeping for one Codex run.
 *
 * The client renders live rows from `stream_replace` (assistant text) and
 * `thought_delta` (reasoning suffix) frames and finalizes them with
 * `stream_end`. Codex documents `item.started`/`item.updated` frames carrying a
 * full item snapshot (SDK `ThreadItem`; `AgentMessageItem`/`ReasoningItem`
 * expose the complete `text`), but codex-cli 0.146.0 only emits those frames
 * for non-message items, so message text still arrives at `item.completed` and
 * this state normally stays empty. Tracking snapshots per item id keeps the
 * forwarding correct the moment Codex starts emitting live message frames.
 */
function createCodexLiveStream() {
  return {
    /** Item id -> last snapshot text the client has already been shown. */
    items: new Map<any, any>(),
    /** Whether a live row is currently open on the client. */
    open: false,
  };
}

/**
 * Builds the live frames for one `item.started`/`item.updated` snapshot.
 *
 * Assistant text snapshots are cumulative, so they are forwarded as
 * `stream_replace`, which swaps the open live row's content. Thinking has no
 * replacement kind, so a reasoning snapshot is reduced to the suffix added
 * since the previous snapshot and sent as `thought_delta`; a snapshot that is
 * not a strict extension of the previous one cannot be expressed safely and is
 * skipped. Every non-message item keeps its completion-only handling.
 *
 * @param {object} item - Codex `ThreadItem` from the SDK event
 * @param {object} liveStream - State from createCodexLiveStream()
 * @param {string|null} sessionId - Session id for the emitted frames
 * @returns {object[]} - Normalized live frames to send
 */
function buildCodexLiveSnapshotMessages(item: any, liveStream: any, sessionId: any) {
  if (!item || (item.type !== 'agent_message' && item.type !== 'reasoning')) {
    return [];
  }

  const text = typeof item.text === 'string' ? item.text : '';
  const previous = liveStream.items.get(item.id) || '';
  if (!text.trim() || text === previous) {
    return [];
  }

  if (item.type === 'agent_message') {
    liveStream.items.set(item.id, text);
    liveStream.open = true;
    return [createNormalizedMessage({ kind: 'stream_replace', content: text, sessionId, provider: 'codex' })];
  }

  if (!text.startsWith(previous)) {
    return [];
  }
  liveStream.items.set(item.id, text);
  liveStream.open = true;
  return [createNormalizedMessage({
    kind: 'thought_delta',
    content: text.slice(previous.length),
    sessionId,
    provider: 'codex'
  })];
}

/**
 * Builds the `stream_end` frame that closes the live row of a completed item.
 *
 * Sent before the authoritative `text`/`thinking` message so the client
 * finalizes the streamed row instead of merging the canonical copy into it.
 * Items that never streamed (all message items with codex-cli 0.146.0) produce
 * no frame, leaving completion-only behavior unchanged.
 *
 * @param {object} item - Completed Codex `ThreadItem`
 * @param {object} liveStream - State from createCodexLiveStream()
 * @param {string|null} sessionId - Session id for the emitted frame
 * @returns {object[]} - Normalized live frames to send
 */
function buildCodexLiveCompletionMessages(item: any, liveStream: any, sessionId: any) {
  if (!item || (item.type !== 'agent_message' && item.type !== 'reasoning')) {
    return [];
  }
  const streamed = liveStream.items.delete(item.id);
  if (!streamed || !liveStream.open) {
    return [];
  }
  liveStream.open = false;
  return [createNormalizedMessage({ kind: 'stream_end', sessionId, provider: 'codex' })];
}

/**
 * Builds the `stream_end` frame for a run that ended with a live row still
 * open (abort, stream error, or an item that never reached `item.completed`).
 * Without it the client would keep that row in its streaming state after the
 * run's terminal lifecycle events. Safe to call more than once per run.
 *
 * @param {object} liveStream - State from createCodexLiveStream()
 * @param {string|null} sessionId - Session id for the emitted frame
 * @returns {object[]} - Normalized live frames to send
 */
function buildCodexLiveRunEndMessages(liveStream: any, sessionId: any) {
  if (!liveStream.open) {
    return [];
  }
  liveStream.open = false;
  liveStream.items.clear();
  return [createNormalizedMessage({ kind: 'stream_end', sessionId, provider: 'codex' })];
}

/**
 * Map permission mode to Codex SDK options
 * @param {string} permissionMode - 'default', 'acceptEdits', or 'bypassPermissions'
 * @returns {object} - { sandboxMode, approvalPolicy }
 */
function mapPermissionModeToCodexOptions(permissionMode: any) {
  switch (permissionMode) {
    case 'acceptEdits':
      return {
        sandboxMode: 'workspace-write',
        approvalPolicy: 'never'
      };
    case 'bypassPermissions':
      return {
        sandboxMode: 'danger-full-access',
        approvalPolicy: 'never'
      };
    case 'default':
    default:
      return {
        sandboxMode: 'workspace-write',
        approvalPolicy: 'untrusted'
      };
  }
}

/**
 * Execute a Codex query with streaming
 * @param {string} command - The prompt to send
 * @param {object} options - Options including cwd, sessionId, model, permissionMode
 * @param {WebSocket|object} ws - WebSocket connection or response writer
 */
export async function queryCodex(command: string, options: AnyRecord = {}, ws: ProviderRuntimeWriter, context: AnyRecord) {
  const {
    sessionId,
    sessionSummary,
    cwd,
    projectPath,
    model,
    effort,
    images,
    files,
    permissionMode = 'default'
  } = options;

  // Callers pass the stable app session id; the SDK resumes threads with the
  // provider-native id recorded on the session row.
  const providerSessionId = context.resolveProviderSessionId(sessionId);

  const resolvedModel = await context.resolveResumeModel(sessionId, model);

  const workingDirectory = cwd || projectPath || process.cwd();
  const { sandboxMode, approvalPolicy } = mapPermissionModeToCodexOptions(permissionMode);
  const catalog = await context.getProviderModels();
  const selectedModel = catalog.OPTIONS.find((option: any) => option.value === resolvedModel) || null;
  const allowedEfforts = selectedModel?.effort?.values?.map((value: any) => value.value) || [];
  const resolvedEffort = typeof effort === 'string' && effort !== 'default' && allowedEfforts.includes(effort)
    ? effort
    : undefined;

  let ownedSession: any;
  let codex: any;
  let thread: any;
  // Provider-native thread id (starts as the resume id, or is captured from
  // the stream for brand-new sessions).
  let capturedSessionId = providerSessionId;
  let sessionCreatedSent = false;
  let terminalFailure: any = null;
  // Text of the last `error` frame sent, to drop the turn.failed repeat.
  let lastErrorText: string | undefined;
  let approvalNoticeSent = false;
  // Tool items whose card was already sent at item.started.
  const startedToolIds = new Set<string>();
  // todo_list item id -> last items snapshot sent.
  const todoSnapshots = new Map<string, string>();
  let todoRevision = 0;
  const codexHome = options.env?.CODEX_HOME || process.env.CODEX_HOME || path.join(os.homedir(), '.codex');
  const catalogWindow = Number(selectedModel?.context) || 0;
  // Live rows relayed to the client for message/reasoning item snapshots.
  const liveStream = createCodexLiveStream();
  const abortController = new AbortController();
  // Session-map key: the app session id when the caller supplied one, else
  // the provider-native thread id once captured (legacy/direct API callers).
  const sessionKey = () => sessionId || capturedSessionId || null;

  try {
    // options.env carries multi-account overrides (e.g. CODEX_HOME pointing at
    // an isolated credential dir). CodexOptions.env replaces process.env, so
    // the full providerChildEnv baseline is passed, not just the overrides.
    codex = new Codex({
      env: Object.fromEntries(Object.entries(providerChildEnv(options.env && typeof options.env === 'object' ? options.env : {})).filter((entry): entry is [string, string] => typeof entry[1] === 'string')),
    });

    const threadOptions: any = {
      workingDirectory,
      skipGitRepoCheck: true,
      sandboxMode,
      approvalPolicy,
      model: resolvedModel,
      modelReasoningEffort: resolvedEffort,
    };

    if (providerSessionId) {
      thread = codex.resumeThread(providerSessionId, threadOptions);
    } else {
      thread = codex.startThread(threadOptions);
    }

    const registerSession = (id: any) => {
      if (!id) {
        return;
      }
      ownedSession ??= {
        thread,
        codex,
        status: 'running',
        abortController,
        startedAt: new Date().toISOString()
      };
      activeCodexSessions.set(id, ownedSession);
    };

    if (sessionKey()) {
      registerSession(sessionKey());
    }

    // Execute with streaming. Turns with image attachments send structured
    // input items so Codex reads the images from their local asset paths.
    const promptWithFiles = appendFilesInputTag(command, files);
    const turnInput = normalizeImageDescriptors(images).length > 0
      ? buildCodexInputItems(promptWithFiles, images, workingDirectory)
      : promptWithFiles;
    const streamedTurn = await thread.runStreamed(turnInput, {
      signal: abortController.signal
    });

    for await (const event of streamedTurn.events) {
      // Capture thread/session id lazily from the stream (Codex emits this asynchronously).
      if (event.type === 'thread.started') {
        const discoveredSessionId = event.thread_id || event.id || null;
        if (discoveredSessionId && !capturedSessionId) {
          capturedSessionId = discoveredSessionId;
          registerSession(sessionKey());

          if (ws.setSessionId && typeof ws.setSessionId === 'function') {
            ws.setSessionId(capturedSessionId);
          }

          if (!providerSessionId && !sessionCreatedSent) {
            sessionCreatedSent = true;
            sendMessage(ws, createNormalizedMessage({ kind: 'session_created', newSessionId: capturedSessionId, sessionId: capturedSessionId, provider: 'codex' }));
          }
        }
      }

      // Check if session was aborted
      if (abortController.signal.aborted) {
        break;
      }
      if (sessionKey()) {
        const session = ownedSession;
        if (session?.status === 'aborted') {
          break;
        }
      }

      const eventSessionId = capturedSessionId || sessionId || null;

      const item = event.item;
      const isItemEvent = event.type === 'item.started' || event.type === 'item.updated' || event.type === 'item.completed';

      // Todo lists stream as snapshots; each changed one becomes its own
      // TodoWrite card (the client shows the latest list).
      if (isItemEvent && item?.type === 'todo_list') {
        const snapshot = JSON.stringify(item.items ?? []);
        if (todoSnapshots.get(item.id) !== snapshot) {
          todoSnapshots.set(item.id, snapshot);
          const transformedTodo: any = transformCodexEvent(event);
          transformedTodo.itemId = `${item.id}:${++todoRevision}`;
          for (const msg of context.normalizeMessage(transformedTodo, eventSessionId)) {
            sendMessage(ws, msg);
          }
        }
        continue;
      }

      if (event.type === 'item.started' || event.type === 'item.updated') {
        // Message/reasoning snapshots feed the client's live rows.
        for (const msg of buildCodexLiveSnapshotMessages(item, liveStream, eventSessionId)) {
          sendMessage(ws, msg);
        }
        // Long-running tools show their card while they run; the result is
        // attached at item.completed under the same toolId.
        if (
          event.type === 'item.started'
          && (item?.type === 'command_execution' || item?.type === 'mcp_tool_call')
          && item.id
        ) {
          startedToolIds.add(item.id);
          const transformedStart: any = transformCodexEvent(event);
          transformedStart.itemId = item.id;
          transformedStart.status = 'in_progress';
          for (const msg of context.normalizeMessage(transformedStart, eventSessionId)) {
            sendMessage(ws, msg);
          }
        }
        continue;
      }

      if (event.type === 'item.completed') {
        for (const msg of buildCodexLiveCompletionMessages(item, liveStream, eventSessionId)) {
          sendMessage(ws, msg);
        }
        if (permissionMode === 'default' && !approvalNoticeSent && isCodexApprovalRefusal(item)) {
          approvalNoticeSent = true;
          sendMessage(ws, createNormalizedMessage({
            kind: 'status',
            notice: true,
            text: 'A command was blocked by the sandbox/approval policy: Codex cannot ask for approval in this mode. Switch to Accept Edits or Bypass Permissions to let it run commands.',
            sessionId: eventSessionId,
            provider: 'codex',
          }));
        }
      } else if (event.type === 'turn.completed' || event.type === 'turn.failed') {
        // The turn is over: finalize any row an unfinished item left open
        // before the turn's own complete/failed frame reaches the client.
        for (const msg of buildCodexLiveRunEndMessages(liveStream, eventSessionId)) {
          sendMessage(ws, msg);
        }
      }

      const transformed: any = transformCodexEvent(event);
      if (item?.id) {
        transformed.itemId = item.id;
      }

      // Normalize the transformed event into NormalizedMessage(s) via adapter
      for (const msg of context.normalizeMessage(transformed, eventSessionId)) {
        if (msg.kind === 'tool_use' && startedToolIds.has(msg.toolId)) {
          // The card was sent at item.started; attach only its outcome.
          sendMessage(ws, createNormalizedMessage({
            kind: 'tool_result',
            toolId: msg.toolId,
            content: msg.toolResult?.content ?? '',
            isError: Boolean(msg.toolResult?.isError),
            exitCode: msg.exitCode,
            sessionId: eventSessionId,
            provider: 'codex',
          }));
          continue;
        }
        if (msg.kind === 'error') {
          // A top-level `error` is usually followed by `turn.failed` with
          // the same text; show it once.
          if (msg.content === lastErrorText) {
            continue;
          }
          lastErrorText = msg.content;
        }
        sendMessage(ws, msg);
      }

      if ((event.type === 'turn.failed' || event.type === 'error') && !terminalFailure) {
        terminalFailure = event.error || new Error(event.message || 'Turn failed');
        // Notifications are app-facing, so they carry the app session id.
        notifyRunFailed({
          userId: ws?.userId || null,
          provider: 'codex',
          sessionId: sessionId || capturedSessionId || null,
          sessionName: sessionSummary,
          error: terminalFailure
        });
      }

      // Extract and send token usage if available (normalized to match Claude format)
      if (event.type === 'turn.completed') {
        const threadId = capturedSessionId || thread.id;
        const rolloutContext = threadId
          ? await readCodexRolloutContextUsage(sessionId || null, threadId, codexHome)
          : null;
        const tokenBudget = extractCodexTokenBudget(event, rolloutContext, catalogWindow);
        if (tokenBudget) {
          sendMessage(ws, createNormalizedMessage({ kind: 'status', text: 'token_budget', tokenBudget, sessionId: capturedSessionId || sessionId || null, provider: 'codex' }));
        }
      }
    }

    // Close a live row the run left open (aborted runs and streams that ended
    // without item.completed) before the terminal lifecycle events.
    for (const msg of buildCodexLiveRunEndMessages(liveStream, capturedSessionId || sessionId || null)) {
      sendMessage(ws, msg);
    }

    // Send the terminal completion event — skipped for aborted runs, whose
    // terminal `complete` (aborted: true) was already sent by abort-session.
    const runSession = sessionKey() ? ownedSession : null;
    const runAborted = runSession?.status === 'aborted' || abortController.signal.aborted;
    if (!runAborted) {
      sendMessage(ws, createCompleteMessage({
        provider: 'codex',
        sessionId: capturedSessionId || sessionId || null,
        actualSessionId: capturedSessionId || thread.id || sessionId || null,
        exitCode: terminalFailure ? 1 : 0,
      }));
      if (!terminalFailure) {
        notifyRunStopped({
          userId: ws?.userId || null,
          provider: 'codex',
          sessionId: sessionId || capturedSessionId || null,
          sessionName: sessionSummary,
          stopReason: 'completed'
        });
      }
    }

  } catch (error: any) {
    // An exception can escape with a live row still open (SDK abort or stream
    // failure); finalize it before the error/complete frames.
    for (const msg of buildCodexLiveRunEndMessages(liveStream, capturedSessionId || sessionId || null)) {
      sendMessage(ws, msg);
    }

    const session = sessionKey() ? ownedSession : null;
    const wasAborted =
      session?.status === 'aborted' || abortController.signal.aborted ||
      error?.name === 'AbortError' ||
      String(error?.message || '').toLowerCase().includes('aborted');

    if (!wasAborted) {
      console.error('[Codex] Error:', error);

      // A turn that already reported its failure exits non-zero too; that
      // exit adds nothing the user has not seen.
      if (!terminalFailure) {
        const message = String(error?.message || error || 'Codex failed');
        const binaryMissing = error?.code === 'ENOENT' || /ENOENT/.test(message) || !(await context.isProviderInstalled());
        const errorContent = binaryMissing
          ? `${message}\nThe Codex CLI was not found. Install it (npm install -g @openai/codex) and sign in.`
          : message;
        sendMessage(ws, createNormalizedMessage({ kind: 'error', content: errorContent, sessionId: capturedSessionId || sessionId || null, provider: 'codex' }));
      }
      sendMessage(ws, createCompleteMessage({
        provider: 'codex',
        sessionId: capturedSessionId || sessionId || null,
        exitCode: 1,
      }));
      if (!terminalFailure) {
        notifyRunFailed({
          userId: ws?.userId || null,
          provider: 'codex',
          sessionId: sessionId || capturedSessionId || null,
          sessionName: sessionSummary,
          error
        });
      }
    }

  } finally {
    // Update session status
    if (sessionKey()) {
      const session = ownedSession;
      if (session && activeCodexSessions.get(sessionKey()) === session) {
        session.status = session.status === 'aborted' ? 'aborted' : 'completed';
      }
    }
  }
}

/**
 * Abort an active Codex session
 * @param {string} sessionId - Session ID to abort
 * @returns {boolean} - Whether abort was successful
 */
export function abortCodexSession(sessionId: any) {
  const session = activeCodexSessions.get(sessionId);

  if (!session) {
    return false;
  }

  session.status = 'aborted';
  try {
    session.abortController?.abort();
  } catch (error: any) {
    console.warn(`[Codex] Failed to abort session ${sessionId}:`, error);
  }

  return true;
}

/**
 * Check if a session is active
 * @param {string} sessionId - Session ID to check
 * @returns {boolean} - Whether session is active
 */
export function isCodexSessionActive(sessionId: any) {
  const session = activeCodexSessions.get(sessionId);
  return session?.status === 'running';
}

/**
 * Get all active sessions
 * @returns {Array} - Array of active session info
 */
export function getActiveCodexSessions() {
  const sessions: any = [];

  for (const [id, session] of activeCodexSessions.entries()) {
    if (session.status === 'running') {
      sessions.push({
        id,
        status: session.status,
        startedAt: session.startedAt
      });
    }
  }

  return sessions;
}

// Consumed by the provider registry for run, Stop and permission controls.
export const codexRuntime: IProviderRuntime = {
  run: queryCodex,
  abort: abortCodexSession,
};

/**
 * Helper to send message via WebSocket or writer
 * @param {WebSocket|object} ws - WebSocket or response writer
 * @param {object} data - Data to send
 */
function sendMessage(ws: any, data: any) {
  try {
    if (ws.isSSEStreamWriter || ws.isWebSocketWriter) {
      // Writer handles stringification (SSEStreamWriter or WebSocketWriter)
      ws.send(data);
    } else if (typeof ws.send === 'function') {
      // Raw WebSocket - stringify here
      ws.send(JSON.stringify(data));
    }
  } catch (error: any) {
    console.error('[Codex] Error sending message:', error);
  }
}

// Clean up old completed sessions periodically
const completedSessionCleanupTimer = setInterval(() => {
  const now = Date.now();
  const maxAge = 30 * 60 * 1000; // 30 minutes

  for (const [id, session] of activeCodexSessions.entries()) {
    if (session.status !== 'running') {
      const startedAt = new Date(session.startedAt).getTime();
      if (now - startedAt > maxAge) {
        activeCodexSessions.delete(id);
      }
    }
  }
}, 5 * 60 * 1000); // Every 5 minutes

// Runtime cleanup should not keep focused tests or one-off scripts alive after
// their provider work has completed.
completedSessionCleanupTimer.unref?.();

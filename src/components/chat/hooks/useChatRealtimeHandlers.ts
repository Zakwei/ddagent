import { useEffect, useRef } from 'react';
import type { Dispatch, MutableRefObject, SetStateAction } from 'react';

import type { ServerEvent, RunReplayCursor } from '../../../contexts/WebSocketContext';
import { showCompletionTitleIndicator } from '../../../utils/pageTitleNotification';
import { playChatCompletionSound, playNotificationSound } from '../../../utils/notificationSound';
import { triggerHapticFeedback } from '../../../utils/haptics';
import type { MarkSessionIdle, MarkSessionProcessing } from '../../../hooks/useSessionProtection';
import type { PendingPermissionRequest } from '../types/types';
import type { ProjectSession, LLMProvider } from '../../../types/app';
import type { SessionStore, NormalizedMessage } from '../../../stores/useSessionStore';
import { lastAssistantSpeechText, maybeSpeakCompletion } from '../../../lib/voiceAutoRead';

import { isSubagentToolName } from './useChatMessages';

/**
 * How often buffered live deltas are flushed into the store. 60 ms keeps the
 * transcript flowing at ~16 updates/s without re-rendering on every chunk.
 */
const STREAM_FLUSH_INTERVAL_MS = 60;

const isActionablePermissionRequest = (request: { toolName?: unknown } | null | undefined): boolean => {
  return request?.toolName !== 'ExitPlanMode' && request?.toolName !== 'exit_plan_mode';
};

const hasActionablePermissionRequests = (requests: Array<{ toolName?: unknown }> | null | undefined): boolean => {
  return Array.isArray(requests) && requests.some((request) => isActionablePermissionRequest(request));
};

interface UseChatRealtimeHandlersArgs {
  isActive: boolean;
  subscribe: (listener: (event: ServerEvent) => void) => () => void;
  provider: LLMProvider;
  selectedSession: ProjectSession | null;
  /**
   * Pane-bound session id from the workspace context. Propagates
   * synchronously on session switches, while `selectedSession` /
   * `currentSessionId` lag a render behind it — prefer it when routing
   * live frames so deltas never land in the previous session's slot.
   */
  boundSessionId?: string | null;
  currentSessionId: string | null;
  setTokenBudget: (budget: Record<string, unknown> | null) => void;
  pendingPermissionRequests: PendingPermissionRequest[];
  setPendingPermissionRequests: Dispatch<SetStateAction<PendingPermissionRequest[]>>;
  /**
   * Streaming flush state is keyed by session id: parallel runs (visible A +
   * background B) must never share one buffer/timer, or B's text would be
   * flushed into A's slot.
   */
  streamTimerRef: MutableRefObject<Map<string, number>>;
  accumulatedStreamRef: MutableRefObject<Map<string, string>>;
  /**
   * Latest replay cursor observed per session. Essential for reconnect
   * catch-up: `chat.subscribe` sends it as `{runId, lastSeq}` so the server
   * replays only the events this client actually missed — `seq` restarts
   * every run, so the runId is what makes the cursor meaningful across runs.
   * Written here on every sequenced frame; read wherever a `chat.subscribe`
   * is sent (session open, reconnect).
   */
  lastSeqRef: MutableRefObject<Map<string, RunReplayCursor>>;
  /** When each session's `chat.subscribe` was last sent; guards stale idle acks. */
  statusCheckSentAtRef: MutableRefObject<Map<string, number>>;
  onSessionProcessing?: MarkSessionProcessing;
  onSessionIdle?: MarkSessionIdle;
  onWebSocketReconnect?: () => void;
  requestLatestMessages: (sessionId: string, allowNetwork?: boolean) => Promise<void>;
  sessionStore: SessionStore;
}

/* ------------------------------------------------------------------ */
/*  Hook                                                              */
/* ------------------------------------------------------------------ */

/**
 * Routes server events into the session store and processing-state map.
 *
 * This is intentionally a thin reducer over the unified `kind`-based
 * protocol: every frame is keyed by the stable app session id, so there is
 * no session-id handoff, no provider branching, and no navigation here.
 * Sidebar events (`session_upserted`, `loading_progress`) are handled by
 * `useProjectsState`, not in this hook.
 */
export function useChatRealtimeHandlers({
  isActive,
  subscribe,
  provider,
  selectedSession,
  boundSessionId,
  currentSessionId,
  setTokenBudget,
  pendingPermissionRequests,
  setPendingPermissionRequests,
  streamTimerRef,
  accumulatedStreamRef,
  lastSeqRef,
  statusCheckSentAtRef,
  onSessionProcessing,
  onSessionIdle,
  onWebSocketReconnect,
  requestLatestMessages,
  sessionStore,
}: UseChatRealtimeHandlersArgs) {
  // Session switches can send `chat.subscribe` before this effect has a chance
  // to rebind the websocket listener. Read the visible session id from a ref
  // so a fast `chat_subscribed` ack is matched against the current view, not
  // the previous render's closed-over selection.
  const activeViewSessionIdRef = useRef<string | null>(boundSessionId || selectedSession?.id || currentSessionId || null);
  activeViewSessionIdRef.current = boundSessionId || selectedSession?.id || currentSessionId || null;
  const isActiveRef = useRef(isActive);
  isActiveRef.current = isActive;

  // Keep the latest pending-permission snapshot available to the websocket
  // listener so back-to-back permission events can dedupe and re-arm the
  // notification sound before React finishes a rerender.
  const pendingPermissionRequestsRef = useRef(pendingPermissionRequests);

  // Track open subagent tool calls so a `complete` event does not flip the
  // session to idle while a subagent is still producing child tool events.
  // The parent `run_subagent` / `Task` tool_use is added; it is removed once
  // its final result (or a completion notification) arrives.
  //
  // Both structures are keyed by session id: every mounted pane receives the
  // broadcast events for ALL sessions, so a flat set would leak session B's
  // subagents into session A's idle bookkeeping and pin it as "processing".
  const openSubagentToolIdsRef = useRef(new Map<string, Set<string>>());
  const pendingIdleSessionIdsRef = useRef(new Set<string>());

  const isSubagentToolUse = (toolName: unknown, toolId: unknown): boolean => {
    if (typeof toolName !== 'string' || typeof toolId !== 'string') return false;
    return isSubagentToolName(toolName) || /run_subagent|read_subagent/.test(toolId);
  };

  const isSubagentLaunchAck = (content: unknown): boolean =>
    typeof content === 'string' && /Background subagent started/i.test(content);

  const isSubagentCompletionSignal = (content: unknown): boolean =>
    typeof content === 'string' && (/Subagent completed/i.test(content) || /subagent_completion_notification/i.test(content));

  const maybeResolveSubagent = (sid: string, toolId: string, content: unknown): void => {
    const openToolIds = openSubagentToolIdsRef.current.get(sid);
    if (!openToolIds?.has(toolId)) return;

    if (isSubagentLaunchAck(content)) {
      // The launch ack is the first result of run_subagent; the subagent is
      // starting, not finished. Keep it open.
      return;
    }

    openToolIds.delete(toolId);

    if (openToolIds.size === 0) {
      openSubagentToolIdsRef.current.delete(sid);
      if (pendingIdleSessionIdsRef.current.delete(sid)) {
        onSessionIdle?.(sid);
      }
    }
  };

  const maybeResolveSubagentByContent = (sid: string, content: unknown): void => {
    if (!isSubagentCompletionSignal(content)) return;
    const openToolIds = openSubagentToolIdsRef.current.get(sid);
    if (!openToolIds || openToolIds.size === 0) return;
    const [firstToolId] = openToolIds.values();
    maybeResolveSubagent(sid, firstToolId, 'force-complete');
  };

  const maybeDeferIdleOnComplete = (sid: string | null): boolean => {
    if (!sid) return false;
    const openToolIds = openSubagentToolIdsRef.current.get(sid);
    // Only this session's own subagents can defer its idle transition.
    if (!openToolIds || openToolIds.size === 0) return false;
    pendingIdleSessionIdsRef.current.add(sid);
    // Safety watchdog: never leave the session stuck waiting indefinitely for subagent
    // resolution if a completion signal or tool result was missed.
    setTimeout(() => {
      if (pendingIdleSessionIdsRef.current.has(sid)) {
        openSubagentToolIdsRef.current.delete(sid);
        pendingIdleSessionIdsRef.current.delete(sid);
        onSessionIdle?.(sid);
      }
    }, 15_000);
    return true;
  };

  const humanizeToolStatus = (toolName: unknown, toolInput: unknown): string | null => {
    const name = String(toolName || '');
    let input: Record<string, unknown> = {};
    if (typeof toolInput === 'string') {
      try {
        input = JSON.parse(toolInput) as Record<string, unknown>;
      } catch {
        input = { raw: toolInput };
      }
    } else if (toolInput && typeof toolInput === 'object') {
      input = toolInput as Record<string, unknown>;
    }

    const file = String(input.file_path || input.path || input.file || '');
    const cmd = String(input.command || input.shell || '');
    const url = String(input.url || '');
    const query = String(input.query || '');

    if (isSubagentToolName(name)) {
      return 'Subagent running';
    }

    switch (name) {
      case 'Read':
      case 'read_file':
      case 'Grep':
      case 'Glob':
        return file ? `Reading ${file.split('/').pop() || file}` : `Running ${name}`;
      case 'Write':
      case 'write_file':
      case 'Edit':
      case 'ApplyPatch':
        return file ? `Editing ${file.split('/').pop() || file}` : `Editing a file`;
      case 'Bash':
      case 'Shell':
      case 'shell':
        return cmd ? `Running \`${cmd.length > 48 ? `${cmd.slice(0, 45)}…` : cmd}\`` : 'Running a shell command';
      case 'Commit':
      case 'git_commit':
        return 'Committing changes';
      case 'Push':
      case 'git_push':
        return 'Pushing branch';
      case 'WebFetch':
      case 'WebSearch':
        return url ? `Fetching ${url}` : query ? `Searching “${query.length > 40 ? `${query.slice(0, 37)}…` : query}”` : `Running ${name}`;
      default:
        return null;
    }
  };

  useEffect(() => {
    pendingPermissionRequestsRef.current = pendingPermissionRequests;
  }, [pendingPermissionRequests]);

  useEffect(() => {
    // Live rows are buffered per session and per row: reasoning gets a suffixed
    // key so the message and thinking rows never share a buffer or timer.
    const streamBufferKey = (sessionId: string, kind: 'stream_delta' | 'thinking') =>
      kind === 'thinking' ? `${sessionId}::thought` : sessionId;

    const flushStream = (sessionId: string, kind: 'stream_delta' | 'thinking') => {
      const key = streamBufferKey(sessionId, kind);
      const timer = streamTimerRef.current.get(key);
      if (timer !== undefined) {
        clearTimeout(timer);
        streamTimerRef.current.delete(key);
      }
      const pendingText = accumulatedStreamRef.current.get(key);
      if (!pendingText) return;
      accumulatedStreamRef.current.delete(key);
      sessionStore.updateStreaming(sessionId, pendingText, provider, kind);
    };

    const bufferStream = (sessionId: string, kind: 'stream_delta' | 'thinking', text: string) => {
      const key = streamBufferKey(sessionId, kind);
      const buffers = accumulatedStreamRef.current;
      buffers.set(key, (buffers.get(key) ?? '') + text);
      if (streamTimerRef.current.has(key)) return;
      streamTimerRef.current.set(
        key,
        window.setTimeout(() => {
          streamTimerRef.current.delete(key);
          const pendingText = accumulatedStreamRef.current.get(key);
          if (pendingText) {
            sessionStore.updateStreaming(sessionId, pendingText, provider, kind);
          }
        }, STREAM_FLUSH_INTERVAL_MS),
      );
    };

    // Close both live rows: flush what is buffered, then finalize each row in
    // the store so the next chunks start fresh rows.
    const closeLiveRows = (sessionId: string) => {
      flushStream(sessionId, 'stream_delta');
      flushStream(sessionId, 'thinking');
      sessionStore.finalizeStreaming(sessionId, 'stream_delta');
      sessionStore.finalizeStreaming(sessionId, 'thinking');
    };

    const handleEvent = (msg: ServerEvent) => {
      if (!msg.kind) {
        return;
      }

      const activeViewSessionId = activeViewSessionIdRef.current;
      const rawSessionId = (typeof msg.sessionId === 'string' && msg.sessionId) || null;
      // Frames without a sessionId are ambiguous when several panes share the
      // socket — only the active pane may claim them for its viewed session;
      // an inactive pane treats them as untargeted rather than guessing.
      const sid = rawSessionId || (isActiveRef.current ? activeViewSessionId : null);

      // Record replay progress for every sequenced live event. A new run
      // reuses low seq numbers, so a changed runId always moves the cursor
      // forward; within one run only higher seqs advance it.
      if (rawSessionId && typeof msg.seq === 'number') {
        const known = lastSeqRef.current.get(rawSessionId);
        const runId =
          typeof msg.runId === 'string' && msg.runId ? msg.runId : known?.runId ?? null;
        if (!known || runId !== known.runId || msg.seq > known.seq) {
          lastSeqRef.current.set(rawSessionId, { runId, seq: msg.seq });
        }
      }

      switch (msg.kind) {
        case 'websocket_reconnected':
          onWebSocketReconnect?.();
          return;

        case 'chat_subscribed': {
          // Ack for chat.subscribe: authoritative processing state plus any
          // pending tool-permission prompts for the run.
          if (!sid) return;

          if (msg.isProcessing) {
            onSessionProcessing?.(sid);
          } else {
            // Authoritative server state: backend has no active run for this session.
            // Clear any stale subagent tool IDs so the UI never hangs indefinitely.
            openSubagentToolIdsRef.current.delete(sid);
            pendingIdleSessionIdsRef.current.delete(sid);
            onSessionIdle?.(sid, {
              ifStartedBefore: statusCheckSentAtRef.current.get(sid),
            });
          }

          const isViewedSession = sid === activeViewSessionId;
          if (isViewedSession && Array.isArray(msg.pendingPermissions)) {
            const nextPendingPermissionRequests = msg.pendingPermissions as PendingPermissionRequest[];
            const hadActionablePermissionRequests = hasActionablePermissionRequests(pendingPermissionRequestsRef.current);
            const hasPendingActionablePermissionRequests = hasActionablePermissionRequests(nextPendingPermissionRequests);

            pendingPermissionRequestsRef.current = nextPendingPermissionRequests;
            setPendingPermissionRequests(nextPendingPermissionRequests);

            if (hasPendingActionablePermissionRequests && !hadActionablePermissionRequests) {
              void playNotificationSound();
            }
          }
          return;
        }

        case 'protocol_error': {
          console.error('[Chat] Protocol error:', msg.code, msg.error);
          if (sid) {
            // Surface the failure in the conversation and stop the spinner —
            // the run never started (or was rejected), so no `complete` follows.
            // NO_ACTIVE_RUN is the benign abort-vs-complete race: settle idle
            // without rendering a phantom "no active run" error row.
            onSessionIdle?.(sid);
            if (msg.code === 'NO_ACTIVE_RUN') {
              return;
            }
            sessionStore.appendRealtime(sid, {
              id: `protocol_error_${Date.now()}`,
              sessionId: sid,
              timestamp: new Date().toISOString(),
              provider,
              kind: 'error',
              content: String(msg.error || 'Request failed'),
            } as NormalizedMessage);
          }
          return;
        }

        // Sidebar/global events — owned by useProjectsState.
        case 'session_upserted':
        case 'session_removed':
        case 'loading_progress':
          return;

        default:
          break;
      }

      /* -------------------------------------------------------------- */
      /*  Provider NormalizedMessage handling                            */
      /* -------------------------------------------------------------- */

      // --- Live stream rows: buffered per session and row for performance ---
      if (msg.kind === 'stream_delta' || msg.kind === 'thought_delta') {
        const text = (msg.content as string) || '';
        if (!text) return;
        if (sid) {
          bufferStream(sid, msg.kind === 'thought_delta' ? 'thinking' : 'stream_delta', text);
        }
        // Raw delta chunks are never appended to realtimeMessages — every
        // mounted pane sees all sessions' deltas, and the per-session buffer
        // above already materializes a single live row via updateStreaming.
        return;
      }

      if (msg.kind === 'stream_replace') {
        // Canonical correction for the open live row: replace it in place and
        // drop the buffer so a later flush cannot resurrect the stale text.
        if (sid) {
          const key = streamBufferKey(sid, 'stream_delta');
          const timer = streamTimerRef.current.get(key);
          if (timer !== undefined) {
            clearTimeout(timer);
            streamTimerRef.current.delete(key);
          }
          accumulatedStreamRef.current.delete(key);
          sessionStore.replaceStreaming(sid, String(msg.content || ''), provider);
        }
        return;
      }

      if (msg.kind === 'stream_end') {
        if (sid) {
          closeLiveRows(sid);
        }
        return;
      }

      // --- All other messages: route to store ---
      const shouldPersist =
        msg.kind !== 'complete'
        && msg.kind !== 'status'
        && msg.kind !== 'permission_request'
        && msg.kind !== 'permission_cancelled';

      if (sid && shouldPersist) {
        sessionStore.appendRealtime(sid, msg as unknown as NormalizedMessage);
      }

      // --- UI side effects for specific kinds ---
      switch (msg.kind) {
        case 'complete': {
          // Flush any remaining streaming state for this session only —
          // a parallel run's buffer/timer must survive.
          if (sid) {
            closeLiveRows(sid);
          }

          // `complete` is the unified terminal event — every provider run ends
          // with exactly one, regardless of success, failure, or abort. The
          // indicator derives from the processing map, so deleting the entry
          // hides it immediately and atomically.
          //
          // If a subagent was launched in this run, defer the idle transition
          // until the subagent actually reports a final result. On explicit
          // abort we still mark idle so queued follow-ups can flush.
          if (msg.aborted || !maybeDeferIdleOnComplete(sid)) {
            onSessionIdle?.(sid);
          }
          if (sid === activeViewSessionId) {
            pendingPermissionRequestsRef.current = [];
            setPendingPermissionRequests([]);
          }

          if (msg.aborted) {
            // Abort was requested — the complete event confirms it. No
            // further UI action is needed beyond clearing the entry above.
            break;
          }

          // Celebrate only successful runs (failed runs end with success: false).
          if (msg.success !== false) {
            if (typeof document === 'undefined' || !document.hidden) {
              showCompletionTitleIndicator();
              void playChatCompletionSound();
            }
          }

          // Opt-in read-aloud: armed sessions speak their final assistant
          // message. Deduped by seq — every mounted pane sees this frame.
          if (sid && typeof msg.seq === 'number') {
            maybeSpeakCompletion(sid, msg.seq, () =>
              lastAssistantSpeechText(sessionStore.getMessages(sid)),
            );
          }

          // The session id is stable for the whole conversation (allocated
          // before the first send), so the only follow-up is syncing the
          // conversation with the now-persisted transcript. A run may finish
          // while the user views another session — the coordinator marks
          // non-viewed sessions pending and flushes them on activation.
          if (sid) {
            void requestLatestMessages(sid, isActiveRef.current);
          }

          break;
        }

        // 'error' is an informational message row, not a terminal event —
        // providers emit it for mid-run stderr output too. Run teardown is
        // always signalled by the unified 'complete' that follows.

        case 'permission_request': {
          if (!msg.requestId) break;
          if (isActionablePermissionRequest({ toolName: msg.toolName })) {
            void playNotificationSound();
            triggerHapticFeedback('permissionRequested');
          }

          if (sid === activeViewSessionId) {
            const previousPendingPermissionRequests = pendingPermissionRequestsRef.current;
            if (!previousPendingPermissionRequests.some((request) => request.requestId === msg.requestId)) {
              const nextPendingPermissionRequests = [...previousPendingPermissionRequests, {
                requestId: msg.requestId as string,
                toolName: (msg.toolName as string) || 'UnknownTool',
                input: msg.input,
                context: msg.context,
                sessionId: sid || null,
                receivedAt: new Date(),
              }];

              pendingPermissionRequestsRef.current = nextPendingPermissionRequests;
              setPendingPermissionRequests(nextPendingPermissionRequests);
            }
          }
          if (sid) {
            onSessionProcessing?.(sid);
          }
          break;
        }

        case 'permission_cancelled': {
          if (msg.requestId && sid === activeViewSessionId) {
            const nextPendingPermissionRequests = pendingPermissionRequestsRef.current.filter(
              (request: PendingPermissionRequest) => request.requestId !== msg.requestId,
            );

            pendingPermissionRequestsRef.current = nextPendingPermissionRequests;
            setPendingPermissionRequests(nextPendingPermissionRequests);
          }
          break;
        }

        case 'status': {
          if (msg.text === 'token_budget' && msg.tokenBudget) {
            // Every pane sees all sessions' status frames — only the viewed
            // session may update this tile's token summary.
            if (sid === activeViewSessionId) {
              setTokenBudget(msg.tokenBudget as Record<string, unknown>);
            }
          } else if (msg.text && sid) {
            onSessionProcessing?.(sid, {
              statusText: msg.text as string,
              canInterrupt: msg.canInterrupt !== false,
            });
          }
          break;
        }

        case 'tool_use': {
          if (sid && isSubagentToolUse(msg.toolName, msg.toolId)) {
            let openToolIds = openSubagentToolIdsRef.current.get(sid);
            if (!openToolIds) {
              openToolIds = new Set<string>();
              openSubagentToolIdsRef.current.set(sid, openToolIds);
            }
            openToolIds.add(msg.toolId as string);
            onSessionProcessing?.(sid, { statusText: 'Subagent running', canInterrupt: true });
          } else if (sid) {
            const status = humanizeToolStatus(msg.toolName, msg.toolInput);
            if (status) {
              onSessionProcessing?.(sid, { statusText: status, canInterrupt: true });
            }
          }
          break;
        }

        case 'tool_result': {
          if (sid && msg.toolId && typeof msg.toolId === 'string') {
            maybeResolveSubagent(sid, msg.toolId, msg.content);
          }
          if (sid) {
            maybeResolveSubagentByContent(sid, msg.content);
          }
          break;
        }

        case 'text': {
          if (sid) {
            maybeResolveSubagentByContent(sid, msg.content);
          }
          break;
        }

        // thinking, interactive_prompt, task_notification
        // → already routed to store above, no UI side effects needed
        default:
          break;
      }
    };

    return subscribe(handleEvent);
  }, [
    subscribe,
    provider,
    selectedSession,
    boundSessionId,
    currentSessionId,
    setTokenBudget,
    pendingPermissionRequests,
    setPendingPermissionRequests,
    streamTimerRef,
    accumulatedStreamRef,
    lastSeqRef,
    statusCheckSentAtRef,
    onSessionProcessing,
    onSessionIdle,
    onWebSocketReconnect,
    requestLatestMessages,
    sessionStore,
  ]);
}

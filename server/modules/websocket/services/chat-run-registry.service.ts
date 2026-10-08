import { randomUUID } from 'node:crypto';
import path from 'node:path';

import { projectsDb, sessionEventsDb, sessionsDb } from '@/modules/database/index.js';
import { generateDisplayName } from '@/modules/projects/index.js';
import { ChatSessionWriter } from '@/modules/websocket/services/chat-session-writer.service.js';
import { connectedClients, WS_OPEN_STATE } from '@/modules/websocket/services/websocket-state.service.js';
import { isSubagentSessionTitle, safeSocketSend } from '@/shared/index.js';
import { readNormalizedMessageText } from '@/shared/utils.js';
import type {
  LLMProvider,
  NormalizedMessage,
  RealtimeClientConnection,
} from '@/shared/index.js';

type ChatRunStatus = 'running' | 'completed';

/**
 * One live (or recently finished) provider run for a single app session.
 *
 * State notes — why each mutable field is essential:
 * - `providerSessionId`: the provider-native id captured mid-run. The abort
 *   handler needs it to address the provider runtime, and the DB mapping is
 *   written from it so history/resume work after the run.
 * - `status`: drives `chat_subscribed.isProcessing`, prevents double sends
 *   into the same session, and guards the synthetic-complete fallback in the
 *   chat handler (only emitted when a runtime died without completing).
 * - `lastSeq` / `events`: the per-run event log. Every live event gets a
 *   monotonically increasing `seq` and is buffered so a reconnecting client
 *   can replay exactly the events it missed via `chat.subscribe`.
 */
type ChatRun = {
  /** Unique run id — `seq` restarts per run, so replay cursors are (runId, seq) pairs. */
  id: string;
  appSessionId: string;
  provider: LLMProvider;
  providerSessionId: string | null;
  status: ChatRunStatus;
  lastSeq: number;
  events: NormalizedMessage[];
  writer: ChatSessionWriter;
  startedAt: number;
  completedAt: number | null;
  aborted?: boolean;
  /** Texts of `error` events already forwarded — an identical repeat is dropped. */
  errorTexts: Set<string>;
};

/**
 * How long a completed run stays available for replay. Covers the window
 * between a run finishing and the client refreshing history over REST (for
 * example when the browser tab was asleep while the run completed).
 */
const COMPLETED_RUN_RETENTION_MS = 5 * 60 * 1000;

// Event kinds a completed run may still publish (see decorateAndRecordEvent):
// asks from work outliving the turn, and the count of that work.
const LATE_ASK_KINDS = new Set<string>(['permission_request', 'permission_cancelled', 'background_tasks']);

/**
 * `error` rows and C1 notice `status` rows: may still arrive after `complete`
 * (a runtime rejecting after an early complete) and are persisted so they
 * survive a history reload.
 */
function isErrorOrNotice(message: NormalizedMessage): boolean {
  return message.kind === 'error' || (message.kind === 'status' && message.notice === true);
}

/**
 * Last `background_tasks` count per app session (absent = 0). Reported in the
 * `chat_subscribed` ack so a (re)subscribing client knows about work that
 * outlived the turn without waiting for the next change.
 */
const backgroundTaskCounts = new Map<string, number>();

function persistErrorOrNotice(run: ChatRun, outbound: NormalizedMessage): void {
  const content = readNormalizedMessageText(outbound);
  if (!content) return;
  try {
    sessionEventsDb.append({
      id: outbound.id,
      sessionId: run.appSessionId,
      provider: run.provider,
      kind: outbound.kind === 'error' ? 'error' : 'status',
      content,
      timestamp: outbound.timestamp,
    });
  } catch (error) {
    // Best effort: the live frame is already on its way to the clients.
    const message = error instanceof Error ? error.message : String(error);
    console.error('[ChatRunRegistry] Failed to persist session event', { appSessionId: run.appSessionId, error: message });
  }
}

/**
 * Upper bound on buffered events per run so a very long tool-heavy run cannot
 * grow memory unbounded. When exceeded, the oldest events are dropped —
 * a reconnecting client whose `lastSeq` predates the buffer falls back to a
 * REST history refresh, which is always the authoritative source.
 */
const MAX_BUFFERED_EVENTS_PER_RUN = 5000;

/**
 * Active and recently-completed runs keyed by app session id.
 *
 * This map is the single in-memory source of truth for "is something running
 * for this session" — the chat websocket handler, abort path, and subscribe
 * path all consult it instead of asking each provider runtime individually.
 */
const runs = new Map<string, ChatRun>();

/**
 * Websocket connections subscribed to a session's live frames.
 *
 * Run events fan out to every subscriber — not just the socket that sent the
 * prompt — so a second tab, the mobile app, or a queued/background dispatch
 * all render the same live transcript. Membership lasts until the socket
 * closes (`removeConnection`) — a pane that browsed away simply keeps
 * buffering frames it ignores, which is cheaper than tracking view state.
 */
const sessionSubscribers = new Map<string, Set<RealtimeClientConnection>>();

/**
 * Listeners notified the moment a run reaches `completed`.
 *
 * The server-side message queue subscribes to drain a session's queued
 * messages as soon as its previous run ends, so queued sends do not depend on
 * any browser tab being open. Kept as a plain listener set (rather than an
 * EventEmitter) to stay dependency-free and trivially testable.
 */
const runCompletedListeners = new Set<(appSessionId: string) => void>();

function notifyRunCompleted(appSessionId: string): void {
  for (const listener of runCompletedListeners) {
    try {
      listener(appSessionId);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[ChatRunRegistry] Run-completed listener threw', { appSessionId, error: message });
    }
  }
}

async function broadcastCanonicalSessionUpsert(appSessionId: string): Promise<void> {
  const row = sessionsDb.getSessionById(appSessionId);
  if (!row || row.isArchived || isSubagentSessionTitle(row.custom_name)) {
    return;
  }

  const projectPath = row.project_path;
  const project = projectPath ? projectsDb.getProjectPath(projectPath) : null;
  const displayName = project?.custom_project_name?.trim()
    ? project.custom_project_name
    : await generateDisplayName(path.basename(projectPath ?? '') || (projectPath ?? ''), projectPath);

  const payload = JSON.stringify({
    kind: 'session_upserted',
    sessionId: row.session_id,
    providerSessionId: row.provider_session_id,
    provider: row.provider,
    session: {
      id: row.session_id,
      summary: row.custom_name || '',
      messageCount: 0,
      lastActivity: row.updated_at ?? row.created_at ?? new Date().toISOString(),
    },
    project: project
      ? {
        projectId: project.project_id,
        path: project.project_path,
        fullPath: project.project_path,
        displayName,
        isStarred: Boolean(project.isStarred),
      }
      : null,
    timestamp: new Date().toISOString(),
  });

  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      safeSocketSend(client, payload);
    }
  });
}

function evictRunLater({ appSessionId, id }: ChatRun): void {
  // Capture only identity: retaining the whole run would keep every replaced
  // turn's event buffer alive until its timer expires.
  const timer = setTimeout(() => {
    const current = runs.get(appSessionId);
    if (current?.id === id && current.status === 'completed') {
      runs.delete(appSessionId);
    }
  }, COMPLETED_RUN_RETENTION_MS);

  // Never keep the process alive just to evict a buffered run.
  timer.unref?.();
}

/**
 * Decorates one outbound live event for a run and records it in the event log.
 *
 * Responsibilities:
 * 1. Remap `sessionId` (and `actualSessionId` on `complete`) to the stable
 *    app session id — provider-native ids never leave the backend.
 * 2. Assign the next `seq` so clients can detect/replay gaps.
 * 3. Buffer the event for `chat.subscribe` replay.
 * 4. Flip the run to `completed` when the terminal `complete` event passes by.
 */
function decorateAndRecordEvent(run: ChatRun, message: NormalizedMessage): NormalizedMessage | null {
  // A terminal event seals the entire stream, including late text, tools and
  // errors. Old writers must never affect a replacement run or its viewers.
  // Asks are the exception: Claude keeps a finished turn's process alive for
  // background work, whose follow-up turn can still ask for permission — a
  // dropped ask silently auto-denies (or, for a question, hangs). They pass
  // while no newer run owns the session, even after this one was evicted, as
  // does the running-task count that work reports between turns. So do
  // errors and notices (C7): a runtime can fail after an early `complete`, and
  // dropping that error would hide why the turn went wrong. Late events keep
  // the run's id and continue its seq, so replay cursors stay monotonic.
  const current = runs.get(run.appSessionId);
  const errorOrNotice = isErrorOrNotice(message);
  // A stopped run's late errors are interrupt noise (e.g. a setup step
  // throwing after a parked abort), not a failure the user should see.
  const late = (LATE_ASK_KINDS.has(message.kind) || (errorOrNotice && !run.aborted))
    && (current === undefined || current === run);
  if (!late && (current !== run || run.status !== 'running')) {
    return null;
  }

  // One error per text per run: providers and the dispatch safety net can
  // report the same failure twice (C3 error + a rejected runtime promise).
  if (message.kind === 'error') {
    const text = readNormalizedMessageText(message);
    if (text && run.errorTexts.has(text)) return null;
    if (text) run.errorTexts.add(text);
  }

  run.lastSeq += 1;

  const outbound: NormalizedMessage = {
    ...message,
    sessionId: run.appSessionId,
    seq: run.lastSeq,
    runId: run.id,
  };

  if (errorOrNotice) {
    // The persisted history row reuses the live id so clients can dedupe.
    outbound.id ||= randomUUID();
    outbound.timestamp ||= new Date().toISOString();
    persistErrorOrNotice(run, outbound);
  }

  if (message.kind === 'background_tasks') {
    const count = typeof message.count === 'number' && message.count > 0 ? message.count : 0;
    if (count > 0) backgroundTaskCounts.set(run.appSessionId, count);
    else backgroundTaskCounts.delete(run.appSessionId);
  }

  if (message.kind === 'complete') {
    // The provider may report its own id here; the frontend only ever knows
    // the app id, so the "actual" id is by definition the app id as well.
    outbound.actualSessionId = run.appSessionId;
    run.status = 'completed';
    run.completedAt = Date.now();
    evictRunLater(run);
  }

  run.events.push(outbound);
  if (run.events.length > MAX_BUFFERED_EVENTS_PER_RUN) {
    run.events.splice(0, run.events.length - MAX_BUFFERED_EVENTS_PER_RUN);
  }

  return outbound;
}

/**
 * Records the provider-native session id for a run and persists the
 * app-id-to-provider-id mapping so history fetches and future resumes can
 * address the provider transcript.
 *
 * Called from the gateway writer when the runtime either calls
 * `setSessionId(...)` or emits its `session_created` event — whichever
 * happens first wins; later calls with the same id are no-ops.
 */
function recordProviderSessionId(run: ChatRun, providerSessionId: string): void {
  if (runs.get(run.appSessionId) !== run || run.status !== 'running'
    || !providerSessionId || run.providerSessionId === providerSessionId) {
    return;
  }

  run.providerSessionId = providerSessionId;

  try {
    sessionsDb.assignProviderSessionId(run.appSessionId, providerSessionId);
    void broadcastCanonicalSessionUpsert(run.appSessionId).catch((error) => {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[ChatRunRegistry] Failed to broadcast canonical session mapping', {
        appSessionId: run.appSessionId,
        providerSessionId,
        error: message,
      });
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    console.error('[ChatRunRegistry] Failed to persist provider session id mapping', {
      appSessionId: run.appSessionId,
      providerSessionId,
      error: message,
    });
  }
}

/**
 * Registry consumed by websocket, queue and orchestrator services to track
 * live provider runs keyed by the stable app session id.
 *
 * The registry is what makes the websocket protocol provider-independent:
 * every run gets a `ChatSessionWriter` that remaps provider-native session
 * ids to the app id, assigns `seq` numbers, and buffers events for replay —
 * regardless of which provider runtime produced them.
 */
export const chatRunRegistry = {
  /**
   * Starts tracking a run and returns it, or `null` when a run is already in
   * progress for the session (callers must reject the duplicate send).
   */
  startRun(input: {
    appSessionId: string;
    provider: LLMProvider;
    providerSessionId: string | null;
    connection: RealtimeClientConnection;
    userId: string | number | null;
  }): ChatRun | null {
    const existing = runs.get(input.appSessionId);
    if (existing && existing.status === 'running') {
      return null;
    }

    const run: ChatRun = {
      id: randomUUID(),
      appSessionId: input.appSessionId,
      provider: input.provider,
      providerSessionId: input.providerSessionId,
      status: 'running',
      lastSeq: 0,
      events: [],
      writer: null as unknown as ChatSessionWriter,
      startedAt: Date.now(),
      completedAt: null,
      errorTexts: new Set(),
    };

    run.writer = new ChatSessionWriter({
      connection: input.connection,
      userId: input.userId,
      provider: input.provider,
      providerSessionId: input.providerSessionId,
      getSubscriberConnections: () => sessionSubscribers.get(run.appSessionId) ?? [],
      onProviderSessionId: (providerSessionId) => {
        recordProviderSessionId(run, providerSessionId);
      },
      decorateOutboundEvent: (message) => decorateAndRecordEvent(run, message),
      // Deliver and buffer complete before a synchronous queue listener can
      // start the next run and publish its first fragment.
      onEventForwarded: (message) => {
        if (message.kind === 'complete') notifyRunCompleted(run.appSessionId);
      },
    });

    runs.set(input.appSessionId, run);
    return run;
  },

  getRun(appSessionId: string): ChatRun | undefined {
    return runs.get(appSessionId);
  },

  isProcessing(appSessionId: string): boolean {
    return runs.get(appSessionId)?.status === 'running';
  },

  /** Latest reported `background_tasks` count for the session (0 if none/unknown). */
  getBackgroundTaskCount(appSessionId: string): number {
    return backgroundTaskCounts.get(appSessionId) ?? 0;
  },

  listRunningRuns(): Array<{
    sessionId: string;
    provider: LLMProvider;
    startedAt: number;
    lastSeq: number;
  }> {
    return Array.from(runs.values())
      .filter((run) => run.status === 'running')
      .map((run) => ({
        sessionId: run.appSessionId,
        provider: run.provider,
        startedAt: run.startedAt,
        lastSeq: run.lastSeq,
      }));
  },

  /**
   * Re-attaches a run's outbound stream to a (new) websocket connection.
   *
   * This is the generic replacement for the Claude-only writer reconnect:
   * after a page refresh the new socket subscribes and immediately starts
   * receiving the still-running stream, for every provider.
   */
  attachConnection(appSessionId: string, connection: RealtimeClientConnection): boolean {
    const run = runs.get(appSessionId);
    if (!run) {
      return false;
    }

    run.writer.updateWebSocket(connection);
    return true;
  },

  /**
   * Returns buffered events for replay after a reconnect.
   *
   * `seq` restarts at 1 for every run, so the cursor is a `{runId, afterSeq}`
   * pair: when the client's runId still matches the live run, only events
   * after `afterSeq` replay; when it names an older (finished) run, the whole
   * current buffer replays — the client provably never saw any of it. A
   * missing runId (older client) falls back to the seq-only comparison.
   *
   * An empty result while the run produced more events than the buffer holds
   * means the log was truncated; the client then refreshes over REST, which
   * is always the authoritative source.
   */
  replayEvents(
    appSessionId: string,
    opts: { runId?: string | null; afterSeq?: number } = {},
  ): NormalizedMessage[] {
    const run = runs.get(appSessionId);
    if (!run) {
      return [];
    }

    if (opts.runId && opts.runId !== run.id) {
      return [...run.events];
    }

    const afterSeq = opts.afterSeq ?? 0;
    return run.events.filter((event) => typeof event.seq === 'number' && event.seq > afterSeq);
  },

  /**
   * Registers a websocket as a viewer of the session's live frames. Called on
   * every `chat.subscribe` — a pane only sends it for the session it shows,
   * which is exactly the set of clients that should watch runs live.
   */
  addSessionSubscriber(appSessionId: string, connection: RealtimeClientConnection): void {
    let subscribers = sessionSubscribers.get(appSessionId);
    if (!subscribers) {
      subscribers = new Set();
      sessionSubscribers.set(appSessionId, subscribers);
    }
    subscribers.add(connection);
  },

  /**
   * Drops a closed socket from every session's subscriber set. Membership is
   * the only liveness signal — panes never explicitly unsubscribe, so this is
   * what keeps the map from leaking dead sockets.
   */
  removeConnection(connection: RealtimeClientConnection): void {
    for (const [sessionId, subscribers] of sessionSubscribers) {
      if (subscribers.delete(connection) && subscribers.size === 0) {
        sessionSubscribers.delete(sessionId);
      }
    }
  },

  /**
   * Marks a running run as aborted before awaiting the provider runtime's
   * asynchronous cancellation. If the runtime resolves or throws during
   * abort, its safety net emits an aborted `complete` rather than exitCode 1.
   * Pass `false` to roll the flag back when the provider refused the abort.
   */
  markAborted(appSessionId: string, aborted = true): void {
    const run = runs.get(appSessionId);
    if (run && run.status === 'running') {
      run.aborted = aborted;
    }
  },

  /**
   * Emits a synthetic terminal `complete` if (and only if) the run is still
   * marked running. Used when a provider runtime throws or resolves without
   * having produced its own terminal event, and by the abort path.
   */
  completeRun(appSessionId: string, opts: { exitCode: number; aborted?: boolean }): void {
    const run = runs.get(appSessionId);
    if (!run || run.status !== 'running') {
      return;
    }

    if (opts.aborted) {
      run.aborted = true;
    }
    // An aborted run always reports exitCode 0 — abort is user intent, not a
    // failure. Mirrors completeRunIfCurrent's safety-net semantics so every
    // terminal `complete` for the same run carries identical fields.
    run.writer.sendComplete({
      exitCode: run.aborted ? 0 : opts.exitCode,
      aborted: run.aborted ? true : opts.aborted,
    });
  },

  /**
   * Safety-net variant of `completeRun` scoped to one specific run: a no-op
   * unless `run` is still the session's current, running run. A runtime
   * promise can resolve after its own `complete` already streamed AND a new
   * run has replaced it in the registry (a queued message sends within
   * milliseconds of the previous turn ending) — the session-keyed
   * `completeRun` would terminate that newer run.
   */
  completeRunIfCurrent(run: ChatRun, opts: { exitCode: number; aborted?: boolean }): void {
    if (runs.get(run.appSessionId) !== run || run.status !== 'running') {
      return;
    }

    run.writer.sendComplete({
      exitCode: run.aborted ? 0 : opts.exitCode,
      aborted: run.aborted ? true : opts.aborted,
    });
  },

  /**
   * Registers a listener fired whenever a run reaches `completed`.
   *
   * Used by the server-side message queue to drain queued messages without a
   * live client. Returns an unsubscribe function.
   */
  onRunCompleted(listener: (appSessionId: string) => void): () => void {
    runCompletedListeners.add(listener);
    return () => {
      runCompletedListeners.delete(listener);
    };
  },

  /**
   * Test-only escape hatch: clears every tracked run and subscription.
   */
  clearAll(): void {
    runs.clear();
    sessionSubscribers.clear();
    backgroundTaskCounts.clear();
  },
};

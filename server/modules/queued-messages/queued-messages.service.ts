import type {
  AnyRecord,
  QueuedMessage,
  QueuedMessagesRepository,
  QueuedMessagesService,
} from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

/**
 * Outcome of one queued dispatch attempt.
 *
 * Mirrors the shared chat dispatcher's result so the queue only decides
 * whether to mark a row sent or failed.
 */
export type QueuedDispatchResult = { ok: true } | { ok: false; error: string };

/**
 * Run-registry surface the queue depends on.
 *
 * Injected rather than imported so queue ordering and dispatch decisions can
 * be unit tested with a fake run registry, and so the completion hook is
 * explicit instead of a hidden module singleton.
 */
export type QueuedMessagesRunRegistry = {
  isProcessing(sessionId: string): boolean;
  onRunCompleted(listener: (sessionId: string) => void): () => void;
  completeRun(sessionId: string, opts: { exitCode: number; aborted?: boolean }): void;
};

type QueuedMessagesServiceDeps = {
  repository: QueuedMessagesRepository;
  runs: QueuedMessagesRunRegistry;
  /**
   * Dispatches one message to its session through the shared chat pipeline.
   * Injected so tests can resolve or reject deterministically without a
   * provider runtime or database.
   */
  dispatch: (input: {
    sessionId: string;
    content: string;
    options: AnyRecord;
    userId: string | number | null;
    connection: unknown;
  }) => Promise<QueuedDispatchResult>;
  /**
   * Aborts the session's in-flight run so `sendNow` can take over. Returns
   * `false` when the provider reports nothing was actually aborted — callers
   * must then leave the run registry alone instead of dispatching into a
   * turn that is still alive. `undefined` means "no signal".
   */
  abort: (sessionId: string) => Promise<boolean | void>;
  /**
   * Live connection for the session, when a browser has it open. A queued
   * message still sends without one, so an absent connection is normal.
   */
  findConnection?: (sessionId: string) => unknown | null;
  /** Notified after a queue mutation so clients can refresh their queue view. */
  broadcast?: (payload: {
    type: 'queued-messages-updated';
    sessionId: string;
    messages: QueuedMessage[];
  }) => void;
};

/** No-op connection used when no browser socket is attached to the session. */
const BACKGROUND_CONNECTION = {
  readyState: 0,
  send: () => {
    /* events reach clients through the run buffer and REST history */
  },
};

/**
 * Server-side outbound message queue.
 *
 * Messages queued while a session is busy (or while the client is offline)
 * live here, not in the browser, so they survive refreshes, device switches,
 * and closed tabs. Two triggers drain a session's queue: a run completing
 * (via the registry listener) and a fresh enqueue while the session is idle.
 *
 * `sendNow` promotes one message to the front and dispatches it immediately,
 * aborting the session's current run first — the only way to honour "send this
 * now" while a turn is in flight, since a session runs one turn at a time.
 */
export function createQueuedMessagesService(deps: QueuedMessagesServiceDeps): QueuedMessagesService {
  /** Sessions with a dispatch in progress, so completion callbacks do not re-enter. */
  const draining = new Set<string>();
  /** Queued-message ids whose provider dispatch is in flight right now. */
  const dispatching = new Set<number>();

  function broadcastQueue(sessionId: string): void {
    deps.broadcast?.({
      type: 'queued-messages-updated',
      sessionId,
      messages: deps.repository.listBySession(sessionId),
    });
  }

  async function dispatchNext(sessionId: string): Promise<void> {
    // A run may already be live for this session; only drain when idle so we
    // never fight the active turn.
    if (deps.runs.isProcessing(sessionId)) {
      return;
    }

    const next = deps.repository.peekNext(sessionId);
    if (!next) {
      return;
    }

    if (!deps.repository.markSending(next.id)) {
      // Another dispatcher claimed it first — not an error.
      return;
    }

    // The message is in flight now — clients drop the queued card here
    // instead of waiting for the whole provider turn to finish.
    broadcastQueue(sessionId);
    dispatching.add(next.id);

    try {
      const result = await deps.dispatch({
        sessionId,
        content: next.content,
        options: next.options,
        userId: next.userId,
        connection: deps.findConnection?.(sessionId) ?? BACKGROUND_CONNECTION,
      });

      if (result.ok) {
        deps.repository.markSent(next.id);
      } else {
        deps.repository.markFailed(next.id, result.error);
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      deps.repository.markFailed(next.id, message);
    } finally {
      dispatching.delete(next.id);
      broadcastQueue(sessionId);
    }
  }

  async function drainSession(sessionId: string): Promise<void> {
    if (draining.has(sessionId)) {
      return;
    }
    draining.add(sessionId);
    try {
      // Keep dispatching while the session stays idle. The completion that
      // would normally trigger the next drain arrives while this one is still
      // awaiting the previous dispatch, so the guard above swallows it — this
      // loop is what keeps a multi-message queue moving, one turn at a time.
      while (!deps.runs.isProcessing(sessionId) && deps.repository.peekNext(sessionId)) {
        await dispatchNext(sessionId);
      }
    } finally {
      draining.delete(sessionId);
    }
  }

  deps.runs.onRunCompleted((sessionId) => {
    void drainSession(sessionId);
  });

  // A restart mid-dispatch orphans rows in `sending` — invisible to both
  // listBySession and peekNext. Requeue and drain them right away: the user
  // already watched these go out, so parking them queued-but-still would
  // just re-create the "message vanished" report after every restart.
  for (const sessionId of deps.repository.requeueStaleSending()) {
    void drainSession(sessionId);
  }

  return {
    list(sessionId): QueuedMessage[] {
      return deps.repository.listBySession(sessionId);
    },

    enqueue(input): QueuedMessage {
      const message = deps.repository.enqueue({
        userId: input.userId == null ? null : String(input.userId),
        sessionId: input.sessionId,
        content: input.content,
        options: input.options,
      });
      broadcastQueue(input.sessionId);
      // If the session is idle right now (offline buffer flushing on
      // reconnect), send immediately rather than waiting for a completion.
      void drainSession(input.sessionId);
      return message;
    },

    remove(id): void {
      const existing = deps.repository.getById(id);
      if (!existing) {
        return;
      }
      deps.repository.remove(id);
      broadcastQueue(existing.sessionId);
    },

    async sendNow(id): Promise<QueuedMessage> {
      const message = deps.repository.getById(id);
      if (!message) {
        throw new AppError(`Queued message "${id}" was not found.`, {
          code: 'QUEUED_MESSAGE_NOT_FOUND',
          statusCode: 404,
        });
      }

      // `sent` is terminal and a live `sending` is already on its way —
      // re-dispatching either would send the same content to the provider
      // twice. A `sending` row with NO in-flight dispatch is a stuck orphan
      // (its dispatcher died), so it falls through to requeue + dispatch
      // like a `failed` row.
      if (message.status === 'sent' || (message.status === 'sending' && dispatching.has(id))) {
        return message;
      }

      const sessionId = message.sessionId;
      deps.repository.promote(id);
      // `sendNow` doubles as the manual retry path: a failed (or stuck
      // `sending`) message is invisible to peekNext until it is queued again.
      if (message.status !== 'queued') {
        deps.repository.requeue(id);
      }

      // A "send now" must not wait for the in-flight turn: abort it, which
      // emits a terminal complete, then dispatch the promoted message.
      if (deps.runs.isProcessing(sessionId)) {
        const aborted = await deps.abort(sessionId).catch(() => false);
        if (aborted === false) {
          // The provider refused to abort — the turn is still alive. Leave
          // the registry alone; its own completion drains the queue and the
          // promoted message goes first. Dispatching now would hit a busy
          // provider or, worse, mark this message failed on RUN_IN_PROGRESS.
          return deps.repository.getById(id) ?? message;
        }
        deps.runs.completeRun(sessionId, { exitCode: 1, aborted: true });
      }

      await dispatchNext(sessionId);

      return deps.repository.getById(id) ?? message;
    },
  };
}

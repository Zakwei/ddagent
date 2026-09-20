export type MessageHistoryRefreshExecutor = (sessionId: string) => Promise<boolean | void>;
export type CanRefreshMessageHistory = (sessionId: string) => boolean;

export type MessageHistoryRefreshCoordinatorOptions = {
  retryBaseDelayMs?: number;
  maxRetryAttempts?: number;
};

export type MessageHistoryRefreshCoordinator = {
  request: (sessionId: string, allowNetwork?: boolean) => Promise<void>;
  flushPending: (sessionId: string) => Promise<void>;
  discardPending: (sessionId: string) => void;
  hasPending: (sessionId: string) => boolean;
};

const RETRY_BASE_DELAY_MS = 1500;
const RETRY_MAX_DELAY_MS = 15000;
const MAX_RETRY_ATTEMPTS = 6;

/**
 * Coalesces automatic persisted-history refresh signals without owning any
 * React state. Hidden sessions remain dirty until they become visible; active
 * bursts collapse into the current request plus at most one trailing request.
 * A failed or deferred refresh on a still-visible session retries with
 * backoff — transient network failures or a `complete` that lands before the
 * transcript write settles must not strand the tail until a manual refresh.
 */
export function createMessageHistoryRefreshCoordinator(
  executeRefresh: MessageHistoryRefreshExecutor,
  canRefreshNow: CanRefreshMessageHistory,
  options: MessageHistoryRefreshCoordinatorOptions = {},
): MessageHistoryRefreshCoordinator {
  const retryBaseDelayMs = options.retryBaseDelayMs ?? RETRY_BASE_DELAY_MS;
  const maxRetryAttempts = options.maxRetryAttempts ?? MAX_RETRY_ATTEMPTS;
  const pendingSessions = new Set<string>();
  const inFlightBySession = new Map<string, Promise<void>>();
  const retryTimerBySession = new Map<string, ReturnType<typeof setTimeout>>();
  const retryAttemptsBySession = new Map<string, number>();

  const clearRetry = (sessionId: string): void => {
    const timer = retryTimerBySession.get(sessionId);
    if (timer !== undefined) clearTimeout(timer);
    retryTimerBySession.delete(sessionId);
    retryAttemptsBySession.delete(sessionId);
  };

  const scheduleRetry = (sessionId: string): void => {
    const attempts = (retryAttemptsBySession.get(sessionId) ?? 0) + 1;
    retryAttemptsBySession.set(sessionId, attempts);
    const previous = retryTimerBySession.get(sessionId);
    if (previous !== undefined) clearTimeout(previous);
    if (attempts > maxRetryAttempts) {
      retryTimerBySession.delete(sessionId);
      return;
    }
    const delay = Math.min(retryBaseDelayMs * 2 ** (attempts - 1), RETRY_MAX_DELAY_MS);
    const timer = setTimeout(() => {
      retryTimerBySession.delete(sessionId);
      if (pendingSessions.has(sessionId) && canRefreshNow(sessionId)) {
        void drain(sessionId);
      }
    }, delay);
    retryTimerBySession.set(sessionId, timer);
  };

  const drain = (sessionId: string): Promise<void> => {
    const existing = inFlightBySession.get(sessionId);
    if (existing) {
      pendingSessions.add(sessionId);
      return existing;
    }

    const request = (async () => {
      try {
        do {
          pendingSessions.delete(sessionId);
          const completed = await executeRefresh(sessionId);
          if (completed === false) {
            pendingSessions.add(sessionId);
            if (canRefreshNow(sessionId)) scheduleRetry(sessionId);
            break;
          }
          clearRetry(sessionId);
        } while (pendingSessions.has(sessionId) && canRefreshNow(sessionId));
      } catch {
        pendingSessions.add(sessionId);
        if (canRefreshNow(sessionId)) scheduleRetry(sessionId);
      }
    })().finally(() => {
      inFlightBySession.delete(sessionId);
    });

    inFlightBySession.set(sessionId, request);
    return request;
  };

  return {
    request(sessionId: string, allowNetwork = true): Promise<void> {
      if (!allowNetwork || !canRefreshNow(sessionId)) {
        pendingSessions.add(sessionId);
        return Promise.resolve();
      }
      return drain(sessionId);
    },

    flushPending(sessionId: string): Promise<void> {
      if (!pendingSessions.has(sessionId) || !canRefreshNow(sessionId)) {
        return Promise.resolve();
      }
      return drain(sessionId);
    },

    discardPending(sessionId: string): void {
      pendingSessions.delete(sessionId);
      clearRetry(sessionId);
    },

    hasPending(sessionId: string): boolean {
      return pendingSessions.has(sessionId);
    },
  };
}

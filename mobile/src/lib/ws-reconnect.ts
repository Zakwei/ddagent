export const WS_RECONNECT_BASE_MS = 1000;
export const WS_RECONNECT_MAX_MS = 30_000;
export const WS_RECONNECT_JITTER_RATIO = 0.2;

/**
 * Exponential backoff with ±20% jitter, capped at 30s. `attempt` is 0-based
 * (0 = first reconnect after a drop); jitter spreads reconnect storms across
 * clients that dropped together.
 */
export function nextReconnectDelay(attempt: number, random: () => number = Math.random): number {
  const capped = Math.min(WS_RECONNECT_BASE_MS * 2 ** Math.max(0, attempt), WS_RECONNECT_MAX_MS);
  const spread = capped * WS_RECONNECT_JITTER_RATIO;
  return Math.round(capped - spread + random() * spread * 2);
}

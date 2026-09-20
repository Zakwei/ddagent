/**
 * Shared number and time formatting for the Control Center screens.
 *
 * Kept in one file so every table and card renders tokens, cost and reset
 * timers identically; the spec requires tabular figures, so all callers apply
 * `tabular-nums` themselves.
 */

/** Formats a token count with a compact K/M/B suffix. */
export function formatTokens(value: number): string {
  if (!Number.isFinite(value) || value === 0) return '0';
  const abs = Math.abs(value);
  if (abs >= 1_000_000_000) return `${(value / 1_000_000_000).toFixed(1)}B`;
  if (abs >= 1_000_000) return `${(value / 1_000_000).toFixed(1)}M`;
  if (abs >= 1_000) return `${(value / 1_000).toFixed(1)}K`;
  return String(Math.round(value));
}

/** Formats a USD amount; small values keep more precision than large ones. */
export function formatCost(value: number): string {
  if (!Number.isFinite(value)) return '$0.00';
  if (value > 0 && Math.abs(value) < 0.01) return '<$0.01';
  return `$${value.toFixed(2)}`;
}

/** Formats a duration in seconds as `42 min`, `1 h 42 min` or `3 d 12 h`. */
export function formatDuration(seconds: number | null): string {
  if (seconds === null || !Number.isFinite(seconds) || seconds <= 0) return '—';
  const minutes = Math.round(seconds / 60);
  if (minutes < 60) return `${minutes} min`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours} h ${minutes % 60} min`;
  return `${Math.floor(hours / 24)} d ${hours % 24} h`;
}

/** Formats a future ISO timestamp as a relative countdown, or `—`. */
export function formatRelativeTo(iso: string | null, now = Date.now()): string {
  if (!iso) return '—';
  const diff = Date.parse(iso) - now;
  if (!Number.isFinite(diff) || diff <= 0) return '—';
  return formatDuration(diff / 1000);
}

/** Formats a Unix epoch in seconds as a relative countdown, or `—`. */
export function formatEpochRelative(epochSeconds: number | null, now = Date.now()): string {
  if (epochSeconds === null) return '—';
  return formatRelativeTo(new Date(epochSeconds * 1000).toISOString(), now);
}

/** Formats elapsed milliseconds as a duration, or `—` when unknown. */
export function formatElapsed(ms: number | null): string {
  return ms === null ? '—' : formatDuration(ms / 1000);
}

/** Formats a UTC date (`YYYY-MM-DD`) as a short axis label (e.g. `09-14`). */
export function formatDayLabel(date: string): string {
  return date.length >= 10 ? date.slice(5) : date;
}

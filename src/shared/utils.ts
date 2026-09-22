/**
 * Environment Flag: Is Platform
 * Indicates if the app is running in Platform mode (hosted) or OSS mode (self-hosted)
 */
export const IS_PLATFORM = import.meta.env?.VITE_IS_PLATFORM === 'true';

/** Rounds a token context-window size to a compact, human-readable string. */
export function formatContextWindow(context: number | undefined): string | null {
  if (!context || !Number.isFinite(context) || context <= 0) {
    return null;
  }
  if (context >= 1_000_000) {
    const millions = Math.round(context / 100_000) / 10;
    return `${millions % 1 === 0 ? Math.round(millions) : millions}M`;
  }
  if (context >= 1_000) {
    return `${Math.round(context / 1_000)}k`;
  }
  return `${context}`;
}

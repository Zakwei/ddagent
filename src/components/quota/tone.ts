import type { AgentFleetStatus, QuotaDataQuality } from './types';

/** Status colours used across every Control Center surface. */
export type Tone = 'safe' | 'watch' | 'danger' | 'neutral' | 'info';

/**
 * Colour carries status only: never brand.
 *
 * safe = plenty of room, watch = over the observation threshold, danger = work
 * will be interrupted, neutral = inactive/estimated, info = loading or cached.
 */
export const TONE_BAR: Record<Tone, string> = {
  safe: 'bg-emerald-500',
  watch: 'bg-amber-500',
  danger: 'bg-red-500',
  neutral: 'bg-zinc-500',
  info: 'bg-sky-500',
};

export const TONE_TEXT: Record<Tone, string> = {
  safe: 'text-emerald-600 dark:text-emerald-400',
  watch: 'text-amber-600 dark:text-amber-400',
  danger: 'text-red-600 dark:text-red-400',
  neutral: 'text-muted-foreground',
  info: 'text-sky-600 dark:text-sky-400',
};

export const TONE_DOT: Record<Tone, string> = {
  safe: 'bg-emerald-500',
  watch: 'bg-amber-500',
  danger: 'bg-red-500',
  neutral: 'bg-zinc-500',
  info: 'bg-sky-500',
};

/**
 * Maps a usage percent onto a status tone using the configured thresholds.
 *
 * The same thresholds the backend uses for alerts, so the card and the KPI row
 * never disagree about what counts as "at risk".
 */
export function toneForPercent(percent: number, watch: number, danger: number): Tone {
  if (percent >= danger) return 'danger';
  if (percent >= watch) return 'watch';
  return 'safe';
}

/** Colour for a data-quality badge; only `error` is alarming. */
export function toneForQuality(quality: QuotaDataQuality): Tone {
  switch (quality) {
    case 'live':
      return 'safe';
    case 'cached':
      return 'info';
    case 'estimate':
    case 'unknown':
      return 'neutral';
    case 'error':
      return 'danger';
  }
}

/** Colour for a fleet status pill. */
export function toneForAgentStatus(status: AgentFleetStatus): Tone {
  switch (status) {
    case 'running':
      return 'info';
    case 'waiting':
      return 'watch';
    case 'failed':
      return 'danger';
    case 'queued':
      return 'neutral';
    case 'finished':
      return 'safe';
  }
}

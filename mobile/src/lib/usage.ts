// Pure helpers for the token-usage / quota / activity surfaces — no RN deps.
// Mirrors web TokenUsageSummary.tsx, QuotaBadge.tsx, ActivityIndicator.tsx.

import type { UsageResponse, UsageWindow } from './model-menu';

/** Section a model name maps to (duplicated from model-menu to keep this
 *  module free of runtime relative imports so Node ESM can load it). */
export function sectionForModel(model?: string | null): string | null {
  if (!model) return null;
  const m = model.toLowerCase();
  if (m.startsWith('google/') || m.includes('antigravity')) return 'gemini';
  if (m.startsWith('commandcode/')) return 'commandcode';
  if (m.startsWith('opencode/') || m.startsWith('opencode-go/')) return 'opencode';
  if (m.startsWith('nvidia/')) return 'byok';
  return null;
}

export const readUsageNumber = (value: unknown): number => {
  const parsed = Number(value);
  return Number.isFinite(parsed) ? parsed : 0;
};

export function formatTokenCount(value: number): string {
  if (!Number.isFinite(value) || value <= 0) return '0';
  if (value >= 1_000_000) return `${(value / 1_000_000).toFixed(value >= 10_000_000 ? 0 : 1)}M`;
  if (value >= 10_000) return `${Math.round(value / 1_000)}K`;
  if (value >= 1_000) return `${(value / 1_000).toFixed(1)}K`;
  return value.toLocaleString();
}

export interface TokenBreakdown {
  unsupported: boolean;
  message?: string;
  used: number;
  total: number;
  input: number;
  cacheRead: number;
  cacheCreation: number;
  cache: number;
  output: number;
  contextPercent: number | null;
  barColor: string;
}

export function tokenBreakdown(usage: Record<string, unknown> | null | undefined): TokenBreakdown | null {
  if (!usage) return null;
  const breakdown = usage.breakdown && typeof usage.breakdown === 'object'
    ? (usage.breakdown as Record<string, unknown>)
    : null;
  const unsupported = usage.unsupported === true;
  const output = readUsageNumber(usage.outputTokens ?? breakdown?.output);
  const used = readUsageNumber(usage.used) || readUsageNumber(usage.inputTokens) + output;
  const cacheRead = readUsageNumber(
    usage.cacheReadTokens ?? usage.cache_read_input_tokens ?? usage.cacheReadInputTokens ?? breakdown?.cacheRead,
  );
  const cacheCreation = readUsageNumber(
    usage.cacheCreationTokens ?? usage.cache_creation_input_tokens ?? usage.cacheCreationInputTokens ?? breakdown?.cacheCreation,
  );
  const cache = cacheRead + cacheCreation;
  const reportedInput = readUsageNumber(usage.inputTokens ?? breakdown?.input);
  const input = breakdown ? reportedInput : Math.max(0, reportedInput - cache);
  const total = readUsageNumber(usage.total);
  const contextPercent = !unsupported && total > 0 ? Math.min(100, Math.round((used / total) * 100)) : null;
  const barColor = contextPercent === null ? '' : contextPercent >= 85 ? '#ef4444' : contextPercent >= 60 ? '#f59e0b' : '#10b981';
  return {
    unsupported,
    message: typeof usage.message === 'string' ? usage.message : undefined,
    used,
    total,
    input,
    cacheRead,
    cacheCreation,
    cache,
    output,
    contextPercent,
    barColor,
  };
}

export const DEFAULT_ACTION_WORDS = ['Thinking', 'Processing', 'Analyzing', 'Working', 'Computing', 'Reasoning'];

/** Rotating activity label; explicit statusText wins, otherwise 4s per word. */
export function activityLabel(statusText: string | null | undefined, elapsedSeconds: number): string {
  const base = statusText && statusText.trim()
    ? statusText
    : DEFAULT_ACTION_WORDS[Math.floor(Math.max(0, elapsedSeconds) / 4) % DEFAULT_ACTION_WORDS.length];
  return base.replace(/\.+$/, '');
}

export function formatElapsed(seconds: number): string {
  const s = Math.max(0, Math.floor(seconds));
  const minutes = Math.floor(s / 60);
  return minutes < 1 ? `${s % 60}s` : `${minutes}m ${s % 60}s`;
}

export type QuotaTone = 'ok' | 'warn' | 'critical';

export const quotaTone = (percent: number, watch: number, danger: number): QuotaTone =>
  percent >= danger ? 'critical' : percent >= watch ? 'warn' : 'ok';

export const TONE_TEXT: Record<QuotaTone, string> = { ok: 'foreground', warn: '#f59e0b', critical: '#ef4444' };
export const TONE_ICON: Record<QuotaTone, string> = { ok: 'primary', warn: '#f59e0b', critical: '#ef4444' };

/** Gemini sections split their windows by model family. */
export function windowMatchesModel(windowKey: string, model?: string | null): boolean {
  if (!model) return true;
  const m = model.toLowerCase();
  const isGemini = m.includes('gemini');
  const isClaudeOrGpt = m.includes('claude') || m.includes('gpt');
  if (windowKey.startsWith('Gemini Models')) return isGemini;
  if (windowKey.startsWith('Claude and GPT')) return isClaudeOrGpt;
  return true;
}

export interface QuotaBadgeInfo {
  percent: number | null;
  tone: QuotaTone;
  plan: string;
  lines: string[];
}

/** Worst matching subscription window for the selected model (web QuotaBadge). */
export function quotaBadgeFor(
  usage: UsageResponse | null,
  provider: string | undefined,
  model: string | null | undefined,
  thresholds: { watch: number; danger: number },
): QuotaBadgeInfo | null {
  if (!usage) return null;
  const sectionKey = sectionForModel(model)
    ?? (provider === 'devin' || provider === 'claude' ? 'devin' : provider === 'opencode' ? 'opencode' : null);
  if (!sectionKey) return null;
  const section = usage[sectionKey];
  if (!section) return null;
  const lines: string[] = [];
  if (section.error) lines.push(`${section.plan}: ${section.error}`);
  let worst: { key: string; w: UsageWindow } | null = null;
  for (const [key, w] of Object.entries(section.windows ?? {})) {
    if (!windowMatchesModel(key, model)) continue;
    lines.push(`${key}: ${w.percent}%${w.resetsAt ? ` · reset ${new Date(w.resetsAt).toLocaleString()}` : ''}`);
    if (!worst || w.percent > worst.w.percent) worst = { key, w };
  }
  const percent = worst?.w.percent ?? null;
  return {
    percent,
    tone: percent === null ? 'ok' : quotaTone(percent, thresholds.watch, thresholds.danger),
    plan: section.plan ?? sectionKey,
    lines,
  };
}

export interface ReplayCursor {
  runId?: string | null;
  seq: number;
}

/** Advance a per-session replay cursor from a sequenced frame (new run resets seq). */
export function advanceCursor(known: ReplayCursor | undefined, runId: string | null | undefined, seq: number): ReplayCursor {
  if (!known) return { runId: runId ?? null, seq };
  if (runId !== known.runId) return { runId: runId ?? null, seq };
  return seq > known.seq ? { runId: known.runId, seq } : known;
}

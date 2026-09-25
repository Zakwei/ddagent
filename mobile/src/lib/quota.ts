import { useCallback, useEffect, useRef, useState } from 'react';

import { api } from '~shared/utils/api';

export type QuotaWindowKind =
  | 'session'
  | 'daily'
  | 'weekly'
  | 'monthly'
  | 'credits'
  | 'metered'
  | 'rolling';

export type QuotaWindow = {
  label: string;
  kind: QuotaWindowKind;
  percent: number;
  remainingPercent: number;
  resetsAt: string | null;
  status: string;
  projectedExhaustionAt: string | null;
  etaSeconds: number | null;
  burnRatePerHour: number | null;
};

export type QuotaAssignedAgent = {
  agentId: string;
  role: string;
  activeTasks: number;
};

export type QuotaDataQuality = 'live' | 'cached' | 'estimate' | 'unknown' | 'error';

export type QuotaAccount = {
  id: string;
  provider: string;
  providerLabel: string;
  plan: string;
  accountLabel: string;
  status: 'active' | 'inactive' | 'error';
  quality: QuotaDataQuality;
  lastSyncedAt: string | null;
  syncError: string | null;
  windows: QuotaWindow[];
  assignedAgents: QuotaAssignedAgent[];
};

export type QuotaOverview = {
  accountsAtRisk: number;
  accountsErrored: number;
  windowsAtRisk: number;
  nextResetAt: string | null;
  watchThreshold: number;
  dangerThreshold: number;
};

export type QuotaSnapshot = {
  overview: QuotaOverview;
  accounts: QuotaAccount[];
  generatedAt: string;
};

export type QuotaConfig = {
  routingMode: 'manual' | 'ask' | 'auto-low-risk';
  alertsEnabled: boolean;
  watchThreshold: number;
  dangerThreshold: number;
  accounts: Array<{ accountId: string; watchThreshold: number; dangerThreshold: number; routingEnabled: boolean }>;
};

export type QuotaHistoryPoint = {
  label: string;
  percent: number;
  at: string;
  resetsAt: string | null;
};

export type QuotaHistory = {
  accountId: string;
  points: QuotaHistoryPoint[];
};

export type InsightPeriod = '24h' | '7d' | '30d' | 'all';
export type UsageGroupBy = 'provider' | 'model' | 'agent' | 'tool';

export type UsageTotals = {
  tokensInput: number;
  tokensOutput: number;
  tokensReasoning: number;
  tokensCacheRead: number;
  tokensCacheWrite: number;
  tokensTotal: number;
  apiCalls: number;
  costUsd: number;
  sessions: number;
};

export type UsageBucket = UsageTotals & { key: string; label: string };

export type UsageTrendPoint = {
  date: string;
  tokensTotal: number;
  costUsd: number;
};

export type EffectiveCost = {
  billedUsd: number;
  listPriceUsd: number;
  subscriptionValueUsd: number;
};

export type UsageSummary = {
  period: InsightPeriod;
  groupBy: UsageGroupBy;
  totals: UsageTotals;
  buckets: UsageBucket[];
  trend: UsageTrendPoint[];
  cacheSavingsUsd: number;
  effectiveCost: EffectiveCost;
  source: string;
  generatedAt: string;
};

export type AgentFleetStatus = 'running' | 'waiting' | 'failed' | 'finished' | 'queued';

export type AgentFleetEntry = {
  agentId: string;
  role: string;
  status: AgentFleetStatus;
  taskId: string | null;
  taskTitle: string | null;
  provider: string | null;
  model: string | null;
  sessionId: string | null;
  tokensTotal: number;
  costUsd: number;
  startedAt: string | null;
  elapsedSeconds: number;
  result: string | null;
  retryCount: number | null;
};

export type AgentFleetSummary = {
  running: number;
  waiting: number;
  failed: number;
  finished: number;
  queued: number;
  totalTokens: number;
  totalCostUsd: number;
};

export type AgentFleetSnapshot = {
  entries: AgentFleetEntry[];
  summary: AgentFleetSummary;
  generatedAt: string;
};

type QuotaApiResponse<TData> = {
  success?: boolean;
  data?: TData;
  error?: string;
};

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

/** Relative "ago" for a past ISO timestamp. */
export function formatAgo(iso: string | null, now = Date.now()): string | null {
  if (!iso) return null;
  const diff = now - Date.parse(iso);
  if (!Number.isFinite(diff) || diff < 0) return null;
  return formatDuration(Math.max(0, diff / 1000));
}

export type Tone = 'safe' | 'watch' | 'danger' | 'neutral' | 'info';

/** Bar / dot fill colours per tone (500-scale on both schemes). */
export const TONE_FILL: Record<Tone, string> = {
  safe: '#10b981',
  watch: '#f59e0b',
  danger: '#ef4444',
  neutral: '#71717a',
  info: '#0ea5e9',
};

/** Text colours per tone; lighter 400-scale on dark for contrast. */
export function toneTextColor(tone: Tone, isDark: boolean): string {
  const light: Record<Tone, string> = {
    safe: '#059669',
    watch: '#d97706',
    danger: '#dc2626',
    neutral: '#71717a',
    info: '#0284c7',
  };
  const dark: Record<Tone, string> = {
    safe: '#34d399',
    watch: '#fbbf24',
    danger: '#f87171',
    neutral: '#a1a1aa',
    info: '#38bdf8',
  };
  return (isDark ? dark : light)[tone];
}

/** Maps a usage percent onto a status tone using the configured thresholds. */
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

/** Unwraps the `{ success, data }` envelope shared by every quota endpoint. */
export async function loadData<TData>(endpoint: Promise<Response>): Promise<TData> {
  const response = await endpoint;
  const payload = (await response.json()) as QuotaApiResponse<TData>;
  if (!response.ok || payload.success === false || payload.data === undefined) {
    throw new Error(payload.error ?? 'Request failed');
  }
  return payload.data;
}

/** Poll interval; matches the backend's 5-minute cache window. */
const POLL_MS = 5 * 60 * 1000;

export function useQuotaSnapshot() {
  const [snapshot, setSnapshot] = useState<QuotaSnapshot | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const refresh = useCallback(async () => {
    setIsRefreshing(true);
    try {
      setSnapshot(await loadData<QuotaSnapshot>(api.quota.refresh()));
      setError(null);
    } catch (refreshError) {
      setError(refreshError instanceof Error ? refreshError.message : 'Refresh failed');
    } finally {
      setIsRefreshing(false);
    }
  }, []);

  useEffect(() => {
    let cancelled = false;
    const doPoll = async () => {
      try {
        const data = await loadData<QuotaSnapshot>(api.quota.get());
        if (!cancelled) {
          setSnapshot(data);
          setError(null);
        }
      } catch (loadError) {
        if (!cancelled) {
          setError(loadError instanceof Error ? loadError.message : 'Failed to load quota snapshot');
        }
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    };
    void doPoll();
    const interval = setInterval(() => void doPoll(), POLL_MS);
    return () => {
      cancelled = true;
      clearInterval(interval);
    };
  }, []);

  return { snapshot, isLoading, isRefreshing, error, refresh };
}

export function useQuotaConfig(active = true) {
  const [config, setConfig] = useState<QuotaConfig | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      setConfig(await loadData<QuotaConfig>(api.quota.getConfig()));
      setError(null);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Failed to load quota config');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (active) void load();
  }, [active, load]);

  return { config, isLoading, error, reload: load };
}

export function useUsageSummary(period: InsightPeriod, groupBy: UsageGroupBy, active = true) {
  const [summary, setSummary] = useState<UsageSummary | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!active) return undefined;
    let cancelled = false;
    const load = async () => {
      setIsLoading(true);
      try {
        const data = await loadData<UsageSummary>(api.quota.usage(period, groupBy));
        if (!cancelled) {
          setSummary(data);
          setError(null);
        }
      } catch (loadError) {
        if (!cancelled) {
          setError(loadError instanceof Error ? loadError.message : 'Failed to load usage');
        }
      } finally {
        if (!cancelled) setIsLoading(false);
      }
    };
    void load();
    return () => {
      cancelled = true;
    };
  }, [period, groupBy, active]);

  return { summary, isLoading, error };
}

export function useAgentFleet(active = true) {
  const [fleet, setFleet] = useState<AgentFleetSnapshot | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      setFleet(await loadData<AgentFleetSnapshot>(api.quota.agents()));
      setError(null);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Failed to load agents');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    if (!active) return undefined;
    void load();
    // Agents change faster than quotas; a 60-second poll keeps the table close
    // to live without opening a websocket channel for this read-only view.
    const interval = setInterval(() => void load(), 60_000);
    return () => clearInterval(interval);
  }, [active, load]);

  return { fleet, isLoading, error, reload: load };
}

const historyCache = new Map<string, QuotaHistory | null>();

/** Loads the recorded percent history of one account for the sparkline. */
export function useQuotaHistory(accountId: string | null, limit = 120): QuotaHistory | null {
  const [history, setHistory] = useState<QuotaHistory | null>(() =>
    accountId ? historyCache.get(accountId) ?? null : null,
  );
  const idRef = useRef(accountId);
  idRef.current = accountId;

  useEffect(() => {
    if (!accountId) {
      setHistory(null);
      return undefined;
    }
    const cached = historyCache.get(accountId);
    if (cached !== undefined) {
      setHistory(cached);
      return undefined;
    }
    let cancelled = false;
    void (async () => {
      try {
        const data = await loadData<QuotaHistory>(api.quota.history(accountId, limit));
        historyCache.set(accountId, data);
        if (!cancelled && idRef.current === accountId) setHistory(data);
      } catch {
        historyCache.set(accountId, null);
        if (!cancelled && idRef.current === accountId) setHistory(null);
      }
    })();
    return () => {
      cancelled = true;
    };
  }, [accountId, limit]);

  return history;
}

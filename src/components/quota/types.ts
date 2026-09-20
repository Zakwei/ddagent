export type QuotaDataQuality = 'live' | 'cached' | 'estimate' | 'unknown' | 'error';

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
};

export type QuotaSnapshot = {
  overview: QuotaOverview;
  accounts: QuotaAccount[];
  generatedAt: string;
};

export type QuotaRoutingMode = 'manual' | 'ask' | 'auto-low-risk';

export type QuotaAccountConfig = {
  accountId: string;
  watchThreshold: number;
  dangerThreshold: number;
  routingEnabled: boolean;
};

export type QuotaConfig = {
  routingMode: QuotaRoutingMode;
  alertsEnabled: boolean;
  watchThreshold: number;
  dangerThreshold: number;
  accounts: QuotaAccountConfig[];
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

export type QuotaApiResponse<TData> = {
  success?: boolean;
  data?: TData;
  error?: string;
};

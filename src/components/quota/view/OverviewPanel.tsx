import { Activity, AlertTriangle, Coins, Gauge, Hash, TrendingUp, Users } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { Card, CardContent, CardHeader, CardTitle, EmptyState } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import { formatCost, formatDuration, formatRelativeTo, formatTokens } from '../format';
import { TONE_BAR, TONE_DOT, TONE_TEXT, toneForPercent } from '../tone';
import { useAgentFleet, useUsageSummary } from '../hooks/useUsageSummary';
import type { InsightPeriod, QuotaAccount, QuotaConfig, QuotaSnapshot, QuotaWindow } from '../types';

import TrendChart from './TrendChart';

type OverviewPanelProps = {
  snapshot: QuotaSnapshot | null;
  config: QuotaConfig | null;
  /** Period selected in the page header, applied to the usage summary. */
  period: InsightPeriod;
  onOpenQuotas: () => void;
  onOpenAgents: () => void;
};

/** Worst (highest) window of an account, shown in the compact limits list. */
function worstWindow(account: QuotaAccount): QuotaWindow | null {
  if (account.windows.length === 0) return null;
  return account.windows.reduce((worst, window) => (window.percent > worst.percent ? window : worst));
}

function Kpi({
  label,
  value,
  hint,
  icon,
  tone,
  onClick,
}: {
  label: string;
  value: string;
  hint?: string;
  icon: React.ReactNode;
  tone: 'safe' | 'watch' | 'danger' | 'neutral';
  onClick?: () => void;
}) {
  const toneClass = TONE_TEXT[tone];

  return (
    <Card
      className={cn(onClick && 'cursor-pointer transition-colors hover:border-foreground/20')}
      onClick={onClick}
    >
      <CardContent className="flex items-center gap-3 p-4">
        <div className={cn('flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-muted', toneClass)}>
          {icon}
        </div>
        <div className="min-w-0">
          <p className="text-xs text-muted-foreground">{label}</p>
          <p className={cn('text-lg font-semibold tabular-nums', toneClass)}>{value}</p>
          {hint && <p className="truncate text-[11px] tabular-nums text-muted-foreground">{hint}</p>}
        </div>
      </CardContent>
    </Card>
  );
}

/**
 * Overview of the Control Center, laid out like the reference mock: a four-KPI
 * top row, a two-column body (usage/limits beside active tasks), a full-width
 * trend with a period switch, and the alert list last.
 *
 * The period switch only refetches the usage summary, so changing it never
 * triggers a provider quota sweep.
 */
export default function OverviewPanel({ snapshot, config, period, onOpenQuotas, onOpenAgents }: OverviewPanelProps) {
  const { t } = useTranslation('common');
  const { summary } = useUsageSummary(period, 'provider');
  const { fleet } = useAgentFleet();

  const watch = config?.watchThreshold ?? 75;
  const danger = config?.dangerThreshold ?? 90;
  const overview = snapshot?.overview ?? null;

  const accounts = snapshot?.accounts ?? [];

  const paceAlerts = accounts.flatMap((account) =>
    account.windows
      .filter((window) => window.etaSeconds !== null)
      .map((window) => ({ account, window })),
  );
  const riskyWindows = accounts.flatMap((account) =>
    account.windows.filter((window) => window.etaSeconds === null && window.percent >= watch).map((window) => ({ account, window })),
  );

  const activeAgents = (fleet?.entries ?? []).filter(
    (entry) => entry.status === 'running' || entry.status === 'waiting' || entry.status === 'queued',
  );

  return (
    <div className="space-y-4">
      <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 xl:grid-cols-4">
        <Kpi
          icon={<AlertTriangle className="h-4 w-4" />}
          label={t('quota.kpi.atRisk', 'Limits at risk')}
          value={String(overview?.accountsAtRisk ?? 0)}
          hint={t('quota.kpi.atRiskHint', 'accounts over {{value}}%', { value: watch })}
          tone={(overview?.accountsAtRisk ?? 0) > 0 ? 'watch' : 'safe'}
          onClick={onOpenQuotas}
        />
        <Kpi
          icon={<Users className="h-4 w-4" />}
          label={t('quota.kpi.activeAgents', 'Active agents')}
          value={String(fleet?.summary.running ?? 0)}
          hint={t('quota.kpi.agentsHint', '{{waiting}} waiting · {{queued}} queued', {
            waiting: fleet?.summary.waiting ?? 0,
            queued: fleet?.summary.queued ?? 0,
          })}
          tone="neutral"
          onClick={onOpenAgents}
        />
        <Kpi
          icon={<Hash className="h-4 w-4" />}
          label={t('quota.kpi.tokens', 'Tokens')}
          value={formatTokens(summary?.totals.tokensTotal ?? 0)}
          hint={t('quota.kpi.sessionsHint', '{{value}} sessions', { value: summary?.totals.sessions ?? 0 })}
          tone="neutral"
        />
        <Kpi
          icon={<Coins className="h-4 w-4" />}
          label={t('quota.kpi.cost', 'Estimated cost')}
          value={formatCost(summary?.totals.costUsd ?? 0)}
          hint={t('quota.kpi.costHint', '{{value}} covered by plans', {
            value: formatCost(summary?.effectiveCost.subscriptionValueUsd ?? 0),
          })}
          tone="neutral"
        />
      </div>

      <div className="grid grid-cols-1 gap-3 lg:grid-cols-2">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0">
            <CardTitle className="text-sm">
              <Gauge className="mr-1.5 inline h-4 w-4" />
              {t('quota.overview.limitsTitle', 'Usage and limits')}
            </CardTitle>
            <button
              type="button"
              onClick={onOpenQuotas}
              className="text-xs text-muted-foreground transition-colors hover:text-foreground"
            >
              {t('quota.overview.viewAccounts', 'All accounts')}
            </button>
          </CardHeader>
          <CardContent className="space-y-3">
            {accounts.length === 0 && (
              <EmptyState size="sm" icon={Gauge} title={t('quota.empty.title', 'No accounts connected')} />
            )}
            {accounts.map((account) => {
              const window = worstWindow(account);
              const tone = account.status === 'error' ? 'danger' : window ? toneForPercent(window.percent, watch, danger) : 'neutral';
              return (
                <div key={account.id} className="space-y-1">
                  <div className="flex items-baseline justify-between gap-2 text-xs">
                    <span className="min-w-0 truncate">
                      <span className="font-medium">{account.providerLabel}</span>
                      {account.accountLabel && (
                        <span className="text-muted-foreground"> · {account.accountLabel}</span>
                      )}
                    </span>
                    {account.status === 'error' ? (
                      <span className="shrink-0 tabular-nums text-red-600 dark:text-red-400">
                        {t('quota.quality.error', 'Error')}
                      </span>
                    ) : account.status === 'inactive' ? (
                      <span className="shrink-0 text-muted-foreground">
                        {t('quota.noSubscription', 'No subscription')}
                      </span>
                    ) : window ? (
                      <span className={cn('shrink-0 tabular-nums', TONE_TEXT[tone])}>
                        {window.percent}% · {formatRelativeTo(window.resetsAt)}
                      </span>
                    ) : null}
                  </div>
                  <div className="h-1.5 overflow-hidden rounded-full bg-muted">
                    <div
                      className={cn('h-full rounded-full', TONE_BAR[tone])}
                      style={{ width: `${account.status === 'error' || !window ? 0 : window.percent}%` }}
                    />
                  </div>
                </div>
              );
            })}
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between space-y-0">
            <CardTitle className="text-sm">
              <Activity className="mr-1.5 inline h-4 w-4" />
              {t('quota.overview.activeTasks', 'Active tasks')}
            </CardTitle>
            <button
              type="button"
              onClick={onOpenAgents}
              className="text-xs text-muted-foreground transition-colors hover:text-foreground"
            >
              {t('quota.overview.viewAgents', 'All agents')}
            </button>
          </CardHeader>
          <CardContent className="space-y-2">
            {activeAgents.length === 0 && (
              <EmptyState size="sm" icon={Activity} title={t('quota.overview.noTasks', 'No agents are running right now.')} />
            )}
            {activeAgents.slice(0, 6).map((entry) => (
              <div key={entry.agentId} className="flex items-center gap-2 text-xs">
                <span className={cn('h-2 w-2 shrink-0 rounded-full', TONE_DOT[entry.status === 'running' ? 'info' : entry.status === 'waiting' ? 'watch' : 'neutral'])} />
                <span className="min-w-0 flex-1 truncate">{entry.taskTitle ?? entry.role}</span>
                <span className="shrink-0 tabular-nums text-muted-foreground">
                  {formatDuration(entry.elapsedSeconds || null)}
                </span>
              </div>
            ))}
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader className="flex flex-row items-center justify-between space-y-0">
          <CardTitle className="text-sm">
            <TrendingUp className="mr-1.5 inline h-4 w-4" />
            {t('quota.overview.trendTitle', 'Tokens and cost')}
          </CardTitle>
        </CardHeader>
        <CardContent>
          {summary && (
            <p className="mb-2 text-xs tabular-nums text-muted-foreground">
              {formatTokens(summary.totals.tokensTotal)} · {formatCost(summary.totals.costUsd)}
            </p>
          )}
          <TrendChart trend={summary?.trend ?? []} />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-sm">{t('quota.overview.alertsTitle', 'Alerts')}</CardTitle>
        </CardHeader>
        <CardContent className="space-y-2 text-xs">
          {paceAlerts.length === 0 && riskyWindows.length === 0 && (
            <p className="text-muted-foreground">
              {t('quota.overview.noAlerts', 'Nothing needs attention right now.')}
            </p>
          )}
          {paceAlerts.map(({ account, window }) => (
            <p key={`${account.id}-${window.label}-pace`} className="text-amber-600 dark:text-amber-400">
              {t('quota.alert.pace', '{{account}} · {{window}}: at the current pace the limit runs out in {{value}}', {
                account: account.providerLabel,
                window: window.label,
                value: formatRelativeTo(window.projectedExhaustionAt),
              })}
            </p>
          ))}
          {riskyWindows.map(({ account, window }) => (
            <p
              key={`${account.id}-${window.label}-threshold`}
              className={cn(
                window.percent >= danger ? 'text-red-600 dark:text-red-400' : 'text-amber-600 dark:text-amber-400',
              )}
            >
              {t('quota.alert.threshold', '{{account}} · {{window}}: {{value}}% used (threshold {{watch}}%)', {
                account: account.providerLabel,
                window: window.label,
                value: window.percent,
                watch,
              })}
            </p>
          ))}
        </CardContent>
      </Card>
    </div>
  );
}

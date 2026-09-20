import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Card, CardContent, CardHeader, CardTitle, Pill, PillBar  } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import { formatCost, formatTokens } from '../format';
import { useUsageSummary } from '../hooks/useUsageSummary';
import type { InsightPeriod, UsageGroupBy } from '../types';

import TrendChart from './TrendChart';

const PERIODS: InsightPeriod[] = ['24h', '7d', '30d', 'all'];
const GROUPS: UsageGroupBy[] = ['provider', 'model', 'agent', 'tool'];

const PERIOD_KEY: Record<InsightPeriod, string> = {
  '24h': 'quota.period.24h',
  '7d': 'quota.period.7d',
  '30d': 'quota.period.30d',
  all: 'quota.period.all',
};

const GROUP_KEY: Record<UsageGroupBy, string> = {
  provider: 'quota.group.provider',
  model: 'quota.group.model',
  agent: 'quota.group.agent',
  tool: 'quota.group.tool',
};

/**
 * Usage explorer: token and cost totals per provider/model/agent/tool for a
 * selected period, plus the daily trend.
 *
 * Tokens, requests and cost are kept as separate columns; the spec explicitly
 * warns against collapsing them into one number.
 */
export default function UsagePanel() {
  const { t } = useTranslation('common');
  const [period, setPeriod] = useState<InsightPeriod>('7d');
  const [groupBy, setGroupBy] = useState<UsageGroupBy>('provider');
  const { summary, isLoading, error } = useUsageSummary(period, groupBy);

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-2">
        <PillBar>
          {PERIODS.map((id) => (
            <Pill key={id} isActive={period === id} onClick={() => setPeriod(id)}>
              {t(PERIOD_KEY[id], id)}
            </Pill>
          ))}
        </PillBar>
        <PillBar>
          {GROUPS.map((id) => (
            <Pill key={id} isActive={groupBy === id} onClick={() => setGroupBy(id)}>
              {t(GROUP_KEY[id], id)}
            </Pill>
          ))}
        </PillBar>
      </div>

      {error && <p className="text-xs text-red-600 dark:text-red-400">{error}</p>}

      <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
        <Metric label={t('quota.metric.tokens', 'Tokens')} value={formatTokens(summary?.totals.tokensTotal ?? 0)} />
        <Metric label={t('quota.metric.cost', 'Cost')} value={formatCost(summary?.totals.costUsd ?? 0)} />
        <Metric label={t('quota.metric.calls', 'API calls')} value={String(summary?.totals.apiCalls ?? 0)} />
        <Metric label={t('quota.metric.sessions', 'Sessions')} value={String(summary?.totals.sessions ?? 0)} />
      </div>

      <Card>
        <CardHeader>
          <CardTitle className="text-sm">{t('quota.usage.trendTitle', 'Daily trend')}</CardTitle>
        </CardHeader>
        <CardContent>
          <TrendChart trend={summary?.trend ?? []} />
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle className="text-sm">
            {t('quota.usage.breakdownTitle', 'Breakdown by {{group}}', {
              group: t(GROUP_KEY[groupBy], groupBy),
            })}
          </CardTitle>
        </CardHeader>
        <CardContent className="overflow-x-auto">
          {isLoading && !summary ? (
            <p className="py-4 text-xs text-muted-foreground">{t('quota.loading', 'Loading…')}</p>
          ) : (
            <table className="w-full text-xs">
              <thead>
                <tr className="border-b border-border/60 text-left text-muted-foreground">
                  <th className="py-2 pr-3 font-medium">{t('quota.usage.colName', 'Name')}</th>
                  <th className="py-2 pr-3 text-right font-medium">{t('quota.metric.input', 'Input')}</th>
                  <th className="py-2 pr-3 text-right font-medium">{t('quota.metric.output', 'Output')}</th>
                  <th className="py-2 pr-3 text-right font-medium">{t('quota.metric.cache', 'Cache read')}</th>
                  <th className="py-2 pr-3 text-right font-medium">{t('quota.metric.tokens', 'Tokens')}</th>
                  <th className="py-2 pr-3 text-right font-medium">{t('quota.metric.calls', 'Calls')}</th>
                  <th className="py-2 text-right font-medium">{t('quota.metric.cost', 'Cost')}</th>
                </tr>
              </thead>
              <tbody>
                {(summary?.buckets ?? []).map((bucket) => (
                  <tr key={bucket.key} className="border-b border-border/40 last:border-0">
                    <td className="max-w-64 truncate py-2 pr-3" title={bucket.label}>
                      {bucket.label}
                    </td>
                    <td className="py-2 pr-3 text-right tabular-nums">{formatTokens(bucket.tokensInput)}</td>
                    <td className="py-2 pr-3 text-right tabular-nums">{formatTokens(bucket.tokensOutput)}</td>
                    <td className="py-2 pr-3 text-right tabular-nums">{formatTokens(bucket.tokensCacheRead)}</td>
                    <td className="py-2 pr-3 text-right font-medium tabular-nums">{formatTokens(bucket.tokensTotal)}</td>
                    <td className="py-2 pr-3 text-right tabular-nums">{bucket.apiCalls}</td>
                    <td className="py-2 text-right tabular-nums">{formatCost(bucket.costUsd)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          )}
          {summary?.source === 'unavailable' && (
            <p className="pt-2 text-[11px] text-muted-foreground">
              {t('quota.usage.sourceUnavailable', 'Analytics store unavailable; showing no data.')}
            </p>
          )}
        </CardContent>
      </Card>
    </div>
  );
}

function Metric({ label, value, className }: { label: string; value: string; className?: string }) {
  return (
    <Card>
      <CardContent className={cn('p-3', className)}>
        <p className="text-[11px] text-muted-foreground">{label}</p>
        <p className="text-base font-semibold tabular-nums">{value}</p>
      </CardContent>
    </Card>
  );
}

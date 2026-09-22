import { useState } from 'react';
import { Bot, ChevronDown, RefreshCw, Users } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { Badge, Button, Card, CardContent, EmptyState } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import { formatCost, formatDuration, formatTokens } from '../format';
import { TONE_DOT, TONE_TEXT, toneForAgentStatus } from '../tone';
import { useAgentFleet } from '../hooks/useUsageSummary';
import type { AgentFleetEntry, AgentFleetStatus } from '../types';

const STATUS_KEY: Record<AgentFleetStatus, string> = {
  running: 'quota.agentStatus.running',
  waiting: 'quota.agentStatus.waiting',
  failed: 'quota.agentStatus.failed',
  finished: 'quota.agentStatus.finished',
  queued: 'quota.agentStatus.queued',
};

const STATUS_ORDER: AgentFleetStatus[] = ['running', 'waiting', 'queued', 'failed', 'finished'];

/**
 * Operational view of every agent: what it runs, on which account, for how
 * long and at what token cost.
 *
 * Expanding a row reveals the run outline (task → status → result) instead of a
 * raw terminal log, so work can be reviewed without leaving the dashboard.
 */
export default function AgentsPanel() {
  const { t } = useTranslation('common');
  const { fleet, isLoading, error, reload } = useAgentFleet();
  const [status, setStatus] = useState<AgentFleetStatus | '__all__'>('__all__');
  const [expanded, setExpanded] = useState<string | null>(null);

  const entries = (fleet?.entries ?? []).filter(
    (entry) => status === '__all__' || entry.status === status,
  );
  const summary = fleet?.summary;

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap items-center gap-2">
        <Badge variant="outline" className="gap-1 border-sky-500/40 text-sky-600 dark:text-sky-400">
          <Users className="h-3 w-3" />
          {t('quota.agents.runningCount', '{{value}} running', { value: summary?.running ?? 0 })}
        </Badge>
        <Badge variant="outline" className="tabular-nums">
          {formatTokens(summary?.totalTokens ?? 0)} · {formatCost(summary?.totalCostUsd ?? 0)}
        </Badge>
        <Button variant="outline" size="sm" className="ml-auto" onClick={() => void reload()}>
          <RefreshCw className={cn('h-3.5 w-3.5', isLoading && 'animate-spin')} />
          {t('quota.syncNow', 'Refresh')}
        </Button>
      </div>

      <div className="flex flex-wrap gap-1">
        <button
          type="button"
          onClick={() => setStatus('__all__')}
          className={cn(
            'rounded-md px-2 py-1 text-xs font-medium transition-colors',
            status === '__all__' ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground',
          )}
        >
          {t('quota.filter.all', 'All')}
        </button>
        {STATUS_ORDER.map((id) => (
          <button
            key={id}
            type="button"
            onClick={() => setStatus(id)}
            className={cn(
              'rounded-md px-2 py-1 text-xs font-medium transition-colors',
              status === id ? 'bg-muted text-foreground' : 'text-muted-foreground hover:text-foreground',
            )}
          >
            {t(STATUS_KEY[id], id)} ({summary?.[id] ?? 0})
          </button>
        ))}
      </div>

      {error && <p className="text-xs text-red-600 dark:text-red-400">{error}</p>}

      <Card>
        <CardContent className="overflow-x-auto p-0">
          <table className="w-full text-xs">
            <thead>
              <tr className="border-b border-border/60 text-left text-muted-foreground">
                <th className="px-4 py-2 font-medium">{t('quota.agents.colAgent', 'Agent')}</th>
                <th className="px-3 py-2 font-medium">{t('quota.agents.colStatus', 'Status')}</th>
                <th className="px-3 py-2 font-medium">{t('quota.agents.colTask', 'Task')}</th>
                <th className="px-3 py-2 font-medium">{t('quota.agents.colModel', 'Account / model')}</th>
                <th className="px-3 py-2 text-right font-medium">{t('quota.metric.tokens', 'Tokens')}</th>
                <th className="px-3 py-2 text-right font-medium">{t('quota.metric.cost', 'Cost')}</th>
                <th className="px-4 py-2 text-right font-medium">{t('quota.agents.colTime', 'Time')}</th>
              </tr>
            </thead>
            <tbody>
              {entries.map((entry) => (
                <AgentRow
                  key={entry.agentId}
                  entry={entry}
                  expanded={expanded === entry.agentId}
                  onToggle={() => setExpanded((current) => (current === entry.agentId ? null : entry.agentId))}
                />
              ))}
              {entries.length === 0 && (
                <tr>
                  <td colSpan={7}>
                    <EmptyState size="sm" icon={Bot} title={t('quota.agents.empty', 'No agents match this filter.')} />
                  </td>
                </tr>
              )}
            </tbody>
          </table>
        </CardContent>
      </Card>
    </div>
  );
}

function AgentRow({
  entry,
  expanded,
  onToggle,
}: {
  entry: AgentFleetEntry;
  expanded: boolean;
  onToggle: () => void;
}) {
  const { t } = useTranslation('common');
  const tone = toneForAgentStatus(entry.status);

  return (
    <>
      <tr className="border-b border-border/40 last:border-0">
        <td className="px-4 py-2">
          <button type="button" className="flex items-center gap-1.5 text-left" onClick={onToggle}>
            <ChevronDown className={cn('h-3 w-3 transition-transform', expanded && 'rotate-180')} />
            <span className="truncate font-medium" title={entry.agentId}>
              {entry.agentId}
            </span>
          </button>
          <p className="truncate pl-4 text-[10px] text-muted-foreground">{entry.role}</p>
        </td>
        <td className="px-3 py-2">
          <span className="inline-flex items-center gap-1.5">
            <span className={cn('h-2 w-2 rounded-full', TONE_DOT[tone])} />
            <span className={TONE_TEXT[tone]}>{t(STATUS_KEY[entry.status], entry.status)}</span>
          </span>
        </td>
        <td className="max-w-56 truncate px-3 py-2" title={entry.taskTitle ?? undefined}>
          {entry.taskTitle ?? '—'}
        </td>
        <td className="px-3 py-2">
          <span className="truncate text-muted-foreground">{entry.provider ?? '—'}</span>
          {entry.model && <span className="block truncate text-[10px] text-muted-foreground/80">{entry.model}</span>}
        </td>
        <td className="px-3 py-2 text-right tabular-nums">{formatTokens(entry.tokensTotal)}</td>
        <td className="px-3 py-2 text-right tabular-nums">{formatCost(entry.costUsd)}</td>
        <td className="px-4 py-2 text-right tabular-nums">{formatDuration(entry.elapsedSeconds)}</td>
      </tr>
      {expanded && (
        <tr className="border-b border-border/40 bg-muted/20">
          <td colSpan={7} className="px-4 py-3">
            <dl className="grid grid-cols-1 gap-2 text-[11px] sm:grid-cols-3">
              <Detail label={t('quota.agents.detailSession', 'Session')} value={entry.sessionId ?? '—'} />
              <Detail label={t('quota.agents.detailStarted', 'Started')} value={entry.startedAt ? new Date(entry.startedAt).toLocaleString() : '—'} />
              <Detail
                label={t('quota.agents.detailRetries', 'Retries')}
                value={entry.retryCount === null ? t('quota.agents.notTracked', 'not tracked') : String(entry.retryCount)}
              />
              <Detail label={t('quota.agents.detailResult', 'Result')} value={entry.result ?? '—'} className="sm:col-span-3" />
            </dl>
          </td>
        </tr>
      )}
    </>
  );
}

function Detail({ label, value, className }: { label: string; value: string; className?: string }) {
  return (
    <div className={className}>
      <dt className="text-muted-foreground">{label}</dt>
      <dd className="truncate">{value}</dd>
    </div>
  );
}

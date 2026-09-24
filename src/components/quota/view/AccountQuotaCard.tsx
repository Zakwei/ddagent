import { useState } from 'react';
import { ChevronDown, History, RefreshCw, Users } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { Badge, Button, Card, CardContent, Collapsible, CollapsibleContent, CollapsibleTrigger, Tooltip } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import { formatDuration, formatRelativeTo } from '../format';
import { TONE_BAR, TONE_DOT, TONE_TEXT, toneForPercent, toneForQuality } from '../tone';
import { useQuotaHistory } from '../hooks/useQuotaSnapshot';
import type { QuotaAccount, QuotaConfig, QuotaDataQuality, QuotaWindow } from '../types';

import Sparkline from './Sparkline';

type AccountQuotaCardProps = {
  account: QuotaAccount;
  config: QuotaConfig | null;
  refreshing: boolean;
  onRefresh: (accountId: string) => void;
};

const QUALITY_KEY: Record<QuotaDataQuality, string> = {
  live: 'quota.quality.live',
  cached: 'quota.quality.cached',
  estimate: 'quota.quality.estimate',
  unknown: 'quota.quality.unknown',
  error: 'quota.quality.error',
};

const QUALITY_BADGE: Record<QuotaDataQuality, string> = {
  live: 'border-emerald-500/40 text-emerald-600 dark:text-emerald-400',
  cached: 'border-sky-500/40 text-sky-600 dark:text-sky-400',
  estimate: 'border-violet-500/40 text-violet-600 dark:text-violet-400',
  unknown: 'border-zinc-500/40 text-zinc-500',
  error: 'border-red-500/40 text-red-600 dark:text-red-400',
};

function WindowRow({
  window,
  watch,
  danger,
  alertsEnabled,
  accountErrored,
  now,
}: {
  window: QuotaWindow;
  watch: number;
  danger: number;
  alertsEnabled: boolean;
  accountErrored: boolean;
  now: number;
}) {
  const { t } = useTranslation('common');
  const tone = accountErrored ? 'neutral' : toneForPercent(window.percent, watch, danger);
  const reset = formatRelativeTo(window.resetsAt, now);
  const resetExact = window.resetsAt ? new Date(window.resetsAt).toLocaleString() : undefined;

  return (
    <div className="space-y-1">
      <div className="flex items-baseline justify-between gap-2 text-xs">
        <span className="text-muted-foreground">
          {window.label}
          <span className="ml-1.5 text-[10px] uppercase tracking-wide text-muted-foreground/70">
            {window.kind}
          </span>
        </span>
        <span className={cn('font-medium tabular-nums', TONE_TEXT[tone])}>{window.percent}%</span>
      </div>
      <div className="h-2 overflow-hidden rounded-full bg-muted">
        <div
          className={cn('h-full rounded-full transition-all', TONE_BAR[tone])}
          style={{ width: `${Math.min(100, Math.max(0, window.percent))}%` }}
        />
      </div>
      <div className="flex items-center justify-between gap-2 text-[11px] text-muted-foreground">
        <span className="tabular-nums">
          {t('quota.remaining', '{{value}}% left', { value: window.remainingPercent })}
        </span>
        {reset !== '—' && (
          <Tooltip content={resetExact} position="top">
            <span className="tabular-nums">{t('quota.resetsIn', 'reset in {{value}}', { value: reset })}</span>
          </Tooltip>
        )}
      </div>
      {alertsEnabled && window.etaSeconds !== null && !accountErrored && (
        <p className={cn('text-[11px] tabular-nums', TONE_TEXT[tone])}>
          {t('quota.projected', 'at the current pace this limit runs out in {{value}}', {
            value: formatDuration(window.etaSeconds),
          })}
        </p>
      )}
    </div>
  );
}

/**
 * Per-account quota card for the Control Center.
 *
 * Shows every limit window with its progress bar, remaining amount, reset
 * timer and pace projection, plus the agents routed to the account and a
 * collapsible sparkline of recorded history. Colour only ever encodes status.
 */
export default function AccountQuotaCard({ account, config, refreshing, onRefresh }: AccountQuotaCardProps) {
  const { t } = useTranslation('common');
  const [historyOpen, setHistoryOpen] = useState(false);
  const history = useQuotaHistory(historyOpen ? account.id : null);
  const now = Date.now();

  const watch = config?.watchThreshold ?? 75;
  const danger = config?.dangerThreshold ?? 90;
  const alertsEnabled = config?.alertsEnabled ?? true;
  const worst = account.windows.reduce((max, window) => Math.max(max, window.percent), 0);
  const tone = account.status === 'error' ? 'neutral' : toneForPercent(worst, watch, danger);
  const qualityTone = toneForQuality(account.quality);
  const age = account.lastSyncedAt
    ? formatDuration(Math.max(0, (now - Date.parse(account.lastSyncedAt)) / 1000))
    : null;
  const agentChip = account.provider.charAt(0).toUpperCase() + account.provider.slice(1);
  const inactive = account.status === 'inactive';

  return (
    <Card>
      <CardContent className="space-y-4 p-4">
        <div className="flex flex-row items-start justify-between gap-2">
          <div className="flex min-w-0 items-start gap-2">
            <span className={cn('mt-1.5 h-2 w-2 shrink-0 rounded-full', TONE_DOT[tone])} />
            <div className="min-w-0">
              <h3 className="truncate text-sm font-semibold">
                {account.providerLabel}
                {account.accountLabel && <span className="text-muted-foreground"> / {account.accountLabel}</span>}
              </h3>
              <p className="truncate text-xs text-muted-foreground">{account.plan}</p>
            </div>
          </div>
          <div className="flex shrink-0 items-center gap-1.5">
            <Badge
              variant="outline"
              className={cn('uppercase', inactive ? QUALITY_BADGE.unknown : QUALITY_BADGE[account.quality])}
            >
              {inactive ? t('quota.noSubscription', 'No subscription') : t(QUALITY_KEY[account.quality])}
            </Badge>
            <Button
              variant="ghost"
              size="icon"
              className="h-7 w-7"
              disabled={refreshing}
              onClick={() => onRefresh(account.id)}
              aria-label={t('quota.refreshAccount', 'Refresh account')}
            >
              <RefreshCw className={cn('h-3.5 w-3.5', refreshing && 'animate-spin')} />
            </Button>
          </div>
        </div>

        {account.status === 'error' ? (
          <p className="text-xs text-red-600 dark:text-red-400">
            {account.syncError ?? t('quota.syncFailed', 'Synchronization failed')}
          </p>
        ) : inactive ? (
          <p className="text-xs text-muted-foreground">
            {t('quota.noSubscriptionHint', 'The provider reports no active plan for this account.')}
          </p>
        ) : (
          <div className="space-y-3">
            {account.windows.map((window) => (
              <WindowRow
                key={window.label}
                window={window}
                watch={watch}
                danger={danger}
                alertsEnabled={alertsEnabled}
                accountErrored={account.status === 'error'}
                now={now}
              />
            ))}
          </div>
        )}

        <div className="flex flex-wrap items-center gap-2 text-[11px] text-muted-foreground">
          {account.assignedAgents.length > 0 ? (
            account.assignedAgents.map((agent) => (
              <span
                key={agent.agentId}
                className="inline-flex items-center gap-1 rounded-md border border-border/60 px-1.5 py-0.5"
              >
                <Users className="h-3 w-3" />
                <span className="tabular-nums">{agent.role}</span>
                <span className="tabular-nums text-foreground">{agent.activeTasks}</span>
              </span>
            ))
          ) : (
            <span className="inline-flex items-center gap-1 rounded-md border border-dashed border-border/60 px-1.5 py-0.5">
              <Users className="h-3 w-3" />
              {t('quota.noAgents', 'No agents assigned')}
            </span>
          )}
        </div>

        <Collapsible open={historyOpen} onOpenChange={setHistoryOpen}>
          <CollapsibleTrigger className="inline-flex h-7 items-center gap-1 rounded-md px-2 text-[11px] text-muted-foreground transition-colors hover:bg-muted hover:text-foreground">
            <History className="h-3.5 w-3.5" />
            {t('quota.history', 'History')}
            <ChevronDown className={cn('h-3 w-3 transition-transform', historyOpen && 'rotate-180')} />
          </CollapsibleTrigger>
          <CollapsibleContent className="pt-2">
            <Sparkline
              points={(history?.points ?? []).map((point) => point.percent)}
              tone={tone}
              className="h-6 w-full"
            />
            <p className="mt-1 text-[10px] tabular-nums text-muted-foreground">
              {history && history.points.length > 0
                ? t('quota.historyPoints', '{{value}} readings recorded', { value: history.points.length })
                : t('quota.historyEmpty', 'No history recorded yet')}
            </p>
          </CollapsibleContent>
        </Collapsible>

        <div className="flex items-center justify-between gap-2 text-[11px] text-muted-foreground">
          <span className={cn('uppercase', TONE_TEXT[qualityTone])}>{agentChip}</span>
          {age && <span className="tabular-nums">{t('quota.syncedAgo', 'synced {{value}} ago', { value: age })}</span>}
        </div>
      </CardContent>
    </Card>
  );
}


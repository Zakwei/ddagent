import { AlertTriangle, Check, Gauge, RefreshCw, Route, ScrollText, ShieldCheck } from 'lucide-react';
import { useEffect, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Badge, Button } from '../../../../../shared/view/ui';
import { cn } from '../../../../../lib/utils';
import { useQuotaConfig, useQuotaSnapshot } from '../../../../quota/hooks/useQuotaSnapshot';
import type { QuotaRoutingMode } from '../../../../quota/types';
import { formatRelativeTo } from '../../../../quota/format';
import SettingsCard from '../../SettingsCard';
import SettingsRow from '../../SettingsRow';
import SettingsSection from '../../SettingsSection';
import SettingsToggle from '../../SettingsToggle';

const ROUTING_MODES: QuotaRoutingMode[] = ['manual', 'ask', 'auto-low-risk'];

type ThresholdKey = 'watchThreshold' | 'dangerThreshold';

/**
 * Control Center preferences: alert thresholds, routing policy, polled accounts
 * and the data sources feeding the usage screens.
 *
 * Thresholds are global by default and can be overridden per account on the
 * backend, so this tab intentionally edits only the shared values.
 */
export default function QuotaSettingsTab() {
  const { t } = useTranslation('settings');
  const { snapshot, isRefreshing, refresh } = useQuotaSnapshot();
  const { config, isLoading, error, save } = useQuotaConfig();
  const [saved, setSaved] = useState(false);
  // Draft text for the threshold inputs: typing updates local state only, and
  // the PUT is committed on blur (or after a short debounce), not per keystroke.
  const [drafts, setDrafts] = useState<Partial<Record<ThresholdKey, string>>>({});
  // Saves run one at a time, in issue order, so a slow earlier PUT can never
  // land after a newer one and overwrite it with a stale config.
  const saveQueueRef = useRef<Promise<unknown>>(Promise.resolve());
  const savedTimerRef = useRef<number | null>(null);
  const debounceTimerRef = useRef<number | null>(null);
  const pendingPatchRef = useRef<Parameters<typeof save>[0]>({});

  const persist = (patch: Parameters<typeof save>[0]) => {
    const run = saveQueueRef.current.then(() => save(patch));
    saveQueueRef.current = run.then(
      () => undefined,
      () => undefined,
    );
    void run.then(
      () => {
        setSaved(true);
        if (savedTimerRef.current !== null) {
          window.clearTimeout(savedTimerRef.current);
        }
        savedTimerRef.current = window.setTimeout(() => {
          savedTimerRef.current = null;
          setSaved(false);
        }, 1500);
      },
      () => setSaved(false),
    );
    return run;
  };

  const flushPendingPatch = () => {
    if (debounceTimerRef.current !== null) {
      window.clearTimeout(debounceTimerRef.current);
      debounceTimerRef.current = null;
    }
    const patch = pendingPatchRef.current;
    pendingPatchRef.current = {};
    if (Object.keys(patch).length > 0) {
      persist(patch);
    }
  };

  const handleThresholdChange = (key: ThresholdKey) => (event: React.ChangeEvent<HTMLInputElement>) => {
    const raw = event.target.value;
    setDrafts((previous) => ({ ...previous, [key]: raw }));
    // An emptied input is not a real value; wait for blur instead of writing 0.
    if (raw === '') {
      return;
    }
    const value = Number(raw);
    if (Number.isNaN(value)) {
      return;
    }
    pendingPatchRef.current = { ...pendingPatchRef.current, [key]: value };
    if (debounceTimerRef.current !== null) {
      window.clearTimeout(debounceTimerRef.current);
    }
    debounceTimerRef.current = window.setTimeout(flushPendingPatch, 600);
  };

  const handleThresholdBlur = (key: ThresholdKey) => () => {
    const blurred = drafts[key];
    flushPendingPatch();
    // Drop the draft only once the queued saves have applied, so the input
    // doesn't flicker back to the stale config value while the PUT is running.
    void saveQueueRef.current.then(() => {
      setDrafts((previous) => (
        previous[key] === blurred ? { ...previous, [key]: undefined } : previous
      ));
    });
  };

  useEffect(() => () => {
    if (debounceTimerRef.current !== null) {
      window.clearTimeout(debounceTimerRef.current);
    }
    if (savedTimerRef.current !== null) {
      window.clearTimeout(savedTimerRef.current);
    }
  }, []);

  const accounts = snapshot?.accounts ?? [];

  return (
    <div className="space-y-6 md:space-y-8">
      <div className="flex items-start gap-3">
        <Gauge className="mt-0.5 h-5 w-5 text-blue-600" />
        <div className="min-w-0 flex-1">
          <h3 className="text-lg font-medium text-foreground">
            {t('quota.settings.title', { defaultValue: 'Control Center' })}
          </h3>
          <p className="text-sm text-muted-foreground">
            {t('quota.settings.description', {
              defaultValue: 'Alert thresholds, routing policy and the accounts polled for quota.',
            })}
          </p>
        </div>
        {saved && (
          <span className="flex items-center gap-1 text-xs text-emerald-600 dark:text-emerald-400">
            <Check className="h-3.5 w-3.5" />
            {t('quota.settings.saved', { defaultValue: 'Saved' })}
          </span>
        )}
      </div>

      {error && (
        <div className="flex items-center gap-2 rounded-lg border border-red-500/40 bg-red-500/5 p-3 text-sm text-red-600 dark:text-red-400">
          <AlertTriangle className="h-4 w-4 flex-shrink-0" />
          {error}
        </div>
      )}

      <SettingsSection
        title={t('quota.settings.alertsSection', { defaultValue: 'Alerts' })}
        description={t('quota.settings.alertsSectionHint', {
          defaultValue: 'Warn before a limit is actually exhausted, not only at 100%.',
        })}
      >
        <SettingsCard divided>
          <SettingsRow
            label={t('quota.settings.alertsEnabled', { defaultValue: 'Predicted limit alerts' })}
            description={t('quota.settings.alertsEnabledHint', {
              defaultValue: 'Surface pace-based projections on the overview and account cards.',
            })}
          >
            <SettingsToggle
              checked={config?.alertsEnabled ?? true}
              disabled={isLoading}
              ariaLabel={t('quota.settings.alertsEnabled', { defaultValue: 'Predicted limit alerts' })}
              onChange={(value: boolean) => void persist({ alertsEnabled: value })}
            />
          </SettingsRow>

          <SettingsRow
            label={t('quota.settings.watchThreshold', { defaultValue: 'Watch threshold (%)' })}
            description={t('quota.settings.watchThresholdHint', {
              defaultValue: 'Accounts at or above this reading are counted as at risk.',
            })}
          >
            <input
              type="number"
              min={0}
              max={100}
              value={drafts.watchThreshold ?? config?.watchThreshold ?? 75}
              disabled={isLoading}
              onChange={handleThresholdChange('watchThreshold')}
              onBlur={handleThresholdBlur('watchThreshold')}
              className="h-9 w-20 rounded-md border border-border bg-background px-2 text-right text-sm tabular-nums focus:outline-none focus:ring-2 focus:ring-ring"
            />
          </SettingsRow>

          <SettingsRow
            label={t('quota.settings.dangerThreshold', { defaultValue: 'Danger threshold (%)' })}
            description={t('quota.settings.dangerThresholdHint', {
              defaultValue: 'Readings at or above this value are shown in red.',
            })}
          >
            <input
              type="number"
              min={0}
              max={100}
              value={drafts.dangerThreshold ?? config?.dangerThreshold ?? 90}
              disabled={isLoading}
              onChange={handleThresholdChange('dangerThreshold')}
              onBlur={handleThresholdBlur('dangerThreshold')}
              className="h-9 w-20 rounded-md border border-border bg-background px-2 text-right text-sm tabular-nums focus:outline-none focus:ring-2 focus:ring-ring"
            />
          </SettingsRow>
        </SettingsCard>
      </SettingsSection>

      <SettingsSection
        title={t('quota.settings.routingSection', { defaultValue: 'Routing' })}
        description={t('quota.settings.routingSectionHint', {
          defaultValue: 'How the panel may move work to the account with the most headroom.',
        })}
      >
        <SettingsCard divided>
          {ROUTING_MODES.map((mode) => (
            <button
              key={mode}
              type="button"
              disabled={isLoading}
              onClick={() => void persist({ routingMode: mode })}
              className="flex w-full items-start gap-3 px-4 py-3 text-left transition-colors hover:bg-muted/40 disabled:opacity-50"
            >
              <span
                className={cn(
                  'mt-0.5 flex h-4 w-4 flex-shrink-0 items-center justify-center rounded-full border',
                  config?.routingMode === mode ? 'border-blue-600 bg-blue-600' : 'border-border',
                )}
              >
                {config?.routingMode === mode && <Check className="h-3 w-3 text-white" />}
              </span>
              <span className="min-w-0">
                <span className="block text-sm font-medium text-foreground">
                  {t(`quota.settings.routing.${mode}`, { defaultValue: mode })}
                </span>
                <span className="block text-sm text-muted-foreground">
                  {t(`quota.settings.routing.${mode}Hint`, { defaultValue: '' })}
                </span>
              </span>
            </button>
          ))}
        </SettingsCard>
        <p className="flex items-center gap-1.5 text-xs text-muted-foreground">
          <Route className="h-3.5 w-3.5" />
          {t('quota.settings.routingNote', {
            defaultValue: 'Switching an account changes cost and model quality, so it always requires a decision.',
          })}
        </p>
      </SettingsSection>

      <SettingsSection
        title={t('quota.settings.accountsSection', { defaultValue: 'Polled accounts' })}
        description={t('quota.settings.accountsSectionHint', {
          defaultValue: 'Credentials are read from each tool; the panel never sends them anywhere else.',
        })}
      >
        <SettingsCard divided>
          {accounts.length === 0 ? (
            <div className="px-4 py-6 text-sm text-muted-foreground">
              {t('quota.empty.description', { defaultValue: 'No accounts detected yet.' })}
            </div>
          ) : (
            accounts.map((account) => (
              <SettingsRow
                key={account.id}
                label={`${account.providerLabel} — ${account.plan || account.accountLabel || account.provider}`}
                description={
                  account.status === 'error'
                    ? (account.syncError ?? t('quota.syncFailed', { defaultValue: 'Sync failed' }))
                    : formatRelativeTo(account.lastSyncedAt)
                }
              >
                <Badge variant={account.status === 'error' ? 'destructive' : 'outline'}>
                  {t(`quota.quality.${account.quality}`, { defaultValue: account.quality })}
                </Badge>
              </SettingsRow>
            ))
          )}
        </SettingsCard>
        <Button
          type="button"
          variant="outline"
          size="sm"
          disabled={isRefreshing}
          onClick={() => void refresh()}
        >
          <RefreshCw className={cn('h-4 w-4', isRefreshing && 'animate-spin')} />
          {t('quota.syncNow', { defaultValue: 'Sync now' })}
        </Button>
      </SettingsSection>

      <SettingsSection
        title={t('quota.settings.sourcesSection', { defaultValue: 'Data sources' })}
        description={t('quota.settings.sourcesSectionHint', {
          defaultValue: 'Where usage and cost figures come from.',
        })}
      >
        <SettingsCard divided>
          <SettingsRow
            label={t('quota.settings.logSources', { defaultValue: 'Token and cost log store' })}
            description={t('quota.settings.logSourcesHint', {
              defaultValue: 'Read-only aggregate store shared with the tokboard collector.',
            })}
          >
            <span className="flex items-center gap-1.5 text-xs text-muted-foreground">
              <ScrollText className="h-3.5 w-3.5" />
              {t('quota.settings.readOnly', { defaultValue: 'Read-only' })}
            </span>
          </SettingsRow>
          <SettingsRow
            label={t('quota.settings.quotaConsent', { defaultValue: 'Quota polling' })}
            description={t('quota.settings.quotaConsentHint', {
              defaultValue: 'Reads provider quota endpoints with locally stored credentials.',
            })}
          >
            <span className="flex items-center gap-1.5 text-xs text-emerald-600 dark:text-emerald-400">
              <ShieldCheck className="h-3.5 w-3.5" />
              {t('quota.settings.localOnly', { defaultValue: 'Local only' })}
            </span>
          </SettingsRow>
        </SettingsCard>
      </SettingsSection>
    </div>
  );
}

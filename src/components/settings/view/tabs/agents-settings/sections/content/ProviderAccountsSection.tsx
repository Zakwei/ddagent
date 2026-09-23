import { Check, Loader2, Plus, Star, Trash2 } from 'lucide-react';
import { useState } from 'react';
import { useTranslation } from 'react-i18next';

import { useProviderAccounts, type ProviderAccount } from '../../../../../../../hooks/useProviderAccounts';
import { Badge, Button, Input } from '../../../../../../../shared/view/ui';
import { authenticatedFetch } from '../../../../../../../utils/api';
import type { AgentProvider } from '../../../../../types/types';

type ProviderAccountsSectionProps = {
  agent: AgentProvider;
};

/**
 * Named accounts for one provider: each row pins a set of env overrides
 * (typically an isolated config dir) that sessions launched with it run under.
 */
export default function ProviderAccountsSection({ agent }: ProviderAccountsSectionProps) {
  const { t } = useTranslation('settings');
  const { accounts, loading, refresh } = useProviderAccounts(agent);
  const [newLabel, setNewLabel] = useState('');
  const [busy, setBusy] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [usageById, setUsageById] = useState<Record<string, { totalTokens: number; costUsd: number | null }>>({});

  const addAccount = async () => {
    const label = newLabel.trim();
    if (!label) return;
    setBusy(true);
    setError(null);
    try {
      const response = await authenticatedFetch('/api/provider-accounts', {
        method: 'POST',
        body: JSON.stringify({ provider: agent, label }),
      });
      const body = await response.json().catch(() => ({}));
      if (!response.ok) throw new Error(body?.error?.message || body?.error || 'create failed');
      setNewLabel('');
      await refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'create failed');
    } finally {
      setBusy(false);
    }
  };

  const removeAccount = async (id: string) => {
    setBusy(true);
    setError(null);
    try {
      const response = await authenticatedFetch(`/api/provider-accounts/${encodeURIComponent(id)}`, {
        method: 'DELETE',
      });
      if (!response.ok) throw new Error('delete failed');
      await refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'delete failed');
    } finally {
      setBusy(false);
    }
  };

  const setDefault = async (id: string) => {
    setBusy(true);
    setError(null);
    try {
      const response = await authenticatedFetch(`/api/provider-accounts/${encodeURIComponent(id)}`, {
        method: 'PATCH',
        body: JSON.stringify({ isDefault: true }),
      });
      if (!response.ok) throw new Error('update failed');
      await refresh();
    } catch (err) {
      setError(err instanceof Error ? err.message : 'update failed');
    } finally {
      setBusy(false);
    }
  };

  const loadUsage = async (id: string) => {
    try {
      const response = await authenticatedFetch(`/api/provider-accounts/${encodeURIComponent(id)}/usage`);
      const body = await response.json().catch(() => ({}));
      const usage = body?.data?.usage;
      if (usage) {
        setUsageById((prev) => ({
          ...prev,
          [id]: { totalTokens: usage.totalTokens ?? 0, costUsd: usage.costUsd ?? null },
        }));
      }
    } catch {
      // Quota display is best-effort — the row just keeps the load button.
    }
  };

  return (
    <div className="rounded-lg border border-border/60 p-4">
      <div className="mb-3">
        <div className="font-medium text-foreground">
          {t('agents.accounts.title', { defaultValue: 'Named accounts' })}
        </div>
        <p className="text-sm text-muted-foreground">
          {t('agents.accounts.description', {
            defaultValue:
              'Additional credential sets. A session pinned to an account launches the CLI with its isolated config directory. Log in by running the provider CLI once with the shown env vars.',
          })}
        </p>
      </div>

      {error && <div className="mb-2 text-sm text-red-600 dark:text-red-400">{error}</div>}

      <div className="space-y-2">
        {loading && accounts.length === 0 && (
          <div className="flex items-center gap-2 text-sm text-muted-foreground">
            <Loader2 className="h-4 w-4 animate-spin" />
            {t('agents.accounts.loading', { defaultValue: 'Loading accounts…' })}
          </div>
        )}

        {accounts.map((account: ProviderAccount) => (
          <div
            key={account.id}
            className="flex items-center gap-2 rounded-lg border border-border/40 bg-muted/30 px-3 py-2"
          >
            <div className="min-w-0 flex-1">
              <div className="flex items-center gap-2">
                <span className="truncate text-sm font-medium text-foreground">{account.label}</span>
                {account.isDefault && (
                  <Badge variant="secondary" className="bg-emerald-100 text-emerald-800 dark:bg-emerald-900/30 dark:text-emerald-300">
                    {t('agents.accounts.default', { defaultValue: 'Default' })}
                  </Badge>
                )}
              </div>
              <div className="truncate font-mono text-xs text-muted-foreground">
                {Object.entries(account.envOverrides)
                  .map(([key, value]) => `${key}=${value}`)
                  .join(' ')}
              </div>
              {usageById[account.id] && (
                <div className="text-xs text-muted-foreground">
                  {t('agents.accounts.usage', {
                    defaultValue: '{{tokens}} tokens',
                    tokens: usageById[account.id].totalTokens.toLocaleString(),
                  })}
                  {usageById[account.id].costUsd != null &&
                    ` · $${usageById[account.id].costUsd!.toFixed(2)}`}
                </div>
              )}
            </div>

            <Button
              variant="ghost"
              size="sm"
              onClick={() => void loadUsage(account.id)}
              title={t('agents.accounts.showUsage', { defaultValue: 'Show token usage' })}
            >
              {t('agents.accounts.usageButton', { defaultValue: 'Usage' })}
            </Button>
            {!account.isDefault && (
              <Button
                variant="ghost"
                size="sm"
                onClick={() => void setDefault(account.id)}
                disabled={busy}
                aria-label={t('agents.accounts.makeDefault', { defaultValue: 'Make default' })}
                title={t('agents.accounts.makeDefault', { defaultValue: 'Make default' })}
              >
                <Star className="h-4 w-4" />
              </Button>
            )}
            {account.isDefault && <Check className="h-4 w-4 shrink-0 text-emerald-600" />}
            <Button
              variant="ghost"
              size="sm"
              onClick={() => void removeAccount(account.id)}
              disabled={busy}
              aria-label={t('agents.accounts.remove', { defaultValue: 'Remove account' })}
              title={t('agents.accounts.remove', { defaultValue: 'Remove account' })}
            >
              <Trash2 className="h-4 w-4 text-red-500" />
            </Button>
          </div>
        ))}
      </div>

      <div className="mt-3 flex items-center gap-2">
        <Input
          value={newLabel}
          onChange={(event) => setNewLabel(event.target.value)}
          onKeyDown={(event) => {
            if (event.key === 'Enter') void addAccount();
          }}
          placeholder={t('agents.accounts.newLabel', { defaultValue: 'Account label (e.g. Work)' })}
          className="h-9 flex-1"
        />
        <Button onClick={() => void addAccount()} disabled={busy || !newLabel.trim()} size="sm">
          {busy ? <Loader2 className="h-4 w-4 animate-spin" /> : <Plus className="mr-1 h-4 w-4" />}
          {t('agents.accounts.add', { defaultValue: 'Add account' })}
        </Button>
      </div>
    </div>
  );
}

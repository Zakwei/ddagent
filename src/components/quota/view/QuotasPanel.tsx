import { useCallback, useMemo, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Gauge } from 'lucide-react';

import { Pill, PillBar } from '../../../shared/view/ui';
import { cn } from '../../../lib/utils';
import type { QuotaAccount, QuotaConfig, QuotaSnapshot } from '../types';

import AccountQuotaCard from './AccountQuotaCard';

type QuotasPanelProps = {
  snapshot: QuotaSnapshot | null;
  config: QuotaConfig | null;
  isRefreshing: boolean;
  refresh: () => Promise<void>;
};

const ALL = '__all__';

/**
 * Full quota grid with a provider filter.
 *
 * The filter is derived from the accounts actually present, so a provider with
 * no credentials never shows an empty tab. Refresh is shared: one provider
 * sweep updates every account.
 */
export default function QuotasPanel({ snapshot, config, isRefreshing, refresh }: QuotasPanelProps) {
  const { t } = useTranslation('common');
  const [provider, setProvider] = useState<string>(ALL);
  const [refreshingAccount, setRefreshingAccount] = useState<string | null>(null);

  const providers = useMemo(() => {
    const ids = new Set<string>();
    for (const account of snapshot?.accounts ?? []) {
      ids.add(account.provider);
    }
    return Array.from(ids);
  }, [snapshot]);

  const accounts: QuotaAccount[] = useMemo(
    () =>
      (snapshot?.accounts ?? []).filter(
        (account) => provider === ALL || account.provider === provider,
      ),
    [snapshot, provider],
  );

  const handleRefreshAccount = useCallback(
    async (accountId: string) => {
      setRefreshingAccount(accountId);
      try {
        await refresh();
      } finally {
        setRefreshingAccount(null);
      }
    },
    [refresh],
  );

  if (!snapshot) {
    return null;
  }

  return (
    <div className="space-y-4">
      {providers.length > 1 && (
        <PillBar className="flex-wrap">
          <Pill isActive={provider === ALL} onClick={() => setProvider(ALL)}>
            {t('quota.filter.all', 'All')}
          </Pill>
          {providers.map((id) => (
            <Pill key={id} isActive={provider === id} onClick={() => setProvider(id)}>
              <span className="capitalize">{id}</span>
            </Pill>
          ))}
        </PillBar>
      )}

      {accounts.length === 0 ? (
        <div className="flex flex-col items-center justify-center gap-2 py-16 text-center">
          <Gauge className="h-8 w-8 text-muted-foreground" />
          <p className="text-sm font-medium">{t('quota.empty.title', 'No accounts connected')}</p>
          <p className="max-w-sm text-xs text-muted-foreground">
            {t(
              'quota.empty.description',
              'Sign in to Claude, Codex, Gemini or CommandCode so quota can be tracked here.',
            )}
          </p>
        </div>
      ) : (
        <div className={cn('grid grid-cols-1 gap-3 lg:grid-cols-2 2xl:grid-cols-3')}>
          {accounts.map((account) => (
            <AccountQuotaCard
              key={account.id}
              account={account}
              config={config}
              refreshing={refreshingAccount === account.id || isRefreshing}
              onRefresh={(accountId) => void handleRefreshAccount(accountId)}
            />
          ))}
        </div>
      )}
    </div>
  );
}

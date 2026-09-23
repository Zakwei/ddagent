import { useCallback, useEffect, useState } from 'react';

import { authenticatedFetch } from '../utils/api';

export type ProviderAccount = {
  id: string;
  provider: string;
  label: string;
  envOverrides: Record<string, string>;
  isDefault: boolean;
  createdAt: string;
};

/**
 * Loads the named accounts for one provider (or every provider when the arg is
 * omitted). Used by the composer account picker and the settings manager.
 */
export function useProviderAccounts(provider?: string) {
  const [accounts, setAccounts] = useState<ProviderAccount[]>([]);
  const [loading, setLoading] = useState(false);

  const refresh = useCallback(async () => {
    setLoading(true);
    try {
      const query = provider ? `?provider=${encodeURIComponent(provider)}` : '';
      const response = await authenticatedFetch(`/api/provider-accounts${query}`);
      const body = (await response.json().catch(() => ({}))) as {
        data?: { accounts?: ProviderAccount[] };
      };
      setAccounts(Array.isArray(body?.data?.accounts) ? body.data.accounts : []);
    } catch {
      setAccounts([]);
    } finally {
      setLoading(false);
    }
  }, [provider]);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  return { accounts, loading, refresh };
}

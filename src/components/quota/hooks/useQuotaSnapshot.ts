import { useCallback, useEffect, useState } from 'react';

import { api } from '../../../utils/api';
import type { QuotaApiResponse, QuotaConfig, QuotaHistory, QuotaSnapshot } from '../types';

type UseQuotaSnapshotResult = {
  snapshot: QuotaSnapshot | null;
  isLoading: boolean;
  isRefreshing: boolean;
  error: string | null;
  refresh: () => Promise<void>;
};

/** Poll interval; matches the backend's 5-minute cache window. */
const POLL_MS = 5 * 60 * 1000;

/** Unwraps the `{ success, data }` envelope shared by every quota endpoint. */
async function loadData<TData>(endpoint: Promise<Response>): Promise<TData> {
  const response = await endpoint;
  const payload = (await response.json()) as QuotaApiResponse<TData>;
  if (!response.ok || payload.success === false || payload.data === undefined) {
    throw new Error(payload.error ?? 'Request failed');
  }
  return payload.data;
}

/**
 * Loads the account quota snapshot and keeps it fresh with a slow poll.
 *
 * Provider quotas move on a scale of minutes, so 5 minutes matches the backend
 * cache window and avoids hammering provider APIs.
 */
export function useQuotaSnapshot(): UseQuotaSnapshotResult {
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
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    };
    void doPoll();
    const interval = window.setInterval(() => void doPoll(), POLL_MS);
    return () => {
      cancelled = true;
      window.clearInterval(interval);
    };
  }, []);

  return { snapshot, isLoading, isRefreshing, error, refresh };
}

/**
 * Loads the persisted alert/routing preferences.
 *
 * Separate from the snapshot hook because config changes on user action, not on
 * a poll, and only the settings surfaces need it.
 */
export function useQuotaConfig(): {
  config: QuotaConfig | null;
  isLoading: boolean;
  error: string | null;
  save: (patch: Partial<QuotaConfig>) => Promise<void>;
} {
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
    void load();
  }, [load]);

  const save = useCallback(async (patch: Partial<QuotaConfig>) => {
    setConfig(await loadData<QuotaConfig>(api.quota.saveConfig(patch)));
  }, []);

  return { config, isLoading, error, save };
}

/** Loads the recorded percent history of one account for the sparkline. */
export function useQuotaHistory(accountId: string | null, limit = 120): QuotaHistory | null {
  const [history, setHistory] = useState<QuotaHistory | null>(null);

  useEffect(() => {
    if (!accountId) {
      setHistory(null);
      return undefined;
    }

    let cancelled = false;
    void (async () => {
      try {
        const data = await loadData<QuotaHistory>(api.quota.history(accountId, limit));
        if (!cancelled) setHistory(data);
      } catch {
        if (!cancelled) setHistory(null);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [accountId, limit]);

  return history;
}

export { loadData };

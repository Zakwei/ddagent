import { useCallback, useEffect, useState } from 'react';

import { api } from '../../../utils/api';
import type { AgentFleetSnapshot, InsightPeriod, UsageGroupBy, UsageSummary } from '../types';

import { loadData } from './useQuotaSnapshot';

type UseUsageSummaryResult = {
  summary: UsageSummary | null;
  isLoading: boolean;
  error: string | null;
};

/**
 * Loads an aggregated usage summary for a period and grouping.
 *
 * Refetches whenever the filters change; the underlying store is read-only and
 * small, so no client-side caching layer is layered on top.
 */
export function useUsageSummary(period: InsightPeriod, groupBy: UsageGroupBy): UseUsageSummaryResult {
  const [summary, setSummary] = useState<UsageSummary | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;
    const load = async () => {
      setIsLoading(true);
      try {
        const data = await loadData<UsageSummary>(api.quota.usage(period, groupBy));
        if (!cancelled) {
          setSummary(data);
          setError(null);
        }
      } catch (loadError) {
        if (!cancelled) {
          setError(loadError instanceof Error ? loadError.message : 'Failed to load usage');
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    };
    void load();
    return () => { cancelled = true; };
  }, [period, groupBy]);

  return { summary, isLoading, error };
}

type UseAgentFleetResult = {
  fleet: AgentFleetSnapshot | null;
  isLoading: boolean;
  error: string | null;
  reload: () => Promise<void>;
};

/** Loads the agent fleet snapshot, with a manual reload for the refresh button. */
export function useAgentFleet(): UseAgentFleetResult {
  const [fleet, setFleet] = useState<AgentFleetSnapshot | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const load = useCallback(async () => {
    try {
      setFleet(await loadData<AgentFleetSnapshot>(api.quota.agents()));
      setError(null);
    } catch (loadError) {
      setError(loadError instanceof Error ? loadError.message : 'Failed to load agents');
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    void load();
    // Agents change faster than quotas: a 60-second poll keeps the table close
    // to live without opening a websocket channel for this read-only view.
    const interval = window.setInterval(() => void load(), 60_000);
    return () => window.clearInterval(interval);
  }, [load]);

  return { fleet, isLoading, error, reload: load };
}

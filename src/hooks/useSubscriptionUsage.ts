import { useCallback, useEffect, useMemo, useState } from 'react';

import type { LLMProvider } from '../types/app';
import { authenticatedFetch, getStoredAuthToken } from '../utils/api';
import {
  isModelAvailableIn,
  isProviderAvailableIn,
  usageFromQuotaSnapshot,
  type UsageResponse,
} from '../utils/subscriptionAvailability';

export type { SubscriptionInfo, UsageResponse, UsageWindow } from '../utils/subscriptionAvailability';
export { sectionForModel } from '../utils/subscriptionAvailability';

const USAGE_ENDPOINT = '/api/quota';
const POLL_MS = 5 * 60 * 1000;

// Logout is client-side (no reload), so this module-level snapshot must be
// keyed by the auth token it was fetched under — otherwise the next account
// to sign in would reuse the previous user's usage data for up to POLL_MS.
let cache: UsageResponse | null = null;
let cacheToken: string | null = null;
let lastLoadedAt = 0;
let inflight: Promise<UsageResponse | null> | null = null;
let inflightToken: string | null = null;

const readCachedUsage = (): UsageResponse | null =>
  cache !== null && cacheToken === getStoredAuthToken() ? cache : null;

const loadUsage = (): Promise<UsageResponse | null> => {
  const requestToken = getStoredAuthToken();
  if (inflight && inflightToken === requestToken) return inflight;

  inflightToken = requestToken;
  inflight = (async () => {
    try {
      const response = await authenticatedFetch(USAGE_ENDPOINT);
      // A different account may have signed in while this was in flight;
      // never let the previous user's snapshot land in the new session.
      if (response.ok && getStoredAuthToken() === requestToken) {
        const payload = (await response.json()) as { data?: Parameters<typeof usageFromQuotaSnapshot>[0] };
        if (payload.data) {
          cache = usageFromQuotaSnapshot(payload.data);
          cacheToken = requestToken;
          lastLoadedAt = Date.now();
        }
      }
    } catch {
      // Keep the last snapshot; callers then show everything.
    } finally {
      if (inflightToken === requestToken) {
        inflight = null;
        inflightToken = null;
      }
    }
    return getStoredAuthToken() === requestToken ? cache : null;
  })();
  return inflight;
};

/**
 * Subscription snapshot shared by every model picker, so they all agree on
 * which providers/models the account can actually run.
 *
 * ponytail: fail-open — an unknown snapshot (quota endpoint down, first paint)
 * filters nothing. Fail-closed would blank every picker until quota answers.
 */
export function useSubscriptionUsage() {
  const [usage, setUsage] = useState<UsageResponse | null>(() => readCachedUsage());

  useEffect(() => {
    let cancelled = false;
    const tick = () => {
      const cached = readCachedUsage();
      if (cached && Date.now() - lastLoadedAt < POLL_MS) {
        setUsage(cached);
        return;
      }
      void loadUsage().then((next) => {
        if (!cancelled) setUsage(next);
      });
    };
    tick();
    const id = setInterval(tick, POLL_MS);
    return () => {
      cancelled = true;
      clearInterval(id);
    };
  }, []);

  const isModelAvailable = useCallback(
    (provider: LLMProvider, model?: string | null) => isModelAvailableIn(usage, provider, model),
    [usage],
  );

  const isProviderAvailable = useCallback(
    (provider: LLMProvider) => isProviderAvailableIn(usage, provider),
    [usage],
  );

  return useMemo(
    () => ({ usage, isModelAvailable, isProviderAvailable }),
    [usage, isModelAvailable, isProviderAvailable],
  );
}

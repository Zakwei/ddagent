import { useCallback, useEffect, useMemo, useState } from 'react';

import { useProviderAccounts, type ProviderAccount } from '../../../../../hooks/useProviderAccounts';
import { authenticatedFetch } from '../../../../../utils/api';
import type { LLMProvider, ProviderModelOption } from '../../../../../types/app';

import { ORCHESTRATOR_PROVIDERS, type OrchestratorConfig } from './types';

type OrchestratorConfigResponse = {
  success?: boolean;
  data?: { config?: OrchestratorConfig };
  error?: string | { code?: string; message?: string };
};

type ProviderModelsResponse = {
  success?: boolean;
  data?: { models?: { OPTIONS?: ProviderModelOption[] } };
};

const readApiError = (payload: OrchestratorConfigResponse | null, fallback: string): string => {
  const error = payload?.error;
  if (typeof error === 'string' && error) return error;
  if (error && typeof error === 'object' && typeof error.message === 'string' && error.message) {
    return error.message;
  }
  return fallback;
};

export type OrchestratorConfigUpdate = (recipe: (draft: OrchestratorConfig) => OrchestratorConfig) => void;

/**
 * Loads the orchestrator config once, keeps a local draft plus the last saved
 * snapshot for dirty tracking, and persists via PUT /api/orchestrator/config.
 * Also preloads every provider's model catalog so each pool row can render a
 * provider-scoped model picker without its own request.
 */
export function useOrchestratorConfig() {
  const [config, setConfig] = useState<OrchestratorConfig | null>(null);
  const [savedConfig, setSavedConfig] = useState<OrchestratorConfig | null>(null);
  const [loading, setLoading] = useState(true);
  const [loadFailed, setLoadFailed] = useState(false);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const [modelCatalog, setModelCatalog] = useState<Partial<Record<LLMProvider, ProviderModelOption[]>>>({});
  const { accounts, loading: accountsLoading } = useProviderAccounts();

  const load = useCallback(async () => {
    setLoading(true);
    setLoadFailed(false);
    try {
      const response = await authenticatedFetch('/api/orchestrator/config');
      const body = (await response.json().catch(() => null)) as OrchestratorConfigResponse | null;
      if (!response.ok || !body?.data?.config) {
        throw new Error(readApiError(body, 'Failed to load orchestration settings'));
      }
      setConfig(body.data.config);
      setSavedConfig(body.data.config);
    } catch {
      setLoadFailed(true);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    void load();
  }, [load]);

  // Model catalogs are best-effort: a provider that fails to answer just gets
  // a free-text fallback in the row instead of blocking the whole tab.
  useEffect(() => {
    let cancelled = false;
    void (async () => {
      const entries = await Promise.all(
        ORCHESTRATOR_PROVIDERS.map(async ({ id }) => {
          try {
            const response = await authenticatedFetch(`/api/providers/${id}/models`);
            const body = (await response.json()) as ProviderModelsResponse;
            return [id, body?.data?.models?.OPTIONS ?? []] as const;
          } catch {
            return [id, []] as const;
          }
        }),
      );
      if (!cancelled) {
        setModelCatalog(Object.fromEntries(entries));
      }
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  const dirty = useMemo(
    () => Boolean(config && savedConfig && JSON.stringify(config) !== JSON.stringify(savedConfig)),
    [config, savedConfig],
  );

  const update = useCallback<OrchestratorConfigUpdate>((recipe) => {
    setConfig((current) => (current ? recipe(current) : current));
    setNotice(null);
  }, []);

  const save = useCallback(async () => {
    if (!config || saving) return;
    setSaving(true);
    setError(null);
    setNotice(null);
    try {
      const response = await authenticatedFetch('/api/orchestrator/config', {
        method: 'PUT',
        body: JSON.stringify({ config }),
      });
      const body = (await response.json().catch(() => null)) as OrchestratorConfigResponse | null;
      if (!response.ok || !body?.data?.config) {
        throw new Error(readApiError(body, 'Failed to save orchestration settings'));
      }
      setConfig(body.data.config);
      setSavedConfig(body.data.config);
      setNotice('saved');
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Failed to save orchestration settings');
    } finally {
      setSaving(false);
    }
  }, [config, saving]);

  const discard = useCallback(() => {
    setConfig(savedConfig);
    setError(null);
    setNotice(null);
  }, [savedConfig]);

  return useMemo(
    () => ({
      config,
      update,
      loading,
      loadFailed,
      reload: load,
      saving,
      dirty,
      error,
      notice,
      save,
      discard,
      modelCatalog,
      accounts: accounts as ProviderAccount[],
      accountsLoading,
    }),
    [
      config,
      update,
      loading,
      loadFailed,
      load,
      saving,
      dirty,
      error,
      notice,
      save,
      discard,
      modelCatalog,
      accounts,
      accountsLoading,
    ],
  );
}

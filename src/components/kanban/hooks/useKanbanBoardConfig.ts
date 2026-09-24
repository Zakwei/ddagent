import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import { authenticatedFetch, api } from '../../../utils/api';
import { useSubscriptionUsage } from '../../../hooks/useSubscriptionUsage';
import type { LLMProvider, ProviderModelOption } from '../../../types/app';
import type { KanbanApiResponse, KanbanBoardConfig } from '../types';
import { readApiError } from '../types';

const PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin'];

const EMPTY_CONFIG: KanbanBoardConfig = { provider: null, model: null, effort: null };

type ProviderModelsResponse = {
  success: boolean;
  data?: { models?: { OPTIONS: ProviderModelOption[]; DEFAULT: string } };
};

type UseKanbanBoardConfigResult = {
  config: KanbanBoardConfig;
  providers: LLMProvider[];
  modelOptions: ProviderModelOption[];
  effortOptions: { value: string; description?: string }[];
  isLoadingModels: boolean;
  save: (next: Partial<KanbanBoardConfig>) => Promise<void>;
};

/**
 * Per-project board agent settings: which provider/model/effort cards started
 * from this board run with. Kept beside `useKanbanBoard` because a board is the
 * only place that decides this — cards may still override the values.
 */
export function useKanbanBoardConfig(projectId: string | null): UseKanbanBoardConfigResult {
  const { subscribe } = useWebSocket();
  const { isModelAvailable, isProviderAvailable } = useSubscriptionUsage();
  const [config, setConfig] = useState<KanbanBoardConfig>(EMPTY_CONFIG);
  const [modelOptions, setModelOptions] = useState<ProviderModelOption[]>([]);
  const [isLoadingModels, setIsLoadingModels] = useState(false);
  const projectIdRef = useRef<string | null>(projectId);

  useEffect(() => {
    projectIdRef.current = projectId;
  }, [projectId]);

  const loadConfig = useCallback(async () => {
    if (!projectId) {
      setConfig(EMPTY_CONFIG);
      return;
    }

    // Stale-response guard: a slow fetch for the previous project must not
    // overwrite the config of the one the user just switched to.
    const requestedProject = projectId;
    try {
      const response = await api.kanban.getBoardConfig(projectId);
      const payload = (await response.json()) as KanbanApiResponse<{ boardConfig: KanbanBoardConfig }>;
      if (projectIdRef.current !== requestedProject) return;
      if (response.ok && payload.success !== false && payload.data?.boardConfig) {
        setConfig(payload.data.boardConfig);
      }
    } catch {
      // A board without saved settings simply keeps the defaults.
    }
  }, [projectId]);

  useEffect(() => {
    void loadConfig();
  }, [loadConfig]);

  // Switching projects resets to the defaults until the new board's config
  // arrives — the previous board's provider/model must not leak over.
  useEffect(() => {
    setConfig(EMPTY_CONFIG);
  }, [projectId]);

  useEffect(() => {
    return subscribe((event) => {
      if (event.type === 'kanban-board-config-updated' && event.projectId === projectIdRef.current) {
        const next = event.boardConfig as KanbanBoardConfig | undefined;
        if (next) setConfig(next);
      }
    });
  }, [subscribe]);

  const provider = config.provider;

  useEffect(() => {
    if (!provider) {
      setModelOptions([]);
      return;
    }

    let cancelled = false;
    setIsLoadingModels(true);

    void (async () => {
      try {
        const response = await authenticatedFetch(`/api/providers/${provider}/models`);
        const payload = (await response.json()) as ProviderModelsResponse;
        if (!cancelled) {
          setModelOptions(payload.data?.models?.OPTIONS ?? []);
        }
      } catch {
        if (!cancelled) setModelOptions([]);
      } finally {
        if (!cancelled) setIsLoadingModels(false);
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [provider]);

  const providers = useMemo(
    () => PROVIDERS.filter((candidate) => isProviderAvailable(candidate)),
    [isProviderAvailable],
  );

  const effortOptions = useMemo(() => {
    const option = modelOptions.find((candidate) => candidate.value === config.model);
    return option?.effort?.values ?? [];
  }, [modelOptions, config.model]);

  const availableModelOptions = useMemo(
    () => modelOptions.filter((option) => isModelAvailable(provider ?? 'claude', option.value, option.tier)),
    [modelOptions, provider, isModelAvailable],
  );

  const save = useCallback(
    async (next: Partial<KanbanBoardConfig>) => {
      if (!projectId) return;

      const merged: KanbanBoardConfig = {
        provider: next.provider !== undefined ? next.provider : config.provider,
        model: next.model !== undefined ? next.model : config.model,
        effort: next.effort !== undefined ? next.effort : config.effort,
      };

      // Optimistic: the pickers should feel instant; the server broadcast
      // confirms the value back.
      setConfig(merged);
      try {
        // fetch only rejects on network failure — a 4xx/5xx answer still has
        // to be detected or the optimistic value sticks after a rejection.
        const response = await api.kanban.saveBoardConfig(projectId, merged);
        const payload = (await response.json().catch(() => null)) as KanbanApiResponse<{
          boardConfig: KanbanBoardConfig;
        }> | null;
        if (!response.ok || payload?.success === false) {
          throw new Error(readApiError(payload ?? { success: false }, 'Failed to save board settings'));
        }
      } catch {
        void loadConfig();
      }
    },
    [projectId, config, loadConfig],
  );

  return useMemo(
    () => ({
      config,
      providers,
      modelOptions: availableModelOptions,
      effortOptions,
      isLoadingModels,
      save,
    }),
    [config, providers, availableModelOptions, effortOptions, isLoadingModels, save],
  );
}

import { useCallback, useEffect, useMemo, useState } from 'react';

import { authenticatedFetch } from '../../../utils/api';
import { PROVIDER_MODELS_CHANGED_EVENT } from '../../../utils/providerSettings';
import type {
  CustomProviderModelInput,
  LLMProvider,
  ProviderModelActions,
  ProviderModelOption,
  ProviderModelsDefinition,
} from '../../../types/app';

const MODEL_LIBRARY_PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'commandcode', 'devin'];

type ProviderModelsApiResponse = {
  success?: boolean;
  data?: {
    models?: ProviderModelsDefinition;
  };
};

type ProviderModelMutationApiResponse = {
  success?: boolean;
  data?: {
    model?: ProviderModelOption;
    models?: ProviderModelsDefinition;
  };
  error?: {
    message?: string;
  };
};

const readModelMutationResponse = async (
  response: Response,
): Promise<Required<Pick<NonNullable<ProviderModelMutationApiResponse['data']>, 'model' | 'models'>>> => {
  const body = (await response.json()) as ProviderModelMutationApiResponse;
  if (!response.ok || !body.success || !body.data?.model || !body.data.models) {
    throw new Error(body.error?.message || 'Unable to save this model.');
  }

  return {
    model: body.data.model,
    models: body.data.models,
  };
};

/**
 * Keeps the shared per-provider default pick pointing at a live model after a
 * rename or delete. Pane-scoped copies (`<key>:pane:<id>`) stay as-is: panes
 * reconcile them the next time they load the catalog.
 */
const rebindStoredDefaultModel = (provider: LLMProvider, previousValue: string, nextValue: string) => {
  const storageKey = `${provider}-model`;
  try {
    if (localStorage.getItem(storageKey) === previousValue) {
      localStorage.setItem(storageKey, nextValue);
    }
  } catch {
    // Storage can be unavailable (private mode); the next catalog load still
    // reconciles the pick, so a skipped write is harmless.
  }
};

const notifyModelCatalogChanged = () => {
  window.dispatchEvent(new Event(PROVIDER_MODELS_CHANGED_EVENT));
};

/**
 * Settings-owned copy of the provider model catalog plus the custom-model
 * mutations. Chat panes keep their own catalog and refresh it via
 * `PROVIDER_MODELS_CHANGED_EVENT`, so this hook never has to reach into chat
 * state.
 */
export function useProviderModelLibrary() {
  const [providerModelCatalog, setProviderModelCatalog] = useState<
    Partial<Record<LLMProvider, ProviderModelsDefinition>>
  >({});
  const [providerModelsLoading, setProviderModelsLoading] = useState(true);

  useEffect(() => {
    let cancelled = false;

    const load = async () => {
      try {
        const results = await Promise.all(
          MODEL_LIBRARY_PROVIDERS.map(async (provider) => {
            const response = await authenticatedFetch(`/api/providers/${provider}/models`);
            const body = (await response.json()) as ProviderModelsApiResponse;
            if (!body.success || !body.data?.models) {
              return null;
            }
            return body.data.models;
          }),
        );

        if (cancelled) {
          return;
        }

        const nextCatalog: Partial<Record<LLMProvider, ProviderModelsDefinition>> = {};
        MODEL_LIBRARY_PROVIDERS.forEach((provider, index) => {
          const entry = results[index];
          if (entry) {
            nextCatalog[provider] = entry;
          }
        });
        setProviderModelCatalog(nextCatalog);
      } catch (error) {
        console.error('Error loading provider models:', error);
      } finally {
        if (!cancelled) {
          setProviderModelsLoading(false);
        }
      }
    };

    void load();
    return () => {
      cancelled = true;
    };
  }, []);

  const applyProviderCatalog = useCallback((provider: LLMProvider, models: ProviderModelsDefinition) => {
    setProviderModelCatalog((previous) => ({
      ...previous,
      [provider]: models,
    }));
  }, []);

  const create = useCallback(async (provider: LLMProvider, input: CustomProviderModelInput) => {
    const response = await authenticatedFetch(`/api/providers/${provider}/models`, {
      method: 'POST',
      body: JSON.stringify(input),
    });
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(provider, result.models);
    notifyModelCatalogChanged();
  }, [applyProviderCatalog]);

  const update = useCallback(async (
    provider: LLMProvider,
    existing: ProviderModelOption,
    input: CustomProviderModelInput,
  ) => {
    if (!existing.recordId) {
      throw new Error('This model cannot be edited.');
    }

    const response = await authenticatedFetch(`/api/providers/${provider}/models/${existing.recordId}`, {
      method: 'PATCH',
      body: JSON.stringify(input),
    });
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(provider, result.models);
    rebindStoredDefaultModel(provider, existing.value, result.model.value);
    notifyModelCatalogChanged();
  }, [applyProviderCatalog]);

  const remove = useCallback(async (provider: LLMProvider, existing: ProviderModelOption) => {
    if (!existing.recordId) {
      throw new Error('This model cannot be deleted.');
    }

    const response = await authenticatedFetch(`/api/providers/${provider}/models/${existing.recordId}`, {
      method: 'DELETE',
    });
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(provider, result.models);
    rebindStoredDefaultModel(provider, existing.value, result.models.DEFAULT);
    notifyModelCatalogChanged();
  }, [applyProviderCatalog]);

  const providerModelActions = useMemo<ProviderModelActions>(() => ({
    create,
    update,
    remove,
  }), [create, update, remove]);

  return {
    providerModelCatalog,
    providerModelActions,
    providerModelsLoading,
  };
}

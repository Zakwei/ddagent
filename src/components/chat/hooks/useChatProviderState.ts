import { useCallback, useEffect, useMemo, useRef, useState } from 'react';

import { authenticatedFetch } from '../../../utils/api';
import { useSubscriptionUsage } from '../../../hooks/useSubscriptionUsage';
import { useWorkspace } from '../../../contexts/WorkspaceContext';
import type { PendingPermissionRequest, PermissionMode } from '../types/types';
import type {
  ProjectSession,
  LLMProvider,
  Project,
  CustomProviderModelInput,
  ProviderModelActions,
  ProviderModelOption,
  ProviderModelsDefinition,
} from '../../../types/app';
import {
  DEFAULT_EFFORT_VALUE,
  FALLBACK_PROVIDER_EFFORT_VALUES,
  toProviderEffortOptions,
} from '../constants/providerEffort';
import { FALLBACK_PERMISSION_MODES } from '../constants/permissionModes';
import { readProviderSetting, writeProviderSetting } from '../utils/providerPaneStorage';
import {
  PROVIDER_SETTINGS_CHANGED_EVENT,
  readStoredPermissionMode,
} from '../../../utils/providerSettings';

const FALLBACK_DEFAULT_MODEL: Record<LLMProvider, string> = {
  claude: 'default',
  cursor: 'gpt-5.3-codex',
  codex: 'gpt-5.4',
  opencode: 'anthropic/claude-sonnet-4-5',
  devin: 'swe-1-7',
  // Auto has no fixed model — the router picks per delegated step.
  orchestrator: 'auto',
};

const PROVIDERS: LLMProvider[] = ['claude', 'cursor', 'codex', 'opencode', 'devin', 'orchestrator'];

/**
 * Providers with a fetchable `/api/providers/:provider/models` catalog. Auto
 * is deliberately excluded: the orchestrator router owns model choice, so a
 * catalog request would only produce a 404.
 */
const MODEL_CATALOG_PROVIDERS: LLMProvider[] = PROVIDERS.filter(
  (p) => p !== 'orchestrator',
);

const readStoredProvider = (): LLMProvider => {
  const storedProvider = localStorage.getItem('selected-provider');
  return PROVIDERS.includes(storedProvider as LLMProvider)
    ? storedProvider as LLMProvider
    : 'claude';
};

type ProviderCapabilities = {
  provider: LLMProvider;
  permissionModes: string[];
  defaultPermissionMode: string;
  supportsImages: boolean;
  supportsFiles: boolean;
  supportsAbort: boolean;
  supportsPermissionRequests: boolean;
  supportsTokenUsage: boolean;
  supportsEffort?: boolean;
};

type ProviderCapabilitiesApiResponse = {
  success?: boolean;
  data?: {
    providers?: ProviderCapabilities[];
  };
};

interface UseChatProviderStateArgs {
  selectedSession: ProjectSession | null;
  selectedProject: Project | null;
  /**
   * Pane-bound session id from the workspace context. Present whenever this
   * chat instance is bound to a concrete session; absent (with no selected
   * session) marks a draft pane whose model/effort picks must stay local.
   */
  boundSessionId?: string | null;
  /**
   * Stable id of the hosting workspace pane. Scopes the "last picked"
   * permission-mode key so a mode chosen in one tile cannot leak into
   * another tile's draft.
   */
  boundPaneId?: string | null;
}

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

type SessionSelectionApiResponse = {
  success?: boolean;
  data?: {
    provider?: LLMProvider;
    sessionId?: string | null;
    model?: string | null;
    effort?: string | null;
    /**
     * `session` and `provider` are real answers for this session; `default`
     * means the backend had nothing recorded and returned the catalog default,
     * which the composer replaces with the user's per-provider selection.
     */
    source?: 'session' | 'provider' | 'default';
  };
};

type SessionProviderSelection = {
  provider: LLMProvider;
  sessionId: string;
  model: string | null;
  effort: string | null;
};

const getSessionSelectionKey = (provider: LLMProvider, sessionId: string): string => (
  `${provider}:${sessionId}`
);

export function useChatProviderState({ selectedSession, selectedProject: _selectedProject, boundSessionId, boundPaneId }: UseChatProviderStateArgs) {
  const { isModelAvailable } = useSubscriptionUsage();
  const { panes } = useWorkspace();
  /**
   * A draft pane (no bound/selected session) that shares the workspace with
   * other chat panes must not leak its model or effort picks into the shared
   * `${provider}-model` / `${provider}-effort` localStorage defaults — another
   * pane's draft would silently inherit them. A lone draft keeps the legacy
   * behavior so its pick still becomes the next new chat's default.
   */
  const hasSessionScope = Boolean(boundSessionId || selectedSession?.id);
  const chatPaneCount = panes.reduce((count, pane) => count + (pane.kind === 'chat' ? 1 : 0), 0);
  const isolateDraftDefaults = !hasSessionScope && chatPaneCount > 1;
  /**
   * Reads one stored provider setting for this pane: its own pick first (that
   * copy survives remounts and reloads), then the shared per-provider default.
   */
  const readStoredSetting = (baseKey: string): string | null => (
    readProviderSetting(localStorage, baseKey, { paneId: boundPaneId })
  );
  const [permissionMode, setPermissionMode] = useState<PermissionMode>('default');
  const [pendingPermissionRequests, setPendingPermissionRequests] = useState<PendingPermissionRequest[]>([]);
  const [provider, setProvider] = useState<LLMProvider>(readStoredProvider);
  /**
   * Scope for the "last picked" permission-mode key. The pane id keeps each
   * tile's choice private; hosts without pane identity fall back to the
   * legacy per-provider scope.
   */
  const permissionModeScope = boundPaneId ?? provider;
  const [cursorModel, setCursorModel] = useState<string>(() => {
    return readStoredSetting('cursor-model') || FALLBACK_DEFAULT_MODEL.cursor;
  });
  const [claudeModel, setClaudeModel] = useState<string>(() => {
    return readStoredSetting('claude-model') || FALLBACK_DEFAULT_MODEL.claude;
  });
  const [codexModel, setCodexModel] = useState<string>(() => {
    return readStoredSetting('codex-model') || FALLBACK_DEFAULT_MODEL.codex;
  });
  const [providerEfforts, setProviderEfforts] = useState<Partial<Record<LLMProvider, string>>>(() => {
    return PROVIDERS.reduce<Partial<Record<LLMProvider, string>>>((acc, targetProvider) => {
      acc[targetProvider] = readStoredSetting(`${targetProvider}-effort`) || DEFAULT_EFFORT_VALUE;
      return acc;
    }, {});
  });
  const [opencodeModel, setOpenCodeModel] = useState<string>(() => {
    return readStoredSetting('opencode-model') || FALLBACK_DEFAULT_MODEL.opencode;
  });
  const [devinModel, setDevinModel] = useState<string>(() => {
    return readStoredSetting('devin-model') || FALLBACK_DEFAULT_MODEL.devin;
  });

  /**
   * Backend-owned capability matrix keyed by provider. Drives the permission
   * mode picker (and is the extension point for future per-provider UI
   * differences) so the frontend stays free of hardcoded provider branching.
   * Null until `/api/providers/capabilities` resolves; the static fallback
   * map covers that window.
   */
  const [providerCapabilities, setProviderCapabilities] = useState<
    Partial<Record<LLMProvider, ProviderCapabilities>> | null
  >(null);

  const [providerModelCatalog, setProviderModelCatalog] = useState<
    Partial<Record<LLMProvider, ProviderModelsDefinition>>
  >({});
  const [providerModelsLoading, setProviderModelsLoading] = useState(true);

  const providerModelsRequestIdRef = useRef(0);
  const sessionSelectionLoadRequestIdRef = useRef(0);
  const sessionModelMutationIdRef = useRef(0);
  const sessionEffortMutationIdRef = useRef(0);

  const setStoredProviderModel = useCallback((targetProvider: LLMProvider, model: string, persist = true) => {
    // The pane-scoped copy keeps this pane's pick across remounts and reloads;
    // the shared key stays the per-provider default new chats inherit.
    writeProviderSetting(localStorage, `${targetProvider}-model`, model, {
      paneId: boundPaneId,
      persistShared: persist,
    });

    if (targetProvider === 'claude') {
      setClaudeModel(model);
      return;
    }

    if (targetProvider === 'cursor') {
      setCursorModel(model);
      return;
    }

    if (targetProvider === 'codex') {
      setCodexModel(model);
      return;
    }

    if (targetProvider === 'opencode') {
      setOpenCodeModel(model);
      return;
    }

    if (targetProvider === 'devin') {
      setDevinModel(model);
      return;
    }

    // Auto has no model state — the stored value is written above so a later
    // session bind can still read it; nothing else needs updating.
  }, [boundPaneId]);

  const setStoredProviderEffort = useCallback((targetProvider: LLMProvider, effort: string, persist = true) => {
    setProviderEfforts((previous) => (
      previous[targetProvider] === effort
        ? previous
        : { ...previous, [targetProvider]: effort }
    ));
    writeProviderSetting(localStorage, `${targetProvider}-effort`, effort, {
      paneId: boundPaneId,
      persistShared: persist,
    });
  }, [boundPaneId]);

  const loadProviderModels = useCallback(async (options?: { refresh?: boolean }) => {
    const requestId = providerModelsRequestIdRef.current + 1;
    providerModelsRequestIdRef.current = requestId;
    setProviderModelsLoading(true);

    try {
      const query = options?.refresh ? '?refresh=true' : '';
      const results = await Promise.all(
        MODEL_CATALOG_PROVIDERS.map(async (p) => {
          const response = await authenticatedFetch(`/api/providers/${p}/models${query}`);
          const body = (await response.json()) as ProviderModelsApiResponse;
          if (!body.success || !body.data?.models) {
            return null;
          }

          return body.data.models;
        }),
      );

      if (providerModelsRequestIdRef.current !== requestId) {
        return;
      }

      const nextCatalog: Partial<Record<LLMProvider, ProviderModelsDefinition>> = {};

      MODEL_CATALOG_PROVIDERS.forEach((p, i) => {
        const entry = results[i];
        if (!entry) {
          return;
        }

        nextCatalog[p] = entry;
      });

      setProviderModelCatalog(nextCatalog);
    } catch (error) {
      console.error('Error loading provider models:', error);
    } finally {
      if (providerModelsRequestIdRef.current === requestId) {
        setProviderModelsLoading(false);
      }
    }
  }, []);

  useEffect(() => {
    void loadProviderModels();
  }, [loadProviderModels]);

  useEffect(() => {
    let cancelled = false;

    const loadCapabilities = async () => {
      try {
        const response = await authenticatedFetch('/api/providers/capabilities');
        const body = (await response.json()) as ProviderCapabilitiesApiResponse;
        if (cancelled || !body.success || !Array.isArray(body.data?.providers)) {
          return;
        }

        const byProvider: Partial<Record<LLMProvider, ProviderCapabilities>> = {};
        for (const capabilities of body.data.providers) {
          byProvider[capabilities.provider] = capabilities;
        }
        setProviderCapabilities(byProvider);
      } catch (error) {
        console.error('Error loading provider capabilities:', error);
      }
    };

    void loadCapabilities();
    return () => {
      cancelled = true;
    };
  }, []);

  const getPermissionModesForProvider = useCallback((targetProvider: LLMProvider): PermissionMode[] => {
    const capabilityModes = providerCapabilities?.[targetProvider]?.permissionModes;
    if (capabilityModes && capabilityModes.length > 0) {
      return capabilityModes as PermissionMode[];
    }
    return FALLBACK_PERMISSION_MODES[targetProvider] ?? ['default'];
  }, [providerCapabilities]);

  const getDefaultPermissionModeForProvider = useCallback((targetProvider: LLMProvider): PermissionMode => {
    const modes = getPermissionModesForProvider(targetProvider);
    const capabilityDefault = providerCapabilities?.[targetProvider]?.defaultPermissionMode as PermissionMode | undefined;
    if (capabilityDefault && modes.includes(capabilityDefault)) {
      return capabilityDefault;
    }
    return modes[0] ?? 'default';
  }, [getPermissionModesForProvider, providerCapabilities]);

  const getSupportsEffortForProvider = useCallback((targetProvider: LLMProvider): boolean => {
    const capabilitySupport = providerCapabilities?.[targetProvider]?.supportsEffort;
    if (typeof capabilitySupport === 'boolean') {
      return capabilitySupport;
    }
    return Boolean(FALLBACK_PROVIDER_EFFORT_VALUES[targetProvider]?.length);
  }, [providerCapabilities]);

  const pickStoredOrCurrent = (
    storageKey: string,
    current: string,
    def: ProviderModelsDefinition,
  ): string => {
    // The pane's own pick always wins — it is what survived the last remount.
    // An isolated draft pane must not inherit the shared key: another pane's
    // choice would clobber its draft.
    const stored = readProviderSetting(localStorage, storageKey, {
      paneId: boundPaneId,
      allowShared: !isolateDraftDefaults,
    });
    if (stored) {
      return stored;
    }
    // A stored/current pick missing from the freshly loaded catalog (rotated
    // free tier, fallback list after a failed fetch) is still a valid model
    // id to send — only an empty state falls back to the catalog default.
    return current || def.DEFAULT;
  };

  const getModelOption = useCallback((
    targetProvider: LLMProvider,
    model: string,
  ): ProviderModelOption | null => {
    const definition = providerModelCatalog[targetProvider];
    if (!definition) {
      return null;
    }

    return definition.OPTIONS.find((option) => option.value === model) ?? null;
  }, [providerModelCatalog]);

  const getEffortOptionsForModel = useCallback((
    targetProvider: LLMProvider,
    model: string,
  ): NonNullable<ProviderModelOption['effort']>['values'] => {
    if (!getSupportsEffortForProvider(targetProvider)) {
      return [];
    }

    const option = getModelOption(targetProvider, model);
    if (option) {
      return option.effort?.values ?? [];
    }

    return toProviderEffortOptions(FALLBACK_PROVIDER_EFFORT_VALUES[targetProvider] ?? []);
  }, [getModelOption, getSupportsEffortForProvider]);

  const getAllowedEffortValues = useCallback((
    targetProvider: LLMProvider,
    model: string,
  ): string[] => (
    getEffortOptionsForModel(targetProvider, model).map((value) => value.value)
  ), [getEffortOptionsForModel]);

  const reconcileStoredEffort = useCallback((
    targetProvider: LLMProvider,
    model: string,
    currentEffort: string,
  ): string => {
    const allowedValues = getAllowedEffortValues(targetProvider, model);
    if (allowedValues.length === 0) {
      return DEFAULT_EFFORT_VALUE;
    }

    if (currentEffort === DEFAULT_EFFORT_VALUE || !currentEffort) {
      return DEFAULT_EFFORT_VALUE;
    }

    if (allowedValues.includes(currentEffort)) {
      return currentEffort;
    }

    return DEFAULT_EFFORT_VALUE;
  }, [getAllowedEffortValues]);

  const providerModels = useMemo<Record<LLMProvider, string>>(() => ({
    claude: claudeModel,
    cursor: cursorModel,
    codex: codexModel,
    opencode: opencodeModel,
    devin: devinModel,
    orchestrator: FALLBACK_DEFAULT_MODEL.orchestrator,
  }), [claudeModel, cursorModel, codexModel, opencodeModel, devinModel]);

  useEffect(() => {
    const claude = providerModelCatalog.claude;
    if (claude) {
      const next = pickStoredOrCurrent('claude-model', claudeModel, claude);
      if (next !== claudeModel) {
        setClaudeModel(next);
      }
      if (!isolateDraftDefaults && localStorage.getItem('claude-model') !== next) {
        localStorage.setItem('claude-model', next);
      }
    }
  }, [providerModelCatalog.claude, claudeModel, isolateDraftDefaults]);

  useEffect(() => {
    const cursor = providerModelCatalog.cursor;
    if (cursor) {
      const next = pickStoredOrCurrent('cursor-model', cursorModel, cursor);
      if (next !== cursorModel) {
        setCursorModel(next);
      }
      if (!isolateDraftDefaults && localStorage.getItem('cursor-model') !== next) {
        localStorage.setItem('cursor-model', next);
      }
    }
  }, [providerModelCatalog.cursor, cursorModel, isolateDraftDefaults]);

  useEffect(() => {
    const codex = providerModelCatalog.codex;
    if (codex) {
      const next = pickStoredOrCurrent('codex-model', codexModel, codex);
      if (next !== codexModel) {
        setCodexModel(next);
      }
      if (!isolateDraftDefaults && localStorage.getItem('codex-model') !== next) {
        localStorage.setItem('codex-model', next);
      }
    }
  }, [providerModelCatalog.codex, codexModel, isolateDraftDefaults]);

  useEffect(() => {
    const opencode = providerModelCatalog.opencode;
    if (opencode) {
      const next = pickStoredOrCurrent('opencode-model', opencodeModel, opencode);
      if (next !== opencodeModel) {
        setOpenCodeModel(next);
      }
      if (!isolateDraftDefaults && localStorage.getItem('opencode-model') !== next) {
        localStorage.setItem('opencode-model', next);
      }
    }
  }, [providerModelCatalog.opencode, opencodeModel, isolateDraftDefaults]);

  useEffect(() => {
    const devin = providerModelCatalog.devin;
    if (devin) {
      const next = pickStoredOrCurrent('devin-model', devinModel, devin);
      if (next !== devinModel) {
        setDevinModel(next);
      }
      if (!isolateDraftDefaults && localStorage.getItem('devin-model') !== next) {
        localStorage.setItem('devin-model', next);
      }
    }
  }, [providerModelCatalog.devin, devinModel, isolateDraftDefaults]);

  useEffect(() => {
    const nextEfforts: Partial<Record<LLMProvider, string>> = {};
    let hasUpdates = false;

    for (const targetProvider of PROVIDERS) {
      const currentEffort = providerEfforts[targetProvider] ?? DEFAULT_EFFORT_VALUE;
      const nextEffort = reconcileStoredEffort(targetProvider, providerModels[targetProvider], currentEffort);
      if (nextEffort === currentEffort) {
        continue;
      }

      nextEfforts[targetProvider] = nextEffort;
      if (!isolateDraftDefaults) {
        localStorage.setItem(`${targetProvider}-effort`, nextEffort);
      }
      hasUpdates = true;
    }

    if (hasUpdates) {
      setProviderEfforts((previous) => ({ ...previous, ...nextEfforts }));
    }
  }, [providerEfforts, providerModels, reconcileStoredEffort, isolateDraftDefaults]);

  // Settings → Agents persists each provider's default permission mode; bump
  // the revision so open draft panes re-resolve it without a reload.
  const [providerSettingsRevision, setProviderSettingsRevision] = useState(0);
  useEffect(() => {
    const handleProviderSettingsChange = () => setProviderSettingsRevision((current) => current + 1);
    window.addEventListener(PROVIDER_SETTINGS_CHANGED_EVENT, handleProviderSettingsChange);
    return () => window.removeEventListener(PROVIDER_SETTINGS_CHANGED_EVENT, handleProviderSettingsChange);
  }, []);

  useEffect(() => {
    const validModes = getPermissionModesForProvider(provider);
    const sessionSavedMode = selectedSession?.id
      ? (localStorage.getItem(`permissionMode-${selectedSession.id}`) as PermissionMode | null)
      : null;
    // Fall back to the last mode picked in this pane: a brand-new chat only
    // receives its session id after the first send, so without this the mode
    // chosen beforehand would snap back to the default as soon as the session
    // id appears. The key is pane-scoped — a per-provider key leaked one
    // tile's mode into every other draft of the same provider.
    const paneSavedMode = localStorage.getItem(`permissionMode-last-${permissionModeScope}`) as PermissionMode | null;
    // The provider-wide default persisted by Settings → Agents is the last
    // fallback: a session or pane pick always wins over it.
    const settingsSavedMode = readStoredPermissionMode(provider);
    const savedMode = [sessionSavedMode, paneSavedMode, settingsSavedMode].find(
      (mode): mode is PermissionMode => Boolean(mode && validModes.includes(mode as PermissionMode)),
    );
    setPermissionMode(savedMode ?? getDefaultPermissionModeForProvider(provider));
  }, [selectedSession?.id, provider, permissionModeScope, providerSettingsRevision, getDefaultPermissionModeForProvider, getPermissionModesForProvider]);

  useEffect(() => {
    // Payload sessions only carry the plain `provider` field (`__provider` is
    // added by the UI-resolved copies), so both must count as the session's
    // provider — otherwise a pane opened from the sidebar keeps the previous
    // provider's catalog and asks the wrong provider for the active model.
    const sessionProvider = selectedSession?.__provider ?? selectedSession?.provider;
    if (!sessionProvider || sessionProvider === provider) {
      return;
    }

    setProvider(sessionProvider);
    localStorage.setItem('selected-provider', sessionProvider);
  }, [provider, selectedSession]);

  // Permission prompts belong to a session, not to the transient provider
  // selection that is synchronized after navigation.
  useEffect(() => {
    setPendingPermissionRequests((previous) =>
      previous.filter((request) => !request.sessionId || request.sessionId === selectedSession?.id),
    );
  }, [selectedSession?.id]);

  const selectPermissionMode = useCallback((nextMode: PermissionMode) => {
    setPermissionMode(nextMode);

    // Persist per pane as well as per session: a brand-new chat has no
    // session id yet, and the pane-scoped key keeps the choice sticky when
    // the real id arrives without leaking into neighboring tiles.
    localStorage.setItem(`permissionMode-last-${permissionModeScope}`, nextMode);
    if (selectedSession?.id) {
      localStorage.setItem(`permissionMode-${selectedSession.id}`, nextMode);
    }
  }, [permissionModeScope, selectedSession?.id]);

  const cyclePermissionMode = useCallback(() => {
    const modes = getPermissionModesForProvider(provider);

    const currentIndex = modes.indexOf(permissionMode);
    const nextIndex = (currentIndex + 1) % modes.length;
    selectPermissionMode(modes[nextIndex]);
  }, [permissionMode, provider, getPermissionModesForProvider, selectPermissionMode]);

  const availablePermissionModes = useMemo(
    () => getPermissionModesForProvider(provider),
    [getPermissionModesForProvider, provider],
  );

  const resolvePermissionModeForProvider = useCallback((
    targetProvider: LLMProvider,
    requestedMode: PermissionMode | string,
  ): PermissionMode => {
    const validModes = getPermissionModesForProvider(targetProvider);
    return validModes.includes(requestedMode as PermissionMode)
      ? requestedMode as PermissionMode
      : getDefaultPermissionModeForProvider(targetProvider);
  }, [getDefaultPermissionModeForProvider, getPermissionModesForProvider]);

  /** Model and reasoning effort recorded for the open session by the backend. */
  const [sessionSelection, setSessionSelection] = useState<SessionProviderSelection | null>(null);
  const selectedSessionId = selectedSession?.id?.trim() || null;
  const selectedSessionProvider = selectedSession?.__provider ?? selectedSession?.provider ?? provider;
  const selectedSessionKey = selectedSessionId
    ? getSessionSelectionKey(selectedSessionProvider, selectedSessionId)
    : null;
  const selectedSessionKeyRef = useRef<string | null>(selectedSessionKey);
  selectedSessionKeyRef.current = selectedSessionKey;

  const activeSessionSelection = sessionSelection
    && selectedSessionId
    && sessionSelection.sessionId === selectedSessionId
    && sessionSelection.provider === selectedSessionProvider
    ? sessionSelection
    : null;
  /**
   * The projects payload already carries each session's recorded model, so the
   * composer can show it from the first paint instead of falling back to the
   * per-provider default (e.g. SWE-2 Max) while the active-model request is in
   * flight — that fallback used to be sent with the next message and recorded
   * on the session, silently switching it.
   */
  const payloadSessionModel = typeof selectedSession?.model === 'string'
    ? selectedSession.model.trim()
    : '';
  const payloadSessionSelection: SessionProviderSelection | null = selectedSessionId && payloadSessionModel
    ? {
      provider: selectedSessionProvider,
      sessionId: selectedSessionId,
      model: payloadSessionModel,
      effort: null,
    }
    : null;
  const sessionModel = (activeSessionSelection ?? payloadSessionSelection)?.model ?? null;

  useEffect(() => {
    const requestId = sessionSelectionLoadRequestIdRef.current + 1;
    sessionSelectionLoadRequestIdRef.current = requestId;

    if (!selectedSessionId) {
      setSessionSelection(null);
      return;
    }

    let cancelled = false;
    const targetProvider = selectedSessionProvider;
    const targetSessionKey = getSessionSelectionKey(targetProvider, selectedSessionId);

    // Auto owns model/effort per step — there is no per-session selection
    // endpoint for it, so skip the request instead of logging a 404.
    if (targetProvider === 'orchestrator') {
      setSessionSelection({
        provider: targetProvider,
        sessionId: selectedSessionId,
        model: null,
        effort: null,
      });
      return;
    }

    const loadSessionSelection = async () => {
      try {
        const response = await authenticatedFetch(
          `/api/providers/${targetProvider}/sessions/${encodeURIComponent(selectedSessionId)}/active-model`,
        );
        const body = (await response.json()) as SessionSelectionApiResponse;
        if (
          cancelled
          || sessionSelectionLoadRequestIdRef.current !== requestId
          || selectedSessionKeyRef.current !== targetSessionKey
        ) {
          return;
        }

        const resolvedModel = body.data?.model?.trim();
        const resolvedEffort = body.data?.effort?.trim() || null;
        setSessionSelection({
          provider: targetProvider,
          sessionId: selectedSessionId,
          model: body.success && resolvedModel && body.data?.source !== 'default' ? resolvedModel : null,
          effort: body.success ? resolvedEffort : null,
        });
      } catch (error) {
        if (
          !cancelled
          && sessionSelectionLoadRequestIdRef.current === requestId
          && selectedSessionKeyRef.current === targetSessionKey
        ) {
          console.error('Error loading the session model and reasoning effort:', error);
          setSessionSelection({
            provider: targetProvider,
            sessionId: selectedSessionId,
            model: null,
            effort: null,
          });
        }
      }
    };

    void loadSessionSelection();
    return () => {
      cancelled = true;
    };
  }, [selectedSessionId, selectedSessionProvider]);

  /**
   * Applies a model choice.
   *
   * The pick always becomes the per-provider default so the next new chat
   * inherits it, and — when a session is open — is also recorded against that
   * session so reopening it later restores this model.
   */
  const selectProviderModel = useCallback(async (
    targetProvider: LLMProvider,
    model: string,
    sessionId?: string | null,
  ) => {
    const normalizedSessionId = typeof sessionId === 'string' ? sessionId.trim() : '';
    // An isolated draft pane keeps the pick local so panes can't bleed
    // per-provider defaults into each other.
    setStoredProviderModel(targetProvider, model, !isolateDraftDefaults);

    if (!normalizedSessionId) {
      return { scope: 'default' as const, model };
    }

    // A pending GET represents the state before this click and must not win
    // if it resolves after the mutation.
    sessionSelectionLoadRequestIdRef.current += 1;
    const mutationId = sessionModelMutationIdRef.current + 1;
    sessionModelMutationIdRef.current = mutationId;
    const targetSessionKey = getSessionSelectionKey(targetProvider, normalizedSessionId);

    const response = await authenticatedFetch(
      `/api/providers/${targetProvider}/sessions/${encodeURIComponent(normalizedSessionId)}/active-model`,
      {
        method: 'POST',
        body: JSON.stringify({ model }),
      },
    );

    const body = (await response.json()) as SessionSelectionApiResponse;
    if (!response.ok || !body.success) {
      throw new Error('Unable to change the active model for this session.');
    }

    const storedModel = body.data?.model?.trim() || model;
    if (
      sessionModelMutationIdRef.current === mutationId
      && selectedSessionKeyRef.current === targetSessionKey
    ) {
      setSessionSelection((current) => ({
        provider: targetProvider,
        sessionId: normalizedSessionId,
        model: storedModel,
        effort: current?.provider === targetProvider && current.sessionId === normalizedSessionId
          ? current.effort
          : body.data?.effort?.trim() || null,
      }));
    }
    return { scope: 'session' as const, model: storedModel };
  }, [isolateDraftDefaults, setStoredProviderModel]);

  /**
   * Applies an effort choice optimistically and persists it for the open
   * session. Mutation counters keep slower earlier requests from overwriting
   * the latest click.
   */
  const selectProviderEffort = useCallback(async (
    targetProvider: LLMProvider,
    effort: string,
    sessionId?: string | null,
  ) => {
    const normalizedSessionId = typeof sessionId === 'string' ? sessionId.trim() : '';
    // Same rule as selectProviderModel: an isolated draft pane keeps the
    // pick pane-local instead of writing the shared default.
    setStoredProviderEffort(targetProvider, effort, !isolateDraftDefaults);

    if (!normalizedSessionId) {
      return { scope: 'default' as const, effort };
    }

    sessionSelectionLoadRequestIdRef.current += 1;
    const mutationId = sessionEffortMutationIdRef.current + 1;
    sessionEffortMutationIdRef.current = mutationId;
    const targetSessionKey = getSessionSelectionKey(targetProvider, normalizedSessionId);
    const previousSelection = sessionSelection?.provider === targetProvider
      && sessionSelection.sessionId === normalizedSessionId
      ? sessionSelection
      : null;

    setSessionSelection({
      provider: targetProvider,
      sessionId: normalizedSessionId,
      model: previousSelection?.model ?? null,
      effort,
    });

    try {
      const response = await authenticatedFetch(
        `/api/providers/${targetProvider}/sessions/${encodeURIComponent(normalizedSessionId)}/active-effort`,
        {
          method: 'POST',
          body: JSON.stringify({ effort }),
        },
      );
      const body = (await response.json()) as SessionSelectionApiResponse;
      if (!response.ok || !body.success) {
        throw new Error('Unable to change the reasoning effort for this session.');
      }

      const storedEffort = body.data?.effort?.trim() || effort;
      if (
        sessionEffortMutationIdRef.current === mutationId
        && selectedSessionKeyRef.current === targetSessionKey
      ) {
        setSessionSelection((current) => ({
          provider: targetProvider,
          sessionId: normalizedSessionId,
          model: current?.provider === targetProvider && current.sessionId === normalizedSessionId
            ? current.model
            : previousSelection?.model ?? null,
          effort: storedEffort,
        }));
      }

      return { scope: 'session' as const, effort: storedEffort };
    } catch (error) {
      if (
        sessionEffortMutationIdRef.current === mutationId
        && selectedSessionKeyRef.current === targetSessionKey
      ) {
        setSessionSelection((current) => (
          current?.provider === targetProvider
          && current.sessionId === normalizedSessionId
          && current.effort === effort
            ? previousSelection
            : current
        ));
      }
      throw error;
    }
  }, [isolateDraftDefaults, sessionSelection, setStoredProviderEffort]);

  // The open session's model wins over the per-provider default, so switching
  // sessions shows (and sends) what each session actually runs with.
  const currentProviderModel = sessionModel ?? providerModels[provider];
  const currentProviderEffortOptions = useMemo(() => {
    return getEffortOptionsForModel(provider, currentProviderModel);
  }, [currentProviderModel, getEffortOptionsForModel, provider]);
  const currentProviderEffort = useMemo(() => {
    return reconcileStoredEffort(
      provider,
      currentProviderModel,
      activeSessionSelection?.effort
        ?? providerEfforts[provider]
        ?? DEFAULT_EFFORT_VALUE,
    );
  }, [activeSessionSelection?.effort, currentProviderModel, provider, providerEfforts, reconcileStoredEffort]);
  const currentProviderModelOptions = useMemo(
    () => (providerModelCatalog[provider]?.OPTIONS ?? []).filter(
      (option) => isModelAvailable(provider, option.value, option.tier),
    ),
    [provider, providerModelCatalog, isModelAvailable],
  );

  const applyProviderCatalog = useCallback((
    targetProvider: LLMProvider,
    models: ProviderModelsDefinition,
  ) => {
    setProviderModelCatalog((previous) => ({
      ...previous,
      [targetProvider]: models,
    }));
  }, []);

  const readModelMutationResponse = useCallback(async (
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
  }, []);

  const createCustomModel = useCallback(async (
    targetProvider: LLMProvider,
    input: CustomProviderModelInput,
  ) => {
    const response = await authenticatedFetch(`/api/providers/${targetProvider}/models`, {
      method: 'POST',
      body: JSON.stringify(input),
    });
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(targetProvider, result.models);
  }, [applyProviderCatalog, readModelMutationResponse]);

  const updateCustomModel = useCallback(async (
    targetProvider: LLMProvider,
    existing: ProviderModelOption,
    input: CustomProviderModelInput,
  ) => {
    if (!existing.recordId) {
      throw new Error('This model cannot be edited.');
    }

    const response = await authenticatedFetch(
      `/api/providers/${targetProvider}/models/${existing.recordId}`,
      {
        method: 'PATCH',
        body: JSON.stringify(input),
      },
    );
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(targetProvider, result.models);

    if (providerModels[targetProvider] === existing.value) {
      setStoredProviderModel(targetProvider, result.model.value);
    }
    if (provider === targetProvider && sessionModel === existing.value) {
      setSessionSelection((current) => current ? {
        ...current,
        model: result.model.value,
      } : current);
    }
  }, [
    applyProviderCatalog,
    provider,
    providerModels,
    readModelMutationResponse,
    sessionModel,
    setStoredProviderModel,
  ]);

  const removeCustomModel = useCallback(async (
    targetProvider: LLMProvider,
    existing: ProviderModelOption,
  ) => {
    if (!existing.recordId) {
      throw new Error('This model cannot be deleted.');
    }

    const response = await authenticatedFetch(
      `/api/providers/${targetProvider}/models/${existing.recordId}`,
      { method: 'DELETE' },
    );
    const result = await readModelMutationResponse(response);
    applyProviderCatalog(targetProvider, result.models);

    if (providerModels[targetProvider] === existing.value) {
      setStoredProviderModel(targetProvider, result.models.DEFAULT);
    }
    if (provider === targetProvider && sessionModel === existing.value) {
      setSessionSelection((current) => current ? {
        ...current,
        model: result.models.DEFAULT,
      } : current);
    }
  }, [
    applyProviderCatalog,
    provider,
    providerModels,
    readModelMutationResponse,
    sessionModel,
    setStoredProviderModel,
  ]);

  const providerModelActions = useMemo<ProviderModelActions>(() => ({
    create: createCustomModel,
    update: updateCustomModel,
    remove: removeCustomModel,
  }), [createCustomModel, removeCustomModel, updateCustomModel]);

  return {
    provider,
    setProvider,
    cursorModel,
    setCursorModel,
    claudeModel,
    setClaudeModel,
    codexModel,
    setCodexModel,
    currentProviderEffort,
    currentProviderEffortOptions,
    currentProviderModel,
    currentProviderModelOptions,
    opencodeModel,
    setOpenCodeModel,
    devinModel,
    setDevinModel,
    permissionMode,
    setPermissionMode,
    pendingPermissionRequests,
    setPendingPermissionRequests,
    availablePermissionModes,
    selectPermissionMode,
    cyclePermissionMode,
    providerModelCatalog,
    providerModelsLoading,
    loadProviderModels,
    providerModelActions,
    selectProviderModel,
    selectProviderEffort,
    resolvePermissionModeForProvider,
  };
}

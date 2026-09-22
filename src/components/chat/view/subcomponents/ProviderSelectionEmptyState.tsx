import React, { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { Check, ChevronDown, Folder, Loader2, MessageSquare, Plus, RotateCw, Star, Wallet } from "lucide-react";
import { Trans, useTranslation } from "react-i18next";

import type {
  Project,
  ProjectSession,
  LLMProvider,
  ProviderModelActions,
  ProviderModelOption,
  ProviderModelsDefinition,
} from "../../../../types/app";
import { formatContextWindow } from "../../../../shared/utils";
import LLMProviderLogo from "../../../llm-provider-logo/LLMProviderLogo";
import { NextTaskBanner } from "../../../task-master";
import type { TaskMasterTask } from "../../../task-master/types";
import {
  Dialog,
  DialogTrigger,
  DialogContent,
  DialogTitle,
  Command,
  CommandInput,
  CommandList,
  CommandEmpty,
  CommandGroup,
  CommandItem,
  Card,
  Badge,
  Button,
  PillBar,
  Pill,
} from "../../../../shared/view/ui";
import { useFavoriteModels, getModelTier, type FavoriteModel } from "../../hooks/useFavoriteModels";
import { useSubscriptionUsage } from "../../../../hooks/useSubscriptionUsage";
import { useWorkspace } from "../../../../contexts/WorkspaceContext";
import { matchesModelSearch } from "../../utils/modelSearch";
import { writeProviderSetting } from "../../utils/providerPaneStorage";

import ModelLibraryPanel from "./ModelLibraryPanel";

const PROVIDER_META: { id: LLMProvider; name: string }[] = [
  { id: "claude", name: "Anthropic" },
  { id: "codex", name: "OpenAI" },
  { id: "cursor", name: "Cursor" },
  { id: "opencode", name: "OpenCode" },
  { id: "devin", name: "Devin" },
];

const MOD_KEY =
  typeof navigator !== "undefined" && /Mac|iPhone|iPad/.test(navigator.platform) ? "⌘" : "Ctrl";

// cmdk scores its filter 0/1; the matching rules live in utils/modelSearch so
// the in-chat composer model menu searches identically.
function modelSearchFilter(value: string, search: string): number {
  return matchesModelSearch(value, search) ? 1 : 0;
}

type TierFilter = "all" | "free" | "paid";

type ProviderSelectionEmptyStateProps = {
  selectedSession: ProjectSession | null;
  currentSessionId: string | null;
  /** Hosting workspace pane — scopes the draft's model pick to this tile. */
  boundPaneId?: string | null;
  provider: LLMProvider;
  setProvider: (next: LLMProvider) => void;
  textareaRef: React.RefObject<HTMLTextAreaElement>;
  claudeModel: string;
  setClaudeModel: (model: string) => void;
  cursorModel: string;
  setCursorModel: (model: string) => void;
  codexModel: string;
  setCodexModel: (model: string) => void;
  opencodeModel: string;
  setOpenCodeModel: (model: string) => void;
  devinModel: string;
  setDevinModel: (model: string) => void;
  providerModelCatalog: Partial<Record<LLMProvider, ProviderModelsDefinition>>;
  providerModelActions: ProviderModelActions;
  providerModelsLoading: boolean;
  onRefreshProviderModels?: (force?: boolean) => Promise<void> | void;
  tasksEnabled: boolean;
  isTaskMasterInstalled: boolean | null;
  onShowAllTasks?: (() => void) | null;
  setInput: React.Dispatch<React.SetStateAction<string>>;
  /** Workspace the draft chat pane is bound to — shown on the workspace card. */
  selectedProject?: Project | null;
  /** All workspaces — powers the workspace picker next to the model picker. */
  projects?: Project[];
  /** Rebinds the draft pane to another workspace. */
  onSelectWorkspace?: (project: Project) => void;
};

type ProviderGroup = {
  id: LLMProvider;
  name: string;
  models: ProviderModelOption[];
};

function getModelConfig(
  p: LLMProvider,
  catalog: Partial<Record<LLMProvider, ProviderModelsDefinition>>,
): ProviderModelsDefinition {
  const entry = catalog[p];
  return entry ?? { OPTIONS: [], DEFAULT: "" };
}

function getCurrentModel(
  p: LLMProvider,
  c: string,
  cu: string,
  co: string,
  o: string,
  d: string,
) {
  if (p === "claude") return c;
  if (p === "codex") return co;
  if (p === "opencode") return o;
  if (p === "devin") return d;
  return cu;
}

function getProviderDisplayName(p: LLMProvider) {
  if (p === "claude") return "Claude";
  if (p === "cursor") return "Cursor";
  if (p === "codex") return "Codex";
  if (p === "opencode") return "OpenCode";
  if (p === "devin") return "Devin";
  return "Claude";
}

function formatModelDescription(option: { description?: string; context?: number }): string | undefined {
  const contextText = formatContextWindow(option.context);
  const parts = [option.description, contextText ? `${contextText} context` : null].filter((part): part is string => Boolean(part));
  return parts.length > 0 ? parts.join(' · ') : undefined;
}

export default function ProviderSelectionEmptyState({
  selectedSession,
  currentSessionId,
  boundPaneId,
  provider,
  setProvider,
  textareaRef,
  claudeModel,
  setClaudeModel,
  cursorModel,
  setCursorModel,
  codexModel,
  setCodexModel,
  opencodeModel,
  setOpenCodeModel,
  devinModel,
  setDevinModel,
  providerModelCatalog,
  providerModelActions,
  providerModelsLoading,
  onRefreshProviderModels,
  tasksEnabled,
  isTaskMasterInstalled,
  onShowAllTasks,
  setInput,
  selectedProject,
  projects = [],
  onSelectWorkspace,
}: ProviderSelectionEmptyStateProps) {
  const { t } = useTranslation("chat");
  const { isModelAvailable, isProviderAvailable } = useSubscriptionUsage();
  const { panes, lastUsedProjectId } = useWorkspace();
  // A draft pane (no session) sharing the workspace with other chat panes
  // must not write the shared provider/model defaults — they would leak
  // into the other panes' drafts.
  const isolateDraftDefaults =
    !(selectedSession?.id || currentSessionId)
    && panes.filter((pane) => pane.kind === "chat").length > 1;
  const [dialogOpen, setDialogOpen] = useState(false);
  const [workspaceDialogOpen, setWorkspaceDialogOpen] = useState(false);
  const [modelLibraryOpen, setModelLibraryOpen] = useState(false);
  const [tierFilter, setTierFilter] = useState<TierFilter>("all");
  const { favorites, isFavorite, toggleFavorite } = useFavoriteModels();
  const wasDialogOpen = useRef(false);
  const focusTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  // A pending composer refocus must not survive unmount — it would otherwise
  // fire into whichever view replaced this one.
  useEffect(() => {
    return () => {
      if (focusTimeoutRef.current) {
        clearTimeout(focusTimeoutRef.current);
        focusTimeoutRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    if (dialogOpen && !wasDialogOpen.current && onRefreshProviderModels && !providerModelsLoading) {
      void onRefreshProviderModels();
    }
    wasDialogOpen.current = dialogOpen;
  }, [dialogOpen, onRefreshProviderModels, providerModelsLoading]);

  const favoriteModels = useMemo<FavoriteModel[]>(() => {
    return Object.values(favorites).filter((favorite) => {
      // Same rule as the provider groups below: resolve the tier so a model
      // without one doesn't leak into both the Free and Paid tabs.
      if (tierFilter !== "all" && getModelTier(favorite) !== tierFilter) return false;
      return isModelAvailable(favorite.provider, favorite.value, favorite.tier);
    });
  }, [favorites, tierFilter, isModelAvailable]);

  const visibleProviderGroups = useMemo<ProviderGroup[]>(() => {
    return PROVIDER_META.map((p) => {
      const allModels = providerModelCatalog[p.id]?.OPTIONS ?? [];
      const models =
        tierFilter === "all"
          ? allModels
          : allModels.filter((m) => getModelTier(m) === tierFilter);
      return { id: p.id, name: p.name, models };
    })
      .filter((g) => isProviderAvailable(g.id))
      .map((g) => ({
        ...g,
        models: g.models.filter((model) => isModelAvailable(g.id, model.value, model.tier)),
      }))
      .filter((g) => g.models.length > 0);
  }, [providerModelCatalog, tierFilter, isProviderAvailable, isModelAvailable]);

  const currentModel = getCurrentModel(
    provider,
    claudeModel,
    cursorModel,
    codexModel,
    opencodeModel,
    devinModel,
  );

  const currentModelLabel = useMemo(() => {
    const config = getModelConfig(provider, providerModelCatalog);
    const found = config.OPTIONS.find(
      (o: { value: string; label: string }) => o.value === currentModel,
    );
    return found?.label || currentModel;
  }, [provider, currentModel, providerModelCatalog]);

  const setModelForProvider = useCallback(
    (providerId: LLMProvider, modelValue: string) => {
      // The pane-scoped copy keeps this pick when the pane remounts (layout
      // restore, reload) instead of falling back to the shared default; the
      // shared key is only written outside isolated drafts.
      writeProviderSetting(localStorage, `${providerId}-model`, modelValue, {
        paneId: boundPaneId,
        persistShared: !isolateDraftDefaults,
      });

      if (providerId === "claude") {
        setClaudeModel(modelValue);
      } else if (providerId === "codex") {
        setCodexModel(modelValue);
      } else if (providerId === "opencode") {
        setOpenCodeModel(modelValue);
      } else if (providerId === "devin") {
        setDevinModel(modelValue);
      } else {
        setCursorModel(modelValue);
      }
    },
    [boundPaneId, isolateDraftDefaults, setClaudeModel, setCursorModel, setCodexModel, setOpenCodeModel, setDevinModel],
  );

  const handleModelSelect = useCallback(
    (providerId: LLMProvider, modelValue: string) => {
      setProvider(providerId);
      if (!isolateDraftDefaults) localStorage.setItem("selected-provider", providerId);
      setModelForProvider(providerId, modelValue);
      setDialogOpen(false);
      if (focusTimeoutRef.current) clearTimeout(focusTimeoutRef.current);
      focusTimeoutRef.current = setTimeout(() => {
        focusTimeoutRef.current = null;
        textareaRef.current?.focus();
      }, 100);
    },
    [isolateDraftDefaults, setProvider, setModelForProvider, textareaRef],
  );

  const openModelLibrary = () => {
    setDialogOpen(false);
    setModelLibraryOpen(true);
  };

  // Same ordering as WorkspaceLauncher: most recently used workspace first,
  // then by last activity.
  const orderedProjects = useMemo(() => {
    const lastActivityMs = (project: Project) => {
      const value = project.lastActivity;
      return typeof value === "string" ? new Date(value).getTime() : 0;
    };
    const sorted = [...projects].sort((a, b) => lastActivityMs(b) - lastActivityMs(a));
    if (!lastUsedProjectId) return sorted;
    const preferred = sorted.find((project) => project.projectId === lastUsedProjectId);
    if (!preferred) return sorted;
    return [preferred, ...sorted.filter((project) => project.projectId !== lastUsedProjectId)];
  }, [projects, lastUsedProjectId]);

  const handleWorkspaceSelect = useCallback(
    (project: Project) => {
      onSelectWorkspace?.(project);
      setWorkspaceDialogOpen(false);
      if (focusTimeoutRef.current) clearTimeout(focusTimeoutRef.current);
      focusTimeoutRef.current = setTimeout(() => {
        focusTimeoutRef.current = null;
        textareaRef.current?.focus();
      }, 100);
    },
    [onSelectWorkspace, textareaRef],
  );

  // Same prompt TaskMasterPanel's run-task uses (`/task-master start <id>`),
  // then return focus to the composer so the user can review/send it.
  const handleStartTask = useCallback(
    (task: TaskMasterTask) => {
      setInput(`/task-master start ${task.id}`);
      if (focusTimeoutRef.current) clearTimeout(focusTimeoutRef.current);
      focusTimeoutRef.current = setTimeout(() => {
        focusTimeoutRef.current = null;
        textareaRef.current?.focus();
      }, 100);
    },
    [setInput, textareaRef],
  );

  const closeModelLibrary = () => {
    setModelLibraryOpen(false);
    setDialogOpen(true);
  };

  if (!selectedSession && !currentSessionId) {
    return (
      <div className="flex h-full items-center justify-center px-4">
        <div className="w-full max-w-[34.25rem]">
          <div className="mb-8 text-center">
            <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl border border-border/60 bg-muted/40">
              <LLMProviderLogo provider={provider} className="h-6 w-6" />
            </div>
            <h2 className="text-lg font-semibold tracking-tight text-foreground sm:text-xl">
              {t("providerSelection.title")}
            </h2>
            <p className="mt-1 text-[13px] text-muted-foreground">
              {t("providerSelection.description")}
            </p>
          </div>

          <div className="flex flex-col gap-3 sm:flex-row">
          <Dialog open={dialogOpen} onOpenChange={setDialogOpen}>
            <DialogTrigger asChild>
              <Card
                className="group w-full min-w-0 cursor-pointer border-border/60 transition-all duration-150 hover:border-border hover:shadow-md active:scale-[0.99] sm:flex-1 sm:basis-0"
                role="button"
                tabIndex={0}
              >
                <div className="flex items-center gap-2 p-3">
                  <LLMProviderLogo
                    provider={provider}
                    className="h-5 w-5 shrink-0"
                  />
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-1">
                      <span className="text-xs font-semibold text-foreground">
                        {getProviderDisplayName(provider)}
                      </span>
                      <span className="text-xs text-muted-foreground">·</span>
                      <span className="truncate text-xs text-foreground">
                        {currentModelLabel}
                      </span>
                    </div>
                    <p className="mt-0.5 text-[11px] text-muted-foreground">
                      {t("providerSelection.clickToChange", {
                        defaultValue: "Click to change model",
                      })}
                    </p>
                  </div>
                  <ChevronDown className="h-3.5 w-3.5 shrink-0 text-muted-foreground transition-transform group-hover:translate-y-0.5" />
                </div>
              </Card>
            </DialogTrigger>

            <DialogContent className="max-w-md overflow-hidden p-0">
              <DialogTitle>Model Selector</DialogTitle>
              <div className="flex items-center justify-between gap-3 border-b border-border/60 bg-muted/20 px-4 py-3">
                <div>
                  <p className="text-sm font-semibold text-foreground">
                    {t("providerSelection.chooseModel", {
                      defaultValue: "Choose a model",
                    })}
                  </p>
                  <p className="mt-0.5 text-[11px] text-muted-foreground">
                    {t("providerSelection.chooseModelDescription", {
                      defaultValue: "Built-in and custom models in one list",
                    })}
                  </p>
                </div>
                <div className="flex items-center gap-1">
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    onClick={() => onRefreshProviderModels?.(true)}
                    disabled={providerModelsLoading}
                    className="h-8 w-8 shrink-0 rounded-lg p-0"
                    aria-label={t("providerSelection.refresh", { defaultValue: "Refresh models" })}
                    title={t("providerSelection.refresh", { defaultValue: "Refresh models" })}
                  >
                    {providerModelsLoading ? (
                      <Loader2 className="h-3.5 w-3.5 animate-spin text-muted-foreground" />
                    ) : (
                      <RotateCw className="h-3.5 w-3.5 text-muted-foreground" />
                    )}
                  </Button>
                  <Button
                    type="button"
                    variant="ghost"
                    size="sm"
                    onClick={openModelLibrary}
                    className="h-8 shrink-0 rounded-lg px-2.5 text-xs"
                  >
                    <Plus className="h-3.5 w-3.5" />
                    {t("providerSelection.addModel", { defaultValue: "Add model" })}
                  </Button>
                </div>
              </div>
              <div className="border-b border-border/60 bg-muted/20 px-4 py-2">
                <PillBar>
                  <Pill
                    isActive={tierFilter === "all"}
                    onClick={() => setTierFilter("all")}
                  >
                    {t("providerSelection.all", { defaultValue: "All" })}
                  </Pill>
                  <Pill
                    isActive={tierFilter === "free"}
                    onClick={() => setTierFilter("free")}
                  >
                    {t("providerSelection.free", { defaultValue: "Free" })}
                  </Pill>
                  <Pill
                    isActive={tierFilter === "paid"}
                    onClick={() => setTierFilter("paid")}
                  >
                    <Wallet className="h-3 w-3" />
                    {t("providerSelection.paid", { defaultValue: "Paid" })}
                  </Pill>
                </PillBar>
              </div>
              <Command filter={modelSearchFilter}>
                <CommandInput
                  placeholder={t("providerSelection.searchModels", {
                    defaultValue: "Search models...",
                  })}
                />
                <CommandList className="max-h-[350px]">
                  <CommandEmpty>
                    {t("providerSelection.noModelsFound", {
                      defaultValue: "No models found.",
                    })}
                  </CommandEmpty>
                  {favoriteModels.length > 0 && (
                    <CommandGroup
                      key="favorites"
                      className="[&_[cmdk-group-heading]]:uppercase [&_[cmdk-group-heading]]:tracking-wider"
                      heading={
                        <span className="flex items-center gap-1.5">
                          <Star className="h-3.5 w-3.5 fill-amber-400 text-amber-400" />
                          {t("providerSelection.favorites", { defaultValue: "Favorites" })}
                        </span>
                      }
                    >
                      {favoriteModels.map((favorite) => {
                        const isSelected =
                          provider === favorite.provider && currentModel === favorite.value;
                        const favoriteDescription = formatModelDescription(favorite);
                        return (
                          <CommandItem
                            key={`fav-${favorite.provider}-${favorite.value}`}
                            value={`${favorite.provider} Favorites ${favorite.label} ${favoriteDescription || ''}`}
                            onSelect={() => handleModelSelect(favorite.provider, favorite.value)}
                            className="ml-4 border-l border-border/40 pl-4"
                          >
                            <div className="min-w-0 flex-1">
                              <div className="flex min-w-0 items-center gap-2">
                                <span className="truncate">{favorite.label}</span>
                                {favorite.isCustom ? (
                                  <Badge className="h-4 shrink-0 rounded-full px-1.5 text-[8px]">Custom</Badge>
                                ) : favorite.tier === "free" ? (
                                  <Badge className="h-4 shrink-0 rounded-full border border-emerald-200 bg-emerald-100 px-1.5 text-[8px] text-emerald-700">
                                    Free
                                  </Badge>
                                ) : favorite.tier ? (
                                  <Badge className="h-4 shrink-0 rounded-full border border-border bg-muted px-1.5 text-[8px] text-muted-foreground">
                                    Paid
                                  </Badge>
                                ) : null}
                              </div>
                              {favorite.label !== favorite.value && (
                                <div className="truncate font-mono text-[10px] text-muted-foreground">
                                  {favorite.value}
                                </div>
                              )}
                              {favoriteDescription && (
                                <div className="truncate text-[10px] text-muted-foreground/80">
                                  {favoriteDescription}
                                </div>
                              )}
                            </div>
                            <div className="ml-auto flex shrink-0 items-center gap-1.5">
                              <button
                                type="button"
                                onClick={(event) => {
                                  event.preventDefault();
                                  event.stopPropagation();
                                  toggleFavorite(favorite.provider, {
                                    value: favorite.value,
                                    label: favorite.label,
                                    description: favorite.description,
                                    context: favorite.context,
                                    tier: favorite.tier,
                                    isCustom: favorite.isCustom,
                                  } as ProviderModelOption);
                                }}
                                className="rounded p-0.5 text-muted-foreground hover:text-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                aria-label={
                                  isFavorite(favorite.provider, favorite.value)
                                    ? "Remove from favorites"
                                    : "Add to favorites"
                                }
                                title={
                                  isFavorite(favorite.provider, favorite.value)
                                    ? "Remove from favorites"
                                    : "Add to favorites"
                                }
                              >
                                <Star
                                  className={`h-3.5 w-3.5 ${
                                    isFavorite(favorite.provider, favorite.value)
                                      ? 'fill-amber-400 text-amber-400'
                                      : 'text-muted-foreground'
                                  }`}
                                />
                              </button>
                              {isSelected && (
                                <Check className="h-4 w-4 shrink-0 text-primary" />
                              )}
                            </div>
                          </CommandItem>
                        );
                      })}
                    </CommandGroup>
                  )}
                  {visibleProviderGroups.map((group, idx) => (
                    <CommandGroup
                      key={group.id}
                      className={
                        idx > 0 || favoriteModels.length > 0
                          ? "border-t border-border/40 [&_[cmdk-group-heading]]:mt-1 [&_[cmdk-group-heading]]:uppercase [&_[cmdk-group-heading]]:tracking-wider"
                          : "[&_[cmdk-group-heading]]:uppercase [&_[cmdk-group-heading]]:tracking-wider"
                      }
                      heading={
                        <span className="flex items-center gap-1.5">
                          <LLMProviderLogo provider={group.id} className="h-3.5 w-3.5 shrink-0" />
                          {group.name}
                        </span>
                      }
                    >
                      {group.models.length === 0 && providerModelsLoading ? (
                        <CommandItem disabled className="ml-4 border-l border-border/40 pl-4 text-muted-foreground">
                          {t("providerSelection.loadingModels", { defaultValue: "Loading models…" })}
                        </CommandItem>
                      ) : null}
                      {group.models.map((model) => {
                        const isSelected = provider === group.id && currentModel === model.value;
                        const favorited = isFavorite(group.id, model.value);
                        const modelDescription = formatModelDescription(model);
                        return (
                          <CommandItem
                            key={`${group.id}-${model.value}`}
                            value={`${group.name} ${model.label} ${modelDescription || ''}`}
                            onSelect={() => handleModelSelect(group.id, model.value)}
                            className="ml-4 border-l border-border/40 pl-4"
                          >
                            <div className="min-w-0 flex-1">
                              <div className="flex min-w-0 items-center gap-2">
                                <span className="truncate">{model.label}</span>
                                {model.isCustom ? (
                                  <Badge className="h-4 shrink-0 rounded-full px-1.5 text-[8px]">Custom</Badge>
                                ) : getModelTier(model) === "free" ? (
                                  <Badge className="h-4 shrink-0 rounded-full border border-emerald-200 bg-emerald-100 px-1.5 text-[8px] text-emerald-700">
                                    Free
                                  </Badge>
                                ) : (
                                  <Badge className="h-4 shrink-0 rounded-full border border-border bg-muted px-1.5 text-[8px] text-muted-foreground">
                                    Paid
                                  </Badge>
                                )}
                              </div>
                              {model.label !== model.value && (
                                <div className="truncate font-mono text-[10px] text-muted-foreground">
                                  {model.value}
                                </div>
                              )}
                              {modelDescription && (
                                <div className="truncate text-[10px] text-muted-foreground/80">
                                  {modelDescription}
                                </div>
                              )}
                            </div>
                            <div className="ml-auto flex shrink-0 items-center gap-1.5">
                              <button
                                type="button"
                                onClick={(event) => {
                                  event.preventDefault();
                                  event.stopPropagation();
                                  toggleFavorite(group.id, model);
                                }}
                                className="rounded p-0.5 text-muted-foreground hover:text-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                aria-label={favorited ? "Remove from favorites" : "Add to favorites"}
                                title={favorited ? "Remove from favorites" : "Add to favorites"}
                              >
                                <Star
                                  className={`h-3.5 w-3.5 ${
                                    favorited ? 'fill-amber-400 text-amber-400' : 'text-muted-foreground'
                                  }`}
                                  aria-hidden
                                  role="img"
                                />
                              </button>
                              {isSelected && (
                                <Check className="h-4 w-4 shrink-0 text-primary" />
                              )}
                            </div>
                          </CommandItem>
                        );
                      })}
                    </CommandGroup>
                  ))}
                </CommandList>
              </Command>
            </DialogContent>
          </Dialog>

          {projects.length > 0 && onSelectWorkspace && (
            <Dialog open={workspaceDialogOpen} onOpenChange={setWorkspaceDialogOpen}>
              <DialogTrigger asChild>
                <Card
                  className="group w-full min-w-0 cursor-pointer border-border/60 transition-all duration-150 hover:border-border hover:shadow-md active:scale-[0.99] sm:flex-1 sm:basis-0"
                  role="button"
                  tabIndex={0}
                >
                  <div className="flex items-center gap-2 p-3">
                    <Folder className="h-5 w-5 shrink-0 text-muted-foreground" />
                    <div className="min-w-0 flex-1">
                      <div className="flex items-center gap-1">
                        <span className="text-xs font-semibold text-foreground">
                          {t("providerSelection.workspace", { defaultValue: "Workspace" })}
                        </span>
                        <span className="text-xs text-muted-foreground">·</span>
                        <span className="truncate text-xs text-foreground">
                          {selectedProject?.displayName ||
                            t("providerSelection.noWorkspace", { defaultValue: "None" })}
                        </span>
                      </div>
                      <p className="mt-0.5 text-[11px] text-muted-foreground">
                        {t("providerSelection.clickToChangeWorkspace", {
                          defaultValue: "Click to change workspace",
                        })}
                      </p>
                    </div>
                    <ChevronDown className="h-3.5 w-3.5 shrink-0 text-muted-foreground transition-transform group-hover:translate-y-0.5" />
                  </div>
                </Card>
              </DialogTrigger>

              <DialogContent className="max-w-md overflow-hidden p-0">
                <DialogTitle>
                  {t("providerSelection.chooseWorkspace", { defaultValue: "Choose a workspace" })}
                </DialogTitle>
                <Command filter={modelSearchFilter}>
                  <CommandInput
                    placeholder={t("providerSelection.searchWorkspaces", {
                      defaultValue: "Search workspaces...",
                    })}
                  />
                  <CommandList className="max-h-[350px]">
                    <CommandEmpty>
                      {t("providerSelection.noWorkspacesFound", {
                        defaultValue: "No workspaces found.",
                      })}
                    </CommandEmpty>
                    {orderedProjects.map((project) => {
                      const isSelected = project.projectId === selectedProject?.projectId;
                      const projectPath = project.fullPath || project.path || "";
                      return (
                        <CommandItem
                          key={project.projectId}
                          value={`${project.displayName || project.projectId} ${projectPath}`}
                          onSelect={() => handleWorkspaceSelect(project)}
                        >
                          <div className="flex min-w-0 flex-1 items-center gap-2">
                            <Folder className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                            <div className="min-w-0 flex-1">
                              <span className="block truncate">
                                {project.displayName || project.projectId}
                              </span>
                              {projectPath && (
                                <span className="block truncate font-mono text-[10px] text-muted-foreground">
                                  {projectPath}
                                </span>
                              )}
                            </div>
                          </div>
                          {isSelected && (
                            <Check className="ml-auto h-4 w-4 shrink-0 text-primary" />
                          )}
                        </CommandItem>
                      );
                    })}
                  </CommandList>
                </Command>
              </DialogContent>
            </Dialog>
          )}
          </div>

          <Dialog
            open={modelLibraryOpen}
            onOpenChange={(open) => {
              if (open) {
                setModelLibraryOpen(true);
              } else {
                closeModelLibrary();
              }
            }}
          >
            <DialogContent className="flex h-[min(90dvh,46rem)] w-[calc(100vw-1rem)] max-w-4xl flex-col overflow-hidden rounded-3xl p-4 sm:p-5">
              <DialogTitle>
                {t("providerSelection.manageModels", {
                  defaultValue: "Manage models",
                })}
              </DialogTitle>
              <ModelLibraryPanel
                initialProvider={provider}
                providerModelCatalog={providerModelCatalog}
                actions={providerModelActions}
                onDone={closeModelLibrary}
              />
            </DialogContent>
          </Dialog>

          <p className="mt-4 text-center text-sm text-muted-foreground/70">
            {
              {
                claude: t("providerSelection.readyPrompt.claude", {
                  model: claudeModel,
                }),
                cursor: t("providerSelection.readyPrompt.cursor", {
                  model: cursorModel,
                }),
                codex: t("providerSelection.readyPrompt.codex", {
                  model: codexModel,
                }),
                opencode: t("providerSelection.readyPrompt.opencode", {
                  model: opencodeModel,
                  defaultValue: "Ready with OpenCode {{model}}",
                }),
                devin: t("providerSelection.readyPrompt.devin", {
                  model: devinModel,
                  defaultValue: "Ready with Devin {{model}}",
                }),
              }[provider]
            }
          </p>

          <p className="mt-3 flex items-center justify-center gap-1.5 text-center text-xs text-muted-foreground/60">
            <Trans
              ns="chat"
              i18nKey="providerSelection.pressToSearch"
              values={{ shortcut: MOD_KEY === "⌘" ? "⌘⇧K" : "Ctrl+Shift+K" }}
              components={{
                kbd: (
                  <kbd className="inline-flex items-center gap-0.5 rounded border border-border/60 bg-muted/40 px-1.5 py-0.5 font-mono text-[10px]" />
                ),
              }}
            />
          </p>

          {provider && tasksEnabled && isTaskMasterInstalled && (
            <div className="mt-5">
              <NextTaskBanner
                onStartTask={handleStartTask}
                onShowAllTasks={onShowAllTasks}
              />
            </div>
          )}
        </div>
      </div>
    );
  }

  if (selectedSession) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="max-w-[34.25rem] px-6 text-center">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl border border-border/60 bg-muted/40">
            <LLMProviderLogo provider={selectedSession.provider ?? provider} className="h-6 w-6" />
          </div>
          <p className="mb-1.5 text-lg font-semibold text-foreground">
            {t("session.continue.title")}
          </p>
          <p className="text-sm leading-relaxed text-muted-foreground">
            {t("session.continue.description")}
          </p>
          <Button
            size="sm"
            className="mt-4"
            onClick={() => {
              if (focusTimeoutRef.current) clearTimeout(focusTimeoutRef.current);
              focusTimeoutRef.current = setTimeout(() => {
                focusTimeoutRef.current = null;
                textareaRef.current?.focus();
              }, 100);
            }}
          >
            <MessageSquare />
            {t("session.continue.action", { defaultValue: "Continue typing" })}
          </Button>

          {tasksEnabled && isTaskMasterInstalled && (
            <div className="mt-5">
              <NextTaskBanner
                onStartTask={handleStartTask}
                onShowAllTasks={onShowAllTasks}
              />
            </div>
          )}
        </div>
      </div>
    );
  }

  return null;
}

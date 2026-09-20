import { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { createPortal } from 'react-dom';
import { useTranslation } from 'react-i18next';
import { Check, ChevronDown, ChevronRight, Search, Star } from 'lucide-react';

import { Badge, Pill, PillBar } from '../../../../shared/view/ui';
import { formatContextWindow } from '../../../../shared/utils';
import type { LLMProvider, ProviderModelOption } from '../../../../types/app';
import { DEFAULT_EFFORT_VALUE } from '../../constants/providerEffort';
import { useComposerMenuAnchor } from '../../hooks/useComposerMenuAnchor';
import { useFavoriteModels, getModelTier } from '../../hooks/useFavoriteModels';
import { useSubscriptionUsage } from '../../../../hooks/useSubscriptionUsage';
import { matchesModelSearch } from '../../utils/modelSearch';

import {
  ComposerMenuHeading,
  ComposerMenuItem,
  ComposerMenuSeparator,
  ComposerMenuSurface,
} from './ComposerMenuPrimitives';

type EffortOption = NonNullable<ProviderModelOption['effort']>['values'][number];
type TierFilter = 'all' | 'free' | 'paid';

interface ComposerModelMenuProps {
  effort: string;
  /** Effort values the active provider/model actually accepts; empty hides the section. */
  effortOptions: EffortOption[];
  onSelectEffort: (effort: string) => void;
  model: string;
  /** Model catalog for the active provider; empty hides the section. */
  modelOptions: ProviderModelOption[];
  onSelectModel: (model: string) => void;
  onRefreshModels?: (force?: boolean) => Promise<void> | void;
  modelsLoading: boolean;
  /** Active provider, used to scope favorites. */
  provider: LLMProvider;
}

function isFreeModel(option: ProviderModelOption | null | undefined): boolean {
  if (!option) return false;
  return getModelTier(option) === 'free';
}

function FreeBadge({ className }: { className?: string }) {
  return (
    <Badge
      variant="secondary"
      className={`rounded-full border-emerald-500/30 bg-emerald-500/15 px-1.5 py-0 text-[10px] font-medium text-emerald-700 hover:bg-emerald-500/20 ${className ?? ''}`}
    >
      Free
    </Badge>
  );
}

export default function ComposerModelMenu({
  effort,
  effortOptions,
  onSelectEffort,
  model,
  modelOptions,
  onSelectModel,
  onRefreshModels,
  modelsLoading,
  provider,
}: ComposerModelMenuProps) {
  const { t } = useTranslation('chat');
  const { isModelAvailable } = useSubscriptionUsage();
  const [isOpen, setIsOpen] = useState(false);
  const [isModelSectionOpen, setIsModelSectionOpen] = useState(false);
  const [tierFilter, setTierFilter] = useState<TierFilter>('all');
  const [search, setSearch] = useState('');
  const close = useCallback(() => setIsOpen(false), []);
  const { triggerRef, menuRef, anchor, updateAnchor } = useComposerMenuAnchor(isOpen, close);
  const { favorites, isFavorite, toggleFavorite, refresh } = useFavoriteModels();
  const wasModelSectionOpen = useRef(false);

  // The model list starts collapsed every time the menu opens, the way Codex
  // shows reasoning first and keeps the longer model list one click away.
  useEffect(() => {
    if (!isOpen) {
      setIsModelSectionOpen(false);
      setSearch('');
    }
  }, [isOpen]);

  useEffect(() => {
    if (isOpen) {
      refresh();
    }
  }, [isOpen, refresh]);

  // Refresh the provider catalog when the user expands the model section.
  useEffect(() => {
    if (isModelSectionOpen && !wasModelSectionOpen.current && onRefreshModels && !modelsLoading) {
      void onRefreshModels();
    }
    wasModelSectionOpen.current = isModelSectionOpen;
  }, [isModelSectionOpen, modelsLoading, onRefreshModels]);

  const defaultEffortLabel = t('composer.effortDefault', { defaultValue: 'Default' });
  const resolvedEffortOptions = useMemo<EffortOption[]>(
    () => (effortOptions.length > 0 ? [{ value: DEFAULT_EFFORT_VALUE }, ...effortOptions] : []),
    [effortOptions],
  );
  const effortLabel = effort === DEFAULT_EFFORT_VALUE ? defaultEffortLabel : effort;

  const mergedOptions = useMemo<ProviderModelOption[]>(() => {
    const map = new Map<string, ProviderModelOption>();
    modelOptions.forEach((option) => map.set(option.value, option));
    Object.values(favorites)
      .filter((favorite) => favorite.provider === provider)
      .forEach((favorite) => {
        if (!map.has(favorite.value)) {
          map.set(favorite.value, {
            value: favorite.value,
            label: favorite.label,
            description: favorite.description,
            context: favorite.context,
            tier: favorite.tier,
            isCustom: favorite.isCustom,
          });
        }
      });
    return Array.from(map.values()).filter((option) => isModelAvailable(provider, option.value));
  }, [modelOptions, favorites, provider, isModelAvailable]);

  const selectedModelOption = useMemo(
    () => mergedOptions.find((option) => option.value === model) ?? null,
    [model, mergedOptions],
  );
  const modelLabel = selectedModelOption?.label || model;
  const selectedFree = isFreeModel(selectedModelOption);

  const visibleOptions = useMemo(() => {
    if (tierFilter === 'all') return mergedOptions;
    return mergedOptions.filter((option) => getModelTier(option) === tierFilter);
  }, [mergedOptions, tierFilter]);

  const filteredOptions = useMemo(() => {
    const query = search.trim();
    if (!query) return visibleOptions;
    return visibleOptions.filter((option) =>
      matchesModelSearch(`${option.label} ${option.value} ${option.description ?? ''}`, query),
    );
  }, [visibleOptions, search]);

  const hasEffortSection = resolvedEffortOptions.length > 0;
  const hasModelSection = visibleOptions.length > 0 || modelsLoading;
  const favoriteOptions = filteredOptions.filter((option) => isFavorite(provider, option.value));
  const otherOptions = filteredOptions.filter((option) => !isFavorite(provider, option.value));

  const handleToggleFavorite = (event: React.MouseEvent, option: ProviderModelOption) => {
    event.preventDefault();
    event.stopPropagation();
    toggleFavorite(provider, option);
  };

  const renderModelOption = (option: ProviderModelOption) => {
    const optionFree = isFreeModel(option);
    const isSelected = option.value === model;
    const favorited = isFavorite(provider, option.value);
    const contextText = formatContextWindow(option.context);
    const modelDescription = (() => {
      if (optionFree) {
        return contextText ? `${contextText} context` : undefined;
      }
      const parts = [option.description, contextText ? `${contextText} context` : null].filter((part): part is string => Boolean(part));
      return parts.length > 0 ? parts.join(' · ') : undefined;
    })();
    return (
      <ComposerMenuItem
        key={option.value}
        label={option.label || option.value}
        description={modelDescription}
        isSelected={isSelected}
        onSelect={() => {
          onSelectModel(option.value);
          setIsOpen(false);
        }}
        trailing={(
          <span className="flex items-center gap-1.5">
            <span
              onClick={(event) => handleToggleFavorite(event, option)}
              className="cursor-pointer rounded p-0.5 text-muted-foreground hover:text-foreground"
              aria-label={favorited ? 'Remove from favorites' : 'Add to favorites'}
              title={favorited ? 'Remove from favorites' : 'Add to favorites'}
            >
              <Star className={`h-3.5 w-3.5 ${favorited ? 'fill-amber-400 text-amber-400' : ''}`} />
            </span>
            {optionFree && <FreeBadge />}
            {isSelected && <Check className="h-3.5 w-3.5 text-foreground" />}
          </span>
        )}
      />
    );
  };

  if (!hasEffortSection && !hasModelSection) {
    return null;
  }

  const triggerLabel = hasModelSection ? modelLabel : effortLabel;
  const ariaLabel = t('composer.modelMenu', {
    defaultValue: 'Select model and reasoning effort',
  });

  return (
    <>
      <button
        ref={triggerRef}
        type="button"
        onClick={() => {
          updateAnchor();
          setIsOpen((current) => !current);
        }}
        className="flex h-8 max-w-36 shrink-0 items-center gap-1 rounded-lg border border-border/60 bg-muted/40 px-2 text-xs font-medium text-foreground transition-colors hover:bg-muted sm:max-w-56"
        aria-haspopup="menu"
        aria-expanded={isOpen}
        aria-label={ariaLabel}
        title={ariaLabel}
      >
        <span className="truncate">{triggerLabel}</span>
        {selectedFree && <FreeBadge className="shrink-0" />}
        {hasModelSection && hasEffortSection && effort !== DEFAULT_EFFORT_VALUE && (
          <span className="hidden shrink-0 capitalize text-muted-foreground sm:inline">· {effortLabel}</span>
        )}
      </button>

      {isOpen && anchor && createPortal(
        <ComposerMenuSurface anchor={anchor} menuRef={menuRef} ariaLabel={ariaLabel}>
          {hasEffortSection && (
            <>
              <ComposerMenuHeading>
                {t('composer.reasoning', { defaultValue: 'Reasoning' })}
              </ComposerMenuHeading>
              {resolvedEffortOptions.map((option) => (
                <ComposerMenuItem
                  key={option.value}
                  label={option.value === DEFAULT_EFFORT_VALUE ? defaultEffortLabel : option.value}
                  description={option.description}
                  isSelected={option.value === effort}
                  onSelect={() => {
                    onSelectEffort(option.value);
                    setIsOpen(false);
                  }}
                  className="capitalize"
                />
              ))}
            </>
          )}

          {hasModelSection && (
            <>
              {hasEffortSection && <ComposerMenuSeparator />}
              {favoriteOptions.length > 0 && (
                <>
                  <ComposerMenuHeading>
                    {t('composer.favorites', { defaultValue: 'Favorites' })}
                  </ComposerMenuHeading>
                  {favoriteOptions.map(renderModelOption)}
                </>
              )}
              <ComposerMenuItem
                role="menuitem"
                label={modelLabel}
                isSelected={false}
                onSelect={() => setIsModelSectionOpen((current) => !current)}
                trailing={
                  isModelSectionOpen
                    ? <ChevronDown className="h-3.5 w-3.5 text-muted-foreground" />
                    : <ChevronRight className="h-3.5 w-3.5 text-muted-foreground" />
                }
                className="text-muted-foreground"
              />

              {isModelSectionOpen && (
                <>
                  <div className="px-2.5 pb-1.5 pt-1">
                    <PillBar>
                      <Pill isActive={tierFilter === 'all'} onClick={() => setTierFilter('all')}>
                        {t('providerSelection.all', { defaultValue: 'All' })}
                      </Pill>
                      <Pill isActive={tierFilter === 'free'} onClick={() => setTierFilter('free')}>
                        {t('providerSelection.free', { defaultValue: 'Free' })}
                      </Pill>
                      <Pill isActive={tierFilter === 'paid'} onClick={() => setTierFilter('paid')}>
                        {t('providerSelection.paid', { defaultValue: 'Paid' })}
                      </Pill>
                    </PillBar>
                  </div>
                  <div className="px-2.5 pb-1.5">
                    <div className="flex h-8 items-center gap-1.5 rounded-lg border border-border/60 bg-muted/40 px-2 transition-colors focus-within:ring-1 focus-within:ring-ring">
                      <Search className="h-3.5 w-3.5 shrink-0 text-muted-foreground" aria-hidden="true" />
                      <input
                        type="text"
                        value={search}
                        onChange={(event) => setSearch(event.target.value)}
                        placeholder={t('providerSelection.searchModels', {
                          defaultValue: 'Search models...',
                        })}
                        aria-label={t('providerSelection.searchModels', {
                          defaultValue: 'Search models...',
                        })}
                        className="h-full w-full min-w-0 bg-transparent text-xs text-foreground outline-none placeholder:text-muted-foreground"
                      />
                    </div>
                  </div>
                  <ComposerMenuHeading>
                    {t('composer.model', { defaultValue: 'Model' })}
                  </ComposerMenuHeading>
                  {filteredOptions.length === 0 && (
                    <p className="px-2.5 py-1.5 text-sm text-muted-foreground">
                      {modelsLoading
                        ? t('composer.loadingModels', { defaultValue: 'Loading models…' })
                        : t('providerSelection.noModelsFound', { defaultValue: 'No models found.' })}
                    </p>
                  )}
                  {otherOptions.map(renderModelOption)}
                </>
              )}
            </>
          )}
        </ComposerMenuSurface>,
        document.body,
      )}
    </>
  );
}

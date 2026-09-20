import { useCallback, useState } from 'react';

import type { LLMProvider, ProviderModelOption } from '../../../types/app';

const FAVORITES_STORAGE_KEY = 'ddagent-favorite-models';

export type FavoriteModel = {
  provider: LLMProvider;
  value: string;
  label: string;
  description?: string;
  context?: number;
  tier?: 'free' | 'paid';
  isCustom?: boolean;
};

function getStorageKey(provider: LLMProvider, value: string): string {
  return `${provider}:${value}`;
}

export function isAntigravityModel(model: { value?: string; label?: string; description?: string } | null | undefined): boolean {
  if (!model) return false;
  const value = model.value?.toLowerCase() ?? '';
  const label = model.label?.toLowerCase() ?? '';
  const desc = model.description?.toLowerCase() ?? '';
  return value.includes('antigravity') || label.includes('antigravity') || desc.includes('antigravity');
}

export function getModelTier(model: ProviderModelOption): 'free' | 'paid' {
  if (isAntigravityModel(model)) return 'paid';
  if (model.tier === 'paid') return 'paid';
  if (model.tier === 'free') return 'free';
  if (model.description && /\bfree\b/i.test(model.description)) return 'free';
  return 'paid';
}

function loadFavorites(): Record<string, FavoriteModel> {
  if (typeof window === 'undefined') return {};
  try {
    const raw = localStorage.getItem(FAVORITES_STORAGE_KEY);
    if (!raw) return {};
    const parsed = JSON.parse(raw) as Record<string, FavoriteModel>;
    for (const key of Object.keys(parsed)) {
      const fav = parsed[key];
      if (fav && isAntigravityModel(fav)) {
        fav.tier = 'paid';
      }
    }
    return parsed;
  } catch {
    return {};
  }
}

function saveFavorites(favorites: Record<string, FavoriteModel>): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(FAVORITES_STORAGE_KEY, JSON.stringify(favorites));
  } catch {
    // Ignore storage errors.
  }
}

export function useFavoriteModels() {
  const [favorites, setFavorites] = useState<Record<string, FavoriteModel>>(loadFavorites);

  const isFavorite = useCallback(
    (provider: LLMProvider, value: string) => Boolean(favorites[getStorageKey(provider, value)]),
    [favorites],
  );

  const refresh = useCallback(() => {
    setFavorites(loadFavorites());
  }, []);

  const toggleFavorite = useCallback(
    (provider: LLMProvider, model: ProviderModelOption) => {
      setFavorites((prev) => {
        const key = getStorageKey(provider, model.value);
        const next: Record<string, FavoriteModel> = { ...prev };
        if (next[key]) {
          delete next[key];
        } else {
          next[key] = {
            provider,
            value: model.value,
            label: model.label,
            description: model.description,
            context: model.context,
            tier: getModelTier(model),
            isCustom: model.isCustom,
          };
        }
        saveFavorites(next);
        return next;
      });
    },
    [],
  );

  return { favorites, isFavorite, toggleFavorite, refresh };
}

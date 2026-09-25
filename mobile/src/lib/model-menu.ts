// Pure helpers for the model/permission/account menus — no RN or expo deps.
// Mirrors web ComposerModelMenu.tsx, ComposerPermissionMenu.tsx,
// ComposerAccountMenu.tsx, useFavoriteModels.ts and subscriptionAvailability.ts.

export type ModelTier = 'free' | 'paid';
export type TierFilter = 'all' | 'free' | 'paid';

export interface EffortOption {
  value: string;
  label?: string;
  description?: string;
}

export interface ProviderModelOption {
  value: string;
  label: string;
  description?: string;
  context?: number;
  tier?: ModelTier;
  isCustom?: boolean;
  effort?: { default?: string; values: EffortOption[] };
}

export interface FavoriteModel {
  provider: string;
  value: string;
  label: string;
  description?: string;
  context?: number;
  tier?: ModelTier;
  isCustom?: boolean;
}

export interface ProviderAccount {
  id: string;
  provider: string;
  label: string;
  envOverrides?: Record<string, string>;
  isDefault: boolean;
  createdAt?: string;
}

export const FAVORITES_STORAGE_KEY = 'ddagent-favorite-models';
export const DEFAULT_EFFORT_VALUE = 'default';

export const favoriteStorageKey = (provider: string, value: string): string => `${provider}:${value}`;

export function isAntigravityModel(model: Pick<ProviderModelOption, 'value' | 'label' | 'description'>): boolean {
  return `${model.value} ${model.label} ${model.description ?? ''}`.toLowerCase().includes('antigravity');
}

/** Free vs paid classification (web getModelTier). */
export function getModelTier(model: Partial<ProviderModelOption>): ModelTier {
  if (isAntigravityModel(model as ProviderModelOption)) return 'paid';
  if (model.tier === 'paid') return 'paid';
  if (model.tier === 'free') return 'free';
  if (/\bfree\b/i.test(model.description ?? '')) return 'free';
  return 'paid';
}

export const isFreeModel = (model: Partial<ProviderModelOption>): boolean => getModelTier(model) === 'free';

/** 1_000_000 → "1M", 200_000 → "200k"; null when unknown. */
export function formatContextWindow(context?: number | null): string | null {
  if (!context || !Number.isFinite(context) || context <= 0) return null;
  if (context >= 1_000_000) {
    const millions = Math.round((context / 1_000_000) * 10) / 10;
    return `${Number.isInteger(millions) ? millions : millions}M`;
  }
  if (context >= 1_000) return `${Math.round(context / 1000)}k`;
  return String(context);
}

/** Subtitle line under a model label (free → 'Nk context'; paid → 'desc · Nk context'). */
export function modelSubtitle(model: ProviderModelOption): string | undefined {
  const contextText = formatContextWindow(model.context);
  const contextLine = contextText ? `${contextText} context` : null;
  if (isFreeModel(model)) return contextLine ?? undefined;
  const parts = [model.description, contextLine].filter(Boolean) as string[];
  return parts.length > 0 ? parts.join(' · ') : undefined;
}

export function filterModelsByTier(models: ProviderModelOption[], tier: TierFilter): ProviderModelOption[] {
  if (tier === 'all') return models;
  return models.filter((m) => getModelTier(m) === tier);
}

// --- favorites ------------------------------------------------------------

export function loadFavoritesFrom(raw: string | null): Record<string, FavoriteModel> {
  if (!raw) return {};
  try {
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) return {};
    const map = parsed as Record<string, FavoriteModel>;
    for (const fav of Object.values(map)) {
      if (fav && isAntigravityModel(fav as ProviderModelOption)) fav.tier = 'paid';
    }
    return map;
  } catch {
    return {};
  }
}

export function toggleFavoriteIn(
  favorites: Record<string, FavoriteModel>,
  provider: string,
  model: ProviderModelOption,
): Record<string, FavoriteModel> {
  const key = favoriteStorageKey(provider, model.value);
  const next = { ...favorites };
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
  return next;
}

/** Merge favorites into the provider catalog so they render even when unlisted. */
export function mergeFavorites(
  models: ProviderModelOption[],
  favorites: Record<string, FavoriteModel>,
  provider: string,
): { favoritesList: ProviderModelOption[]; others: ProviderModelOption[] } {
  const byKey = new Map<string, ProviderModelOption>();
  for (const model of models) byKey.set(favoriteStorageKey(provider, model.value), model);
  const favoritesList: ProviderModelOption[] = [];
  for (const [key, fav] of Object.entries(favorites)) {
    if (fav.provider !== provider) continue;
    const existing = byKey.get(key);
    favoritesList.push(
      existing ?? {
        value: fav.value,
        label: fav.label,
        description: fav.description,
        context: fav.context,
        tier: fav.tier,
        isCustom: fav.isCustom,
      },
    );
  }
  const favKeys = new Set(favoritesList.map((f) => f.value));
  const others = models.filter((m) => !favKeys.has(m.value));
  return { favoritesList, others };
}

/** Effort options with the synthetic 'default' first (web resolvedEffortOptions). */
export function resolveEffortOptions(effort?: { values: EffortOption[] } | null): EffortOption[] {
  const values = effort?.values ?? [];
  if (values.length === 0) return [];
  return [{ value: DEFAULT_EFFORT_VALUE }, ...values];
}

// --- subscription availability -------------------------------------------

export interface UsageWindow {
  status: string;
  percent: number;
  resetsAt: string | null;
}
export interface SubscriptionInfo {
  plan: string;
  windows?: Record<string, UsageWindow>;
  error?: string;
}
export type UsageResponse = Record<string, SubscriptionInfo | undefined>;

export const PROVIDER_SECTIONS: Record<string, string[]> = {
  claude: [],
  cursor: [],
  codex: [],
  opencode: ['opencode', 'commandcode', 'gemini'],
  devin: ['devin'],
};

export function usageFromQuotaSnapshot(snapshot: {
  accounts: { provider: string; plan: string; status: string; syncError?: string | null; windows: { label: string; status: string; percent: number; resetsAt: string | null }[] }[];
} | null | undefined): UsageResponse | null {
  if (!snapshot) return null;
  return Object.fromEntries(
    snapshot.accounts.map((account) => [
      account.provider,
      {
        plan: account.plan,
        error: account.status === 'active' ? undefined : account.syncError ?? 'no subscription',
        windows: Object.fromEntries(
          account.windows.map((w) => [w.label, { status: w.status, percent: w.percent, resetsAt: w.resetsAt }]),
        ),
      },
    ]),
  );
}

export function sectionForModel(model?: string | null): string | null {
  if (!model) return null;
  const m = model.toLowerCase();
  if (m.startsWith('google/') || m.includes('antigravity')) return 'gemini';
  if (m.startsWith('commandcode/')) return 'commandcode';
  if (m.startsWith('opencode/') || m.startsWith('opencode-go/')) return 'opencode';
  if (m.startsWith('nvidia/')) return 'byok';
  return null;
}

export const isActiveSection = (usage: UsageResponse | null, section: string): boolean => {
  if (section === 'byok') return true;
  const subscription = usage?.[section];
  return Boolean(subscription && !subscription.error);
};

export function isModelAvailableIn(
  usage: UsageResponse | null,
  provider: string,
  model?: string | null,
  tier?: ModelTier | null,
): boolean {
  return !usage || tier === 'free' || isActiveSection(usage, sectionForModel(model) ?? provider);
}

export function isProviderAvailableIn(usage: UsageResponse | null, provider: string): boolean {
  if (!usage) return true;
  const sections = PROVIDER_SECTIONS[provider];
  if (!sections || sections.length === 0) return true;
  return sections.some((section) => isActiveSection(usage, section));
}

// --- permission modes -----------------------------------------------------

export interface PermissionModeAppearance {
  iconKey: 'hand' | 'bot' | 'smile' | 'alert' | 'clipboard' | 'shield';
  tintLight: string;
  tintDark: string;
  bgLight: string;
  bgDark: string;
}

export const PERMISSION_MODE_APPEARANCE: Record<string, PermissionModeAppearance> = {
  default: { iconKey: 'hand', tintLight: '#64748b', tintDark: '#cbd5e1', bgLight: '#f1f5f9', bgDark: '#1e293b' },
  auto: { iconKey: 'bot', tintLight: '#1d4ed8', tintDark: '#93c5fd', bgLight: '#eff6ff', bgDark: '#1e3a8a33' },
  acceptEdits: { iconKey: 'smile', tintLight: '#15803d', tintDark: '#86efac', bgLight: '#f0fdf4', bgDark: '#14532d33' },
  bypassPermissions: { iconKey: 'alert', tintLight: '#c2410c', tintDark: '#fdba74', bgLight: '#fff7ed', bgDark: '#7c2d1233' },
  plan: { iconKey: 'clipboard', tintLight: '#2563eb', tintDark: '#93c5fd', bgLight: '#eff6ff', bgDark: '#1e3a8a33' },
};

export const UNKNOWN_PERMISSION_MODE: PermissionModeAppearance = {
  iconKey: 'shield',
  tintLight: '#64748b',
  tintDark: '#cbd5e1',
  bgLight: '#f1f5f9',
  bgDark: '#1e293b',
};

export const getPermissionAppearance = (mode: string): PermissionModeAppearance =>
  PERMISSION_MODE_APPEARANCE[mode] ?? UNKNOWN_PERMISSION_MODE;

/** Fallback effort value lists per provider (web providerEffort.ts). */
export const PROVIDER_EFFORT_VALUES: Record<string, string[]> = {
  claude: ['low', 'medium', 'high', 'xhigh', 'max'],
  codex: ['low', 'medium', 'high', 'xhigh', 'max', 'ultra'],
  opencode: ['none', 'low', 'medium', 'high', 'xhigh', 'max'],
  devin: ['low', 'medium', 'high', 'xhigh', 'max'],
};

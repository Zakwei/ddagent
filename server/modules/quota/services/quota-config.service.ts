import type {
  QuotaAccountConfig,
  QuotaConfig,
  QuotaRoutingMode,
} from '@/shared/types.js';

/** app_config key holding the serialized quota preferences. */
export const QUOTA_CONFIG_KEY = 'quota.config';

/** Default thresholds: watch at 75%, danger at 90%, routing manual. */
export const DEFAULT_QUOTA_CONFIG: QuotaConfig = {
  routingMode: 'manual',
  alertsEnabled: true,
  watchThreshold: 75,
  dangerThreshold: 90,
  accounts: [],
};

const ROUTING_MODES: QuotaRoutingMode[] = ['manual', 'ask', 'auto-low-risk'];

/** Config store surface; satisfied by `appConfigDb` in production. */
type ConfigStore = {
  get(key: string): string | null;
  set(key: string, value: string): void;
};

export type QuotaConfigDependencies = {
  store: ConfigStore;
};

function clampPercent(value: unknown, fallback: number): number {
  if (typeof value !== 'number' || !Number.isFinite(value)) {
    return fallback;
  }
  return Math.min(100, Math.max(0, value));
}

/** Parses an account override, dropping entries without a usable account id. */
function parseAccountConfig(
  value: unknown,
  fallback: { watchThreshold: number; dangerThreshold: number },
): QuotaAccountConfig | null {
  if (typeof value !== 'object' || value === null) {
    return null;
  }

  const raw = value as Record<string, unknown>;
  const accountId = typeof raw.accountId === 'string' ? raw.accountId.trim() : '';
  if (!accountId) {
    return null;
  }

  return {
    accountId,
    watchThreshold: clampPercent(raw.watchThreshold, fallback.watchThreshold),
    dangerThreshold: clampPercent(raw.dangerThreshold, fallback.dangerThreshold),
    routingEnabled: raw.routingEnabled !== false,
  };
}

/**
 * Parses a stored quota config, falling back to defaults for any missing or
 * malformed field so a partially-written row can never break the API.
 */
export function parseQuotaConfig(raw: string | null): QuotaConfig {
  if (!raw) {
    return { ...DEFAULT_QUOTA_CONFIG, accounts: [] };
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(raw);
  } catch {
    return { ...DEFAULT_QUOTA_CONFIG, accounts: [] };
  }

  if (typeof parsed !== 'object' || parsed === null) {
    return { ...DEFAULT_QUOTA_CONFIG, accounts: [] };
  }

  const source = parsed as Record<string, unknown>;
  const config: QuotaConfig = {
    routingMode: ROUTING_MODES.includes(source.routingMode as QuotaRoutingMode)
      ? (source.routingMode as QuotaRoutingMode)
      : DEFAULT_QUOTA_CONFIG.routingMode,
    alertsEnabled: source.alertsEnabled !== false,
    watchThreshold: clampPercent(source.watchThreshold, DEFAULT_QUOTA_CONFIG.watchThreshold),
    dangerThreshold: clampPercent(source.dangerThreshold, DEFAULT_QUOTA_CONFIG.dangerThreshold),
    accounts: [],
  };

  if (Array.isArray(source.accounts)) {
    const seen = new Set<string>();
    for (const entry of source.accounts) {
      const account = parseAccountConfig(entry, config);
      if (account && !seen.has(account.accountId)) {
        seen.add(account.accountId);
        config.accounts.push(account);
      }
    }
  }

  return config;
}

/** Merges a partial update into an existing config, keeping defaults intact. */
export function mergeQuotaConfig(current: QuotaConfig, patch: Partial<QuotaConfig>): QuotaConfig {
  return parseQuotaConfig(JSON.stringify({
    ...current,
    ...patch,
    accounts: patch.accounts ?? current.accounts,
  }));
}

/**
 * Reads and writes the persisted quota preferences.
 *
 * The store is injected so tests can use an in-memory map instead of SQLite;
 * every read is normalized through `parseQuotaConfig` so callers always get a
 * complete object.
 */
export function createQuotaConfigService(dependencies: QuotaConfigDependencies) {
  return {
    getConfig(): QuotaConfig {
      return parseQuotaConfig(dependencies.store.get(QUOTA_CONFIG_KEY));
    },

    saveConfig(patch: Partial<QuotaConfig>): QuotaConfig {
      const next = mergeQuotaConfig(this.getConfig(), patch);
      dependencies.store.set(QUOTA_CONFIG_KEY, JSON.stringify(next));
      return next;
    },
  };
}

export type QuotaConfigService = ReturnType<typeof createQuotaConfigService>;

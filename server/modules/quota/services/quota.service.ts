import type {
  KanbanCard,
  QuotaAccount,
  QuotaConfig,
  QuotaDataQuality,
  QuotaHistory,
  QuotaOverview,
  QuotaSnapshot,
  QuotaWindow,
  QuotaAssignedAgent,
  QuotaSnapshotsRepository,
} from '@/shared/types.js';
import type { QuotaProviders } from '@/modules/quota/services/quota-providers.service.js';
import type { QuotaConfigService } from '@/modules/quota/services/quota-config.service.js';

/** Cache lifetime for a full provider sweep. */
const CACHE_MS = 5 * 60 * 1000;

/** Percent a window must at least gain between samples to yield a burn rate. */
const MIN_BURN_DELTA_PERCENT = 0.5;

/** How long snapshot history is kept before it is pruned. */
const HISTORY_RETENTION_MS = 30 * 24 * 3_600_000;

/** Max history points returned per account. */
const HISTORY_POINT_LIMIT = 120;

/** Trust dependencies for the quota aggregator. */
export type QuotaServiceDependencies = {
  providers: QuotaProviders;
  /** Clock injection so pace tests can advance time deterministically. */
  now: () => number;
  /** Snapshot history store; omitted in tests that do not need history. */
  history?: QuotaSnapshotsRepository;
  /** Persisted thresholds/routing preferences. */
  config?: QuotaConfigService;
  /** Kanban cards, used to resolve which agents each account serves. */
  listKanbanCards?: () => KanbanCard[];
};

/** Last successful reading of one window, used to derive its burn rate. */
type WindowSample = {
  percent: number;
  at: number;
  resetsAt: string | null;
};

/**
 * Enriches one window with pace data derived from the previous sample.
 *
 * A window that has reset (its `resetsAt` moved) has no comparable history, so
 * its sample is replaced and no rate is reported. A projection that would land
 * after the window reset is dropped: the limit refills first, so that is not a
 * real risk.
 */
function withPace(
  window: QuotaWindow,
  previous: WindowSample | undefined,
  now: number,
): { window: QuotaWindow; sample: WindowSample } {
  const resetsAt = window.resetsAt;
  const resetMoved = previous !== undefined && previous.resetsAt !== resetsAt;
  const baseline = previous && !resetMoved ? previous : undefined;
  const sample: WindowSample = { percent: window.percent, at: now, resetsAt };

  if (!baseline) {
    return { window, sample };
  }

  const elapsedHours = (now - baseline.at) / 3_600_000;
  const delta = window.percent - baseline.percent;
  if (elapsedHours <= 0 || delta < MIN_BURN_DELTA_PERCENT) {
    return { window, sample };
  }

  const burnRatePerHour = delta / elapsedHours;
  const hoursLeft = (100 - window.percent) / burnRatePerHour;
  if (!Number.isFinite(hoursLeft) || hoursLeft < 0) {
    return { window: { ...window, burnRatePerHour }, sample };
  }

  const exhaustionMs = now + hoursLeft * 3_600_000;
  const resetMs = resetsAt ? Date.parse(resetsAt) : Number.NaN;
  const beforeReset = !Number.isFinite(resetMs) || exhaustionMs < resetMs;

  return {
    window: {
      ...window,
      burnRatePerHour,
      projectedExhaustionAt: beforeReset ? new Date(exhaustionMs).toISOString() : null,
      etaSeconds: beforeReset ? Math.round((exhaustionMs - now) / 1000) : null,
    },
    sample,
  };
}

/**
 * Resolves which agents are currently routed to one quota account.
 *
 * A kanban card names a provider and a model, not a quota account, so the
 * account is matched on the provider it belongs to. Cards without a session are
 * still counted: they occupy capacity on that account as soon as they run.
 */
function assignedAgentsFor(
  account: QuotaAccount,
  cards: KanbanCard[],
  providerToAccount: Map<string, string>,
): QuotaAssignedAgent[] {
  const accountId = providerToAccount.get(account.provider) ?? account.id;
  const perAgent = new Map<string, QuotaAssignedAgent>();

  for (const card of cards) {
    if (card.isArchived || !card.provider) {
      continue;
    }
    if ((providerToAccount.get(card.provider) ?? card.provider) !== accountId) {
      continue;
    }

    const agentId = card.provider;
    const existing = perAgent.get(agentId);
    if (existing) {
      existing.activeTasks += 1;
      continue;
    }
    perAgent.set(agentId, {
      agentId,
      role: `${card.provider.charAt(0).toUpperCase()}${card.provider.slice(1)} agent`,
      activeTasks: 1,
    });
  }

  return Array.from(perAgent.values());
}

/**
 * Aggregates provider quota readings into one snapshot.
 *
 * The service owns the 5-minute cache and the per-window sample history that
 * pace projection needs. Samples advance only on a genuinely new provider read,
 * so a cached response never decays the burn rate it already reported.
 */
export function createQuotaService(dependencies: QuotaServiceDependencies) {
  let cache: { at: number; accounts: QuotaAccount[] } | null = null;
  const samples = new Map<string, WindowSample>();

  /** Cache key for one window of one account. */
  const sampleKey = (accountId: string, label: string) => `${accountId}:${label}`;

  /** Applies pace enrichment to a fresh provider sweep and records samples. */
  function enrich(accounts: QuotaAccount[], now: number): QuotaAccount[] {
    return accounts.map((entry) => ({
      ...entry,
      windows: entry.windows.map((window) => {
        const key = sampleKey(entry.id, window.label);
        const { window: enriched, sample } = withPace(window, samples.get(key), now);
        samples.set(key, sample);
        return enriched;
      }),
    }));
  }

  /**
   * Appends a fresh sweep to snapshot history and prunes old rows.
   *
   * Errored accounts are skipped: their empty windows would otherwise look like
   * a drop to zero on the sparkline.
   */
  function recordHistory(accounts: QuotaAccount[], now: number): void {
    const history = dependencies.history;
    if (!history) {
      return;
    }

    const capturedAt = new Date(now).toISOString();
    const entries = accounts.flatMap((entry) =>
      entry.status === 'error'
        ? []
        : entry.windows.map((window) => ({
            accountId: entry.id,
            provider: entry.provider,
            windowLabel: window.label,
            windowKind: window.kind,
            percent: window.percent,
            resetsAt: window.resetsAt,
            capturedAt,
          })),
    );

    history.record(entries);
    history.pruneBefore(new Date(now - HISTORY_RETENTION_MS).toISOString());
  }

  /** Rolls individual accounts up into the four top-row KPI values. */
  function buildOverview(accounts: QuotaAccount[], config: QuotaConfig, now: number): QuotaOverview {
    const windows = accounts.flatMap((entry) => entry.windows);
    const resetTimes = windows
      .map((window) => (window.resetsAt ? Date.parse(window.resetsAt) : Number.NaN))
      .filter((value) => Number.isFinite(value) && value > now);

    return {
      accountsAtRisk: accounts.filter((entry) =>
        entry.windows.some((window) => window.percent >= config.watchThreshold),
      ).length,
      accountsErrored: accounts.filter((entry) => entry.status === 'error').length,
      windowsAtRisk: windows.filter((window) => window.projectedExhaustionAt !== null).length,
      nextResetAt: resetTimes.length > 0 ? new Date(Math.min(...resetTimes)).toISOString() : null,
    };
  }

  function currentConfig(): QuotaConfig {
    return dependencies.config?.getConfig() ?? {
      routingMode: 'manual',
      alertsEnabled: true,
      watchThreshold: 75,
      dangerThreshold: 90,
      accounts: [],
    };
  }

  return {
    /**
     * Returns the current quota snapshot.
     *
     * Serves the cached sweep when it is still fresh, otherwise reads every
     * provider. `force` bypasses the cache for an explicit user refresh. The
     * `quality` field reports whether this response is live or cached.
     */
    async getSnapshot(force = false): Promise<QuotaSnapshot> {
      const now = dependencies.now();
      const isFresh = cache !== null && now - cache.at <= CACHE_MS;
      const quality: QuotaDataQuality = isFresh && !force ? 'cached' : 'live';

      if (!isFresh || force) {
        const loaded = await dependencies.providers.loadAll();
        const enriched = enrich(loaded, now);
        cache = { at: now, accounts: enriched };
        recordHistory(enriched, now);
      }

      const config = currentConfig();
      const cards = dependencies.listKanbanCards?.() ?? [];
      const providerToAccount = new Map<string, string>();
      for (const entry of cache!.accounts) {
        providerToAccount.set(entry.provider, entry.id);
      }

      const accounts: QuotaAccount[] = cache!.accounts.map((entry) => ({
        ...entry,
        quality: entry.status === 'error' ? 'error' : entry.status === 'inactive' ? 'unknown' : quality,
        assignedAgents: assignedAgentsFor(entry, cards, providerToAccount),
      }));

      return {
        overview: buildOverview(accounts, config, now),
        accounts,
        generatedAt: new Date(now).toISOString(),
      };
    },

    /**
     * Returns persisted alert/routing preferences.
     *
     * Exposed through the same service so the routes never reach into the
     * config store directly.
     */
    getConfig(): QuotaConfig {
      return currentConfig();
    },

    /** Merges a partial preference update and persists the result. */
    saveConfig(patch: Partial<QuotaConfig>): QuotaConfig {
      if (!dependencies.config) {
        return currentConfig();
      }
      return dependencies.config.saveConfig(patch);
    },

    /**
     * Returns the recorded history of one account, oldest first.
     *
     * Reads straight from the store rather than the in-memory cache so the
     * sparkline shows readings from previous server runs too.
     */
    getHistory(accountId: string, limit = HISTORY_POINT_LIMIT): QuotaHistory {
      const bounded = Math.min(Math.max(1, limit), 1000);
      return {
        accountId,
        points: dependencies.history?.listByAccount(accountId, bounded) ?? [],
      };
    },
  };
}

export type QuotaService = ReturnType<typeof createQuotaService>;

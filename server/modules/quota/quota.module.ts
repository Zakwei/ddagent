import { appConfigDb, kanbanCardsDb, providerAccountsDb, quotaSnapshotsDb } from '@/modules/database/index.js';
import type { KanbanCard } from '@/shared/types.js';
import { createAgentFleetService } from '@/modules/quota/services/agents.service.js';
import { createInsightSource } from '@/modules/quota/services/insights-source.service.js';
import { createQuotaConfigService } from '@/modules/quota/services/quota-config.service.js';
import { createQuotaProviders } from '@/modules/quota/services/quota-providers.service.js';
import { createQuotaService } from '@/modules/quota/services/quota.service.js';
import { createUsageService } from '@/modules/quota/services/usage.service.js';
import { createQuotaRouter } from '@/modules/quota/quota.routes.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';

/** External token analytics store shared by the Usage and Agents screens. */
const insightSource = createInsightSource();

/**
 * Reads every non-archived kanban card across projects.
 *
 * The quota/agent screens need a cross-project view, while the standard
 * repository list is per-project. The cross-project query lives in the Kanban
 * repository (via the database barrel) so this module does not reach into
 * another module's internals.
 */
function listAllKanbanCards(): KanbanCard[] {
  try {
    return kanbanCardsDb.listAll();
  } catch {
    // A missing board must not break quota polling.
    return [];
  }
}

/** Production quota aggregator: real filesystem credentials and live HTTP. */
export const quotaService = createQuotaService({
  providers: createQuotaProviders({}, { listProviderAccounts: () => providerAccountsDb.list() }),
  now: () => Date.now(),
  history: quotaSnapshotsDb,
  config: createQuotaConfigService({ store: appConfigDb }),
  listKanbanCards: listAllKanbanCards,
});

const usageService = createUsageService({ source: insightSource, now: () => Date.now() });

/**
 * Agent fleet reads the same registry the websocket layer uses for live runs,
 * so the table reflects what is actually executing without a second pipeline.
 */
const agentFleetService = createAgentFleetService({
  listRunningRuns: () => chatRunRegistry.listRunningRuns(),
  listKanbanCards: listAllKanbanCards,
  listSessions: () => insightSource.loadSessions(),
  now: () => Date.now(),
});

/**
 * Server-side quota sweep, same cadence as the client's poll.
 *
 * `getSnapshot` only reads providers when `/api/quota` is requested, so without
 * this timer nothing syncs — and no history is recorded — while no UI is open.
 * `force` lands a real sweep every tick instead of racing the cache's
 * freshness edge; per-adapter failures surface as `syncError`, anything else
 * is logged rather than crashing the process. `unref` keeps the interval from
 * pinning the event loop for tools that import this module.
 */
const SYNC_INTERVAL_MS = 5 * 60 * 1000;
const syncQuota = () => {
  void quotaService.getSnapshot(true).catch((error: unknown) => {
    console.error('[quota] background sync failed:', error);
  });
};
syncQuota();
setInterval(syncQuota, SYNC_INTERVAL_MS).unref();

/** Quota/Insights router mounted by the server entrypoint at `/api/quota`. */
export const quotaRoutes = createQuotaRouter({
  quota: quotaService,
  usage: usageService,
  agents: agentFleetService,
});

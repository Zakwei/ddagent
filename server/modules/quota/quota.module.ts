import { appConfigDb, kanbanCardsDb, quotaSnapshotsDb } from '@/modules/database/index.js';
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
  providers: createQuotaProviders(),
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

/** Quota/Insights router mounted by the server entrypoint at `/api/quota`. */
export const quotaRoutes = createQuotaRouter({
  quota: quotaService,
  usage: usageService,
  agents: agentFleetService,
});

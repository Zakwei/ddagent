import type { orchestratorMessagesDb } from '@/modules/database/index.js';
import type { OrchestratorCandidateMetrics, OrchestratorMetricsSnapshot } from '@/shared/types.js';

/**
 * Consumed by: orchestrator.module — the `metrics` handler behind
 * `GET /api/orchestrator/metrics` (orchestrator.routes) calls `snapshot()`.
 */
export type OrchestratorMetricsService = {
  /** Aggregates all delegation transcript rows into per-candidate telemetry. */
  snapshot(): OrchestratorMetricsSnapshot;
};

/** Delegation statuses that count as a settled run; queued/running rows don't. */
const TERMINAL_STATUSES = new Set(['done', 'failed', 'aborted']);

/**
 * Consumed by: orchestrator.module — builds the metrics service over the
 * `orchestrator_messages` repository. `messages` is a structural pick so tests
 * inject a stub without a database.
 */
export function createOrchestratorMetricsService(deps: {
  messages: Pick<typeof orchestratorMessagesDb, 'listDelegations'>;
}): OrchestratorMetricsService {
  return {
    snapshot() {
      type Accumulator = OrchestratorCandidateMetrics & {
        durationSum: number;
        durationCount: number;
        lastFailedId: number;
      };
      const groups = new Map<string, Accumulator>();

      for (const row of deps.messages.listDelegations()) {
        const payload = row.payload;
        const provider = typeof payload.provider === 'string' ? payload.provider : '';
        const model = typeof payload.model === 'string' ? payload.model : '';
        // Rows predating `candidateId` aggregate under `provider/model`; a row
        // carrying none of the three has no identity to aggregate under.
        if (payload.candidateId == null && !provider && !model) continue;
        const candidateId = String(payload.candidateId ?? `${provider}/${model}`);

        let acc = groups.get(candidateId);
        if (!acc) {
          acc = {
            candidateId,
            provider,
            model,
            runs: 0,
            done: 0,
            failed: 0,
            aborted: 0,
            successRate: null,
            avgDurationMs: null,
            totalDurationMs: 0,
            lastUsedAt: null,
            lastError: null,
            errorClasses: {},
            durationSum: 0,
            durationCount: 0,
            lastFailedId: -1,
          };
          groups.set(candidateId, acc);
        }
        if (!acc.provider && provider) acc.provider = provider;
        if (!acc.model && model) acc.model = model;

        const status = typeof payload.status === 'string' ? payload.status : '';
        if (TERMINAL_STATUSES.has(status)) {
          acc.runs += 1;
          if (status === 'done') acc.done += 1;
          else if (status === 'failed') acc.failed += 1;
          else acc.aborted += 1;
        }
        if (status === 'failed') {
          if (typeof payload.errorClass === 'string' && payload.errorClass) {
            acc.errorClasses[payload.errorClass] = (acc.errorClasses[payload.errorClass] ?? 0) + 1;
          }
          // Rows arrive id-DESC; comparing ids keeps `lastError` correct even
          // if an injected repo returns them in another order.
          if (row.id > acc.lastFailedId) {
            acc.lastFailedId = row.id;
            acc.lastError = typeof payload.error === 'string' && payload.error ? payload.error : null;
          }
        }
        if (typeof payload.durationMs === 'number' && Number.isFinite(payload.durationMs)) {
          acc.durationSum += payload.durationMs;
          acc.durationCount += 1;
        }
        const usedAt = typeof payload.finishedAt === 'string' ? payload.finishedAt : row.createdAt;
        if (acc.lastUsedAt === null || usedAt > acc.lastUsedAt) acc.lastUsedAt = usedAt;
      }

      const candidates = [...groups.values()]
        .map((acc): OrchestratorCandidateMetrics => {
          const decided = acc.done + acc.failed;
          return {
            candidateId: acc.candidateId,
            provider: acc.provider,
            model: acc.model,
            runs: acc.runs,
            done: acc.done,
            failed: acc.failed,
            aborted: acc.aborted,
            successRate: decided > 0 ? acc.done / decided : null,
            avgDurationMs: acc.durationCount > 0 ? acc.durationSum / acc.durationCount : null,
            totalDurationMs: acc.durationSum,
            lastUsedAt: acc.lastUsedAt,
            lastError: acc.lastError,
            errorClasses: acc.errorClasses,
          };
        })
        .sort((a, b) => b.runs - a.runs || a.candidateId.localeCompare(b.candidateId));

      return { candidates, generatedAt: new Date().toISOString() };
    },
  };
}

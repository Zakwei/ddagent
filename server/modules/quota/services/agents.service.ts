import type {
  AgentFleetEntry,
  AgentFleetSnapshot,
  AgentFleetStatus,
  AgentFleetSummary,
  KanbanCard,
} from '@/shared/types.js';
import type { InsightSession } from '@/modules/quota/services/insights-source.service.js';

/** Minutes of history shown for agents that already finished. */
const FINISHED_LOOKBACK_HOURS = 24;

/** Max finished agent rows returned, newest first. */
const FINISHED_LIMIT = 25;

/** One live provider run as reported by the chat run registry. */
export type RunningAgentRun = {
  sessionId: string;
  provider: string;
  startedAt: number;
  lastSeq: number;
};

export type AgentFleetDependencies = {
  /** Live runs from the chat registry. */
  listRunningRuns: () => RunningAgentRun[];
  /** Kanban cards, used to name the task each running agent is working on. */
  listKanbanCards: () => KanbanCard[];
  /** Historical sessions for finished/failed rows. */
  listSessions: () => InsightSession[];
  now: () => number;
};

/** Derives an agent id/role from a kanban card's provider and title. */
function roleForProvider(provider: string | null): string {
  if (!provider) {
    return 'Agent';
  }
  return `${provider.charAt(0).toUpperCase()}${provider.slice(1)} agent`;
}

function summarize(entries: AgentFleetEntry[]): AgentFleetSummary {
  const summary: AgentFleetSummary = {
    running: 0,
    waiting: 0,
    failed: 0,
    finished: 0,
    queued: 0,
    totalTokens: 0,
    totalCostUsd: 0,
  };

  for (const entry of entries) {
    summary[entry.status] += 1;
    summary.totalTokens += entry.tokensTotal;
    summary.totalCostUsd += entry.costUsd;
  }
  return summary;
}

/** Maps a kanban status onto the fleet status shown in the table. */
function statusFromCard(status: KanbanCard['status']): AgentFleetStatus | null {
  switch (status) {
    case 'working':
      return 'running';
    case 'ready':
      return 'queued';
    case 'needs_decision':
      return 'waiting';
    case 'done':
      return 'finished';
    default:
      return null;
  }
}

/**
 * Builds the Agent Control Center payload from three cheap, already-available
 * sources: the live run registry, the kanban board, and session history.
 *
 * Nothing here is persisted or polled — the same read paths the rest of the app
 * uses are reused, so no new event pipeline is introduced. Because the sources
 * carry no retry counter, `retryCount` is reported as null rather than faked.
 */
export function createAgentFleetService(dependencies: AgentFleetDependencies) {
  /** Newest session history lookup keyed by provider-native session id. */
  function buildHistoryIndex(): Map<string, InsightSession> {
    const index = new Map<string, InsightSession>();
    for (const session of dependencies.listSessions()) {
      index.set(session.sourceId, session);
    }
    return index;
  }

  return {
    getSnapshot(): AgentFleetSnapshot {
      const now = dependencies.now();
      const running = dependencies.listRunningRuns();
      const cards = dependencies.listKanbanCards();
      const history = buildHistoryIndex();

      const entries: AgentFleetEntry[] = [];
      const claimedSessions = new Set<string>();

      // Live runs win over board state: the registry knows exactly what is
      // executing right now, and the card only supplies the human task label.
      for (const run of running) {
        const card =
          cards.find((candidate) => candidate.sessionId === run.sessionId) ??
          cards.find(
            (candidate) =>
              candidate.status === 'working' &&
              candidate.provider === run.provider &&
              !claimedSessions.has(candidate.sessionId ?? ''),
          );
        if (card?.sessionId) {
          claimedSessions.add(card.sessionId);
        }

        const session = history.get(run.sessionId);
        entries.push({
          agentId: card ? `agent-${run.provider}-${card.cardId.slice(0, 8)}` : `run-${run.sessionId.slice(0, 8)}`,
          role: card ? roleForProvider(card.provider) : roleForProvider(run.provider),
          status: 'running',
          taskId: card?.cardId ?? null,
          taskTitle: card?.title ?? session?.title ?? null,
          provider: run.provider,
          model: card?.model ?? session?.model ?? null,
          sessionId: run.sessionId,
          tokensTotal: session
            ? session.tokensInput +
              session.tokensOutput +
              session.tokensReasoning +
              session.tokensCacheRead +
              session.tokensCacheWrite
            : 0,
          costUsd: session?.costUsd ?? 0,
          startedAt: new Date(run.startedAt).toISOString(),
          elapsedSeconds: Math.max(0, Math.round((now - run.startedAt) / 1000)),
          result: null,
          retryCount: null,
        });
      }

      // Cards that own work but have no live run: queued and waiting agents.
      for (const card of cards) {
        if (card.sessionId && claimedSessions.has(card.sessionId)) {
          continue;
        }
        if (card.isArchived) {
          continue;
        }
        const status = statusFromCard(card.status);
        if (status === null || status === 'running') {
          continue;
        }

        entries.push({
          agentId: `card-${card.cardId.slice(0, 8)}`,
          role: roleForProvider(card.provider),
          status,
          taskId: card.cardId,
          taskTitle: card.title,
          provider: card.provider,
          model: card.model,
          sessionId: card.sessionId,
          tokensTotal: 0,
          costUsd: 0,
          startedAt: null,
          elapsedSeconds: 0,
          result: card.statusMessage,
          retryCount: null,
        });
      }

      // Recently finished sessions that are not already represented by a card
      // or a live run, so the table shows what agents actually did.
      const cutoff = now - FINISHED_LOOKBACK_HOURS * 3_600_000;
      const finished = dependencies
        .listSessions()
        .filter((session) => {
          const stamp = session.endedAt ?? session.startedAt;
          return (
            stamp !== null &&
            stamp * 1000 >= cutoff &&
            !claimedSessions.has(session.sourceId) &&
            !running.some((run) => run.sessionId === session.sourceId)
          );
        })
        .sort((a, b) => (b.endedAt ?? b.startedAt ?? 0) - (a.endedAt ?? a.startedAt ?? 0))
        .slice(0, FINISHED_LIMIT);

      for (const session of finished) {
        entries.push({
          agentId: `${session.source}-${session.sourceId.slice(0, 8)}`,
          role: session.agent || 'Agent',
          status: 'finished',
          taskId: null,
          taskTitle: session.title || null,
          provider: session.provider || session.source,
          model: session.model,
          sessionId: session.sourceId,
          tokensTotal:
            session.tokensInput +
            session.tokensOutput +
            session.tokensReasoning +
            session.tokensCacheRead +
            session.tokensCacheWrite,
          costUsd: session.costUsd,
          startedAt: session.startedAt !== null ? new Date(session.startedAt * 1000).toISOString() : null,
          elapsedSeconds:
            session.startedAt !== null && session.endedAt !== null
              ? Math.max(0, session.endedAt - session.startedAt)
              : 0,
          result: null,
          retryCount: null,
        });
      }

      return {
        entries,
        summary: summarize(entries),
        generatedAt: new Date(now).toISOString(),
      };
    },
  };
}

export type AgentFleetService = ReturnType<typeof createAgentFleetService>;

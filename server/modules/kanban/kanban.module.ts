import { randomUUID } from 'node:crypto';

import { activityEventsDb, appConfigDb, cardCommentsDb, kanbanCardsDb, projectsDb } from '@/modules/database/index.js';
import { createKanbanReportRouter, createKanbanRouter } from '@/modules/kanban/kanban.routes.js';
import { createKanbanCardService } from '@/modules/kanban/services/kanban-card.service.js';
import { createKanbanDispatcher } from '@/modules/kanban/services/kanban-dispatch.service.js';
import { providerRuntimeService, sessionsService } from '@/modules/providers/index.js';
import { chatRunRegistry, connectedClients, WS_OPEN_STATE } from '@/modules/websocket/index.js';
import { worktreeServices } from '@/modules/worktrees/index.js';
import type {
  KanbanBoardConfig,
  KanbanBroadcaster,
  KanbanCard,
  KanbanDispatcher,
  KanbanDispatcherDeps,
  KanbanRunHandle,
  LLMProvider,
} from '@/shared/types.js';

/** Builds the key that stores one project's board agent/model selection. */
function boardConfigKey(projectId: string): string {
  return `kanban_board_config:${projectId}`;
}

/** Reads a project's board config, defaulting to "no override". */
function readBoardConfig(projectId: string): KanbanBoardConfig {
  const raw = appConfigDb.get(boardConfigKey(projectId));
  if (!raw) {
    return { provider: null, model: null, effort: null };
  }

  try {
    const parsed = JSON.parse(raw) as Partial<KanbanBoardConfig>;
    return {
      provider: (parsed.provider as LLMProvider | null) ?? null,
      model: parsed.model ?? null,
      effort: parsed.effort ?? null,
    };
  } catch {
    return { provider: null, model: null, effort: null };
  }
}

/** Persists one project's board config. */
function writeBoardConfig(projectId: string, config: KanbanBoardConfig): void {
  appConfigDb.set(boardConfigKey(projectId), JSON.stringify(config));
}

/** Broadcast boundary delegating to the shared websocket server. */
const kanbanBroadcaster: KanbanBroadcaster = (payload) => {
  const message = JSON.stringify(payload);
  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      client.send(message);
    }
  });
};

/**
 * Repository facade for the dispatcher that broadcasts every write.
 *
 * The dispatcher calls the repository directly (no service in between), so
 * without this wrapper its stage transitions and runtime fields — sessionId
 * included — would never reach the board until a manual refetch.
 */
const broadcastingCards: KanbanDispatcherDeps['cards'] = {
  ...kanbanCardsDb,
  move: (cardId, status, position) => {
    const card = kanbanCardsDb.move(cardId, status, position);
    if (card) {
      kanbanBroadcaster({ type: 'kanban-card-upserted', projectId: card.projectId, card });
    }
    return card;
  },
  setRuntime: (cardId, patch) => {
    const card = kanbanCardsDb.setRuntime(cardId, patch);
    if (card) {
      kanbanBroadcaster({ type: 'kanban-card-upserted', projectId: card.projectId, card });
    }
    return card;
  },
};

/**
 * Minimal normalize view of a provider event consumed by the dispatcher.
 *
 * The dispatcher only distinguishes "turn ended" from everything else, so the
 * wiring adapter narrows the event stream here rather than teaching the
 * dispatcher about `NormalizedMessage`.
 */
function signalFromEvent(event: { kind?: string }): { kind: 'end_turn' } | null {
  if (event.kind === 'complete') {
    return { kind: 'end_turn' };
  }
  return null;
}

/**
 * Starts a tracked provider run for one card.
 *
 * This is the only place that combines the chat-run registry, provider runtime,
 * and a no-op connection. Events are still written to the registry so a
 * user who opens the linked session sees the live transcript; the dispatcher
 * additionally observes `complete` as its end-of-turn signal.
 */
async function startKanbanRun(input: {
  sessionId: string;
  provider: LLMProvider;
  projectPath: string;
  cwd: string;
  command: string;
  model?: string | null;
  effort?: string | null;
  onSignal: (signal: { kind: 'end_turn' }) => void;
}): Promise<KanbanRunHandle> {
  // The browser websocket is an optional observer: without a live client the
  // run still records events and completes, so a no-op connection is enough.
  const connection = {
    readyState: 0,
    send: () => {
      /* events reach clients through the run buffer and REST history */
    },
  };

  const run = chatRunRegistry.startRun({
    appSessionId: input.sessionId,
    provider: input.provider,
    providerSessionId: null,
    connection,
    userId: null,
  });

  if (!run) {
    return {
      abort: async () => undefined,
      completed: Promise.resolve(),
    };
  }

  // A user abort tears the run down and makes the card return to `backlog`;
  // the terminal `complete` frame it emits must not also be read as "the agent
  // ended its turn waiting for input", so abort latches this flag first.
  let aborted = false;

  const originalWriter = run.writer;
  const wrappedWriter = new Proxy(originalWriter, {
    get: (target, property, receiver) => {
      if (property === 'send') {
        return (data: unknown) => {
          // Feed the registry (and any subscribed browser) exactly as a chat
          // send would, then surface the end-of-turn signal to the dispatcher.
          (target.send as (value: unknown) => void).call(target, data);
          const signal = signalFromEvent((data ?? {}) as { kind?: string });
          if (signal && !aborted) {
            input.onSignal(signal);
          }
        };
      }
      return Reflect.get(target, property, receiver);
    },
  });

  const runtimeOptions = {
    sessionId: input.sessionId,
    cwd: input.cwd,
    projectPath: input.cwd,
    model: input.model ?? undefined,
    effort: input.effort ?? undefined,
    permissionMode: 'bypassPermissions',
  };

  const completed = (async () => {
    try {
      await providerRuntimeService.run(input.provider, input.command, runtimeOptions, wrappedWriter);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[Kanban] Provider run failed', {
        sessionId: input.sessionId,
        provider: input.provider,
        error: message,
      });
    } finally {
      chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });
    }
  })();

  return {
    abort: async () => {
      aborted = true;
      await providerRuntimeService.abort(input.provider, input.sessionId).catch(() => false);
      chatRunRegistry.completeRun(input.sessionId, { exitCode: 1, aborted: true });
    },
    completed,
  };
}

/**
 * Production Kanban dispatcher.
 *
 * Composes the dispatcher with real session, provider, worktree, and project
 * capabilities. Kept in the module entrypoint so services remain dependency-
 * injected and independently testable.
 */
const kanbanDispatcher: KanbanDispatcher = createKanbanDispatcher({
  cards: broadcastingCards,
  createSession: async (sessionInput) => {
    const session = sessionsService.createAppSession(
      sessionInput.provider,
      sessionInput.projectPath,
      sessionInput.initialMessage,
    );
    if (sessionInput.model || sessionInput.effort) {
      const { providerModelsService } = await import('@/modules/providers/index.js');
      if (sessionInput.model) {
        providerModelsService.setSessionModel(sessionInput.provider, session.sessionId, sessionInput.model);
      }
      if (sessionInput.effort) {
        providerModelsService.setSessionEffort(sessionInput.provider, session.sessionId, sessionInput.effort);
      }
    }
    return { sessionId: session.sessionId };
  },
  startRun: startKanbanRun,
  createWorktree: async (worktreeInput) => {
    const result = await worktreeServices.create(worktreeInput);
    return { worktreePath: result.worktreePath, branch: result.branch };
  },
  removeWorktree: async (worktreeInput) => {
    await worktreeServices.remove({
      projectPath: worktreeInput.projectPath,
      worktreePath: worktreeInput.worktreePath,
      deleteBranch: false,
    });
  },
  resolveProjectPath: (projectId) => projectsDb.getProjectPathById(projectId),
  resolveBoardConfig: readBoardConfig,
  // Resolved lazily at dispatch so a consumer that sets SERVER_PORT or
  // KANBAN_REPORT_BASE_URL after module evaluation still reports to the
  // right endpoint (import-time evaluation would freeze the value).
  reportBaseUrl: () => process.env.KANBAN_REPORT_BASE_URL ?? `http://127.0.0.1:${process.env.SERVER_PORT ?? 3001}`,
  maxConcurrentRuns: 5,
  isProviderAvailable: (provider) => providerRuntimeService.hasRuntime(provider),
});

/**
 * Production Kanban application-service surface.
 *
 * Move requests dispatch through the same service so the router never talks to
 * the dispatcher directly; `cleanup` is invoked on archive/delete.
 */
const kanbanCardService = createKanbanCardService({
  repository: kanbanCardsDb,
  comments: cardCommentsDb,
  broadcast: kanbanBroadcaster,
  // Board actions land in the Collab activity feed; the row id is minted here
  // so the service stays free of id generation.
  recordActivity: (event) => {
    const numericUserId = event.userId === null || event.userId === undefined
      ? null
      : Number(event.userId);
    activityEventsDb.record({
      id: randomUUID(),
      projectId: event.projectId,
      userId: Number.isFinite(numericUserId) ? numericUserId : null,
      kind: event.kind,
      entityId: event.entityId,
      summary: event.summary,
    });
  },
  projectExists: (projectId) => projectsDb.getProjectPathById(projectId) !== null,
  dispatch: async (card: KanbanCard) => {
    if (!kanbanDispatcher.canDispatch()) {
      return;
    }
    await kanbanDispatcher.dispatch(card);
  },
  abort: (cardId) => kanbanDispatcher.abort(cardId),
  cleanup: (card) => kanbanDispatcher.cleanup(card),
  readBoardConfig,
  writeBoardConfig,
});

/** Kanban router mounted by the server entrypoint at `/api/kanban`. */
export const kanbanRoutes = createKanbanRouter(kanbanCardService);

/**
 * Token-guarded agent report router mounted at `/api/kanban` before auth.
 *
 * It must be registered ahead of the authenticated router because the agent
 * callback carries no JWT; the per-card token is validated in the service.
 */
export const kanbanReportRoutes = createKanbanReportRouter(kanbanCardService);

/** Dispatcher exposed so lifecycle hooks (archive/delete) can clean worktrees. */
export { kanbanDispatcher };
export { kanbanCardService };

import assert from 'node:assert/strict';
import test from 'node:test';

import { createKanbanCardService } from '@/modules/kanban/services/kanban-card.service.js';
import { buildKickoffPrompt, createKanbanDispatcher } from '@/modules/kanban/services/kanban-dispatch.service.js';
import type {
  KanbanBoardConfig,
  KanbanCard,
  KanbanCardStatus,
  KanbanCardsRepository,
  KanbanCardStatus as CardStatus,
} from '@/shared/types.js';

function makeCard(patch: Partial<KanbanCard> = {}): KanbanCard {
  return {
    cardId: 'card-1',
    projectId: 'proj-1',
    title: 'Add login page',
    description: '',
    status: 'backlog',
    position: 0,
    sessionId: null,
    provider: 'claude',
    model: null,
    effort: null,
    worktreePath: null,
    branch: null,
    prUrl: null,
    statusMessage: null,
    isArchived: false,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    ...patch,
  };
}

function createMemoryRepository(initial: KanbanCard[] = []): KanbanCardsRepository {
  const cards = new Map(initial.map((card) => [card.cardId, card]));
  let reportToken: string | null = null;

  return {
    list: (projectId, options) =>
      [...cards.values()].filter(
        (card) =>
          card.projectId === projectId &&
          (options?.includeArchived === true || card.status !== 'archived'),
      ),
    listAll: () => [...cards.values()].filter((card) => card.status !== 'archived'),
    getById: (cardId) => cards.get(cardId) ?? null,
    create: (input) => {
      const card = makeCard({
        cardId: input.cardId,
        projectId: input.projectId,
        title: input.title,
        description: input.description ?? '',
        provider: input.provider ?? null,
      });
      cards.set(card.cardId, card);
      return card;
    },
    update: (cardId, input) => {
      const card = cards.get(cardId);
      if (!card) return null;
      const updated = { ...card, ...input } as KanbanCard;
      cards.set(cardId, updated);
      return updated;
    },
    move: (cardId, status: KanbanCardStatus, position: number) => {
      const card = cards.get(cardId);
      if (!card) return null;
      const updated = { ...card, status, position, isArchived: status === 'archived' };
      cards.set(cardId, updated);
      return updated;
    },
    setRuntime: (cardId, input) => {
      const card = cards.get(cardId);
      if (!card) return null;
      const updated = {
        ...card,
        sessionId: input.sessionId ?? card.sessionId,
        worktreePath: input.worktreePath ?? card.worktreePath,
        branch: input.branch ?? card.branch,
        prUrl: input.prUrl ?? card.prUrl,
        statusMessage: input.statusMessage === undefined ? card.statusMessage : input.statusMessage,
      };
      cards.set(cardId, updated);
      if (input.reportToken !== undefined) {
        reportToken = input.reportToken;
      }
      return updated;
    },
    getReportToken: () => reportToken,
    delete: (cardId) => cards.delete(cardId),
  };
}

test('moving a card to ready dispatches a run and a user cannot set an agent status', async () => {
  const dispatched: KanbanCard[] = [];
  const service = createKanbanCardService({
    repository: createMemoryRepository([makeCard()]),
    broadcast: () => undefined,
    projectExists: () => true,
    dispatch: (card) => {
      dispatched.push(card);
    },
    abort: async () => makeCard({ status: 'backlog' }),
    cleanup: async () => undefined,
    readBoardConfig: () => ({ provider: null, model: null, effort: null }),
    writeBoardConfig: () => undefined,
  });

  const result = await service.moveCard('card-1', 'ready');
  assert.equal(result.dispatch, true);
  assert.equal(result.card.status, 'ready');
  assert.equal(dispatched.length, 1);

  await assert.rejects(() => service.moveCard('card-1', 'done' as CardStatus), /agent/);
});

test('agent report is rejected without the per-card token', () => {
  const repository = createMemoryRepository([makeCard({ status: 'working' })]);
  const service = createKanbanCardService({
    repository,
    broadcast: () => undefined,
    projectExists: () => true,
    dispatch: () => undefined,
    abort: async () => makeCard({ status: 'backlog' }),
    cleanup: async () => undefined,
    readBoardConfig: () => ({ provider: null, model: null, effort: null }),
    writeBoardConfig: () => undefined,
  });

  assert.throws(
    () => service.reportCardByToken({ cardId: 'card-1', token: 'wrong', status: 'done' }),
    /Invalid kanban report token/,
  );
});

test('an agent turn that ends silently falls back to needs_decision', async () => {
  const signalRef: { handler: ((signal: { kind: 'end_turn' }) => void) | null } = { handler: null };
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async (input) => {
      signalRef.handler = input.onSignal;
      return { abort: async () => undefined, completed: Promise.resolve() };
    },
    createWorktree: async () => ({
      worktreePath: '/tmp/project/worktrees/card-1',
      branch: 'kanban/card-1-add-login-page',
    }),
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  await dispatcher.dispatch(makeCard({ status: 'ready' }));
  assert.equal(repository.getById('card-1')?.status, 'working');

  signalRef.handler?.({ kind: 'end_turn' });
  assert.equal(repository.getById('card-1')?.status, 'needs_decision');
});

test('saving a board config clears model and effort when the provider is cleared', () => {
  let stored: KanbanBoardConfig = { provider: null, model: null, effort: null };
  const service = createKanbanCardService({
    repository: createMemoryRepository(),
    broadcast: () => undefined,
    projectExists: () => true,
    dispatch: () => undefined,
    abort: async () => makeCard({ status: 'backlog' }),
    cleanup: async () => undefined,
    readBoardConfig: () => stored,
    writeBoardConfig: (_projectId, config) => {
      stored = config;
    },
  });

  const saved = service.saveBoardConfig('proj-1', {
    provider: 'claude',
    model: 'opus',
    effort: 'high',
  });
  assert.deepEqual(saved, { provider: 'claude', model: 'opus', effort: 'high' });

  const cleared = service.saveBoardConfig('proj-1', { provider: null, model: 'opus', effort: 'high' });
  assert.deepEqual(cleared, { provider: null, model: null, effort: null });
});

test('the kickoff prompt embeds the report token and endpoint', () => {
  const prompt = buildKickoffPrompt({
    card: makeCard(),
    token: 'secret-token',
    reportEndpoint: 'http://localhost:3001/api/kanban/report',
  });

  assert.match(prompt, /secret-token/);
  assert.match(prompt, /needs_decision/);
  assert.match(prompt, /Add login page/);
});

test('worktree creation failure moves card to backlog and fails fast without touching projectPath', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);
  let sessionCreated = false;

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => {
      sessionCreated = true;
      return { sessionId: 'session-1' };
    },
    startRun: async () => ({ abort: async () => undefined, completed: Promise.resolve() }),
    createWorktree: async () => {
      throw new Error('git worktree add failed');
    },
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  await assert.rejects(
    () => dispatcher.dispatch(makeCard({ status: 'ready' })),
    /Worktree creation failed: git worktree add failed/,
  );

  const updated = repository.getById('card-1');
  assert.equal(updated?.status, 'backlog');
  assert.match(updated?.statusMessage ?? '', /Worktree creation failed: git worktree add failed/);
  assert.equal(sessionCreated, false);
  assert.equal(dispatcher.canDispatch(), true);
});

test('queue unjamming dispatches next ready card when a run completes', async () => {
  const card1 = makeCard({ cardId: 'card-1', status: 'ready', position: 0 });
  const card2 = makeCard({ cardId: 'card-2', status: 'ready', position: 1 });
  const repository = createMemoryRepository([card1, card2]);
  let completeRun1!: () => void;
  const run1Completed = new Promise<void>((resolve) => {
    completeRun1 = resolve;
  });
  const dispatchedCardIds: string[] = [];

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async (input) => {
      dispatchedCardIds.push(input.cwd);
      if (dispatchedCardIds.length === 1) {
        return { abort: async () => undefined, completed: run1Completed };
      }
      return { abort: async () => undefined, completed: Promise.resolve() };
    },
    createWorktree: async (input) => ({
      worktreePath: `/tmp/project/worktrees/${input.branch}`,
      branch: input.branch,
    }),
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 1,
    isProviderAvailable: () => true,
  });

  await dispatcher.dispatch(card1);
  assert.equal(dispatchedCardIds.length, 1);
  assert.equal(dispatcher.canDispatch(), false);

  completeRun1();
  await new Promise((resolve) => setImmediate(resolve));

  assert.equal(dispatchedCardIds.length, 2);
  assert.equal(repository.getById('card-2')?.status, 'working');
});

import assert from 'node:assert/strict';
import test from 'node:test';

import { createKanbanCardService } from '@/modules/kanban/services/kanban-card.service.js';
import { buildKickoffPrompt, createKanbanDispatcher } from '@/modules/kanban/services/kanban-dispatch.service.js';
import type {
  KanbanBoardConfig,
  KanbanCard,
  KanbanCardComment,
  KanbanCardCommentsRepository,
  KanbanCardStatus,
  KanbanCardsRepository,
  KanbanCardStatus as CardStatus,
  KanbanDispatchSignal,
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
    assigneeUserId: null,
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
    shiftPositions: (projectId, status, fromPosition, excludeCardId) => {
      for (const card of [...cards.values()]) {
        if (
          card.projectId === projectId &&
          card.status === status &&
          card.position >= fromPosition &&
          card.cardId !== excludeCardId
        ) {
          cards.set(card.cardId, { ...card, position: card.position + 1 });
        }
      }
    },
  };
}

function createMemoryComments(): KanbanCardCommentsRepository {
  const comments = new Map<string, KanbanCardComment>();
  return {
    listByCard: (cardId) => [...comments.values()].filter((comment) => comment.cardId === cardId),
    create: (input) => {
      const comment: KanbanCardComment = {
        id: input.id,
        cardId: input.cardId,
        userId: input.userId,
        body: input.body,
        createdAt: new Date().toISOString(),
      };
      comments.set(comment.id, comment);
      return comment;
    },
    delete: (id) => comments.delete(id),
    deleteByCard: (cardId) => {
      let removed = 0;
      for (const comment of [...comments.values()]) {
        if (comment.cardId === cardId) {
          comments.delete(comment.id);
          removed += 1;
        }
      }
      return removed;
    },
  };
}

function makeService(
  repository: KanbanCardsRepository,
  overrides: Partial<Parameters<typeof createKanbanCardService>[0]> = {},
) {
  return createKanbanCardService({
    repository,
    comments: createMemoryComments(),
    broadcast: () => undefined,
    projectExists: () => true,
    dispatch: () => undefined,
    abort: async () => makeCard({ status: 'backlog' }),
    cleanup: async () => undefined,
    readBoardConfig: () => ({ provider: null, model: null, effort: null }),
    writeBoardConfig: () => undefined,
    ...overrides,
  });
}

test('moving a card to ready dispatches a run and a user cannot set an agent status', async () => {
  const dispatched: KanbanCard[] = [];
  const service = createKanbanCardService({
    repository: createMemoryRepository([makeCard()]),
    comments: createMemoryComments(),
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
    comments: createMemoryComments(),
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
      // A pending completion keeps the card in `working` — settling the run
      // without a report is itself a demotion signal, so only the signal may
      // move the card here.
      return { abort: async () => undefined, completed: new Promise(() => {}) };
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
    comments: createMemoryComments(),
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
      // Run 2 stays pending: an instantly-settled run ends without a report
      // and the dispatcher correctly demotes the card out of `working`.
      return { abort: async () => undefined, completed: new Promise(() => {}) };
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

test('a run_failed signal demotes a working card with the failure message', async () => {
  const signalRef: { handler: ((signal: KanbanDispatchSignal) => void) | null } = {
    handler: null,
  };
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async (input) => {
      signalRef.handler = input.onSignal;
      return { abort: async () => undefined, completed: new Promise(() => {}) };
    },
    createWorktree: async () => ({ worktreePath: '/tmp/wt-card-1', branch: 'kanban/card-1' }),
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  await dispatcher.dispatch(makeCard({ status: 'ready' }));
  assert.equal(repository.getById('card-1')?.status, 'working');

  signalRef.handler?.({ kind: 'run_failed', message: 'provider exited' });
  const card = repository.getById('card-1');
  assert.equal(card?.status, 'needs_decision');
  assert.match(card?.statusMessage ?? '', /provider exited/);
});

test('a card pulled back to backlog mid-dispatch is never resurrected to working', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);
  let releaseWorktree!: () => void;
  const worktreeGate = new Promise<void>((resolve) => {
    releaseWorktree = resolve;
  });
  const removed: string[] = [];
  let sessionCreated = false;

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => {
      sessionCreated = true;
      return { sessionId: 'session-1' };
    },
    startRun: async () => ({ abort: async () => undefined, completed: Promise.resolve() }),
    createWorktree: async (input) => {
      await worktreeGate;
      return { worktreePath: `/tmp/project/worktrees/${input.branch}`, branch: input.branch };
    },
    removeWorktree: async (input) => {
      removed.push(input.worktreePath);
    },
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  const dispatchPromise = dispatcher.dispatch(makeCard({ status: 'ready' }));
  repository.move('card-1', 'backlog', 0);
  releaseWorktree();
  await dispatchPromise;

  assert.equal(repository.getById('card-1')?.status, 'backlog');
  assert.equal(sessionCreated, false);
  assert.equal(removed.length, 1);
  assert.equal(dispatcher.canDispatch(), true);
});

test('a card pulled back after session creation discards worktree and session', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);
  let releaseSession!: () => void;
  const sessionGate = new Promise<void>((resolve) => {
    releaseSession = resolve;
  });
  let markSessionEntered!: () => void;
  const sessionEntered = new Promise<void>((resolve) => {
    markSessionEntered = resolve;
  });
  const deletedSessions: string[] = [];
  const removed: string[] = [];

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => {
      markSessionEntered();
      await sessionGate;
      return { sessionId: 'session-1' };
    },
    startRun: async () => ({ abort: async () => undefined, completed: Promise.resolve() }),
    createWorktree: async (input) => ({
      worktreePath: `/tmp/project/worktrees/${input.branch}`,
      branch: input.branch,
    }),
    removeWorktree: async (input) => {
      removed.push(input.worktreePath);
    },
    deleteSession: async (sessionId) => {
      deletedSessions.push(sessionId);
    },
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  const dispatchPromise = dispatcher.dispatch(makeCard({ status: 'ready' }));
  // Wait until dispatch is parked inside createSession, then pull the card —
  // a synchronous move would be caught at the earlier worktree check instead.
  await sessionEntered;
  repository.move('card-1', 'backlog', 0);
  releaseSession();
  await dispatchPromise;

  assert.equal(repository.getById('card-1')?.status, 'backlog');
  assert.deepEqual(deletedSessions, ['session-1']);
  assert.equal(removed.length, 1);
});

test('a dispatch reuses an existing worktree instead of recreating the branch', async () => {
  const repository = createMemoryRepository([
    makeCard({ status: 'ready', worktreePath: '/tmp', branch: 'kanban/card-1-add-login-page' }),
  ]);
  let createCalls = 0;

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async () => ({ abort: async () => undefined, completed: new Promise(() => {}) }),
    createWorktree: async (input) => {
      createCalls += 1;
      return { worktreePath: `/tmp/project/worktrees/${input.branch}`, branch: input.branch };
    },
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  await dispatcher.dispatch(
    makeCard({ status: 'ready', worktreePath: '/tmp', branch: 'kanban/card-1-add-login-page' }),
  );

  assert.equal(createCalls, 0);
  assert.equal(repository.getById('card-1')?.status, 'working');
  assert.equal(repository.getById('card-1')?.worktreePath, '/tmp');
});

test('an unavailable provider demotes the card to backlog with a status message', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'ready' })]);

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async () => ({ abort: async () => undefined, completed: Promise.resolve() }),
    createWorktree: async () => ({ worktreePath: '/tmp/wt', branch: 'b' }),
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => false,
  });

  await assert.rejects(() => dispatcher.dispatch(makeCard({ status: 'ready' })), /not available/);
  const card = repository.getById('card-1');
  assert.equal(card?.status, 'backlog');
  assert.match(card?.statusMessage ?? '', /Dispatch failed/);
  assert.equal(dispatcher.canDispatch(), true);
});

test('aborting a done card is a no-op that keeps its state', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'done' })]);

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async () => ({ abort: async () => undefined, completed: Promise.resolve() }),
    createWorktree: async () => ({ worktreePath: '/tmp/wt', branch: 'b' }),
    removeWorktree: async () => undefined,
    resolveProjectPath: () => '/tmp/project',
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 5,
    isProviderAvailable: () => true,
  });

  const card = await dispatcher.abort('card-1');
  assert.equal(card.status, 'done');
  assert.equal(repository.getById('card-1')?.status, 'done');
});

test('a working card can only be archived, not moved through a plain move', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'working' })]);
  const cleanupCalls: { card: KanbanCard; options?: { deleteBranch?: boolean } }[] = [];
  const service = makeService(repository, {
    cleanup: async (card, options) => {
      cleanupCalls.push({ card, options });
    },
  });

  await assert.rejects(() => service.moveCard('card-1', 'backlog'), /abort the run or archive/);
  await assert.rejects(() => service.moveCard('card-1', 'ready'), /abort the run or archive/);
  assert.equal(repository.getById('card-1')?.status, 'working');

  const archived = await service.moveCard('card-1', 'archived');
  assert.equal(archived.card.status, 'archived');
  // Archive cleanup keeps the branch so a restored card can resume its work.
  assert.equal(cleanupCalls.length, 1);
  assert.equal(cleanupCalls[0].options?.deleteBranch, undefined);
});

test('dropping a card onto its own column is a no-op', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'backlog', position: 0 })]);
  let recorded = 0;
  const service = makeService(repository, {
    recordActivity: () => {
      recorded += 1;
    },
  });

  const result = await service.moveCard('card-1', 'backlog');
  assert.equal(result.dispatch, false);
  assert.equal(result.card.position, 0);
  assert.equal(recorded, 0);
});

test('an explicit position bumps the incumbents so slots stay unique', async () => {
  const repository = createMemoryRepository([
    makeCard({ cardId: 'card-a', status: 'backlog', position: 0 }),
    makeCard({ cardId: 'card-b', status: 'backlog', position: 1 }),
  ]);
  const service = makeService(repository);

  await service.moveCard('card-b', 'backlog', 0);
  assert.equal(repository.getById('card-b')?.position, 0);
  assert.equal(repository.getById('card-a')?.position, 1);
});

test('a negative patch position is clamped and still bumps incumbents', async () => {
  const repository = createMemoryRepository([
    makeCard({ cardId: 'card-a', status: 'backlog', position: 0 }),
    makeCard({ cardId: 'card-b', status: 'backlog', position: 1 }),
  ]);
  const service = makeService(repository);

  service.updateCard('card-b', { position: -5 });
  assert.equal(repository.getById('card-b')?.position, 0);
  assert.equal(repository.getById('card-a')?.position, 1);
});

test('unknown providers are rejected on cards and board config', () => {
  const service = makeService(createMemoryRepository([makeCard()]), {
    projectExists: () => true,
  });

  assert.throws(() => service.updateCard('card-1', { provider: 'bogus' as never }), /Unknown provider/);
  assert.throws(
    () => service.saveBoardConfig('proj-1', { provider: 'bogus' as never }),
    /Unknown provider/,
  );
});

test('an assignee must name an existing user', () => {
  const service = makeService(createMemoryRepository([makeCard()]), {
    userExists: (userId) => userId === 7,
  });

  assert.throws(() => service.updateCard('card-1', { assigneeUserId: 42 }), /was not found/);
  assert.equal(service.updateCard('card-1', { assigneeUserId: 7 }).assigneeUserId, 7);
  assert.equal(service.updateCard('card-1', { assigneeUserId: null }).assigneeUserId, null);
});

test('deleting a card clears its comments and removes the worktree with its branch', async () => {
  const repository = createMemoryRepository([makeCard({ status: 'done' })]);
  const comments = createMemoryComments();
  comments.create({ id: 'comment-1', cardId: 'card-1', userId: null, body: 'hello' });
  const cleanupCalls: { card: KanbanCard; options?: { deleteBranch?: boolean } }[] = [];
  const service = makeService(repository, {
    comments,
    cleanup: async (card, options) => {
      cleanupCalls.push({ card, options });
    },
  });

  service.deleteCard('card-1');
  await new Promise((resolve) => setImmediate(resolve));

  assert.equal(repository.getById('card-1'), null);
  assert.equal(comments.listByCard('card-1').length, 0);
  assert.equal(cleanupCalls.length, 1);
  assert.equal(cleanupCalls[0].options?.deleteBranch, true);
});

test('queue unjamming reaches ready cards in other projects', async () => {
  const card1 = makeCard({ cardId: 'card-1', projectId: 'proj-1', status: 'ready', position: 0 });
  const card2 = makeCard({ cardId: 'card-2', projectId: 'proj-2', status: 'ready', position: 0 });
  const repository = createMemoryRepository([card1, card2]);
  let completeRun1!: () => void;
  const run1Completed = new Promise<void>((resolve) => {
    completeRun1 = resolve;
  });
  const dispatchedCwds: string[] = [];

  const dispatcher = createKanbanDispatcher({
    cards: repository,
    createSession: async () => ({ sessionId: 'session-1' }),
    startRun: async (input) => {
      dispatchedCwds.push(input.cwd);
      return {
        abort: async () => undefined,
        // Run 2 stays pending so the cross-project card can be observed in
        // `working`; a settled-without-report run demotes immediately.
        completed: dispatchedCwds.length === 1 ? run1Completed : new Promise(() => {}),
      };
    },
    createWorktree: async (input) => ({
      worktreePath: `${input.projectPath}/worktrees/${input.branch}`,
      branch: input.branch,
    }),
    removeWorktree: async () => undefined,
    resolveProjectPath: (projectId) => `/tmp/${projectId}`,
    resolveBoardConfig: () => ({ provider: null, model: null, effort: null }),
    reportBaseUrl: 'http://localhost:3001',
    maxConcurrentRuns: 1,
    isProviderAvailable: () => true,
  });

  await dispatcher.dispatch(card1);
  assert.equal(dispatchedCwds.length, 1);

  completeRun1();
  await new Promise((resolve) => setImmediate(resolve));
  // The unjam dispatch is fire-and-forget: give its async chain a few ticks.
  for (let i = 0; i < 20 && dispatchedCwds.length < 2; i += 1) {
    await new Promise((resolve) => setImmediate(resolve));
  }

  assert.equal(dispatchedCwds.length, 2);
  assert.equal(repository.getById('card-2')?.status, 'working');
});

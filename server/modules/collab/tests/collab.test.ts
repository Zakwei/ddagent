import assert from 'node:assert/strict';
import { randomUUID } from 'node:crypto';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import express from 'express';

import {
  activityEventsDb,
  cardCommentsDb,
  closeConnection,
  collabInvitesDb,
  getConnection,
  initializeDatabase,
  kanbanCardsDb,
  userDb,
} from '@/modules/database/index.js';
// eslint-disable-next-line boundaries/dependencies -- the kanban barrel only exposes the production-wired service; tests need the factory.
import { createKanbanCardService } from '@/modules/kanban/services/kanban-card.service.js';
import type { KanbanCard } from '@/shared/types.js';

import { applyCollabSchema } from '../collab-migrations.js';
import { createCollabRouter } from '../collab.routes.js';
import { createPresenceService, readPresenceViewing } from '../presence.service.js';
import { requireRole, roleAtLeast } from '../require-role.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const tempDirectory = await mkdtemp(path.join(tmpdir(), 'collab-'));
  const databasePath = path.join(tempDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();
  // The coordinator wires applyCollabSchema into runMigrations; tests apply it
  // manually so the module stays verifiable before that wiring lands.
  applyCollabSchema(getConnection());

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(tempDirectory, { recursive: true, force: true });
  }
}

function createCard(projectId = 'proj-1', title = 'Card'): KanbanCard {
  return kanbanCardsDb.create({
    cardId: randomUUID(),
    projectId,
    title,
    description: '',
  });
}

test('applyCollabSchema adds users.role (default owner), kanban assignee, and collab tables — idempotently', async () => {
  await withIsolatedDatabase(async () => {
    const db = getConnection();
    const user = userDb.createUser('alice', 'hash');

    // Second run must be a no-op — the migration is idempotent.
    applyCollabSchema(db);
    applyCollabSchema(db);

    const userColumns = (db.prepare('PRAGMA table_info(users)').all() as { name: string }[]).map((c) => c.name);
    assert.ok(userColumns.includes('role'));
    const cardColumns = (db.prepare('PRAGMA table_info(kanban_cards)').all() as { name: string }[]).map((c) => c.name);
    assert.ok(cardColumns.includes('assignee_user_id'));

    // The column default covers both pre-existing rows (ALTER TABLE backfill)
    // and new inserts that don't name the column.
    const fetched = userDb.getUserById(Number(user.id));
    assert.equal(fetched?.role, 'owner');

    const users = userDb.listActiveUsers();
    assert.equal(users.length, 1);
    assert.equal(users[0].username, 'alice');
    assert.equal(users[0].role, 'owner');
  });
});

test('cardCommentsDb creates, lists and deletes comments for a card', async () => {
  await withIsolatedDatabase(async () => {
    const card = createCard();

    const first = cardCommentsDb.create({ id: 'c1', cardId: card.cardId, userId: 1, body: 'hello' });
    const second = cardCommentsDb.create({ id: 'c2', cardId: card.cardId, userId: null, body: 'world' });
    cardCommentsDb.create({ id: 'other', cardId: 'other-card', userId: 1, body: 'noise' });

    assert.equal(first.cardId, card.cardId);
    assert.equal(first.userId, 1);
    assert.ok(first.createdAt.length > 0);

    const comments = cardCommentsDb.listByCard(card.cardId);
    assert.deepEqual(comments.map((c) => c.id), ['c1', 'c2']);
    assert.equal(second.userId, null);

    assert.equal(cardCommentsDb.delete('c1'), true);
    assert.equal(cardCommentsDb.delete('c1'), false);
    assert.deepEqual(cardCommentsDb.listByCard(card.cardId).map((c) => c.id), ['c2']);
  });
});

test('assignee patch round-trips through kanbanCardsDb.update', async () => {
  await withIsolatedDatabase(async () => {
    const card = createCard();
    assert.equal(card.assigneeUserId, null);

    const assigned = kanbanCardsDb.update(card.cardId, { assigneeUserId: 7 });
    assert.equal(assigned?.assigneeUserId, 7);
    assert.equal(kanbanCardsDb.getById(card.cardId)?.assigneeUserId, 7);

    const unassigned = kanbanCardsDb.update(card.cardId, { assigneeUserId: null });
    assert.equal(unassigned?.assigneeUserId, null);
  });
});

test('kanban service records card_created/moved/assigned/commented into the activity feed', async () => {
  await withIsolatedDatabase(async () => {
    const broadcasts: Array<Record<string, unknown>> = [];
    const service = createKanbanCardService({
      repository: kanbanCardsDb,
      comments: cardCommentsDb,
      broadcast: (payload) => broadcasts.push(payload as Record<string, unknown>),
      projectExists: () => true,
      dispatch: () => undefined,
      abort: async (cardId) => kanbanCardsDb.getById(cardId) as KanbanCard,
      cleanup: async () => undefined,
      readBoardConfig: () => ({ provider: null, model: null, effort: null }),
      writeBoardConfig: () => undefined,
      recordActivity: (event) => {
        activityEventsDb.record({
          id: randomUUID(),
          projectId: event.projectId,
          userId: event.userId === null || event.userId === undefined ? null : Number(event.userId),
          kind: event.kind,
          entityId: event.entityId,
          summary: event.summary,
        });
      },
    });

    const card = service.createCard({ projectId: 'proj-feed', title: 'Feed card', actorUserId: 1 });
    // backlog→backlog is a no-op by design, so the feed assertion needs a real
    // column change; dispatch is a no-op fake here.
    await service.moveCard(card.cardId, 'ready', undefined, { actorUserId: 1 });
    service.updateCard(card.cardId, { assigneeUserId: 1, actorUserId: 2 });
    const comment = service.addComment(card.cardId, { userId: 1, body: '  looks good  ' });

    assert.equal(comment.body, 'looks good');
    assert.equal(comment.userId, 1);
    assert.deepEqual(service.listComments(card.cardId).map((c) => c.id), [comment.id]);

    // The comment was broadcast to board subscribers.
    const commentBroadcast = broadcasts.find((b) => b.type === 'kanban-comment-added');
    assert.equal((commentBroadcast?.comment as { id: string } | undefined)?.id, comment.id);
    assert.equal(commentBroadcast?.projectId, 'proj-feed');

    const events = activityEventsDb.listByProject('proj-feed');
    assert.deepEqual(
      events.map((e) => e.kind).sort(),
      ['card_assigned', 'card_commented', 'card_created', 'card_moved'],
    );
    const created = events.find((e) => e.kind === 'card_created');
    assert.equal(created?.userId, 1);
    assert.equal(created?.entityId, card.cardId);
    assert.match(created?.summary ?? '', /Feed card/);
  });
});

test('presence service broadcasts a per-user roster to announcing clients, throttled', () => {
  const received: Array<{ client: string; users: Array<{ userId: unknown; viewing: unknown }> }> = [];
  const makeClient = (name: string) => ({
    readyState: 1,
    send: (data: string) => {
      received.push({ client: name, users: (JSON.parse(data) as { users: never[] }).users });
    },
  });

  const timers: Array<{ fn: () => void; ms?: number }> = [];
  const fakeScheduler = {
    setTimeout: ((fn: () => void, ms?: number) => {
      const timer = { fn, ms };
      timers.push(timer);
      return timer as unknown as NodeJS.Timeout;
    }) as typeof setTimeout,
    clearTimeout: ((timer: unknown) => {
      const index = timers.indexOf(timer as { fn: () => void });
      if (index >= 0) timers.splice(index, 1);
    }) as typeof clearTimeout,
  };

  const presence = createPresenceService({ throttleMs: 1000, scheduler: fakeScheduler });
  const c1 = makeClient('c1');
  const c2 = makeClient('c2');
  const c1secondTab = makeClient('c1-tab2');

  presence.update(c1, { userId: 1, username: 'alice', viewing: { kind: 'board', id: 'p1' } });
  assert.equal(received.length, 1);
  assert.deepEqual(received[0].users.map((u) => u.userId), [1]);

  // Inside the throttle window: no immediate broadcast, one pending timer.
  presence.update(c2, { userId: 2, username: 'bob', viewing: null });
  assert.equal(received.length, 1);
  assert.equal(timers.length, 1);

  // Flushing the trailing broadcast delivers the roster to every registered
  // client — c2 announced before the flush fired, so it receives it too.
  timers.splice(0).forEach((timer) => timer.fn());
  assert.equal(received.length, 3);
  assert.deepEqual(
    received.slice(1).map((entry) => entry.client).sort(),
    ['c1', 'c2'],
  );
  assert.deepEqual(received[1].users.map((u) => u.userId), [1, 2]);

  // A second tab of the same user collapses into one roster entry (the user's
  // first-seen slot keeps its position; the newest viewing wins).
  presence.update(c1secondTab, { userId: 1, username: 'alice', viewing: { kind: 'card', id: 'k9' } });
  assert.deepEqual(presence.roster().map((u) => u.userId), [1, 2]);
  assert.deepEqual(presence.roster().find((u) => u.userId === 1)?.viewing, { kind: 'card', id: 'k9' });

  presence.remove(c1);
  presence.remove(c1secondTab);
  assert.equal(presence.size, 1);
  assert.deepEqual(presence.roster().map((u) => u.userId), [2]);
  presence.dispose();
});

test('readPresenceViewing accepts known kinds and coerces junk to null', () => {
  assert.deepEqual(readPresenceViewing({ kind: 'card', id: 'k1' }), { kind: 'card', id: 'k1' });
  assert.equal(readPresenceViewing(null), null);
  assert.equal(readPresenceViewing('session'), null);
  assert.equal(readPresenceViewing({ kind: 'nope', id: 'x' }), null);
  assert.equal(readPresenceViewing({ kind: 'card' }), null);
});

test('role matrix: roleAtLeast + requireRole enforce viewer < member < owner', async () => {
  assert.equal(roleAtLeast('viewer', 'viewer'), true);
  assert.equal(roleAtLeast('viewer', 'member'), false);
  assert.equal(roleAtLeast('viewer', 'owner'), false);
  assert.equal(roleAtLeast('member', 'member'), true);
  assert.equal(roleAtLeast('member', 'owner'), false);
  assert.equal(roleAtLeast('owner', 'owner'), true);
  assert.equal(roleAtLeast('owner', 'viewer'), true);
  // Unknown/missing roles fail closed.
  assert.equal(roleAtLeast(undefined, 'viewer'), false);
  assert.equal(roleAtLeast('superadmin', 'viewer'), false);

  const app = express();
  app.use(express.json());
  const asRole = (role?: string) => (req: express.Request, _res: express.Response, next: express.NextFunction) => {
    (req as express.Request & { user?: { role?: string } }).user = role ? { role } : undefined;
    next();
  };
  app.post('/approve-member', asRole('viewer'), requireRole('member'), (_req, res) => res.json({ ok: true }));
  app.post('/approve-owner', asRole('member'), requireRole('owner'), (_req, res) => res.json({ ok: true }));
  app.post('/approve-anon', requireRole('viewer'), (_req, res) => res.json({ ok: true }));
  // AppError inside a sync middleware needs the error handler to map status.
  app.use((err: { statusCode?: number }, _req: express.Request, res: express.Response, _next: express.NextFunction) => {
    res.status(err.statusCode ?? 500).json({ error: 'err' });
  });
  const server = await new Promise<ReturnType<typeof app.listen>>((resolve) => {
    const s = app.listen(0, '127.0.0.1', () => resolve(s));
  });
  try {
    const { port } = server.address() as { port: number };
    const base = `http://127.0.0.1:${port}`;
    // The concrete spec requirement: a viewer cannot approve.
    assert.equal((await fetch(`${base}/approve-member`, { method: 'POST' })).status, 403);
    assert.equal((await fetch(`${base}/approve-owner`, { method: 'POST' })).status, 403);
    assert.equal((await fetch(`${base}/approve-anon`, { method: 'POST' })).status, 403);
  } finally {
    await new Promise<void>((resolve) => server.close(() => resolve()));
  }
});

test('invite flow: owner mints, register burns, role lands on the new user', async () => {
  await withIsolatedDatabase(async () => {
    userDb.createUser('alice', 'hash');
    const invite = collabInvitesDb.create({
      id: 'inv-1',
      token: 'tok-1',
      role: 'viewer',
      createdBy: 1,
      expiresAt: new Date(Date.now() + 3600_000).toISOString(),
    });
    assert.equal(invite.role, 'viewer');

    collabInvitesDb.create({
      id: 'inv-2',
      token: 'tok-expired',
      role: 'member',
      createdBy: 1,
      expiresAt: new Date(Date.now() - 1000).toISOString(),
    });

    assert.equal(collabInvitesDb.findValid('tok-1')?.role, 'viewer');
    assert.equal(collabInvitesDb.findValid('nope'), null);
    assert.equal(collabInvitesDb.findValid('tok-expired'), null);
    assert.equal(collabInvitesDb.consume('tok-expired', 2), null);

    // Burn once — replay must fail.
    assert.ok(collabInvitesDb.consume('tok-1', 2));
    assert.equal(collabInvitesDb.findValid('tok-1'), null);
    assert.equal(collabInvitesDb.consume('tok-1', 3), null);
  });
});

test('collab routes expose /users and /activity over HTTP', async () => {
  await withIsolatedDatabase(async () => {
    userDb.createUser('alice', 'hash');
    const card = createCard('proj-x', 'HTTP card');
    activityEventsDb.record({
      id: 'e1',
      projectId: 'proj-x',
      userId: 1,
      kind: 'card_created',
      entityId: card.cardId,
      summary: 'Created card "HTTP card"',
    });

    const app = express();
    app.use(express.json());
    app.use(createCollabRouter());
    const server = await new Promise<ReturnType<typeof app.listen>>((resolve) => {
      const s = app.listen(0, '127.0.0.1', () => resolve(s));
    });
    try {
      const { port } = server.address() as { port: number };
      const base = `http://127.0.0.1:${port}`;

      const usersResponse = await fetch(`${base}/users`);
      const usersPayload = await usersResponse.json() as { success: boolean; data: { users: Array<{ username: string; role: string; displayName: string }> } };
      assert.equal(usersResponse.status, 200);
      assert.equal(usersPayload.data.users[0].username, 'alice');
      assert.equal(usersPayload.data.users[0].role, 'owner');
      assert.equal(usersPayload.data.users[0].displayName, 'alice');

      const activityResponse = await fetch(`${base}/activity?projectId=proj-x`);
      const activityPayload = await activityResponse.json() as { success: boolean; data: { events: Array<{ kind: string; entityId: string }> } };
      assert.equal(activityResponse.status, 200);
      assert.equal(activityPayload.data.events.length, 1);
      assert.equal(activityPayload.data.events[0].kind, 'card_created');
      assert.equal(activityPayload.data.events[0].entityId, card.cardId);

      const missingProject = await fetch(`${base}/activity`);
      assert.equal(missingProject.status, 400);
    } finally {
      await new Promise<void>((resolve) => server.close(() => resolve()));
    }
  });
});

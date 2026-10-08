import assert from 'node:assert/strict';
import test from 'node:test';

import {
  createQueuedMessagesService,
  type QueuedDispatchResult,
  type QueuedMessagesRunRegistry,
} from '@/modules/queued-messages/queued-messages.service.js';
import type { QueuedMessage, QueuedMessagesRepository } from '@/shared/types.js';

const SESSION = 'session-1';

/** Waits long enough for a short sweep interval to fire at least once. */
const sleep = (ms: number): Promise<void> => new Promise((resolve) => setTimeout(resolve, ms));

function createMemoryRepository(): QueuedMessagesRepository {
  let nextId = 1;
  const rows = new Map<number, QueuedMessage>();

  function ordered(sessionId: string): QueuedMessage[] {
    return [...rows.values()]
      .filter((row) => row.sessionId === sessionId && row.status !== 'sent')
      .sort((a, b) => a.position - b.position || a.id - b.id);
  }

  return {
    enqueue(input) {
      const position = ordered(input.sessionId).length;
      const message: QueuedMessage = {
        id: nextId++,
        userId: input.userId ?? null,
        sessionId: input.sessionId,
        content: input.content,
        options: input.options ?? {},
        status: 'queued',
        error: null,
        position,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };
      rows.set(message.id, message);
      return message;
    },
    // Mirrors the SQL: an in-flight message leaves the queue view.
    listBySession: (sessionId) => ordered(sessionId).filter((row) => row.status !== 'sending'),
    peekNext: (sessionId) => ordered(sessionId).find((row) => row.status === 'queued') ?? null,
    getById: (id) => rows.get(id) ?? null,
    markSending(id) {
      const row = rows.get(id);
      if (!row || row.status !== 'queued') return false;
      row.status = 'sending';
      return true;
    },
    markSent(id) {
      const row = rows.get(id);
      if (row) row.status = 'sent';
    },
    markFailed(id, error) {
      const row = rows.get(id);
      if (row) {
        row.status = 'failed';
        row.error = error ?? null;
      }
    },
    requeue(id) {
      const row = rows.get(id);
      if (row && (row.status === 'sending' || row.status === 'failed')) row.status = 'queued';
    },
    listSending: () =>
      [...rows.values()]
        .filter((row) => row.status === 'sending')
        .sort((a, b) => a.position - b.position || a.id - b.id),
    listPendingSessionIds: () => [
      ...new Set(
        [...rows.values()]
          .filter((row) => row.status === 'queued' || row.status === 'sending')
          .map((row) => row.sessionId),
      ),
    ],
    requeueStaleSending() {
      // Mirrors the SQL: report sessions with `queued` or `sending` rows,
      // and flip only `sending` back to `queued`.
      const pending = [...rows.values()].filter(
        (row) => row.status === 'queued' || row.status === 'sending',
      );
      for (const row of pending) {
        if (row.status === 'sending') row.status = 'queued';
      }
      return [...new Set(pending.map((row) => row.sessionId))];
    },
    remove: (id) => {
      rows.delete(id);
    },
    removeBySession: (sessionId) => {
      let count = 0;
      for (const [id, row] of rows) {
        if (row.sessionId === sessionId) {
          rows.delete(id);
          count += 1;
        }
      }
      return count;
    },
    promote(id) {
      const row = rows.get(id);
      if (!row) return;
      const min = Math.min(...ordered(row.sessionId).map((entry) => entry.position), 0);
      row.position = min - 1;
    },
  };
}

function createRunRegistry(initialProcessing = false): QueuedMessagesRunRegistry & {
  emitCompleted(sessionId: string): void;
  /** Flips the session idle WITHOUT notifying listeners — a lost completion frame. */
  setIdle(sessionId: string): void;
} {
  let processing = initialProcessing;
  const listeners = new Set<(sessionId: string) => void>();
  return {
    isProcessing: () => processing,
    onRunCompleted: (listener) => {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    emitCompleted(sessionId) {
      processing = false;
      for (const listener of listeners) listener(sessionId);
    },
    setIdle() {
      processing = false;
    },
  };
}

test('enqueue dispatches immediately when the session is idle', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });

  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['hello']);
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('enqueue holds messages while the session is processing and drains on completion', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  service.enqueue({ sessionId: SESSION, content: 'first' });
  service.enqueue({ sessionId: SESSION, content: 'second' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, []);

  runs.emitCompleted(SESSION);
  await new Promise((resolve) => setTimeout(resolve, 0));
  // One turn at a time: the head dispatches, and once its turn resolves the
  // drain continues with the next message without needing another completion.
  assert.deepEqual(dispatched, ['first', 'second']);
});

test('sendNow promotes a queued message without interrupting the active run', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  const first = service.enqueue({ sessionId: SESSION, content: 'first' });
  const second = service.enqueue({ sessionId: SESSION, content: 'second' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, []);

  // Promote the second message to the front — the live turn keeps running,
  // so nothing dispatches yet.
  await service.sendNow(second.id);
  assert.deepEqual(dispatched, []);
  assert.equal(repository.getById(second.id)?.status, 'queued');

  // The active turn's completion drains the promoted message first.
  runs.emitCompleted(SESSION);
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['second', 'first']);
});

test('sendNow steers a message into the live turn when the provider accepts it', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];
  const steered: string[] = [];
  const broadcasts: QueuedMessage[][] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    steer: async (input) => {
      steered.push(input.content);
      return true;
    },
    broadcast: (payload) => broadcasts.push(payload.messages),
  });

  const first = service.enqueue({ sessionId: SESSION, content: 'first' });
  const second = service.enqueue({ sessionId: SESSION, content: 'second' });

  const returned = await service.sendNow(second.id);
  assert.deepEqual(steered, ['second']);
  assert.equal(returned.status, 'sent');
  // The steered row left the queue; the other one still waits for the turn.
  assert.deepEqual(broadcasts.at(-1)?.map((row) => row.id), [first.id]);

  runs.emitCompleted(SESSION);
  await sleep(0);
  // Never sent twice: only the untouched row drains as the next turn.
  assert.deepEqual(dispatched, ['first']);
});

test('sendNow falls back to promoting when the live turn refuses the message', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    steer: async () => false,
  });

  service.enqueue({ sessionId: SESSION, content: 'first' });
  const second = service.enqueue({ sessionId: SESSION, content: 'second' });

  const returned = await service.sendNow(second.id);
  assert.equal(returned.status, 'queued');
  assert.deepEqual(dispatched, []);

  runs.emitCompleted(SESSION);
  await sleep(0);
  assert.deepEqual(dispatched, ['second', 'first']);
});

test('a steer that throws keeps the message queued', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (): Promise<QueuedDispatchResult> => ({ ok: true }),
    steer: async () => {
      throw new Error('provider went away');
    },
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  const returned = await service.sendNow(message.id);
  assert.equal(returned.status, 'queued');
});

test('a completion during a refused steer still drains the message', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    // The turn ends while the provider is deciding — its completion drain
    // finds the row claimed and skips it.
    steer: async () => {
      runs.emitCompleted(SESSION);
      return false;
    },
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'late' });
  await service.sendNow(message.id);
  await sleep(0);
  assert.deepEqual(dispatched, ['late']);
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('a failed dispatch marks the row failed rather than dropping it', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (): Promise<QueuedDispatchResult> => ({ ok: false, error: 'boom' }),
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  await new Promise((resolve) => setTimeout(resolve, 0));

  const stored = repository.getById(message.id);
  assert.equal(stored?.status, 'failed');
  assert.equal(stored?.error, 'boom');
  // Failed rows stay listed so the client can see (and retry) them.
  assert.deepEqual(service.list(SESSION).map((entry) => entry.id), [message.id]);
});

test('sendNow retries a failed message', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const dispatched: string[] = [];
  let fail = true;

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      if (fail) {
        return { ok: false, error: 'boom' };
      }
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'failed');

  fail = false;
  await service.sendNow(message.id);
  // The dispatch is fire-and-forget so the REST call is not held for the whole
  // turn — the row is `sending` synchronously and settles a tick later.
  assert.deepEqual(dispatched, ['hello']);
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('sendNow on an idle session does not wait for the dispatched turn', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  let release: () => void = () => {};

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: () =>
      new Promise<QueuedDispatchResult>((resolve) => {
        release = () => resolve({ ok: true });
      }),
  });

  // Queue while the session looks busy, then go idle WITHOUT firing the
  // completion listener (a lost frame): only sendNow can start the turn.
  const message = service.enqueue({ sessionId: SESSION, content: 'hold' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  runs.setIdle(SESSION);

  // The row flips to `sending` and the call returns while the provider turn
  // (the `dispatch` promise) is still pending — a REST client must never be
  // held for the length of a turn.
  const returned = await service.sendNow(message.id);
  assert.equal(returned.status, 'sending');

  release();
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('remove deletes a queued message and broadcasts the new queue', () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const broadcasts: string[][] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (): Promise<QueuedDispatchResult> => ({ ok: true }),
    broadcast: (payload) => broadcasts.push(payload.messages.map((message) => message.content)),
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  service.remove(message.id);

  assert.equal(repository.getById(message.id), null);
  assert.deepEqual(broadcasts.at(-1), []);
});

test('sendNow rejects an unknown message id', async () => {
  const service = createQueuedMessagesService({
    repository: createMemoryRepository(),
    runs: createRunRegistry(false),
    dispatch: async (): Promise<QueuedDispatchResult> => ({ ok: true }),
  });

  await assert.rejects(() => service.sendNow(999), /was not found/);
});

test('drains the next queued message only after the previous turn resolves', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];
  const releases: Array<() => void> = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: (input) =>
      new Promise<QueuedDispatchResult>((resolve) => {
        dispatched.push(input.content);
        releases.push(() => resolve({ ok: true }));
      }),
  });

  service.enqueue({ sessionId: SESSION, content: 'first' });
  service.enqueue({ sessionId: SESSION, content: 'second' });
  await new Promise((resolve) => setTimeout(resolve, 0));

  runs.emitCompleted(SESSION);
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['first']);

  releases.shift()?.();
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['first', 'second']);

  releases.shift()?.();
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(
    repository.listBySession(SESSION).map((message) => message.status),
    [],
  );
});

test('rows orphaned in `sending` are requeued and drained at service creation', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const dispatched: string[] = [];

  // Simulate a restart mid-dispatch: a row stuck in `sending` before the
  // service (and its drain trigger) even exists.
  const orphan = repository.enqueue({ sessionId: SESSION, content: 'orphaned' });
  repository.markSending(orphan.id);

  createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['orphaned']);
  assert.equal(repository.getById(orphan.id)?.status, 'sent');
});

test('startup drains `queued` rows parked before the process restarted', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const dispatched: string[] = [];

  // Simulate a restart while a run was active: the row is still `queued`,
  // never dispatched, and no completion event will ever arrive for it.
  const parked = repository.enqueue({ sessionId: SESSION, content: 'parked' });

  createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
  });

  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, ['parked']);
  assert.equal(repository.getById(parked.id)?.status, 'sent');
});

test('sendNow on an in-flight `sending` row does not dispatch twice', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const dispatched: string[] = [];
  let release: () => void = () => {};

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: (input) =>
      new Promise<QueuedDispatchResult>((resolve) => {
        dispatched.push(input.content);
        release = () => resolve({ ok: true });
      }),
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'sending');
  assert.deepEqual(dispatched, ['hello']);

  // The first dispatch is still in flight — send-now must not send it again.
  const returned = await service.sendNow(message.id);
  assert.equal(returned.status, 'sending');
  assert.deepEqual(dispatched, ['hello']);

  release();
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('a dispatching message leaves the queue list as soon as its turn starts', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);
  const broadcasts: string[][] = [];
  let release: () => void = () => {};

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: () =>
      new Promise<QueuedDispatchResult>((resolve) => {
        release = () => resolve({ ok: true });
      }),
    broadcast: (payload) => broadcasts.push(payload.messages.map((message) => message.content)),
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  await new Promise((resolve) => setTimeout(resolve, 0));

  assert.equal(repository.getById(message.id)?.status, 'sending');
  assert.deepEqual(service.list(SESSION), []);
  assert.deepEqual(broadcasts.at(-1), []);

  release();
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('the idle sweep drains a queued message when the completion notification is lost', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    sweepIntervalMs: 5,
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'lost' });
  await sleep(20);
  // Still processing — the message correctly waits.
  assert.deepEqual(dispatched, []);

  // The run went idle but no `complete` frame reached the listener, so the
  // completion-driven drain never runs. The sweep must still deliver it.
  runs.setIdle(SESSION);
  await sleep(40);
  assert.deepEqual(dispatched, ['lost']);
  assert.equal(repository.getById(message.id)?.status, 'sent');
});

test('the idle sweep recovers a row orphaned in `sending`', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    sweepIntervalMs: 5,
  });

  // A dispatcher claimed this row and then died without finalizing it — the
  // row is invisible to both `peekNext` and `listBySession`.
  const orphan = repository.enqueue({ sessionId: SESSION, content: 'orphan' });
  repository.markSending(orphan.id);
  await sleep(20);
  assert.deepEqual(dispatched, []);

  runs.setIdle(SESSION);
  await sleep(40);
  assert.deepEqual(dispatched, ['orphan']);
  assert.equal(repository.getById(orphan.id)?.status, 'sent');
});

import assert from 'node:assert/strict';
import test from 'node:test';

import {
  createQueuedMessagesService,
  type QueuedDispatchResult,
  type QueuedMessagesRunRegistry,
} from '@/modules/queued-messages/queued-messages.service.js';
import type { QueuedMessage, QueuedMessagesRepository } from '@/shared/types.js';

const SESSION = 'session-1';

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
    promote(id) {
      const row = rows.get(id);
      if (!row) return;
      const min = Math.min(...ordered(row.sessionId).map((entry) => entry.position), 0);
      row.position = min - 1;
    },
  };
}

function createRunRegistry(initialProcessing = false): QueuedMessagesRunRegistry & {
  setProcessing(value: boolean): void;
  emitCompleted(sessionId: string): void;
} {
  let processing = initialProcessing;
  const listeners = new Set<(sessionId: string) => void>();
  return {
    isProcessing: () => processing,
    onRunCompleted: (listener) => {
      listeners.add(listener);
      return () => listeners.delete(listener);
    },
    completeRun: () => {
      processing = false;
    },
    setProcessing(value) {
      processing = value;
    },
    emitCompleted(sessionId) {
      processing = false;
      for (const listener of listeners) listener(sessionId);
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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

test('sendNow aborts the active run and sends the promoted message', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(true);
  const dispatched: string[] = [];
  const aborted: string[] = [];

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (input): Promise<QueuedDispatchResult> => {
      dispatched.push(input.content);
      return { ok: true };
    },
    abort: async (sessionId) => {
      aborted.push(sessionId);
    },
  });

  const first = service.enqueue({ sessionId: SESSION, content: 'first' });
  const second = service.enqueue({ sessionId: SESSION, content: 'second' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.deepEqual(dispatched, []);

  // Promote the second message to the front and send it before the first.
  runs.setProcessing(true);
  await service.sendNow(second.id);
  assert.deepEqual(aborted, [SESSION]);
  assert.deepEqual(dispatched, ['second']);
  assert.equal(repository.getById(second.id)?.status, 'sent');
  assert.equal(repository.getById(first.id)?.status, 'queued');
});

test('sendNow leaves the message queued when the provider refuses to abort', async () => {
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
    // The provider reports nothing was aborted — the turn is still alive.
    abort: async () => false,
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'later' });
  await new Promise((resolve) => setTimeout(resolve, 0));

  const result = await service.sendNow(message.id);
  // No dispatch into a busy provider, no registry force-clear: the message
  // stays queued and the live turn's completion drains it.
  assert.deepEqual(dispatched, []);
  assert.equal(result.status, 'queued');
  assert.equal(repository.getById(message.id)?.status, 'queued');
});

test('a failed dispatch marks the row failed rather than dropping it', async () => {
  const repository = createMemoryRepository();
  const runs = createRunRegistry(false);

  const service = createQueuedMessagesService({
    repository,
    runs,
    dispatch: async (): Promise<QueuedDispatchResult> => ({ ok: false, error: 'boom' }),
    abort: async () => undefined,
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
    abort: async () => undefined,
  });

  const message = service.enqueue({ sessionId: SESSION, content: 'hello' });
  await new Promise((resolve) => setTimeout(resolve, 0));
  assert.equal(repository.getById(message.id)?.status, 'failed');

  fail = false;
  await service.sendNow(message.id);
  assert.deepEqual(dispatched, ['hello']);
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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
    abort: async () => undefined,
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

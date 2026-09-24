import assert from 'node:assert/strict';
import test, { beforeEach } from 'node:test';

import {
  readOfflineQueue,
  writeOfflineQueue,
  clearOfflineQueue,
  flushOfflineMessages,
  offlineQueueKey,
  type QueuedOfflineMessage,
} from '../utils/chatStorage';

class MockLocalStorage {
  private store = new Map<string, string>();

  getItem(key: string): string | null {
    return this.store.get(key) ?? null;
  }

  setItem(key: string, value: string): void {
    this.store.set(key, value);
  }

  removeItem(key: string): void {
    this.store.delete(key);
  }

  clear(): void {
    this.store.clear();
  }
}

const mockStorage = new MockLocalStorage();
(globalThis as any).localStorage = mockStorage;

beforeEach(() => {
  mockStorage.clear();
});

test('readOfflineQueue returns empty array when empty or invalid', () => {
  assert.deepEqual(readOfflineQueue('proj-1'), []);

  mockStorage.setItem(offlineQueueKey('proj-1'), 'invalid json {');
  assert.deepEqual(readOfflineQueue('proj-1'), []);

  mockStorage.setItem(offlineQueueKey('proj-1'), JSON.stringify('not an array'));
  assert.deepEqual(readOfflineQueue('proj-1'), []);
});

test('writeOfflineQueue stores messages and readOfflineQueue retrieves them', () => {
  const messages: QueuedOfflineMessage[] = [
    {
      id: 'msg-1',
      sessionId: 'session-123',
      content: 'Hello offline world',
      options: { model: 'claude-3-5-sonnet' },
      createdAt: 1000,
    },
    {
      id: 'msg-2',
      sessionId: 'session-123',
      content: 'Second offline message',
      createdAt: 2000,
    },
  ];

  writeOfflineQueue('proj-1', messages);

  const stored = readOfflineQueue('proj-1');
  assert.equal(stored.length, 2);
  assert.equal(stored[0].id, 'msg-1');
  assert.equal(stored[0].content, 'Hello offline world');
  assert.equal(stored[1].id, 'msg-2');
  assert.equal(stored[1].content, 'Second offline message');

  // Verify key format
  const raw = mockStorage.getItem(offlineQueueKey('proj-1'));
  assert.ok(raw);
  assert.ok(raw.includes('Hello offline world'));
});

test('writeOfflineQueue with empty array or clearOfflineQueue removes key', () => {
  const messages: QueuedOfflineMessage[] = [
    {
      id: 'msg-1',
      sessionId: 'session-1',
      content: 'test',
      createdAt: Date.now(),
    },
  ];

  writeOfflineQueue('proj-1', messages);
  assert.equal(readOfflineQueue('proj-1').length, 1);

  writeOfflineQueue('proj-1', []);
  assert.equal(mockStorage.getItem(offlineQueueKey('proj-1')), null);
  assert.deepEqual(readOfflineQueue('proj-1'), []);

  writeOfflineQueue('proj-1', messages);
  assert.equal(readOfflineQueue('proj-1').length, 1);

  clearOfflineQueue('proj-1');
  assert.equal(mockStorage.getItem(offlineQueueKey('proj-1')), null);
  assert.deepEqual(readOfflineQueue('proj-1'), []);
});

test('flush logic sends queued messages and removes them on success', () => {
  const projectId = 'proj-auto-send';
  const initialMessages: QueuedOfflineMessage[] = [
    {
      id: 'msg-1',
      sessionId: 's-1',
      content: 'First command',
      createdAt: 1,
    },
    {
      id: 'msg-2',
      sessionId: 's-1',
      content: 'Second command',
      createdAt: 2,
    },
  ];

  writeOfflineQueue(projectId, initialMessages);

  const sent: any[] = [];
  const fakeSendMessage = (msg: any): boolean => {
    sent.push(msg);
    return true;
  };

  // Simulate flushOfflineQueue implementation
  const currentQueue = readOfflineQueue(projectId);
  const remaining: QueuedOfflineMessage[] = [];
  for (const msg of currentQueue) {
    const ok = fakeSendMessage({
      type: 'chat.send',
      sessionId: msg.sessionId,
      content: msg.content,
      options: msg.options ?? {},
    });
    if (!ok) {
      remaining.push(msg);
    }
  }
  writeOfflineQueue(projectId, remaining);

  assert.equal(sent.length, 2);
  assert.equal(sent[0].content, 'First command');
  assert.equal(sent[1].content, 'Second command');
  assert.equal(readOfflineQueue(projectId).length, 0);
});

test('flush logic retains messages that fail to send', () => {
  const projectId = 'proj-partial-fail';
  const initialMessages: QueuedOfflineMessage[] = [
    {
      id: 'msg-1',
      sessionId: 's-1',
      content: 'Will succeed',
      createdAt: 1,
    },
    {
      id: 'msg-2',
      sessionId: 's-1',
      content: 'Will fail',
      createdAt: 2,
    },
  ];

  writeOfflineQueue(projectId, initialMessages);

  const fakeSendMessage = (msg: any): boolean => {
    return msg.content === 'Will succeed';
  };

  const currentQueue = readOfflineQueue(projectId);
  const remaining: QueuedOfflineMessage[] = [];
  for (const msg of currentQueue) {
    const ok = fakeSendMessage({
      type: 'chat.send',
      sessionId: msg.sessionId,
      content: msg.content,
    });
    if (!ok) {
      remaining.push(msg);
    }
  }
  writeOfflineQueue(projectId, remaining);

  const updatedQueue = readOfflineQueue(projectId);
  assert.equal(updatedQueue.length, 1);
  assert.equal(updatedQueue[0].id, 'msg-2');
  assert.equal(updatedQueue[0].content, 'Will fail');
});

test('flushOfflineMessages promotes an offline-session placeholder to a real session', async () => {
  const placeholder = `offline-session-${Date.now()}`;
  const messages: QueuedOfflineMessage[] = [
    { id: 'm1', sessionId: placeholder, content: 'queued while offline', createdAt: 1 },
  ];

  const sentTo: string[] = [];
  const promotedTo: string[] = [];
  const result = await flushOfflineMessages(messages, {
    send: (sessionId) => {
      sentTo.push(sessionId);
      return true;
    },
    createSession: async () => 'real-session-1',
    onSessionPromoted: (realSessionId) => promotedTo.push(realSessionId),
  });

  assert.deepEqual(sentTo, ['real-session-1']);
  assert.deepEqual(promotedTo, ['real-session-1']);
  assert.equal(result.sent.length, 1);
  assert.equal(result.sent[0].sessionId, 'real-session-1');
  assert.equal(result.remaining.length, 0);
});

test('flushOfflineMessages reuses one created session for all entries sharing a placeholder', async () => {
  const placeholder = `offline-session-${Date.now()}`;
  const messages: QueuedOfflineMessage[] = [
    { id: 'm1', sessionId: placeholder, content: 'first', createdAt: 1 },
    { id: 'm2', sessionId: placeholder, content: 'second', createdAt: 2 },
    { id: 'm3', sessionId: placeholder, content: 'third', createdAt: 3 },
  ];

  let createCalls = 0;
  const sentTo: string[] = [];
  const result = await flushOfflineMessages(messages, {
    send: (sessionId) => {
      sentTo.push(sessionId);
      return true;
    },
    createSession: async () => {
      createCalls++;
      return 'real-session-shared';
    },
  });

  assert.equal(createCalls, 1);
  assert.deepEqual(sentTo, ['real-session-shared', 'real-session-shared', 'real-session-shared']);
  assert.equal(result.remaining.length, 0);
});

test('flushOfflineMessages keeps the placeholder entry when session creation fails', async () => {
  const placeholder = `offline-session-${Date.now()}`;
  const messages: QueuedOfflineMessage[] = [
    { id: 'm1', sessionId: placeholder, content: 'still parked', createdAt: 1 },
  ];

  for (const createSession of [async () => null, async () => { throw new Error('network down'); }]) {
    const result = await flushOfflineMessages(messages, {
      send: () => {
        throw new Error('must not be reached — promotion failed first');
      },
      createSession,
    });

    assert.equal(result.sent.length, 0);
    assert.equal(result.remaining.length, 1);
    assert.equal(result.remaining[0].sessionId, placeholder);
  }
});

test('flushOfflineMessages retains the promoted session id when the socket write fails', async () => {
  const placeholder = `offline-session-${Date.now()}`;
  const messages: QueuedOfflineMessage[] = [
    { id: 'm1', sessionId: placeholder, content: 'promoted but not sent', createdAt: 1 },
  ];

  let createCalls = 0;
  const result = await flushOfflineMessages(messages, {
    send: () => false,
    createSession: async () => {
      createCalls++;
      return 'real-session-kept';
    },
  });

  assert.equal(createCalls, 1);
  assert.equal(result.sent.length, 0);
  assert.equal(result.remaining.length, 1);
  // Retry must target the real session, not recreate one from the placeholder.
  assert.equal(result.remaining[0].sessionId, 'real-session-kept');
});

test('flushOfflineMessages leaves non-placeholder entries untouched', async () => {
  const messages: QueuedOfflineMessage[] = [
    { id: 'm1', sessionId: 'existing-session', content: 'normal queued', createdAt: 1 },
  ];

  let createCalls = 0;
  const sentTo: string[] = [];
  const result = await flushOfflineMessages(messages, {
    send: (sessionId) => {
      sentTo.push(sessionId);
      return true;
    },
    createSession: async () => {
      createCalls++;
      return 'should-not-be-created';
    },
  });

  assert.equal(createCalls, 0);
  assert.deepEqual(sentTo, ['existing-session']);
  assert.equal(result.remaining.length, 0);
});

// Storage-backed harness: simulates the real localStorage claim/requeue
// wiring so the tests observe the same states a reload would see.
const storageBacked = (projectId: string) => ({
  stillQueued: (message: QueuedOfflineMessage) =>
    readOfflineQueue(projectId).some((m) => m.id === message.id),
  claim: (message: QueuedOfflineMessage) => {
    const fresh = readOfflineQueue(projectId);
    if (!fresh.some((m) => m.id === message.id)) return false;
    writeOfflineQueue(projectId, fresh.filter((m) => m.id !== message.id));
    return true;
  },
  requeue: (message: QueuedOfflineMessage) => {
    writeOfflineQueue(projectId, [...readOfflineQueue(projectId), message]);
  },
});

test('flushOfflineMessages leaves the entry in storage while promotion awaits (reload-safe)', async () => {
  const projectId = 'proj-reload-mid-flush';
  const placeholder = `offline-session-${Date.now()}`;
  const message: QueuedOfflineMessage = {
    id: 'm1',
    sessionId: placeholder,
    content: 'waiting out the create',
    createdAt: 1,
  };
  writeOfflineQueue(projectId, [message]);

  let resolveCreate: ((v: string) => void) | null = null;
  const flushPromise = flushOfflineMessages([message], {
    send: () => true,
    createSession: () =>
      new Promise<string>((resolve) => {
        resolveCreate = resolve;
      }),
    ...storageBacked(projectId),
  });

  // While session creation is in flight the entry must still be queued.
  await new Promise((r) => setTimeout(r, 0));
  assert.equal(readOfflineQueue(projectId).length, 1);
  assert.equal(readOfflineQueue(projectId)[0].id, 'm1');

  resolveCreate!('real-session-1');
  await flushPromise;
  assert.equal(readOfflineQueue(projectId).length, 0);
});

test('flushOfflineMessages requeues a failed send with the promoted session id', async () => {
  const projectId = 'proj-requeue-promoted';
  const placeholder = `offline-session-${Date.now()}`;
  const message: QueuedOfflineMessage = {
    id: 'm1',
    sessionId: placeholder,
    content: 'send fails once',
    createdAt: 1,
  };
  writeOfflineQueue(projectId, [message]);

  const result = await flushOfflineMessages(readOfflineQueue(projectId), {
    send: () => false,
    createSession: async () => 'real-session-9',
    ...storageBacked(projectId),
  });

  const parked = readOfflineQueue(projectId);
  assert.equal(parked.length, 1);
  assert.equal(parked[0].sessionId, 'real-session-9');
  assert.equal(result.remaining[0].sessionId, 'real-session-9');
});

test('flushOfflineMessages skips an entry already claimed by a sibling flush', async () => {
  const projectId = 'proj-sibling-claim';
  const message: QueuedOfflineMessage = {
    id: 'm1',
    sessionId: 'existing-session',
    content: 'taken by another pane',
    createdAt: 1,
  };
  writeOfflineQueue(projectId, [message]);
  const hooks = storageBacked(projectId);

  // Sibling claims it first.
  assert.equal(hooks.claim(message), true);
  assert.equal(readOfflineQueue(projectId).length, 0);
  hooks.requeue(message); // sibling send failed, entry is back
  assert.equal(hooks.claim(message), true); // sibling re-claims and sends

  const sentTo: string[] = [];
  const result = await flushOfflineMessages([message], {
    send: (sessionId) => {
      sentTo.push(sessionId);
      return true;
    },
    createSession: async () => null,
    ...hooks,
  });

  assert.equal(result.sent.length, 0);
  assert.equal(result.remaining.length, 0);
  assert.deepEqual(sentTo, []);
});

test('flushOfflineMessages does not send or rebind when a sibling claims during promotion', async () => {
  const projectId = 'proj-sibling-mid-promote';
  const placeholder = `offline-session-${Date.now()}`;
  const message: QueuedOfflineMessage = {
    id: 'm1',
    sessionId: placeholder,
    content: 'raced by another tab',
    createdAt: 1,
  };
  writeOfflineQueue(projectId, [message]);
  const hooks = storageBacked(projectId);

  const sentTo: string[] = [];
  const promotedTo: string[] = [];
  const result = await flushOfflineMessages([message], {
    send: (sessionId) => {
      sentTo.push(sessionId);
      return true;
    },
    createSession: async () => {
      // Sibling claims the entry while our session create is in flight.
      hooks.claim(message);
      return 'orphaned-session';
    },
    onSessionPromoted: (realSessionId) => promotedTo.push(realSessionId),
    ...hooks,
  });

  // The created session is orphaned (unavoidable without a cross-tab lock),
  // but nothing is sent under it and the pane is never rebound to it.
  assert.deepEqual(sentTo, []);
  assert.deepEqual(promotedTo, []);
  assert.equal(result.sent.length, 0);
  assert.equal(result.remaining.length, 0);
});

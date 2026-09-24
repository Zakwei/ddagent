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

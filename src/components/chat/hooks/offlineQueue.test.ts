import assert from 'node:assert/strict';
import test, { beforeEach } from 'node:test';

import {
  readOfflineQueue,
  writeOfflineQueue,
  clearOfflineQueue,
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

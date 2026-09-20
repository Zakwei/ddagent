import assert from 'node:assert/strict';
import test, { beforeEach } from 'node:test';

import {
  _resetForTests,
  getPinnedSessionIds,
  isSessionPinned,
  sortSessionsWithPinned,
  toggleSessionPinned,
  PINNED_SESSIONS_STORAGE_KEY,
} from './pinnedSessions';

// Simple mock for localStorage in Node test environment
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
  _resetForTests();
});

test('isSessionPinned returns false for unpinned session', () => {
  assert.equal(isSessionPinned('session-1'), false);
  assert.equal(getPinnedSessionIds().size, 0);
});

test('toggleSessionPinned pins and unpins a session', () => {
  const pinnedFirst = toggleSessionPinned('session-1');
  assert.equal(pinnedFirst, true);
  assert.equal(isSessionPinned('session-1'), true);
  assert.deepEqual(Array.from(getPinnedSessionIds()), ['session-1']);

  // Check persisted in storage
  const raw = mockStorage.getItem(PINNED_SESSIONS_STORAGE_KEY);
  assert.ok(raw);
  assert.deepEqual(JSON.parse(raw), ['session-1']);

  // Toggle again unpins
  const pinnedSecond = toggleSessionPinned('session-1');
  assert.equal(pinnedSecond, false);
  assert.equal(isSessionPinned('session-1'), false);
  assert.equal(getPinnedSessionIds().size, 0);
});

test('toggleSessionPinned handles invalid inputs gracefully', () => {
  assert.equal(toggleSessionPinned(''), false);
  assert.equal(toggleSessionPinned(null as unknown as string), false);
  assert.equal(isSessionPinned(''), false);
});

test('sortSessionsWithPinned places pinned sessions at top preserving relative order', () => {
  const sessions = [
    { id: 'session-a', name: 'A' },
    { id: 'session-b', name: 'B' },
    { id: 'session-c', name: 'C' },
    { id: 'session-d', name: 'D' },
    { id: 'session-e', name: 'E' },
  ];

  const pinnedSet = new Set(['session-b', 'session-d']);
  const isPinned = (id: string) => pinnedSet.has(id);

  const sorted = sortSessionsWithPinned(sessions, isPinned);

  assert.deepEqual(
    sorted.map((s) => s.id),
    ['session-b', 'session-d', 'session-a', 'session-c', 'session-e'],
  );
});

test('sortSessionsWithPinned preserves order when nothing or all is pinned', () => {
  const sessions = [
    { id: 'session-1', name: '1' },
    { id: 'session-2', name: '2' },
  ];

  // None pinned
  assert.deepEqual(
    sortSessionsWithPinned(sessions, () => false).map((s) => s.id),
    ['session-1', 'session-2'],
  );

  // All pinned
  assert.deepEqual(
    sortSessionsWithPinned(sessions, () => true).map((s) => s.id),
    ['session-1', 'session-2'],
  );
});

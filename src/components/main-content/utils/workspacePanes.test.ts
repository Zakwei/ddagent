import assert from 'node:assert/strict';
import { test } from 'node:test';

import {
  WORKSPACE_PANES_STORAGE_KEY,
  pickWorkspaceProjectId,
  readWorkspaceState,
  sanitizeWorkspaceState,
  writeWorkspaceState,
  type WorkspaceState,
} from './workspacePanes';

function createStorage(initial: Record<string, string> = {}): Storage {
  const map = new Map(Object.entries(initial));
  return {
    get length() {
      return map.size;
    },
    clear: () => map.clear(),
    getItem: (key: string) => map.get(key) ?? null,
    key: (index: number) => Array.from(map.keys())[index] ?? null,
    removeItem: (key: string) => {
      map.delete(key);
    },
    setItem: (key: string, value: string) => {
      map.set(key, value);
    },
  } as Storage;
}

test('sanitizeWorkspaceState drops panes with an unknown kind', () => {
  const state = sanitizeWorkspaceState({
    panes: [
      { id: 'a', kind: 'chat', sessionId: 's1' },
      { id: 'b', kind: 'hologram' },
      { id: 'c', kind: 'terminal', projectId: 'p1' },
    ],
    activePaneId: 'c',
  });

  assert.deepEqual(state.panes.map((pane) => pane.id), ['a', 'c']);
  assert.equal(state.activePaneId, 'c');
});

test('sanitizeWorkspaceState falls back to the first pane when active id is invalid', () => {
  const state = sanitizeWorkspaceState({
    panes: [{ id: 'a', kind: 'chat' }],
    activePaneId: 'missing',
  });

  assert.equal(state.activePaneId, 'a');
});

test('sanitizeWorkspaceState tolerates junk without throwing', () => {
  assert.deepEqual(sanitizeWorkspaceState(null), {
    panes: [],
    activePaneId: null,
    lastUsedProjectId: null,
  });
  assert.deepEqual(sanitizeWorkspaceState({ panes: 'nope' }), {
    panes: [],
    activePaneId: null,
    lastUsedProjectId: null,
  });
});

test('read/write round-trips a workspace through storage', () => {
  const storage = createStorage();
  const state: WorkspaceState = {
    panes: [
      { id: 'chat-1', kind: 'chat', sessionId: 's1', projectId: 'p1' },
      { id: 'browser-1', kind: 'browser', url: 'https://example.com' },
    ],
    activePaneId: 'browser-1',
    lastUsedProjectId: 'p1',
  };

  writeWorkspaceState(state, storage);
  assert.ok(storage.getItem(WORKSPACE_PANES_STORAGE_KEY));

  assert.deepEqual(readWorkspaceState(storage), state);
});

test('readWorkspaceState returns an empty workspace for corrupt JSON', () => {
  const storage = createStorage({ [WORKSPACE_PANES_STORAGE_KEY]: '{not json' });

  assert.deepEqual(readWorkspaceState(storage), {
    panes: [],
    activePaneId: null,
    lastUsedProjectId: null,
  });
});

test('browser panes keep their url and never inherit a session id', () => {
  const [pane] = sanitizeWorkspaceState({
    panes: [{ id: 'b', kind: 'browser', url: 'https://x.test', sessionId: 'ignored' }],
  }).panes;

  assert.equal(pane.url, 'https://x.test');
  assert.equal(pane.sessionId, undefined);
});

test('picker panes keep the flag through sanitize and a storage round-trip', () => {
  const state = sanitizeWorkspaceState({
    panes: [
      { id: 'chat-1', kind: 'chat', picker: true, sessionId: 's1', projectId: 'p1' },
      { id: 'chat-2', kind: 'chat', picker: true },
    ],
    activePaneId: 'chat-1',
  });

  assert.equal(state.panes[0].picker, true);
  assert.equal(state.panes[1].picker, true);

  const storage = createStorage();
  const roundTrip: WorkspaceState = {
    panes: state.panes,
    activePaneId: state.activePaneId,
    lastUsedProjectId: 'p1',
  };

  writeWorkspaceState(roundTrip, storage);
  assert.deepEqual(readWorkspaceState(storage), roundTrip);
});

test('picker is dropped unless it is literally true', () => {
  const panes = sanitizeWorkspaceState({
    panes: [
      { id: 'a', kind: 'chat', picker: false },
      { id: 'b', kind: 'chat', picker: 'true' },
      { id: 'c', kind: 'chat', picker: 1 },
      { id: 'd', kind: 'browser', url: 'https://x.test', picker: true },
    ],
  }).panes;

  assert.equal(panes[0].picker, undefined);
  assert.equal(panes[1].picker, undefined);
  assert.equal(panes[2].picker, undefined);
  // Browser panes never carry a picker flag.
  assert.equal(panes[3].picker, undefined);
});

test('pickWorkspaceProjectId prefers the focused pane project', () => {
  const panes = [
    { id: 'a', kind: 'chat' as const, projectId: 'p1' },
    { id: 'b', kind: 'terminal' as const, projectId: 'p2' },
  ];

  assert.equal(pickWorkspaceProjectId(panes, 'b', 'p9'), 'p2');
});

test('pickWorkspaceProjectId falls back to any project-bound pane for project-less focus', () => {
  const panes = [
    { id: 'chat', kind: 'chat' as const, projectId: 'p1' },
    { id: 'browser', kind: 'browser' as const, url: 'https://x.test' },
  ];

  // Reload with the browser pane focused must still restore project p1,
  // otherwise MainContent drops the whole workspace for the empty state.
  assert.equal(pickWorkspaceProjectId(panes, 'browser', null), 'p1');
  assert.equal(pickWorkspaceProjectId(panes, 'browser', 'p9'), 'p1');
});

test('pickWorkspaceProjectId falls back to the launcher choice when no pane has a project', () => {
  const panes = [
    { id: 'chat', kind: 'chat' as const },
    { id: 'browser', kind: 'browser' as const },
  ];

  assert.equal(pickWorkspaceProjectId(panes, 'chat', 'p9'), 'p9');
  assert.equal(pickWorkspaceProjectId([], null, null), null);
});

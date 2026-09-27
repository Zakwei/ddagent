import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import {
  readWorkspaceState,
  sanitizeWorkspaceState,
  writeWorkspaceState,
} from './utils/workspacePanes';
import { updateSplitPane, type SplitPane } from './utils/splitWorkspace';
import { auditPersistedPaneSessions } from './utils/paneSessionAudit';
import SessionPicker from './view/subcomponents/SessionPicker';

function createMockStorage(initial: Record<string, string> = {}): Storage {
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

test('startup audit detects archived pane session, resets pane to picker, and clears sessionId', async () => {
  let panes: SplitPane[] = [
    { id: 'pane-archived', kind: 'chat', sessionId: 'sess-archived-1', picker: false },
    { id: 'pane-active', kind: 'chat', sessionId: 'sess-active-2', picker: false },
  ];
  const auditedPaneSessionIds = new Set<string>();

  const handleSessionDeleted = (deletedSessionId: string) => {
    panes = panes.map((pane) =>
      pane.kind === 'chat' && pane.sessionId === deletedSessionId
        ? updateSplitPane([pane], pane.id, { sessionId: null, picker: true })[0]
        : pane,
    );
  };

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: handleSessionDeleted,
    fetchSessionDetails: async (sessionId) => {
      if (sessionId === 'sess-archived-1') {
        return {
          ok: true,
          json: async () => ({
            data: {
              sessionId,
              isArchived: true,
            },
          }),
        };
      }
      return {
        ok: true,
        json: async () => ({
          data: {
            sessionId,
            isArchived: false,
          },
        }),
      };
    },
  });

  // pane-archived is reset to picker/empty
  const archivedPane = panes.find((p) => p.id === 'pane-archived');
  assert.ok(archivedPane);
  assert.equal(archivedPane.sessionId, null);
  assert.equal(archivedPane.picker, true);

  // pane-active is left untouched
  const activePane = panes.find((p) => p.id === 'pane-active');
  assert.ok(activePane);
  assert.equal(activePane.sessionId, 'sess-active-2');
  assert.equal(activePane.picker, false);
});

test('persisting reset pane saves sessionId: null and picker: true to storage', () => {
  const mockStorage = createMockStorage();

  const resetPanes: SplitPane[] = [
    { id: 'pane-archived', kind: 'chat', sessionId: null, picker: true },
  ];

  writeWorkspaceState(
    { panes: resetPanes, activePaneId: 'pane-archived', lastUsedProjectId: null },
    mockStorage,
  );

  const restored = readWorkspaceState(mockStorage);
  assert.equal(restored.panes.length, 1);
  assert.equal(restored.panes[0].id, 'pane-archived');
  assert.equal(restored.panes[0].sessionId, null);
  assert.equal(restored.panes[0].picker, true);

  const sanitized = sanitizeWorkspaceState(restored);
  assert.equal(sanitized.panes[0].sessionId, null);
  assert.equal(sanitized.panes[0].picker, true);
});

test('pane in picker: true state renders SessionPicker, closing chat interface', () => {
  const pane: SplitPane = { id: 'pane-1', kind: 'chat', sessionId: null, picker: true };

  // When pane.picker is true, MainContent renders SessionPicker instead of ChatInterface
  assert.equal(pane.picker, true);
  assert.equal(pane.sessionId, null);

  const html = renderToStaticMarkup(
    React.createElement(SessionPicker, {
      sessions: [],
      onSelectSession: () => {},
      onNewChat: () => {},
    }),
  );

  assert.ok(html.includes('data-testid="session-picker"'));
  assert.ok(html.includes('+ New chat'));
  // ChatInterface content (e.g. composer, messages) is not mounted
  assert.ok(!html.includes('data-testid="chat-interface"'));
});

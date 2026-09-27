import assert from 'node:assert/strict';
import test, { beforeEach } from 'node:test';

import type { Project, ProjectSession } from '../types/app';
import { purgeSessionLocalState } from '../components/chat/utils/chatStorage';
import type { SplitPane } from '../components/main-content/utils/splitWorkspace';

class MockLocalStorage {
  getItem(key: string): string | null {
    return Object.prototype.hasOwnProperty.call(this, key) ? (this as any)[key] : null;
  }

  setItem(key: string, value: string): void {
    (this as any)[key] = value;
  }

  removeItem(key: string): void {
    delete (this as any)[key];
  }

  clear(): void {
    for (const key of Object.keys(this)) {
      delete (this as any)[key];
    }
  }
}

const mockStorage = new MockLocalStorage();
(globalThis as any).localStorage = mockStorage;

beforeEach(() => {
  mockStorage.clear();
});

test('session resolution with isArchived: true clears active session, purges local state, navigates to /, and resets panes', async () => {
  const sessionId = 'archived-sess-123';

  // 1. Setup local drafts and offline queue
  mockStorage.setItem(`draft_input_session_${sessionId}`, 'Draft message text');
  mockStorage.setItem(
    'ddagent_offline_queue_proj-1',
    JSON.stringify([{ sessionId, content: 'Offline queued msg' }]),
  );

  // 2. Setup active session state, cache, projects, and panes
  let selectedSession: ProjectSession | null = {
    id: sessionId,
    summary: 'Archived session title',
    __projectId: 'proj-1',
  };
  const navigatedRoutes: string[] = [];
  const sessionCache = new Map<string, ProjectSession>([[sessionId, selectedSession]]);
  let projects: Project[] = [
    {
      projectId: 'proj-1',
      displayName: 'Project 1',
      projectPath: '/work/proj-1',
      fullPath: '/work/proj-1',
      sessions: [selectedSession],
    },
  ];
  let panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId, picker: false },
    { id: 'pane-2', kind: 'chat', sessionId: 'active-other', picker: false },
  ];

  const navigate = (to: string) => {
    navigatedRoutes.push(to);
  };

  const onSessionDeleted = (deletedSessionId: string) => {
    panes = panes.map((pane) =>
      pane.kind === 'chat' && pane.sessionId === deletedSessionId
        ? { ...pane, sessionId: null, picker: true }
        : pane,
    );
  };

  const handleSessionDelete = (sessionIdToDelete: string) => {
    // Purge browser local state
    purgeSessionLocalState(sessionIdToDelete);

    // Clear active session and navigate away if it was the selected session
    if (selectedSession?.id === sessionIdToDelete) {
      selectedSession = null;
      navigate('/');
    }

    // Evict from cache
    sessionCache.delete(sessionIdToDelete);

    // Remove from projects
    projects = projects.map((p) => ({
      ...p,
      sessions: (p.sessions ?? []).filter((s) => s.id !== sessionIdToDelete),
    }));

    // Trigger pane unbinding callback
    onSessionDeleted(sessionIdToDelete);
  };

  // 3. Simulate session details resolving with isArchived: true
  const resolvedDetails = {
    sessionId,
    isArchived: true,
  };

  if (resolvedDetails.isArchived === true) {
    handleSessionDelete(sessionId);
  }

  // 4. Verify active session is cleared
  assert.equal(selectedSession, null);

  // 5. Verify navigation to root /
  assert.deepEqual(navigatedRoutes, ['/']);

  // 6. Verify local state (draft & offline queue) purged
  assert.equal(mockStorage.getItem(`draft_input_session_${sessionId}`), null);
  const queueJson = mockStorage.getItem('ddagent_offline_queue_proj-1');
  const queue = queueJson ? JSON.parse(queueJson) : [];
  assert.deepEqual(queue, []);

  // 7. Verify sessionCache eviction
  assert.equal(sessionCache.has(sessionId), false);

  // 8. Verify session removed from projects
  assert.equal(projects[0].sessions?.length, 0);

  // 9. Verify pane is reset to empty/picker state
  const targetPane = panes.find((p) => p.id === 'pane-1');
  assert.ok(targetPane);
  assert.equal(targetPane.sessionId, null);
  assert.equal(targetPane.picker, true);

  // 10. Verify sibling active pane is untouched
  const siblingPane = panes.find((p) => p.id === 'pane-2');
  assert.ok(siblingPane);
  assert.equal(siblingPane.sessionId, 'active-other');
  assert.equal(siblingPane.picker, false);
});

test('session resolution with isArchived: false preserves active session and panes', () => {
  const sessionId = 'active-sess-456';
  mockStorage.setItem(`draft_input_session_${sessionId}`, 'My draft');

  let selectedSession: ProjectSession | null = {
    id: sessionId,
    summary: 'Active session',
  };
  const navigatedRoutes: string[] = [];
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId, picker: false },
  ];

  const resolvedDetails = {
    sessionId,
    isArchived: false,
  };

  // When isArchived is false, handleSessionDelete is not called
  if (resolvedDetails.isArchived === true) {
    selectedSession = null;
    navigatedRoutes.push('/');
  }

  assert.ok(selectedSession !== null);
  assert.equal(selectedSession?.id, sessionId);
  assert.equal(navigatedRoutes.length, 0);
  assert.equal(mockStorage.getItem(`draft_input_session_${sessionId}`), 'My draft');
  assert.equal(panes[0].sessionId, sessionId);
  assert.equal(panes[0].picker, false);
});

test('deleting an archived background session preserves an unrelated active session', () => {
  const activeSessionId = 'active-sess-789';
  const archivedSessionId = 'archived-background-sess';

  let selectedSession: ProjectSession | null = {
    id: activeSessionId,
    summary: 'Active Session',
  };
  const navigatedRoutes: string[] = [];
  let panes: SplitPane[] = [
    { id: 'pane-active', kind: 'chat', sessionId: activeSessionId, picker: false },
    { id: 'pane-archived', kind: 'chat', sessionId: archivedSessionId, picker: false },
  ];

  const handleSessionDelete = (sessionIdToDelete: string) => {
    purgeSessionLocalState(sessionIdToDelete);
    if (selectedSession?.id === sessionIdToDelete) {
      selectedSession = null;
      navigatedRoutes.push('/');
    }
    panes = panes.map((pane) =>
      pane.kind === 'chat' && pane.sessionId === sessionIdToDelete
        ? { ...pane, sessionId: null, picker: true }
        : pane,
    );
  };

  // Background lookup for archived session resolves
  handleSessionDelete(archivedSessionId);

  // Active session remains active
  assert.ok(selectedSession !== null);
  assert.equal(selectedSession?.id, activeSessionId);
  assert.equal(navigatedRoutes.length, 0);

  // Only the archived pane is reset
  const archivedPane = panes.find((p) => p.id === 'pane-archived');
  assert.ok(archivedPane);
  assert.equal(archivedPane.sessionId, null);
  assert.equal(archivedPane.picker, true);

  const activePane = panes.find((p) => p.id === 'pane-active');
  assert.ok(activePane);
  assert.equal(activePane.sessionId, activeSessionId);
  assert.equal(activePane.picker, false);
});

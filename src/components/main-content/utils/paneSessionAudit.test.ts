import assert from 'node:assert/strict';
import test from 'node:test';

import type { Project } from '../../../types/app';

import type { SplitPane } from './splitWorkspace';
import { auditPersistedPaneSessions } from './paneSessionAudit';

test('auditPersistedPaneSessions triggers onArchivedSession when unknown chat pane resolves with isArchived: true', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'archived-sess-1' },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const archivedReported: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: (sessionId) => {
      archivedReported.push(sessionId);
    },
    fetchSessionDetails: async (sessionId) => ({
      ok: true,
      json: async () => ({
        data: {
          sessionId,
          isArchived: true,
        },
      }),
    }),
  });

  assert.deepEqual(archivedReported, ['archived-sess-1']);
  assert.ok(auditedPaneSessionIds.has('archived-sess-1'));
});

test('auditPersistedPaneSessions does not trigger onArchivedSession when session is active', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'active-sess-1' },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const archivedReported: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: (sessionId) => {
      archivedReported.push(sessionId);
    },
    fetchSessionDetails: async (sessionId) => ({
      ok: true,
      json: async () => ({
        data: {
          sessionId,
          isArchived: false,
        },
      }),
    }),
  });

  assert.deepEqual(archivedReported, []);
  assert.ok(auditedPaneSessionIds.has('active-sess-1'));
});

test('auditPersistedPaneSessions ignores failed lookups and leaves pane untouched', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'missing-sess-404' },
    { id: 'pane-2', kind: 'chat', sessionId: 'error-sess-500' },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const archivedReported: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: (sessionId) => {
      archivedReported.push(sessionId);
    },
    fetchSessionDetails: async (sessionId) => {
      if (sessionId === 'missing-sess-404') {
        return {
          ok: false,
          json: async () => ({ error: 'Not found' }),
        };
      }
      throw new Error('Network error');
    },
  });

  assert.deepEqual(archivedReported, []);
  assert.ok(auditedPaneSessionIds.has('missing-sess-404'));
  assert.ok(auditedPaneSessionIds.has('error-sess-500'));
});

test('auditPersistedPaneSessions skips panes whose session is already in projects or sessionCache', async () => {
  const projects = [
    {
      projectId: 'p1',
      displayName: 'Proj 1',
      projectPath: '/p1',
      sessions: [{ id: 'known-in-project', summary: 'active' }],
    },
  ] as unknown as Project[];
  const sessionCache = new Map<string, unknown>([['known-in-cache', {}]]);

  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'known-in-project' },
    { id: 'pane-2', kind: 'chat', sessionId: 'known-in-cache' },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const fetchedIds: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects,
    sessionCache,
    panes,
    auditedPaneSessionIds,
    onArchivedSession: () => {},
    fetchSessionDetails: async (sessionId) => {
      fetchedIds.push(sessionId);
      return { ok: true, json: async () => ({ data: { isArchived: true } }) };
    },
  });

  assert.equal(fetchedIds.length, 0);
  assert.equal(auditedPaneSessionIds.size, 0);
});

test('auditPersistedPaneSessions skips non-chat panes and panes without a sessionId', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-browser', kind: 'browser', sessionId: 'browser-sess' as unknown as undefined },
    { id: 'pane-empty-chat', kind: 'chat', sessionId: null },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const fetchedIds: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: () => {},
    fetchSessionDetails: async (sessionId) => {
      fetchedIds.push(sessionId);
      return { ok: true, json: async () => ({ data: { isArchived: true } }) };
    },
  });

  assert.equal(fetchedIds.length, 0);
  assert.equal(auditedPaneSessionIds.size, 0);
});

test('auditPersistedPaneSessions deduplicates lookups for already audited session IDs', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'already-audited' },
  ];
  const auditedPaneSessionIds = new Set<string>(['already-audited']);
  const fetchedIds: string[] = [];

  await auditPersistedPaneSessions({
    isLoadingProjects: false,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: () => {},
    fetchSessionDetails: async (sessionId) => {
      fetchedIds.push(sessionId);
      return { ok: true, json: async () => ({ data: { isArchived: true } }) };
    },
  });

  assert.equal(fetchedIds.length, 0);
});

test('auditPersistedPaneSessions no-ops when isLoadingProjects is true', async () => {
  const panes: SplitPane[] = [
    { id: 'pane-1', kind: 'chat', sessionId: 'archived-sess-1' },
  ];
  const auditedPaneSessionIds = new Set<string>();
  const fetchedIds: string[] = [];

  const result = auditPersistedPaneSessions({
    isLoadingProjects: true,
    projects: [],
    sessionCache: new Map(),
    panes,
    auditedPaneSessionIds,
    onArchivedSession: () => {},
    fetchSessionDetails: async (sessionId) => {
      fetchedIds.push(sessionId);
      return { ok: true, json: async () => ({ data: { isArchived: true } }) };
    },
  });

  assert.equal(result, undefined);
  assert.equal(fetchedIds.length, 0);
  assert.equal(auditedPaneSessionIds.size, 0);
});

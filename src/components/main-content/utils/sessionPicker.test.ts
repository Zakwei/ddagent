import assert from 'node:assert/strict';
import test from 'node:test';

import type { SplitSessionCandidate } from './splitSessionUtils';
import {
  filterArchivedPickerSessions,
  filterArchivedProjects,
  filterPickerSessions,
  formatPickerAge,
  getPickerSessionTitle,
  groupArchivedPickerSessions,
  groupPickerSessions,
  parseArchivedProjects,
  parseArchivedSessions,
  type PickerArchivedSession,
} from './sessionPicker';

function candidate(overrides: Partial<SplitSessionCandidate> & { id: string }): SplitSessionCandidate {
  return {
    projectId: 'proj-1',
    projectName: 'Project One',
    isCurrentProject: false,
    ...overrides,
  };
}

function archivedSession(
  overrides: Partial<PickerArchivedSession> & { sessionId: string },
): PickerArchivedSession {
  return {
    provider: 'claude',
    projectId: 'proj-1',
    projectPath: '/work/one',
    projectDisplayName: 'Project One',
    sessionTitle: 'Archived session',
    lastActivity: '2026-09-17T10:00:00Z',
    isProjectArchived: false,
    messageCount: 3,
    ...overrides,
  };
}

test('getPickerSessionTitle prefers summary, then title, then name, then a short id', () => {
  assert.equal(getPickerSessionTitle({ id: 'abcdef123456', summary: ' Summary ', title: 'Title' }), 'Summary');
  assert.equal(getPickerSessionTitle({ id: 'abcdef123456', title: 'Title', name: 'Name' }), 'Title');
  assert.equal(getPickerSessionTitle({ id: 'abcdef123456', name: 'Name' }), 'Name');
  assert.equal(getPickerSessionTitle({ id: 'abcdef123456' }), 'abcdef12');
});

test('filterPickerSessions matches title, summary, name and project name case-insensitively', () => {
  const sessions = [
    candidate({ id: 's1', title: 'Fix login bug', projectName: 'Alpha' }),
    candidate({ id: 's2', summary: 'Refactor SPLIT panes', projectName: 'Beta' }),
    candidate({ id: 's3', name: 'Docs cleanup', projectName: 'Gamma' }),
  ];

  assert.deepEqual(filterPickerSessions(sessions, 'LOGIN').map((s) => s.id), ['s1']);
  assert.deepEqual(filterPickerSessions(sessions, 'split').map((s) => s.id), ['s2']);
  assert.deepEqual(filterPickerSessions(sessions, 'docs').map((s) => s.id), ['s3']);
  // Project display name participates in the match.
  assert.deepEqual(filterPickerSessions(sessions, 'gamma').map((s) => s.id), ['s3']);
  assert.deepEqual(filterPickerSessions(sessions, '  ').map((s) => s.id), ['s1', 's2', 's3']);
  assert.deepEqual(filterPickerSessions(sessions, 'nothing'), []);
});

test('groupPickerSessions splits current project from the rest and keeps order', () => {
  const sessions = [
    candidate({ id: 's1', isCurrentProject: true, projectName: 'Current' }),
    candidate({ id: 's2', isCurrentProject: true, projectName: 'Current' }),
    candidate({ id: 's3', projectName: 'Other' }),
  ];

  const groups = groupPickerSessions(sessions);
  assert.deepEqual(groups.currentProject.map((s) => s.id), ['s1', 's2']);
  assert.equal(groups.currentProjectName, 'Current');
  assert.deepEqual(groups.otherProjects.map((s) => s.id), ['s3']);

  const empty = groupPickerSessions([]);
  assert.deepEqual(empty.currentProject, []);
  assert.equal(empty.currentProjectName, '');
});

test('groupArchivedPickerSessions groups by project, newest activity first', () => {
  const groups = groupArchivedPickerSessions([
    archivedSession({ sessionId: 'a1', projectId: 'p1', lastActivity: '2026-09-17T09:00:00Z' }),
    archivedSession({ sessionId: 'a2', projectId: 'p1', lastActivity: '2026-09-17T12:00:00Z' }),
    archivedSession({
      sessionId: 'a3',
      projectId: 'p2',
      projectDisplayName: 'Project Two',
      lastActivity: '2026-09-17T10:00:00Z',
      isProjectArchived: true,
    }),
  ]);

  assert.equal(groups.length, 2);
  assert.equal(groups[0].projectId, 'p1');
  assert.equal(groups[0].latestActivity, '2026-09-17T12:00:00Z');
  assert.deepEqual(groups[0].sessions.map((s) => s.sessionId), ['a1', 'a2']);
  assert.equal(groups[1].projectId, 'p2');
  assert.equal(groups[1].isProjectArchived, true);
});

test('groupArchivedPickerSessions appends archived projects with no sessions', () => {
  const groups = groupArchivedPickerSessions(
    [archivedSession({ sessionId: 'a1', projectId: 'p1' })],
    [{ projectId: 'p9', displayName: 'Empty archive', fullPath: '/work/nine' }],
  );

  assert.equal(groups.length, 2);
  const emptyGroup = groups.find((group) => group.projectId === 'p9');
  assert.ok(emptyGroup);
  assert.equal(emptyGroup.isProjectArchived, true);
  assert.equal(emptyGroup.projectDisplayName, 'Empty archive');
  assert.equal(emptyGroup.projectPath, '/work/nine');
  assert.deepEqual(emptyGroup.sessions, []);
});

test('groupArchivedPickerSessions falls back to the project path when there is no project id', () => {
  const groups = groupArchivedPickerSessions([
    archivedSession({ sessionId: 'a1', projectId: null, projectPath: '/work/legacy' }),
    archivedSession({ sessionId: 'a2', projectId: null, projectPath: '/work/legacy' }),
  ]);

  assert.equal(groups.length, 1);
  assert.equal(groups[0].key, '/work/legacy');
  assert.equal(groups[0].sessions.length, 2);
});

test('archived filters match session titles and project names', () => {
  const sessions = [
    archivedSession({ sessionId: 'a1', sessionTitle: 'Old login work' }),
    archivedSession({ sessionId: 'a2', sessionTitle: 'Misc', projectDisplayName: 'Payments' }),
  ];

  assert.deepEqual(filterArchivedPickerSessions(sessions, 'LOGIN').map((s) => s.sessionId), ['a1']);
  assert.deepEqual(filterArchivedPickerSessions(sessions, 'payments').map((s) => s.sessionId), ['a2']);
  assert.equal(filterArchivedPickerSessions(sessions, '').length, 2);

  const projects = [
    { projectId: 'p1', displayName: 'Alpha' },
    { projectId: 'p2', displayName: 'Beta' },
  ];
  assert.deepEqual(filterArchivedProjects(projects, 'bet').map((p) => p.projectId), ['p2']);
  assert.equal(filterArchivedProjects(projects, '').length, 2);
});

test('formatPickerAge renders compact buckets', () => {
  const now = new Date('2026-09-17T12:00:00Z');

  assert.equal(formatPickerAge('2026-09-17T11:59:40Z', now), '<1m');
  assert.equal(formatPickerAge('2026-09-17T11:18:00Z', now), '42m');
  assert.equal(formatPickerAge('2026-09-17T09:00:00Z', now), '3hr');
  assert.equal(formatPickerAge('2026-09-15T12:00:00Z', now), '2d');
  assert.equal(formatPickerAge(null, now), '');
  assert.equal(formatPickerAge('not-a-date', now), '');
});

test('parseArchivedSessions keeps known fields and drops rows without an id', () => {
  const sessions = parseArchivedSessions({
    data: {
      sessions: [
        {
          sessionId: 'a1',
          provider: 'codex',
          projectId: 'p1',
          projectPath: '/work/one',
          projectDisplayName: 'Project One',
          sessionTitle: 'Old work',
          lastActivity: '2026-09-17T10:00:00Z',
          isProjectArchived: true,
          messageCount: 7,
          extra: 'ignored',
        },
        { sessionTitle: 'no id' },
        null,
      ],
    },
  });

  assert.equal(sessions.length, 1);
  assert.deepEqual(sessions[0], {
    sessionId: 'a1',
    provider: 'codex',
    projectId: 'p1',
    projectPath: '/work/one',
    projectDisplayName: 'Project One',
    sessionTitle: 'Old work',
    lastActivity: '2026-09-17T10:00:00Z',
    isProjectArchived: true,
    messageCount: 7,
  });
});

test('parseArchivedSessions tolerates junk payloads and falls back to the session id as title', () => {
  assert.deepEqual(parseArchivedSessions(null), []);
  assert.deepEqual(parseArchivedSessions({ data: { sessions: 'nope' } }), []);
  assert.deepEqual(parseArchivedSessions({ data: { sessions: [{}] } }), []);

  const [session] = parseArchivedSessions({ data: { sessions: [{ sessionId: 'a1' }] } });
  assert.equal(session.sessionTitle, 'a1');
  assert.equal(session.projectId, null);
  assert.equal(session.isProjectArchived, false);
  assert.equal(session.messageCount, 0);
});

test('parseArchivedProjects keeps rows with an id and falls back to the id as name', () => {
  const projects = parseArchivedProjects({
    data: {
      projects: [
        { projectId: 'p1', displayName: 'Alpha', fullPath: '/work/alpha' },
        { projectId: 'p2' },
        { displayName: 'no id' },
      ],
    },
  });

  assert.deepEqual(projects, [
    { projectId: 'p1', displayName: 'Alpha', fullPath: '/work/alpha' },
    { projectId: 'p2', displayName: 'p2', fullPath: undefined },
  ]);

  assert.deepEqual(parseArchivedProjects(undefined), []);
});

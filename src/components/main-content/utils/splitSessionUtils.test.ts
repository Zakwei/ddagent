import assert from 'node:assert/strict';
import test from 'node:test';

import type { ProjectSession } from '../../../types/app';

import { getAvailableSplitSessions } from './splitSessionUtils';

test('getAvailableSplitSessions returns sessions excluding the primary session', () => {
  const sessions: ProjectSession[] = [
    { id: 's1', title: 'Session 1' },
    { id: 's2', title: 'Session 2' },
    { id: 's3', title: 'Session 3' },
  ];

  const available = getAvailableSplitSessions(sessions, 's1');
  assert.equal(available.length, 2);
  assert.deepEqual(available.map((s) => s.id), ['s2', 's3']);

  assert.deepEqual(getAvailableSplitSessions([], 's1'), []);
  assert.deepEqual(getAvailableSplitSessions(undefined, 's1'), []);
});

test('getAvailableSplitSessions collects and prioritizes candidates across multiple projects', () => {
  const projects = [
    {
      projectId: 'proj-1',
      name: 'Project One',
      sessions: [
        { id: 's1', title: 'Session 1', lastActivity: '2026-09-17T10:00:00Z' },
        { id: 's2', title: 'Session 2', lastActivity: '2026-09-17T12:00:00Z' },
      ],
    },
    {
      projectId: 'proj-2',
      name: 'Project Two',
      sessions: [
        { id: 's3', title: 'Session 3', lastActivity: '2026-09-17T14:00:00Z' },
        { id: 's4', title: 'Session 4', lastActivity: '2026-09-17T09:00:00Z' },
      ],
    },
  ];

  // Primary session is s1 in proj-1.
  // Candidates should exclude s1.
  // Current project sessions (s2) should be listed first, followed by proj-2 sessions (s3, s4) sorted by date.
  const candidates = getAvailableSplitSessions(projects as any, 's1', 'proj-1');
  assert.equal(candidates.length, 3);
  assert.equal(candidates[0].id, 's2');
  assert.equal(candidates[0].isCurrentProject, true);
  assert.equal(candidates[1].id, 's3');
  assert.equal(candidates[1].projectName, 'Project Two');
  assert.equal(candidates[2].id, 's4');
});

test('getAvailableSplitSessions treats the sole contributing project as current when the id is unresolved', () => {
  const projects = [
    {
      projectId: 'proj-1',
      name: 'Project One',
      sessions: [
        { id: 's1', title: 'Session 1' },
        { id: 's2', title: 'Session 2' },
      ],
    },
    { projectId: 'proj-empty', name: 'No sessions', sessions: [] },
  ];

  // Unset or mismatched ids must not push the active project's sessions into
  // the "Other projects" group.
  for (const unresolvedId of [undefined, null, 'missing-project']) {
    const candidates = getAvailableSplitSessions(projects as any, 's1', unresolvedId);
    assert.equal(candidates.length, 1);
    assert.equal(candidates[0].id, 's2');
    assert.equal(candidates[0].isCurrentProject, true);
  }
});

test('getAvailableSplitSessions keeps sessions ungrouped when several projects contribute and the id is unresolved', () => {
  const projects = [
    { projectId: 'proj-1', name: 'Project One', sessions: [{ id: 's1' }] },
    { projectId: 'proj-2', name: 'Project Two', sessions: [{ id: 's2' }] },
  ];

  const candidates = getAvailableSplitSessions(projects as any, null, undefined);
  assert.equal(candidates.length, 2);
  assert.ok(candidates.every((session) => session.isCurrentProject === false));
});

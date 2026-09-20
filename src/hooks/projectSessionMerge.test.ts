import assert from 'node:assert/strict';
import test from 'node:test';

import type { Project, ProjectSession } from '../types/app';

import {
  getProjectSessions,
  isSubagentSession,
  isSubagentSessionTitle,
  mergeExpandedSessionPages,
  mergeProjectSessionPage,
} from './projectSessionMerge';

function session(id: string): ProjectSession {
  return { id, summary: id };
}

function project(projectId: string, sessions: ProjectSession[], total = sessions.length): Project {
  return {
    projectId,
    displayName: projectId,
    fullPath: `/${projectId}`,
    sessions,
    sessionMeta: { total, hasMore: false },
  };
}

test('sessions moved to another project are not restored to the old one', () => {
  const previous = [project('old', [session('moved'), session('stays')], 2), project('new', [], 1)];
  const incoming = [project('old', [session('stays')], 1), project('new', [session('moved')], 1)];

  const merged = mergeExpandedSessionPages(previous, incoming);

  assert.deepEqual(
    merged.map((entry) => [entry.projectId, (entry.sessions ?? []).map((item) => item.id)]),
    [
      ['old', ['stays']],
      ['new', ['moved']],
    ],
  );
});

test('shrunk pages keep sessions still absent from every incoming project', () => {
  const previous = [project('loads', [session('visible'), session('notFetchedYet')], 5)];
  const incoming = [project('loads', [session('visible')], 5)];

  const merged = mergeExpandedSessionPages(previous, incoming);

  assert.deepEqual((merged[0].sessions ?? []).map((item) => item.id), ['visible', 'notFetchedYet']);
  assert.equal(merged[0].sessionMeta?.hasMore, true);
});

test('session page fragments merge without duplicating a session id', () => {
  const existing = project('p', [session('a')], 3);
  const merged = mergeProjectSessionPage(existing, { sessions: [session('a'), session('b')], sessionMeta: { total: 3, hasMore: true } });

  assert.deepEqual((merged.sessions ?? []).map((item) => item.id), ['a', 'b']);
});

test('isSubagentSession correctly identifies subagents and excludes them from project sessions', () => {
  assert.equal(isSubagentSessionTitle('Implement backend fixes (@subagents/code/coder subagent)'), true);
  assert.equal(isSubagentSessionTitle('Review commits (@subagents/code/reviewer subagent)'), true);
  assert.equal(isSubagentSessionTitle('Explore files (@explore subagent)'), true);
  assert.equal(isSubagentSessionTitle('Worker task (subagent)'), true);
  assert.equal(isSubagentSessionTitle('Regular User Session'), false);
  assert.equal(isSubagentSessionTitle(null), false);
  assert.equal(isSubagentSessionTitle(undefined), false);

  const main = { id: 's1', summary: 'Main user chat' };
  const sub1 = { id: 's2', summary: 'Coder subtask (@subagents/code/coder subagent)' };
  const sub2 = { id: 's3', name: 'Review subtask (@subagents/code/reviewer subagent)' };

  assert.equal(isSubagentSession(main), false);
  assert.equal(isSubagentSession(sub1), true);
  assert.equal(isSubagentSession(sub2), true);

  const proj = project('p1', [main, sub1, sub2]);
  const visible = getProjectSessions(proj);
  assert.deepEqual(visible.map((s) => s.id), ['s1']);
});

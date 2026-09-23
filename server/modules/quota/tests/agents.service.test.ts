import assert from 'node:assert/strict';
import test from 'node:test';

import { createAgentFleetService } from '@/modules/quota/services/agents.service.js';
import type { InsightSession } from '@/modules/quota/services/insights-source.service.js';
import type { KanbanCard } from '@/shared/types.js';

const NOW = Date.parse('2026-01-02T12:00:00.000Z');

function makeCard(patch: Partial<KanbanCard> = {}): KanbanCard {
  return {
    cardId: 'card-0001',
    projectId: 'p1',
    title: 'Build feature',
    description: '',
    status: 'working',
    position: 0,
    sessionId: 'sess-1',
    provider: 'opencode',
    model: 'sonnet',
    effort: null,
    worktreePath: null,
    branch: null,
    prUrl: null,
    statusMessage: null,
    assigneeUserId: null,
    isArchived: false,
    createdAt: '2026-01-02T10:00:00.000Z',
    updatedAt: '2026-01-02T10:00:00.000Z',
    ...patch,
  };
}

function makeSession(patch: Partial<InsightSession> = {}): InsightSession {
  return {
    source: 'opencode',
    sourceId: 'sess-done',
    title: 'Old run',
    agent: 'builder',
    model: 'sonnet',
    subscription: 'go',
    provider: 'opencode',
    tokensInput: 100,
    tokensOutput: 50,
    tokensReasoning: 0,
    tokensCacheRead: 0,
    tokensCacheWrite: 0,
    apiCalls: 1,
    costUsd: 0.5,
    startedAt: NOW / 1000 - 600,
    endedAt: NOW / 1000 - 60,
    ...patch,
  };
}

test('marks a live run as running and names its kanban task', () => {
  const service = createAgentFleetService({
    listRunningRuns: () => [
      { sessionId: 'sess-1', provider: 'opencode', startedAt: NOW - 60_000, lastSeq: 3 },
    ],
    listKanbanCards: () => [makeCard()],
    listSessions: () => [],
    now: () => NOW,
  });

  const snapshot = service.getSnapshot();
  assert.equal(snapshot.summary.running, 1);
  assert.equal(snapshot.entries[0].status, 'running');
  assert.equal(snapshot.entries[0].taskTitle, 'Build feature');
  assert.equal(snapshot.entries[0].taskId, 'card-0001');
  assert.equal(snapshot.entries[0].retryCount, null);
});

test('derives queued and waiting agents from cards without live runs', () => {
  const service = createAgentFleetService({
    listRunningRuns: () => [],
    listKanbanCards: () => [
      makeCard({ cardId: 'c1', status: 'ready', sessionId: null }),
      makeCard({ cardId: 'c2', status: 'needs_decision', sessionId: null }),
    ],
    listSessions: () => [],
    now: () => NOW,
  });

  const snapshot = service.getSnapshot();
  assert.equal(snapshot.summary.queued, 1);
  assert.equal(snapshot.summary.waiting, 1);
  assert.equal(snapshot.summary.running, 0);
});

test('adds recently finished sessions and ignores old ones', () => {
  const service = createAgentFleetService({
    listRunningRuns: () => [],
    listKanbanCards: () => [],
    listSessions: () => [
      makeSession({ sourceId: 'recent' }),
      makeSession({ sourceId: 'old', startedAt: NOW / 1000 - 200_000, endedAt: NOW / 1000 - 190_000 }),
    ],
    now: () => NOW,
  });

  const snapshot = service.getSnapshot();
  assert.equal(snapshot.summary.finished, 1);
  assert.equal(snapshot.entries[0].sessionId, 'recent');
  assert.equal(snapshot.entries[0].tokensTotal, 150);
});

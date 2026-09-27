import assert from 'node:assert/strict';
import test from 'node:test';

import React from 'react';
import { renderToStaticMarkup } from 'react-dom/server';

import {
  filterSelectableSessions,
  getSelectAllSessionIds,
  getSelectOrchestratorSessionIds,
  hasSelectableOrchestrators,
  isOrchestratorSession,
} from '../../utils/broadcastSessionUtils';
import type { SplitSessionCandidate } from '../../utils/splitSessionUtils';

import BroadcastDialog from './BroadcastDialog';

const noop = () => {};

function makeSession(
  id: string,
  provider?: string | null,
  isArchived = false,
  extra?: Partial<SplitSessionCandidate>,
): SplitSessionCandidate {
  return {
    id,
    sessionId: id,
    title: `Session ${id}`,
    projectName: 'TestProject',
    projectId: 'p1',
    isCurrentProject: true,
    isArchived,
    provider: provider as any,
    ...extra,
  };
}

// ---------------------------------------------------------------------------
// 1. Filtrowanie sesji według providera
// ---------------------------------------------------------------------------

test('isOrchestratorSession identifies orchestrator via provider or __provider', () => {
  assert.equal(isOrchestratorSession({ provider: 'orchestrator' }), true);
  assert.equal(isOrchestratorSession({ __provider: 'orchestrator' }), true);
  assert.equal(isOrchestratorSession({ provider: 'orchestrator', __provider: 'claude' }), true);

  // Non-orchestrator providers
  assert.equal(isOrchestratorSession({ provider: 'claude' }), false);
  assert.equal(isOrchestratorSession({ provider: 'codex' }), false);
  assert.equal(isOrchestratorSession({ provider: 'cursor' }), false);
  assert.equal(isOrchestratorSession({ provider: 'devin' }), false);
  assert.equal(isOrchestratorSession({ provider: undefined }), false);
  assert.equal(isOrchestratorSession({ provider: null }), false);
  assert.equal(isOrchestratorSession({}), false);
});

test('filtering excludes archived sessions even if provider is orchestrator', () => {
  const sessions = [
    makeSession('s1', 'orchestrator', false),
    makeSession('s2', 'orchestrator', true), // archived
  ];

  const selectable = filterSelectableSessions(sessions);
  assert.equal(selectable.length, 1);
  assert.equal(selectable[0].id, 's1');

  const orchestratorIds = getSelectOrchestratorSessionIds(sessions);
  assert.deepEqual(orchestratorIds, ['s1']);
});

// ---------------------------------------------------------------------------
// 2. Zachowanie przy liście mieszanej
// ---------------------------------------------------------------------------

test('mixed list: getSelectOrchestratorSessionIds selects strictly orchestrators', () => {
  const mixedSessions = [
    makeSession('s-orch-1', 'orchestrator'),
    makeSession('s-claude', 'claude'),
    makeSession('s-orch-2', undefined, false, { __provider: 'orchestrator' as any }),
    makeSession('s-cursor', 'cursor'),
    makeSession('s-devin', 'devin'),
    makeSession('s-orch-archived', 'orchestrator', true),
  ];

  const selectedIds = getSelectOrchestratorSessionIds(mixedSessions);
  assert.deepEqual(selectedIds, ['s-orch-1', 's-orch-2']);

  // Verify none of the non-orchestrator or archived sessions are present
  assert.ok(!selectedIds.includes('s-claude'));
  assert.ok(!selectedIds.includes('s-cursor'));
  assert.ok(!selectedIds.includes('s-devin'));
  assert.ok(!selectedIds.includes('s-orch-archived'));
});

test('mixed list: selecting orchestrators replaces previous selection, deselecting others', () => {
  const mixedSessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'orchestrator'),
    makeSession('s3', 'cursor'),
    makeSession('s4', 'orchestrator'),
  ];

  // User initially had non-orchestrator sessions selected
  let currentSelected = new Set(['s1', 's3']);

  // User clicks "Select orchestrators"
  currentSelected = new Set(getSelectOrchestratorSessionIds(mixedSessions));

  assert.equal(currentSelected.size, 2);
  assert.ok(currentSelected.has('s2'));
  assert.ok(currentSelected.has('s4'));
  assert.ok(!currentSelected.has('s1'), 's1 (claude) should be deselected');
  assert.ok(!currentSelected.has('s3'), 's3 (cursor) should be deselected');
});

// ---------------------------------------------------------------------------
// 3. Brak zaznaczenia przy braku orchestratorów
// ---------------------------------------------------------------------------

test('returns empty selection when no orchestrator sessions are present', () => {
  const noOrchestrators = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'cursor'),
    makeSession('s3', 'codex'),
  ];

  assert.equal(hasSelectableOrchestrators(noOrchestrators), false);
  const selectedIds = getSelectOrchestratorSessionIds(noOrchestrators);
  assert.deepEqual(selectedIds, []);
  assert.equal(new Set(selectedIds).size, 0);
});

test('returns empty selection when all orchestrators are archived', () => {
  const onlyArchivedOrchestrator = [
    makeSession('s1', 'claude', false),
    makeSession('s2', 'orchestrator', true),
  ];

  assert.equal(hasSelectableOrchestrators(onlyArchivedOrchestrator), false);
  const selectedIds = getSelectOrchestratorSessionIds(onlyArchivedOrchestrator);
  assert.deepEqual(selectedIds, []);
});

test('handles empty sessions array gracefully', () => {
  assert.equal(hasSelectableOrchestrators([]), false);
  assert.deepEqual(getSelectOrchestratorSessionIds([]), []);
  assert.deepEqual(getSelectAllSessionIds([]), []);
});

// ---------------------------------------------------------------------------
// 4. Współdziałanie z opcją 'Select all'
// ---------------------------------------------------------------------------

test('interaction: Select all -> Select orchestrators narrows selection to orchestrators only', () => {
  const sessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'orchestrator'),
    makeSession('s3', 'cursor'),
    makeSession('s4', 'orchestrator'),
  ];

  // 1. Click "Select all"
  let selected = new Set(getSelectAllSessionIds(sessions));
  assert.equal(selected.size, 4);
  assert.deepEqual([...selected].sort(), ['s1', 's2', 's3', 's4']);

  // 2. Click "Select orchestrators"
  selected = new Set(getSelectOrchestratorSessionIds(sessions));
  assert.equal(selected.size, 2);
  assert.deepEqual([...selected].sort(), ['s2', 's4']);
});

test('interaction: Select orchestrators -> Select all expands selection to all sessions', () => {
  const sessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'orchestrator'),
    makeSession('s3', 'cursor'),
    makeSession('s4', 'orchestrator'),
  ];

  // 1. Click "Select orchestrators"
  let selected = new Set(getSelectOrchestratorSessionIds(sessions));
  assert.equal(selected.size, 2);
  assert.deepEqual([...selected].sort(), ['s2', 's4']);

  // 2. Click "Select all"
  selected = new Set(getSelectAllSessionIds(sessions));
  assert.equal(selected.size, 4);
  assert.deepEqual([...selected].sort(), ['s1', 's2', 's3', 's4']);
});

test('orchestrator selection is a strict subset of select-all in a mixed list', () => {
  const sessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'orchestrator'),
    makeSession('s3', 'cursor'),
  ];

  const allIds = new Set(getSelectAllSessionIds(sessions));
  const orchIds = getSelectOrchestratorSessionIds(sessions);

  assert.equal(orchIds.length, 1);
  for (const id of orchIds) {
    assert.ok(allIds.has(id), `Orchestrator id ${id} must be in allIds`);
  }
  assert.ok(orchIds.length < allIds.size, 'Orchestrators must be a strict subset');
});

// ---------------------------------------------------------------------------
// 5. Weryfikacja renderowania przycisków w BroadcastDialog
// ---------------------------------------------------------------------------

test('renders Select orchestrators button when at least one orchestrator session is present', () => {
  const sessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'orchestrator'),
  ];

  const html = renderToStaticMarkup(
    React.createElement(BroadcastDialog, {
      open: true,
      onClose: noop,
      sessions,
    }),
  );

  assert.ok(html.includes('Select all'));
  assert.ok(html.includes('Select orchestrators'));
});

test('does NOT render Select orchestrators button when no orchestrator sessions exist', () => {
  const sessions = [
    makeSession('s1', 'claude'),
    makeSession('s2', 'cursor'),
  ];

  const html = renderToStaticMarkup(
    React.createElement(BroadcastDialog, {
      open: true,
      onClose: noop,
      sessions,
    }),
  );

  assert.ok(html.includes('Select all'));
  assert.ok(!html.includes('Select orchestrators'));
});

test('does NOT render Select orchestrators button when orchestrators are archived', () => {
  const sessions = [
    makeSession('s1', 'claude', false),
    makeSession('s2', 'orchestrator', true), // archived
  ];

  const html = renderToStaticMarkup(
    React.createElement(BroadcastDialog, {
      open: true,
      onClose: noop,
      sessions,
    }),
  );

  assert.ok(html.includes('Select all'));
  assert.ok(!html.includes('Select orchestrators'));
});

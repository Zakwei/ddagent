import assert from 'node:assert/strict';
import test from 'node:test';

import type { NormalizedMessage } from './useSessionStore';
import { computeMerged } from './useSessionStore';

const SESSION_ID = 'session-1';

const msg = (
  id: string,
  timestamp: string,
  overrides: Partial<NormalizedMessage> = {},
): NormalizedMessage => ({
  id,
  sessionId: SESSION_ID,
  timestamp,
  provider: 'devin',
  kind: 'text',
  ...overrides,
});

const countByText = (list: NormalizedMessage[], text: string) =>
  list.filter((m) => m.kind === 'text' && (m.content || '').includes(text)).length;

test('drops a streamed assistant copy even when a stale realtime user row shifts the turn ordinal', () => {
  // Regression: a finalized stream row + its persisted twin rendered twice.
  // A realtime user echo that never reconciled (own id, timestamp outside the
  // 3 s window) counted as an extra user turn, pushed the ordinal past the
  // real turn, and the assistant echo check could never match.
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
    msg('thinking_1', '2026-09-23T09:26:25.343Z', { kind: 'thinking', content: 'reasoning' }),
    msg('assistant_1', '2026-09-23T09:26:25.472Z', { role: 'assistant', content: '## Research answer' }),
    msg('user_2', '2026-09-23T09:30:25.029Z', { role: 'user', content: 'follow up' }),
  ];

  const realtime = [
    // Orphaned user echo of the first turn — different id than the persisted row.
    msg('user_echo_orphan', '2026-09-23T09:24:58.500Z', { role: 'user', content: 'first prompt' }),
    msg('text_rt1', '2026-09-23T09:25:52.000Z', { role: 'assistant', content: '## Research answer' }),
    msg('thinking_rt1', '2026-09-23T09:25:52.000Z', { kind: 'thinking', content: 'reasoning' }),
  ];

  const merged = computeMerged(server, realtime);

  assert.equal(countByText(merged, '## Research answer'), 1);
  assert.equal(merged.filter((m) => m.id === 'thinking_rt1').length, 0);
});

test('keeps a streamed assistant row while its text is not yet persisted', () => {
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
  ];
  const realtime = [
    msg('text_rt1', '2026-09-23T09:25:52.000Z', { role: 'assistant', content: 'still streaming…' }),
  ];

  const merged = computeMerged(server, realtime);
  assert.equal(merged.filter((m) => m.id === 'text_rt1').length, 1);
});

test('drops a replayed stream row rebuilt from buffered deltas', () => {
  // chat.subscribe replay rebuilds a __streaming_ row from raw deltas; once the
  // persisted copy is in the window the rebuilt row must not render twice.
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
    msg('assistant_1', '2026-09-23T09:26:25.472Z', { role: 'assistant', content: '## Research answer' }),
  ];
  const realtime = [
    {
      id: `__streaming_${SESSION_ID}`,
      sessionId: SESSION_ID,
      timestamp: '2026-09-23T09:25:52.000Z',
      provider: 'devin',
      kind: 'stream_delta',
      content: '## Research answer',
    } as NormalizedMessage,
  ];

  const merged = computeMerged(server, realtime);
  assert.equal(countByText(merged, '## Research answer'), 1);
});

const orchestratorStatus = (
  id: string,
  timestamp: string,
  context: Record<string, unknown>,
): NormalizedMessage =>
  msg(id, timestamp, {
    provider: 'orchestrator',
    kind: 'status',
    role: 'assistant',
    context,
    // Realtime handler pins the context fingerprint into content so the
    // appendRealtime same-id early-return still detects payload changes.
    content: JSON.stringify(context),
  });

test('drops a realtime orchestrator card once its context twin is persisted', () => {
  // Live frames carry no row id, so a history refresh would otherwise stack a
  // second delegation card next to the persisted row.
  const delegationContext = {
    orchestratorKind: 'delegation',
    stepId: 'step-1',
    title: 'Implement login',
    status: 'done',
  };
  const server = [
    msg('user_1', '2026-09-23T09:24:57.504Z', { role: 'user', content: 'first prompt' }),
    orchestratorStatus('db_delegation_1', '2026-09-23T09:26:00.000Z', delegationContext),
  ];
  const realtime = [
    orchestratorStatus('orch-live:session-1:1:delegation:step-1', '2026-09-23T09:26:00.000Z', delegationContext),
  ];

  const merged = computeMerged(server, realtime);
  const delegationRows = merged.filter(
    (m) => m.kind === 'status'
      && (m.context as Record<string, unknown> | undefined)?.orchestratorKind === 'delegation',
  );
  assert.equal(delegationRows.length, 1);
  assert.equal(delegationRows[0].id, 'db_delegation_1');
});

test('keeps a realtime orchestrator card whose payload is newer than the persisted row', () => {
  // Mid-run refresh: the DB row still says 'running' while a later live frame
  // already patched the card to 'done' — the realtime row must win.
  const server = [
    orchestratorStatus('db_delegation_1', '2026-09-23T09:26:00.000Z', {
      orchestratorKind: 'delegation',
      stepId: 'step-1',
      title: 'Implement login',
      status: 'running',
    }),
  ];
  const realtime = [
    orchestratorStatus('orch-live:session-1:1:delegation:step-1', '2026-09-23T09:26:05.000Z', {
      orchestratorKind: 'delegation',
      stepId: 'step-1',
      title: 'Implement login',
      status: 'done',
    }),
  ];

  const merged = computeMerged(server, realtime);
  const statuses = merged
    .filter((m) => m.kind === 'status')
    .map((m) => (m.context as Record<string, unknown>).status);
  assert.deepEqual(statuses, ['running', 'done']);
});

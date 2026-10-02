import assert from 'node:assert/strict';
import test from 'node:test';

import type { OrchestratorMessage } from '@/shared/types.js';
import { createOrchestratorStatusFrame } from '@/shared/utils.js';

const ENTRY: OrchestratorMessage = {
  id: 7,
  sessionId: 'parent-1',
  seq: 3,
  kind: 'delegation',
  payload: {
    stepId: 'step-1',
    provider: 'devin',
    model: 'swe-2-medium',
    status: 'running',
    childSessionId: 'child-1',
  },
  createdAt: '2026-01-01T00:00:00.000Z',
};

test('successive status frames for the same entry never share an id', () => {
  // Regression: the live publishers used to emit id-less frames, so every
  // status change after the first collided on `id === ''` in the client's
  // realtime dedupe and the open session showed a stale task status.
  const first = createOrchestratorStatusFrame(ENTRY);
  const second = createOrchestratorStatusFrame(ENTRY);

  assert.ok(first.id.length > 0);
  assert.ok(second.id.length > 0);
  assert.notEqual(first.id, second.id);
});

test('patches to one delegation row stay deliverable as distinct frames', () => {
  const running = createOrchestratorStatusFrame(ENTRY);
  const done = createOrchestratorStatusFrame({
    ...ENTRY,
    payload: { ...ENTRY.payload, status: 'done', finalText: 'answer' },
  });

  assert.notEqual(running.id, done.id);
  assert.equal((running.context as Record<string, unknown>).status, 'running');
  assert.equal((done.context as Record<string, unknown>).status, 'done');
});

test('the frame matches the history envelope the client renders', () => {
  const frame = createOrchestratorStatusFrame(ENTRY);

  assert.equal(frame.kind, 'status');
  assert.equal(frame.provider, 'orchestrator');
  assert.equal(frame.sessionId, 'parent-1');
  assert.equal(frame.role, 'assistant');
  assert.equal(frame.summary, 'delegation');
  assert.ok(!Number.isNaN(Date.parse(frame.timestamp)));

  const context = frame.context as Record<string, unknown>;
  assert.equal(context.orchestratorKind, 'delegation');
  assert.equal(context.stepId, 'step-1');
  assert.equal(context.childSessionId, 'child-1');
});

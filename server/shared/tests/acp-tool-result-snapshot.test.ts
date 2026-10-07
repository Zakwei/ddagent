import assert from 'node:assert/strict';
import test from 'node:test';

import { foldAcpToolResultSnapshot } from '@/shared/utils.js';

test('foldAcpToolResultSnapshot keeps the last non-empty content and a sticky error', () => {
  const snapshots = new Map<string, { content: string; isError: boolean }>();

  assert.deepEqual(foldAcpToolResultSnapshot(snapshots, 't1', '', false), { content: '', isError: false });
  assert.deepEqual(foldAcpToolResultSnapshot(snapshots, 't1', 'partial', false), { content: 'partial', isError: false });
  assert.deepEqual(foldAcpToolResultSnapshot(snapshots, 't1', 'MCP tool failed', true), { content: 'MCP tool failed', isError: true });
  // The trailing empty snapshot must not blank the output or clear the error.
  assert.deepEqual(foldAcpToolResultSnapshot(snapshots, 't1', '', false), { content: 'MCP tool failed', isError: true });
  // Calls are tracked independently.
  assert.deepEqual(foldAcpToolResultSnapshot(snapshots, 't2', 'ok', false), { content: 'ok', isError: false });
});

test('foldAcpToolResultSnapshot caps the tracked calls, evicting the oldest', () => {
  const snapshots = new Map<string, { content: string; isError: boolean }>();
  for (let index = 0; index < 501; index += 1) {
    foldAcpToolResultSnapshot(snapshots, `t${index}`, 'out', false);
  }
  assert.equal(snapshots.size, 500);
  assert.equal(snapshots.has('t0'), false);
  assert.equal(snapshots.has('t500'), true);
});

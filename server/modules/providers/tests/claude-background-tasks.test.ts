import assert from 'node:assert/strict';
import test from 'node:test';

// NOTE: the providers barrel must evaluate before the direct runtime import —
// importing claude-runtime first trips the registry → provider → runtime cycle.
import '@/modules/providers/index.js';
import { trackBackgroundTask } from '@/modules/providers/list/claude/claude-runtime.provider.js';

const started = (taskId: string, extra: Record<string, unknown> = {}) => ({
  type: 'system',
  subtype: 'task_started',
  task_id: taskId,
  description: 'background agent',
  ...extra,
});

test('a subagent still running after a sibling reports back keeps the hold', () => {
  const outstanding = new Map();
  trackBackgroundTask(outstanding, started('a'));
  trackBackgroundTask(outstanding, started('b'));

  trackBackgroundTask(outstanding, { type: 'system', subtype: 'task_notification', task_id: 'a', status: 'completed' });
  assert.deepEqual([...outstanding.keys()], ['b']);

  trackBackgroundTask(outstanding, { type: 'system', subtype: 'task_notification', task_id: 'b', status: 'failed' });
  assert.equal(outstanding.size, 0);
});

test('a terminal task_updated settles a task; a non-terminal one does not', () => {
  const outstanding = new Map();
  trackBackgroundTask(outstanding, started('a'));

  trackBackgroundTask(outstanding, { type: 'system', subtype: 'task_updated', task_id: 'a', patch: { status: 'running' } });
  assert.equal(outstanding.size, 1);

  trackBackgroundTask(outstanding, { type: 'system', subtype: 'task_updated', task_id: 'a', patch: { status: 'killed' } });
  assert.equal(outstanding.size, 0);
});

test('a running task keeps its description and kind for the client', () => {
  const outstanding = new Map();
  trackBackgroundTask(outstanding, started('a', { description: 'Run checkout tests', task_type: 'local_bash' }));
  assert.deepEqual(outstanding.get('a'), { id: 'a', description: 'Run checkout tests', type: 'local_bash' });
});

test('ambient tasks and unrelated messages are ignored', () => {
  const outstanding = new Map();
  trackBackgroundTask(outstanding, started('ambient', { skip_transcript: true }));
  trackBackgroundTask(outstanding, { type: 'assistant', message: { content: [] } });
  trackBackgroundTask(outstanding, { type: 'system', subtype: 'init' });
  assert.equal(outstanding.size, 0);
});

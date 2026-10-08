import assert from 'node:assert/strict';
import test from 'node:test';

import { buildCursorToolCallMessages } from '@/modules/providers/list/cursor/cursor-runtime.provider.js';

test('cursor: tool_call started/completed events become paired tool rows', () => {
  const [use] = buildCursorToolCallMessages({
    type: 'tool_call', subtype: 'started', call_id: 'call_1',
    tool_call: { shellToolCall: { args: { command: 'ls' } } },
  }, 'app');
  assert.equal(use.kind, 'tool_use');
  assert.equal(use.toolId, 'call_1');
  assert.equal(use.toolName, 'Bash');
  assert.deepEqual(use.toolInput, { command: 'ls' });

  const [result] = buildCursorToolCallMessages({
    type: 'tool_call', subtype: 'completed', call_id: 'call_1',
    tool_call: { shellToolCall: { args: { command: 'ls' }, result: { success: { exitCode: 0, stdout: 'a.ts' } } } },
  }, 'app');
  assert.equal(result.kind, 'tool_result');
  assert.equal(result.toolId, 'call_1');
  assert.equal(result.content, 'a.ts');
  assert.equal(result.isError, false);
});

test('cursor: failed and MCP tool calls keep their error and name', () => {
  const [failed] = buildCursorToolCallMessages({
    subtype: 'completed', call_id: 'call_2',
    tool_call: { readToolCall: { args: { path: 'x' }, result: { error: { message: 'not found' } } } },
  }, 'app');
  assert.equal(failed.isError, true);
  assert.equal(failed.content, 'not found');

  const [mcp] = buildCursorToolCallMessages({
    subtype: 'started', call_id: 'call_3',
    tool_call: { function: { name: 'get_task', arguments: '{"id":7}' } },
  }, 'app');
  assert.equal(mcp.toolName, 'get_task');
  assert.deepEqual(mcp.toolInput, { id: 7 });

  assert.deepEqual(buildCursorToolCallMessages({ subtype: 'started', tool_call: {} }, 'app'), []);
});

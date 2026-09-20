import assert from 'node:assert/strict';
import test from 'node:test';

import type { ChatMessage } from '../types/types';

import { groupConsecutiveTools, isToolGroupItem, TOOL_GROUP_THRESHOLD } from './toolGrouping';

const tool = (toolName: string): ChatMessage =>
  ({ isToolUse: true, toolName }) as unknown as ChatMessage;

test('groups a run of the same repeated tool', () => {
  const items = groupConsecutiveTools([tool('Read'), tool('Read'), tool('Read')]);
  assert.equal(items.length, 1);
  assert.ok(isToolGroupItem(items[0]));
  assert.equal((items[0] as any).toolName, 'Read');
  assert.equal((items[0] as any).messages.length, 3);
});

test('runs shorter than the threshold stay expanded', () => {
  const items = groupConsecutiveTools([tool('Bash'), tool('Bash')]);
  assert.equal(items.length, 2);
  assert.ok(items.every((i) => !isToolGroupItem(i)));
  assert.ok(TOOL_GROUP_THRESHOLD > 2);
});

test('a different tool breaks the run', () => {
  const items = groupConsecutiveTools([tool('Bash'), tool('Grep'), tool('Bash')]);
  assert.equal(items.length, 3);
  assert.ok(items.every((i) => !isToolGroupItem(i)));
});

test('edits never get grouped', () => {
  const items = groupConsecutiveTools([tool('Edit'), tool('Edit'), tool('Edit'), tool('Edit')]);
  assert.equal(items.length, 4);
  assert.ok(items.every((i) => !isToolGroupItem(i)));
});

test('an edit in the middle splits two runs', () => {
  const items = groupConsecutiveTools([
    tool('Bash'),
    tool('Bash'),
    tool('Bash'),
    tool('Edit'),
    tool('Bash'),
    tool('Bash'),
    tool('Bash'),
  ]);
  assert.deepEqual(items.map((i) => (isToolGroupItem(i) ? `group:${i.toolName}` : i.toolName)), [
    'group:Bash',
    'Edit',
    'group:Bash',
  ]);
});

test('hidden reasoning does not break a run', () => {
  const items = groupConsecutiveTools([
    tool('Read'),
    { isThinking: true } as unknown as ChatMessage,
    tool('Read'),
    tool('Read'),
  ], false);
  assert.equal(items.length, 1);
  assert.ok(isToolGroupItem(items[0]));
  assert.equal((items[0] as any).messages.length, 3);
});

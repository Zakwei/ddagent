import assert from 'node:assert/strict';
import test from 'node:test';

import type { NormalizedMessage } from '../../../stores/useSessionStore';
import type { ChatMessage } from '../types/types';

import { MIN_VISIBLE_TEXT_MESSAGES, normalizedToChatMessages, sliceVisibleMessages } from './useChatMessages';

const text = (id: string): ChatMessage => ({
  type: 'assistant',
  content: id,
  id,
  timestamp: new Date(),
});
const tool = (id: string): ChatMessage => ({
  type: 'assistant',
  content: '',
  id,
  timestamp: new Date(),
  isToolUse: true,
});

test('sliceVisibleMessages keeps the tail window when it already ends on text', () => {
  const messages = [text('a'), tool('t1'), text('b'), tool('t2'), text('c')];

  assert.deepEqual(
    sliceVisibleMessages(messages, 3).map((message) => message.id),
    ['b', 't2', 'c'],
  );
});

test('sliceVisibleMessages reaches back to the last text messages when tools flood the tail', () => {
  const tools = Array.from({ length: 60 }, (_, index) => tool(`t${index}`));
  const messages = [text('reply-1'), text('user-2'), ...tools];

  // A 40-message window would show tools only; the anchored window must keep
  // the conversation tail (the assistant reply and the prompt it answers).
  const visible = sliceVisibleMessages(messages, 40);

  assert.equal(visible[0].id, 'reply-1');
  assert.equal(visible.length, messages.length);
});

test('sliceVisibleMessages returns everything when the window covers the session', () => {
  const messages = [text('a'), tool('t1')];

  assert.deepEqual(sliceVisibleMessages(messages, 40), messages);
});

test('sliceVisibleMessages defaults to the documented text anchor', () => {
  assert.equal(MIN_VISIBLE_TEXT_MESSAGES, 2);
});

test('normalizedToChatMessages attaches the newest tool result that carries output', () => {
  const base = {
    sessionId: 'session-1',
    provider: 'devin',
    timestamp: '2026-09-20T20:00:00.000Z',
  };
  const result = (content: string) => ({
    ...base,
    id: 'call_1__result',
    kind: 'tool_result' as const,
    toolId: 'call_1',
    content,
  });
  const rows = normalizedToChatMessages([
    { ...base, id: 'call_1', kind: 'tool_use', toolName: 'exec', toolId: 'call_1', toolInput: '{}' },
    result(''),
    result('full output'),
    result(''),
  ] as unknown as NormalizedMessage[]);

  const toolRow = rows.find((row) => row.isToolUse);
  assert.equal(toolRow?.toolResult?.content, 'full output');
});

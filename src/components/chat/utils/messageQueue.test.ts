import assert from 'node:assert/strict';
import test from 'node:test';

import { parseMessages } from './messageQueue';

const message = {
  id: 1,
  sessionId: 'session-1',
  content: 'hello',
  options: {},
  status: 'queued',
  error: null,
  createdAt: '2026-01-01T00:00:00.000Z',
  updatedAt: '2026-01-01T00:00:00.000Z',
};

test('parseMessages reads the { data: { messages } } API envelope', () => {
  const parsed = parseMessages({ data: { messages: [message] } });
  assert.equal(parsed.length, 1);
  assert.equal(parsed[0].content, 'hello');
});

test('parseMessages also accepts a bare { messages } object', () => {
  assert.equal(parseMessages({ messages: [message] }).length, 1);
});

test('parseMessages drops entries missing an id or content', () => {
  const parsed = parseMessages({
    messages: [message, { id: 2 }, { content: 'no id' }, null, 'nope'],
  });
  assert.equal(parsed.length, 1);
  assert.equal(parsed[0].id, 1);
});

test('parseMessages returns an empty list for unexpected payloads', () => {
  assert.deepEqual(parseMessages(null), []);
  assert.deepEqual(parseMessages('nope'), []);
  assert.deepEqual(parseMessages({ data: 'nope' }), []);
  assert.deepEqual(parseMessages({ data: { messages: 'nope' } }), []);
});

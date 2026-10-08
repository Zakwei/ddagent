import assert from 'node:assert/strict';
import test from 'node:test';

import { ClaudeSessionsProvider } from '@/modules/providers/list/claude/claude-sessions.provider.js';

const SESSION_ID = 'session-1';

const SKILL_BODY = [
  'Base directory for this skill: /tmp/claude/bundled-skills/2.1.220/abc123/claude-api',
  '',
  '# Building LLM-Powered Applications with Claude',
  '',
  'This skill helps you build LLM-powered applications with Claude.',
].join('\n');

test('claude: injected skill bodies are hidden even without the isMeta flag', () => {
  const provider = new ClaudeSessionsProvider();

  // The live SDK stream omits `isMeta`, so the payload has to be recognised by
  // its content or it renders as a giant user bubble mid-run.
  const live = provider.normalizeMessage(
    {
      uuid: 'u1',
      timestamp: '2026-07-28T10:00:00.000Z',
      message: { role: 'user', content: [{ type: 'text', text: SKILL_BODY }] },
    },
    SESSION_ID,
  );
  assert.deepEqual(live, []);

  const persisted = provider.normalizeMessage(
    {
      uuid: 'u2',
      timestamp: '2026-07-28T10:00:00.000Z',
      isMeta: true,
      message: { role: 'user', content: [{ type: 'text', text: SKILL_BODY }] },
    },
    SESSION_ID,
  );
  assert.deepEqual(persisted, []);
});

test('claude: the Skill tool result itself still reaches the UI', () => {
  const provider = new ClaudeSessionsProvider();

  const messages = provider.normalizeMessage(
    {
      uuid: 'u3',
      timestamp: '2026-07-28T10:00:00.000Z',
      message: {
        role: 'user',
        content: [{ type: 'tool_result', tool_use_id: 'toolu_1', content: 'Launching skill: claude-api' }],
      },
    },
    SESSION_ID,
  );

  assert.equal(messages.length, 1);
  assert.equal(messages[0].kind, 'tool_result');
  assert.equal(messages[0].toolId, 'toolu_1');
});

/**
 * Builds one partial-message wrapper exactly as the SDK emits it when
 * `includePartialMessages` is enabled (SDKPartialAssistantMessage).
 */
function streamEvent(
  event: Record<string, unknown>,
  parentToolUseId: string | null = null,
): Record<string, unknown> {
  return {
    type: 'stream_event',
    event,
    parent_tool_use_id: parentToolUseId,
    uuid: 'evt-1',
    session_id: 'provider-session-1',
  };
}

test('claude: text deltas become incremental stream_delta frames', () => {
  const provider = new ClaudeSessionsProvider();

  const frames = provider.normalizeMessage(
    streamEvent({ type: 'content_block_delta', index: 0, delta: { type: 'text_delta', text: 'Hello' } }),
    SESSION_ID,
  );

  assert.equal(frames.length, 1);
  assert.equal(frames[0].kind, 'stream_delta');
  assert.equal(frames[0].content, 'Hello');
  assert.equal(frames[0].provider, 'claude');
  assert.equal(frames[0].sessionId, SESSION_ID);
});

test('claude: thinking deltas become incremental thought_delta frames', () => {
  const provider = new ClaudeSessionsProvider();

  const frames = provider.normalizeMessage(
    streamEvent({
      type: 'content_block_delta',
      index: 0,
      delta: { type: 'thinking_delta', thinking: 'Let me check the transcript' },
    }),
    SESSION_ID,
  );

  assert.equal(frames.length, 1);
  assert.equal(frames[0].kind, 'thought_delta');
  assert.equal(frames[0].content, 'Let me check the transcript');
  assert.equal(frames[0].provider, 'claude');
  assert.equal(frames[0].sessionId, SESSION_ID);
});

test('claude: message_stop closes the live rows with a stream_end frame', () => {
  const provider = new ClaudeSessionsProvider();

  const frames = provider.normalizeMessage(streamEvent({ type: 'message_stop' }), SESSION_ID);

  assert.equal(frames.length, 1);
  assert.equal(frames[0].kind, 'stream_end');
  assert.equal(frames[0].provider, 'claude');
  assert.equal(frames[0].sessionId, SESSION_ID);
});

test('claude: stream events that are not text/thinking deltas are not forwarded', () => {
  const provider = new ClaudeSessionsProvider();

  const ignoredEvents = [
    { type: 'message_start', message: { id: 'msg_1', usage: { input_tokens: 12 } } },
    { type: 'content_block_start', index: 0, content_block: { type: 'text', text: '' } },
    { type: 'content_block_delta', index: 0, delta: { type: 'input_json_delta', partial_json: '{"path":' } },
    { type: 'content_block_stop', index: 0 },
    { type: 'message_delta', delta: { stop_reason: 'end_turn' } },
  ];

  for (const event of ignoredEvents) {
    assert.deepEqual(provider.normalizeMessage(streamEvent(event), SESSION_ID), []);
  }
});

test('claude: empty deltas are dropped instead of opening an empty live row', () => {
  const provider = new ClaudeSessionsProvider();

  assert.deepEqual(
    provider.normalizeMessage(
      streamEvent({ type: 'content_block_delta', delta: { type: 'text_delta', text: '' } }),
      SESSION_ID,
    ),
    [],
  );
  assert.deepEqual(
    provider.normalizeMessage(
      streamEvent({ type: 'content_block_delta', delta: { type: 'thinking_delta', thinking: '' } }),
      SESSION_ID,
    ),
    [],
  );
});

test('claude: subagent partials stay out of the main live row', () => {
  const provider = new ClaudeSessionsProvider();

  const frames = provider.normalizeMessage(
    streamEvent({ type: 'content_block_delta', delta: { type: 'text_delta', text: 'subagent text' } }, 'toolu_parent'),
    SESSION_ID,
  );

  assert.deepEqual(frames, []);
});

test('claude: the complete assistant message keeps carrying the authoritative parts', () => {
  const provider = new ClaudeSessionsProvider();

  const messages = provider.normalizeMessage(
    {
      uuid: 'a1',
      timestamp: '2026-07-28T10:00:00.000Z',
      message: {
        role: 'assistant',
        content: [
          { type: 'thinking', thinking: 'Let me check the transcript' },
          { type: 'text', text: 'Hello' },
          { type: 'tool_use', id: 'toolu_1', name: 'Read', input: { file_path: '/tmp/a.txt' } },
        ],
      },
    },
    SESSION_ID,
  );

  // The complete copy still flows as today; the client dedupes it against the
  // streamed row by trimmed content, so no second bubble appears.
  assert.deepEqual(messages.map((message) => message.kind), ['thinking', 'text', 'tool_use']);
  assert.equal(messages[0].content, 'Let me check the transcript');
  assert.equal(messages[1].content, 'Hello');
  assert.equal(messages[2].toolId, 'toolu_1');
});

test('claude: transcript rows never normalize into live stream frames', () => {
  const provider = new ClaudeSessionsProvider();

  // The JSONL transcript is written by the Claude CLI from complete messages
  // only. Only the live `stream_event` wrapper may produce stream frames, so a
  // transcript-shaped row (even one mimicking a raw streaming event) must not
  // become a live frame that would resurface as a stale bubble on reload.
  const persistedRows: Array<Record<string, unknown>> = [
    {
      type: 'assistant',
      uuid: 'a2',
      timestamp: '2026-07-28T10:00:00.000Z',
      message: { role: 'assistant', content: [{ type: 'text', text: 'Hello' }] },
    },
    { type: 'content_block_delta', delta: { type: 'text_delta', text: 'Hello' } },
    { type: 'message_stop' },
  ];

  const kinds = persistedRows.flatMap(
    (row) => provider.normalizeMessage(row, SESSION_ID).map((message) => message.kind),
  );

  assert.deepEqual(kinds, ['text']);
});

test('claude: a live SDK tool result keeps its tool_use_result payload', () => {
  const provider = new ClaudeSessionsProvider();
  const messages = provider.normalizeMessage({
    type: 'user',
    uuid: 'u-live',
    tool_use_result: { filenames: ['a.ts'] },
    message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: 'toolu_1', content: 'Found 1 file' }] },
  }, 'app');
  const result = messages.find((message) => message.kind === 'tool_result');
  assert.deepEqual(result?.toolUseResult, { filenames: ['a.ts'] });
});

const notificationText = [
  '<task-notification>',
  '<task-id>a1</task-id>',
  '<tool-use-id>toolu_agent</tool-use-id>',
  '<status>completed</status>',
  '<summary>Agent "Audit" finished</summary>',
  '<result>All good.</result>',
  '</task-notification>',
].join('\n');

test('claude: a background-task notification becomes a card, not a raw XML user bubble', () => {
  const provider = new ClaudeSessionsProvider();
  for (const raw of [
    { type: 'user', uuid: 'n1', message: { role: 'user', content: notificationText } },
    { type: 'attachment', uuid: 'n2', attachment: { type: 'queued_command', prompt: notificationText } },
  ]) {
    const [message] = provider.normalizeMessage(raw, 'app');
    assert.equal(message.kind, 'task_notification');
    assert.equal(message.content, 'Agent "Audit" finished');
    assert.equal(message.toolId, 'toolu_agent');
    assert.equal(message.status, 'completed');
    assert.equal(message.summary, 'All good.');
  }
});

test('claude: a message sent mid-turn renders as the user turn it is', () => {
  const provider = new ClaudeSessionsProvider();
  // How the CLI persists a user message that arrived while a turn was running.
  const messages = provider.normalizeMessage({
    type: 'attachment',
    uuid: 'q1',
    timestamp: '2026-10-08T16:33:36.086Z',
    attachment: {
      type: 'queued_command',
      prompt: [{ type: 'text', text: 'Also cover the edge case' }],
      source_uuid: 'src-1',
      commandMode: 'prompt',
    },
  }, 'app');
  assert.equal(messages.length, 1);
  assert.equal(messages[0].kind, 'text');
  assert.equal(messages[0].role, 'user');
  assert.equal(messages[0].content, 'Also cover the edge case');
  assert.equal(messages[0].timestamp, '2026-10-08T16:33:36.086Z');
});

test('claude: the async Agent launch placeholder is not shown as the subagent answer', () => {
  const provider = new ClaudeSessionsProvider();
  const [result] = provider.normalizeMessage({
    type: 'user', uuid: 'u2',
    message: { role: 'user', content: [{ type: 'tool_result', tool_use_id: 'toolu_agent', content: [{ type: 'text', text: 'Async agent launched successfully. agentId: a1' }] }] },
  }, 'app');
  assert.equal(result.content, '');
});

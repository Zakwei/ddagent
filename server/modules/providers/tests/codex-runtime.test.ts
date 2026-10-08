import assert from 'node:assert/strict';
import { mkdir, mkdtemp, readFile, readdir, rm, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import { Thread } from '@openai/codex-sdk';

import { queryCodex } from '@/modules/providers/list/codex/codex-runtime.provider.js';
import { CodexSessionsProvider } from '@/modules/providers/list/codex/codex-sessions.provider.js';
import type { AnyRecord, NormalizedMessage } from '@/shared/types.js';

type CapturedMessage = NormalizedMessage & AnyRecord;

/**
 * Runs the real `queryCodex` loop against a fixed SDK event sequence.
 *
 * The runtime constructs the SDK `Thread` itself, so the only seam needed is
 * `Thread.prototype.runStreamed`: patching it replaces the spawned
 * `codex exec --experimental-json` process while everything else (session
 * capture, transform, normalization, terminal lifecycle) stays production code.
 */
async function runCodexWithEvents(
  events: AnyRecord[],
  options: { cwd: string; sessionId: string },
): Promise<CapturedMessage[]> {
  const prototype = Thread.prototype as unknown as { runStreamed: unknown };
  const originalRunStreamed = prototype.runStreamed;
  prototype.runStreamed = async () => ({
    events: (async function* generateEvents() {
      for (const event of events) {
        yield event;
      }
    })(),
  });

  const sent: CapturedMessage[] = [];
  const writer = {
    isWebSocketWriter: true,
    userId: null,
    send(message: unknown) {
      sent.push(message as CapturedMessage);
    },
    setSessionId() {},
    getSessionId() {
      return null;
    },
  };

  const sessions = new CodexSessionsProvider();
  const context = {
    resolveProviderSessionId: () => 'provider-thread-1',
    resolveResumeModel: async (_sessionId: string, model?: string | null) => model ?? undefined,
    getProviderModels: async () => ({
      OPTIONS: [{ value: 'gpt-5-codex' }],
      DEFAULT: 'gpt-5-codex',
    }),
    normalizeMessage: (raw: unknown, sessionId: string | null) =>
      sessions.normalizeMessage(raw, sessionId),
    isProviderInstalled: async () => true,
  };

  try {
    await queryCodex(
      'hello',
      {
        sessionId: options.sessionId,
        cwd: options.cwd,
        model: 'gpt-5-codex',
        permissionMode: 'default',
      },
      writer,
      context,
    );
  } finally {
    prototype.runStreamed = originalRunStreamed;
  }

  return sent;
}

test('codex runtime relays live item snapshots and closes them at completion', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-live-'));
  try {
    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        // Assistant text snapshots are cumulative in the Codex item model, so
        // the live frame replaces the open row instead of appending to it.
        { type: 'item.started', item: { id: 'msg-1', type: 'agent_message', text: '' } },
        { type: 'item.updated', item: { id: 'msg-1', type: 'agent_message', text: 'Hello' } },
        { type: 'item.updated', item: { id: 'msg-1', type: 'agent_message', text: 'Hello' } },
        { type: 'item.updated', item: { id: 'msg-1', type: 'agent_message', text: 'Hello world' } },
        { type: 'item.completed', item: { id: 'msg-1', type: 'agent_message', text: 'Hello world' } },
        // Reasoning snapshots are cumulative too, but the client has no
        // replacement kind for thinking rows, so only the suffix is sent.
        { type: 'item.started', item: { id: 'rs-1', type: 'reasoning', text: '' } },
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Think' } },
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Think' } },
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Thinking harder' } },
        { type: 'item.completed', item: { id: 'rs-1', type: 'reasoning', text: 'Thinking harder' } },
        // A started command shows its card at once; the outcome follows as a
        // tool_result under the same toolId.
        {
          type: 'item.started',
          item: {
            id: 'cmd-1',
            type: 'command_execution',
            command: 'echo hi',
            aggregated_output: '',
            status: 'in_progress',
          },
        },
        {
          type: 'item.updated',
          item: {
            id: 'cmd-1',
            type: 'command_execution',
            command: 'echo hi',
            aggregated_output: 'hi\n',
            status: 'in_progress',
          },
        },
        {
          type: 'item.completed',
          item: {
            id: 'cmd-1',
            type: 'command_execution',
            command: 'echo hi',
            aggregated_output: 'hi\n',
            exit_code: 0,
            status: 'completed',
          },
        },
        { type: 'turn.completed', usage: { input_tokens: 3, output_tokens: 2 } },
      ],
      { cwd, sessionId: 'app-codex-live-1' },
    );

    assert.deepEqual(sent.map((message) => message.kind), [
      'stream_replace',
      'stream_replace',
      'stream_end',
      'text',
      'thought_delta',
      'thought_delta',
      'stream_end',
      'thinking',
      'tool_use',
      'tool_result',
      'complete',
    ]);

    assert.deepEqual(
      sent.filter((message) => message.kind === 'stream_replace').map((message) => message.content),
      ['Hello', 'Hello world'],
    );
    assert.deepEqual(
      sent.filter((message) => message.kind === 'thought_delta').map((message) => message.content),
      ['Think', 'ing harder'],
    );

    // The authoritative completion copies still go out exactly as before.
    const authoritativeText = sent.find((message) => message.kind === 'text');
    assert.equal(authoritativeText?.content, 'Hello world');
    assert.equal(authoritativeText?.role, 'assistant');
    assert.equal(sent.find((message) => message.kind === 'thinking')?.content, 'Thinking harder');
    assert.equal(sent.find((message) => message.kind === 'tool_use')?.toolName, 'Bash');
    // The started card has no outcome yet; the result pairs with it by toolId.
    const startedCard = sent.find((message) => message.kind === 'tool_use');
    assert.equal(startedCard?.toolResult, undefined);
    assert.equal(startedCard?.toolId, 'cmd-1');
    const result = sent.find((message) => message.kind === 'tool_result');
    assert.equal(result?.toolId, 'cmd-1');
    assert.equal(result?.content, 'hi\n');
    assert.equal(result?.isError, false);

    // Live frames are control events, never transcript rows: exactly one
    // authoritative text and one authoritative thinking message are emitted,
    // and the run writes nothing to disk (the Codex rollout is owned by the
    // CLI process, which is the only transcript writer).
    assert.equal(
      sent.filter((message) => message.kind === 'text' || message.kind === 'thinking').length,
      2,
    );
    assert.deepEqual(await readdir(cwd), []);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('codex runtime keeps completion-only frames when no live snapshots arrive', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-complete-only-'));
  try {
    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        { type: 'item.completed', item: { id: 'msg-1', type: 'agent_message', text: 'Final answer' } },
        {
          type: 'item.completed',
          item: {
            id: 'cmd-1',
            type: 'command_execution',
            command: 'ls',
            aggregated_output: 'a\n',
            exit_code: 0,
            status: 'completed',
          },
        },
        { type: 'turn.completed', usage: { input_tokens: 1, output_tokens: 1 } },
      ],
      { cwd, sessionId: 'app-codex-complete-only-1' },
    );

    // codex-cli 0.146.0 emits message/reasoning items only at completion, so a
    // run without live snapshots must not gain a `stream_end` frame.
    assert.deepEqual(sent.map((message) => message.kind), [
      'text',
      'tool_use',
      'complete',
    ]);
    assert.equal(sent[0].content, 'Final answer');
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('codex runtime closes a live row left open when the turn ends', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-run-end-'));
  try {
    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        { type: 'item.updated', item: { id: 'msg-1', type: 'agent_message', text: 'Partial answer' } },
        { type: 'turn.completed', usage: { input_tokens: 1, output_tokens: 1 } },
      ],
      { cwd, sessionId: 'app-codex-run-end-1' },
    );

    assert.deepEqual(sent.map((message) => message.kind), [
      'stream_replace',
      'stream_end',
      'complete',
    ]);
    assert.equal(sent[0].content, 'Partial answer');
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('codex runtime skips reasoning snapshots that are not safe to reduce to a suffix', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-reasoning-'));
  try {
    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Alpha' } },
        // Rewritten snapshot: the open thinking row cannot be corrected, so the
        // frame is skipped instead of appending a wrong suffix.
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Beta rewritten' } },
        { type: 'item.updated', item: { id: 'rs-1', type: 'reasoning', text: 'Alpha gamma' } },
        { type: 'item.completed', item: { id: 'rs-1', type: 'reasoning', text: 'Alpha gamma' } },
        { type: 'turn.completed', usage: { input_tokens: 1, output_tokens: 1 } },
      ],
      { cwd, sessionId: 'app-codex-reasoning-1' },
    );

    assert.deepEqual(
      sent.filter((message) => message.kind === 'thought_delta').map((message) => message.content),
      ['Alpha', ' gamma'],
    );
    assert.deepEqual(sent.map((message) => message.kind), [
      'thought_delta',
      'thought_delta',
      'stream_end',
      'thinking',
      'complete',
    ]);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('codex: installed SDK types carry cumulative full-text item snapshots', async () => {
  // The runtime reduces reasoning snapshots to deltas and replaces assistant
  // text rows, which is only correct while `item.started`/`item.updated` items
  // carry the item's complete text. codex-cli 0.146.0 never emits those frames
  // for agent_message/reasoning (its exec JSONL processor drops them), so a
  // future SDK that switches to incremental chunks must update this runtime.
  const sdkEntryUrl = import.meta.resolve('@openai/codex-sdk');
  const sdkTypesPath = path.join(path.dirname(new URL(sdkEntryUrl).pathname), 'index.d.ts');
  const types = await readFile(sdkTypesPath, 'utf8');

  assert.match(types, /type AgentMessageItem = \{[\s\S]*?text: string;/);
  assert.match(types, /type ReasoningItem = \{[\s\S]*?text: string;/);
  assert.match(types, /type ItemUpdatedEvent = \{[\s\S]*?item: ThreadItem;/);
});

test('live Codex tool items carry their outcome as toolResult', () => {
  const provider = new CodexSessionsProvider();
  const [failedCommand] = provider.normalizeMessage(
    { type: 'item', itemType: 'command_execution', command: 'false', output: 'boom', exitCode: 1, status: 'failed' },
    'app',
  );
  assert.deepEqual(failedCommand.toolResult, { content: 'boom', isError: true });

  const [mcp] = provider.normalizeMessage(
    { type: 'item', itemType: 'mcp_tool_call', tool: 'get_task', result: { content: [{ type: 'text', text: 'task 7' }] }, status: 'completed' },
    'app',
  );
  assert.deepEqual(mcp.toolResult, { content: 'task 7', isError: false });

  const [mcpError] = provider.normalizeMessage(
    { type: 'item', itemType: 'mcp_tool_call', tool: 'get_task', error: { message: 'not found' }, status: 'failed' },
    'app',
  );
  assert.deepEqual(mcpError.toolResult, { content: 'not found', isError: true });

  const [fileChange] = provider.normalizeMessage(
    { type: 'item', itemType: 'file_change', changes: [{ kind: 'update', path: 'a.ts' }], status: 'completed' },
    'app',
  );
  assert.deepEqual(fileChange.toolResult, { content: 'update a.ts', isError: false });
});

test('Codex history flags tool outputs with a non-zero exit code as errors', () => {
  const provider = new CodexSessionsProvider();
  // Rollout records go through the history normalizer (fetchHistory).
  const result = (output: string) =>
    (provider as any).normalizeHistoryEntry({ type: 'tool_result', toolCallId: 'call_1', output }, 'app')[0];

  assert.equal(result('Script completed\nOutput:\n{"exit_code":2,"output":"no match"}').isError, true);
  assert.equal(result('Script completed\nOutput:\n{"exit_code":0,"output":"ok"}').isError, false);
  assert.equal(result('Process exited with code 1\nOutput:\nboom').isError, true);
  assert.equal(result('plain output').isError, false);
});

test('codex runtime surfaces errors, notices, todos and the context budget with one complete', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-lifecycle-'));
  const previousCodexHome = process.env.CODEX_HOME;
  process.env.CODEX_HOME = cwd;
  try {
    // The live usage is thread-wide; the gauge reads the rollout's last request.
    const now = new Date();
    const dayDir = path.join(
      cwd, 'sessions', String(now.getFullYear()),
      String(now.getMonth() + 1).padStart(2, '0'), String(now.getDate()).padStart(2, '0'),
    );
    await mkdir(dayDir, { recursive: true });
    await writeFile(
      path.join(dayDir, 'rollout-2026-10-08T10-00-00-provider-thread-1.jsonl'),
      `${JSON.stringify({
        type: 'event_msg',
        payload: {
          type: 'token_count',
          info: {
            total_token_usage: { input_tokens: 400000, output_tokens: 3000, total_tokens: 403000 },
            last_token_usage: { input_tokens: 51000, output_tokens: 200, total_tokens: 51200 },
            model_context_window: 258400,
          },
        },
      })}\n`,
    );

    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        { type: 'item.started', item: { id: 'todo-1', type: 'todo_list', items: [{ text: 'Read', completed: false }] } },
        { type: 'item.updated', item: { id: 'todo-1', type: 'todo_list', items: [{ text: 'Read', completed: true }] } },
        { type: 'item.completed', item: { id: 'todo-1', type: 'todo_list', items: [{ text: 'Read', completed: true }] } },
        { type: 'item.completed', item: { id: 'err-1', type: 'error', message: 'Reconnecting... 1/5' } },
        { type: 'item.completed', item: { id: 'rs-1', type: 'reasoning', text: '   ' } },
        {
          type: 'item.completed',
          item: { id: 'cmd-1', type: 'command_execution', command: 'rm x', aggregated_output: 'exec command rejected by user', status: 'failed' },
        },
        { type: 'turn.completed', usage: { input_tokens: 400000, cached_input_tokens: 300000, output_tokens: 3000 } },
      ],
      { cwd, sessionId: 'app-codex-lifecycle-1' },
    );

    const kinds = sent.map((message) => message.kind);
    assert.equal(kinds.filter((kind) => kind === 'complete').length, 1);
    assert.equal(kinds.at(-1), 'complete');
    assert.equal(sent.at(-1)?.exitCode, 0);
    assert.ok(!kinds.includes('error'), 'non-fatal item errors are notices');
    assert.ok(!kinds.includes('thinking'), 'blank reasoning is skipped');

    const todos = sent.filter((message) => message.toolName === 'TodoWrite');
    assert.equal(todos.length, 2);
    assert.deepEqual((todos[1].toolInput as any).todos, [{ content: 'Read', status: 'completed' }]);
    assert.ok(todos.every((message) => message.toolResult));

    const notices = sent.filter((message) => message.kind === 'status' && message.notice === true);
    assert.equal(notices[0].text, 'Reconnecting... 1/5');
    assert.match(String(notices[1].text), /approval policy/);

    const budget = sent.find((message) => message.text === 'token_budget')?.tokenBudget as AnyRecord;
    assert.equal(budget.used, 51200);
    assert.equal(budget.total, 258400);
    assert.equal(budget.cacheReadTokens, 300000);
  } finally {
    if (previousCodexHome === undefined) delete process.env.CODEX_HOME;
    else process.env.CODEX_HOME = previousCodexHome;
    await rm(cwd, { recursive: true, force: true });
  }
});

test('codex runtime sends a fatal stream error once, before a failed complete', async () => {
  const cwd = await mkdtemp(path.join(os.tmpdir(), 'codex-runtime-error-'));
  try {
    const sent = await runCodexWithEvents(
      [
        { type: 'turn.started' },
        { type: 'error', message: 'stream disconnected' },
        { type: 'turn.failed', error: { message: 'stream disconnected' } },
      ],
      { cwd, sessionId: 'app-codex-error-1' },
    );

    assert.deepEqual(sent.map((message) => message.kind), ['error', 'complete']);
    assert.equal(sent[0].content, 'stream disconnected');
    assert.equal(sent[1].exitCode, 1);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('readableCodexError shows the message inside a raw API error body', async () => {
  const { readableCodexError } = await import('@/modules/providers/list/codex/codex-runtime.provider.js');
  assert.equal(
    readableCodexError('{"type":"error","status":400,"error":{"type":"invalid_request_error","message":"Model not supported"}}'),
    'Model not supported',
  );
  assert.equal(readableCodexError('plain failure'), 'plain failure');
  assert.equal(readableCodexError('{not json'), '{not json');
});

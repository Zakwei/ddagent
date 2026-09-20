import assert from 'node:assert/strict';
import { mkdtemp, readFile, readdir, rm } from 'node:fs/promises';
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
        // Tool items keep their completion-only handling: no live frames.
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
      'complete',
      'status',
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
      'status',
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
      'status',
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
      'status',
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

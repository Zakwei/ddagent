import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { PassThrough } from 'node:stream';

import ts from 'typescript';

import { CursorSessionsProvider } from '@/modules/providers/list/cursor/cursor-sessions.provider.js';

/** Evaluates the Cursor runtime with a fake `cross-spawn`, so no CLI runs. */
async function loadCursorRuntime(fakeSpawn: unknown) {
  const url = new URL('../list/cursor/cursor-runtime.provider.ts', import.meta.url);
  const source = await readFile(url, 'utf8');
  const ast = ts.createSourceFile(url.pathname, source, ts.ScriptTarget.Latest, true);
  const imports = new Map<string, unknown>();
  for (const node of ast.statements) {
    if (!ts.isImportDeclaration(node) || node.importClause?.isTypeOnly) continue;
    const spec = (node.moduleSpecifier as ts.StringLiteral).text;
    imports.set(spec, spec === 'cross-spawn' ? fakeSpawn : await import(spec.startsWith('.') ? new URL(spec, url).href : spec));
  }
  const output = ts.transpileModule(source, {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, esModuleInterop: true },
  }).outputText;
  const module = { exports: {} as Record<string, any> };
  new Function('require', 'module', 'exports', output)((spec: string) => imports.get(spec), module, module.exports);
  return module.exports;
}

function fakeChild() {
  const signals: string[] = [];
  const child = Object.assign(new EventEmitter(), {
    stdin: new PassThrough(),
    stdout: new PassThrough(),
    stderr: new PassThrough(),
    exitCode: null as number | null,
    signalCode: null as string | null,
    kill(signal: string) {
      signals.push(signal);
      return true;
    },
  });
  return { child, signals };
}

async function runCursor(lines: unknown[], { stderr = '', code = 0 } = {}) {
  const { child, signals } = fakeChild();
  const runtime = await loadCursorRuntime(() => child);
  const sessions = new CursorSessionsProvider();
  const sent: any[] = [];
  const context = {
    resolveProviderSessionId: () => null,
    resolveResumeModel: async () => undefined,
    isProviderInstalled: async () => true,
    normalizeMessage: (raw: unknown, sessionId: string | null) => sessions.normalizeMessage(raw, sessionId),
  };
  const run = runtime.spawnCursor('hello', { sessionId: 'app', cwd: '/tmp' }, { send: (msg: unknown) => sent.push(msg) }, context);
  run.catch(() => {});
  await new Promise((resolve) => setImmediate(resolve));
  if (stderr) child.stderr.emit('data', Buffer.from(stderr));
  for (const line of lines) child.stdout.emit('data', Buffer.from(`${JSON.stringify(line)}\n`));
  child.exitCode = code;
  child.emit('close', code);
  const outcome = await run.then(() => 'resolved', () => 'rejected');
  return { sent, signals, outcome };
}

const text = (value: string) => ({ type: 'assistant', message: { content: [{ type: 'text', text: value }] } });

test('cursor: text segments close at tool calls and the result; thinking streams live', async () => {
  const { sent, outcome } = await runCursor([
    { type: 'thinking', subtype: 'delta', text: 'Plan' },
    { type: 'thinking', subtype: 'completed' },
    text('Looking.'),
    { type: 'tool_call', subtype: 'started', call_id: 'c1', tool_call: { editToolCall: { args: { path: 'a.ts' } } } },
    text('Done.'),
    { type: 'result', subtype: 'success', result: 'Looking. Done.' },
  ], { stderr: 'warning: something' });

  assert.equal(outcome, 'resolved');
  assert.deepEqual(sent.map((msg) => msg.kind), [
    'thought_delta', 'stream_end', 'stream_delta', 'stream_end', 'tool_use', 'stream_delta', 'stream_end', 'complete',
  ]);
  // Live tool inputs use the history normalization.
  assert.equal(sent[4].toolInput.file_path, 'a.ts');
  assert.equal(sent.at(-1).exitCode, 0);
});

test('cursor: a failed result reports its text and the stderr tail before complete', async () => {
  const { sent, outcome } = await runCursor(
    [{ type: 'result', subtype: 'error', is_error: true, result: 'Model unavailable' }],
    { stderr: 'boom details', code: 1 },
  );
  assert.equal(outcome, 'rejected');
  assert.deepEqual(sent.map((msg) => msg.kind), ['error', 'complete']);
  assert.equal(sent[0].content, 'Model unavailable\nboom details');
  assert.equal(sent[1].exitCode, 1);
});

test('cursor: a silent non-zero exit sends an error before complete', async () => {
  const { sent } = await runCursor([], { code: 3 });
  assert.deepEqual(sent.map((msg) => msg.kind), ['error', 'complete']);
  assert.equal(sent[0].content, 'cursor-agent exited with code 3');
  assert.equal(sent[1].exitCode, 3);
});

test('cursor: abort escalates SIGTERM to SIGKILL when the process ignores it', async (t) => {
  t.mock.timers.enable({ apis: ['setTimeout'] });
  const { child, signals } = fakeChild();
  const runtime = await loadCursorRuntime(() => child);
  const context = { resolveProviderSessionId: () => null, resolveResumeModel: async () => undefined, isProviderInstalled: async () => true, normalizeMessage: () => [] };
  const run = runtime.spawnCursor('hello', { sessionId: 'abort-app', cwd: '/tmp' }, { send() {} }, context);
  await Promise.resolve();
  await Promise.resolve();
  assert.equal(runtime.abortCursorSession('abort-app'), true);
  assert.deepEqual(signals, ['SIGTERM']);
  t.mock.timers.tick(2000);
  assert.deepEqual(signals, ['SIGTERM', 'SIGKILL']);
  child.emit('close', null);
  await run;
});

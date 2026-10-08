import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { PassThrough } from 'node:stream';
import test from 'node:test';

import ts from 'typescript';

/** Evaluates the runtime with fake spawn/DB so no real `agy` or SQLite is touched. */
async function loadRuntime(overrides: Record<string, unknown>) {
  const url = new URL('../list/antigravity/antigravity-runtime.provider.ts', import.meta.url);
  const source = await readFile(url, 'utf8');
  const ast = ts.createSourceFile(url.pathname, source, ts.ScriptTarget.Latest, true);
  const imports = new Map<string, unknown>();
  for (const node of ast.statements) {
    if (!ts.isImportDeclaration(node) || node.importClause?.isTypeOnly) continue;
    const spec = (node.moduleSpecifier as ts.StringLiteral).text;
    imports.set(spec, overrides[spec] ?? await import(spec));
  }
  const output = ts.transpileModule(source, {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, esModuleInterop: true },
  }).outputText;
  const module = { exports: {} as Record<string, any> };
  new Function('require', 'module', 'exports', output)((spec: string) => imports.get(spec), module, module.exports);
  return module.exports;
}

async function setup() {
  const children: any[] = [];
  const fakeSpawn = () => {
    const child = Object.assign(new EventEmitter(), {
      stdout: new PassThrough(), stderr: new PassThrough(), kill: () => true, exitCode: null, signalCode: null,
    });
    children.push(child);
    return child;
  };
  const sessionsDb = { createSession: () => 'x', assignProviderSessionId: () => {} };
  const runtime = await loadRuntime({
    'cross-spawn': fakeSpawn,
    '@/modules/database/index.js': { sessionsDb },
    '@/modules/notifications/index.js': { notifyRunFailed() {}, notifyRunStopped() {} },
  });
  const cwd = await mkdtemp(path.join(tmpdir(), 'agy-rt-'));
  const sent: any[] = [];
  const writer = { send: (msg: any) => sent.push(msg) };
  const context = { resolveProviderSessionId: () => null, resolveResumeModel: async () => undefined };
  return { runtime, children, cwd, sent, writer, context };
}

const tick = () => new Promise((resolve) => setImmediate(resolve));
const line = (event: unknown) => `${JSON.stringify(event)}\n`;
const step = (step_update: Record<string, unknown>) => line({ event: 'step_update', step_update });

test('antigravity runtime maps tool output/errors, ends text streams and reports denials', async () => {
  const { runtime, children, cwd, sent, writer, context } = await setup();
  try {
    const run = runtime.spawnAntigravity('hi', { sessionId: 'app', cwd, images: [{ path: '/tmp/a.png' }] }, writer, context);
    await tick();
    assert.equal(runtime.hasPendingAntigravityLaunch(cwd), true);
    const out = children[0].stdout;
    out.write(line({ event: 'init', conversation_id: 'conv-1', init: { cwd } }));
    assert.equal(runtime.hasPendingAntigravityLaunch(cwd), false);
    out.write(step({ step_index: 1, state: 'ACTIVE', step_type: 'agent_response', text_delta: 'A', thinking_delta: 'hmm' }));
    out.write(step({ step_index: 1, state: 'DONE', step_type: 'agent_response' }));
    out.write(step({ step_index: 2, state: 'ACTIVE', step_type: 'tool', tool_name: 'run_command', tool_info: { parameters: { CommandLine: 'ls' } } }));
    out.write(step({ step_index: 2, state: 'DONE', step_type: 'tool', tool_name: 'run_command', tool_info: { output: 'a.txt\r\n' } }));
    out.write(step({ step_index: 3, state: 'ERROR', step_type: 'tool', tool_name: 'view_file', tool_info: { error: { type: 'TOOL_ERROR', message: 'no such file' } } }));
    out.write(step({ step_index: 4, state: 'DONE', step_type: 'agent_response', text_delta: 'B' }));
    out.write(line({ event: 'result', result: { status: 'SUCCESS', denied_actions: [{ action: 'command', display_name: 'RunCommand' }] } }));
    await tick();
    children[0].emit('close', 0);
    await run;

    assert.equal(sent[0].role, 'user');
    assert.equal(sent[0].images[0].path, '/tmp/a.png');
    assert.equal(sent.filter((m) => m.kind === 'stream_end').length, 2);
    assert.deepEqual(sent.filter((m) => m.kind === 'thought_delta').map((m) => m.content), ['hmm']);
    const results = sent.filter((m) => m.kind === 'tool_result');
    assert.deepEqual(results.map((m) => [m.content, m.isError]), [['a.txt\r\n', false], ['no such file', true]]);
    const notice = sent.find((m) => m.kind === 'status' && m.notice === true);
    assert.match(notice.text, /RunCommand/);
    assert.equal(sent.filter((m) => m.kind === 'complete').length, 1);

    const mirror = await readFile(path.join(cwd, '.ddagent', 'antigravity', 'conv-1.jsonl'), 'utf8');
    assert.match(mirror, /"type":"thinking","thinking":"hmm"/);
    assert.match(mirror, /"content":"no such file","is_error":true/);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('antigravity runtime reports spawn failure before complete', async () => {
  const { runtime, children, cwd, sent, writer, context } = await setup();
  try {
    const run = runtime.spawnAntigravity('hi', { sessionId: 'app', cwd }, writer, context);
    await tick();
    children[0].emit('error', Object.assign(new Error('spawn agy ENOENT'), { code: 'ENOENT' }));
    children[0].emit('close', -2);
    // Same text as the error row, so the dispatcher's late copy is deduped.
    await assert.rejects(run, /not installed/);
    assert.deepEqual(sent.slice(1).map((m) => m.kind), ['error', 'complete']);
    assert.match(sent[1].content, /not installed/);
    assert.equal(runtime.hasPendingAntigravityLaunch(cwd), false);

    // A missing cwd fails up front without creating it.
    const missing = path.join(cwd, 'missing');
    sent.length = 0;
    await assert.rejects(runtime.spawnAntigravity('hi', { sessionId: 'app', cwd: missing }, writer, context));
    assert.deepEqual(sent.map((m) => m.kind), ['error', 'complete']);
    assert.equal(children.length, 1);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('antigravity runtime buffers stderr and surfaces it with a silent non-zero exit', async () => {
  const { runtime, children, cwd, sent, writer, context } = await setup();
  try {
    const run = runtime.spawnAntigravity('hi', { sessionId: 'app', cwd }, writer, context);
    await tick();
    children[0].stderr.write('auth ');
    children[0].stderr.write('expired');
    await tick();
    assert.equal(sent.filter((m) => m.kind === 'error').length, 0);
    children[0].emit('close', 3);
    await assert.rejects(run, (error: Error) => error.message === 'Antigravity CLI exited with code 3:\nauth expired');
    const errors = sent.filter((m) => m.kind === 'error');
    assert.equal(errors.length, 1);
    assert.match(errors[0].content, /code 3:\nauth expired/);
    assert.equal(sent.at(-1).kind, 'complete');
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

test('antigravity Stop keeps partial text and stops later mirror writes', async () => {
  const { runtime, children, cwd, writer, context } = await setup();
  try {
    const run = runtime.spawnAntigravity('hi', { sessionId: 'app', cwd }, writer, context);
    await tick();
    const out = children[0].stdout;
    out.write(line({ event: 'init', conversation_id: 'conv-2' }));
    out.write(step({ step_index: 1, state: 'ACTIVE', step_type: 'agent_response', text_delta: 'partial' }));
    await tick();
    assert.equal(runtime.abortAntigravitySession('app'), true);
    out.write(step({ step_index: 2, state: 'ACTIVE', step_type: 'tool', tool_name: 'run_command', tool_info: { parameters: {} } }));
    await tick();
    children[0].emit('close', null);
    await run;
    const mirror = await readFile(path.join(cwd, '.ddagent', 'antigravity', 'conv-2.jsonl'), 'utf8');
    assert.match(mirror, /"text":"partial"/);
    assert.doesNotMatch(mirror, /tool_use/);
  } finally {
    await rm(cwd, { recursive: true, force: true });
  }
});

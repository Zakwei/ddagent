import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { PassThrough } from 'node:stream';

import ts from 'typescript';

/** Evaluate an isolated runtime with fake transports; production maps stay private. */
async function loadRuntime(name: string, hooks: string, overrides: Record<string, unknown> = {}) {
  const url = new URL(`../list/${name}/${name}-runtime.provider.ts`, import.meta.url);
  const source = await readFile(url, 'utf8');
  const ast = ts.createSourceFile(url.pathname, source, ts.ScriptTarget.Latest, true);
  const imports = new Map<string, unknown>();
  for (const node of ast.statements) {
    if (!ts.isImportDeclaration(node) || node.importClause?.isTypeOnly) continue;
    const spec = (node.moduleSpecifier as ts.StringLiteral).text;
    imports.set(spec, overrides[spec] ?? await import(spec.startsWith('.') ? new URL(spec, url).href : spec));
  }
  const output = ts.transpileModule(`${source}\nexport const lifecycleHooks = { ${hooks} };`, {
    compilerOptions: { module: ts.ModuleKind.CommonJS, target: ts.ScriptTarget.ES2022, esModuleInterop: true },
  }).outputText;
  const module = { exports: {} as Record<string, any> };
  new Function('require', 'module', 'exports', 'fetch', output)((spec: string) => imports.get(spec), module, module.exports, overrides.fetch ?? globalThis.fetch);
  return module.exports;
}

function deferred<T = void>() {
  let resolve!: (value: T) => void;
  let reject!: (error: Error) => void;
  const promise = new Promise<T>((res, rej) => { resolve = res; reject = rej; });
  return { promise, resolve, reject };
}

for (const success of [true, false]) {
  test(`Claude: delayed interrupt (${success}) preserves replacement and its abort flag`, async () => {
    const runtime = await loadRuntime('claude', 'addSession, activeSessions, abortedInstances');
    const { addSession, activeSessions, abortedInstances } = runtime.lifecycleHooks;
    const interrupt = deferred();
    const previous = { interrupt: () => interrupt.promise };
    const next = { interrupt: async () => {} };
    addSession('app', previous);
    const pending = runtime.abortClaudeSDKSession('app');
    // Simulate the old generator ending before interrupt acknowledges cancellation.
    activeSessions.delete('app');
    addSession('app', next);
    abortedInstances.add(next);
    if (success) interrupt.resolve();
    else interrupt.reject(new Error('interrupt refused'));
    assert.equal(await pending, success);
    assert.equal(activeSessions.get('app').instance, next);
    assert.equal(abortedInstances.has(next), true);
  });
}

for (const [name, map, nativeId, abort] of [
  ['devin', 'activeDevinProcesses', 'devinSessionId', 'abortDevinSession'],
  ['commandcode', 'activeCommandCodeProcesses', 'commandCodeSessionId', 'abortCommandCodeSession'],
]) {
  test(`${name}: failed cancel keeps the live process available for another Stop`, async () => {
    const runtime = await loadRuntime(name!, map!);
    let killed = false;
    const state = { [nativeId!]: 'native', child: { kill: () => { killed = true; } }, sendNotification: async () => { throw new Error('write failed'); } };
    runtime.lifecycleHooks[map!].set('app', state);
    assert.equal(await runtime[abort!]('app'), false);
    assert.equal(killed, false);
    assert.equal(runtime.lifecycleHooks[map!].get('app'), state);
  });
  test(`${name}: accepted cancellation cleans old state without deleting its replacement`, async () => {
    const runtime = await loadRuntime(name!, `${map}, ${name === 'devin' ? 'devin' : 'commandCode'}PendingPermissions`);
    const cancel = deferred();
    let rejected = false;
    const state = { [nativeId!]: 'native', child: { kill: () => { throw new Error('already exited'); } }, queue: [{ reject: () => { rejected = true; } }], sendNotification: () => cancel.promise };
    const processes = runtime.lifecycleHooks[map!];
    processes.set('app', state);
    const pending = runtime[abort!]('app');
    const next = { terminated: false };
    processes.set('app', next);
    cancel.resolve();
    assert.equal(await pending, true);
    assert.equal(rejected, true);
    assert.equal(processes.get('app'), next);
  });
}

for (const [name, spawn, abort, map] of [
  ['cursor', 'spawnCursor', 'abortCursorSession', 'activeCursorProcesses'],
  ['antigravity', 'spawnAntigravity', 'abortAntigravitySession', 'activeProcesses'],
]) {
  for (const event of ['close', 'error']) {
    test(`${name}: delayed ${event} of stopped process preserves the resumed process`, async () => {
      const children: any[] = [];
      const fakeSpawn = () => {
        const child = Object.assign(new EventEmitter(), {
          stdin: new PassThrough(), stdout: new PassThrough(), stderr: new PassThrough(), kill: () => true,
        });
        children.push(child);
        return child;
      };
      const runtime = await loadRuntime(name!, map!, { 'cross-spawn': fakeSpawn });
      const context = { resolveProviderSessionId: () => 'native', resolveResumeModel: async () => undefined, isProviderInstalled: async () => true, normalizeMessage: () => [] };
      const writer = { send() {} };
      const previous = runtime[spawn!]('hello', { sessionId: 'app', cwd: '/tmp' }, writer, context);
      await new Promise((resolve) => setImmediate(resolve));
      if (name === 'cursor') children[0].stderr.emit('data', Buffer.from('workspace trust required'));
      assert.equal(await runtime[abort!]('app'), true);
      const next = runtime[spawn!]('next', { sessionId: 'app', cwd: '/tmp' }, writer, context);
      await new Promise((resolve) => setImmediate(resolve));
      children[0].emit(event, event === 'close' ? 1 : new Error('late exit'));
      await previous;
      assert.equal(children.length, 2, 'a stopped process must not retry workspace trust');
      assert.equal(runtime.lifecycleHooks[map!].get('app'), children[1]);
      assert.equal(await runtime[abort!]('app'), true);
      children[1].emit('close', 0);
      await next;
    });
  }
}

test('OpenCode: old cleanup preserves replacement mapping, mode and permissions', async () => {
  const runtime = await loadRuntime('opencode', 'cleanupRun, activeRuns, providerToApp, sessionModes, pendingPermissions');
  const hooks = runtime.lifecycleHooks;
  const old = { appSessionId: 'app', providerSessionId: 'native' };
  const next = { ...old };
  hooks.activeRuns.set('app', next);
  hooks.providerToApp.set('native', 'app');
  hooks.sessionModes.set('app', 'plan');
  const permission = { appSessionId: 'app' };
  hooks.pendingPermissions.set('new-permission', permission);
  hooks.cleanupRun(old);
  assert.equal(hooks.activeRuns.get('app'), next);
  assert.equal(hooks.providerToApp.get('native'), 'app');
  assert.equal(hooks.sessionModes.get('app'), 'plan');
  assert.equal(hooks.pendingPermissions.get('new-permission'), permission);
  hooks.cleanupRun(next);
  assert.equal(hooks.pendingPermissions.size, 0);
});

test('OpenCode: HTTP abort failure returns false without settling the live run', async () => {
  const runtime = await loadRuntime('opencode', 'abortOpenCodeSession, activeRuns', { fetch: async () => { throw new Error('connection refused'); } });
  let settled = false;
  const run = { appSessionId: 'app', providerSessionId: 'native', baseUrl: 'http://127.0.0.1:1', directory: '/tmp', aborted: false, resolve: () => { settled = true; } };
  runtime.lifecycleHooks.activeRuns.set('app', run);
  assert.equal(await runtime.lifecycleHooks.abortOpenCodeSession('app'), false);
  assert.equal(run.aborted, false);
  assert.equal(settled, false);
});

for (const [name, createProcess] of [['devin', 'createDevinProcess'], ['commandcode', 'createCommandCodeProcess']]) {
  for (const empty of [false, true]) {
    test(`${name}: failed or empty session/load (${empty}) never creates a fresh session`, async () => {
      const methods: string[] = [];
      const fakeSpawn = () => {
        const child = Object.assign(new EventEmitter(), {
          stdin: new PassThrough(), stdout: new PassThrough(), stderr: new PassThrough(),
          kill() { child.emit('close', 1); return true; },
        });
        child.stdin.on('data', (chunk: Buffer) => {
          const request = JSON.parse(chunk.toString());
          methods.push(request.method);
          setImmediate(() => {
            const response = request.method === 'initialize'
              ? { id: request.id, result: { agentCapabilities: {} } }
              : empty ? { id: request.id, result: null } : { id: request.id, error: { message: 'session expired' } };
            child.stdout.write(`${JSON.stringify(response)}\n`);
          });
        });
        return child;
      };
      const runtime = await loadRuntime(name!, createProcess!, { 'cross-spawn': fakeSpawn });
      const context = { getMcpConfig: async () => ({ mcpServers: {} }) };
      await assert.rejects(runtime.lifecycleHooks[createProcess!]('app', '/tmp', null, { send() {} }, context, 'native'), /resume|conversation context/i);
      assert.deepEqual(methods, ['initialize', 'session/load']);
    });
  }
}

test('Codex: old finally and abort reads belong to the original turn', async () => {
  const oldEvents = deferred();
  const nextEvents = deferred();
  let turns = 0;
  class FakeCodex {
    resumeThread() {
      return {
        id: 'native',
        runStreamed: async () => {
          const gate = turns++ === 0 ? oldEvents : nextEvents;
          return { events: (async function* () { await gate.promise; })() };
        },
      };
    }
  }
  const runtime = await loadRuntime('codex', 'activeCodexSessions', { '@openai/codex-sdk': { Codex: FakeCodex } });
  const context = { resolveProviderSessionId: () => 'native', resolveResumeModel: async () => undefined, getProviderModels: async () => ({ OPTIONS: [] }), isProviderInstalled: async () => true };
  const previousFrames: any[] = [];
  const old = runtime.queryCodex('old', { sessionId: 'app' }, { send: (frame: any) => previousFrames.push(frame) }, context);
  await new Promise((resolve) => setImmediate(resolve));
  assert.equal(runtime.abortCodexSession('app'), true);
  const next = runtime.queryCodex('next', { sessionId: 'app' }, { send() {} }, context);
  await new Promise((resolve) => setImmediate(resolve));
  const current = runtime.lifecycleHooks.activeCodexSessions.get('app');
  oldEvents.resolve();
  await old;
  assert.equal(current.status, 'running');
  assert.equal(runtime.isCodexSessionActive('app'), true);
  assert.equal(previousFrames.some((frame) => frame.kind === 'complete'), false);
  nextEvents.resolve();
  await next;
  assert.equal(current.status, 'completed');
});

for (const [status, body] of [[500, 'failure'], [200, 'false']] as const) {
  test(`OpenCode: refused abort (${status}, ${body}) leaves the run live`, async () => {
    const runtime = await loadRuntime('opencode', 'abortOpenCodeSession, activeRuns', {
      fetch: async () => new Response(body, { status }),
    });
    let settled = false;
    const run = { appSessionId: 'app', providerSessionId: 'native', baseUrl: 'http://fake', directory: '/tmp', aborted: false, resolve: () => { settled = true; } };
    runtime.lifecycleHooks.activeRuns.set('app', run);
    assert.equal(await runtime.lifecycleHooks.abortOpenCodeSession('app'), false);
    assert.equal(run.aborted, false);
    assert.equal(settled, false);
  });
}

for (const [name, map, abort] of [['cursor', 'activeCursorProcesses', 'abortCursorSession'], ['antigravity', 'activeProcesses', 'abortAntigravitySession']]) {
  test(`${name}: refused process termination keeps the session stoppable`, async () => {
    const runtime = await loadRuntime(name!, map!);
    const child = { aborted: false, kill: () => false };
    runtime.lifecycleHooks[map!].set('app', child);
    assert.equal(runtime[abort!]('app'), false);
    assert.equal(child.aborted, false);
    assert.equal(runtime.lifecycleHooks[map!].get('app'), child);
  });
}

for (const [name, createProcess, map, abort, nativeKey] of [
  ['devin', 'createDevinProcess', 'activeDevinProcesses', 'abortDevinSession', 'devinSessionId'],
  ['commandcode', 'createCommandCodeProcess', 'activeCommandCodeProcesses', 'abortCommandCodeSession', 'commandCodeSessionId'],
] as const) {
  test(`${name}: warm ACP stream after idle uses the new writer and Stop settles without child close`, { timeout: 10000 }, async (t) => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-stream-lifecycle-'));
    type AcpChild = EventEmitter & { stdin: PassThrough; stdout: PassThrough; stderr: PassThrough; kill: () => boolean };
    const children: AcpChild[] = [];
    const prompts: Array<{ child: AcpChild; id: number }> = [];
    function fakeSpawn(): AcpChild {
      const child = Object.assign(new EventEmitter(), {
        stdin: new PassThrough(), stdout: new PassThrough(), stderr: new PassThrough(),
        // Simulate an accepted kill with no close notification. No real process exists.
        kill: () => true,
      });
      children.push(child);
      child.stdin.on('data', (chunk: Buffer) => {
        const request = JSON.parse(chunk.toString());
        if (request.method === 'session/prompt') {
          prompts.push({ child, id: request.id });
        } else if (request.id !== undefined) {
          setImmediate(() => child.stdout.write(`${JSON.stringify({ id: request.id, result: request.method === 'initialize' ? { agentCapabilities: {} } : { sessionId: 'native-session' } })}\n`));
        }
      });
      return child;
    }
    const runtime = await loadRuntime(name, `${createProcess}, ${map}`, {
      'cross-spawn': fakeSpawn,
      '../../../database/index.js': { sessionsDb: { createSession() {}, assignProviderSessionId() {} } },
      [`./${name}-sessions.provider.js`]: {
        [name === 'devin' ? 'DevinSessionsProvider' : 'CommandCodeSessionsProvider']: class {
          async fetchHistory() {
            return { messages: [
              { kind: 'text', role: 'user', content: 'prompt' },
              { id: `final-${prompts.length}`, kind: 'text', role: 'assistant', content: prompts.length === 1 ? 'first answer' : 'final answer' },
            ] };
          }
        },
      },
    });
    const writers = [0, 1, 2].map(() => {
      const frames: Array<Record<string, any>> = [];
      return { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    });
    const notify = (child: AcpChild, content: string) => child.stdout.write(`${JSON.stringify({
      method: 'session/update', params: { sessionId: 'native-session', update: { sessionUpdate: 'agent_message_chunk', content: { type: 'text', text: content } } },
    })}\n`);
    const drain = () => new Promise<void>((resolve) => setImmediate(resolve));
    try {
      const state = await runtime.lifecycleHooks[createProcess]('app', directory, null, writers[0], {}, 'native-session');
      runtime.lifecycleHooks[map].set('app', state);
      t.mock.timers.enable({ apis: ['Date', 'setTimeout'], now: Date.now() });
      const first = state.prompt('first', {}, writers[0]);
      await drain();
      assert.equal(prompts.length, 1);
      notify(children[0]!, 'first ');
      notify(children[0]!, 'answer');
      children[0]!.stdout.write(`${JSON.stringify({ id: prompts[0]!.id, result: { stopReason: 'end_turn' } })}\n`);
      await drain();
      for (let tick = 0; tick < 20; tick += 1) {
        t.mock.timers.tick(500);
        await drain();
      }
      await first;
      assert.deepEqual(writers[0]!.frames.filter((f) => f.kind === 'stream_delta').map((f) => f.content), ['first ', 'answer']);
      assert.equal(state.busy, false);
      const firstCount = writers[0]!.frames.length;
      // Idle updates from the completed prompt must not pollute buffers/history.
      notify(children[0]!, 'LATE IDLE');
      assert.equal(writers[0]!.frames.length, firstCount);
      assert.equal(state.assistantBuffer.includes('LATE'), false);
      t.mock.timers.tick(6 * 60 * 1000);
      const second = state.prompt('after idle', {}, writers[1]);
      await drain();
      assert.equal(prompts.length, 2);
      notify(children[0]!, 'new ');
      notify(children[0]!, 'answer');
      assert.equal(writers[0]!.frames.length, firstCount);
      assert.deepEqual(writers[1]!.frames.filter((f) => f.kind === 'stream_delta').map((f) => f.content), ['new ', 'answer']);
      const stopped = runtime[abort]('app');
      await drain();
      t.mock.timers.tick(200);
      assert.equal(await stopped, true);
      await second;
      assert.equal(state.busy, false);
      assert.equal(state.terminated, true);
      assert.equal(runtime.lifecycleHooks[map].has('app'), false);
      const secondCount = writers[1]!.frames.length;
      notify(children[0]!, 'LATE STOP');
      // Start another ACP instance resuming the same native conversation.
      const next = await runtime.lifecycleHooks[createProcess]('app', directory, null, writers[2], {}, 'native-session');
      runtime.lifecycleHooks[map].set('app', next);
      const third = next.prompt('after stop', {}, writers[2]);
      await drain();
      children[0]!.stdout.write(`${JSON.stringify({ id: prompts[1]!.id, result: { stopReason: 'end_turn' } })}\n`);
      notify(children[0]!, 'LATE OLD PROCESS');
      notify(children[1]!, 'final ');
      notify(children[1]!, 'answer');
      children[1]!.stdout.write(`${JSON.stringify({ id: prompts[2]!.id, result: { stopReason: 'end_turn' } })}\n`);
      await drain();
      for (let tick = 0; tick < 20; tick += 1) {
        t.mock.timers.tick(500);
        await drain();
      }
      await third;
      assert.equal(writers[1]!.frames.length, secondCount);
      assert.deepEqual(writers[2]!.frames.filter((f) => f.kind === 'stream_delta').map((f) => f.content), ['final ', 'answer']);
      assert.equal(writers[2]!.frames.filter((f) => f.kind === 'complete').length, 1);
      assert.equal(writers[2]!.frames.some((f) => f.kind === 'text' && f.role === 'assistant'), false, 'canonical final must not duplicate streamed text');
      assert.equal(writers[2]!.frames.find((f) => f.kind === 'complete')?.exitCode, 0);
      assert.equal(next.busy, false);
      assert.equal(next.completeSent, true);
      assert.equal(next[nativeKey], 'native-session');
      if (name === 'devin') {
        const rows = (await readFile(state.jsonlPath, 'utf8')).trim().split('\n').map((line) => JSON.parse(line));
        assert.deepEqual(rows.filter((row) => row.kind === 'text' && row.role === 'assistant').map((row) => row.content), ['first answer', 'new answer', 'final answer']);
        assert.equal(rows.some((row) => row.kind === 'error'), false);
      }
    } finally {
      t.mock.timers.reset();
      for (const child of children) child.stdout.end();
      await rm(directory, { recursive: true, force: true });
    }
  });
}

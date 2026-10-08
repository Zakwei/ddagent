import assert from 'node:assert/strict';
import { EventEmitter } from 'node:events';
import { mkdtemp, readFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';
import { PassThrough } from 'node:stream';

import ts from 'typescript';

import { CommandCodeSessionsProvider } from '../list/commandcode/commandcode-sessions.provider.js';

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

// The chat.subscribe ack carries pending asks the client filters by the app
// session id, so listPending must report that id — never the provider-native
// one, or the answerable question panel silently disappears (only the greyed
// read-only recap remains). See chat-websocket.service.ts.
for (const [name, map, nativeId, runtimeName] of [
  ['devin', 'devinPendingPermissions', 'devinSessionId', 'devinRuntime'],
  ['commandcode', 'commandCodePendingPermissions', 'commandCodeSessionId', 'commandCodeRuntime'],
]) {
  test(`${name}: listPending reports the app session id for a pending ask`, async () => {
    const runtime = await loadRuntime(name!, map!);
    const params = {
      toolCall: { title: 'Zakres: Pytanie?', rawInput: { question: 'Pytanie?', options: ['A', 'B'] } },
      options: [
        { optionId: 'o0', name: 'A: a' },
        { optionId: 'o1', name: 'B: b' },
      ],
    };
    runtime.lifecycleHooks[map!].set('req-1', {
      appSessionId: 'app',
      [nativeId!]: 'native',
      params,
      state: {},
    });

    const pending = runtime[runtimeName!].permissions.listPending('app');
    assert.equal(pending.length, 1);
    assert.equal(pending[0].sessionId, 'app');
    assert.equal(pending[0].toolName, 'AskUserQuestion');
    assert.equal(runtime[runtimeName!].permissions.listPending('other').length, 0);
  });

  test(`${name}: denying without a reject option cancels instead of picking an allow option`, async () => {
    const runtime = await loadRuntime(name!, map!);
    const written: string[] = [];
    const state = { child: { stdin: { writable: true, destroyed: false, write: (line: string) => written.push(line) } } };
    runtime.lifecycleHooks[map!].set('req-deny', {
      appSessionId: 'app',
      [nativeId!]: 'native',
      acpId: 7,
      params: { toolCall: { title: 'rm -rf build' }, options: [{ optionId: 'allow', kind: 'allow_once', name: 'Allow' }] },
      state,
    });

    runtime[runtimeName!].permissions.resolve('req-deny', { allow: false });

    assert.equal(written.length, 1);
    assert.deepEqual(JSON.parse(written[0]).result, { outcome: { outcome: 'cancelled' } });
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

for (const [permissionMode, expected, unexpected] of [
  ['bypassPermissions', ['-f'], ['--mode']],
  ['plan', ['--mode', 'plan'], ['-f']],
  ['acceptEdits', [], ['-f', '--mode']],
] as const) {
  test(`cursor: permissionMode ${permissionMode} maps onto cursor-agent flags`, async () => {
    let spawnedArgs: string[] = [];
    const child = Object.assign(new EventEmitter(), {
      stdin: new PassThrough(), stdout: new PassThrough(), stderr: new PassThrough(), kill: () => true,
    });
    const fakeSpawn = (_cmd: string, args: string[]) => {
      spawnedArgs = args;
      return child;
    };
    const runtime = await loadRuntime('cursor', 'activeCursorProcesses', { 'cross-spawn': fakeSpawn });
    const context = { resolveProviderSessionId: () => null, resolveResumeModel: async () => undefined, isProviderInstalled: async () => true, normalizeMessage: () => [] };
    const run = runtime.spawnCursor('hello', { sessionId: 'app', cwd: '/tmp', permissionMode }, { send() {} }, context);
    await new Promise((resolve) => setImmediate(resolve));
    child.emit('close', 0);
    await run;
    const joined = spawnedArgs.join(' ');
    if (expected.length) assert.ok(joined.includes(expected.join(' ')), joined);
    for (const flag of unexpected) assert.ok(!spawnedArgs.includes(flag), joined);
  });
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

// ---------------------------------------------------------------------------
// Interactive ask (AskUserQuestion) lifecycle for the ACP providers: the ask
// must reach the client, a delegated child must never be shown, and a turn
// that dies (error/timeout/stall) must cancel its pending asks so listPending
// cannot resurface a dead, unanswerable prompt.
// ---------------------------------------------------------------------------

const flush = () => new Promise<void>((resolve) => setImmediate(resolve));

const questionParams = {
  toolCall: {
    title: 'Zakres: Pick a scope?',
    rawInput: { question: 'Pick a scope?', options: ['MVP', 'Full clone'] },
  },
  options: [
    { optionId: 'option_0', name: 'MVP: small' },
    { optionId: 'option_1', name: 'Full clone: everything' },
  ],
};

/** Loads a provider with a scripted ACP child; captures responses + prompts. */
async function loadAcpProvider(name: string, hooks: string, delegated = false) {
  const children: any[] = [];
  const responses: any[] = [];
  const prompts: Array<{ id: number }> = [];
  function fakeSpawn() {
    const child = Object.assign(new EventEmitter(), {
      stdin: new PassThrough(), stdout: new PassThrough(), stderr: new PassThrough(), kill: () => true,
    });
    children.push(child);
    child.stdin.on('data', (chunk: Buffer) => {
      for (const line of chunk.toString().split('\n')) {
        if (!line.trim()) continue;
        let msg: any;
        try { msg = JSON.parse(line); } catch { continue; }
        if (msg.method === 'session/prompt') { prompts.push({ id: msg.id }); continue; }
        if (msg.method) {
          setImmediate(() => child.stdout.write(`${JSON.stringify({ id: msg.id, result: msg.method === 'initialize' ? { agentCapabilities: {} } : { sessionId: 'native-session' } })}\n`));
          continue;
        }
        responses.push(msg);
      }
    });
    return child;
  }
  const runtime = await loadRuntime(name, hooks, {
    'cross-spawn': fakeSpawn,
    '../../../database/index.js': {
      sessionsDb: { createSession() {}, assignProviderSessionId() {} },
      orchestratorMessagesDb: { findDelegationByChildSessionId: () => delegated },
    },
    [`./${name}-sessions.provider.js`]: {
      [name === 'devin' ? 'DevinSessionsProvider' : 'CommandCodeSessionsProvider']: class {
        async fetchHistory() { return { messages: [] }; }
      },
    },
  });
  return { runtime, children, responses, prompts };
}

for (const [name, createProcess, permissions, nativeKey, queryFn, runtimeExport, map] of [
  ['devin', 'createDevinProcess', 'devinPendingPermissions', 'devinSessionId', 'queryDevin', 'devinRuntime', 'activeDevinProcesses'],
  ['commandcode', 'createCommandCodeProcess', 'commandCodePendingPermissions', 'commandCodeSessionId', 'queryCommandCode', 'commandCodeRuntime', 'activeCommandCodeProcesses'],
]) {
  test(`${name}: a question ask reaches the client and answers by option id`, async () => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-question-'));
    const { runtime, children, responses } = await loadAcpProvider(name!, `${createProcess}`);
    const frames: Array<Record<string, any>> = [];
    const writer = { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    try {
      const state = await runtime.lifecycleHooks[createProcess!]('app', directory, null, writer, {}, 'native-session');
      state.child.stdout.write(`${JSON.stringify({ jsonrpc: '2.0', id: 99, method: 'session/request_permission', params: questionParams })}\n`);
      await flush();

      const ask = frames.find((frame) => frame.kind === 'permission_request');
      assert.ok(ask, 'the ask must reach the client');
      assert.equal(ask.toolName, 'AskUserQuestion');
      assert.equal(ask.input.questions[0].question, 'Pick a scope?');
      assert.equal(ask.input.questions[0].header, 'Zakres');

      runtime[runtimeExport!].permissions.resolve(String(ask.requestId), {
        allow: true,
        updatedInput: { answers: { 'Pick a scope?': 'Full clone' } },
      });
      assert.ok(
        responses.some((response) => response.id === 99 && response.result?.outcome?.optionId === 'option_1'),
        'the picked label must map back to the ACP optionId',
      );
      const cancelled = frames.find((frame) => frame.kind === 'permission_cancelled');
      assert.deepEqual(cancelled?.answers, { 'Pick a scope?': 'Full clone' }, 'other windows must receive the answer');
    } finally {
      for (const child of children) child.stdout.end();
      await rm(directory, { recursive: true, force: true });
    }
  });

  test(`${name}: a delegated child's question is auto-cancelled, never shown`, async () => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-question-'));
    const { runtime, children, responses } = await loadAcpProvider(name!, `${createProcess}`, true);
    const frames: Array<Record<string, any>> = [];
    const writer = { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    try {
      const state = await runtime.lifecycleHooks[createProcess!]('app', directory, null, writer, {}, 'native-session');
      state.child.stdout.write(`${JSON.stringify({ jsonrpc: '2.0', id: 100, method: 'session/request_permission', params: questionParams })}\n`);
      await flush();

      assert.equal(frames.some((frame) => frame.kind === 'permission_request'), false, 'headless child has no panel');
      assert.ok(
        responses.some((response) => response.id === 100 && response.result?.outcome?.outcome === 'cancelled'),
        'the ask must be answered cancelled for a delegated child',
      );
    } finally {
      for (const child of children) child.stdout.end();
      await rm(directory, { recursive: true, force: true });
    }
  });

  test(`${name}: a dead turn cancels its pending asks`, async () => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-question-'));
    const { runtime, children, prompts } = await loadAcpProvider(name!, `${createProcess}, ${permissions}`);
    const frames: Array<Record<string, any>> = [];
    const writer = { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    try {
      const state = await runtime.lifecycleHooks[createProcess!]('app', directory, null, writer, {}, 'native-session');
      state.currentWriter = writer;
      runtime.lifecycleHooks[permissions!].set('req-1', {
        state, appSessionId: 'app', [nativeKey!]: 'native-session', params: questionParams, acpId: 7,
      });

      const pending = state.prompt('hi', {}, writer);
      await flush();
      assert.equal(prompts.length, 1);
      // Fail the turn (rate limit / inactivity timeout / ACP error).
      state.child.stdout.write(`${JSON.stringify({ jsonrpc: '2.0', id: prompts[0]!.id, error: { message: 'boom' } })}\n`);
      await pending;

      assert.equal(runtime.lifecycleHooks[permissions!].has('req-1'), false, 'the dead turn must drop its ask');
      assert.ok(frames.some((frame) => frame.kind === 'permission_cancelled' && frame.requestId === 'req-1'));
    } finally {
      for (const child of children) child.stdout.end();
      await rm(directory, { recursive: true, force: true });
    }
  });

  test(`${name}: a run waiting on a pending ask is never killed as stalled`, async () => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-question-'));
    const { runtime, children } = await loadAcpProvider(name!, `${createProcess}, ${map}, ${permissions}, ${queryFn}`);
    const frames: Array<Record<string, any>> = [];
    const writer = { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    try {
      const stalled: any = {
        terminated: false, busy: true, lastActivityAt: 0, workingDir: directory,
        appSessionId: 'app', [nativeKey!]: 'native-session', currentWriter: writer,
        child: { stdin: new PassThrough(), kill: () => true }, sendNotification: async () => {}, queue: [],
      };
      runtime.lifecycleHooks[map!].set('app', stalled);
      runtime.lifecycleHooks[permissions!].set('req-1', {
        state: stalled, appSessionId: 'app', [nativeKey!]: 'native-session', params: questionParams, acpId: 9,
      });
      const context = {
        isProviderInstalled: async () => true,
        resolveResumeModel: async () => ({ model: null }),
        resolveProviderSessionId: async () => 'native-session',
      };
      // Do not await: the restart then waits on an unanswered session/prompt.
      void runtime[queryFn!]('hi', { sessionId: 'app', cwd: directory }, writer, context).catch(() => {});
      await flush();

      assert.equal(runtime.lifecycleHooks[permissions!].has('req-1'), true, 'a run waiting on the user is not stalled');
      assert.ok(!frames.some((frame) => frame.kind === 'permission_cancelled' && frame.requestId === 'req-1'));
    } finally {
      for (const child of children) child.stdout.end();
      await rm(directory, { recursive: true, force: true });
    }
  });
}

// Only a tool the agent reports running excuses silence; a queued (pending)
// tool_call that never starts is exactly the deadlock the stall check exists for.
for (const [label, updates, expectStalled] of [
  ['a queued tool that never starts is still caught as stalled', [{ sessionUpdate: 'tool_call', toolCallId: 't1', title: 'Shell: ls', kind: 'execute', status: 'pending' }], true],
  ['a running tool is not a stall', [
    { sessionUpdate: 'tool_call', toolCallId: 't1', title: 'Shell: ls', kind: 'execute', status: 'pending' },
    { sessionUpdate: 'tool_call_update', toolCallId: 't1', status: 'in_progress' },
  ], false],
] as const) {
  test(`commandcode: ${label}`, async () => {
    const directory = await mkdtemp(path.join(tmpdir(), 'acp-stall-'));
    const { runtime, children } = await loadAcpProvider('commandcode', 'createCommandCodeProcess, activeCommandCodeProcesses, queryCommandCode');
    const frames: Array<Record<string, any>> = [];
    const writer = { frames, send(message: Record<string, any>) { frames.push(message); }, setSessionId() {} };
    try {
      const { createCommandCodeProcess, activeCommandCodeProcesses, queryCommandCode } = runtime.lifecycleHooks;
      const state = await createCommandCodeProcess('app', directory, null, writer, {}, 'native-session');
      activeCommandCodeProcesses.set('app', state);
      void state.prompt('hi', {}, writer).catch(() => {});
      for (let i = 0; i < 5; i += 1) await flush();
      for (const update of updates) {
        state.child.stdout.write(`${JSON.stringify({ jsonrpc: '2.0', method: 'session/update', params: { sessionId: 'native-session', update } })}\n`);
      }
      await flush();
      state.lastActivityAt = 1;
      const context = {
        isProviderInstalled: async () => true,
        resolveResumeModel: async () => ({ model: null }),
        resolveProviderSessionId: async () => 'native-session',
      };
      void queryCommandCode('next', { sessionId: 'app', cwd: directory }, writer, context).catch(() => {});
      for (let i = 0; i < 5; i += 1) await flush();
      assert.equal(state.terminated, expectStalled);
    } finally {
      // Let a stall restart finish spawning, then close every child so the
      // in-flight session/prompt timeout timers are cleared.
      for (let i = 0; i < 10; i += 1) await flush();
      for (const child of children) { child.stdout.end(); child.emit('close', 0); }
      await rm(directory, { recursive: true, force: true });
    }
  });
}

test('OpenCode: switching to bypass approves pending permissions but leaves questions open', async () => {
  const requests: string[] = [];
  const fakeFetch = async (url: string) => {
    requests.push(new URL(url).pathname);
    return new Response('true', { status: 200, headers: { 'content-type': 'application/json' } });
  };
  const runtime = await loadRuntime('opencode', 'pendingPermissions', { fetch: fakeFetch });
  const pending = runtime.lifecycleHooks.pendingPermissions;
  pending.set('perm-1', {
    kind: 'permission', appSessionId: 'app', baseUrl: 'http://127.0.0.1:1', directory: '/tmp',
    providerSessionId: 'ses_1', permissionID: 'per_1',
  });
  pending.set('question-1', {
    kind: 'question', appSessionId: 'app', baseUrl: 'http://127.0.0.1:1', directory: '/tmp',
    providerSessionId: 'ses_1', requestId: 'que_1', questions: [{ question: 'Which scope?' }],
  });

  runtime.setOpenCodePermissionMode('app', 'bypassPermissions');
  await new Promise((resolve) => setImmediate(resolve));

  assert.equal(pending.has('perm-1'), false);
  assert.equal(pending.has('question-1'), true);
  assert.ok(requests.every((pathname) => !pathname.includes('/question/')), requests.join(', '));
});

test('OpenCode: a subagent child session ask reaches the parent run instead of being rejected', async () => {
  const requests: string[] = [];
  const fakeFetch = async (url: string) => {
    requests.push(new URL(url).pathname);
    return new Response('true', { status: 200, headers: { 'content-type': 'application/json' } });
  };
  const runtime = await loadRuntime('opencode', 'dispatchServerEvent, activeRuns, providerToApp, pendingPermissions', { fetch: fakeFetch });
  const { dispatchServerEvent, activeRuns, providerToApp, pendingPermissions } = runtime.lifecycleHooks;
  const sent: any[] = [];
  activeRuns.set('app', {
    appSessionId: 'app', providerSessionId: 'ses_parent', baseUrl: 'http://127.0.0.1:1', directory: '/tmp',
    writer: { send: (message: any) => sent.push(message) },
  });
  providerToApp.set('ses_parent', 'app');

  dispatchServerEvent('http://127.0.0.1:1', {
    type: 'session.created',
    properties: { sessionID: 'ses_child', info: { id: 'ses_child', parentID: 'ses_parent' } },
  });
  dispatchServerEvent('http://127.0.0.1:1', {
    type: 'permission.asked',
    properties: { id: 'per_1', sessionID: 'ses_child', permission: 'bash', patterns: ['ls'] },
  });
  await new Promise((resolve) => setImmediate(resolve));

  assert.ok(requests.every((pathname) => !pathname.endsWith('/permissions/per_1')), requests.join(', '));
  assert.equal(sent.filter((message) => message.kind === 'permission_request').length, 1);
  assert.equal(pendingPermissions.size, 1);
});

test('commandcode: an answer closed at a tool boundary is not re-sent at the end of the turn', async (t) => {
  const runtime = await loadRuntime('commandcode', 'finalizeLiveMessages');
  const original = CommandCodeSessionsProvider.prototype.fetchHistory;
  CommandCodeSessionsProvider.prototype.fetchHistory = async () => ({
    messages: [
      { id: 'u1', kind: 'text', role: 'user', content: 'fix it' },
      { id: 'a2', kind: 'text', role: 'assistant', content: 'Fixed the bug.' },
    ],
  }) as any;
  t.after(() => { CommandCodeSessionsProvider.prototype.fetchHistory = original; });

  const sent: any[] = [];
  const writer = { send: (message: any) => sent.push(message) };
  const state: any = {
    appSessionId: 'app', commandCodeSessionId: 'cc', terminated: false, promptStartedAt: Date.now(),
    lastFinalAssistantId: null, assistantBuffer: '', streamedAssistantContents: new Set(), currentWriter: writer,
    liveStreamOpen: true, liveThoughtOpen: false,
  };
  // Narration, a tool call, the answer, then a trailing tool call.
  state.assistantBuffer = 'Looking.';
  runtime.lifecycleHooks.finalizeLiveMessages(state);
  state.assistantBuffer = 'Fixed the bug.';
  state.liveStreamOpen = true;
  runtime.lifecycleHooks.finalizeLiveMessages(state);
  sent.length = 0;

  const ok = await runtime.sendFinalAssistantMessage(writer, state, { maxRetries: 0, retryDelayMs: 1 });

  assert.equal(ok, true);
  assert.deepEqual(sent, []);
});

test('OpenCode: live rows end at every part boundary so text around a tool never merges', async () => {
  const runtime = await loadRuntime('opencode', 'dispatchServerEvent, activeRuns, providerToApp');
  const { dispatchServerEvent, activeRuns, providerToApp } = runtime.lifecycleHooks;
  const sent: any[] = [];
  activeRuns.set('app', {
    appSessionId: 'app', providerSessionId: 'ses_1', baseUrl: 'http://127.0.0.1:1', directory: '/tmp',
    writer: { send: (message: any) => sent.push(message) },
    context: { normalizeMessage: () => [] },
    partTypes: new Map(), streamedParts: new Set(), editedMessageIds: new Set(), livePartId: null,
  });
  providerToApp.set('ses_1', 'app');
  const updated = (id: string, type: string) => dispatchServerEvent('http://x', {
    type: 'message.part.updated', properties: { sessionID: 'ses_1', part: { id, type, messageID: 'm1' } },
  });
  const delta = (partID: string, text: string) => dispatchServerEvent('http://x', {
    type: 'message.part.delta', properties: { sessionID: 'ses_1', partID, field: 'text', delta: text },
  });

  // The order a real `opencode serve` run produced.
  updated('r1', 'reasoning'); delta('r1', 'plan');
  updated('t1', 'text'); delta('t1', 'first');
  updated('tool1', 'tool');
  updated('r2', 'reasoning'); delta('r2', 'again');
  updated('t2', 'text'); delta('t2', 'done');

  assert.deepEqual(sent.map((message) => message.kind === 'stream_end' ? '|' : message.content), [
    'plan', '|', 'first', '|', 'again', '|', 'done',
  ]);
});

test('claude: Always rules are safe command prefixes and never approve a chained command', async () => {
  const runtime = await loadRuntime('claude', 'matchesToolPermission');
  const { matchesToolPermission } = runtime.lifecycleHooks;

  assert.equal(runtime.claudeRememberEntry('Bash', { command: 'git status --short' }), 'Bash(git status:*)');
  assert.equal(runtime.claudeRememberEntry('Bash', { command: 'ls -la src' }), 'Bash(ls:*)');
  assert.equal(runtime.claudeRememberEntry('Bash', { command: 'npm test && rm -rf build' }), null);
  assert.equal(runtime.claudeRememberEntry('Edit', { file_path: 'a.ts' }), 'Edit');
  assert.equal(runtime.claudeRememberEntry('AskUserQuestion', {}), null);

  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git status --short' }), true);
  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git status' }), true);
  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git statusx' }), false);
  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git status && rm -rf ~' }), false);
  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git status; curl evil' }), false);
  assert.equal(matchesToolPermission('Bash(git status:*)', 'Bash', { command: 'git status $(curl evil)' }), false);
});

for (const [name, map, nativeId, runtimeName] of [
  ['devin', 'devinPendingPermissions', 'devinSessionId', 'devinRuntime'],
  ['commandcode', 'commandCodePendingPermissions', 'commandCodeSessionId', 'commandCodeRuntime'],
]) {
  test(`${name}: Always is offered only when the agent has an allow_always option`, async () => {
    const runtime = await loadRuntime(name!, map!);
    const ask = (options: unknown[]) => ({
      appSessionId: 'app', [nativeId!]: 'native', state: {},
      params: { toolCall: { title: 'Run ls' }, options },
    });
    runtime.lifecycleHooks[map!].set('with', ask([
      { optionId: 'a', kind: 'allow_once', name: 'Allow' },
      { optionId: 'b', kind: 'allow_always', name: 'Always allow ls' },
    ]));
    runtime.lifecycleHooks[map!].set('without', ask([{ optionId: 'a', kind: 'allow_once', name: 'Allow' }]));

    const pending = runtime[runtimeName!].permissions.listPending('app');
    const byId = Object.fromEntries(pending.map((entry: any) => [entry.requestId, entry]));
    assert.equal(byId.with.context.rememberEntry, 'Always allow ls');
    assert.equal(byId.without.context.rememberEntry, undefined);
  });
}

test('OpenCode: Always is offered with the patterns an always reply would approve', async () => {
  const runtime = await loadRuntime('opencode', 'pendingPermissions');
  runtime.lifecycleHooks.pendingPermissions.set('p1', {
    requestId: 'p1', appSessionId: 'app', kind: 'permission', toolName: 'bash',
    input: { permission: 'bash', always: ['git status*'] },
  });
  const [entry] = runtime.opencodeRuntime.permissions.listPending('app');
  assert.equal(entry.context.rememberEntry, 'bash: git status*');
});

// ---------------------------------------------------------------------------
// Claude: one CLI process per session while background work runs.

/** Fake `query()` that records each spawned process and lets the test drive its output. */
function fakeClaudeSdk() {
  const processes: any[] = [];
  const query = ({ prompt, options }: { prompt: AsyncIterable<any>; options: any }) => {
    const outbox: any[] = [];
    let wake: (() => void) | null = null;
    let ended = false;
    const proc = {
      options,
      prompts: [] as any[],
      inputClosed: false,
      emit(message: any) { outbox.push({ session_id: 'native', ...message }); wake?.(); },
      end() { ended = true; wake?.(); },
    };
    void (async () => {
      for await (const message of prompt) proc.prompts.push(message);
      proc.inputClosed = true;
    })();
    processes.push(proc);
    const stream = (async function* () {
      while (true) {
        while (outbox.length) yield outbox.shift();
        if (ended) return;
        await new Promise<void>((resolve) => { wake = resolve; });
      }
    })();
    return Object.assign(stream, { interrupt: async () => proc.end(), setPermissionMode: async () => {} });
  };
  return { query, processes };
}

async function until(condition: () => boolean) {
  // Time-bounded: the run does real async I/O (MCP config read) before spawning.
  const deadline = Date.now() + 5000;
  while (!condition() && Date.now() < deadline) {
    await new Promise((resolve) => setTimeout(resolve, 2));
  }
  assert.ok(condition(), 'condition not reached');
}

function recordingWriter() {
  const events: any[] = [];
  return { events, userId: null, send(message: any) { events.push(message); }, kinds: () => events.map((event) => event.kind) };
}

async function loadClaudeWithFakeSdk() {
  const sdk = fakeClaudeSdk();
  const runtime = await loadRuntime('claude', 'activeSessions', {
    '@anthropic-ai/claude-agent-sdk': { query: sdk.query },
  });
  const context = {
    resolveProviderSessionId: () => 'native',
    resolveResumeModel: async () => undefined,
    getProviderModels: async () => ({ OPTIONS: [], DEFAULT: 'default' }),
    isProviderInstalled: async () => true,
    normalizeMessage: (message: any) => (message.type === 'assistant' ? [{ kind: 'text', content: 'reply' }] : []),
  };
  return { runtime, sdk, context };
}

test('claude: a message sent while a background agent runs joins the live process', async () => {
  const { runtime, sdk, context } = await loadClaudeWithFakeSdk();
  const followUp = recordingWriter();
  let opened = 0;
  const options = { sessionId: 'app', cwd: '/tmp', openFollowUpRun: () => { opened += 1; return followUp; } };
  const first = recordingWriter();
  const firstRun = runtime.queryClaudeSDK('launch an agent', options, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];
  proc.emit({ type: 'system', subtype: 'task_started', task_id: 't1' });
  proc.emit({ type: 'result' });
  await until(() => first.kinds().includes('complete'));
  assert.ok(first.events.some((event) => event.kind === 'background_tasks' && event.count === 1));

  // The user writes again while t1 is still running.
  const second = recordingWriter();
  const secondRun = runtime.queryClaudeSDK('and another thing', options, second, context);
  await until(() => proc.prompts.length === 2);
  assert.equal(sdk.processes.length, 1, 'no replacement process is spawned');
  assert.equal(proc.inputClosed, false, 'the running agent keeps its permission channel');

  proc.emit({ type: 'user', isReplay: true, uuid: proc.prompts[1].uuid, message: { role: 'user', content: 'and another thing' } });
  proc.emit({ type: 'assistant', message: { content: [{ type: 'text', text: 'pong' }] } });
  proc.emit({ type: 'result' });
  await secondRun;
  // The injected turn's run opens with the live task list (t1 still running).
  assert.deepEqual(second.kinds().filter((kind) => kind !== 'status'), ['background_tasks', 'text', 'complete']);
  assert.deepEqual(second.events[0].tasks.map((task: { id: string }) => task.id), ['t1']);
  assert.equal(first.kinds().filter((kind) => kind === 'complete').length, 1);

  // t1 reports back in a turn the CLI starts on its own — it gets its own run.
  proc.emit({ type: 'system', subtype: 'task_notification', task_id: 't1', status: 'completed' });
  proc.emit({ type: 'assistant', message: { content: [{ type: 'text', text: 'agent finished' }] } });
  proc.emit({ type: 'result' });
  await until(() => proc.inputClosed);
  proc.end();
  await firstRun;
  assert.equal(opened, 1);
  assert.deepEqual(followUp.kinds().filter((kind) => kind !== 'status'), ['background_tasks', 'text', 'complete']);
  // The count dropped before that turn began, so the latest run heard it.
  assert.deepEqual(second.events.filter((event) => event.kind === 'background_tasks').map((event) => event.count), [1, 0]);
});

test('claude: a message the live process cannot take starts a new one', async () => {
  const { runtime, sdk, context } = await loadClaudeWithFakeSdk();
  const first = recordingWriter();
  void runtime.queryClaudeSDK('launch an agent', { sessionId: 'app', cwd: '/tmp' }, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];
  proc.emit({ type: 'system', subtype: 'task_started', task_id: 't1' });
  proc.emit({ type: 'result' });
  await until(() => first.kinds().includes('complete'));

  // A different working directory can't be applied to a running CLI.
  const second = recordingWriter();
  void runtime.queryClaudeSDK('elsewhere', { sessionId: 'app', cwd: '/var/tmp' }, second, context);
  await until(() => sdk.processes.length === 2);
  assert.equal(proc.prompts.length, 1);
  await until(() => proc.inputClosed);
  sdk.processes[1].end();
  proc.end();
});

test('claude: a task that finishes mid-turn keeps stdin open for the turn that reports it', async () => {
  const { runtime, sdk, context } = await loadClaudeWithFakeSdk();
  const followUp = recordingWriter();
  const options = { sessionId: 'app', cwd: '/tmp', openFollowUpRun: () => followUp };
  const first = recordingWriter();
  const run = runtime.queryClaudeSDK('run a slow command', options, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];

  // A command moved to the background and finished before the turn ended.
  proc.emit({ type: 'system', subtype: 'task_started', task_id: 'b1' });
  proc.emit({ type: 'system', subtype: 'task_notification', task_id: 'b1', status: 'completed' });
  proc.emit({ type: 'result' });
  await until(() => first.kinds().includes('complete'));
  await new Promise((resolve) => setTimeout(resolve, 20));
  assert.equal(proc.inputClosed, false, 'the queued report turn still needs the permission channel');

  // The CLI's report turn — afterwards nothing is left, so stdin closes.
  proc.emit({ type: 'assistant', message: { content: [{ type: 'text', text: 'it finished' }] } });
  proc.emit({ type: 'result' });
  await until(() => proc.inputClosed);
  assert.ok(followUp.kinds().includes('complete'));
  proc.end();
  await run;
});

test('claude: the empty result a resumed CLI emits for orphaned tasks does not end the turn', async () => {
  const { runtime, sdk, context } = await loadClaudeWithFakeSdk();
  const first = recordingWriter();
  const run = runtime.queryClaudeSDK('check it', { sessionId: 'app', cwd: '/tmp' }, first, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];

  // Real CLI order after a restart killed its tasks: the orphan report and an
  // empty `result` come before the CLI even replays our prompt.
  proc.emit({ type: 'system', subtype: 'task_notification', task_id: 'gone', status: 'stopped' });
  proc.emit({ type: 'result', subtype: 'success', num_turns: 0 });
  await new Promise((resolve) => setTimeout(resolve, 20));
  assert.equal(proc.inputClosed, false, 'the real turn still needs the permission channel');
  assert.ok(!first.kinds().includes('complete'));

  proc.emit({ type: 'user', isReplay: true, uuid: proc.prompts[0].uuid, message: { role: 'user', content: 'check it' } });
  proc.emit({ type: 'assistant', message: { content: [{ type: 'text', text: 'checked' }] } });
  proc.emit({ type: 'result', subtype: 'success', num_turns: 1 });
  await until(() => proc.inputClosed);
  assert.deepEqual(first.kinds().filter((kind) => kind !== 'status' && kind !== 'background_tasks'), ['text', 'complete']);
  proc.end();
  await run;
});

test('claude: a new process clears a task count an earlier process left on the client', async () => {
  const { runtime, sdk, context } = await loadClaudeWithFakeSdk();
  const writer = recordingWriter();
  void runtime.queryClaudeSDK('hello', { sessionId: 'app', cwd: '/tmp' }, writer, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  assert.deepEqual(writer.events[0], {
    ...writer.events[0],
    kind: 'background_tasks',
    count: 0,
    tasks: [],
  });
  sdk.processes[0].end();
});

test('claude: the context gauge uses the window the CLI reports at spawn, not the 200k fallback', async () => {
  const sdk = fakeClaudeSdk();
  const contextUsage = deferred<{ model: string; rawMaxTokens: number; maxTokens: number }>();
  const stored: Array<[string, number]> = [];
  const runtime = await loadRuntime('claude', 'activeSessions', {
    '@anthropic-ai/claude-agent-sdk': {
      query: (args: any) => Object.assign(sdk.query(args), { getContextUsage: () => contextUsage.promise }),
    },
    '@/modules/database/index.js': {
      orchestratorMessagesDb: { findDelegationByChildSessionId: () => null },
      sessionsDb: { setSessionContextWindow: (id: string, window: number) => stored.push([id, window]) },
    },
  });
  const context = {
    resolveProviderSessionId: () => 'native-window',
    resolveResumeModel: async () => undefined,
    getProviderModels: async () => ({ OPTIONS: [], DEFAULT: 'default' }),
    isProviderInstalled: async () => true,
    normalizeMessage: () => [],
  };
  const writer = recordingWriter();
  const run = runtime.queryClaudeSDK('hi', { sessionId: 'app-window', cwd: '/tmp' }, writer, context);
  await until(() => sdk.processes[0]?.prompts.length === 1);
  const proc = sdk.processes[0];
  const budgets = () => writer.events.filter((event) => event.text === 'token_budget').map((event) => event.tokenBudget.total);

  proc.emit({ type: 'assistant', message: { model: 'claude-spawn-window', usage: { input_tokens: 10, output_tokens: 5 } } });
  await until(() => budgets().length === 1);
  contextUsage.resolve({ model: 'claude-spawn-window[1m]', rawMaxTokens: 1_000_000, maxTokens: 1_000_000 });
  // The reported window re-sizes the gauge mid-turn and is stored for restarts.
  await until(() => budgets().length === 2);
  assert.equal(budgets()[1], 1_000_000);
  assert.deepEqual(stored, [['app-window', 1_000_000]]);

  proc.emit({ type: 'assistant', message: { model: 'claude-spawn-window', usage: { input_tokens: 20, output_tokens: 5 } } });
  proc.emit({ type: 'result' });
  proc.end();
  await run;
  assert.deepEqual(budgets().slice(2), [1_000_000, 1_000_000]);
});

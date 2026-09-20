import assert from 'node:assert/strict';
import http from 'node:http';
import { mkdtemp, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  opencodeRuntime,
  resolveOpenCodePermissionBehavior,
} from './opencode-runtime.provider.js';
import { resetServersForTest } from './opencode-server.manager.js';
import { OpenCodeSessionsProvider } from './opencode-sessions.provider.js';

const sessionsProvider = new OpenCodeSessionsProvider();

const makeContext = (providerSessionId = null) => ({
  resolveProviderSessionId: () => providerSessionId,
  resolveResumeModel: async (_sessionId, requestedModel) => requestedModel || undefined,
  getProviderModels: async () => ({ OPTIONS: [], DEFAULT: '' }),
  normalizeMessage: (raw, sessionId) => sessionsProvider.normalizeMessage(raw, sessionId),
  isProviderInstalled: async () => true,
});

const makeWriter = () => ({
  userId: null,
  sessionId: null,
  messages: [],
  send(message) {
    this.messages.push(message);
  },
  setSessionId(sessionId) {
    this.sessionId = sessionId;
  },
});

/**
 * In-memory `opencode serve` stub. The runtime talks plain HTTP/SSE, so the
 * stub only needs route handlers for session, prompt, permission replies,
 * abort and a hold-open `/event` stream.
 */
function createFakeServe() {
  const state = {
    sseClients: new Set(),
    promptBodies: [],
    permissionReplies: [],
    aborts: [],
    nextSessionId: 1,
    emit(event) {
      const line = `data: ${JSON.stringify(event)}\n\n`;
      for (const res of state.sseClients) {
        res.write(line);
      }
    },
  };

  const server = http.createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');
    let body = '';
    req.on('data', (chunk) => { body += chunk; });
    req.on('end', () => {
      let parsed = null;
      try {
        parsed = body ? JSON.parse(body) : null;
      } catch { /* ignore */ }

      if (req.method === 'GET' && url.pathname === '/config') {
        res.setHeader('Content-Type', 'application/json');
        res.end('{}');
        return;
      }
      if (req.method === 'GET' && url.pathname === '/event') {
        res.writeHead(200, { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' });
        res.write('data: {"type":"server.connected"}\n\n');
        state.sseClients.add(res);
        // 'close' must hang off the response — on a GET the request's close
        // fires as soon as the headers are read, which would drop this client
        // from the set before any emit reaches it.
        res.on('close', () => state.sseClients.delete(res));
        return;
      }
      if (req.method === 'POST' && url.pathname === '/session') {
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify({ id: `ses_fake_${state.nextSessionId++}` }));
        return;
      }
      const sessionGet = url.pathname.match(/^\/session\/([^/]+)$/);
      if (req.method === 'GET' && sessionGet) {
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(state.sessionRecords?.[sessionGet[1]] ?? {}));
        return;
      }
      const prompt = url.pathname.match(/^\/session\/([^/]+)\/prompt_async$/);
      if (req.method === 'POST' && prompt) {
        state.promptBodies.push({ sessionID: prompt[1], body: parsed });
        res.statusCode = 204;
        res.end();
        return;
      }
      const permission = url.pathname.match(/^\/session\/([^/]+)\/permissions\/([^/]+)$/);
      if (req.method === 'POST' && permission) {
        state.permissionReplies.push({
          sessionID: permission[1],
          permissionID: permission[2],
          response: parsed?.response,
        });
        res.end('true');
        return;
      }
      const abort = url.pathname.match(/^\/session\/([^/]+)\/abort$/);
      if (req.method === 'POST' && abort) {
        state.aborts.push(abort[1]);
        res.statusCode = 204;
        res.end();
        return;
      }
      res.statusCode = 404;
      res.end();
    });
  });

  return { server, state };
}

async function waitFor(condition, timeoutMs = 5000) {
  const start = Date.now();
  while (!condition()) {
    if (Date.now() - start > timeoutMs) {
      throw new Error('Timed out waiting for condition');
    }
    await new Promise((resolve) => setTimeout(resolve, 10));
  }
}

async function withFakeServe(fn) {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-serve-test-'));
  const { server, state } = createFakeServe();
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const baseUrl = `http://127.0.0.1:${server.address().port}`;
  const previous = process.env.OPENCODE_SERVE_BASE_URL;
  process.env.OPENCODE_SERVE_BASE_URL = baseUrl;
  resetServersForTest();

  try {
    await fn({ state, tempRoot, baseUrl });
  } finally {
    if (previous === undefined) {
      delete process.env.OPENCODE_SERVE_BASE_URL;
    } else {
      process.env.OPENCODE_SERVE_BASE_URL = previous;
    }
    resetServersForTest();
    // Hold-open SSE responses would otherwise keep server.close pending.
    for (const res of state.sseClients) {
      res.end();
    }
    server.closeAllConnections?.();
    await new Promise((resolve) => server.close(resolve));
    await rm(tempRoot, { recursive: true, force: true });
  }
}

const textPartEvent = (sessionID, text) => ({
  type: 'message.part.updated',
  properties: {
    sessionID,
    part: { type: 'text', text, id: 'prt_1', messageID: 'msg_1', sessionID },
    time: Date.now(),
  },
});

const idleEvent = (sessionID) => ({
  type: 'session.idle',
  properties: { sessionID },
});

// Real `opencode serve` emits session.status busy when a turn starts and
// idle when it ends — the runtime only accepts an idle as terminal for a
// run that saw its own busy.
const busyEvent = (sessionID) => ({
  type: 'session.status',
  properties: { sessionID, status: { type: 'busy' } },
});

const askedEvent = (sessionID, id, permission) => ({
  type: 'permission.asked',
  properties: {
    id,
    sessionID,
    permission,
    patterns: ['echo *'],
    metadata: { command: 'echo hi' },
    always: ['echo *'],
    tool: { messageID: 'msg_1', callID: 'call_1' },
  },
});

test('run creates a provider session, posts prompt_async and completes on session.idle', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    assert.equal(state.promptBodies[0].sessionID, 'ses_fake_1');
    assert.equal(state.promptBodies[0].body.parts[0].text, 'Hi');
    assert.equal(state.promptBodies[0].body.agent, undefined);

    state.emit(textPartEvent('ses_fake_1', 'assistant response'));
    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;

    const created = writer.messages.findIndex((m) => m.kind === 'session_created');
    const textIndex = writer.messages.findIndex((m) => m.kind === 'text' && m.content === 'assistant response');
    const complete = writer.messages.find((m) => m.kind === 'complete');
    assert.notEqual(created, -1);
    assert.ok(created < textIndex);
    assert.equal(writer.messages[created].newSessionId, 'ses_fake_1');
    assert.equal(writer.sessionId, 'ses_fake_1');
    assert.equal(complete?.exitCode, 0);
    assert.equal(writer.messages.some((m) => m.kind === 'error'), false);
  });
});

test('run resumes an existing provider session without session_created', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-2' },
      writer,
      makeContext('ses_existing'),
    );

    await waitFor(() => state.promptBodies.length === 1);
    assert.equal(state.promptBodies[0].sessionID, 'ses_existing');
    state.emit(busyEvent('ses_existing'));
    state.emit(idleEvent('ses_existing'));
    await run;

    assert.equal(writer.messages.some((m) => m.kind === 'session_created'), false);
    assert.equal(writer.messages.some((m) => m.kind === 'complete'), true);
  });
});

test('run ignores a stored provider session bound to another directory', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    // opencode serve is global — a repointed workspace must not resume the
    // session rooted in the old directory, it starts a fresh one instead.
    state.sessionRecords = { ses_old: { id: 'ses_old', directory: '/tmp/other-dir' } };
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-9' },
      writer,
      makeContext('ses_old'),
    );

    await waitFor(() => state.promptBodies.length === 1);
    assert.equal(state.promptBodies[0].sessionID, 'ses_fake_1');
    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;

    assert.equal(writer.messages.some((m) => m.kind === 'session_created'), true);
    assert.equal(writer.sessionId, 'ses_fake_1');
  });
});

test('bypassPermissions auto-approves permission.asked with a once reply', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-3', permissionMode: 'bypassPermissions' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(askedEvent('ses_fake_1', 'per_1', 'bash'));
    await waitFor(() => state.permissionReplies.length === 1);

    assert.equal(state.permissionReplies[0].permissionID, 'per_1');
    assert.equal(state.permissionReplies[0].response, 'once');
    assert.equal(writer.messages.some((m) => m.kind === 'permission_request'), false);

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('acceptEdits auto-approves edit asks but forwards bash to the UI', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-4', permissionMode: 'acceptEdits' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(askedEvent('ses_fake_1', 'per_edit', 'edit'));
    await waitFor(() => state.permissionReplies.length === 1);
    assert.equal(state.permissionReplies[0].response, 'once');

    state.emit(askedEvent('ses_fake_1', 'per_bash', 'bash'));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));
    const request = writer.messages.find((m) => m.kind === 'permission_request');
    assert.equal(request.requestId, 'per_bash');
    assert.equal(request.toolName, 'bash');

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('default mode forwards asks and permissions.resolve replies to the server', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-5', permissionMode: 'default' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(askedEvent('ses_fake_1', 'per_a', 'bash'));
    state.emit(askedEvent('ses_fake_1', 'per_b', 'bash'));
    await waitFor(() => writer.messages.filter((m) => m.kind === 'permission_request').length === 2);

    assert.deepEqual(
      opencodeRuntime.permissions.listPending('app-5').map((p) => p.requestId),
      ['per_a', 'per_b'],
    );

    opencodeRuntime.permissions.resolve('per_a', { allow: true });
    opencodeRuntime.permissions.resolve('per_b', { allow: false });
    await waitFor(() => state.permissionReplies.length === 2);
    assert.equal(state.permissionReplies[0].response, 'once');
    assert.equal(state.permissionReplies[1].response, 'reject');

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('setPermissionMode to bypass auto-approves asks already pending mid-run', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-6', permissionMode: 'default' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(askedEvent('ses_fake_1', 'per_live', 'bash'));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));

    opencodeRuntime.setPermissionMode('app-6', 'bypassPermissions');
    await waitFor(() => state.permissionReplies.length === 1);
    assert.equal(state.permissionReplies[0].response, 'once');
    assert.equal(
      writer.messages.some((m) => m.kind === 'permission_cancelled' && m.requestId === 'per_live'),
      true,
    );

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('plan mode sends the plan agent on prompt_async', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-7', permissionMode: 'plan' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    assert.equal(state.promptBodies[0].body.agent, 'plan');

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('a stale session.idle arriving before the prompt posts does not settle the run', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-10' }, writer, makeContext('ses_stale'));

    // The aborted/previous turn's trailing idle arrives while the new run is
    // still in setup — it must neither resolve the run nor skip the prompt.
    state.emit(idleEvent('ses_stale'));

    let settled = false;
    void run.then(() => { settled = true; }, () => { settled = true; });
    await new Promise((resolve) => setTimeout(resolve, 100));
    assert.equal(settled, false);

    await waitFor(() => state.promptBodies.length === 1);
    assert.equal(state.promptBodies[0].sessionID, 'ses_stale');

    state.emit(busyEvent('ses_stale'));
    state.emit(idleEvent('ses_stale'));
    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('an idle with no busy still completes the run after the grace window', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-11' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    // A turn that produced no busy event must not hang forever.
    state.emit(idleEvent('ses_fake_1'));
    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('abort posts to the session abort endpoint and resolves the run', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-8' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const didAbort = await opencodeRuntime.abort('app-8');
    assert.equal(didAbort, true);
    await run;

    assert.deepEqual(state.aborts, ['ses_fake_1']);
  });
});

test('resolveOpenCodePermissionBehavior maps UI modes to approval behavior', () => {
  assert.deepEqual(resolveOpenCodePermissionBehavior('plan'), { agent: 'plan', autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('bypassPermissions'), { autoApprove: 'all' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('acceptEdits'), { autoApprove: 'edits' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('default'), { autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior(undefined), { autoApprove: 'none' });
});

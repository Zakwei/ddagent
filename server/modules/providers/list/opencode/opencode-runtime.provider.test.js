import assert from 'node:assert/strict';
import http from 'node:http';
import { mkdtemp, rm } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import test from 'node:test';

import {
  opencodeRuntime,
  reconcileActiveRuns,
  resolveOpenCodePermissionBehavior,
} from './opencode-runtime.provider.js';
import { resetServersForTest, setServerForTest } from './opencode-server.manager.js';
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
    sseConnects: 0,
    sseLastEventIds: [],
    promptBodies: [],
    permissionReplies: [],
    questionReplies: [],
    questionRejects: [],
    aborts: [],
    disposes: [],
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
        state.sseConnects += 1;
        state.sseLastEventIds.push(req.headers['last-event-id'] ?? null);
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
      // Must precede /session/:id — the bare-id regex would swallow 'status'.
      if (req.method === 'GET' && url.pathname === '/session/status') {
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(state.sessionStatuses ?? {}));
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
      const questionReply = url.pathname.match(/^\/question\/([^/]+)\/reply$/);
      if (req.method === 'POST' && questionReply) {
        state.questionReplies.push({ requestID: questionReply[1], answers: parsed?.answers });
        res.end('true');
        return;
      }
      const questionReject = url.pathname.match(/^\/question\/([^/]+)\/reject$/);
      if (req.method === 'POST' && questionReject) {
        state.questionRejects.push(questionReject[1]);
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
      if (req.method === 'POST' && url.pathname === '/instance/dispose') {
        state.disposes.push(url.searchParams.get('directory'));
        res.end('true');
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
  const previousStall = process.env.OPENCODE_SSE_STALL_MS;
  const previousRetryStall = process.env.OPENCODE_RETRY_STALL_MS;
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
    if (previousStall === undefined) {
      delete process.env.OPENCODE_SSE_STALL_MS;
    } else {
      process.env.OPENCODE_SSE_STALL_MS = previousStall;
    }
    if (previousRetryStall === undefined) {
      delete process.env.OPENCODE_RETRY_STALL_MS;
    } else {
      process.env.OPENCODE_RETRY_STALL_MS = previousRetryStall;
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

const toolPartEvent = (sessionID, { id, messageID, tool, input, output, metadata }) => ({
  type: 'message.part.updated',
  properties: {
    sessionID,
    part: {
      type: 'tool',
      id,
      messageID,
      callID: `${id}_call`,
      tool,
      state: { status: 'completed', input, output, metadata },
      sessionID,
    },
    time: Date.now(),
  },
});

const patchPartEvent = (sessionID, { id, messageID }) => ({
  type: 'message.part.updated',
  properties: {
    sessionID,
    part: { type: 'patch', id, messageID, hash: 'abc123', files: ['/repo/a.ts'], sessionID },
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

const questionAskedEvent = (sessionID, id, questions) => ({
  type: 'question.asked',
  properties: {
    id,
    sessionID,
    questions,
    tool: { messageID: 'msg_1', callID: 'call_1' },
  },
});

const sampleQuestions = [
  {
    question: 'Which approach?',
    header: 'Approach',
    options: [
      { label: 'Fast', description: 'Ship it' },
      { label: 'Safe', description: 'Test it' },
    ],
  },
  {
    question: 'Which files?',
    header: 'Files',
    multiple: true,
    options: [{ label: 'a.ts', description: 'a' }, { label: 'b.ts', description: 'b' }],
  },
];

test('question.asked is forwarded to the UI and resolve replies with positional answers', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-q1', permissionMode: 'default' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(questionAskedEvent('ses_fake_1', 'que_1', sampleQuestions));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));

    const request = writer.messages.find((m) => m.kind === 'permission_request');
    assert.equal(request.requestId, 'que_1');
    assert.equal(request.toolName, 'AskUserQuestion');
    assert.equal(request.input.questions.length, 2);
    assert.equal(request.input.questions[0].options[0].label, 'Fast');
    assert.deepEqual(
      opencodeRuntime.permissions.listPending('app-q1').map((p) => p.requestId),
      ['que_1'],
    );

    opencodeRuntime.permissions.resolve('que_1', {
      allow: true,
      updatedInput: {
        questions: sampleQuestions,
        answers: {
          'Which approach?': 'Fast',
          'Which files?': 'a.ts, b.ts',
        },
      },
    });
    await waitFor(() => state.questionReplies.length === 1);
    assert.equal(state.questionReplies[0].requestID, 'que_1');
    assert.deepEqual(state.questionReplies[0].answers, [['Fast'], ['a.ts', 'b.ts']]);
    assert.equal(opencodeRuntime.permissions.listPending('app-q1').length, 0);

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('question.asked skip (empty answers) replies with empty selections', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-q2', permissionMode: 'default' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(questionAskedEvent('ses_fake_1', 'que_skip', sampleQuestions));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));

    opencodeRuntime.permissions.resolve('que_skip', { allow: true, updatedInput: { answers: {} } });
    await waitFor(() => state.questionReplies.length === 1);
    assert.deepEqual(state.questionReplies[0].answers, [[], []]);

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('question.asked reject posts to the question reject endpoint', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-q3', permissionMode: 'default' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(questionAskedEvent('ses_fake_1', 'que_rej', sampleQuestions));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));

    opencodeRuntime.permissions.resolve('que_rej', { allow: false });
    await waitFor(() => state.questionRejects.length === 1);
    assert.equal(state.questionRejects[0], 'que_rej');

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('question.v2.asked (nested data) is forwarded and bypass auto-answers it', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run(
      'Hi',
      { cwd: tempRoot, sessionId: 'app-q4', permissionMode: 'bypassPermissions' },
      writer,
      makeContext(),
    );

    await waitFor(() => state.promptBodies.length === 1);
    state.emit({
      type: 'question.v2.asked',
      properties: { id: 'que_v2', sessionID: 'ses_fake_1', questions: sampleQuestions },
    });
    await waitFor(() => state.questionReplies.length === 1);
    assert.equal(state.questionReplies[0].requestID, 'que_v2');
    assert.deepEqual(state.questionReplies[0].answers, [[], []]);
    assert.equal(writer.messages.some((m) => m.kind === 'permission_request'), false);

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
  });
});

test('question.replied clears a pending question for another client', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-q5' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(questionAskedEvent('ses_fake_1', 'que_other', sampleQuestions));
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_request'));

    state.emit({
      type: 'question.replied',
      properties: { sessionID: 'ses_fake_1', requestID: 'que_other', answers: [['Fast'], []] },
    });
    await waitFor(() => writer.messages.some((m) => m.kind === 'permission_cancelled' && m.requestId === 'que_other'));

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

const deltaEvent = (sessionID, partID, delta, field = 'text') => ({
  type: 'message.part.delta',
  properties: { sessionID, messageID: 'msg_1', partID, field, delta },
});

const partUpdateEvent = (sessionID, partID, partType, text = '') => ({
  type: 'message.part.updated',
  properties: {
    sessionID,
    part: { type: partType, text, id: partID, messageID: 'msg_1', sessionID },
    time: Date.now(),
  },
});

test('message.part.delta forwards live stream_delta/thought_delta chunks', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-d1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    // Reasoning part announced first, then its deltas stream as thought_delta.
    state.emit(partUpdateEvent(sid, 'prt_r1', 'reasoning', ''));
    state.emit(deltaEvent(sid, 'prt_r1', 'thinking…'));
    state.emit(deltaEvent(sid, 'prt_r1', ' still thinking'));
    // Text part: creation update, two deltas, then the final snapshot.
    state.emit(partUpdateEvent(sid, 'prt_t1', 'text', ''));
    state.emit(deltaEvent(sid, 'prt_t1', 'Hello '));
    state.emit(deltaEvent(sid, 'prt_t1', 'world'));
    // The final text snapshot must be suppressed too, not just reasoning's:
    // its deltas already streamed, and re-sending it as a `text` row would
    // duplicate the live row (the client's echo dedupe only merges adjacent
    // twins, so an interleaved tool row keeps the duplicate visible).
    state.emit(partUpdateEvent(sid, 'prt_t1', 'text', 'Hello world'));
    // Final reasoning snapshot must be suppressed — its deltas already streamed.
    state.emit(partUpdateEvent(sid, 'prt_r1', 'reasoning', 'thinking… still thinking'));
    state.emit(busyEvent(sid));
    state.emit(idleEvent(sid));
    await run;

    const deltas = writer.messages.filter((m) => m.kind === 'stream_delta').map((m) => m.content);
    const thoughts = writer.messages.filter((m) => m.kind === 'thought_delta').map((m) => m.content);
    assert.deepEqual(deltas, ['Hello ', 'world']);
    assert.deepEqual(thoughts, ['thinking…', ' still thinking']);
    assert.equal(writer.messages.some((m) => m.kind === 'text' && m.content === 'Hello world'), false);
    assert.equal(writer.messages.some((m) => m.kind === 'thinking'), false);
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('the auto-generated patch echo of a live edit tool is dropped', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-patch-echo' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    // The edit tool carries the diff in its own metadata; OpenCode then mirrors
    // it with a `patch` part in the same message. Only the edit must render.
    state.emit(toolPartEvent(sid, {
      id: 'prt_e1',
      messageID: 'msg_1',
      tool: 'edit',
      input: { filePath: '/repo/a.ts', oldString: 'x', newString: 'y' },
      output: 'Edit applied successfully.',
      metadata: { diff: 'Index: /repo/a.ts\n+added' },
    }));
    state.emit(patchPartEvent(sid, { id: 'prt_p1', messageID: 'msg_1' }));
    // A genuine standalone patch in a message with no edit tool still renders.
    state.emit(patchPartEvent(sid, { id: 'prt_p2', messageID: 'msg_2' }));
    state.emit(busyEvent(sid));
    state.emit(idleEvent(sid));
    await run;

    const editRows = writer.messages.filter((m) => m.kind === 'tool_use' && m.toolName === 'edit');
    const patchRows = writer.messages.filter((m) => m.kind === 'tool_use' && m.toolName === 'Patch');
    assert.equal(editRows.length, 1);
    assert.equal(patchRows.length, 1);
    assert.equal((patchRows[0].toolInput ?? {}).id, 'prt_p2');
    assert.match(editRows[0].toolResult.content, /\+added/);
  });
});

test('a turn that finished while the event stream was down completes via the status resync', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-sse1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit(busyEvent(sid));

    // The stream drops and the turn finishes while it is down — its
    // session.idle never arrives. The reconnect's /session/status resync
    // must settle the run instead of letting it hang.
    state.sessionStatuses = { [sid]: { type: 'idle' } };
    for (const res of state.sseClients) {
      res.end();
    }
    state.sseClients.clear();

    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('a finished turn omitted from the status map settles after the resync re-polls', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-sse2' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit(busyEvent(sid));

    // This build omits finished sessions from /session/status entirely, so
    // the post-reconnect poll finds no entry at all. The resync must confirm
    // the absence over its bounded re-polls and settle the run.
    state.sessionStatuses = {};
    for (const res of state.sseClients) {
      res.end();
    }
    state.sseClients.clear();

    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('a stalled (half-open) event stream is aborted and reconnected', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    process.env.OPENCODE_SSE_STALL_MS = '300';
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-stall' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    // A tagged event seeds the Last-Event-ID cursor for the reconnect.
    state.emit({ id: 'ev-42', ...busyEvent(sid) });

    // The first connection never delivers anything again — the watchdog must
    // notice the silence and re-establish the stream on its own.
    await waitFor(() => state.sseConnects >= 2);
    assert.equal(state.sseLastEventIds[0], null);
    assert.equal(state.sseLastEventIds[1], 'ev-42');

    state.emit(idleEvent(sid));
    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('a run survives its serve process being replaced mid-turn', async () => {
  const tempRoot = await mkdtemp(path.join(os.tmpdir(), 'opencode-serve-test-'));
  const first = createFakeServe();
  const second = createFakeServe();
  await new Promise((resolve) => first.server.listen(0, '127.0.0.1', resolve));
  await new Promise((resolve) => second.server.listen(0, '127.0.0.1', resolve));
  const firstUrl = `http://127.0.0.1:${first.server.address().port}`;
  const secondUrl = `http://127.0.0.1:${second.server.address().port}`;
  resetServersForTest();
  // The env seam would bypass the servers map entirely — inject handles so
  // the real ensureServer/getServer lookups drive the run.
  setServerForTest(tempRoot, { baseUrl: firstUrl, directory: tempRoot, child: null });

  try {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-fo1' }, writer, makeContext());
    await waitFor(() => first.state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    first.state.emit(busyEvent(sid));

    // The serve process dies and its replacement is already registered —
    // the event stream must hop to the new port instead of failing the run
    // after a retry budget spent on a dead one.
    setServerForTest(tempRoot, { baseUrl: secondUrl, directory: tempRoot, child: null });
    for (const res of first.state.sseClients) {
      res.end();
    }
    first.server.closeAllConnections();
    await new Promise((resolve) => first.server.close(resolve));

    await waitFor(() => second.state.sseConnects >= 1);
    second.state.emit(busyEvent(sid));
    second.state.emit(idleEvent(sid));
    await run;

    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
    assert.equal(writer.messages.some((m) => m.kind === 'error'), false);
  } finally {
    resetServersForTest();
    for (const res of [...first.state.sseClients, ...second.state.sseClients]) {
      res.end();
    }
    second.server.closeAllConnections?.();
    await new Promise((resolve) => second.server.close(resolve));
    await rm(tempRoot, { recursive: true, force: true });
  }
});

test('periodic status reconcile settles a run whose terminal idle was missed', async () => {
  await withFakeServe(async ({ state, tempRoot, baseUrl }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-rec1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit(busyEvent(sid));

    // The stream stays connected but the session.idle event never arrives.
    // The status poll must settle the run on its own.
    state.sessionStatuses = { [sid]: { type: 'idle' } };
    await reconcileActiveRuns(baseUrl);

    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('a busy status observed in reconcile adopts the turn so a later idle settles', async () => {
  await withFakeServe(async ({ state, tempRoot, baseUrl }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-rec2' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';

    // The SSE busy event was lost; the status map still reports the turn as
    // live. Reconcile must credit the run with its own busy so the eventual
    // idle is accepted instead of debated as stale.
    state.sessionStatuses = { [sid]: { type: 'busy' } };
    await reconcileActiveRuns(baseUrl);

    state.emit(idleEvent(sid));
    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
  });
});

test('a session.status retry surfaces a rate-limit status to the client', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-rl1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit({
      type: 'session.status',
      properties: { sessionID: sid, status: { type: 'retry', attempt: 2, message: 'Rate Limited' } },
    });
    await waitFor(() => writer.messages.some((m) => m.kind === 'status' && m.text?.includes('retry')));

    const statusMessage = writer.messages.find((m) => m.kind === 'status');
    assert.equal(statusMessage.text, 'Rate Limited — retry 2');

    state.emit(busyEvent(sid));
    state.emit(idleEvent(sid));
    await run;
  });
});

test('a provider retry that stops advancing aborts the wedged turn instead of hanging', async () => {
  await withFakeServe(async ({ state, tempRoot, baseUrl }) => {
    process.env.OPENCODE_RETRY_STALL_MS = '150';
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-rs1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit({
      type: 'session.status',
      properties: { sessionID: sid, status: { type: 'retry', attempt: 1, message: 'Provider response headers timed out' } },
    });
    state.sessionStatuses = { [sid]: { type: 'retry', attempt: 1 } };

    // The attempt counter never advances — the provider call is hung past
    // its own timeout. The status poll must abort the wedged turn and fail
    // the run instead of spinning on "retry 1" forever.
    await new Promise((resolve) => setTimeout(resolve, 250));
    await reconcileActiveRuns(baseUrl);

    await assert.rejects(run, /retry stalled/);
    assert.deepEqual(state.aborts, [sid]);
    assert.equal(writer.messages.some((m) => m.kind === 'error' && /retry stalled/.test(m.content)), true);
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 1), true);
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

const abortedAssistantEvent = (sessionID, outputTokens = 0) => ({
  type: 'message.updated',
  properties: {
    sessionID,
    info: {
      id: 'msg_aborted',
      role: 'assistant',
      sessionID,
      error: { name: 'MessageAbortedError', data: { message: 'Aborted' } },
      tokens: { input: 0, output: outputTokens, reasoning: 0, cache: { read: 0, write: 0 } },
    },
  },
});

test('an instant MessageAbortedError resets the instance and retries the prompt once', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-p1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    // Poisoned directory instance (opencode #30144): the turn dies instantly
    // with no tokens, and its trailing session.idle must not settle the run.
    state.emit(abortedAssistantEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));

    await waitFor(() => state.disposes.length === 1);
    assert.equal(state.disposes[0], tempRoot);
    await waitFor(() => state.promptBodies.length === 2);
    assert.equal(state.promptBodies[1].body.parts[0].text, 'Hi');
    // Let the repost response land so the run leaves the recovering state.
    await new Promise((resolve) => setTimeout(resolve, 50));

    let settled = false;
    void run.then(() => { settled = true; }, () => { settled = true; });
    assert.equal(settled, false);

    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await run;
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 0), true);
    assert.equal(writer.messages.some((m) => m.kind === 'error'), false);
  });
});

test('a second instant abort after the retry does not loop', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-p2' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    state.emit(abortedAssistantEvent('ses_fake_1'));
    await waitFor(() => state.promptBodies.length === 2);
    await new Promise((resolve) => setTimeout(resolve, 50));

    // Still poisoned after one retry — the run must fail instead of looping,
    // so a caller (the orchestrator) can fail over to the next candidate.
    state.emit(abortedAssistantEvent('ses_fake_1'));
    await assert.rejects(run, /Aborted/);

    assert.equal(state.promptBodies.length, 2);
    assert.equal(state.disposes.length, 1);
  });
});

test('a user-aborted turn does not trigger instance dispose', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-p3' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const didAbort = await opencodeRuntime.abort('app-p3');
    assert.equal(didAbort, true);
    state.emit(abortedAssistantEvent('ses_fake_1'));
    await new Promise((resolve) => setTimeout(resolve, 100));

    assert.equal(state.disposes.length, 0);
    assert.equal(state.promptBodies.length, 1);
    await run;
  });
});

test('an aborted assistant message carrying tokens is not retried', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-p4' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    // A mid-stream provider abort already produced output — replaying the
    // prompt would duplicate it, so the turn fails through normally.
    state.emit(abortedAssistantEvent('ses_fake_1', 5));
    state.emit(busyEvent('ses_fake_1'));
    state.emit(idleEvent('ses_fake_1'));
    await assert.rejects(run, /Aborted/);

    assert.equal(state.disposes.length, 0);
    assert.equal(state.promptBodies.length, 1);
  });
});

const erroredAssistantEvent = (sessionID, name, message) => ({
  type: 'message.updated',
  properties: {
    sessionID,
    info: {
      id: 'msg_err',
      role: 'assistant',
      sessionID,
      error: { name, data: { message } },
      tokens: { input: 5, output: 3, reasoning: 0, cache: { read: 0, write: 0 } },
    },
  },
});

test('a terminal assistant-message error fails the run instead of idle-settling as success', async () => {
  await withFakeServe(async ({ state, tempRoot }) => {
    const writer = makeWriter();
    const run = opencodeRuntime.run('Hi', { cwd: tempRoot, sessionId: 'app-err1' }, writer, makeContext());

    await waitFor(() => state.promptBodies.length === 1);
    const sid = 'ses_fake_1';
    state.emit(busyEvent(sid));
    state.emit(erroredAssistantEvent(sid, 'APIError', 'All 2 account(s) rate-limited for claude'));
    state.emit(idleEvent(sid));

    await assert.rejects(run, /rate-limited/);
    assert.equal(writer.messages.some((m) => m.kind === 'error' && /rate-limited/.test(m.content)), true);
    assert.equal(writer.messages.some((m) => m.kind === 'complete' && m.exitCode === 1), true);
  });
});

test('resolveOpenCodePermissionBehavior maps UI modes to approval behavior', () => {
  assert.deepEqual(resolveOpenCodePermissionBehavior('plan'), { agent: 'plan', autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('bypassPermissions'), { autoApprove: 'all' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('acceptEdits'), { autoApprove: 'edits' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('default'), { autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior(undefined), { autoApprove: 'none' });
});

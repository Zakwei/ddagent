import assert from 'node:assert/strict';
import http from 'node:http';
import { mkdtemp, rm, writeFile } from 'node:fs/promises';
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
const TEST_PASSWORD = 'test-serve-password';

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
 * In-memory OpenCode 2 `serve` stub: the `/api/*` routes the runtime uses
 * (basic auth, JSON envelopes, SSE at `/api/event`) with recorders for every
 * request the tests assert on.
 */
function createFakeServe() {
  const state = {
    sseClients: new Set(),
    sseConnects: 0,
    sseLastEventIds: [],
    authHeaders: [],
    promptBodies: [],
    modelBodies: [],
    agentBodies: [],
    permissionReplies: [],
    formReplies: [],
    formCancels: [],
    interrupts: [],
    evictions: [],
    nextSessionId: 1,
    /** `GET /api/session/active` body — session id → `{ type: 'running' }`. */
    active: {},
    /** `GET /api/session/:id` records (`location.directory` matters). */
    sessionRecords: {},
    interruptedResponse: undefined,
    emit(event) {
      const line = `data: ${JSON.stringify(event)}\n\n`;
      for (const res of state.sseClients) {
        res.write(line);
      }
    },
  };

  const server = http.createServer((req, res) => {
    const url = new URL(req.url, 'http://localhost');
    state.authHeaders.push(req.headers.authorization ?? null);
    let body = '';
    req.on('data', (chunk) => { body += chunk; });
    req.on('end', () => {
      let parsed = null;
      try {
        parsed = body ? JSON.parse(body) : null;
      } catch { /* ignore */ }
      const json = (payload, status = 200) => {
        res.statusCode = status;
        res.setHeader('Content-Type', 'application/json');
        res.end(JSON.stringify(payload));
      };
      const noContent = () => {
        res.statusCode = 204;
        res.end();
      };

      if (req.method === 'GET' && url.pathname === '/api/info') {
        json({ version: '2.0.32', pid: process.pid, urls: [], paths: { tmp: os.tmpdir() } });
        return;
      }
      if (req.method === 'GET' && url.pathname === '/api/event') {
        state.sseConnects += 1;
        state.sseLastEventIds.push(req.headers['last-event-id'] ?? null);
        res.writeHead(200, { 'Content-Type': 'text/event-stream', 'Cache-Control': 'no-cache' });
        res.write('data: {"type":"server.connected","data":{}}\n\n');
        state.sseClients.add(res);
        res.on('close', () => state.sseClients.delete(res));
        return;
      }
      if (req.method === 'POST' && url.pathname === '/api/session') {
        const id = `ses_fake_${state.nextSessionId++}`;
        json({ data: { id, location: parsed?.location ?? {}, title: parsed?.title ?? '' } });
        state.onSessionCreated?.(id);
        return;
      }
      if (req.method === 'GET' && url.pathname === '/api/session/active') {
        json({ data: state.active });
        return;
      }
      const sessionGet = url.pathname.match(/^\/api\/session\/([^/]+)$/);
      if (req.method === 'GET' && sessionGet) {
        json({ data: state.sessionRecords?.[sessionGet[1]] ?? { id: sessionGet[1] } });
        return;
      }
      const model = url.pathname.match(/^\/api\/session\/([^/]+)\/model$/);
      if (req.method === 'POST' && model) {
        state.modelBodies.push({ sessionID: model[1], body: parsed });
        noContent();
        return;
      }
      const agent = url.pathname.match(/^\/api\/session\/([^/]+)\/agent$/);
      if (req.method === 'POST' && agent) {
        state.agentBodies.push({ sessionID: agent[1], body: parsed });
        noContent();
        return;
      }
      const prompt = url.pathname.match(/^\/api\/session\/([^/]+)\/prompt$/);
      if (req.method === 'POST' && prompt) {
        state.promptBodies.push({ sessionID: prompt[1], body: parsed, directory: url.searchParams.get('location[directory]') });
        json({ data: { id: `msg_${state.promptBodies.length}`, sessionID: prompt[1], type: 'user', payload: { text: parsed?.text } } });
        return;
      }
      const permission = url.pathname.match(/^\/api\/session\/([^/]+)\/permission\/([^/]+)\/reply$/);
      if (req.method === 'POST' && permission) {
        state.permissionReplies.push({
          sessionID: permission[1],
          permissionID: permission[2],
          decision: parsed?.decision,
          message: parsed?.message,
        });
        noContent();
        return;
      }
      const formReply = url.pathname.match(/^\/api\/session\/([^/]+)\/form\/([^/]+)\/reply$/);
      if (req.method === 'POST' && formReply) {
        state.formReplies.push({ sessionID: formReply[1], formID: formReply[2], answer: parsed?.answer });
        noContent();
        return;
      }
      const formCancel = url.pathname.match(/^\/api\/session\/([^/]+)\/form\/([^/]+)$/);
      if (req.method === 'DELETE' && formCancel) {
        state.formCancels.push({ sessionID: formCancel[1], formID: formCancel[2] });
        noContent();
        return;
      }
      const interrupt = url.pathname.match(/^\/api\/session\/([^/]+)\/interrupt$/);
      if (req.method === 'POST' && interrupt) {
        state.interrupts.push(interrupt[1]);
        state.onInterrupt?.(interrupt[1]);
        setTimeout(() => json({ interrupted: state.interruptedResponse ?? true }), state.interruptDelayMs ?? 0);
        return;
      }
      if (req.method === 'DELETE' && url.pathname === '/api/debug/location') {
        state.evictions.push(url.searchParams.get('location[directory]'));
        noContent();
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
  const previous = {
    OPENCODE_SERVE_BASE_URL: process.env.OPENCODE_SERVE_BASE_URL,
    OPENCODE_SERVE_PASSWORD: process.env.OPENCODE_SERVE_PASSWORD,
    OPENCODE_SSE_STALL_MS: process.env.OPENCODE_SSE_STALL_MS,
    OPENCODE_RETRY_STALL_MS: process.env.OPENCODE_RETRY_STALL_MS,
  };
  process.env.OPENCODE_SERVE_BASE_URL = baseUrl;
  process.env.OPENCODE_SERVE_PASSWORD = TEST_PASSWORD;
  resetServersForTest();
  try {
    await fn({ state, tempRoot, baseUrl });
  } finally {
    for (const [key, value] of Object.entries(previous)) {
      if (value === undefined) {
        delete process.env[key];
      } else {
        process.env[key] = value;
      }
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

// --- OpenCode 2 event envelopes (`{ type, data }`) ---
const ev = (type, data) => ({ type, data });
const executionStarted = (sessionID) => ev('session.execution.started', { sessionID });
const stepStarted = (sessionID, assistantMessageID = 'msg_a') => ev('session.step.started', { sessionID, assistantMessageID, agent: 'build' });
const textStarted = (sessionID, ordinal = 0, assistantMessageID = 'msg_a') => ev('session.text.started', { sessionID, assistantMessageID, ordinal });
const textDelta = (sessionID, delta, ordinal = 0, assistantMessageID = 'msg_a') => ev('session.text.delta', { sessionID, assistantMessageID, ordinal, delta });
const textEnded = (sessionID, text, ordinal = 0, assistantMessageID = 'msg_a') => ev('session.text.ended', { sessionID, assistantMessageID, ordinal, text });
const toolInputStarted = (sessionID, id, name, assistantMessageID = 'msg_a') => ev('session.tool.input.started', { sessionID, assistantMessageID, id, name });
const toolCalled = (sessionID, id, input, assistantMessageID = 'msg_a') => ev('session.tool.called', { sessionID, assistantMessageID, id, input, executed: false });
const toolSuccess = (sessionID, id, text, metadata, assistantMessageID = 'msg_a') => ev('session.tool.success', { sessionID, assistantMessageID, id, content: [{ type: 'text', text }], metadata });
const toolFailed = (sessionID, id, message, assistantMessageID = 'msg_a') => ev('session.tool.failed', { sessionID, assistantMessageID, id, error: { type: 'ToolError', message } });
const stepEnded = (sessionID, assistantMessageID = 'msg_a') => ev('session.step.ended', { sessionID, assistantMessageID, finish: 'stop' });
const succeeded = (sessionID) => ev('session.execution.succeeded', { sessionID });
const failed = (sessionID, error) => ev('session.execution.failed', { sessionID, error });
const interrupted = (sessionID) => ev('session.execution.interrupted', { sessionID });
const retryScheduled = (sessionID, attempt, message) => ev('session.retry.scheduled', { sessionID, attempt, error: { type: 'APIError', message } });
const askedEvent = (sessionID, id, action, extra = {}) => ev('permission.asked', {
  id,
  sessionID,
  action,
  resources: ['echo *'],
  save: ['echo *'],
  metadata: { command: 'echo hi' },
  source: { type: 'tool', messageID: 'msg_a', id: 'call_1' },
  ...extra,
});
const formCreated = (sessionID, id, fields) => ev('form.created', {
  form: { id, sessionID, title: 'Questions', metadata: { kind: 'question' }, fields },
});

async function startRun({ state, tempRoot }, options = {}, context = makeContext(options.providerSessionId ?? null)) {
  const writer = makeWriter();
  const run = opencodeRuntime.run(options.command ?? 'hello', {
    sessionId: 'app-session',
    cwd: tempRoot,
    ...options,
  }, writer, context);
  await waitFor(() => state.promptBodies.length >= (options.expectedPrompts ?? 1));
  const sessionID = state.promptBodies.at(-1).sessionID;
  return { writer, run, sessionID };
}

test('run creates a session, selects the model and agent, posts the prompt and completes on execution.succeeded', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx, { model: 'anthropic/claude-haiku-5-5' });

    assert.ok(state.authHeaders.every((header) => header === `Basic ${Buffer.from(`opencode:${TEST_PASSWORD}`).toString('base64')}`));
    assert.deepEqual(state.modelBodies, [{ sessionID, body: { model: { id: 'claude-haiku-5-5', providerID: 'anthropic' } } }]);
    assert.deepEqual(state.agentBodies, [{ sessionID, body: { agent: 'build' } }]);
    assert.deepEqual(state.promptBodies[0].body, { text: 'hello' });
    assert.equal(state.promptBodies[0].directory, ctx.tempRoot);
    assert.ok(writer.messages.some((message) => message.kind === 'session_created' && message.newSessionId === sessionID));

    state.emit(executionStarted(sessionID));
    state.emit(stepStarted(sessionID));
    state.emit(textStarted(sessionID));
    state.emit(textDelta(sessionID, 'Hel'));
    state.emit(textDelta(sessionID, 'lo'));
    state.emit(textEnded(sessionID, 'Hello'));
    state.emit(stepEnded(sessionID));
    state.emit(succeeded(sessionID));
    await run;

    const kinds = writer.messages.map((message) => message.kind);
    assert.deepEqual(writer.messages.filter((m) => m.kind === 'stream_delta').map((m) => m.content), ['Hel', 'lo']);
    // Streamed text is not repeated as a snapshot when the part ends.
    assert.equal(writer.messages.filter((m) => m.kind === 'text').length, 0);
    assert.equal(kinds.at(-1), 'complete');
    assert.equal(writer.messages.at(-1).exitCode, 0);
  });
});

test('run resumes an existing provider session without session_created', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    state.sessionRecords.ses_existing = { id: 'ses_existing', location: { directory: ctx.tempRoot } };
    const { writer, run, sessionID } = await startRun(ctx, { providerSessionId: 'ses_existing' });

    assert.equal(sessionID, 'ses_existing');
    assert.equal(writer.messages.some((message) => message.kind === 'session_created'), false);
    state.emit(executionStarted(sessionID));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('run ignores a stored provider session bound to another directory', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    state.sessionRecords.ses_elsewhere = { id: 'ses_elsewhere', location: { directory: path.join(ctx.tempRoot, 'other') } };
    const { writer, run, sessionID } = await startRun(ctx, { providerSessionId: 'ses_elsewhere' });

    assert.notEqual(sessionID, 'ses_elsewhere');
    assert.ok(writer.messages.some((message) => message.kind === 'session_created'));
    state.emit(executionStarted(sessionID));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('text that was not streamed lands as one assistant text with the history id', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(textStarted(sessionID, 2, 'msg_7'));
    state.emit(textEnded(sessionID, 'Done.', 2, 'msg_7'));
    state.emit(succeeded(sessionID));
    await run;

    const text = writer.messages.find((message) => message.kind === 'text');
    assert.equal(text.content, 'Done.');
    assert.equal(text.role, 'assistant');
    assert.equal(text.id, 'msg_7_text_2');
  });
});

test('tool calls stream as tool_use + tool_result with the call id', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(toolInputStarted(sessionID, 'call_1', 'bash'));
    state.emit(toolCalled(sessionID, 'call_1', { command: 'ls' }));
    state.emit(toolSuccess(sessionID, 'call_1', 'a.ts\nb.ts'));
    state.emit(toolInputStarted(sessionID, 'call_2', 'read'));
    state.emit(toolCalled(sessionID, 'call_2', { filePath: '/x' }));
    state.emit(toolFailed(sessionID, 'call_2', 'ENOENT'));
    state.emit(succeeded(sessionID));
    await run;

    const uses = writer.messages.filter((message) => message.kind === 'tool_use');
    const results = writer.messages.filter((message) => message.kind === 'tool_result');
    assert.deepEqual(uses.map((m) => [m.toolName, m.toolId, m.id]), [['bash', 'call_1', 'msg_a_call_1'], ['read', 'call_2', 'msg_a_call_2']]);
    assert.equal(results[0].content.includes('a.ts'), true);
    assert.equal(results[0].isError, false);
    assert.equal(results[1].isError, true);
    assert.ok(results[1].content.includes('ENOENT'));
  });
});

test('bypassPermissions auto-approves permission.asked with a once decision', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx, { permissionMode: 'bypassPermissions' });
    state.emit(executionStarted(sessionID));
    state.emit(askedEvent(sessionID, 'per_1', 'bash'));
    await waitFor(() => state.permissionReplies.length === 1);
    assert.deepEqual(state.permissionReplies[0], { sessionID, permissionID: 'per_1', decision: 'once', message: undefined });
    assert.equal(writer.messages.some((message) => message.kind === 'permission_request'), false);
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('acceptEdits auto-approves edit asks but forwards bash to the UI', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx, { permissionMode: 'acceptEdits' });
    state.emit(executionStarted(sessionID));
    state.emit(askedEvent(sessionID, 'per_edit', 'edit', { resources: ['/repo/a.ts'], metadata: { filepath: '/repo/a.ts' } }));
    await waitFor(() => state.permissionReplies.length === 1);
    assert.equal(state.permissionReplies[0].decision, 'once');

    state.emit(askedEvent(sessionID, 'per_bash', 'bash'));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_request'));
    const request = writer.messages.find((message) => message.kind === 'permission_request');
    assert.equal(request.toolName, 'bash');
    assert.equal(request.input.command, 'echo hi');
    assert.equal(request.context.rememberEntry, 'bash: echo *');
    assert.equal(state.permissionReplies.length, 1);

    state.emit(succeeded(sessionID));
    await run;
  });
});

test('default mode forwards asks; resolve replies once / always / reject-with-feedback', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    for (const id of ['per_1', 'per_2', 'per_3']) {
      state.emit(askedEvent(sessionID, id, 'bash'));
    }
    await waitFor(() => writer.messages.filter((message) => message.kind === 'permission_request').length === 3);
    assert.deepEqual(opencodeRuntime.permissions.listPending('app-session').map((entry) => entry.requestId), ['per_1', 'per_2', 'per_3']);

    opencodeRuntime.permissions.resolve('per_1', { allow: true });
    opencodeRuntime.permissions.resolve('per_2', { allow: true, rememberEntry: 'bash: echo *' });
    opencodeRuntime.permissions.resolve('per_3', { allow: false, message: 'Use mkdir -p instead' });
    await waitFor(() => state.permissionReplies.length === 3);
    assert.deepEqual(state.permissionReplies.map((reply) => [reply.permissionID, reply.decision, reply.message]), [
      ['per_1', 'once', undefined],
      ['per_2', 'always', undefined],
      ['per_3', 'reject', 'Use mkdir -p instead'],
    ]);
    // Every other viewer drops the prompt once it is answered.
    assert.equal(writer.messages.filter((message) => message.kind === 'permission_cancelled').length, 3);

    state.emit(succeeded(sessionID));
    await run;
  });
});

test('permission.replied from another client clears the pending ask', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(askedEvent(sessionID, 'per_1', 'bash'));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_request'));
    state.emit(ev('permission.replied', { sessionID, requestID: 'per_1', reply: 'once' }));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_cancelled'));
    assert.equal(opencodeRuntime.permissions.listPending('app-session').length, 0);
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('form.created is forwarded as a question and answered through the form reply endpoint', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(formCreated(sessionID, 'frm_1', [
      {
        key: 'color',
        title: 'Color preference',
        description: 'Which color?',
        type: 'string',
        options: [{ value: 'red', label: 'Red' }, { value: 'blue', label: 'Blue' }],
        custom: true,
      },
      {
        key: 'tags',
        title: 'Tags',
        type: 'multiselect',
        options: [{ value: 'a', label: 'Alpha' }, { value: 'b', label: 'Beta, really' }],
      },
      { key: 'count', title: 'How many?', type: 'integer' },
      { key: 'confirm', title: 'Proceed?', type: 'boolean' },
      { key: 'secret', title: 'hidden', type: 'string', hidden: true },
    ]));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_request'));
    const request = writer.messages.find((message) => message.kind === 'permission_request');
    assert.equal(request.toolName, 'AskUserQuestion');
    assert.equal(request.requestId, 'frm_1');
    assert.deepEqual(request.input.questions.map((question) => question.question), ['Color preference', 'Tags', 'How many?', 'Proceed?']);
    assert.deepEqual(request.input.questions[0].options.map((option) => option.label), ['Red', 'Blue', 'Other']);
    assert.equal(request.input.questions[1].multiSelect, true);
    assert.deepEqual(request.input.questions[3].options.map((option) => option.label), ['Yes', 'No']);

    opencodeRuntime.permissions.resolve('frm_1', {
      allow: true,
      updatedInput: {
        answers: {
          'Color preference': 'Red',
          Tags: 'Beta, really',
          'How many?': '3',
          'Proceed?': 'Yes',
        },
      },
    });
    await waitFor(() => state.formReplies.length === 1);
    assert.deepEqual(state.formReplies[0], {
      sessionID,
      formID: 'frm_1',
      answer: { color: 'red', tags: ['b'], count: 3, confirm: true },
    });

    state.emit(succeeded(sessionID));
    await run;
  });
});

test('a rejected form is cancelled; a free-text answer and a split multi-select survive', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(formCreated(sessionID, 'frm_a', [{ key: 'q0', title: 'Why?', type: 'string', options: [{ value: 'x', label: 'X' }] }]));
    state.emit(formCreated(sessionID, 'frm_b', [
      { key: 'picks', title: 'Pick', type: 'multiselect', options: [{ value: '1', label: 'One' }, { value: '2', label: 'Two' }] },
    ]));
    await waitFor(() => writer.messages.filter((message) => message.kind === 'permission_request').length === 2);

    opencodeRuntime.permissions.resolve('frm_a', { allow: true, updatedInput: { answers: { 'Why?': 'because, obviously' } } });
    opencodeRuntime.permissions.resolve('frm_b', { allow: true, updatedInput: { answers: { Pick: 'One, Two' } } });
    await waitFor(() => state.formReplies.length === 2);
    assert.deepEqual(state.formReplies[0].answer, { q0: 'because, obviously' });
    assert.deepEqual(state.formReplies[1].answer, { picks: ['1', '2'] });

    state.emit(formCreated(sessionID, 'frm_c', [{ key: 'q', title: 'Sure?', type: 'string' }]));
    await waitFor(() => writer.messages.filter((message) => message.kind === 'permission_request').length === 3);
    opencodeRuntime.permissions.resolve('frm_c', { allow: false });
    await waitFor(() => state.formCancels.length === 1);
    assert.deepEqual(state.formCancels[0], { sessionID, formID: 'frm_c' });

    state.emit(succeeded(sessionID));
    await run;
  });
});

test('bypassPermissions still forwards forms — user input is not a permission', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx, { permissionMode: 'bypassPermissions' });
    state.emit(executionStarted(sessionID));
    state.emit(formCreated(sessionID, 'frm_1', [{ key: 'q', title: 'Which?', type: 'string', options: [{ value: 'a', label: 'A' }] }]));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_request'));
    assert.equal(state.formReplies.length, 0);
    state.emit(ev('form.cancelled', { sessionID, formID: 'frm_1' }));
    await waitFor(() => writer.messages.some((message) => message.kind === 'permission_cancelled'));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('images are posted as file attachments and outside paths are refused', async () => {
  await withFakeServe(async (ctx) => {
    const { state, tempRoot } = ctx;
    const inside = path.join(tempRoot, 'shot.png');
    await writeFile(inside, 'png');
    const { run, sessionID } = await startRun(ctx, {
      images: [{ path: 'shot.png', name: 'shot.png', mediaType: 'image/png' }, { path: '/etc/passwd', name: 'passwd' }],
    });
    const body = state.promptBodies[0].body;
    assert.equal(body.files.length, 1);
    assert.equal(body.files[0].uri, `file://${inside}`);
    assert.equal(body.files[0].name, 'shot.png');
    assert.ok(body.text.includes('<images_input>'));
    state.emit(executionStarted(sessionID));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('plan mode selects the plan agent; an effort variant rides on the model', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const context = {
      ...makeContext(),
      getProviderModels: async () => ({
        OPTIONS: [{ value: 'openai/gpt-5', effort: { default: 'medium', values: [{ value: 'low' }, { value: 'high' }] } }],
        DEFAULT: 'openai/gpt-5',
      }),
    };
    const { run, sessionID } = await startRun(ctx, { permissionMode: 'plan', model: 'openai/gpt-5', effort: 'high' }, context);
    assert.deepEqual(state.agentBodies.at(-1).body, { agent: 'plan' });
    assert.deepEqual(state.modelBodies.at(-1).body, { model: { id: 'gpt-5', providerID: 'openai', variant: 'high' } });
    state.emit(executionStarted(sessionID));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('session.execution.failed fails the run with the provider error text', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(failed(sessionID, { type: 'provider.auth', message: 'Missing API key' }));
    await assert.rejects(run, /Missing API key/);
    assert.equal(writer.messages.at(-1).kind, 'complete');
    assert.equal(writer.messages.at(-1).exitCode, 1);
    assert.ok(writer.messages.some((message) => message.kind === 'error' && message.content === 'Missing API key'));
  });
});

test('a stale execution.succeeded arriving before the prompt posts does not settle the run', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    // The previous turn's trailing completion lands right after the session
    // is created — before this run's prompt went out.
    state.onSessionCreated = (sessionID) => state.emit(succeeded(sessionID));
    const { writer, run, sessionID } = await startRun(ctx);
    await new Promise((resolve) => setTimeout(resolve, 50));
    assert.equal(writer.messages.some((message) => message.kind === 'complete'), false);

    state.emit(executionStarted(sessionID));
    state.emit(succeeded(sessionID));
    await run;
    assert.equal(writer.messages.at(-1).kind, 'complete');
  });
});

test('a succeeded with no live event still completes once the status poll confirms the session is idle', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    // No execution.started — the only word is the completion itself.
    state.emit(succeeded(sessionID));
    await run;
    assert.equal(writer.messages.at(-1).kind, 'complete');
  });
}, { timeout: 20000 });

test('live rows end at every part boundary so text around a tool never merges', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(ev('session.reasoning.started', { sessionID, assistantMessageID: 'm1', ordinal: 0 }));
    state.emit(ev('session.reasoning.delta', { sessionID, assistantMessageID: 'm1', ordinal: 0, delta: 'plan' }));
    state.emit(textStarted(sessionID, 0, 'm1'));
    state.emit(textDelta(sessionID, 'first', 0, 'm1'));
    state.emit(toolInputStarted(sessionID, 'call_1', 'bash', 'm1'));
    state.emit(toolCalled(sessionID, 'call_1', { command: 'ls' }, 'm1'));
    state.emit(textStarted(sessionID, 1, 'm1'));
    state.emit(textDelta(sessionID, 'done', 1, 'm1'));
    state.emit(succeeded(sessionID));
    await run;

    const trace = writer.messages
      .filter((message) => ['thought_delta', 'stream_delta', 'stream_end', 'tool_use'].includes(message.kind))
      .map((message) => message.kind === 'stream_end' ? '|' : message.kind === 'tool_use' ? `[${message.toolName}]` : message.content);
    assert.deepEqual(trace, ['plan', '|', 'first', '|', '[bash]', 'done']);
  });
});

test('abort posts to the interrupt endpoint and resolves the run; a refused interrupt keeps it live', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));

    state.interruptedResponse = false;
    assert.equal(await opencodeRuntime.abort('app-session'), false);
    assert.equal(opencodeRuntime.isSessionActive?.('app-session') ?? true, true);

    state.interruptedResponse = true;
    assert.equal(await opencodeRuntime.abort('app-session'), true);
    assert.deepEqual(state.interrupts, [sessionID, sessionID]);
    await run;
    assert.equal(writer.messages.some((message) => message.kind === 'complete'), false);
  });
});

test('steer posts the message to the running turn with steer delivery', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    assert.equal(await opencodeRuntime.steer('app-session', 'also this', {}), false);
    state.active = { [sessionID]: { type: 'running' } };
    state.emit(executionStarted(sessionID));
    state.emit(textStarted(sessionID));
    state.emit(textDelta(sessionID, 'working'));
    await waitFor(() => writer.messages.some((message) => message.kind === 'stream_delta'));
    assert.equal(await opencodeRuntime.steer('app-session', 'also this', {}), true);
    assert.deepEqual(state.promptBodies.at(-1).body, { text: 'also this', delivery: 'steer' });
    assert.ok(writer.messages.some((message) => message.kind === 'text' && message.role === 'user' && message.content === 'also this'));
    state.emit(succeeded(sessionID));
    await run;
  });
});

test('a turn that finished while the event stream was down completes via the status resync', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    await waitFor(() => state.sseClients.size === 1);
    // The turn ends during the outage: no completion event is ever seen,
    // and `/session/active` no longer lists the session.
    state.active = {};
    for (const res of state.sseClients) {
      res.end();
    }
    await run;
    assert.equal(writer.messages.at(-1).kind, 'complete');
    assert.ok(state.sseConnects >= 2);
  });
}, { timeout: 20000 });

test('a running status observed in reconcile adopts the turn so a later succeeded settles it', async () => {
  await withFakeServe(async (ctx) => {
    const { state, baseUrl } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.active = { [sessionID]: { type: 'running' } };
    await reconcileActiveRuns(baseUrl);
    state.emit(succeeded(sessionID));
    await run;
    assert.equal(writer.messages.at(-1).kind, 'complete');
  });
});

test('a session.retry.scheduled surfaces a retry status; a stalled retry aborts the wedged turn', async () => {
  process.env.OPENCODE_RETRY_STALL_MS = '200';
  try {
    await withFakeServe(async (ctx) => {
      const { state } = ctx;
      const { writer, run, sessionID } = await startRun(ctx);
      // A retrying turn is still listed as running by the status poll.
      state.active = { [sessionID]: { type: 'running' } };
      state.emit(executionStarted(sessionID));
      state.emit(retryScheduled(sessionID, 1, 'rate limited'));
      await waitFor(() => writer.messages.some((message) => message.kind === 'status' && /retry 1/.test(message.text)));
      assert.ok(writer.messages.some((message) => message.kind === 'status' && message.notice && /rate limited/.test(message.text)));

      await new Promise((resolve) => setTimeout(resolve, 250));
      state.emit(retryScheduled(sessionID, 1, 'rate limited'));
      await assert.rejects(run, /retry stalled/);
      assert.deepEqual(state.interrupts, [sessionID]);
    });
  } finally {
    delete process.env.OPENCODE_RETRY_STALL_MS;
  }
});

test('a stalled (half-open) event stream is aborted and reconnected', async () => {
  process.env.OPENCODE_SSE_STALL_MS = '150';
  try {
    await withFakeServe(async (ctx) => {
      const { state } = ctx;
      const { run, sessionID } = await startRun(ctx);
      state.emit(executionStarted(sessionID));
      await waitFor(() => state.sseConnects >= 2, 5000);
      state.emit(succeeded(sessionID));
      await run;
    });
  } finally {
    delete process.env.OPENCODE_SSE_STALL_MS;
  }
});

test('a run survives its serve process being replaced mid-turn', async () => {
  await withFakeServe(async (ctx) => {
    const { state, tempRoot } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));

    // Replacement server on another port — the stream must follow it.
    const replacement = createFakeServe();
    await new Promise((resolve) => replacement.server.listen(0, '127.0.0.1', resolve));
    const replacementUrl = `http://127.0.0.1:${replacement.server.address().port}`;
    replacement.state.active = { [sessionID]: { type: 'running' } };
    try {
      delete process.env.OPENCODE_SERVE_BASE_URL;
      setServerForTest(tempRoot, { baseUrl: replacementUrl, directory: tempRoot, child: null, password: TEST_PASSWORD });
      for (const res of state.sseClients) {
        res.end();
      }
      await waitFor(() => replacement.state.sseClients.size === 1, 5000);
      replacement.state.emit(succeeded(sessionID));
      await run;
      assert.equal(writer.messages.at(-1).kind, 'complete');
    } finally {
      for (const res of replacement.state.sseClients) {
        res.end();
      }
      replacement.server.closeAllConnections?.();
      await new Promise((resolve) => replacement.server.close(resolve));
    }
  });
}, { timeout: 20000 });

test('a turn interrupted from elsewhere completes the run instead of failing it', async () => {
  await withFakeServe(async (ctx) => {
    const { state } = ctx;
    const { writer, run, sessionID } = await startRun(ctx);
    state.emit(executionStarted(sessionID));
    state.emit(interrupted(sessionID));
    await run;
    assert.equal(writer.messages.at(-1).kind, 'complete');
    assert.equal(writer.messages.at(-1).exitCode, 0);
  });
});

test('resolveOpenCodePermissionBehavior maps UI modes to approval behavior', () => {
  assert.deepEqual(resolveOpenCodePermissionBehavior('plan'), { agent: 'plan', autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('bypassPermissions'), { autoApprove: 'all' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('acceptEdits'), { autoApprove: 'edits' });
  assert.deepEqual(resolveOpenCodePermissionBehavior('default'), { autoApprove: 'none' });
  assert.deepEqual(resolveOpenCodePermissionBehavior(undefined), { autoApprove: 'none' });
});

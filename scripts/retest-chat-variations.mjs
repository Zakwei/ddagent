import WebSocket from 'ws';
import { appendFileSync, writeFileSync } from 'node:fs';

/**
 * Comprehensive Chat Variations & Consistency Retest Suite
 * Tests all chat variations across free-tier models for both OpenCode and Devin:
 * 1. Protocol Validation & Edge Cases (empty message, missing id, unknown session, archived session, restore, idle abort)
 * 2. Model Variations on Free Tier:
 *    - OpenCode: opencode/big-pickle, opencode/mimo-v2.6-flash-free
 *    - Devin: swe-2-high, swe-2-medium
 * 3. Query Variations:
 *    - Variation A: Simple deterministic Ping/Pong
 *    - Variation B: Multi-turn Context & Memory Retention (Turn 1 set secret -> Turn 2 recall secret)
 *    - Variation C: Structured Code Generation (TypeScript function)
 *    - Variation D: In-Flight User Abort (verifying exitCode: 0, aborted: true)
 *    - Variation E: Event Replay & WebSocket Reconnection (subscribing with lastSeq)
 *    - Variation F: Normalized REST Message History & Schema Consistency
 */

const BASE = process.env.BASE || 'http://127.0.0.1:10087';
const WS_URL = BASE.replace(/^http/, 'ws') + '/ws';
const REPORT_PATH = '/tmp/chat-variations-retest-report.txt';

// Auth: the optional API-wide key (x-api-key) plus, in OSS mode, a JWT either
// handed in directly (DDAGENT_TOKEN) or minted from credentials at startup.
// Platform mode needs neither.
const API_KEY = process.env.API_KEY || '';
const AUTH_USERNAME = process.env.DDAGENT_USERNAME || '';
const AUTH_PASSWORD = process.env.DDAGENT_PASSWORD || '';
let authToken = process.env.DDAGENT_TOKEN || '';

writeFileSync(REPORT_PATH, `=== Chat Variations & Consistency Retest ===\nDate: ${new Date().toISOString()}\nTarget: ${BASE}\n\n`);

const log = (...args) => {
  const line = args.join(' ');
  console.log(line);
  appendFileSync(REPORT_PATH, line + '\n');
};

const results = [];
const record = (category, testName, passed, detail = '') => {
  results.push({ category, testName, passed, detail });
  const status = passed ? '✅ PASS' : '❌ FAIL';
  log(`[${status}] [${category}] ${testName} ${detail ? `(${detail})` : ''}`);
};

const sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

const authHeaders = () => ({
  'content-type': 'application/json',
  ...(API_KEY ? { 'x-api-key': API_KEY } : {}),
  ...(authToken ? { authorization: `Bearer ${authToken}` } : {}),
});

const api = async (method, path, body) => {
  const res = await fetch(`${BASE}${path}`, {
    method,
    headers: authHeaders(),
    body: body ? JSON.stringify(body) : undefined,
  });
  const json = await res.json().catch(() => null);
  return { status: res.status, json };
};

/** WS target with the JWT as a query param — the upgrade reads `?token` first. */
const wsTarget = () => (authToken ? `${WS_URL}?token=${encodeURIComponent(authToken)}` : WS_URL);

/** Mints a JWT for OSS mode when credentials are provided. */
const authenticate = async () => {
  if (authToken || !AUTH_USERNAME || !AUTH_PASSWORD) return;
  const res = await api('POST', '/api/auth/login', { username: AUTH_USERNAME, password: AUTH_PASSWORD });
  if (res.status !== 200 || !res.json?.token) {
    throw new Error(
      `Login failed (HTTP ${res.status}): ${JSON.stringify(res.json)} — set DDAGENT_TOKEN or DDAGENT_USERNAME/DDAGENT_PASSWORD.`,
    );
  }
  authToken = res.json.token;
  log('Authenticated via POST /api/auth/login');
};

const createTestSession = async (provider, projectPath = '/workspace') => {
  const res = await api('POST', '/api/providers/sessions', {
    provider,
    projectPath,
  });
  if (res.status !== 201 || !res.json?.data?.sessionId) {
    throw new Error(`Failed to create session for ${provider}: ${JSON.stringify(res.json)}`);
  }
  return res.json.data.sessionId;
};

const deleteTestSession = async (sessionId) => {
  await api('DELETE', `/api/providers/sessions/${sessionId}?force=true`);
};

// ---------------------------------------------------------
// SECTION 1: PROTOCOL & EDGE CASES
// ---------------------------------------------------------

/**
 * Sends one frame and waits for the matching protocol_error. A hard timeout
 * keeps a silent server (or an unmatched response) from hanging the suite.
 */
function expectProtocolError({ label, expectedCode, send, timeoutMs = 10000 }) {
  return new Promise((resolve) => {
    const ws = new WebSocket(wsTarget());
    let settled = false;

    const finalize = (passed, detail) => {
      if (settled) return;
      settled = true;
      clearTimeout(timer);
      record('Protocol', label, passed, detail);
      try { ws.close(); } catch {}
      resolve();
    };

    const timer = setTimeout(() => finalize(false, 'TIMEOUT waiting for protocol_error'), timeoutMs);

    ws.on('open', () => send(ws));
    ws.on('message', (data) => {
      let msg;
      try { msg = JSON.parse(data.toString()); } catch { return; }
      if (msg.kind === 'protocol_error') {
        finalize(msg.code === expectedCode, `code=${msg.code}`);
      }
    });
    ws.on('error', (err) => finalize(false, err.message));
  });
}

async function runProtocolEdgeCaseTests() {
  log('\n--- SECTION 1: PROTOCOL & EDGE CASES ---');
  const dummySessionId = '00000000-0000-4000-8000-000000000000';

  // Test 1.1: Missing sessionId
  await expectProtocolError({
    label: 'Missing sessionId rejected',
    expectedCode: 'SESSION_ID_REQUIRED',
    send: (ws) => ws.send(JSON.stringify({ type: 'chat.send', content: 'Hello' })),
  });

  // Test 1.2: Empty content rejected on real session
  const emptySessionId = await createTestSession('opencode');
  await expectProtocolError({
    label: 'Empty chat message rejected',
    expectedCode: 'EMPTY_MESSAGE',
    send: (ws) => ws.send(JSON.stringify({ type: 'chat.send', sessionId: emptySessionId, content: '   ' })),
  });
  await deleteTestSession(emptySessionId);

  // Test 1.3: Non-existent sessionId rejected
  await expectProtocolError({
    label: 'Non-existent session rejected',
    expectedCode: 'SESSION_NOT_FOUND',
    send: (ws) => ws.send(JSON.stringify({ type: 'chat.send', sessionId: dummySessionId, content: 'Hello' })),
  });

  // Test 1.4: Abort on idle session returns NO_ACTIVE_RUN
  await expectProtocolError({
    label: 'Idle abort returns NO_ACTIVE_RUN',
    expectedCode: 'NO_ACTIVE_RUN',
    send: (ws) => ws.send(JSON.stringify({ type: 'chat.abort', sessionId: dummySessionId })),
  });

  // Test 1.5: Archived session send rejected & restore works
  const archiveSessionId = await createTestSession('opencode');
  await api('DELETE', `/api/providers/sessions/${archiveSessionId}`); // archive (force=false)

  await expectProtocolError({
    label: 'Send to archived session rejected',
    expectedCode: 'SESSION_ARCHIVED',
    send: (ws) => ws.send(JSON.stringify({ type: 'chat.send', sessionId: archiveSessionId, content: 'Hello' })),
  });

  // Restore the session
  const restoreRes = await api('POST', `/api/providers/sessions/${archiveSessionId}/restore`);
  const restoredOk = restoreRes.status === 200 && restoreRes.json?.success === true;
  record('Protocol', 'Restore archived session succeeded', restoredOk);

  await deleteTestSession(archiveSessionId);
}

// ---------------------------------------------------------
// Helper: Send message with full event stream capture
// ---------------------------------------------------------
function executeChatSend({ sessionId, model, content, timeoutMs = 120000, onDelta, onThought, onAbortAfterDeltaCount }) {
  return new Promise((resolve) => {
    const ws = new WebSocket(wsTarget());
    let resolved = false;
    let fullText = '';
    let thoughtText = '';
    const events = [];
    let deltaCount = 0;
    let abortedTriggered = false;

    const finalize = (data) => {
      if (resolved) return;
      resolved = true;
      clearTimeout(timer);
      try { ws.close(); } catch {}
      resolve(data);
    };

    const timer = setTimeout(() => {
      finalize({ ok: false, error: 'TIMEOUT', fullText, events });
    }, timeoutMs);

    ws.on('open', () => {
      ws.send(JSON.stringify({
        type: 'chat.subscribe',
        sessions: [{ sessionId, lastSeq: 0 }],
      }));
      ws.send(JSON.stringify({
        type: 'chat.send',
        sessionId,
        content,
        options: model ? { model } : undefined,
      }));
    });

    ws.on('message', (raw) => {
      let msg;
      try {
        msg = JSON.parse(raw.toString());
      } catch {
        return;
      }
      events.push(msg);

      // Auto-approve permissions if any provider requests
      if (msg.kind === 'permission_request' && msg.requestId) {
        ws.send(JSON.stringify({
          type: 'chat.permission-response',
          sessionId,
          requestId: msg.requestId,
          allow: true,
        }));
      }

      if (msg.kind === 'stream_delta') {
        const chunk = msg.delta || msg.content || '';
        fullText += chunk;
        deltaCount++;
        if (onDelta) onDelta(chunk);

        if (onAbortAfterDeltaCount && deltaCount >= onAbortAfterDeltaCount && !abortedTriggered) {
          abortedTriggered = true;
          // Send chat.abort
          ws.send(JSON.stringify({ type: 'chat.abort', sessionId }));
        }
      }

      if (msg.kind === 'thought_delta') {
        const chunk = msg.delta || msg.content || '';
        thoughtText += chunk;
        if (onThought) onThought(chunk);
      }

      if (msg.kind === 'complete') {
        finalize({
          ok: true,
          exitCode: msg.exitCode,
          aborted: msg.aborted,
          fullText,
          thoughtText,
          events,
        });
      }

      if (msg.kind === 'error') {
        finalize({
          ok: false,
          error: msg.error,
          fullText,
          thoughtText,
          events,
        });
      }

      if (msg.kind === 'protocol_error') {
        finalize({
          ok: false,
          error: msg.error,
          code: msg.code,
          fullText,
          thoughtText,
          events,
        });
      }
    });

    ws.on('error', (err) => {
      finalize({ ok: false, error: err.message, fullText, events });
    });
  });
}

// ---------------------------------------------------------
// SECTION 2 & 3: VARIATIONS FOR A PROVIDER
// ---------------------------------------------------------
async function testProviderVariations({ provider, primaryModel, secondaryModel }) {
  log(`\n=========================================================`);
  log(`--- TESTING PROVIDER: ${provider.toUpperCase()} ---`);
  log(`Primary Model: ${primaryModel}`);
  if (secondaryModel) log(`Secondary Model: ${secondaryModel}`);
  log(`=========================================================`);

  const sessionId = await createTestSession(provider);
  log(`Created session ${sessionId} for ${provider}`);

  // Pin active model
  await api('POST', `/api/providers/${provider}/sessions/${sessionId}/active-model`, {
    model: primaryModel,
  });

  try {
    // -------------------------------------------------------
    // Variation A: Simple Ping / Pong Marker Response
    // -------------------------------------------------------
    const pingSecret = `PING-${Date.now().toString().slice(-4)}`;
    log(`\n[${provider}] Variation A: Simple Ping/Pong (${pingSecret})...`);
    const resA = await executeChatSend({
      sessionId,
      model: primaryModel,
      content: `Odpowiedz dokładnie dwoma słowami: ${pingSecret} OK`,
    });

    const hasDeltasA = resA.events.some((e) => e.kind === 'stream_delta');
    const seqsA = resA.events.filter((e) => typeof e.seq === 'number').map((e) => e.seq);
    const monotonicA = seqsA.length > 0 && seqsA.every((s, i) => i === 0 || s > seqsA[i - 1]);
    const pingPassed = resA.ok && resA.fullText.includes(pingSecret);

    record(provider, 'Variation A: Ping/Pong streaming deltas received', hasDeltasA, `count=${seqsA.length}`);
    record(provider, 'Variation A: Monotonic sequence numbers', monotonicA);
    record(provider, 'Variation A: Content match', pingPassed, `response: "${resA.fullText.trim().slice(0, 60)}"`);
    record(provider, 'Variation A: Clean completion (exitCode 0)', resA.exitCode === 0 && !resA.aborted);

    // -------------------------------------------------------
    // Variation B: Multi-turn Context & Memory Retention
    // -------------------------------------------------------
    log(`\n[${provider}] Variation B: Multi-turn Context Retention...`);
    const secretWord = `AURORA-${Math.floor(1000 + Math.random() * 9000)}`;

    // Turn 1: Save secret
    log(`Turn 1: Instructing to remember keyword "${secretWord}"...`);
    const resB1 = await executeChatSend({
      sessionId,
      model: primaryModel,
      content: `Zapamiętaj słowo kluczowe "${secretWord}". W odpowiedzi napisz tylko jedno słowo: ZAPISANO.`,
    });
    record(provider, 'Variation B (Turn 1): Secret stored acknowledgment', resB1.ok && resB1.exitCode === 0);

    // Turn 2: Recall secret
    log(`Turn 2: Asking to recall keyword...`);
    const resB2 = await executeChatSend({
      sessionId,
      model: primaryModel,
      content: `Podaj słowo kluczowe, które kazałem ci przed chwilą zapamiętać. Podaj tylko samo słowo.`,
    });
    const recalledSecret = resB2.ok && resB2.fullText.includes(secretWord);
    record(provider, 'Variation B (Turn 2): Multi-turn context recall', recalledSecret, `expected=${secretWord}, got="${resB2.fullText.trim()}"`);

    // -------------------------------------------------------
    // Variation C: Structured Code Generation
    // -------------------------------------------------------
    log(`\n[${provider}] Variation C: Structured Code Generation...`);
    const resC = await executeChatSend({
      sessionId,
      model: primaryModel,
      content: `Napisz w TypeScript zwięzłą funkcję reverseString(s: string): string odwracającą tekst. Kod umieść w bloku markdown (\`\`\`ts).`,
    });

    const hasCodeBlock = resC.ok && (resC.fullText.includes('```ts') || resC.fullText.includes('```typescript') || resC.fullText.includes('```'));
    const hasFunctionDef = resC.fullText.includes('reverseString');
    record(provider, 'Variation C: Code block generation', hasCodeBlock && hasFunctionDef, `code present: ${hasCodeBlock}`);

    // Check Devin thought reasoning deltas across turns
    if (provider === 'devin') {
      const hasThoughts = (resA.thoughtText?.length > 0 || resA.events?.some((e) => e.kind === 'thought_delta'))
        || (resB1.thoughtText?.length > 0 || resB1.events?.some((e) => e.kind === 'thought_delta'))
        || (resB2.thoughtText?.length > 0 || resB2.events?.some((e) => e.kind === 'thought_delta'))
        || (resC.thoughtText?.length > 0 || resC.events?.some((e) => e.kind === 'thought_delta'));
      record(provider, 'Thought reasoning deltas emitted', hasThoughts);
    }

    // -------------------------------------------------------
    // Variation D: In-Flight User Abort Handling
    // -------------------------------------------------------
    log(`\n[${provider}] Variation D: In-Flight User Abort...`);
    // Prompt something verbose so we have time to abort mid-stream
    const resD = await executeChatSend({
      sessionId,
      model: primaryModel,
      content: `Wypisz szczegółowo liczby od 1 do 150 słownie po polsku (jeden, dwa, trzy...), każdą w nowej linii z dokładnym opisem.`,
      onAbortAfterDeltaCount: 3, // Abort immediately after 3 chunks stream
    });

    const abortClean = resD.ok && resD.aborted === true && resD.exitCode === 0;
    record(provider, 'Variation D: In-Flight Abort returns aborted: true & exitCode: 0', abortClean, `aborted=${resD.aborted}, exitCode=${resD.exitCode}`);

    // -------------------------------------------------------
    // Variation E: Replay & WebSocket Subscription
    // -------------------------------------------------------
    log(`\n[${provider}] Variation E: Event Replay & Reconnection...`);
    // Send a message and verify subscribe receives info
    const subRes = await new Promise((resolve) => {
      const ws = new WebSocket(wsTarget());
      let receivedSubscribed = false;
      ws.on('open', () => {
        ws.send(JSON.stringify({
          type: 'chat.subscribe',
          sessions: [{ sessionId, lastSeq: 0 }],
        }));
      });
      ws.on('message', (raw) => {
        const msg = JSON.parse(raw.toString());
        if (msg.kind === 'chat_subscribed') {
          receivedSubscribed = true;
          ws.close();
          resolve({ ok: true, data: msg });
        }
      });
      ws.on('error', () => resolve({ ok: false }));
      setTimeout(() => {
        try { ws.close(); } catch {}
        resolve({ ok: receivedSubscribed });
      }, 5000);
    });
    record(provider, 'Variation E: chat.subscribe receives chat_subscribed frame', subRes.ok);

    // -------------------------------------------------------
    // Variation F: REST History Consistency Check
    // -------------------------------------------------------
    log(`\n[${provider}] Variation F: REST History Consistency...`);
    const historyRes = await api('GET', `/api/providers/sessions/${sessionId}/messages`);
    const messages = historyRes.json?.data?.messages || historyRes.json?.messages || [];
    const hasUserAndAssistant = messages.some((m) => m.role === 'user') && messages.some((m) => m.role === 'assistant');
    const validStructure = messages.length > 0 && messages.every((m) => m.id && (m.role || m.kind) && m.timestamp);

    record(provider, 'Variation F: REST message history contains user & assistant turns', hasUserAndAssistant, `total=${messages.length}`);
    record(provider, 'Variation F: REST message schema integrity', validStructure);

    // -------------------------------------------------------
    // Secondary Free Model Test (if available)
    // -------------------------------------------------------
    if (secondaryModel) {
      log(`\n[${provider}] Testing Secondary Free Model: ${secondaryModel}...`);
      const secSessionId = await createTestSession(provider);
      const resSec = await executeChatSend({
        sessionId: secSessionId,
        model: secondaryModel,
        content: `Odpowiedz dokładnie jednym słowem: ZATWIERDZONO`,
      });
      const secPassed = resSec.ok && resSec.exitCode === 0 && resSec.fullText.length > 0;
      record(provider, `Secondary Model (${secondaryModel}) execution`, secPassed, `output="${resSec.fullText.trim().slice(0, 40)}"`);
      await deleteTestSession(secSessionId);
    }

  } finally {
    log(`Cleaning up session ${sessionId}...`);
    await deleteTestSession(sessionId);
  }
}

// ---------------------------------------------------------
// MAIN RUNNER
// ---------------------------------------------------------
async function runAll() {
  const section = process.argv.find((a) => a.startsWith('--section='))?.split('=')[1] || 'all';
  log(`Starting comprehensive chat variation testing suite (section: ${section})...`);
  const t0 = Date.now();
  let fatalError = null;

  try {
    await authenticate();

    if (section === 'all' || section === 'protocol') {
      await runProtocolEdgeCaseTests();
    }

    if (section === 'all' || section === 'opencode') {
      await testProviderVariations({
        provider: 'opencode',
        primaryModel: 'opencode/big-pickle',
        secondaryModel: 'opencode/mimo-v2.6-flash-free',
      });
    }

    if (section === 'all' || section === 'devin') {
      await testProviderVariations({
        provider: 'devin',
        primaryModel: 'swe-2-high',
        secondaryModel: 'swe-2-medium',
      });
    }

  } catch (err) {
    fatalError = err;
    log(`FATAL ERROR DURING TEST EXECUTION: ${err.stack || err.message}`);
  }

  const durationSec = Math.round((Date.now() - t0) / 1000);
  const total = results.length;
  const passed = results.filter((r) => r.passed).length;
  const failed = results.filter((r) => !r.passed).length;
  const score = total === 0
    ? 'n/a'
    : passed === total
      ? '100% PERFECT RUN'
      : `${Math.round((passed / total) * 100)}%`;

  log(`\n=========================================================`);
  log(`TEST SUMMARY (${durationSec}s total)`);
  log(`Total:  ${total}`);
  log(`Passed: ${passed}`);
  log(`Failed: ${failed}`);
  log(`Score:  ${score}`);
  log(`=========================================================`);

  // A crash (or a run that never executed a single test) must not report
  // success — the runner's exit code is what CI and scripts key on.
  if (failed > 0 || fatalError || total === 0) {
    log('\nFAILED TESTS:');
    results.filter((r) => !r.passed).forEach((r) => {
      log(` - [${r.category}] ${r.testName}: ${r.detail}`);
    });
    if (fatalError) {
      log(` - [FATAL] ${fatalError.message}`);
    } else if (total === 0) {
      log(' - [FATAL] No tests ran.');
    }
    process.exit(1);
  } else {
    log('\nALL CHAT VARIATIONS PASSED FLAWLESSLY!');
    process.exit(0);
  }
}

runAll();

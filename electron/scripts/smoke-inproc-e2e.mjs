// Headless end-to-end REST smoke for DDAGENT_DESKTOP_INPROC=1 (embedded
// backend). Boots the REAL electron/main.js — launcher window, preload
// bridge, IPC handlers, protocol.handle — under a headless ozone platform,
// drives "This computer" via window.ddagentDesktop.openLocal(), then asserts
// on the ddagent-app://local/index.html page:
//
//   1. the app HTML actually loaded (title + non-empty DOM),
//   2. fetch('/api/*') answers over the ddagent-app:// scheme — a public route
//      and at least one authenticateToken-protected route in platform mode,
//   3. WebSocket-over-IPC works end-to-end: the app's own bundled socket
//      (WebSocketProvider -> createAppWebSocket -> DesktopWebSocket ->
//      desktopApi.ws -> wsRouter -> handleChatConnection) connects on page
//      load, and a smoke socket pair driven through the REAL compiled
//      DesktopWebSocket class (transpiled from src/ and injected) completes
//      open -> chat.subscribe/chat_subscribed round-trip -> protocol_error
//      -> close(1000), plus a second concurrent connection and webContents
//      teardown with a socket still open,
//   4. navigator.serviceWorker exists on the ddagent-app:// origin and the
//      app's own /sw.js registration reaches 'active',
//   5. every same-origin script/link/img referenced by index.html is served
//      by protocol.handle (favicon, hashed /assets/ chunks with JS MIME),
//      and loadURL('ddagent-app://local/board') hits the SPA index.html
//      fallback instead of a 404,
//   6. no TCP listener is bound by any process in the app's process tree
//      (and no new listener appears on the box at all).
//
// Run from the repo root (dist/ + dist-server/ must be built):
//   node_modules/.bin/electron --no-sandbox --ozone-platform=headless \
//     --disable-gpu electron/scripts/smoke-inproc-e2e.mjs
//
// DDAGENT_DESKTOP_INPROC is forced to 1 and ELECTRON_DEV_URL cleared inside
// the script so the production path is exercised. Exit code: 0 = all checks
// passed, 1 = failure. The profile lives in a throwaway userData dir
// (override with DDAGENT_SMOKE_USERDATA) so a real install is never touched.

import { execFileSync } from 'node:child_process';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { app, BrowserWindow } from 'electron';

const smokeUserData =
  process.env.DDAGENT_SMOKE_USERDATA ||
  fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-smoke-'));

// Must land before importing main.js — its bootstrap reads userData lazily,
// and isInProcessLocalMode() is evaluated when the local target resolves.
app.setPath('userData', smokeUserData);
process.env.DDAGENT_DESKTOP_INPROC = '1';
// Headless ozone has no display connection — the tray's Gtk context menu
// aborts the process on first page load; main.js honors this flag.
process.env.DDAGENT_DESKTOP_NO_TRAY = '1';
delete process.env.ELECTRON_DEV_URL;

const startedAt = Date.now();
// Direct fd-2 writes: app.exit() can drop piped stdout buffered by Node, and
// the parent shell merges stderr anyway — never lose the verdict.
const emit = (line) => fs.writeSync(2, `${line}\n`);
const log = (line) => emit(`[smoke ${String((Date.now() - startedAt) / 1000).slice(0, 6)}s] ${line}`);

const checks = [];
function check(name, ok, detail = '') {
  checks.push({ name, ok });
  emit(`${ok ? 'PASS' : 'FAIL'} ${name}${detail ? ` — ${detail}` : ''}`);
}

function tcpListenLines() {
  try {
    return execFileSync('ss', ['-tlnH'], { encoding: 'utf8' })
      .split('\n')
      .map((line) => line.trim())
      .filter(Boolean)
      .sort();
  } catch (error) {
    log(`ss -tlnH unavailable: ${error.message}`);
    return null;
  }
}

function tcpListenLinesForPids(pids) {
  let out;
  try {
    out = execFileSync('ss', ['-tlnpH'], { encoding: 'utf8' });
  } catch (error) {
    log(`ss -tlnpH unavailable: ${error.message}`);
    return null;
  }
  return out
    .split('\n')
    .filter((line) => pids.some((pid) => line.includes(`pid=${pid},`)));
}

// Every PID in our own process tree (renderers, GPU, network service, ...)
// — the app must not hold a LISTEN socket in any of them.
function ownProcessTreePids() {
  const rows = execFileSync('ps', ['-eo', 'pid=,ppid='], { encoding: 'utf8' })
    .split('\n')
    .map((line) => line.trim().split(/\s+/).map(Number))
    .filter(([pid, ppid]) => Number.isInteger(pid) && Number.isInteger(ppid));

  const childrenByParent = new Map();
  for (const [pid, ppid] of rows) {
    if (!childrenByParent.has(ppid)) childrenByParent.set(ppid, []);
    childrenByParent.get(ppid).push(pid);
  }

  const pids = new Set([process.pid]);
  const queue = [process.pid];
  while (queue.length) {
    for (const child of childrenByParent.get(queue.pop()) || []) {
      if (!pids.has(child)) {
        pids.add(child);
        queue.push(child);
      }
    }
  }
  return [...pids];
}

async function waitFor(predicate, timeoutMs, label) {
  const deadline = Date.now() + timeoutMs;
  let lastError = null;
  while (Date.now() < deadline) {
    try {
      const value = await predicate();
      if (value) return value;
    } catch (error) {
      lastError = error;
    }
    await new Promise((resolve) => setTimeout(resolve, 250));
  }
  throw new Error(`Timed out waiting for ${label}${lastError ? ` (last error: ${lastError.message})` : ''}`);
}

function withTimeout(promise, timeoutMs, label) {
  let timer;
  const timeout = new Promise((_, reject) => {
    timer = setTimeout(() => reject(new Error(`${label} timed out after ${timeoutMs / 1000}s`)), timeoutMs);
  });
  return Promise.race([promise, timeout]).finally(() => clearTimeout(timer));
}

// The embedded backend runs in THIS process — its console.log is ours.
// Count chat-websocket connects so the smoke can prove the bundled app's own
// WebSocketProvider socket reached handleChatConnection (not just sockets the
// harness itself opened). wsRouter has no logging on the connect path, so the
// handler's own line is the observable signal.
let backendChatConnects = 0;
const originalConsoleLog = console.log;
console.log = (...args) => {
  if (args.some((arg) => typeof arg === 'string' && arg.includes('Chat WebSocket connected'))) {
    backendChatConnects += 1;
  }
  originalConsoleLog(...args);
};

// The web bundle's createAppWebSocket/DesktopWebSocket is not exposed on
// window — it is only reachable inside the vite chunk graph. To still drive
// the REAL class (not a reimplementation) in the page, transpile the actual
// src/utils/DesktopWebSocket.ts with esbuild and eval it into the app
// webContents. Same code the bundle ships, same bridge it binds.
async function loadDesktopWebSocketBundle() {
  const { transformSync } = await import('esbuild');
  const sourcePath = fileURLToPath(new URL('../../src/utils/DesktopWebSocket.ts', import.meta.url));
  const { code } = transformSync(fs.readFileSync(sourcePath, 'utf8'), {
    loader: 'ts',
    format: 'iife',
    globalName: '__smokeDesktopWS',
  });
  return code;
}

// Side effect: registerSchemesAsPrivileged + single-instance + bootstrap().
log('importing electron/main.js');
await import('../main.js');
log('main.js imported');

let listenersAtBoot = null;

async function drive() {
  log(`userData=${smokeUserData}`);
  listenersAtBoot = tcpListenLines();

  const launcherWindow = await waitFor(
    () => BrowserWindow.getAllWindows().find((win) => {
      try {
        return !win.isDestroyed() && win.webContents.getURL().includes('launcher/index.html');
      } catch {
        return false;
      }
    }),
    30_000,
    'launcher window',
  );
  log('launcher window found');

  await waitFor(
    () => launcherWindow.webContents.executeJavaScript(
      `typeof window.ddagentDesktop === 'object' && typeof window.ddagentDesktop.openLocal === 'function'`,
    ),
    15_000,
    'ddagentDesktop preload bridge',
  );
  log('preload bridge ready — invoking openLocal()');

  // The real launcher click path: preload bridge -> ipcMain 'open-local' ->
  // openLocalInDesktop -> resolveLocalServerUrl -> startEmbeddedBackend ->
  // BrowserView.loadURL(ddagent-app://local/index.html). Resolves with the
  // desktop state once the view finished loading.
  const state = await withTimeout(
    launcherWindow.webContents.executeJavaScript(`window.ddagentDesktop.openLocal()`),
    120_000,
    'ddagentDesktop.openLocal()',
  );
  const startupLogs = state?.localStartupLogs || [];
  check(
    'openLocal resolves to local target',
    state?.activeTarget?.kind === 'local' && String(state?.activeTarget?.url || '').startsWith('ddagent-app://'),
    JSON.stringify(state?.activeTarget),
  );
  check(
    'embedded backend reports ready',
    startupLogs.some((line) => /embedded backend ready/i.test(line)),
    startupLogs.slice(-4).join(' | ') || '(no startup logs)',
  );

  const view = await waitFor(
    () => launcherWindow.getBrowserViews().find((candidate) => {
      try {
        return candidate.webContents.getURL().startsWith('ddagent-app://');
      } catch {
        return false;
      }
    }),
    15_000,
    'ddagent-app:// BrowserView',
  );
  const wc = view.webContents;

  const page = await wc.executeJavaScript(
    `({ title: document.title, url: location.href, bodyLen: document.body ? document.body.innerHTML.length : 0 })`,
  );
  check(
    'app HTML loaded over ddagent-app://',
    page.url.startsWith('ddagent-app://') && page.bodyLen > 0,
    JSON.stringify(page),
  );

  const apiFetch = (path, init) => wc.executeJavaScript(
    `fetch(${JSON.stringify(path)}, ${JSON.stringify(init ?? {})})`
    + `.then(async (r) => ({ status: r.status, type: r.headers.get('content-type') || '', text: (await r.text()).slice(0, 400) }))`
    + `.catch((e) => ({ status: 0, error: String(e) }))`,
  );

  const authStatus = await apiFetch('/api/auth/status');
  check(
    'GET /api/auth/status -> 200 JSON (public route)',
    authStatus.status === 200 && authStatus.type.includes('json'),
    JSON.stringify(authStatus),
  );

  const authUser = await apiFetch('/api/auth/user');
  check(
    'GET /api/auth/user -> 200 platform user (no token)',
    authUser.status === 200 && /"desktop"/.test(authUser.text),
    JSON.stringify(authUser),
  );

  const running = await apiFetch('/api/providers/sessions/running');
  check(
    'GET /api/providers/sessions/running -> 200 JSON (protected route)',
    running.status === 200 && running.type.includes('json'),
    JSON.stringify(running),
  );

  // Not a failure — documented behavior: /api/health does not exist on the
  // backend (health lives at /health, which the ddagent-app:// handler does
  // not route), so it falls through to the SPA index.html.
  const apiHealth = await apiFetch('/api/health');
  log(`note: GET /api/health -> ${apiHealth.status} ${apiHealth.type} (SPA fallback, backend health is /health off-scheme)`);

  // --- Service worker on the ddagent-app:// origin ----------------------
  // registerSchemesAsPrivileged marks the scheme allowServiceWorkers so
  // navigator.serviceWorker exists at all; the app registers /sw.js on load
  // (inline index.html script + src/main.jsx — same URL, one registration).
  // Scope '/' is the default for a root-level script, so no
  // Service-Worker-Allowed header is needed; protocol.handle serves /sw.js
  // as text/javascript already.
  const swProbe = await wc.executeJavaScript(`(async () => {
    const out = { apiPresent: 'serviceWorker' in navigator };
    if (!out.apiPresent) return out;
    try {
      const regs = await navigator.serviceWorker.getRegistrations();
      out.registrations = regs.map((reg) => ({
        scope: reg.scope,
        script: (reg.active || reg.waiting || reg.installing || {}).scriptURL || null,
      }));
      const ready = await Promise.race([
        navigator.serviceWorker.ready,
        new Promise((_, reject) => setTimeout(() => reject(new Error('ready timed out')), 10_000)),
      ]);
      out.active = { scope: ready.scope, script: ready.active ? ready.active.scriptURL : null };
    } catch (error) {
      out.error = String((error && error.message) || error);
    }
    return out;
  })()`).catch((error) => ({ apiPresent: false, error: String(error?.message || error) }));

  check(
    'sw: navigator.serviceWorker exists on ddagent-app://',
    swProbe.apiPresent === true,
    swProbe.error || '',
  );
  const swScript = (swProbe.registrations || [])
    .map((reg) => reg.script)
    .find((script) => typeof script === 'string' && script.endsWith('/sw.js'));
  check(
    'sw: app registration for /sw.js exists',
    Boolean(swScript),
    JSON.stringify(swProbe.registrations || []),
  );
  check(
    'sw: registration activated (navigator.serviceWorker.ready)',
    Boolean(swProbe.active && String(swProbe.active.script || '').endsWith('/sw.js')),
    swProbe.active ? JSON.stringify(swProbe.active) : (swProbe.error || '(no registration)'),
  );

  // --- Static assets on ddagent-app:// ----------------------------------
  // Every same-origin URL index.html references must be served by
  // protocol.handle. Chromium does not emit PerformanceResourceTiming entries
  // for this custom scheme (resource timing is empty even though everything
  // loaded), so "actually loaded" is proven per kind: stylesheets must appear
  // in document.styleSheets and the module entry chunk must have executed
  // (React rendered into #root).
  const assetProbe = await wc.executeJavaScript(`(async () => {
    const kindOf = (node) => {
      if (node.tagName === 'SCRIPT') return 'script';
      if (node.tagName === 'IMG') return 'img';
      const rel = node.getAttribute('rel') || '';
      if (rel === 'stylesheet') return 'css';
      return 'other';
    };
    const nodes = [...document.querySelectorAll('script[src], link[href], img[src]')]
      .map((node) => ({ url: node.src || node.href, kind: kindOf(node) }))
      .filter(({ url }) => {
        try { return new URL(url).origin === location.origin; } catch { return false; }
      });
    const styleSheetHrefs = new Set([...document.styleSheets].map((sheet) => sheet.href));
    const results = [];
    const done = new Set();
    for (const { url, kind } of nodes) {
      if (done.has(url)) continue;
      done.add(url);
      let status = 0;
      let type = '';
      try {
        const response = await fetch(url);
        status = response.status;
        type = response.headers.get('content-type') || '';
        await response.arrayBuffer();
      } catch (error) {
        type = String((error && error.message) || error);
      }
      results.push({
        url,
        kind,
        status,
        type,
        applied: kind === 'css' ? styleSheetHrefs.has(url) : null,
      });
    }
    return {
      results,
      rendered: Boolean(document.getElementById('root') && document.getElementById('root').children.length),
    };
  })()`).catch((error) => ({ error: String(error?.message || error) }));

  const assetResults = assetProbe?.results || [];
  const failedAssets = assetResults.filter(
    (entry) => entry.status !== 200 || entry.applied === false,
  );
  check(
    'assets: all index.html resources served + applied over ddagent-app://',
    assetResults.length > 0 && failedAssets.length === 0 && assetProbe.rendered === true,
    failedAssets.length ? JSON.stringify(failedAssets) : `${assetResults.length} assets ok, rendered=${assetProbe?.rendered}`,
  );

  const favicon = assetResults.find((entry) => entry.url.endsWith('/favicon.svg'));
  check(
    'assets: /favicon.svg resolves with image MIME',
    Boolean(favicon && favicon.status === 200 && favicon.type.startsWith('image/')),
    JSON.stringify(favicon || null),
  );

  const hashedChunks = assetResults.filter((entry) => /\/assets\/[^/]+\.js$/.test(entry.url));
  const badChunks = hashedChunks.filter(
    (entry) => entry.status !== 200 || !entry.type.includes('javascript'),
  );
  check(
    'assets: hashed vite chunks under /assets/ served as JavaScript',
    hashedChunks.length > 0 && badChunks.length === 0,
    badChunks.length ? JSON.stringify(badChunks) : `${hashedChunks.length} chunks`,
  );

  // --- WebSocket-over-IPC -------------------------------------------------
  // The bundled app already opened its own chat socket on page load
  // (WebSocketProvider mounts at App root and calls createAppWebSocket
  // immediately in platform mode) — the backend logs every connect.
  const appSocketConnected = await waitFor(
    () => backendChatConnects >= 1,
    20_000,
    'backend chat connect from the app bundle',
  ).then(() => true).catch(() => false);
  check(
    'ws: bundled app socket connected on page load',
    appSocketConnected,
    `backend chat connects so far=${backendChatConnects}`,
  );

  // Drive the real compiled DesktopWebSocket class inside the page.
  let wsResult = null;
  try {
    const bundleCode = await loadDesktopWebSocketBundle();
    // Trailing literal: executeJavaScript serializes the last expression's
    // value — the module namespace would throw "could not be cloned".
    await wc.executeJavaScript(`${bundleCode}\n;window.__smokeDesktopWS = __smokeDesktopWS, 'injected';`);
    wsResult = await withTimeout(
      wc.executeJavaScript(`(async () => {
        const api = globalThis.__smokeDesktopWS;
        const out = { bridgePresent: Boolean(window.desktopApi && window.desktopApi.ws) };
        const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
        const until = async (fn, ms, label) => {
          const end = Date.now() + ms;
          for (;;) {
            const v = fn();
            if (v) return v;
            if (Date.now() >= end) throw new Error(label + ' timed out');
            await sleep(50);
          }
        };
        try {
          if (!api) throw new Error('DesktopWebSocket bundle not injected');
          if (!out.bridgePresent) throw new Error('window.desktopApi.ws missing');

          const s1 = api.createAppWebSocket('ws://local/ws');
          out.factoryPickedDesktop = s1 instanceof api.DesktopWebSocket;
          const msgs = [];
          const closes = [];
          s1.addEventListener('message', (e) => {
            try { msgs.push(JSON.parse(e.data)); } catch { msgs.push({ raw: String(e.data) }); }
          });
          s1.addEventListener('close', (e) => closes.push({ code: e.code, wasClean: e.wasClean }));
          await until(() => s1.readyState === 1, 10_000, 'socket1 open');
          out.s1open = true;

          // Frame the real handleChatConnection answers: chat.subscribe acks
          // with chat_subscribed even for a session id that does not exist.
          s1.send(JSON.stringify({ type: 'chat.subscribe', sessions: [{ sessionId: 'smoke-ws-e2e', lastSeq: 0 }] }));
          const ack = await until(() => msgs.find((m) => m && m.kind === 'chat_subscribed'), 10_000, 'chat_subscribed ack');
          out.subscribeAck = { kind: ack.kind, sessionId: ack.sessionId, isProcessing: ack.isProcessing };

          // Second round-trip: unknown types get a protocol_error back.
          s1.send(JSON.stringify({ type: 'smoke.unknown' }));
          const perr = await until(() => msgs.find((m) => m && m.kind === 'protocol_error'), 10_000, 'protocol_error');
          out.protocolError = { kind: perr.kind, code: perr.code };

          // Multi-conn: a second socket must handshake while s1 is still open.
          const s2 = api.createAppWebSocket('ws://local/ws');
          await until(() => s2.readyState === 1, 10_000, 'socket2 open');
          out.s2open = true;
          // Left open on purpose — the teardown check destroys the
          // webContents with this socket live.
          globalThis.__smokeWsSecond = s2;

          s1.close(1000, 'smoke-done');
          await until(() => s1.readyState === 3 && closes.length > 0, 10_000, 'socket1 close');
          out.s1close = closes[0];
          out.s1closeCount = closes.length;
        } catch (error) {
          out.error = String((error && error.message) || error);
        }
        return out;
      })()`),
      45_000,
      'ws scenario in page',
    );
  } catch (error) {
    wsResult = { error: String(error?.message || error) };
  }
  const wsErr = wsResult?.error ? ` (${wsResult.error})` : '';
  check(
    'ws: preload bridge present (desktopApi.ws)',
    wsResult?.bridgePresent === true,
    wsResult?.error || '',
  );
  check(
    'ws: createAppWebSocket picks DesktopWebSocket on ddagent-app://',
    wsResult?.factoryPickedDesktop === true,
    wsErr,
  );
  check(
    'ws: socket open to /ws (platform auth, no token)',
    wsResult?.s1open === true,
    wsErr,
  );
  check(
    'ws: chat.subscribe -> chat_subscribed round-trip',
    wsResult?.subscribeAck?.kind === 'chat_subscribed' && wsResult?.subscribeAck?.sessionId === 'smoke-ws-e2e',
    JSON.stringify(wsResult?.subscribeAck || null) + wsErr,
  );
  check(
    'ws: unknown frame -> protocol_error',
    wsResult?.protocolError?.kind === 'protocol_error' && wsResult?.protocolError?.code === 'UNKNOWN_MESSAGE_TYPE',
    JSON.stringify(wsResult?.protocolError || null) + wsErr,
  );
  check(
    'ws: second concurrent socket opens',
    wsResult?.s2open === true,
    wsErr,
  );
  check(
    'ws: close(1000) -> onclose wasClean',
    wsResult?.s1close?.code === 1000 && wsResult?.s1close?.wasClean === true && wsResult?.s1closeCount === 1,
    JSON.stringify(wsResult?.s1close || null) + wsErr,
  );
  log(`backend chat connects total=${backendChatConnects}`);

  const pids = ownProcessTreePids();
  log(`process tree under pid ${process.pid}: ${pids.join(', ')}`);
  const owned = tcpListenLinesForPids(pids);
  check(
    'no TCP listener owned by app processes',
    owned !== null && owned.length === 0,
    (owned || []).join(' | '),
  );

  const listenersNow = tcpListenLines();
  const added = listenersAtBoot && listenersNow
    ? listenersNow.filter((line) => !listenersAtBoot.includes(line))
    : null;
  check(
    'no new TCP listeners on the box since boot',
    added !== null && added.length === 0,
    (added || []).join(' | '),
  );

  // --- SPA deep-route fallback ------------------------------------------
  // /board is a real React Router route with no dist/ file — protocol.handle
  // must serve index.html (not a 404) and the app must mount on it. Done
  // last: the navigation reloads this webContents and replaces the page.
  let deepRoute = null;
  try {
    await withTimeout(wc.loadURL('ddagent-app://local/board'), 30_000, 'loadURL /board');
    deepRoute = await waitFor(
      () => wc.executeJavaScript(
        `({ title: document.title, path: location.pathname, rendered: Boolean(document.getElementById('root') && document.getElementById('root').children.length) })`,
      ).then((probe) => (probe.title === 'ddagent' && probe.rendered ? probe : null)),
      20_000,
      'deep-route SPA render',
    );
  } catch (error) {
    deepRoute = { error: String(error?.message || error) };
  }
  check(
    'routing: loadURL ddagent-app://local/board serves SPA index.html fallback',
    Boolean(deepRoute && deepRoute.rendered),
    JSON.stringify(deepRoute),
  );

  // Socket #2 (and the app's own socket) are still open on this webContents.
  // Destroying it must run the wsRouter 'destroyed' sweep — sockets get
  // terminate()d server-side — without hanging or crashing the main process.
  let teardownOk = false;
  let teardownDetail = '';
  try {
    wc.destroy();
    const deadline = Date.now() + 5_000;
    while (Date.now() < deadline && !wc.isDestroyed()) {
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    teardownOk = wc.isDestroyed();
  } catch (error) {
    teardownDetail = String(error?.message || error);
  }
  check(
    'ws: webContents teardown with open sockets did not hang',
    teardownOk,
    teardownDetail,
  );
}

const watchdog = setTimeout(() => {
  emit('[smoke] overall timeout — aborting');
  app.exit(1);
}, 180_000);

async function dumpState() {
  try {
    const win = BrowserWindow.getAllWindows()[0];
    if (win && !win.webContents.isDestroyed()) {
      const state = await win.webContents.executeJavaScript(
        `window.ddagentDesktop ? window.ddagentDesktop.getState() : null`,
      );
      emit(`[smoke] last desktop state: ${JSON.stringify(state)?.slice(0, 2000)}`);
    }
  } catch {
    // Best effort diagnostics only.
  }
}

function finish() {
  clearTimeout(watchdog);
  const failed = checks.filter((entry) => !entry.ok);
  emit(`[smoke] ${checks.length - failed.length}/${checks.length} checks passed`);
  emit(`SMOKE RESULT: ${failed.length === 0 ? 'PASS' : 'FAIL'}`);
  app.exit(failed.length === 0 ? 0 : 1);
}

// NOTE: never `await app.whenReady()` at a .mjs entry's top level — Electron
// only emits 'ready' after the entry module finishes evaluating, so a module
// suspended on the ready promise deadlocks before the event can fire.
log('harness up — waiting for app ready');
app.whenReady()
  .then(async () => {
    log('app ready');
    await drive();
  })
  .catch(async (error) => {
    emit(`[smoke] driver failed: ${error?.stack || error}`);
    await dumpState();
    check('driver completed', false, error?.message || String(error));
  })
  .finally(finish);

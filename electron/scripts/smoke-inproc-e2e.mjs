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
//      (and no new listener appears on the box at all),
//   7. first-run dirs: WORKSPACES_ROOT is pointed at a not-yet-existing dir
//      under the throwaway userData so the embedded bootstrap's mkdir is the
//      only thing that can create it — asserted after boot,
//   8. chat stream E2E (task 10.4): a scratch session created over REST
//      (POST /api/providers/sessions) takes a real chat.send down the full
//      pipeline — sessionsDb lookup -> chatRunRegistry -> provider runtime ->
//      ChatSessionWriter (seq/remap) -> IPC socket. The asserted invariant is
//      the terminal `complete` frame; the frames before it report which level
//      the host reached (provider streamed vs provider error — no CLI/API on
//      the host still terminates cleanly). A hung run is bounded by
//      chat.abort. Plus a provider-free broadcast proof: POST /api/queue
//      emits `queued-messages-updated` to every connected /ws client.
//   9. shell pty E2E (task 10.5): a DesktopWebSocket to ws://local/shell
//      drives handleShellConnection — init spawns a real node-pty process
//      (plain shell), `input` round-trips through it (shell-computed echo),
//      `resize` is tolerated, `exit` reports "Process exited", and a bad
//      projectPath gets a protocol `error` frame.
//
// Run from the repo root (dist/ + dist-server/ must be built):
//   node_modules/.bin/electron --no-sandbox --ozone-platform=headless \
//     --disable-gpu electron/scripts/smoke-inproc-e2e.mjs
//
// DDAGENT_DESKTOP_INPROC is forced to 1 and ELECTRON_DEV_URL cleared inside
// the script so the production path is exercised. Exit code: 0 = all checks
// passed, 1 = failure. The profile lives in a throwaway userData dir
// (override with DDAGENT_SMOKE_USERDATA) so a real install is never touched.
//
// Why a bespoke harness and not Playwright (desktop E2E decision, task 10.1):
// @playwright/test + _electron.launch was evaluated and rejected —
//   * it is not in devDeps and pulling it in adds a heavy dependency tree
//     (plus browser downloads) for zero new coverage;
//   * Playwright drives Electron over CDP — the same control surface this
//     harness already reaches via the preload bridge +
//     webContents.executeJavaScript, with no shim layer in between;
//   * headless still needs the same --ozone-platform=headless flags, and
//     Playwright's Electron support is finicky offscreen.
// This file already covers boot -> launcher -> openLocal -> REST / WS /
// service worker / assets / SPA fallback / teardown with zero extra deps.
// Revisit only if we ever need multi-window input-level UI automation.
//
// Wired up as `npm run test:desktop` (preflight: scripts/check-desktop-build.mjs).

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
// First-run contract: point the workspaces root at a dir that does not exist
// yet — the embedded bootstrap's mkdir is the only thing that may create it.
process.env.WORKSPACES_ROOT = path.join(smokeUserData, 'workspaces');
// Launch auto-continue (task 7.3) would re-enter a persisted lastTarget on
// boot when DDAGENT_SMOKE_USERDATA is reused — pin the launcher-first path so
// the harness alone drives openLocal().
process.env.DDAGENT_DESKTOP_NO_AUTOCONTINUE = '1';
// Headless ozone has no display connection — the tray's Gtk context menu
// aborts the process on first page load; main.js honors this flag.
process.env.DDAGENT_DESKTOP_NO_TRAY = '1';
delete process.env.ELECTRON_DEV_URL;

// Task 10.4: give the provider runtime a real CLI to spawn — the
// claude-agent-sdk's own vendored binary — independent of any host-level
// CLAUDE_CLI_PATH (a stale/global override would otherwise mask it). With no
// API credentials on the host the run still terminates cleanly via the
// provider's error + complete frames, which the check accepts.
const bundledClaudeCli = [
  `claude-agent-sdk-${process.platform}-${process.arch}`,
  ...(process.platform === 'linux' ? ['claude-agent-sdk-linux-x64-musl'] : []),
]
  .map((pkg) => fileURLToPath(new URL(
    `../../node_modules/@anthropic-ai/${pkg}/${process.platform === 'win32' ? 'claude.exe' : 'claude'}`,
    import.meta.url,
  )))
  .find((candidate) => fs.existsSync(candidate));
process.env.CLAUDE_CLI_PATH = bundledClaudeCli ?? process.env.CLAUDE_CLI_PATH ?? 'claude';

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

  // Launcher must actually render DOM — a ReferenceError in launcher.js once
  // produced a blank window while all process-level checks passed.
  const launcherDom = await launcherWindow.webContents.executeJavaScript(
    `document.getElementById('app') ? document.getElementById('app').innerHTML.length : 0`,
  );
  check('launcher DOM rendered', launcherDom > 200, `#app innerHTML=${launcherDom}`);

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
  check(
    'localStatus phase is ready after boot (idle -> booting -> ready)',
    state?.localStatus === 'ready',
    `localStatus=${state?.localStatus}`,
  );
  check(
    'first-run: WORKSPACES_ROOT dir created by embedded bootstrap',
    fs.existsSync(process.env.WORKSPACES_ROOT),
    process.env.WORKSPACES_ROOT,
  );

  // Auto-continue (task 7.3) persistence: opening the local target must have
  // recorded lastTarget into desktop-settings.json (fire-and-forget write —
  // poll briefly). NO_AUTOCONTINUE only skips the boot-time reconnect.
  const desktopSettingsPath = path.join(smokeUserData, 'desktop-settings.json');
  const persistedTarget = await waitFor(
    () => {
      try {
        const stored = JSON.parse(fs.readFileSync(desktopSettingsPath, 'utf8'));
        return stored?.lastTarget?.kind ? stored : null;
      } catch {
        return null;
      }
    },
    5_000,
    'lastTarget persisted to desktop-settings.json',
  );
  check(
    'autocontinue: lastTarget persisted as local in desktop-settings.json',
    persistedTarget?.lastTarget?.kind === 'local',
    JSON.stringify(persistedTarget?.lastTarget || null),
  );
  check(
    'autocontinue: autoContinue setting defaults to enabled',
    persistedTarget?.autoContinue === true,
    `autoContinue=${persistedTarget?.autoContinue}`,
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

  // Capture renderer console output — when the bundled page stalls before
  // opening /ws on CI, the console is the only window into why.
  const rendererConsole = [];
  wc.on('console-message', (...args) => {
    const ev = args[0];
    const line = ev && typeof ev === 'object' && 'message' in ev
      ? `[${ev.level}] ${ev.message}`
      : args.map(String).join(' ');
    if (rendererConsole.length < 80) rendererConsole.push(line.slice(0, 300));
  });

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
    // Slow CI runners mount the app bundle late — the socket has been
    // observed connecting ~21s in, just past a 20s window.
    60_000,
    'backend chat connect from the app bundle',
  ).then(() => true).catch(() => false);
  if (!appSocketConnected) {
    const stuckState = await wc.executeJavaScript(`({
      url: location.href,
      rootChildren: document.getElementById('root') ? document.getElementById('root').childElementCount : -1,
      bodySnippet: document.body ? document.body.innerHTML.slice(0, 600) : '',
      localStorageKeys: Object.keys(localStorage),
      onLine: navigator.onLine,
    })`).catch((e) => ({ evalError: String(e) }));
    log(`bundled page state at ws timeout: ${JSON.stringify(stuckState)}`);
    log(`renderer console (${rendererConsole.length}): ${rendererConsole.join(' | ') || '(none)'}`);
  }
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

  // --- Chat stream E2E (task 10.4) ---------------------------------------
  // A scratch app session (created over REST, same as the composer does)
  // takes a real `chat.send` through the whole server pipeline: sessionsDb
  // lookup -> chatRunRegistry.startRun -> provider runtime ->
  // ChatSessionWriter (sessionId remap + seq) -> wsRouter -> IPC socket.
  //
  // The provider CLI decides the level reached:
  //   * CLI + API reachable  -> live frames (stream_delta/text/...) then
  //     `complete` exitCode 0 ("provider-stream");
  //   * no CLI / no API auth -> runtime emits `error` then `complete`
  //     exitCode 1 ("provider-error") — the documented boundary on hosts
  //     without a provider;
  //   * a run that hangs is cut by `chat.abort`, which itself emits the
  //     terminal `complete` (aborted) — so the asserted invariant is simply
  //     "a terminal complete frame always arrives".
  const workspacesRoot = process.env.WORKSPACES_ROOT;
  let chatResult = null;
  try {
    chatResult = await withTimeout(
      wc.executeJavaScript(`(async () => {
        const api = globalThis.__smokeDesktopWS;
        const out = {};
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

          // Session gateway entry point — allocates the stable app session id
          // that chat.send resolves against sessionsDb.
          const createRes = await fetch('/api/providers/sessions', {
            method: 'POST',
            headers: { 'content-type': 'application/json' },
            body: JSON.stringify({
              provider: 'claude',
              projectPath: ${JSON.stringify(workspacesRoot)},
              initialMessage: 'smoke e2e',
            }),
          }).then(async (r) => ({ status: r.status, body: await r.json().catch(() => null) }))
            .catch((e) => ({ status: 0, error: String(e) }));
          out.createStatus = createRes.status;
          const sessionId = createRes.body && createRes.body.data && createRes.body.data.sessionId;
          out.sessionCreated = createRes.status === 201 && typeof sessionId === 'string' && sessionId.length > 0;
          if (!out.sessionCreated) return out;

          const s = api.createAppWebSocket('ws://local/ws');
          const msgs = [];
          s.addEventListener('message', (e) => {
            try { msgs.push(JSON.parse(e.data)); } catch { /* keep raw-free */ }
          });
          await until(() => s.readyState === 1, 10_000, 'chat socket open');
          out.open = true;

          s.send(JSON.stringify({ type: 'chat.subscribe', sessions: [{ sessionId, lastSeq: 0 }] }));
          const sub = await until(
            () => msgs.find((m) => m.kind === 'chat_subscribed' && m.sessionId === sessionId),
            10_000,
            'chat_subscribed for scratch session',
          );
          out.subscribed = { isProcessing: sub.isProcessing, lastSeq: sub.lastSeq };

          // Dispatch-entry check: an unknown session must be rejected by the
          // dispatcher before any provider is touched.
          s.send(JSON.stringify({ type: 'chat.send', sessionId: 'smoke-missing-session', content: 'x' }));
          const nf = await until(
            () => msgs.find((m) => m.kind === 'protocol_error' && m.sessionId === 'smoke-missing-session'),
            10_000,
            'SESSION_NOT_FOUND protocol_error',
          );
          out.notFound = { code: nf.code };

          // The real send. Frames for this run all carry sessionId === the app
          // session id (the writer remaps provider-native ids away).
          const runStart = msgs.length;
          s.send(JSON.stringify({
            type: 'chat.send',
            sessionId,
            content: 'Reply with exactly the word: ok',
            options: { sessionSummary: 'smoke e2e' },
          }));

          const deadline = Date.now() + 50_000;
          let abortSent = false;
          let complete = null;
          while (Date.now() < deadline) {
            complete = msgs.slice(runStart).find((m) => m.kind === 'complete' && m.sessionId === sessionId);
            if (complete) break;
            if (!abortSent && Date.now() > deadline - 20_000) {
              // ~30s without a terminal frame — abort so a stuck provider
              // cannot hang the suite; the abort path emits complete(aborted).
              abortSent = true;
              s.send(JSON.stringify({ type: 'chat.abort', sessionId }));
            }
            await sleep(100);
          }
          out.abortSent = abortSent;

          const runFrames = msgs.slice(runStart).filter((m) => m && m.sessionId === sessionId);
          const kinds = [...new Set(runFrames.map((m) => m.kind || m.type || '?'))];
          out.runFrameKinds = kinds;
          out.complete = complete
            ? {
              exitCode: complete.exitCode,
              aborted: complete.aborted === true,
              success: complete.success === true,
              actualSessionId: complete.actualSessionId,
              seq: complete.seq,
            }
            : null;
          const seqs = runFrames.map((m) => m.seq).filter((n) => typeof n === 'number');
          out.seqMonotonic = seqs.length > 0 && seqs.every((v, i) => i === 0 || v > seqs[i - 1]);
          out.streamed = kinds.some((k) => (
            k === 'stream_delta' || k === 'thought_delta' || k === 'text'
            || k === 'thinking' || k === 'stream_end' || k === 'tool_use'
          ));
          out.providerError = (runFrames.find((m) => m.kind === 'error') || {}).content || null;
          // A real run that announced its provider-native id also produced the
          // connectedClients-wide session_upserted broadcast.
          out.sessionUpserted = msgs.some((m) => m.kind === 'session_upserted' && m.sessionId === sessionId);

          // Provider-free broadcast proof: POST /api/queue enqueues a row and
          // the service broadcasts "queued-messages-updated" to EVERY socket
          // in connectedClients — including this IPC-backed one. The session
          // id is intentionally bogus so the queued row can never dispatch to
          // a provider (it is marked failed server-side).
          const probeSession = 'smoke-queue-probe';
          const enq = await fetch('/api/queue/', {
            method: 'POST',
            headers: { 'content-type': 'application/json' },
            body: JSON.stringify({ sessionId: probeSession, content: 'smoke queue probe' }),
          }).then((r) => ({ status: r.status })).catch((e) => ({ status: 0, error: String(e) }));
          out.queuePost = enq.status;
          const bcast = await until(
            () => msgs.find((m) => m.type === 'queued-messages-updated' && m.sessionId === probeSession),
            10_000,
            'queued-messages-updated broadcast',
          );
          out.queueBroadcast = {
            type: bcast.type,
            sessionId: bcast.sessionId,
            count: Array.isArray(bcast.messages) ? bcast.messages.length : null,
          };

          s.close();
        } catch (error) {
          out.error = String((error && error.message) || error);
        }
        return out;
      })()`),
      90_000,
      'chat stream scenario in page',
    );
  } catch (error) {
    chatResult = { error: String(error?.message || error) };
  }
  const chatErr = chatResult?.error ? ` (${chatResult.error})` : '';
  const chatLevel = chatResult?.streamed
    ? 'provider-stream'
    : chatResult?.providerError
      ? 'provider-error'
      : 'complete-only';
  check(
    'chat: scratch session created via POST /api/providers/sessions',
    chatResult?.sessionCreated === true,
    `status=${chatResult?.createStatus}${chatErr}`,
  );
  check(
    'chat: socket open + chat.subscribe ack for real session',
    chatResult?.open === true && Boolean(chatResult?.subscribed),
    JSON.stringify(chatResult?.subscribed || null) + chatErr,
  );
  check(
    'chat: chat.send to unknown session -> SESSION_NOT_FOUND',
    chatResult?.notFound?.code === 'SESSION_NOT_FOUND',
    JSON.stringify(chatResult?.notFound || null) + chatErr,
  );
  check(
    'chat: chat.send -> terminal complete frame over IPC socket',
    Boolean(chatResult?.complete && typeof chatResult.complete.seq === 'number'),
    `level=${chatLevel} complete=${JSON.stringify(chatResult?.complete || null)} kinds=${(chatResult?.runFrameKinds || []).join(',')}${chatResult?.abortSent ? ' abortSent' : ''}${chatErr}`,
  );
  check(
    'chat: run frames carry monotonic per-run seq',
    chatResult?.seqMonotonic === true,
    `kinds=${(chatResult?.runFrameKinds || []).join(',')}${chatErr}`,
  );
  check(
    'chat: REST queue mutation broadcasts to /ws socket (queued-messages-updated)',
    chatResult?.queueBroadcast?.type === 'queued-messages-updated' && chatResult?.queueBroadcast?.sessionId === 'smoke-queue-probe',
    `post=${chatResult?.queuePost} ${JSON.stringify(chatResult?.queueBroadcast || null)}${chatErr}`,
  );
  if (chatResult?.sessionUpserted === true) {
    log('chat: session_upserted broadcast observed (provider announced a native session id)');
  }
  log(`chat: stream level reached = ${chatLevel}${chatResult?.providerError ? ` — ${String(chatResult.providerError).slice(0, 160)}` : ''}`);

  // --- Shell pty E2E (task 10.5) ------------------------------------------
  // A DesktopWebSocket to ws://local/shell reaches handleShellConnection —
  // the same handler the standalone ws gateway dispatches. `init` with
  // isPlainShell spawns a real node-pty process (no provider CLI involved),
  // so the echo round-trip proves input -> pty -> output end to end.
  let shellResult = null;
  try {
    shellResult = await withTimeout(
      wc.executeJavaScript(`(async () => {
        const api = globalThis.__smokeDesktopWS;
        const out = {};
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

          const sh = api.createAppWebSocket('ws://local/shell');
          const msgs = [];
          sh.addEventListener('message', (e) => {
            try { msgs.push(JSON.parse(e.data)); } catch { /* keep raw-free */ }
          });
          await until(() => sh.readyState === 1, 10_000, 'shell socket open');
          out.open = true;

          sh.send(JSON.stringify({
            type: 'init',
            projectPath: ${JSON.stringify(workspacesRoot)},
            isPlainShell: true,
            cols: 80,
            rows: 24,
          }));
          await until(
            () => msgs.find((m) => m.type === 'output' && /Starting terminal in:/.test(m.data || '')),
            15_000,
            'shell welcome output',
          );
          out.welcome = true;

          // The arithmetic is evaluated by the spawned shell — SMOKE_PTY_42
          // can only appear if input reached a live pty and its output came
          // back over the socket (the echoed input line carries the raw
          // '$((6*7))', never the computed value).
          sh.send(JSON.stringify({ type: 'input', data: 'echo SMOKE_PTY_$((6*7))\\n' }));
          await until(
            () => msgs.some((m) => m.type === 'output' && (m.data || '').includes('SMOKE_PTY_42')),
            15_000,
            'shell echo output',
          );
          out.echo = true;

          // resize has no response frame — prove the pty pipe survives it.
          sh.send(JSON.stringify({ type: 'resize', cols: 120, rows: 40 }));
          sh.send(JSON.stringify({ type: 'input', data: 'echo AFTER_RESIZE_$((1+1))\\n' }));
          await until(
            () => msgs.some((m) => m.type === 'output' && (m.data || '').includes('AFTER_RESIZE_2')),
            15_000,
            'post-resize echo',
          );
          out.resizeOk = true;

          // Clean shutdown: "exit" ends the spawned shell, the pty onExit
          // reports it and the server drops the session-map entry.
          sh.send(JSON.stringify({ type: 'input', data: 'exit\\n' }));
          const exitFrame = await until(
            () => msgs.find((m) => m.type === 'output' && /Process exited with code \\d+/.test(m.data || '')),
            15_000,
            'pty exit frame',
          );
          out.exited = /code 0/.test(exitFrame.data || '');
          sh.close();

          // Protocol-level rejection: init against a missing directory gets a
          // structured error frame, not a silent drop.
          const bad = api.createAppWebSocket('ws://local/shell');
          const bmsgs = [];
          bad.addEventListener('message', (e) => {
            try { bmsgs.push(JSON.parse(e.data)); } catch { /* keep raw-free */ }
          });
          await until(() => bad.readyState === 1, 10_000, 'bad-init socket open');
          bad.send(JSON.stringify({
            type: 'init',
            projectPath: '/nonexistent-ddagent-smoke-dir',
            isPlainShell: true,
          }));
          const err = await until(() => bmsgs.find((m) => m.type === 'error'), 10_000, 'shell error frame');
          out.badPath = { type: err.type, message: err.message };
          bad.close();
        } catch (error) {
          out.error = String((error && error.message) || error);
        }
        return out;
      })()`),
      75_000,
      'shell pty scenario in page',
    );
  } catch (error) {
    shellResult = { error: String(error?.message || error) };
  }
  const shellErr = shellResult?.error ? ` (${shellResult.error})` : '';
  check(
    'shell: socket opens on ws://local/shell',
    shellResult?.open === true,
    shellErr,
  );
  check(
    'shell: init -> welcome output frame (pty spawned)',
    shellResult?.welcome === true,
    shellErr,
  );
  check(
    'shell: input -> shell-computed echo output (pty round-trip)',
    shellResult?.echo === true,
    shellErr,
  );
  check(
    'shell: resize tolerated, pty still responsive',
    shellResult?.resizeOk === true,
    shellErr,
  );
  check(
    'shell: exit -> "Process exited with code 0" frame',
    shellResult?.exited === true,
    shellErr,
  );
  check(
    'shell: invalid projectPath -> error frame',
    shellResult?.badPath?.type === 'error' && /Invalid project path/.test(shellResult?.badPath?.message || ''),
    JSON.stringify(shellResult?.badPath || null) + shellErr,
  );

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

  // --- Disconnect -> launcher ----------------------------------------------
  // The disconnect IPC must swap the main window back to the launcher target.
  // Local-mode semantics: the embedded backend keeps running and the 'local'
  // tab survives, so returning to it reuses the live session — only the view
  // stack goes back to the launcher UI.
  const disconnectState = await withTimeout(
    launcherWindow.webContents.executeJavaScript(`window.ddagentDesktop.disconnect()`),
    15_000,
    'ddagentDesktop.disconnect()',
  );
  check(
    'disconnect: active target returns to launcher',
    disconnectState?.activeTarget?.kind === 'launcher' && disconnectState?.activeTabId === 'home',
    JSON.stringify({ activeTarget: disconnectState?.activeTarget, activeTabId: disconnectState?.activeTabId }),
  );
  check(
    'disconnect: embedded backend keeps running, local tab survives',
    disconnectState?.localServerRunning === true
      && Boolean(disconnectState?.tabs?.some((tab) => tab.id === 'local')),
    JSON.stringify({ localServerRunning: disconnectState?.localServerRunning, tabs: (disconnectState?.tabs || []).map((tab) => tab.id) }),
  );
  check(
    'disconnect: all BrowserViews detached from main window',
    launcherWindow.getBrowserViews().length === 0,
    `browserViews=${launcherWindow.getBrowserViews().length}`,
  );

  // Disconnect must NOT clear lastTarget — resume-last-session semantics mean
  // the next launch auto-continues back to the local target.
  try {
    const stored = JSON.parse(fs.readFileSync(desktopSettingsPath, 'utf8'));
    check(
      'autocontinue: disconnect keeps lastTarget for next launch',
      stored?.lastTarget?.kind === 'local',
      JSON.stringify(stored?.lastTarget || null),
    );
  } catch (error) {
    check('autocontinue: disconnect keeps lastTarget for next launch', false, String(error?.message || error));
  }
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

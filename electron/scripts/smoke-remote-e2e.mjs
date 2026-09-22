// Headless end-to-end smoke for the REMOTE connect flow (task 10.6). Boots
// the REAL electron/main.js under headless ozone and drives the launcher via
// the same preload-bridge IPC the UI uses, against a mock ddagent server —
// a tiny node:http server in THIS process serving a ddagent-shaped
// GET /health ({status:'ok',version,...}) and a minimal GET / page:
//
//   1. remoteServers.check(url) accepts the ddagent health shape and rejects
//      both a non-ddagent JSON body and an invalid URL,
//   2. remoteServers.add() persists the entry to <userData>/remote-servers.json,
//   3. remoteServers.open(entry) -> openRemoteServerInDesktop -> BrowserView
//      loads the mock URL in a per-server persist:remote-<origin> partition
//      (asserted via the __ddagentPartition marker AND session identity),
//   4. the remote origin gets the app bridge (desktopApi.ws) but NOT the
//      launcher bridge (window.ddagentDesktop is file://-only),
//   5. connect touches lastUsedAt and persists lastTarget for auto-continue,
//   6. disconnect() destroys the remote tab + view and lands on the launcher
//      while the store entry survives,
//   7. reconnect recreates the view in the SAME partition and partition
//      localStorage written by the first view is still there — the whole
//      point of persist:remote-* (login survives reconnects/restarts).
//
// This is a sibling of smoke-inproc-e2e.mjs, not an extension of it: the
// in-proc smoke asserts "no TCP listener anywhere in the process tree", which
// a mock server would violate by definition. No dist/ or dist-server build is
// needed — the remote path never touches the embedded backend or the
// ddagent-app:// scheme; the launcher is plain file://.
//
// Run from the repo root:
//   node_modules/.bin/electron --no-sandbox --ozone-platform=headless \
//     --disable-gpu electron/scripts/smoke-remote-e2e.mjs
//
// Same env flags as the in-proc smoke (forced inside, so `npm run
// test:desktop:remote` matches). Exit code: 0 = all checks passed, 1 =
// failure. The profile lives in a throwaway userData dir (override with
// DDAGENT_SMOKE_USERDATA) so a real install is never touched.

import fs from 'node:fs';
import http from 'node:http';
import os from 'node:os';
import path from 'node:path';

import { app, BrowserWindow, session } from 'electron';

const smokeUserData =
  process.env.DDAGENT_SMOKE_USERDATA ||
  fs.mkdtempSync(path.join(os.tmpdir(), 'ddagent-smoke-remote-'));

// Must land before importing main.js — its bootstrap reads userData lazily.
app.setPath('userData', smokeUserData);
process.env.DDAGENT_DESKTOP_INPROC = '1';
// Launch auto-continue would re-enter a persisted lastTarget on boot when
// DDAGENT_SMOKE_USERDATA is reused — pin the launcher-first path so the
// harness alone drives the remote connect.
process.env.DDAGENT_DESKTOP_NO_AUTOCONTINUE = '1';
// Headless ozone has no display connection — the tray's Gtk context menu
// aborts the process on first page load; main.js honors this flag.
process.env.DDAGENT_DESKTOP_NO_TRAY = '1';
delete process.env.ELECTRON_DEV_URL;

const startedAt = Date.now();
// Direct fd-2 writes: app.exit() can drop piped stdout buffered by Node, and
// the parent shell merges stderr anyway — never lose the verdict.
const emit = (line) => fs.writeSync(2, `${line}\n`);
const log = (line) => emit(`[smoke-remote ${String((Date.now() - startedAt) / 1000).slice(0, 6)}s] ${line}`);

const checks = [];
function check(name, ok, detail = '') {
  checks.push({ name, ok });
  emit(`${ok ? 'PASS' : 'FAIL'} ${name}${detail ? ` — ${detail}` : ''}`);
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

// --- Mock ddagent server ----------------------------------------------------
// checkRemoteServer (electron/remoteHealth.js) requires GET /health -> JSON
// with body.status === 'ok'; version/installMode are passed through. Flip
// healthy=false to serve a well-formed but non-ddagent body for the negative
// check. Everything else gets a minimal HTML page / 404.
const PAGE_MARKER = 'REMOTE_SMOKE_MARKER_7f3a';
const mockState = { healthy: true };
const mockServer = http.createServer((req, res) => {
  let pathname;
  try {
    pathname = new URL(req.url || '/', 'http://127.0.0.1').pathname;
  } catch {
    pathname = '/';
  }
  if (pathname === '/health') {
    res.writeHead(200, { 'content-type': 'application/json' });
    res.end(JSON.stringify(
      mockState.healthy
        ? { status: 'ok', version: 'smoke-remote-1.0', installMode: 'test' }
        : { ok: true, version: 'not-a-ddagent-shape' },
    ));
    return;
  }
  if (pathname === '/') {
    res.writeHead(200, { 'content-type': 'text/html' });
    res.end(`<!doctype html><meta charset="utf-8"><title>smoke-remote-app</title><div id="app">${PAGE_MARKER}</div>`);
    return;
  }
  res.writeHead(404, { 'content-type': 'text/plain' });
  res.end('not found');
});

await new Promise((resolve, reject) => {
  mockServer.once('error', reject);
  mockServer.listen(0, '127.0.0.1', resolve);
});
const mockPort = mockServer.address().port;
const mockOrigin = `http://127.0.0.1:${mockPort}`;
log(`mock ddagent server on ${mockOrigin}`);

// Same slug derivation as getRemoteTargetPartition() in viewHost.js —
// computed here instead of imported so the check fails if the app's mapping
// drifts, not just the test's copy of it.
const expectedPartition = `persist:remote-${new URL(mockOrigin).origin
  .toLowerCase()
  .replace(/[^a-z0-9]+/g, '-')
  .replace(/^-+|-+$/g, '')}`;

// Side effect: registerSchemesAsPrivileged + single-instance + bootstrap().
log('importing electron/main.js');
await import('../main.js');
log('main.js imported');

const remoteServersPath = path.join(smokeUserData, 'remote-servers.json');
const desktopSettingsPath = path.join(smokeUserData, 'desktop-settings.json');

function readJsonFile(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, 'utf8'));
  } catch {
    return null;
  }
}

// The active remote BrowserView, identified by its partition marker.
function findRemoteView(launcherWindow) {
  return launcherWindow.getBrowserViews().find((view) => {
    try {
      return typeof view.__ddagentPartition === 'string'
        && view.__ddagentPartition.startsWith('persist:remote-');
    } catch {
      return false;
    }
  }) || null;
}

async function drive() {
  log(`userData=${smokeUserData}`);

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
      `typeof window.ddagentDesktop === 'object' && typeof window.ddagentDesktop.remoteServers === 'object'`,
    ),
    15_000,
    'ddagentDesktop preload bridge (remoteServers)',
  );
  log('preload bridge ready');
  const bridge = (expression) => launcherWindow.webContents.executeJavaScript(expression);

  // --- Health check (ddagent-desktop:remote-servers-check) ----------------
  const healthOk = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.check(${JSON.stringify(mockOrigin)})`),
    15_000,
    'remoteServers.check',
  );
  check(
    'remote: health check accepts ddagent-shaped /health',
    healthOk?.ok === true && healthOk?.version === 'smoke-remote-1.0',
    JSON.stringify(healthOk),
  );

  mockState.healthy = false;
  const healthBad = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.check(${JSON.stringify(mockOrigin)})`),
    15_000,
    'remoteServers.check (non-ddagent body)',
  ).finally(() => { mockState.healthy = true; });
  check(
    'remote: health check rejects non-ddagent JSON as not-ddagent',
    healthBad?.ok === false && healthBad?.reason === 'not-ddagent',
    JSON.stringify(healthBad),
  );

  const healthInvalid = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.check('not a url')`),
    15_000,
    'remoteServers.check (invalid url)',
  );
  check(
    'remote: health check rejects invalid URL',
    healthInvalid?.ok === false && typeof healthInvalid?.reason === 'string',
    JSON.stringify(healthInvalid),
  );

  // --- Save the server (ddagent-desktop:remote-servers-add) ---------------
  const entry = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.add({ url: ${JSON.stringify(mockOrigin)}, name: 'smoke-remote' })`),
    15_000,
    'remoteServers.add',
  );
  check(
    'remote: add() returns a normalized stored entry',
    Boolean(entry?.id) && entry?.url === mockOrigin && entry?.name === 'smoke-remote',
    JSON.stringify(entry),
  );

  const storedServers = await waitFor(
    () => {
      const stored = readJsonFile(remoteServersPath);
      return Array.isArray(stored) && stored.some((server) => server.id === entry.id) ? stored : null;
    },
    5_000,
    'remote-servers.json write',
  );
  check(
    'remote: remote-servers.json persisted under userData',
    Boolean(storedServers),
    remoteServersPath,
  );

  // --- Connect (ddagent-desktop:open-remote-url) ----------------------------
  // The real launcher path (CC.openServer -> bridge.remoteServers.open) passes
  // the stored entry; openRemoteServerInDesktop resolves with desktop state
  // once the view finished loading.
  const openState = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.open(${JSON.stringify({ id: entry.id, url: entry.url, name: entry.name })})`),
    45_000,
    'remoteServers.open',
  );
  check(
    'remote: open() activates the remote target and its tab',
    openState?.activeTarget?.kind === 'remote'
      && openState?.activeTarget?.id === entry.id
      && openState?.activeTabId === `remote:${entry.id}`
      && openState?.tabs?.some((tab) => tab.id === `remote:${entry.id}` && tab.kind === 'remote'),
    JSON.stringify({ activeTarget: openState?.activeTarget, activeTabId: openState?.activeTabId }),
  );

  const view = await waitFor(
    () => findRemoteView(launcherWindow),
    15_000,
    'persist:remote-* BrowserView',
  );
  const remoteUrl = view.webContents.getURL();
  check(
    'remote: BrowserView loaded the mock server URL',
    remoteUrl === `${mockOrigin}/`,
    remoteUrl,
  );
  check(
    'remote: view partition marker is persist:remote-<origin>',
    view.__ddagentPartition === expectedPartition,
    `__ddagentPartition=${view.__ddagentPartition}`,
  );
  check(
    'remote: view webContents uses the per-server session',
    view.webContents.session === session.fromPartition(expectedPartition),
    `session match for ${expectedPartition}`,
  );

  const page = await view.webContents.executeJavaScript(
    `({ title: document.title, bodyLen: document.body ? document.body.innerHTML.length : 0, marker: document.body ? document.body.innerHTML.includes(${JSON.stringify(PAGE_MARKER)}) : false })`,
  );
  check(
    'remote: mock app HTML rendered inside the view',
    page.title === 'smoke-remote-app' && page.marker === true && page.bodyLen > 0,
    JSON.stringify(page),
  );

  const remoteBridges = await view.webContents.executeJavaScript(
    `({ launcher: typeof window.ddagentDesktop, app: typeof window.desktopApi, ws: typeof (window.desktopApi && window.desktopApi.ws) })`,
  );
  check(
    'remote: http origin gets app bridge (desktopApi.ws) but not the launcher bridge',
    remoteBridges.launcher === 'undefined' && remoteBridges.app === 'object' && remoteBridges.ws === 'object',
    JSON.stringify(remoteBridges),
  );

  // Partition localStorage marker — the reconnect check below reads it back
  // from a NEW webContents in the SAME session, proving persist:remote-*
  // survives the view being destroyed on disconnect.
  await view.webContents.executeJavaScript(
    `window.localStorage.setItem('smoke-remote-marker', ${JSON.stringify(PAGE_MARKER)}), 'stored'`,
  );

  const listed = await bridge(`window.ddagentDesktop.remoteServers.list()`);
  const listedEntry = (listed || []).find((server) => server.id === entry.id);
  check(
    'remote: connect touched lastUsedAt (remote-servers-list)',
    Boolean(listedEntry?.lastUsedAt),
    JSON.stringify(listedEntry || null),
  );

  // setActiveTarget persists lastTarget for launch auto-continue (async write).
  const persistedTarget = await waitFor(
    () => {
      const stored = readJsonFile(desktopSettingsPath);
      return stored?.lastTarget?.kind ? stored : null;
    },
    5_000,
    'lastTarget persisted to desktop-settings.json',
  );
  check(
    'remote: lastTarget persisted for auto-continue',
    persistedTarget?.lastTarget?.kind === 'remote'
      && persistedTarget?.lastTarget?.serverId === entry.id
      && persistedTarget?.lastTarget?.url === mockOrigin,
    JSON.stringify(persistedTarget?.lastTarget || null),
  );

  // --- Disconnect -> launcher ---------------------------------------------
  const disconnectState = await withTimeout(
    bridge(`window.ddagentDesktop.disconnect()`),
    15_000,
    'ddagentDesktop.disconnect()',
  );
  check(
    'remote: disconnect returns to the launcher',
    disconnectState?.activeTarget?.kind === 'launcher' && disconnectState?.activeTabId === 'home',
    JSON.stringify({ activeTarget: disconnectState?.activeTarget, activeTabId: disconnectState?.activeTabId }),
  );
  check(
    'remote: remote tab removed and its BrowserView destroyed',
    !disconnectState?.tabs?.some((tab) => tab.kind === 'remote')
      && launcherWindow.getBrowserViews().length === 0,
    JSON.stringify({ tabs: (disconnectState?.tabs || []).map((tab) => tab.id), views: launcherWindow.getBrowserViews().length }),
  );
  const storedAfterDisconnect = readJsonFile(remoteServersPath);
  check(
    'remote: server entry survives disconnect',
    Array.isArray(storedAfterDisconnect) && storedAfterDisconnect.some((server) => server.id === entry.id),
    `${remoteServersPath} (${(storedAfterDisconnect || []).length} entries)`,
  );

  // --- Reconnect: same partition, localStorage survives --------------------
  const reopenState = await withTimeout(
    bridge(`window.ddagentDesktop.remoteServers.open(${JSON.stringify({ id: entry.id, url: entry.url, name: entry.name })})`),
    45_000,
    'remoteServers.open (reconnect)',
  );
  check(
    'remote: reconnect re-activates the remote target',
    reopenState?.activeTarget?.kind === 'remote' && reopenState?.activeTarget?.id === entry.id,
    JSON.stringify(reopenState?.activeTarget || null),
  );

  const view2 = await waitFor(
    () => findRemoteView(launcherWindow),
    15_000,
    'persist:remote-* BrowserView after reconnect',
  );
  await waitFor(
    () => view2.webContents.getURL() === `${mockOrigin}/`,
    15_000,
    'mock URL loaded after reconnect',
  );
  check(
    'remote: reconnect reuses the same persist:remote-* partition',
    view2.__ddagentPartition === expectedPartition
      && view2.webContents.session === session.fromPartition(expectedPartition),
    `__ddagentPartition=${view2.__ddagentPartition}`,
  );

  const markerAfterReconnect = await view2.webContents.executeJavaScript(
    `window.localStorage.getItem('smoke-remote-marker')`,
  );
  check(
    'remote: partition localStorage survives disconnect + reconnect',
    markerAfterReconnect === PAGE_MARKER,
    `marker=${markerAfterReconnect}`,
  );

  const disconnectState2 = await withTimeout(
    bridge(`window.ddagentDesktop.disconnect()`),
    15_000,
    'ddagentDesktop.disconnect() (second)',
  );
  check(
    'remote: second disconnect returns to the launcher',
    disconnectState2?.activeTarget?.kind === 'launcher' && launcherWindow.getBrowserViews().length === 0,
    JSON.stringify({ activeTarget: disconnectState2?.activeTarget, views: launcherWindow.getBrowserViews().length }),
  );
}

const watchdog = setTimeout(() => {
  emit('[smoke-remote] overall timeout — aborting');
  app.exit(1);
}, 120_000);

async function dumpState() {
  try {
    const win = BrowserWindow.getAllWindows()[0];
    if (win && !win.webContents.isDestroyed()) {
      const state = await win.webContents.executeJavaScript(
        `window.ddagentDesktop ? window.ddagentDesktop.getState() : null`,
      );
      emit(`[smoke-remote] last desktop state: ${JSON.stringify(state)?.slice(0, 2000)}`);
    }
  } catch {
    // Best effort diagnostics only.
  }
}

function finish() {
  clearTimeout(watchdog);
  try {
    mockServer.close();
  } catch {
    // Already closed — nothing to do.
  }
  const failed = checks.filter((entry) => !entry.ok);
  emit(`[smoke-remote] ${checks.length - failed.length}/${checks.length} checks passed`);
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
    emit(`[smoke-remote] driver failed: ${error?.stack || error}`);
    await dumpState();
    check('driver completed', false, error?.message || String(error));
  })
  .finally(finish);

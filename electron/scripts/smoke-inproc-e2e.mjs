// Headless end-to-end REST smoke for DDAGENT_DESKTOP_INPROC=1 (embedded
// backend). Boots the REAL electron/main.js — launcher window, preload
// bridge, IPC handlers, protocol.handle — under a headless ozone platform,
// drives "This computer" via window.ddagentDesktop.openLocal(), then asserts
// on the ddagent-app://local/index.html page:
//
//   1. the app HTML actually loaded (title + non-empty DOM),
//   2. fetch('/api/*') answers over the ddagent-app:// scheme — a public route
//      and at least one authenticateToken-protected route in platform mode,
//   3. no TCP listener is bound by any process in the app's process tree
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

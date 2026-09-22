// Embedded-backend bootstrap for DDAGENT_DESKTOP_INPROC=1 local mode.
//
// Boots the real ddagent backend inside the Electron main process — no TCP
// listener anywhere. Requests travel over the ddagent-app:// protocol handler
// (/api/*) and the WS-over-IPC router instead of sockets.
//
// Ordering contract: server/load-env.js and several feature modules capture
// env (DATABASE_PATH, JWT_SECRET, VITE_IS_PLATFORM, WORKSPACES_ROOT) at import
// time, so every env var must be set BEFORE the first dist-server import —
// that is why services.js is pulled in via dynamic import() inside
// startEmbeddedBackend, never at module top level.

import crypto from 'node:crypto';
import fs from 'node:fs';
import fsp from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

import {
  setApiDispatcher,
  setBackendApp,
  setHttpAdapter,
  setWsDeps,
} from './localBackend.js';
import { createHttpAdapter } from './transport/httpAdapter.js';

const SERVICES_ENTRY = path.join('server', 'services.js');
const PLAINTEXT_SECRET_PATTERN = /^[0-9a-f]{64,}$/i;

// A desktop app is a single-user install — same shape the platform build of
// the frontend bundle already assumes (it skips the login screen and never
// attaches tokens), so the backend must run with IS_PLATFORM semantics. A
// stray API_KEY inherited from the launching shell would make
// validateApiKey 401 every /api call, so it is scrubbed.
function applyEmbeddedEnv({ databasePath, workspaceRoot, jwtSecret }) {
  process.env.NODE_ENV = 'production';
  process.env.DATABASE_PATH = databasePath;
  process.env.JWT_SECRET = jwtSecret;
  process.env.VITE_IS_PLATFORM = 'true';
  process.env.WORKSPACES_ROOT = process.env.WORKSPACES_ROOT || workspaceRoot;

  // Nothing ever calls listen() — these exist only so load-env's .env fill-in
  // and lazily-read config (e.g. KANBAN_REPORT_BASE_URL's derived default)
  // cannot pick up a port that implies a real server.
  process.env.SERVER_PORT = '0';
  process.env.PORT = '0';
  process.env.HOST = '127.0.0.1';
  delete process.env.API_KEY;
}

/**
 * Locates the compiled backend bundle.
 *
 * Dev: <repo>/dist-server. Packaged (asar:false): <resources>/app/dist-server
 * once D-F7 ships it inside the app. Also accepts the ServerInstaller cache
 * (~/.ddagent/server/<version>/dist-server) so a packaged app without a
 * bundled dist-server can still reuse a downloaded runtime, and an explicit
 * DDAGENT_EMBEDDED_SERVER_DIR override for tests/diagnostics.
 */
function resolveDistServerDir({ appRoot, appVersion }) {
  const candidates = [
    process.env.DDAGENT_EMBEDDED_SERVER_DIR,
    path.join(appRoot, 'dist-server'),
    typeof process.resourcesPath === 'string'
      ? path.join(process.resourcesPath, 'dist-server')
      : null,
    typeof process.resourcesPath === 'string'
      ? path.join(process.resourcesPath, 'app', 'dist-server')
      : null,
    appVersion
      ? path.join(os.homedir(), '.ddagent', 'server', appVersion, 'dist-server')
      : null,
  ].filter(Boolean);

  for (const dir of candidates) {
    if (fs.existsSync(path.join(dir, SERVICES_ENTRY))) {
      return dir;
    }
  }

  throw new Error(
    `Embedded backend bundle not found. Looked in:\n${candidates.map((dir) => `  - ${dir}`).join('\n')}`,
  );
}

/**
 * JWT signing secret for the embedded backend. Prefer Electron safeStorage
 * (OS keychain) and fall back to a plaintext 0600 file — either way the
 * secret is generated once and persisted in userData.
 *
 * Plaintext reads are gated on a strict hex shape so a safeStorage-encrypted
 * blob whose keychain is gone is regenerated instead of being adopted as a
 * mojibake secret.
 */
async function loadOrCreateJwtSecret(userDataDir, safeStorage) {
  const secretPath = path.join(userDataDir, 'jwt-secret');
  const stored = await fsp.readFile(secretPath).catch(() => null);

  if (stored?.length) {
    const text = stored.toString('utf8').trim();
    if (PLAINTEXT_SECRET_PATTERN.test(text)) {
      return text;
    }
    if (safeStorage?.isEncryptionAvailable?.()) {
      try {
        return safeStorage.decryptString(stored);
      } catch {
        // Keychain entry lost — fall through and regenerate.
      }
    }
  }

  const secret = crypto.randomBytes(48).toString('hex');
  const payload = safeStorage?.isEncryptionAvailable?.()
    ? safeStorage.encryptString(secret)
    : Buffer.from(secret, 'utf8');
  await fsp.mkdir(userDataDir, { recursive: true });
  await fsp.writeFile(secretPath, payload, { mode: 0o600 });
  return secret;
}

/**
 * Platform-mode auth answers every request as userDb.getFirstUser() — with a
 * fresh userData DB there is no user and every call 500s. The platform-built
 * frontend never registers, so the bootstrap provisions the single local
 * user through the public /api/auth routes themselves.
 */
async function ensurePlatformUser(adapter, log) {
  const status = await adapter.dispatch({ method: 'GET', path: '/api/auth/status' });
  let needsSetup = false;
  try {
    needsSetup = Boolean(JSON.parse(status.body.toString('utf8'))?.needsSetup);
  } catch {
    needsSetup = false;
  }
  if (!needsSetup) return;

  // The password is never used (platform mode skips JWT checks) — it only
  // satisfies the register route's validation.
  const password = crypto.randomBytes(24).toString('hex');
  const res = await adapter.dispatch({
    method: 'POST',
    path: '/api/auth/register',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ username: 'desktop', password }),
  });
  const bodyText = res.body.toString('utf8');
  if (res.status >= 400 && !bodyText.includes('AUTH_USER_ALREADY_CONFIGURED')) {
    throw new Error(`Local user provisioning failed (HTTP ${res.status}): ${bodyText}`);
  }
  log('Provisioned local user "desktop".');
}

function getAppVersion(app, appRoot) {
  try {
    return app?.getVersion?.() || JSON.parse(
      fs.readFileSync(path.join(appRoot, 'package.json'), 'utf8'),
    ).version || null;
  } catch {
    return null;
  }
}

/**
 * Boots the ddagent backend in-process and wires it into the desktop
 * transports. Resolves once createServices() has returned — the caller should
 * await this before loading ddagent-app:// so the first page fetch hits a
 * working /api.
 *
 * @param {object} options
 * @param {object} [options.app] Electron app — used for getPath/getVersion fallbacks.
 * @param {string} [options.userDataDir] Data root; defaults to app.getPath('userData').
 * @param {string} [options.appRoot] App root for package.json/public/dist lookups.
 * @param {Set} [options.wsClients] Open-socket set from createWsRouter — becomes app.locals.wss.clients.
 * @param {object} [options.safeStorage] Electron safeStorage (optional; plaintext fallback without it).
 * @param {(line: string) => void} [options.onLog] Startup-log sink (localServer.appendStartupLog).
 * @returns {Promise<{app: object, shutdown: () => Promise<void>}>}
 */
export async function startEmbeddedBackend({
  app,
  userDataDir,
  appRoot,
  wsClients,
  safeStorage,
  onLog,
} = {}) {
  const log = typeof onLog === 'function' ? onLog : () => {};
  const dataDir = userDataDir || app?.getPath?.('userData');
  if (!dataDir) {
    throw new Error('startEmbeddedBackend requires userDataDir (or an Electron app).');
  }
  const root = appRoot || path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');

  const distServerDir = resolveDistServerDir({
    appRoot: root,
    appVersion: getAppVersion(app, root),
  });
  // First-run directory contract — the only dirs the backend cannot create
  // for itself are made here, before the first dist-server import:
  //   - <userData>/db         DATABASE_PATH dir (connection.ts mkdirs it lazily
  //                           as well — doing it here keeps the boot order
  //                           explicit and independent of module internals)
  //   - WORKSPACES_ROOT       validateWorkspacePath() realpath()s the root and
  //                           the file-tree browser opendir()s it — both throw
  //                           if it is missing, so it must exist before boot.
  //                           Default ~/ddagent-workspace is a user-facing
  //                           projects dir on purpose, NOT hidden in userData.
  // Everything else self-creates lazily: ~/.ddagent/assets on first upload,
  // provider transcript roots (~/.claude/projects, ~/.codex/sessions, ...) in
  // initializeSessionsWatcher, <project>/.ddagent/devin per devin run.
  //
  // ~/.ddagent is deliberately shared with a web install instead of being
  // redirected into userData: attachment paths are persisted as absolute
  // paths inside provider transcripts (~/.claude/projects/*.jsonl) that both
  // installs read back, and ~/.ddagent/server/<version> is the shared runtime
  // cache resolveDistServerDir falls back to. A userData-local assets dir
  // would break those cross-install references for no real sandboxing gain.
  const databasePath = path.join(dataDir, 'db', 'auth.db');
  const workspaceRoot = path.join(os.homedir(), 'ddagent-workspace');
  const jwtSecret = await loadOrCreateJwtSecret(dataDir, safeStorage);

  await fsp.mkdir(path.dirname(databasePath), { recursive: true });
  await fsp.mkdir(process.env.WORKSPACES_ROOT || workspaceRoot, { recursive: true });
  applyEmbeddedEnv({ databasePath, workspaceRoot, jwtSecret });

  log(`Booting embedded backend from ${distServerDir}`);
  log(`DATABASE_PATH=${databasePath}`);

  // First dist-server import — env above must already be in place.
  const servicesUrl = pathToFileURL(path.join(distServerDir, SERVICES_ENTRY)).href;
  const { createServices } = await import(servicesUrl);
  const result = await createServices({ appRoot: root, isPlatform: true });

  // Transports: legacy IPC payload adapter + web Request dispatcher for the
  // ddagent-app:// /api route, WS deps for the IPC router, and the clients
  // set broadcast users reach through app.locals.wss.
  const adapter = createHttpAdapter(result.app);
  setHttpAdapter(adapter);
  setApiDispatcher(adapter.dispatchRequest);
  setWsDeps(result.wsDeps);
  setBackendApp(result.app);
  result.app.locals.wss = { clients: wsClients ?? new Set() };

  await ensurePlatformUser(adapter, log);

  // Same post-listen step as the standalone entrypoint: sync provider
  // transcripts into the DB and watch ~/.claude, ~/.codex, etc. Runs async —
  // the API is usable while the initial sync streams in.
  void result.services.initializeSessionsWatcher().then(
    () => log('Session watcher ready.'),
    (error) => log(`Session watcher failed: ${error?.message || error}`),
  );

  log('Embedded backend ready.');

  const shutdown = async () => {
    for (const client of wsClients ?? []) {
      try {
        client.terminate();
      } catch {
        // Socket already gone.
      }
    }
    try {
      await result.services.closeSessionsWatcher();
    } catch {
      // Watcher may never have finished initializing.
    }
    await result.shutdown();
  };

  return { app: result.app, shutdown };
}

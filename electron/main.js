import { app, BrowserWindow, clipboard, dialog, ipcMain, protocol, safeStorage, session, shell } from 'electron';
import { spawn } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { APP_SCHEME } from './appScheme.js';
import { CloudController } from './cloud.js';
import { DesktopWindowManager } from './desktopWindow.js';
import { DesktopNotificationsController } from './desktopNotifications.js';
import { startEmbeddedBackend } from './embeddedBackend.js';
import { dispatchApiRequest, getBackendApp, getWsDeps } from './localBackend.js';
import { LocalServerController } from './localServer.js';
import { checkRemoteServer } from './remoteHealth.js';
import { normalizeServerUrl, RemoteServersStore } from './remoteServers.js';
import { createDistProtocolHandler } from './staticProtocol.js';
import { TabsController } from './tabs.js';
import { getRemoteTargetPartition } from './viewHost.js';
import { createWsRouter } from './transport/wsRouter.js';

const __dirname = path.dirname(fileURLToPath(import.meta.url));

const APP_NAME = 'ddagent';
const APP_USER_MODEL_ID = 'ai.ddagent.desktop';
const CALLBACK_PROTOCOL = 'ddagent';
const CALLBACK_URL = `${CALLBACK_PROTOCOL}://auth/callback`;
const DDAGENT_CONTROL_PLANE_URL = process.env.DDAGENT_CONTROL_PLANE_URL || 'https://github.com/Zakwei/ddagent';
const REMOTE_START_TIMEOUT_MS = 30000;
const AUTH_CALLBACK_TTL_MS = 10 * 60 * 1000;
// Auto-continue (task 7.3): how long the boot-time remote health probe may
// take before falling back to the launcher. Keep it short — it gates startup.
const AUTOCONTINUE_HEALTH_TIMEOUT_MS = 3000;

protocol.registerSchemesAsPrivileged([
  // allowServiceWorkers exposes navigator.serviceWorker on the custom scheme
  // (the app registers /sw.js for web push + asset caching). `secure` makes it
  // a secure context — required by both SW and CacheStorage — and
  // supportFetchAPI lets SW-initiated fetches ride protocol.handle.
  { scheme: APP_SCHEME, privileges: { standard: true, secure: true, supportFetchAPI: true, stream: true, corsEnabled: true, bypassCSP: false, allowServiceWorkers: true } },
]);

const tabs = new TabsController();

// WS-over-IPC router for DesktopWebSocket. Deps resolve lazily: until the
// backend bootstrap calls setWsDeps(result.wsDeps), connects fail with
// close 1011. Bootstrap also assigns app.locals.wss = { clients: wsRouter.clients }.
const wsRouter = createWsRouter({ getWsDeps, getApp: getBackendApp });

if (process.platform === 'win32') {
  app.setAppUserModelId(APP_USER_MODEL_ID);
}

let activeTarget = { kind: 'launcher', name: APP_NAME, url: null };
let desktopWindow = null;
let localServer = null;
let cloud = null;
let remoteServers = null;
let desktopNotifications = null;
let isQuitting = false;
let isRefreshingCloud = false;
// Remote-servers ids whose auto-continue health probe failed this run —
// reported to the launcher so the entry can be flagged offline.
const offlineRemoteServerIds = new Set();
// One-line activity pushed to the launcher while auto-continue works (e.g.
// "Connecting to X...") — the health probe can take seconds and the launcher
// must not sit inert meanwhile. null when nothing is in flight.
let autoContinueStatus = null;
let pendingCloudConnectStartedAt = 0;
let embeddedBackendPromise = null;
let embeddedBackendShutdown = null;
// origin -> Promise<'once'|'always'|'cancel'> while a trust dialog is open, so
// concurrent certificate-error events share one user decision.
const pendingCertDecisions = new Map();

function getAppRoot() {
  return app.isPackaged ? app.getAppPath() : path.resolve(__dirname, '..');
}

// DDAGENT_DESKTOP_INPROC=1 boots the real backend in this process — no TCP
// listen, /api + WS ride IPC/protocol transports. Memoized so repeated
// "This computer" picks share one boot; a failure clears the memo so the
// next attempt retries instead of caching a dead promise.
function ensureEmbeddedBackend() {
  if (!embeddedBackendPromise) {
    embeddedBackendPromise = startEmbeddedBackend({
      app,
      userDataDir: app.getPath('userData'),
      appRoot: getAppRoot(),
      wsClients: wsRouter.clients,
      safeStorage,
      onLog: (line) => localServer?.appendStartupLog(line),
    }).then((backend) => {
      embeddedBackendShutdown = backend.shutdown;
      return backend;
    }).catch((error) => {
      embeddedBackendPromise = null;
      throw error;
    });
  }
  return embeddedBackendPromise;
}

function getLauncherPath() {
  return path.join(__dirname, 'launcher', 'index.html');
}

function getPreloadPath() {
  return path.join(__dirname, 'preload.cjs');
}

function getWindowIconPath() {
  if (process.platform === 'darwin') {
    return path.join(getAppRoot(), 'electron', 'assets', 'logo-macos.png');
  }
  return path.join(getAppRoot(), 'public', 'logo-512.png');
}

function getStorePath() {
  return path.join(app.getPath('userData'), 'cloud-account.json');
}

function getSettingsPath() {
  return path.join(app.getPath('userData'), 'desktop-settings.json');
}

function getDesktopNotificationsSettingsPath() {
  return path.join(app.getPath('userData'), 'desktop-notifications-settings.json');
}

function getRemoteServersPath() {
  return path.join(app.getPath('userData'), 'remote-servers.json');
}

function getRunningEnvironmentUrls() {
  return cloud.getEnvironments()
    .filter((environment) => environment.status === 'running')
    .map((environment) => cloud.getEnvironmentUrl(environment))
    .filter(Boolean);
}

function getUrlOrigin(url) {
  try {
    const origin = new URL(url).origin;
    return origin === 'null' ? null : origin;
  } catch {
    return null;
  }
}

// Remote-notification targets = open remote tabs that are not cloud
// environments (those already come from getRunningEnvironmentUrls). Scope is
// "connected" on purpose: the remote auth token is only readable from an open
// tab's persist:remote-* partition localStorage, so a saved-but-closed server
// could not authenticate anyway.
function getRemoteServerNotificationUrls() {
  const cloudOrigins = new Set(getRunningEnvironmentUrls().map(getUrlOrigin).filter(Boolean));
  const urls = [];
  for (const tab of tabs.tabs) {
    if (tab.kind !== 'remote' || !tab.target?.url) continue;
    const origin = getUrlOrigin(tab.target.url);
    if (!origin || cloudOrigins.has(origin) || urls.includes(origin)) continue;
    urls.push(origin);
  }
  return urls;
}

function syncDesktopNotifications() {
  void desktopNotifications?.sync().catch((error) => console.error('[DesktopNotifications] sync failed:', error?.message || error));
}

function getDisplayTargetName() {
  return activeTarget?.name || APP_NAME;
}

function getCloudState() {
  return {
    account: cloud.getAccount(),
    environments: cloud.getEnvironments(),
    controlPlaneUrl: DDAGENT_CONTROL_PLANE_URL,
  };
}

function getLocalState() {
  return {
    desktopSettings: localServer.getSettings(),
    localServerRunning: Boolean(localServer.getLocalServerUrl()),
    localStatus: localServer.getLocalStatus(),
    localWebUrl: localServer.getLocalServerUrl(),
    shareableWebUrl: localServer.getShareableWebUrl(),
    localError: localServer.getLocalError(),
  };
}

function serializeEnvironment(environment) {
  return {
    id: environment.id,
    name: environment.name,
    subdomain: environment.subdomain,
    access_url: cloud.getEnvironmentUrl(environment),
    status: environment.status,
    created_at: environment.created_at,
    github_url: environment.github_url || null,
    region: environment.region || null,
    agent: environment.agent || null,
  };
}

function getDesktopState() {
  const cloudAccount = cloud.getAccount();
  const localState = getLocalState();
  const authState = cloud.getAuthState();
  return {
    account: {
      connected: authState === 'connected',
      email: cloudAccount?.email || null,
      authState,
      requiresReconnect: authState === 'expired',
    },
    activeTarget,
    desktopSettings: localState.desktopSettings,
    localWebUrl: localState.localWebUrl,
    shareableWebUrl: localState.shareableWebUrl,
    localServerRunning: localState.localServerRunning,
    localStatus: localState.localStatus,
    localError: localState.localError,
    localStartupLogs: localServer.getStartupLogs(),
    autoContinueStatus,
    offlineServerIds: [...offlineRemoteServerIds],
    cloudLoading: isRefreshingCloud,
    tabs: tabs.getSerializableTabs(),
    activeTabId: tabs.activeTabId,
    environments: cloud.getEnvironments().map(serializeEnvironment),
    desktopNotifications: desktopNotifications?.getState() || { enabled: false, supported: false, connectedCount: 0, targetCount: 0 },
  };
}

async function openExternalUrl(url) {
  if (String(url).startsWith(CALLBACK_PROTOCOL + "://")) {
    await handleDeepLink(url);
    return;
  }

  await shell.openExternal(url);
}

async function showError(title, error) {
  const message = error instanceof Error ? error.message : String(error);
  console.error(`${title}: ${message}`);
  await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'error',
    title,
    message: title,
    detail: message,
  });
}

function isExpectedNavigationAbort(error) {
  const message = error instanceof Error ? error.message : String(error);
  return error?.code === 'ERR_ABORTED' || message.includes('ERR_ABORTED') || message.includes('(-3)');
}

function syncDesktopState() {
  if (!desktopWindow) return;
  desktopWindow.buildAppMenu();
  desktopWindow.emitDesktopState();
  if (activeTarget?.kind === 'local' && !localServer?.getLocalServerUrl()) {
    void desktopWindow.showLocalStartupTarget(localServer.getPendingTarget(), localServer.getStartupLogs())
      .catch((error) => {
        if (isExpectedNavigationAbort(error)) return;
        void showError('Could not update local startup log', error);
      });
  }
}

function setActiveTarget(target) {
  activeTarget = target;
  // Persist the last real target for launch auto-continue (fire-and-forget —
  // a failed write must never break a target switch). 'launcher' is skipped
  // so disconnecting to the launcher still resumes the last session on boot.
  if (localServer && (target?.kind === 'local' || target?.kind === 'remote')) {
    void localServer.setLastTarget(target)
      .catch((error) => console.error('[DesktopState] could not persist lastTarget:', error?.message || error));
  }
}

function getEnvironmentTarget(environment) {
  return {
    kind: 'remote',
    id: environment.id,
    name: environment.name || environment.subdomain,
    url: cloud.getEnvironmentUrl(environment),
  };
}

async function getEnvironmentLaunchTarget(environment) {
  const environmentUrl = cloud.getEnvironmentUrl(environment);
  return {
    ...getEnvironmentTarget(environment),
    url: environmentUrl,
    loadUrl: await cloud.getEnvironmentLaunchUrl(environment),
  };
}

async function hasCloudWebSession(target) {
  // Remote targets live in per-server partitions (see viewHost), so the web
  // session check must read the partition the target will actually load in.
  const partition = getRemoteTargetPartition(target);
  const targetSession = partition ? session.fromPartition(partition) : session.defaultSession;
  const cookies = await targetSession.cookies.get({});
  return cookies.some((cookie) => {
    const cookieDomain = String(cookie.domain || '');
    return cookieDomain.includes('ddagent')
      && /-auth-token(?:\.\d+)?$/.test(cookie.name)
      && Boolean(cookie.value);
  });
}

function isCloudAuthRedirect(url) {
  if (!url) return false;
  try {
    const parsed = new URL(url);
    const controlPlane = new URL(DDAGENT_CONTROL_PLANE_URL);
    return parsed.origin === controlPlane.origin
      && (parsed.pathname === '/login' || parsed.pathname.startsWith('/auth/'));
  } catch {
    return false;
  }
}

function getDiagnosticsText() {
  const cloudAccount = cloud.getAccount();
  const localState = getLocalState();
  return JSON.stringify({
    app: APP_NAME,
    version: app.getVersion(),
    electron: process.versions.electron,
    node: process.versions.node,
    platform: process.platform,
    arch: process.arch,
    appPath: getAppRoot(),
    userDataPath: app.getPath('userData'),
    activeTarget,
    localServerUrl: localState.localWebUrl,
    localServerPort: localServer.localServerPort,
    localWebUrl: localState.localWebUrl,
    shareableWebUrl: localState.shareableWebUrl,
    localError: localState.localError || null,
    localStartupLogTail: localServer.getStartupLogs().slice(-50),
    desktopSettings: localState.desktopSettings,
    cloudConnected: Boolean(cloudAccount?.apiKey),
    cloudEmail: cloudAccount?.email || null,
    cloudEnvironmentCount: cloud.getEnvironments().length,
    cloudRunningEnvironmentCount: getRunningEnvironmentUrls().length,
    cloudAuthState: cloud.getAuthState(),
    cloudAccountPath: getStorePath(),
    controlPlaneUrl: DDAGENT_CONTROL_PLANE_URL,
  }, null, 2);
}

async function copyDiagnostics() {
  clipboard.writeText(getDiagnosticsText());
  await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'info',
    title: 'Diagnostics copied',
    message: 'ddagent desktop diagnostics were copied to the clipboard.',
  });
}

// --- Auto-update (task 9.4) --------------------------------------------------
// Feed: GitHub Releases — the `publish` config is generated into the staged
// desktop build by scripts/release/prepare-desktop-app.js. Everything here is
// inert unless app.isPackaged, so dev runs and the headless smoke (unpacked)
// never touch electron-updater — which is also only staged into packaged
// builds' node_modules.
let autoUpdaterModule = null;

// Update activity lands in the local startup log, which the launcher renders
// and Copy Diagnostics exports as localStartupLogTail.
function appendUpdateLog(line) {
  const text = `[update] ${line}`;
  if (localServer) {
    localServer.appendStartupLog(text);
  } else {
    console.log(text);
  }
}

// electron-updater's HttpError embeds the whole response dump (headers,
// cookies) — log only the one-line summary.
function updateErrorSummary(error) {
  const message = error instanceof Error ? error.message : String(error);
  return (message.split('\n').find((line) => line.trim()) || 'unknown error').slice(0, 200);
}

async function checkForUpdates() {
  const updater = autoUpdaterModule;
  if (!updater) {
    appendUpdateLog(app.isPackaged
      ? 'check skipped: electron-updater is not bundled in this build'
      : 'check skipped: auto-update only runs in packaged builds');
    return;
  }
  try {
    await updater.checkForUpdatesAndNotify();
  } catch (error) {
    appendUpdateLog(`check failed: ${updateErrorSummary(error)}`);
  }
}

async function initAutoUpdater() {
  if (!app.isPackaged) return;
  try {
    // electron-updater is CJS: `autoUpdater` is a lazy getter on
    // module.exports that cjs-module-lexer does not detect as a named
    // export, so read it off the default interop export.
    const mod = await import('electron-updater');
    autoUpdaterModule = mod.default?.autoUpdater ?? mod.autoUpdater;
    if (!autoUpdaterModule) throw new Error('autoUpdater export not found');
  } catch (error) {
    appendUpdateLog(`electron-updater unavailable: ${error instanceof Error ? error.message : error}`);
    return;
  }
  const updater = autoUpdaterModule;
  // electron-updater logs through an electron-log-shaped logger.
  updater.logger = {
    debug: () => {},
    info: (message) => appendUpdateLog(String(message)),
    warn: (message) => appendUpdateLog(`warn: ${message}`),
    error: (message) => appendUpdateLog(`error: ${updateErrorSummary(message)}`),
  };
  updater.on('update-available', (info) => appendUpdateLog(`update available: ${info?.version ?? 'unknown'}`));
  updater.on('update-not-available', () => appendUpdateLog('already up to date'));
  updater.on('update-downloaded', (info) => appendUpdateLog(`update ${info?.version ?? ''} downloaded — installs on quit`));
  updater.on('error', (error) => appendUpdateLog(`error: ${updateErrorSummary(error)}`));
  void checkForUpdates();
}

async function refreshCloudEnvironments({ showErrors = false } = {}) {
  isRefreshingCloud = true;
  syncDesktopState();
  try {
    return await cloud.refreshCloudEnvironments();
  } catch (error) {
    const authState = cloud.getAuthState();
    if (authState === 'expired') {
      const expiredError = new Error('Your ddagent session expired. Reconnect your account.');
      if (showErrors) {
        await showError('ddagent login required', expiredError);
        return [];
      }
      throw expiredError;
    }
    if (showErrors) {
      await showError('Could not load ddagent environments', error);
      return [];
    }
    throw error;
  } finally {
    isRefreshingCloud = false;
    syncDesktopNotifications();
    syncDesktopState();
  }
}

async function connectCloudAccount() {
  const connectUrl = cloud.buildConnectUrl();
  pendingCloudConnectStartedAt = Date.now();
  clipboard.writeText(connectUrl);
  await openExternalUrl(connectUrl);
  return connectUrl;
}

async function handleDeepLink(url) {
  let parsed;
  try {
    parsed = new URL(url);
  } catch {
    return;
  }

  if (parsed.protocol !== `${CALLBACK_PROTOCOL}:` || parsed.hostname !== 'auth') {
    return;
  }

  if (!pendingCloudConnectStartedAt || Date.now() - pendingCloudConnectStartedAt > AUTH_CALLBACK_TTL_MS) {
    await showError('ddagent account connection failed', new Error('No recent ddagent account connection was started from this app.'));
    return;
  }

  const apiKey = parsed.searchParams.get('api_key');
  if (!apiKey) {
    await showError('ddagent account connection failed', new Error('The callback did not include an API key.'));
    return;
  }

  await cloud.saveFromCallback({
    apiKey,
    email: parsed.searchParams.get('email'),
  });
  pendingCloudConnectStartedAt = 0;
  await refreshCloudEnvironments({ showErrors: true });

  dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'info',
    title: 'ddagent account connected',
    message: cloud.getAccount()?.email ? `Connected as ${cloud.getAccount().email}.` : 'ddagent account connected.',
  }).catch(() => {});
}

async function copyLocalWebUrl() {
  await localServer.ensureLocalServer();
  const shareableUrl = localServer.getShareableWebUrl();
  const localUrl = localServer.getLocalServerUrl();

  if (!shareableUrl) {
    throw new Error('Local ddagent URL is not available yet.');
  }

  clipboard.writeText(shareableUrl);
  const isLanUrl = shareableUrl !== localUrl;
  await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'info',
    title: 'Web URL copied',
    message: isLanUrl ? 'LAN web URL copied.' : 'Local web URL copied.',
    detail: isLanUrl
      ? `${shareableUrl}\n\nUse this URL from another device on the same network.`
      : `${shareableUrl}\n\nThis URL works on this computer. Enable LAN access before starting Local ddagent to copy a phone-accessible URL.`,
  });

  return getDesktopState();
}

async function openLocalWebUi() {
  await localServer.ensureLocalServer();
  const url = localServer.getShareableWebUrl() || localServer.getLocalServerUrl();
  if (!url || !url.startsWith('http')) {
    throw new Error('Local ddagent is embedded in this app — there is no browser URL to open.');
  }

  await openExternalUrl(url);
  return getDesktopState();
}

async function updateDesktopSetting(key, value) {
  const result = await localServer.updateDesktopSetting(key, value);
  syncDesktopState();

  if (result.requiresRestartNotice) {
    await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
      type: 'info',
      title: 'Restart local server to apply',
      message: 'LAN access changes apply the next time the local server starts.',
      detail: 'Quit ddagent and stop the local server, then open Local ddagent again.',
    });
  }

  return getDesktopState();
}

async function showEnvironmentPicker() {
  let environments = cloud.getEnvironments();
  let refreshError = null;

  if (cloud.getAccount()?.apiKey) {
    try {
      environments = await refreshCloudEnvironments({ showErrors: false });
    } catch (error) {
      refreshError = error;
      console.warn('[Cloud] Could not refresh environments before showing picker:', error?.message || error);
    }
  }

  const choices = ['Local ddagent', ...environments.map((environment) => {
    const status = environment.status === 'running' ? '' : ` (${environment.status})`;
    return `${environment.name || environment.subdomain}${status}`;
  })];

  const response = await dialog.showMessageBox(desktopWindow?.getMainWindow(), {
    type: 'question',
    buttons: [...choices, 'Cancel'],
    defaultId: 0,
    cancelId: choices.length,
    title: 'Switch ddagent Environment',
    message: 'Choose where this desktop window should connect.',
    detail: refreshError ? `Cloud environments could not be refreshed. Showing cached environments.\n\n${refreshError.message || refreshError}` : undefined,
  });

  if (response.response === choices.length) return getDesktopState();
  if (response.response === 0) return openLocalInDesktop();
  return openEnvironmentInDesktop(environments[response.response - 1]);
}

async function startEnvironment(environment) {
  await cloud.startEnvironmentAndWait(environment, REMOTE_START_TIMEOUT_MS);
  await refreshCloudEnvironments({ showErrors: true });
  return getDesktopState();
}

async function stopEnvironment(environment) {
  await cloud.stopEnvironment(environment);
  await refreshCloudEnvironments({ showErrors: true });
  return getDesktopState();
}

async function openEnvironmentInBrowser(environment) {
  await openExternalUrl(await cloud.getEnvironmentLaunchUrl(environment));
  return getDesktopState();
}

function getProjectFolder(environment) {
  return String(environment.name || environment.subdomain || 'workspace').replace(/[^a-zA-Z0-9-]/g, '');
}

function getSshTarget(credentials) {
  if (credentials.ssh_command) {
    const parts = String(credentials.ssh_command).split(/\s+/);
    if (parts.length >= 2) return parts[1];
  }
  return `${credentials.username}@ssh.ddagent`;
}

function getSshHost(credentials) {
  const target = getSshTarget(credentials);
  const atIndex = target.indexOf('@');
  return atIndex >= 0 ? target.slice(atIndex + 1) : 'ssh.ddagent';
}

function getSafeSshUsername(credentials) {
  const username = String(credentials.username || '');
  if (!/^[a-zA-Z0-9._-]+$/.test(username)) {
    throw new Error('Cloud environment returned an invalid SSH username.');
  }
  return username;
}

function getSafeSshHost(credentials) {
  const host = getSshHost(credentials);
  if (!/^[a-zA-Z0-9.-]+$/.test(host)) {
    throw new Error('Cloud environment returned an invalid SSH host.');
  }
  return host;
}

function shellQuote(value) {
  return `'${String(value).replace(/'/g, `'\\''`)}'`;
}

async function getEnvironmentCredentials(environment) {
  const credentials = await cloud.getEnvironmentCredentials(environment);
  if (credentials.password) {
    clipboard.writeText(credentials.password);
  }
  return credentials;
}

async function openEnvironmentInIde(environment, ide) {
  const credentials = await getEnvironmentCredentials(environment);
  const scheme = ide === 'cursor' ? 'cursor' : 'vscode';
  const remoteUri = `${scheme}://vscode-remote/ssh-remote+${getSafeSshUsername(credentials)}@${getSafeSshHost(credentials)}/workspace/${getProjectFolder(environment)}?windowId=_blank`;
  await shell.openExternal(remoteUri);
  return getDesktopState();
}

async function openEnvironmentInSsh(environment) {
  const credentials = await getEnvironmentCredentials(environment);
  const remoteCommand = `cd /workspace/${getProjectFolder(environment)} && exec $SHELL -l`;
  const sshCommand = `ssh -t ${shellQuote(getSshTarget(credentials))} ${shellQuote(remoteCommand)}`;

  if (process.platform === 'darwin') {
    const escaped = sshCommand.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
    spawn('osascript', ['-e', `tell application "Terminal" to do script "${escaped}"`], {
      detached: true,
      stdio: 'ignore',
    }).unref();
  } else {
    clipboard.writeText(sshCommand);
    await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
      type: 'info',
      title: 'SSH command copied',
      message: 'The SSH command was copied to the clipboard.',
      detail: sshCommand,
    });
  }

  return getDesktopState();
}

async function copyEnvironmentMobileUrl(environment) {
  const url = cloud.getEnvironmentUrl(environment);
  clipboard.writeText(url);
  await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'info',
    title: 'Environment URL copied',
    message: 'Use this URL from your mobile browser.',
    detail: url,
  });
  return getDesktopState();
}

async function openCloudDashboard() {
  await openExternalUrl(DDAGENT_CONTROL_PLANE_URL);
  return getDesktopState();
}

function getActiveRemoteEnvironment() {
  if (activeTarget?.kind !== 'remote') return null;
  return cloud.findEnvironment(activeTarget.id);
}

async function runActiveEnvironmentAction(action) {
  const environment = getActiveRemoteEnvironment();
  if (!environment) {
    throw new Error('Open a cloud environment first.');
  }

  switch (action) {
    case 'web':
      return openEnvironmentInBrowser(environment);
    case 'vscode':
      return openEnvironmentInIde(environment, 'vscode');
    case 'cursor':
      return openEnvironmentInIde(environment, 'cursor');
    case 'ssh':
      return openEnvironmentInSsh(environment);
    case 'mobile':
      return copyEnvironmentMobileUrl(environment);
    default:
      throw new Error(`Unknown environment action: ${action}`);
  }
}

async function openLocalInDesktop() {
  const existingTab = tabs.getTab('local');
  if (existingTab && localServer.getLocalServerUrl()) {
    await desktopWindow.showTarget(await localServer.getResolvedTarget());
    return getDesktopState();
  }

  const pendingTarget = localServer.getPendingTarget();
  tabs.upsertTarget(pendingTarget);
  setActiveTarget(pendingTarget);
  await desktopWindow.showLocalStartupTarget(pendingTarget, localServer.getStartupLogs());
  desktopWindow.emitDesktopState();

  let target;
  try {
    target = await localServer.getResolvedTarget();
  } catch (error) {
    // Boot failed (missing dist-server, ABI mismatch, locked DB, ...) — drop
    // the dead "Starting..." tab so it can't spin forever and land on the
    // launcher, which renders state.localError + the startup log tail. The
    // rethrow keeps the IPC error (statusbar/auto-continue catch) intact.
    const tabId = tabs.getTabIdForTarget(pendingTarget);
    tabs.remove(tabId);
    desktopWindow?.destroyTabView(tabId);
    await desktopWindow?.showLauncher().catch(() => {});
    throw error;
  }
  await desktopWindow.showTarget(target);
  return getDesktopState();
}

async function openEnvironmentInDesktop(environment) {
  const pendingTarget = getEnvironmentTarget(environment);
  const tabId = tabs.getTabIdForTarget(pendingTarget);
  const hadTab = Boolean(tabs.getTab(tabId));
  const previousTabId = tabs.activeTabId;

  if (!hadTab) {
    await desktopWindow.showTabPlaceholder(
      pendingTarget,
      `${environment.status === 'running' ? 'Opening' : 'Starting'} ${pendingTarget.name}...`,
    );
    tabs.upsertTarget(pendingTarget);
    desktopWindow.emitDesktopState();
  }

  let nextEnvironment = environment;

  if (environment.status !== 'running') {
    const response = await dialog.showMessageBox(desktopWindow?.getMainWindow(), {
      type: 'question',
      buttons: ['Start Environment', 'Cancel'],
      defaultId: 0,
      cancelId: 1,
      title: 'Start environment?',
      message: `${pendingTarget.name} is ${environment.status}.`,
      detail: 'ddagent can start it before opening the remote app.',
    });

    if (response.response !== 0) {
      if (!hadTab) {
        tabs.remove(tabId);
        desktopWindow.destroyTabView(tabId);
        if (previousTabId && previousTabId !== tabId) {
          await desktopWindow.switchDesktopTab(previousTabId);
        } else {
          await desktopWindow.showLauncher();
        }
      }
      return getDesktopState();
    }

    if (hadTab) {
      await desktopWindow.showTabPlaceholder(pendingTarget, `Starting ${pendingTarget.name}...`);
      tabs.upsertTarget(pendingTarget);
      desktopWindow.emitDesktopState();
    }

    nextEnvironment = await cloud.startEnvironmentAndWait(environment, REMOTE_START_TIMEOUT_MS);
  }

  let target = getEnvironmentTarget(nextEnvironment);
  if (!(await hasCloudWebSession(target))) {
    target = await getEnvironmentLaunchTarget(nextEnvironment);
  }

  const usedBootstrap = Boolean(target.loadUrl);
  const finalUrl = await desktopWindow.showTarget(target);
  if (!usedBootstrap && isCloudAuthRedirect(finalUrl)) {
    const bootstrapTarget = await getEnvironmentLaunchTarget(nextEnvironment);
    bootstrapTarget.forceLoad = true;
    await desktopWindow.showTarget(bootstrapTarget);
  }
  // The freshly loaded view may hold an auth token the notification socket
  // can now use — reconcile targets against the open tabs.
  syncDesktopNotifications();
  return getDesktopState();
}

// Opens a saved (or freshly checked) remote server in a desktop tab. The
// BrowserView partition is derived from the target URL inside viewHost, so
// each server keeps its own persistent session storage.
async function openRemoteServerInDesktop(payload) {
  const url = normalizeServerUrl(typeof payload === 'string' ? payload : payload?.url);
  const id = typeof payload?.id === 'string' && payload.id ? payload.id : undefined;
  if (id) {
    // Keep lastUsedAt fresh on every connect path, not just launcher clicks.
    await remoteServers.touch(id).catch(() => null);
  }
  const target = {
    kind: 'remote',
    id,
    name: String(payload?.name || '').trim() || new URL(url).hostname,
    url,
  };
  // First connect shows a "Connecting" placeholder instead of a blank white
  // BrowserView while the remote app loads. Reconnects skip it so an
  // already-loaded tab is not reloaded just to flash the splash.
  const tabId = tabs.getTabIdForTarget(target);
  const isNewTab = !tabs.getTab(tabId);
  if (isNewTab) {
    await desktopWindow.showTabPlaceholder(target, `Connecting to ${target.name}...`);
  }
  try {
    await desktopWindow.showTarget(target);
  } catch (error) {
    if (isNewTab) {
      // Drop the placeholder tab so a failed load cannot leave it covering
      // the launcher — same cleanup as the local boot-failure path.
      tabs.remove(tabId);
      desktopWindow.destroyTabView(tabId);
      await desktopWindow.showLauncher().catch(() => {});
    }
    throw error;
  }
  if (id) offlineRemoteServerIds.delete(id);
  // Subscribe to this server's /desktop-notifications stream (6.8): the tab's
  // partition localStorage is the auth-token source, so the socket can only
  // be attempted once the view exists.
  syncDesktopNotifications();
  return getDesktopState();
}

// Disconnect leaves the current target and lands back on the launcher.
// Remote: the tab and its BrowserView are destroyed — webContents.destroy()
// runs the wsRouter 'destroyed' sweep, terminating the target's connIds —
// while the persist:remote-* partition survives so the next connect keeps
// the login. Local: the embedded backend keeps running and the 'local'
// tab/view stay alive, so returning to it reuses the live session.
async function disconnectActiveTarget() {
  if (activeTarget?.kind === 'remote' && desktopWindow) {
    const tabId = tabs.getTabIdForTarget(activeTarget);
    tabs.remove(tabId);
    desktopWindow.destroyTabView(tabId);
  }
  await desktopWindow?.showLauncher();
  // Dropped the remote tab → drop its notification socket too (6.7 hook).
  syncDesktopNotifications();
  return getDesktopState();
}

// Auto-continue (task 7.3): after the window is up on the launcher, re-enter
// the last connected target instead of making the user pick again.
// - remoteServers entry: 3s /health probe first — unreachable stays on the
//   launcher with the server flagged offline, so a dead server can't hang boot.
// - cloud environment: its own open path (start-if-stopped + auth bootstrap).
// - local: the regular openLocalInDesktop flow (bounded by its own startup
//   timeout; a failure drops back to the launcher).
// Escape hatches: DDAGENT_DESKTOP_NO_AUTOCONTINUE=1, or the autoContinue
// desktop setting (Desktop Settings sheet).
async function autoContinueLastTarget() {
  if (process.env.DDAGENT_DESKTOP_NO_AUTOCONTINUE === '1') return;
  if (!localServer.getSettings().autoContinue) return;
  const lastTarget = localServer.getLastTarget();
  if (!lastTarget) return;

  try {
    if (lastTarget.kind === 'local') {
      await openLocalInDesktop();
      return;
    }
    if (lastTarget.kind !== 'remote' || !lastTarget.url) return;

    const environment = lastTarget.serverId ? cloud.findEnvironment(lastTarget.serverId) : null;
    if (environment) {
      await openEnvironmentInDesktop(environment);
      return;
    }

    // Prefer the stored entry (fresh url/name) when the id still resolves.
    const entry = lastTarget.serverId
      ? (await remoteServers.list()).find((server) => server.id === lastTarget.serverId)
      : null;
    const url = entry?.url || lastTarget.url;
    // The probe can take up to AUTOCONTINUE_HEALTH_TIMEOUT_MS — tell the
    // launcher what it is waiting on instead of sitting inert.
    autoContinueStatus = `Connecting to ${entry?.name || lastTarget.name || url}...`;
    desktopWindow?.emitDesktopState();
    const health = await checkRemoteServer(url, { timeoutMs: AUTOCONTINUE_HEALTH_TIMEOUT_MS });
    autoContinueStatus = null;
    // A remembered self-signed cert can't be replayed through Node fetch, so
    // a tls-error on a fingerprint-trusted server still connects — Chromium's
    // certificate-error handler adjudicates the stored trust instead.
    if (health.ok || (health.reason === 'tls-error' && entry?.trustedCertFingerprint)) {
      await openRemoteServerInDesktop({ id: entry?.id || lastTarget.serverId, url, name: entry?.name || lastTarget.name });
      return;
    }

    if (entry) offlineRemoteServerIds.add(entry.id);
    console.warn(`[AutoContinue] ${url} unreachable (${health.reason}) — staying on launcher`);
    // Push the cleared status + fresh offlineServerIds — the boot-time
    // remote-servers-list call raced the probe and would show the row stale.
    desktopWindow?.emitDesktopState();
  } catch (error) {
    autoContinueStatus = null;
    console.error('[AutoContinue] failed:', error?.message || error);
    await desktopWindow?.showLauncher().catch(() => {});
  }
}

// Remote servers are commonly self-hosted with self-signed certs, which
// Chromium rejects by default. Policy: never trust silently without an
// explicit user choice; "always" is remembered per server via the stored cert
// fingerprint. Anything that isn't a remote-partition view or a saved remote
// server origin is rejected — no blanket trust for arbitrary navigations.
function getTlsUrlOrigin(url) {
  try {
    const parsed = new URL(url);
    // URL.origin keeps the wss: scheme; normalize so wss cert errors match the
    // server's https:// origin.
    if (parsed.protocol === 'wss:') return `https://${parsed.host}`;
    if (parsed.protocol !== 'https:') return null;
    return parsed.origin === 'null' ? null : parsed.origin;
  } catch {
    return null;
  }
}

function isRemoteViewWebContents(webContents) {
  const tabViews = desktopWindow?.viewHost?.tabViews;
  if (!tabViews) return false;
  for (const view of tabViews.values()) {
    if (view?.webContents === webContents) {
      return typeof view.__ddagentPartition === 'string' && view.__ddagentPartition.startsWith('persist:remote-');
    }
  }
  return false;
}

async function findRemoteServerByOrigin(origin) {
  if (!remoteServers || !origin) return null;
  const servers = await remoteServers.list();
  return servers.find((server) => getTlsUrlOrigin(server.url) === origin) || null;
}

async function promptCertificateTrust(origin, error, certificate, certChanged) {
  const host = new URL(origin).host;
  const fingerprint = String(certificate?.fingerprint || 'unknown');
  const detail = [
    `TLS error: ${error}`,
    `Certificate fingerprint: ${fingerprint}`,
  ];
  if (certChanged) {
    detail.push('The certificate differs from the one previously trusted for this server.');
  }
  detail.push('"Trust Once" applies to this session only. "Trust Always" remembers the fingerprint for this server.');

  const { response } = await dialog.showMessageBox(desktopWindow?.getMainWindow() || undefined, {
    type: 'warning',
    buttons: ['Trust Once', 'Trust Always', 'Cancel'],
    defaultId: 2,
    cancelId: 2,
    noLink: true,
    title: 'Untrusted certificate',
    message: `The certificate for ${host} is not trusted (self-signed?). Trust it?`,
    detail: detail.join('\n'),
  });
  if (response === 0) return 'once';
  if (response === 1) return 'always';
  return 'cancel';
}

async function persistTrustedCertFingerprint(origin, server, fingerprint) {
  try {
    // Remote views without a store entry (e.g. opened via notification) get one
    // so the remembered trust is durable and revocable with the server entry.
    const entry = server || await remoteServers.add({ url: origin });
    await remoteServers.update(entry.id, { trustedCertFingerprint: fingerprint });
  } catch (persistError) {
    console.error('[Cert] Could not persist trusted certificate:', persistError?.message || persistError);
  }
}

async function resolveCertificateTrust(webContents, url, error, certificate) {
  const origin = getTlsUrlOrigin(url);
  if (!origin || !remoteServers) return false;

  const server = await findRemoteServerByOrigin(origin);
  if (!server && !isRemoteViewWebContents(webContents)) return false;

  const fingerprint = String(certificate?.fingerprint || '');
  if (fingerprint && server?.trustedCertFingerprint === fingerprint) return true;

  let decisionPromise = pendingCertDecisions.get(origin);
  let ownsDecision = false;
  if (!decisionPromise) {
    ownsDecision = true;
    decisionPromise = promptCertificateTrust(origin, error, certificate, Boolean(server?.trustedCertFingerprint))
      .finally(() => {
        if (pendingCertDecisions.get(origin) === decisionPromise) {
          pendingCertDecisions.delete(origin);
        }
      });
    pendingCertDecisions.set(origin, decisionPromise);
  }
  const decision = await decisionPromise;
  if (ownsDecision && decision === 'always' && fingerprint) {
    await persistTrustedCertFingerprint(origin, server, fingerprint);
  }
  return decision === 'once' || decision === 'always';
}

function findEnvironmentByUrl(environmentUrl) {
  const targetOrigin = (() => {
    try {
      return new URL(environmentUrl).origin;
    } catch {
      return null;
    }
  })();
  if (!targetOrigin) return null;

  return cloud.getEnvironments().find((environment) => {
    try {
      return new URL(cloud.getEnvironmentUrl(environment)).origin === targetOrigin;
    } catch {
      return false;
    }
  }) || null;
}

async function openNotificationTarget({ environmentUrl, sessionId = null }) {
  const window = desktopWindow?.getMainWindow();
  if (window) {
    if (window.isMinimized()) window.restore();
    window.show();
    window.focus();
  }

  const environment = findEnvironmentByUrl(environmentUrl);
  if (environment) {
    await openEnvironmentInDesktop(environment);
  } else {
    const parsed = new URL(environmentUrl);
    await desktopWindow.showTarget({
      kind: 'remote',
      name: parsed.hostname,
      url: parsed.origin,
    });
  }

  const targetUrl = new URL(sessionId ? `/session/${encodeURIComponent(sessionId)}` : '/', environmentUrl).toString();
  await desktopWindow.navigateActiveView(targetUrl);
  // A remote target opened from a notification click becomes subscribable too.
  syncDesktopNotifications();
  return getDesktopState();
}

async function getEnvironmentAuthToken(environmentUrl) {
  return (await desktopWindow?.readAuthTokenForTarget(environmentUrl)) || null;
}

async function clearCloudAccount() {
  await cloud.clearCloudAccount();
  desktopNotifications?.stop();
  const removedTabs = tabs.removeByKind('remote');
  for (const tab of removedTabs) {
    desktopWindow?.destroyTabView(tab.id);
  }
  if (activeTarget?.kind === 'remote') {
    await desktopWindow?.showLauncher();
  } else {
    syncDesktopState();
  }
  return getDesktopState();
}

function getRemoteEnvironmentMenuItems() {
  const cloudAccount = cloud.getAccount();
  const environments = cloud.getEnvironments();

  if (!cloudAccount?.apiKey) {
    return [{ label: 'Connect ddagent Account...', click: () => void connectCloudAccount() }];
  }

  if (!environments.length) {
    return [{ label: 'No environments found', enabled: false }];
  }

  return environments.map((environment) => ({
    label: `${environment.name || environment.subdomain}${environment.status === 'running' ? '' : ` (${environment.status})`}`,
    click: () => void openEnvironmentInDesktop(environment)
      .catch((error) => showError('Could not open environment', error)),
  }));
}

function registerProtocolHandler() {
  const appEntry = path.join(getAppRoot(), 'electron', 'main.js');
  if (process.defaultApp && process.argv.length >= 2) {
    app.setAsDefaultProtocolClient(CALLBACK_PROTOCOL, process.execPath, [appEntry]);
  } else {
    app.setAsDefaultProtocolClient(CALLBACK_PROTOCOL);
  }
}

function registerIpcHandlers() {
  ipcMain.handle('ddagent-desktop:connect-cloud', async () => ({
    ...getDesktopState(),
    connectUrl: await connectCloudAccount(),
  }));

  ipcMain.handle('ddagent-desktop:copy-diagnostics', async () => {
    await copyDiagnostics();
    return getDesktopState();
  });

  ipcMain.handle('ddagent-desktop:copy-local-web-url', async () => copyLocalWebUrl());
  ipcMain.handle('ddagent-desktop:get-state', () => getDesktopState());
  ipcMain.handle('ddagent-desktop:api', async (_event, payload) => {
    if (
      !payload ||
      typeof payload.method !== 'string' ||
      typeof payload.path !== 'string' ||
      !payload.path.startsWith('/')
    ) {
      return { status: 400, headers: {}, body: { error: 'invalid api request' } };
    }
    return dispatchApiRequest(payload);
  });
  // WS-over-IPC bridge for DesktopWebSocket (preload desktopApi.ws). The
  // router owns per-connection state and cleans up when event.sender's
  // webContents is destroyed.
  ipcMain.handle('ddagent-desktop:ws-connect', (event, url, protocols) => {
    if (typeof url !== 'string' || !/^wss?:/i.test(url)) {
      throw new Error('Invalid WebSocket URL');
    }
    return wsRouter.connect(event.sender, url, protocols);
  });
  ipcMain.handle('ddagent-desktop:ws-send', (_event, connId, data) => wsRouter.send(connId, data));
  ipcMain.handle('ddagent-desktop:ws-close', (_event, connId, code, reason) => wsRouter.close(connId, code, reason));
  ipcMain.handle('ddagent-desktop:open-cloud-dashboard', async () => openCloudDashboard());
  ipcMain.handle('ddagent-desktop:open-external', async (_event, url) => {
    if (typeof url !== 'string' || !/^https?:/i.test(url)) {
      throw new Error('Invalid URL');
    }
    await openExternalUrl(url);
    return true;
  });
  ipcMain.handle('ddagent-desktop:run-active-environment-action', async (_event, action) => runActiveEnvironmentAction(action));
  ipcMain.handle('ddagent-desktop:open-environment', async (_event, environmentId) => {
    const environment = cloud.findEnvironment(environmentId);
    if (!environment) {
      throw new Error('Environment not found. Refresh and try again.');
    }
    return openEnvironmentInDesktop(environment);
  });
  ipcMain.handle('ddagent-desktop:open-local', async () => openLocalInDesktop());
  ipcMain.handle('ddagent-desktop:open-local-web-ui', async () => openLocalWebUi());
  ipcMain.handle('ddagent-desktop:refresh-environments', async () => {
    await refreshCloudEnvironments({ showErrors: true });
    return getDesktopState();
  });
  ipcMain.handle('ddagent-desktop:disconnect-cloud', async () => clearCloudAccount());
  ipcMain.handle('ddagent-desktop:reload-active-tab', async () => desktopWindow.reloadActiveTab());
  ipcMain.handle('ddagent-desktop:check-for-updates', async () => checkForUpdates());
  ipcMain.handle('ddagent-desktop:show-environment-picker', async () => showEnvironmentPicker());
  ipcMain.handle('ddagent-desktop:show-launcher', async () => {
    await desktopWindow.showLauncher();
    return getDesktopState();
  });
  ipcMain.handle('ddagent-desktop:disconnect', async () => disconnectActiveTarget());
  ipcMain.handle('ddagent-desktop:capture-active-view', async () => desktopWindow.captureActiveViewPng());
  ipcMain.handle('ddagent-desktop:update-desktop-notifications', async (_event, settings) => {
    await desktopNotifications?.saveSettings(settings);
    return getDesktopState();
  });
  ipcMain.handle('ddagent-desktop:show-desktop-settings', async () => desktopWindow.showDesktopSettings());
  ipcMain.handle('ddagent-desktop:show-local-settings', async () => desktopWindow.showLocalSettings());
  ipcMain.handle('ddagent-desktop:close-settings-window', async () => {
    desktopWindow.closeSettingsWindow();
    return getDesktopState();
  });
  ipcMain.handle('ddagent-desktop:show-active-environment-actions-menu', async () => desktopWindow.showActiveEnvironmentActionsMenu());
  ipcMain.handle('ddagent-desktop:show-environment-actions-menu', async (_event, environmentId) => desktopWindow.showEnvironmentActionsMenu(environmentId));
  ipcMain.handle('ddagent-desktop:switch-tab', async (_event, tabId) => desktopWindow.switchDesktopTab(tabId));
  ipcMain.handle('ddagent-desktop:close-tab', async (_event, tabId) => {
    const state = await desktopWindow.closeDesktopTab(tabId);
    syncDesktopNotifications();
    return state;
  });
  ipcMain.handle('ddagent-desktop:update-setting', async (_event, key, value) => updateDesktopSetting(key, value));
  ipcMain.handle('ddagent-desktop:remote-servers-list', async () => {
    const servers = await remoteServers.list();
    if (!offlineRemoteServerIds.size) return servers;
    return servers.map((server) => ({ ...server, offline: offlineRemoteServerIds.has(server.id) }));
  });
  ipcMain.handle('ddagent-desktop:remote-servers-add', async (_event, payload) => remoteServers.add(payload));
  ipcMain.handle('ddagent-desktop:remote-servers-update', async (_event, id, fields) => remoteServers.update(id, fields));
  ipcMain.handle('ddagent-desktop:remote-servers-remove', async (_event, id) => remoteServers.remove(id));
  ipcMain.handle('ddagent-desktop:remote-servers-check', async (_event, url) => checkRemoteServer(url));
  ipcMain.handle('ddagent-desktop:remote-servers-touch', async (_event, id) => remoteServers.touch(id));
  ipcMain.handle('ddagent-desktop:open-remote-url', async (_event, payload) => openRemoteServerInDesktop(payload));
}

function registerAppEvents() {
  app.on('open-url', (event, url) => {
    event.preventDefault();
    void handleDeepLink(url);
  });

  // Self-signed certs on remote servers would otherwise hit a Chromium
  // interstitial/fail. preventDefault makes our callback the only policy:
  // resolveCertificateTrust returns true only on stored-fingerprint match or
  // an explicit Trust choice in the dialog; everything else is rejected.
  app.on('certificate-error', (event, webContents, url, error, certificate, callback) => {
    event.preventDefault();
    resolveCertificateTrust(webContents, url, error, certificate)
      .then((trusted) => callback(Boolean(trusted)))
      .catch(() => callback(false));
  });

  // Voice input needs getUserMedia — Chromium's default permission handler
  // denies mic in Electron. Grant the capabilities the ddagent UI actually
  // uses on every session (default + per-server remote partitions).
  const ALLOWED_PERMISSIONS = new Set([
    'media',
    'notifications',
    'clipboard-read',
    'clipboard-sanitized-write',
  ]);
  const grantAppPermissions = (ses) => {
    ses.setPermissionRequestHandler((_webContents, permission, callback) => {
      callback(ALLOWED_PERMISSIONS.has(permission));
    });
  };
  app.on('session-created', grantAppPermissions);
  grantAppPermissions(session.defaultSession);

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) {
      if (desktopWindow) {
        void desktopWindow.createWindow();
      } else {
        void createDesktopWindow();
      }
      return;
    }

    const window = desktopWindow?.getMainWindow();
    if (window) {
      window.show();
      window.focus();
    }
  });

  app.on('before-quit', () => {
    desktopNotifications?.stop();
  });

  app.on('before-quit', (event) => {
    if (isQuitting) return;

    const shutdownTasks = [];
    if (localServer?.hasOwnedServer()) {
      if (localServer.getSettings().keepLocalServerRunning) {
        localServer.detachOwnedServer();
      } else {
        shutdownTasks.push(() => localServer.shutdownOwnedServer());
      }
    }
    if (embeddedBackendShutdown) {
      shutdownTasks.push(() => embeddedBackendShutdown());
    }
    if (shutdownTasks.length === 0) return;

    event.preventDefault();
    isQuitting = true;
    void Promise.allSettled(shutdownTasks.map((task) => task())).finally(() => app.quit());
  });

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') {
      app.quit();
    }
  });
}

async function createDesktopWindow() {
  desktopWindow = new DesktopWindowManager({
    appName: APP_NAME,
    userDataDir: app.getPath('userData'),
    getWindowIconPath,
    getLauncherPath,
    getPreloadPath,
    openExternalUrl,
    getDesktopState,
    getDisplayTargetName,
    getRemoteEnvironmentMenuItems,
    getCloudState,
    getLocalState,
    tabs,
    actions: {
      checkForUpdates,
      copyDiagnostics,
      copyText: (text) => clipboard.writeText(text),
      clearCloudAccount,
      connectCloudAccount,
      disconnect: disconnectActiveTarget,
      getActiveTarget: () => activeTarget,
      getEnvironmentUrl: (environment) => cloud.getEnvironmentUrl(environment),
      openEnvironmentInBrowser,
      openEnvironmentInDesktop,
      openEnvironmentInIde,
      openEnvironmentInSsh,
      openLocalInDesktop,
      openLocalWebUi,
      openCloudDashboard,
      refreshCloudEnvironments: () => refreshCloudEnvironments({ showErrors: true }),
      setActiveTarget,
      showEnvironmentPicker,
      showError,
      startEnvironment,
      stopEnvironment,
      updateDesktopSetting,
      copyLocalWebUrl,
      openNotificationTarget,
    },
  });

  desktopWindow.createTray();
  desktopWindow.configurePermissions();
  await desktopWindow.createWindow();
}

function registerSingleInstance() {
  const gotSingleInstanceLock = app.requestSingleInstanceLock();
  if (!gotSingleInstanceLock) {
    app.quit();
    return false;
  }

  app.on('second-instance', (_event, argv) => {
    const deepLink = argv.find((arg) => arg.startsWith(`${CALLBACK_PROTOCOL}://`));
    if (deepLink) {
      void handleDeepLink(deepLink);
    }

    const window = desktopWindow?.getMainWindow();
    if (window) {
      if (window.isMinimized()) window.restore();
      window.show();
      window.focus();
    }
  });

  return true;
}

async function bootstrap() {
  app.name = APP_NAME;
  app.setName(APP_NAME);
  process.title = APP_NAME;

  await app.whenReady();
  protocol.handle(APP_SCHEME, createDistProtocolHandler({
    distDir: path.join(getAppRoot(), 'dist'),
    apiDispatch: (request) => dispatchApiRequest(request),
  }));
  app.setName(APP_NAME);
  app.setAboutPanelOptions({
    applicationName: APP_NAME,
    applicationVersion: app.getVersion(),
    copyright: 'ddagent',
  });

  localServer = new LocalServerController({
    appRoot: getAppRoot(),
    settingsPath: getSettingsPath(),
    isPackaged: app.isPackaged,
    appVersion: app.getVersion(),
    onChange: syncDesktopState,
    startInProcessBackend: () => ensureEmbeddedBackend(),
  });
  cloud = new CloudController({
    storePath: getStorePath(),
    controlPlaneUrl: DDAGENT_CONTROL_PLANE_URL,
    callbackUrl: CALLBACK_URL,
    onChange: syncDesktopState,
  });
  desktopNotifications = new DesktopNotificationsController({
    settingsPath: getDesktopNotificationsSettingsPath(),
    appVersion: app.getVersion(),
    appName: APP_NAME,
    getDeviceId: () => cloud.getAccount()?.deviceId || '',
    getAccountEmail: () => cloud.getAccount()?.email || null,
    getRunningEnvironmentUrls,
    getRemoteServerUrls: getRemoteServerNotificationUrls,
    getTrustedCertFingerprint: async (httpUrl) => {
      const server = await findRemoteServerByOrigin(getTlsUrlOrigin(httpUrl));
      return server?.trustedCertFingerprint || null;
    },
    requestJsonOnTarget: (httpUrl, requestUrl, options) =>
      desktopWindow?.requestJsonOnTargetView(httpUrl, requestUrl, options),
    getApiKey: () => cloud.getAccount()?.apiKey || '',
    getAuthToken: getEnvironmentAuthToken,
    getIconPath: getWindowIconPath,
    openNotificationTarget,
    onChange: syncDesktopState,
  });
  remoteServers = new RemoteServersStore({ storePath: getRemoteServersPath() });

  await localServer.loadDesktopSettings();
  await cloud.loadCloudAccount();
  await desktopNotifications.loadSettings();

  registerProtocolHandler();
  registerIpcHandlers();
  registerAppEvents();
  await createDesktopWindow();
  // Launcher is already on screen — auto-continue swaps to the last target
  // when there is one, and quietly does nothing otherwise.
  void autoContinueLastTarget();
  void refreshCloudEnvironments({ showErrors: false });
  // Fire-and-forget: a slow/unreachable update feed must never gate startup.
  void initAutoUpdater();
}

if (registerSingleInstance()) {
  bootstrap().catch(async (error) => {
    await showError('ddagent failed to start', error);
    app.quit();
  });
}

import { BrowserView } from 'electron';

import { APP_SCHEME } from './appScheme.js';

const TARGET_LOAD_TIMEOUT_MS = 20000;
const LOADABLE_TARGET_PROTOCOLS = new Set(['http:', 'https:', `${APP_SCHEME}:`]);

function escapeHtml(value) {
  return String(value == null ? '' : value)
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;');
}

function buildPlaceholderHtml(title, message, logs = []) {
  const logHtml = logs.length
    ? `<pre>${logs.map(escapeHtml).join('\n')}</pre>`
    : '<pre>Waiting for process output...</pre>';
  return [
    '<!doctype html><meta charset="utf-8">',
    '<style>',
    'html,body{margin:0;height:100%;background:#0a0a0a;color:#fafafa;font:14px -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif}',
    'body{padding:28px;overflow:hidden}',
    '.shell{height:100%;display:flex;flex-direction:column;gap:16px}',
    '.box{display:flex;align-items:center;gap:10px;color:#d4d4d4;flex:0 0 auto}',
    '.dot{width:8px;height:8px;border-radius:50%;background:#0b60ea;box-shadow:0 0 0 6px rgba(11,96,234,.15)}',
    'pre{margin:0;flex:1;overflow:auto;border:1px solid #262626;border-radius:10px;background:#050505;color:#d4d4d4;padding:14px;font:12px/1.55 ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace;white-space:pre-wrap;user-select:text}',
    '</style>',
    '<div class="shell">',
    `<div class="box"><span class="dot"></span><span>${escapeHtml(message || `Opening ${title}...`)}</span></div>`,
    logHtml,
    '</div>',
  ].join('');
}

function isLoadableUrl(url) {
  try {
    return LOADABLE_TARGET_PROTOCOLS.has(new URL(url).protocol);
  } catch {
    return false;
  }
}

// Remote targets get a persistent per-server partition so login/localStorage
// survives app restarts and two servers never share storage. The slug derives
// from the normalized origin, so the same server always maps to the same
// partition. Local/launcher targets return null and keep the default session.
export function getRemoteTargetPartition(target) {
  if (target?.kind !== 'remote') return null;
  try {
    const parsed = new URL(target.url || target.loadUrl || '');
    if (parsed.protocol !== 'http:' && parsed.protocol !== 'https:') return null;
    const slug = parsed.origin.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-+|-+$/g, '');
    return slug ? `persist:remote-${slug}` : null;
  } catch {
    return null;
  }
}

// Origins a remote view is allowed to navigate to. The server URL is the
// canonical origin; the cloud launch URL (loadUrl) may sit on a different
// origin while bootstrapping the session, so it is allowed too. Returns null
// for local/launcher targets — those views keep the default link handling.
function getRemoteTargetOrigins(target) {
  if (target?.kind !== 'remote') return null;
  const origins = new Set();
  for (const candidate of [target.url, target.loadUrl]) {
    try {
      const parsed = new URL(candidate || '');
      if (parsed.protocol === 'http:' || parsed.protocol === 'https:') {
        origins.add(parsed.origin);
      }
    } catch {
      // Missing or non-URL candidates carry no origin.
    }
  }
  return origins.size ? origins : null;
}

async function loadUrlWithTimeout(webContents, url, timeoutMs = TARGET_LOAD_TIMEOUT_MS) {
  let timedOut = false;
  let timeout = null;
  const loadPromise = webContents.loadURL(url);
  const timeoutPromise = new Promise((_, reject) => {
    timeout = setTimeout(() => {
      timedOut = true;
      try {
        webContents.stop();
      } catch {
        // Ignore teardown races while reporting the original timeout.
      }
      reject(new Error(`Timed out loading ${url} after ${Math.round(timeoutMs / 1000)} seconds.`));
    }, timeoutMs);
  });

  try {
    await Promise.race([loadPromise, timeoutPromise]);
  } catch (error) {
    if (timedOut) {
      loadPromise.catch(() => {});
    }
    throw error;
  } finally {
    if (timeout) clearTimeout(timeout);
  }
}

export class ViewHost {
  constructor({ appName, getMainWindow, getContentViewBounds, getPreloadPath, openExternalUrl, showError }) {
    this.appName = appName;
    this.getMainWindow = getMainWindow;
    this.getContentViewBounds = getContentViewBounds;
    this.getPreloadPath = getPreloadPath;
    this.openExternalUrl = openExternalUrl;
    this.showError = showError;
    this.activeContentView = null;
    this.tabViews = new Map();
  }

  configureChildWebContents(webContents, remoteOrigins = null) {
    const isRemoteAllowedUrl = (url) => {
      try {
        return remoteOrigins?.has(new URL(url).origin) === true;
      } catch {
        return false;
      }
    };

    webContents.setWindowOpenHandler(({ url }) => {
      if (isRemoteAllowedUrl(url)) {
        return { action: 'allow' };
      }
      // Same-scheme window.open stays inside the app — the OS has no external
      // handler for ddagent-app:// URLs.
      if (typeof url === 'string' && url.startsWith(`${APP_SCHEME}:`)) {
        void webContents.loadURL(url).catch(() => {});
        return { action: 'deny' };
      }
      void this.openExternalUrl(url).catch((error) => this.showError('Could not open external link', error));
      return { action: 'deny' };
    });

    if (!remoteOrigins) return;

    // A remote view is pinned to its server's origin: in-page navigation that
    // would leave it is rerouted to the system browser so an external link
    // can never replace the app inside the tab. will-redirect covers the
    // server-side redirect hop escaping the origin after an allowed start.
    const guardRemoteNavigation = (event, url) => {
      if (isRemoteAllowedUrl(url)) return;
      event.preventDefault();
      void this.openExternalUrl(url).catch((error) => this.showError('Could not open external link', error));
    };
    webContents.on('will-navigate', guardRemoteNavigation);
    webContents.on('will-redirect', guardRemoteNavigation);
  }

  detachAll() {
    const mainWindow = this.getMainWindow();
    if (!mainWindow || mainWindow.isDestroyed()) return;
    try {
      for (const view of mainWindow.getBrowserViews()) {
        mainWindow.removeBrowserView(view);
      }
    } catch {
      // BrowserViews may already be gone during BrowserWindow teardown.
    }
    this.activeContentView = null;
  }

  detachActiveView() {
    const mainWindow = this.getMainWindow();
    const view = this.activeContentView;
    if (!mainWindow || mainWindow.isDestroyed() || !view) return false;
    try {
      if (mainWindow.getBrowserViews().includes(view)) {
        mainWindow.removeBrowserView(view);
      }
    } catch {
      return false;
    }
    this.activeContentView = null;
    return true;
  }

  getActiveView() {
    const view = this.activeContentView;
    if (!view || view.webContents.isDestroyed()) return null;
    return view;
  }

  openActiveViewDevTools() {
    const view = this.getActiveView();
    if (!view) return false;
    view.webContents.openDevTools({ mode: 'detach' });
    return true;
  }

  reloadActiveView() {
    const view = this.getActiveView();
    if (!view) return false;
    view.webContents.reloadIgnoringCache();
    return true;
  }

  async readLocalStorageValueForOrigin(originUrl, key) {
    let targetOrigin;
    try {
      targetOrigin = new URL(originUrl).origin;
    } catch {
      return null;
    }

    for (const view of this.tabViews.values()) {
      if (!view || view.webContents.isDestroyed()) continue;
      let viewOrigin;
      try {
        viewOrigin = new URL(view.webContents.getURL()).origin;
      } catch {
        continue;
      }
      if (viewOrigin !== targetOrigin) continue;

      try {
        const value = await view.webContents.executeJavaScript(
          `window.localStorage.getItem(${JSON.stringify(key)})`,
          true
        );
        return typeof value === 'string' && value ? value : null;
      } catch {
        return null;
      }
    }

    return null;
  }

  getTabViewDiagnostics() {
    const mainWindow = this.getMainWindow();
    const attachedViews = new Set();
    if (mainWindow && !mainWindow.isDestroyed()) {
      try {
        for (const view of mainWindow.getBrowserViews()) {
          attachedViews.add(view);
        }
      } catch {
        // Ignore teardown races while gathering best-effort diagnostics.
      }
    }

    return Array.from(this.tabViews.entries()).map(([tabId, view]) => {
      const { webContents } = view;
      const destroyed = webContents.isDestroyed();
      return {
        tabId,
        webContentsId: destroyed ? null : webContents.id,
        url: destroyed ? null : webContents.getURL(),
        title: destroyed ? null : webContents.getTitle(),
        osProcessId: destroyed || typeof webContents.getOSProcessId !== 'function' ? null : webContents.getOSProcessId(),
        processId: destroyed || typeof webContents.getProcessId !== 'function' ? null : webContents.getProcessId(),
        attached: attachedViews.has(view),
        active: this.activeContentView === view,
        destroyed,
      };
    });
  }

  getOrCreateTabView(tabId, target = null) {
    const partition = getRemoteTargetPartition(target);
    let view = this.tabViews.get(tabId);
    if (view && view.__ddagentPartition === partition) return view;

    // The partition is fixed at webContents creation, so a tab retargeted at a
    // different server (id-less remote targets share the 'remote' tab) must be
    // rebuilt to move it into the right session.
    if (view) this.destroyTabView(tabId);

    view = new BrowserView({
      webPreferences: {
        contextIsolation: true,
        nodeIntegration: false,
        sandbox: true,
        preload: this.getPreloadPath(),
        ...(partition ? { partition } : {}),
      },
    });
    view.__ddagentPartition = partition;
    this.configureChildWebContents(view.webContents, partition ? getRemoteTargetOrigins(target) : null);
    this.tabViews.set(tabId, view);
    return view;
  }

  attach(view) {
    const mainWindow = this.getMainWindow();
    if (!mainWindow || mainWindow.isDestroyed()) return;
    if (this.activeContentView && this.activeContentView !== view) {
      this.detachAll();
    }
    this.activeContentView = view;
    try {
      if (!mainWindow.getBrowserViews().includes(view)) {
        mainWindow.addBrowserView(view);
      }
    } catch {
      return;
    }
    view.setBounds(this.getContentViewBounds());
    view.setAutoResize({ width: true, height: true });
  }

  resizeActiveView() {
    if (this.activeContentView) {
      this.activeContentView.setBounds(this.getContentViewBounds());
    }
  }

  async showTabPlaceholder(tabId, target, message) {
    const view = this.getOrCreateTabView(tabId, target);
    this.attach(view);
    const html = buildPlaceholderHtml(target.name || this.appName, message);
    await view.webContents.loadURL(`data:text/html;charset=utf-8,${encodeURIComponent(html)}`);
    view.__ddagentStartupHtml = html;
    view.__ddagentLoadedUrl = null;
  }

  async showLocalStartupTarget(tabId, target, logs) {
    const view = this.getOrCreateTabView(tabId, target);
    if (view.__ddagentLoadingUrl) return;
    this.attach(view);
    const html = buildPlaceholderHtml(target.name || this.appName, 'Starting Local ddagent...', logs);
    if (view.__ddagentStartupHtml === html) return;
    // Mark before the await so a concurrent refresh with identical html skips
    // instead of racing a second loadURL. A superseding load (newer html) or
    // a destroyed view aborts this one with ERR_ABORTED/ERR_FAILED — that is
    // cosmetic and must not bubble up into openLocalInDesktop, where it would
    // abort the backend boot before it even runs.
    view.__ddagentStartupHtml = html;
    try {
      await view.webContents.loadURL(`data:text/html;charset=utf-8,${encodeURIComponent(html)}`);
    } catch (error) {
      console.warn('[ViewHost] startup placeholder load failed:', error?.message || error);
    }
    view.__ddagentLoadedUrl = null;
  }

  async showContentTarget(tabId, target) {
    const loadUrl = target.loadUrl || target.url;
    if (!isLoadableUrl(loadUrl)) {
      throw new Error(`Refusing to load unsupported app URL: ${loadUrl}`);
    }
    const view = this.getOrCreateTabView(tabId, target);
    this.attach(view);
    if (target.forceLoad || view.__ddagentLoadedUrl !== target.url) {
      view.__ddagentLoadingUrl = loadUrl;
      try {
        await loadUrlWithTimeout(view.webContents, loadUrl);
        view.__ddagentLoadedUrl = target.url;
        view.__ddagentStartupHtml = null;
        delete target.loadUrl;
        delete target.forceLoad;
      } finally {
        if (view.__ddagentLoadingUrl === loadUrl) {
          view.__ddagentLoadingUrl = null;
        }
      }
    }
    return view.webContents.getURL();
  }

  reloadTab(tabId) {
    const view = this.tabViews.get(tabId);
    if (!view || view.webContents.isDestroyed()) return false;
    view.webContents.reloadIgnoringCache();
    return true;
  }

  async navigateActiveView(url) {
    const view = this.getActiveView();
    if (!view) return false;
    await loadUrlWithTimeout(view.webContents, url);
    view.__ddagentLoadedUrl = url;
    view.__ddagentStartupHtml = null;
    return true;
  }

  destroyTabView(tabId) {
    const view = this.tabViews.get(tabId);
    if (!view) return;
    const mainWindow = this.getMainWindow();
    if (mainWindow && !mainWindow.isDestroyed()) {
      try {
        if (mainWindow.getBrowserViews().includes(view)) {
          mainWindow.removeBrowserView(view);
        }
      } catch {
        // Ignore teardown races; Electron owns final destruction during quit.
      }
    }
    if (this.activeContentView === view) {
      this.activeContentView = null;
    }
    try {
      if (!view.webContents.isDestroyed()) {
        view.webContents.destroy();
      }
    } catch {
      // The view may already be destroyed by its parent BrowserWindow.
    }
    this.tabViews.delete(tabId);
  }

  clear() {
    this.tabViews.clear();
    this.activeContentView = null;
  }
}

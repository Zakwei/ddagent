window.__APP_VERSION__ = '1.34.0';
window.__MOCK_STATE__ = {
  account: { connected: false, email: null },
  activeTarget: { kind: 'launcher', name: 'Launcher', url: null },
  cloudLoading: false,
  desktopSettings: { keepLocalServerRunning: false, exposeLocalServerOnNetwork: false, themeMode: 'system', autoContinue: true },
  localWebUrl: 'http://localhost:3001',
  shareableWebUrl: 'http://localhost:3001',
  localServerRunning: false,
  localStatus: 'idle',
  localError: null,
  localStartupLogs: [],
  autoContinueStatus: null,
  offlineServerIds: [],
  remoteServers: [
    { id: 'srv-demo', name: 'staging ddagent', url: 'https://ddagent.internal.example', lastUsedAt: '2026-09-21T18:24:00.000Z', createdAt: '2026-09-12T10:00:00.000Z' },
  ],
};

// Local boot phase: idle -> booting -> ready/failed. Derives the phase when
// a state payload lacks localStatus so older/initial renders still work.
// Top-level: used by both the main launcher and the sidebar IIFE below.
function localStatusOf(state) {
  if (state && state.localStatus) return state.localStatus;
  if (state && state.localServerRunning) return 'ready';
  if (state && state.localError) return 'failed';
  return 'idle';
}

(function ddagentLauncher() {
  var MOCK = window.__MOCK_STATE__ || {};
  var VERSION = window.__APP_VERSION__ || '';
  var LOGO_URL = new URL('../../public/logo-32.png', window.location.href).toString();
  var SEARCH = new URLSearchParams(window.location.search || '');

  function clone(value) {
    return JSON.parse(JSON.stringify(value));
  }

  var mockState = clone(MOCK);
  var mockBridge = {
    getState: function () { return Promise.resolve(clone(mockState)); },
    openLocal: function () {
      mockState.localServerRunning = true;
      mockState.localStatus = 'ready';
      mockState.localError = null;
      mockState.activeTarget = { kind: 'local', name: 'Local ddagent', url: mockState.localWebUrl };
      return Promise.resolve(clone(mockState));
    },
    openLocalWebUi: function () {
      mockState.localServerRunning = true;
      mockState.localStatus = 'ready';
      mockState.localError = null;
      return Promise.resolve(clone(mockState));
    },
    copyLocalWebUrl: function () { return Promise.resolve(clone(mockState)); },
    connectCloud: function () {
      mockState.account = { connected: true, email: 'you@ddagent' };
      return Promise.resolve(clone(mockState));
    },
    disconnectCloud: function () {
      mockState.account = { connected: false, email: null };
      mockState.tabs = (mockState.tabs || []).filter(function (tab) { return tab.kind !== 'remote'; });
      mockState.activeTabId = 'home';
      mockState.activeTarget = { kind: 'launcher', name: 'Launcher', url: null };
      return Promise.resolve(clone(mockState));
    },
    disconnect: function () {
      var target = mockState.activeTarget;
      if (target && target.kind === 'remote') {
        var tabId = target.id ? 'remote:' + target.id : 'remote';
        mockState.tabs = (mockState.tabs || []).filter(function (tab) { return tab.id !== tabId; });
      }
      mockState.activeTabId = 'home';
      mockState.activeTarget = { kind: 'launcher', name: 'Launcher', url: null };
      return Promise.resolve(clone(mockState));
    },
    refreshActiveTab: function () { return Promise.resolve(clone(mockState)); },
    copyDiagnostics: function () { return Promise.resolve(clone(mockState)); },
    showLauncher: function () { return Promise.resolve(clone(mockState)); },
    showLocalSettings: function () { return Promise.resolve(clone(mockState)); },
    showDesktopSettings: function () { return Promise.resolve(clone(mockState)); },
    closeSettingsWindow: function () { return Promise.resolve(clone(mockState)); },
    showEnvironmentActionsMenu: function () { return Promise.resolve(clone(mockState)); },
    remoteServers: {
      list: function () { return Promise.resolve(clone(mockState.remoteServers || [])); },
      add: function (payload) {
        var url = String((payload && payload.url) || '').trim();
        var host = url.replace(/^[a-zA-Z][a-zA-Z0-9+.-]*:\/\//, '').split('/')[0];
        var entry = {
          id: 'srv-' + Date.now(),
          name: String((payload && payload.name) || '').trim() || host || 'server',
          url: url,
          lastUsedAt: null,
          createdAt: new Date().toISOString(),
        };
        mockState.remoteServers = (mockState.remoteServers || []).concat([entry]);
        return Promise.resolve(clone(entry));
      },
      update: function () { return Promise.resolve(null); },
      remove: function (id) {
        mockState.remoteServers = (mockState.remoteServers || []).filter(function (server) { return server.id !== id; });
        return Promise.resolve(true);
      },
      check: function (url) {
        var reachable = String(url || '').indexOf('bad') === -1;
        return Promise.resolve(reachable
          ? { ok: true, version: '1.34.0', installMode: 'mock' }
          : { ok: false, reason: 'offline', message: 'Server is unreachable.' });
      },
      touch: function (id) {
        var server = (mockState.remoteServers || []).filter(function (item) { return item.id === id; })[0];
        if (server) server.lastUsedAt = new Date().toISOString();
        return Promise.resolve(clone(server || null));
      },
      open: function (server) {
        var tabId = 'remote:' + server.id;
        var tabs = (mockState.tabs || []).filter(function (tab) { return tab.id !== tabId; });
        tabs.forEach(function (tab) { tab.active = false; });
        tabs.push({ id: tabId, title: server.name || server.url, kind: 'remote', closable: true, active: true });
        mockState.tabs = tabs;
        mockState.activeTabId = tabId;
        mockState.activeTarget = { kind: 'remote', id: server.id, name: server.name || server.url, url: server.url };
        return Promise.resolve(clone(mockState));
      },
    },
    switchTab: function (id) { mockState.activeTabId = id; return Promise.resolve(clone(mockState)); },
    closeTab: function (id) {
      mockState.tabs = (mockState.tabs || []).filter(function (tab) { return tab.id === 'home' || tab.id !== id; });
      if (mockState.activeTabId === id) mockState.activeTabId = 'home';
      return Promise.resolve(clone(mockState));
    },
    updateSetting: function (key, value) {
      mockState.desktopSettings = mockState.desktopSettings || {};
      mockState.desktopSettings[key] = key === 'themeMode' ? value : !!value;
      return Promise.resolve(clone(mockState));
    },
  };

  var bridge = window.ddagentDesktop || mockBridge;

  var ICONS = {
    terminal: '<polyline points="4 17 10 11 4 5"/><line x1="12" y1="19" x2="20" y2="19"/>',
    cloud: '<path d="M17.5 19a4.5 4.5 0 0 0 .5-8.97A6 6 0 0 0 6.34 9 4 4 0 0 0 7 19z"/>',
    refresh: '<polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/>',
    settings: '<line x1="4" y1="21" x2="4" y2="14"/><line x1="4" y1="10" x2="4" y2="3"/><line x1="12" y1="21" x2="12" y2="12"/><line x1="12" y1="8" x2="12" y2="3"/><line x1="20" y1="21" x2="20" y2="16"/><line x1="20" y1="12" x2="20" y2="3"/><line x1="1" y1="14" x2="7" y2="14"/><line x1="9" y1="8" x2="15" y2="8"/><line x1="17" y1="16" x2="23" y2="16"/>',
    gear: '<circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.7 1.7 0 0 0 .34 1.88l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06A1.7 1.7 0 0 0 15 19.4a1.7 1.7 0 0 0-1 .6l-.03.08a2 2 0 1 1-3.94 0L10 20a1.7 1.7 0 0 0-1-.6 1.7 1.7 0 0 0-1.88.34l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06A1.7 1.7 0 0 0 4.6 15a1.7 1.7 0 0 0-.6-1l-.08-.03a2 2 0 1 1 0-3.94L4 10a1.7 1.7 0 0 0 .6-1 1.7 1.7 0 0 0-.34-1.88l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06A1.7 1.7 0 0 0 9 4.6a1.7 1.7 0 0 0 1-.6l.03-.08a2 2 0 1 1 3.94 0L14 4a1.7 1.7 0 0 0 1 .6 1.7 1.7 0 0 0 1.88-.34l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06A1.7 1.7 0 0 0 19.4 9c.2.36.4.7.6 1l.08.03a2 2 0 1 1 0 3.94L20 14a1.7 1.7 0 0 0-.6 1z"/>',
    play: '<polygon points="6 4 20 12 6 20 6 4"/>',
    arrow: '<line x1="7" y1="17" x2="17" y2="7"/><polyline points="8 7 17 7 17 16"/>',
    copy: '<rect x="9" y="9" width="13" height="13" rx="2"/><path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"/>',
    monitor: '<rect x="2" y="3" width="20" height="14" rx="2"/><line x1="8" y1="21" x2="16" y2="21"/><line x1="12" y1="17" x2="12" y2="21"/>',
    phone: '<rect x="7" y="2" width="10" height="20" rx="2"/><line x1="11" y1="18" x2="13" y2="18"/>',
    x: '<line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/>',
    logOut: '<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/>',
  };
  var FILLED = { play: true };

  function icon(name, size) {
    size = size || 16;
    return '<svg width="' + size + '" height="' + size + '" viewBox="0 0 24 24" fill="' + (FILLED[name] ? 'currentColor' : 'none') + '" stroke="' + (FILLED[name] ? 'none' : 'currentColor') + '" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">' + (ICONS[name] || '') + '</svg>';
  }

  function esc(value) {
    return String(value == null ? '' : value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  function connected(state) {
    return !!(state && state.account && state.account.connected);
  }

  function authState(state) {
    return state && state.account ? (state.account.authState || (state.account.connected ? 'connected' : 'logged_out')) : 'logged_out';
  }

  function accountLabel(state) {
    if (authState(state) === 'expired') return 'Reconnect';
    if (state && state.account && state.account.email) return state.account.email;
    if (connected(state)) return 'Connected';
    return 'Log in';
  }

  function localUrl(state) {
    return (state && (state.shareableWebUrl || state.localWebUrl)) || '';
  }

  function serverCount() {
    var count = CC.servers ? CC.servers.length : 0;
    return count + ' server' + (count === 1 ? '' : 's');
  }

  function relTime(iso) {
    var then = iso ? new Date(iso).getTime() : 0;
    if (!then) return 'never used';
    var mins = Math.floor((Date.now() - then) / 60000);
    if (mins < 1) return 'just now';
    if (mins < 60) return mins + 'm ago';
    var hours = Math.floor(mins / 60);
    if (hours < 24) return hours + 'h ago';
    var days = Math.floor(hours / 24);
    if (days < 30) return days + 'd ago';
    return new Date(then).toLocaleDateString();
  }

  function checkErrorText(result) {
    var reason = result && result.reason;
    if (reason === 'tls-error') return 'Certificate problem — the server certificate could not be verified.';
    if (reason === 'not-ddagent') return 'Not a ddagent server.';
    return 'Server unreachable.';
  }

  function errMsg(error) {
    return error && error.message ? error.message : String(error);
  }

  function resolveTheme(state) {
    var settings = state && state.desktopSettings ? state.desktopSettings : {};
    var mode = settings.themeMode || 'system';
    if (mode === 'light' || mode === 'dark') return mode;
    return window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  var CC = {
    icon: icon,
    esc: esc,
    relTime: relTime,
    connected: connected,
    authState: authState,
    accountLabel: accountLabel,
    localUrl: localUrl,
    serverCount: serverCount,
    version: VERSION,
    logoUrl: LOGO_URL,
    platform: 'win',
    state: clone(MOCK),
    servers: clone(MOCK.remoteServers || []),
    ui: {},
    _status: { msg: '', tone: '' },
    _reg: {},
    _wired: false,
    modalMode: SEARCH.get('modal') === '1',
  };

  window.CC = CC;

  var app;
  var overlay;

  CC.setState = function (state) {
    var currentSheet = CC.ui.openSheet || (CC.modalMode ? (CC.ui.initialSheet || 'desktop-settings') : null);
    var sheetBody = overlay ? overlay.querySelector('.cc-sheet-body') : null;
    var scrollTop = sheetBody ? sheetBody.scrollTop : 0;
    if (state && typeof state === 'object') CC.state = state;
    CC.applyTheme(CC.state);
    CC.render(CC.state);
    if (currentSheet) {
      CC.openSheet(currentSheet, { scrollTop: scrollTop });
    }
  };

  CC.applyTheme = function (state) {
    var settings = state && state.desktopSettings ? state.desktopSettings : {};
    var themeMode = settings.themeMode || 'system';
    var resolvedTheme = resolveTheme(state);
    document.documentElement.setAttribute('data-theme', resolvedTheme);
    document.documentElement.setAttribute('data-theme-mode', themeMode);
  };

  CC.refresh = function () {
    return Promise.resolve(bridge.getState()).then(function (state) {
      CC.setState(state);
      return state;
    });
  };

  CC.run = function (label, fn) {
    CC._status = { msg: label, tone: 'progress' };
    CC.render(CC.state);
    return Promise.resolve()
      .then(fn)
      .then(function (state) {
        if (state) CC.state = state;
        return CC.refresh();
      })
      .then(function () {
        CC._status = { msg: '', tone: '' };
        CC.render(CC.state);
      })
      .catch(function (error) {
        CC._status = { msg: errMsg(error), tone: 'error' };
        CC.render(CC.state);
      });
  };

  CC.refreshServers = function () {
    if (!bridge.remoteServers || !bridge.remoteServers.list) return Promise.resolve([]);
    return Promise.resolve(bridge.remoteServers.list()).then(function (servers) {
      CC.servers = servers || [];
      return CC.servers;
    }).catch(function () {
      CC.servers = [];
      return CC.servers;
    });
  };

  CC.checkServer = function () {
    var url = (CC.ui.serverUrl || '').trim();
    if (!bridge.remoteServers || !bridge.remoteServers.check) {
      CC.ui.serverCheck = { ok: false, error: 'Server checks are not available.' };
      CC.render(CC.state);
      return;
    }
    if (!url) {
      CC.ui.serverCheck = { ok: false, error: 'Enter a server URL first.' };
      CC.render(CC.state);
      return;
    }
    CC.ui.serverChecking = true;
    CC.ui.serverCheck = null;
    CC.render(CC.state);
    return Promise.resolve(bridge.remoteServers.check(url)).then(function (result) {
      CC.ui.serverChecking = false;
      CC.ui.serverCheck = result && result.ok
        ? { ok: true, url: url, version: result.version || null }
        : { ok: false, error: checkErrorText(result) };
      CC.render(CC.state);
    }).catch(function () {
      CC.ui.serverChecking = false;
      CC.ui.serverCheck = { ok: false, error: 'Server unreachable.' };
      CC.render(CC.state);
    });
  };

  CC.saveCheckedServer = function (connect) {
    var check = CC.ui.serverCheck;
    if (!check || !check.ok || !check.url) return;
    CC._status = { msg: 'Saving server...', tone: 'progress' };
    CC.render(CC.state);
    return Promise.resolve(bridge.remoteServers.add({ url: check.url }))
      .then(function (entry) {
        if (connect && bridge.remoteServers.touch) {
          return Promise.resolve(bridge.remoteServers.touch(entry.id)).then(function () { return entry; });
        }
        return entry;
      })
      .then(function (entry) {
        CC.ui.serverCheck = null;
        CC.ui.serverUrl = '';
        return CC.refreshServers().then(function () {
          if (connect) return CC.openServer(entry);
          CC._status = { msg: 'Saved ' + (entry.name || entry.url), tone: '' };
          CC.render(CC.state);
        });
      })
      .catch(function (error) {
        CC._status = { msg: errMsg(error), tone: 'error' };
        CC.render(CC.state);
      });
  };

  CC.connectSavedServer = function (id) {
    var server = (CC.servers || []).filter(function (item) { return item.id === id; })[0];
    if (!server) return;
    CC._status = { msg: 'Connecting to ' + (server.name || server.url) + '...', tone: 'progress' };
    CC.render(CC.state);
    return Promise.resolve(bridge.remoteServers.touch ? bridge.remoteServers.touch(id) : null)
      .then(function () { return CC.refreshServers(); })
      .then(function () { return CC.openServer(server); })
      .catch(function (error) {
        CC._status = { msg: errMsg(error), tone: 'error' };
        CC.render(CC.state);
      });
  };

  CC.openServer = function (server) {
    if (!bridge.remoteServers || !bridge.remoteServers.open) {
      CC._status = { msg: 'Opening remote servers is not available in this build.', tone: 'error' };
      CC.render(CC.state);
      return;
    }
    return CC.run('Opening ' + (server.name || server.url) + '...', function () {
      return bridge.remoteServers.open(server);
    });
  };

  CC.removeServer = function (id) {
    return CC.run('Removing server...', function () {
      return Promise.resolve(bridge.remoteServers.remove(id)).then(function () { return null; });
    }).then(function () {
      return CC.refreshServers().then(function () { CC.render(CC.state); });
    });
  };

  CC.act = function (name, node) {
    switch (name) {
      case 'local':
        return CC.run('Starting Local ddagent...', function () { return bridge.openLocal(); });
      case 'connect':
        return CC.run('Opening ddagent to connect your account...', function () { return bridge.connectCloud(); });
      case 'logout':
        return CC.run('Logging out...', function () { return bridge.disconnectCloud(); });
      case 'disconnect':
        return CC.run('Disconnecting...', function () {
          return bridge.disconnect ? bridge.disconnect() : bridge.showLauncher();
        });
      case 'open-web':
        return CC.run('Opening local web UI in your browser...', function () { return bridge.openLocalWebUi(); });
      case 'copy-web':
        return CC.run('Copied local URL to clipboard', function () { return bridge.copyLocalWebUrl(); });
      case 'diagnostics':
        return CC.run('Copied diagnostics to clipboard', function () { return bridge.copyDiagnostics(); });
      case 'set-setting':
        return CC.run('Saved', function () { return bridge.updateSetting(node.key, node.value); });
      case 'set-theme-mode':
        return CC.run('Saved', function () { return bridge.updateSetting('themeMode', node.value); });
      case 'settings-toggle':
        return CC.run('Opening desktop settings...', function () { return bridge.showDesktopSettings(); });
      case 'desktop-settings-toggle':
        return CC.run('Opening desktop settings...', function () { return bridge.showDesktopSettings(); });
      case 'local-settings-toggle':
        return CC.run('Opening local settings...', function () { return bridge.showLocalSettings(); });
      case 'settings-close':
        return CC.closeSheet();
      case 'refresh-tab':
        return CC.run('Refreshing tab...', function () { return bridge.refreshActiveTab(); });
      case 'server-check':
        return CC.checkServer();
      case 'server-save':
        return CC.saveCheckedServer(false);
      case 'server-connect':
        return CC.saveCheckedServer(true);
      case 'server-open':
        return CC.connectSavedServer(node.getAttribute('data-cc-server-id'));
      case 'server-remove':
        return CC.removeServer(node.getAttribute('data-cc-server-id'));
      case 'env-row-menu':
        return CC.run('Opening environment actions...', function () { return bridge.showEnvironmentActionsMenu(node.getAttribute('data-cc-environment-id')); });
      default:
        return;
    }
  };

  function renderTabs(state) {
    var tabs = state.tabs && state.tabs.length ? state.tabs : [{ id: 'home', title: 'Home', closable: false, active: true }];
    return tabs.map(function (tab) {
      var title = tab.title || '';
      var visibleChars = Math.min(title.length, 20);
      var tabWidth = Math.max(112, Math.min(232, (visibleChars * 8) + (tab.closable ? 56 : 38)));
      return '<button class="tb-tab no-drag' + (tab.active ? ' active' : '') + '" data-cc-tab="' + esc(tab.id) + '" title="' + esc(title) + '" style="width:' + tabWidth + 'px;flex-basis:' + tabWidth + 'px">' +
        '<span>' + esc(title) + '</span>' +
        (tab.closable ? '<span class="tb-close" data-cc-close-tab="' + esc(tab.id) + '" title="Close tab">&times;</span>' : '') +
        '</button>';
    }).join('');
  }

  CC.titlebar = function (state) {
    var conn = connected(state);
    var activeTab = (state.tabs || []).filter(function (tab) { return tab.active; })[0] || null;
    var activeEnvironmentId = state.activeTarget && state.activeTarget.kind === 'remote' ? state.activeTarget.id : null;
    if (!activeEnvironmentId && activeTab && /^remote:/.test(activeTab.id || '')) {
      activeEnvironmentId = activeTab.id.replace(/^remote:/, '');
    }
    var activeRefreshable = (state.activeTarget && (state.activeTarget.kind === 'remote' || state.activeTarget.kind === 'local')) ||
      (activeTab && activeTab.id !== 'home');
    var envActions = activeEnvironmentId ? '<button class="btn sm tb-action no-drag" data-cc-action="env-row-menu" data-cc-environment-id="' + esc(activeEnvironmentId) + '" title="Open environment actions">Open environment in...</button>' : '';
    var refreshAction = activeRefreshable ? '<button class="icon-btn tb-action no-drag" data-cc-action="refresh-tab" title="Refresh tab">' + icon('refresh', 16) + '</button>' : '';
    var activeKind = state.activeTarget && state.activeTarget.kind;
    var disconnectAction = (activeKind === 'remote' || activeKind === 'local')
      ? '<button class="btn sm tb-action no-drag" data-cc-action="disconnect" title="Leave ' + esc(state.activeTarget.name || 'this server') + ' and return to the launcher">' + icon('logOut', 14) + 'Disconnect</button>'
      : '';
    var logoutAction = (conn || authState(state) === 'expired') ? '<button class="icon-btn tb-action no-drag" data-cc-action="logout" title="Logout">' + icon('logOut', 16) + '</button>' : '';
    return '<div class="titlebar">' +
      '<div class="brand"><img class="mk" src="' + esc(LOGO_URL) + '" alt=""><span>ddagent</span></div>' +
      '<div class="tb-tabs no-drag">' + renderTabs(state) + '</div>' +
      '<span style="flex:1"></span>' +
      refreshAction +
      envActions +
      disconnectAction +
      '<button class="btn sm tb-action no-drag" data-cc-action="connect" title="' + esc(authState(state) === 'expired' ? 'Reconnect your ddagent account' : accountLabel(state)) + '"><span class="dot" style="background:' + (conn ? 'var(--ok)' : (authState(state) === 'expired' ? 'var(--warn)' : 'var(--tx3)')) + '"></span>' + esc(accountLabel(state)) + '</button>' +
      logoutAction +
      '<button class="icon-btn tb-action no-drag" data-cc-action="settings-toggle" title="Settings">' + icon('settings', 16) + '</button>' +
      '</div>';
  };

  CC.statusbar = function (state) {
    var status = CC._status || {};
    var phase = localStatusOf(state);
    var running = phase === 'ready';
    var failed = phase === 'failed';
    var booting = phase === 'booting';
    // Auto-continue pushes its own line (e.g. "Connecting to X...") while the
    // probe runs — shown in the same slot a local action status would take.
    var activityMsg = status.msg || state.autoContinueStatus || '';
    var activityTone = status.msg ? status.tone : 'progress';
    return '<div class="statusbar">' +
      '<span><span class="dot" style="width:7px;height:7px;background:' + (running ? 'var(--ok)' : (failed ? 'var(--err)' : (booting ? 'var(--brand-2)' : 'var(--tx3)'))) + '"></span> local ' + (running ? 'running · ' + esc(localUrl(state)) : (failed ? 'failed' : (booting ? 'starting' : 'idle'))) + '</span>' +
      '<span class="sep">·</span><span>' + esc(serverCount()) + '</span>' +
      '<span class="sep">·</span><span>' + (authState(state) === 'expired' ? 'session expired' : (connected(state) ? esc(accountLabel(state)) : 'not connected')) + '</span>' +
      '<span style="flex:1"></span>' +
      (activityMsg ? '<span class="status-msg ' + esc(activityTone) + '">' + esc(activityMsg) + '</span><span class="sep">·</span>' : '') +
      '<span>v' + esc(VERSION) + '</span>' +
      '</div>';
  };

  CC.renderSheet = function (title, subtitle, sections, footer) {
    overlay.innerHTML =
      '<div class="cc-sheet cc-modal">' +
      '<div class="cc-sheet-header">' +
      '<div class="cc-sheet-copy"><div class="cc-sheet-title">' + esc(title) + '</div><div class="cc-sheet-subtitle">' + esc(subtitle || '') + '</div></div>' +
      '<button class="icon-btn cc-sheet-close" data-cc-action="settings-close" title="Close">' + icon('x', 16) + '</button>' +
      '</div>' +
      '<div class="cc-sheet-body">' + sections.join('') + '</div>' +
      (footer ? '<div class="cc-sheet-footer">' + footer + '</div>' : '') +
      '</div>';
  };

  CC.renderSection = function (eyebrow, title, body) {
    return '<section class="cc-section">' +
      '<div class="cc-section-head">' +
      '<div class="lbl">' + esc(eyebrow) + '</div>' +
      '<div class="cc-section-title">' + esc(title) + '</div>' +
      '</div>' +
      '<div class="cc-section-body">' + body + '</div>' +
      '</section>';
  };

  CC.renderRadioOption = function (name, value, checked, title, description) {
    return '<label class="cc-choice">' +
      '<input type="radio" name="' + esc(name) + '" value="' + esc(value) + '"' + (checked ? ' checked' : '') + '>' +
      '<span><b>' + esc(title) + '</b><br>' + esc(description) + '</span>' +
      '</label>';
  };

  CC.openSheet = function (sheet, options) {
    options = options || {};
    if (sheet === 'desktop-settings') {
      CC.renderDesktopSettings();
    } else {
      CC.renderLocalSettings();
    }
    CC.ui.openSheet = sheet;
    overlay.classList.add('open');
    if (typeof options.scrollTop === 'number') {
      var body = overlay.querySelector('.cc-sheet-body');
      if (body) body.scrollTop = options.scrollTop;
    }
  };

  CC.closeSheet = function () {
    if (CC.modalMode && bridge.closeSettingsWindow) {
      CC.ui.openSheet = null;
      return bridge.closeSettingsWindow();
    }
    CC.ui.openSheet = null;
    overlay.classList.remove('open');
  };

  CC.buildLocalServerSection = function (state, options) {
    options = options || {};
    var settings = state.desktopSettings || {};
    var url = localUrl(state) || 'starts on demand';
    var body = '<div class="cc-surface">' +
      '<div class="cc-meta mono">' + esc(url) + '</div>' +
      '<div class="cc-row2"><button class="btn sm" data-cc-action="open-web">' + icon('arrow', 14) + 'Open in browser</button><button class="btn sm" data-cc-action="copy-web">' + icon('copy', 14) + 'Copy URL</button></div>';
    if (options.includePreferences) {
      body +=
        '<label class="cc-toggle"><input type="checkbox" data-cc-setting="keepLocalServerRunning"' + (settings.keepLocalServerRunning ? ' checked' : '') + '><span><b>Keep server running</b><br>Leave Local ddagent available after you quit the app.</span></label>' +
        '<label class="cc-toggle"><input type="checkbox" data-cc-setting="exposeLocalServerOnNetwork"' + (settings.exposeLocalServerOnNetwork ? ' checked' : '') + '><span><b>Allow LAN access</b><br>Use the copied URL from another device on this network.</span></label>';
    }
    body += '</div>';
    return CC.renderSection(
      options.eyebrow || 'LOCAL SERVER',
      options.title || 'Run Local ddagent on this machine',
      body
    );
  };

  CC.buildThemeSection = function (state) {
    var settings = state.desktopSettings || {};
    return CC.renderSection('APPEARANCE', 'Desktop theme', '' +
      '<div class="cc-surface cc-choice-group">' +
      CC.renderRadioOption('desktop-theme', 'system', settings.themeMode === 'system', 'System', 'Follow the operating system appearance.') +
      CC.renderRadioOption('desktop-theme', 'light', settings.themeMode === 'light', 'Light', 'Use the light interface appearance.') +
      CC.renderRadioOption('desktop-theme', 'dark', settings.themeMode === 'dark', 'Dark', 'Use the dark interface appearance.') +
      '</div>'
    );
  };

  CC.renderLocalSettings = function () {
    var state = CC.state || {};
    var sections = [
      CC.buildLocalServerSection(state, { includePreferences: false }),
      CC.renderSection('PREFERENCES', 'How the local service behaves', '' +
        '<div class="cc-surface">' +
        '<label class="cc-toggle"><input type="checkbox" data-cc-setting="keepLocalServerRunning"' + ((state.desktopSettings || {}).keepLocalServerRunning ? ' checked' : '') + '><span><b>Keep server running</b><br>Leave Local ddagent available after you quit the app.</span></label>' +
        '<label class="cc-toggle"><input type="checkbox" data-cc-setting="exposeLocalServerOnNetwork"' + ((state.desktopSettings || {}).exposeLocalServerOnNetwork ? ' checked' : '') + '><span><b>Allow LAN access</b><br>Use the copied URL from another device on this network.</span></label>' +
        '</div>'
      ),
    ];
    CC.renderSheet('Local Settings', 'Manage how Local ddagent runs on this computer.', sections);
  };

  CC.renderDesktopSettings = function () {
    var settings = (CC.state || {}).desktopSettings || {};
    var sections = [
      CC.buildThemeSection(CC.state || {}),
      CC.renderSection('STARTUP', 'On launch', '' +
        '<div class="cc-surface">' +
        '<label class="cc-toggle"><input type="checkbox" data-cc-setting="autoContinue"' + (settings.autoContinue !== false ? ' checked' : '') + '><span><b>Reconnect automatically</b><br>Skip the launcher on launch and return to the last connected server.</span></label>' +
        '</div>'
      ),
    ];
    CC.renderSheet('Desktop Settings', 'Manage the desktop app appearance.', sections);
  };

  CC.render = function (state) {
    state = state || CC.state;
    var titlebar = (CC._reg.titlebar || CC.titlebar)(state);
    var statusbar = (CC._reg.statusbar || CC.statusbar)(state);
    var body = CC._reg.renderBody ? CC._reg.renderBody(state) : '';
    if (CC.modalMode) {
      app.innerHTML = '';
    } else {
      app.innerHTML = titlebar + '<div class="cc-body ' + (CC._reg.bodyClass || '') + '">' + body + '</div>' + statusbar;
    }
    if (CC._reg.afterRender) CC._reg.afterRender(state);
  };

  function wireEvents() {
    if (CC._wired) return;
    CC._wired = true;

    document.addEventListener('click', function (event) {
      if (CC._reg.onClick && CC._reg.onClick(event)) return;
      var closeTab = event.target.closest('[data-cc-close-tab]');
      if (closeTab) {
        event.stopPropagation();
        CC.run('Closing tab...', function () { return bridge.closeTab(closeTab.getAttribute('data-cc-close-tab')); });
        return;
      }
      var tab = event.target.closest('[data-cc-tab]');
      if (tab) {
        CC.run('Switching tab...', function () { return bridge.switchTab(tab.getAttribute('data-cc-tab')); });
        return;
      }
      var action = event.target.closest('[data-cc-action]');
      if (action) {
        CC.act(action.getAttribute('data-cc-action'), action);
        return;
      }
      if (overlay.classList.contains('open') && !event.target.closest('.cc-sheet')) {
        CC.closeSheet();
      }
    });

    document.addEventListener('input', function (event) {
      if (event.target.closest('[data-cc-server-input]')) {
        CC.ui.serverUrl = event.target.value;
      }
    });

    document.addEventListener('change', function (event) {
      var setting = event.target.closest('[data-cc-setting]');
      if (setting) {
        CC.act('set-setting', {
          key: setting.getAttribute('data-cc-setting'),
          value: setting.checked,
        });
        return;
      }
      var theme = event.target.closest('[name="desktop-theme"]');
      if (theme) {
        CC.act('set-theme-mode', { value: theme.value });
        return;
      }
    });

    document.addEventListener('keydown', function (event) {
      if (event.key === 'Escape' && overlay.classList.contains('open')) {
        CC.closeSheet();
        return;
      }
      if ((event.metaKey || event.ctrlKey) && event.key === ',') {
        event.preventDefault();
        CC.act('settings-toggle');
        return;
      }
      if (overlay.classList.contains('open')) return;
      if (event.key === 'Enter' && event.target.closest && event.target.closest('[data-cc-server-input]')) {
        CC.checkServer();
        return;
      }
      if (CC._reg.onKey) CC._reg.onKey(event, CC.state);
    });
  }

  function boot() {
    app = document.getElementById('app');
    overlay = document.createElement('div');
    overlay.id = 'cc-overlay';
    overlay.className = 'cc-overlay';
    document.body.appendChild(overlay);

    var isMac = /Mac/i.test(navigator.platform) || /Mac OS X/i.test(navigator.userAgent);
    var isWin = /Win/i.test(navigator.platform);
    CC.platform = isMac ? 'mac' : (isWin ? 'win' : 'linux');
    document.body.classList.add(CC.platform);
    CC.ui.initialSheet = SEARCH.get('sheet') || 'desktop-settings';
    if (CC.modalMode) {
      document.documentElement.classList.add('cc-modal-window');
      document.body.classList.add('cc-modal-window');
    }

    wireEvents();
    if (window.matchMedia) {
      window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', function () {
        CC.applyTheme(CC.state);
      });
    }
    if (bridge.onStateUpdated) {
      bridge.onStateUpdated(function (state) { CC.setState(state); });
    }
    if (bridge.onLauncherCommand) {
      bridge.onLauncherCommand(function (command) {
        if (command && command.type === 'open-sheet') {
          CC.ui.initialSheet = command.sheet || CC.ui.initialSheet || 'desktop-settings';
          CC.openSheet(command.sheet);
        }
      });
    }
    CC.refresh().catch(function (error) {
      CC._status = { msg: errMsg(error), tone: 'error' };
      CC.render(CC.state);
    });
    CC.refreshServers().then(function () { CC.render(CC.state); });
  }

  CC.register = function (registry) {
    CC._reg = registry || {};
  };

  CC.start = function () {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', boot);
    } else {
      boot();
    }
  };
})();

(function sidebarApp() {
  var CC = window.CC;

  function navItem(id, iconName, label, meta, selected) {
    return '<button class="sb-item' + (selected === id ? ' active' : '') + '" data-cc-nav="' + id + '">' +
      CC.icon(iconName, 16) + '<span>' + label + '</span><span class="sb-meta">' + CC.esc(meta) + '</span></button>';
  }

  function localPane(state) {
    var phase = localStatusOf(state);
    var error = state.localError ? String(state.localError) : '';
    var dotColor = phase === 'ready' ? 'var(--ok)' : (phase === 'failed' ? 'var(--err)' : (phase === 'booting' ? 'var(--brand-2)' : 'var(--tx3)'));
    var card = '<div class="card"><div class="card-head"><div><div class="card-t">Local server</div><div class="card-sub mono">' + CC.esc(CC.localUrl(state) || 'Starts on demand') + '</div></div><div class="card-tools"><span class="dot" style="background:' + dotColor + '"></span><button class="icon-btn" data-cc-action="local-settings-toggle" title="Local settings">' + CC.icon('gear', 16) + '</button></div></div>';
    if (error) {
      var logs = (state.localStartupLogs || []).slice(-50);
      card += '<div class="local-error"><b>Startup failed.</b> ' + CC.esc(error) + '</div>' +
        '<div class="card-actions"><button class="btn pri" data-cc-action="local">' + CC.icon('refresh', 15) + 'Retry</button>' +
        '<button class="btn" data-cc-action="diagnostics">' + CC.icon('copy', 14) + 'Copy diagnostics</button></div>' +
        (logs.length ? '<pre class="log-tail">' + CC.esc(logs.join('\n')) + '</pre>' : '');
    } else if (phase === 'booting') {
      // Splash while the embedded backend boots — visible when the boot was
      // not triggered by the "Open Local" flow that swaps in the tab
      // placeholder (e.g. tray "Open Local in Browser", or the few frames
      // before that placeholder attaches).
      var tail = (state.localStartupLogs || []).slice(-8);
      card += '<div class="boot-row"><span class="spinner"></span><span>Starting local backend...</span></div>' +
        (tail.length
          ? '<div class="boot-latest mono">' + CC.esc(tail[tail.length - 1]) + '</div><pre class="log-tail">' + CC.esc(tail.join('\n')) + '</pre>'
          : '<div class="cc-meta">Waiting for first output...</div>');
    } else {
      card += '<div class="card-actions"><button class="btn pri" data-cc-action="local">' + CC.icon('play', 15) + 'Open Local ddagent</button><button class="btn" data-cc-action="open-web">' + CC.icon('arrow', 14) + 'Open in browser</button><button class="btn" data-cc-action="copy-web">' + CC.icon('copy', 14) + 'Copy URL</button></div>';
    }
    return '<div class="pane-h"><div><h2 class="pane-title">Local servers</h2><p class="pane-sub">Manage Local ddagent on this machine. No account required.</p></div></div>' + card + '</div>';
  }

  function serverRow(server, offline) {
    return '<div class="srv">' +
      '<div class="srv-i"><div class="srv-n">' + CC.esc(server.name || server.url) + ((server.offline || offline) ? ' <span class="tag err">offline</span>' : '') + '</div><div class="srv-u mono">' + CC.esc(server.url || '') + '</div></div>' +
      '<span class="srv-last">' + CC.esc(CC.relTime(server.lastUsedAt)) + '</span>' +
      '<button class="btn sm pri" data-cc-action="server-open" data-cc-server-id="' + CC.esc(server.id) + '">' + CC.icon('arrow', 14) + 'Connect</button>' +
      '<button class="icon-btn" data-cc-action="server-remove" data-cc-server-id="' + CC.esc(server.id) + '" title="Remove server">' + CC.icon('x', 14) + '</button></div>';
  }

  function serversPane(state) {
    var servers = CC.servers || [];
    var check = CC.ui.serverCheck || null;
    var feedback = '';
    if (check && check.ok) {
      feedback = '<div class="srv-check ok">' +
        '<span class="srv-check-label">' + CC.icon('monitor', 14) + 'ddagent ' + CC.esc(check.version || 'server') + ' · <span class="mono">' + CC.esc(check.url) + '</span></span>' +
        '<span class="srv-check-actions"><button class="btn sm" data-cc-action="server-save">Save</button>' +
        '<button class="btn sm pri" data-cc-action="server-connect">' + CC.icon('arrow', 14) + 'Connect</button></span></div>';
    } else if (check && check.error) {
      feedback = '<div class="srv-check err">' + CC.esc(check.error) + '</div>';
    }
    var card = '<div class="card"><div class="card-head"><div><div class="card-t">Connect to server</div>' +
      '<div class="card-sub">Paste the URL of a ddagent server.</div></div></div>' +
      '<div class="srv-form"><input class="srv-input mono" data-cc-server-input type="text" placeholder="host.example.com:10087" value="' + CC.esc(CC.ui.serverUrl || '') + '" spellcheck="false" autocomplete="off">' +
      '<button class="btn pri" data-cc-action="server-check"' + (CC.ui.serverChecking ? ' disabled' : '') + '>' + CC.icon('arrow', 14) + 'Connect</button></div>' +
      feedback + '</div>';
    var offlineIds = state.offlineServerIds || [];
    var list = servers.length
      ? servers.map(function (server) { return serverRow(server, offlineIds.indexOf(server.id) !== -1); }).join('')
      : '<div class="empty">No saved servers — paste a URL above.</div>';
    return '<div class="pane-h"><div><h2 class="pane-title">Servers</h2><p class="pane-sub">' + CC.esc(CC.serverCount()) + ' saved</p></div></div>' + card + list;
  }

  function renderBody(state) {
    // A failed local boot auto-selects the local pane so the error + log tail
    // are what the user sees first; an explicit nav pick always wins.
    var section = CC.ui.section || (state.localError ? 'local' : 'servers');
    var phase = localStatusOf(state);
    var localMeta = phase === 'ready' ? 'on' : (phase === 'failed' ? 'error' : (phase === 'booting' ? 'starting' : 'idle'));
    var nav = '<div class="sb"><div class="sb-grp"><div class="lbl">Launcher</div>' +
      navItem('servers', 'cloud', 'Servers', CC.servers ? CC.servers.length : 0, section) +
      navItem('local', 'terminal', 'Local servers', localMeta, section) +
      '</div></div>';
    return nav + '<div class="sb-main">' + (section === 'local' ? localPane(state) : serversPane(state)) + '</div>';
  }

  function onClick(event) {
    var nav = event.target.closest('[data-cc-nav]');
    if (!nav) return false;
    CC.ui.section = nav.getAttribute('data-cc-nav');
    CC.render(CC.state);
    return true;
  }

  CC.register({
    bodyClass: 'v-sidebar',
    renderBody: renderBody,
    onClick: onClick,
  });
  CC.start();
})();

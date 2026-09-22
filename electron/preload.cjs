const { contextBridge, ipcRenderer } = require('electron');

function isDdagentAppOrigin(location) {
  if (location.protocol === 'file:') return true;

  if (location.protocol === 'http:') {
    return location.hostname === '127.0.0.1' || location.hostname === 'localhost';
  }

  return location.protocol === 'https:' && (
    location.hostname === 'ddagent' || location.hostname.endsWith('.ddagent')
  );
}

function onDesktopStateUpdated(callback) {
  const listener = (_event, state) => callback(state);
  ipcRenderer.on('ddagent-desktop:state-updated', listener);
  return () => {
    ipcRenderer.removeListener('ddagent-desktop:state-updated', listener);
  };
}

if (isDdagentAppOrigin(window.location)) {
  contextBridge.exposeInMainWorld('ddagentDesktopNotifications', {
    getState: () => ipcRenderer.invoke('ddagent-desktop:get-state'),
    update: (settings) => ipcRenderer.invoke('ddagent-desktop:update-desktop-notifications', settings),
    onStateUpdated: onDesktopStateUpdated,
  });

  contextBridge.exposeInMainWorld('ddagentBrowser', {
    isDesktop: true,
    openExternal: (url) => ipcRenderer.invoke('ddagent-desktop:open-external', url),
  });
}

if (window.location.protocol === 'file:') {
  contextBridge.exposeInMainWorld('ddagentDesktop', {
    connectCloud: () => ipcRenderer.invoke('ddagent-desktop:connect-cloud'),
    disconnectCloud: () => ipcRenderer.invoke('ddagent-desktop:disconnect-cloud'),
    copyDiagnostics: () => ipcRenderer.invoke('ddagent-desktop:copy-diagnostics'),
    copyLocalWebUrl: () => ipcRenderer.invoke('ddagent-desktop:copy-local-web-url'),
    getState: () => ipcRenderer.invoke('ddagent-desktop:get-state'),
    openCloudDashboard: () => ipcRenderer.invoke('ddagent-desktop:open-cloud-dashboard'),
    openEnvironment: (environmentId) => ipcRenderer.invoke('ddagent-desktop:open-environment', environmentId),
    runActiveEnvironmentAction: (action) => ipcRenderer.invoke('ddagent-desktop:run-active-environment-action', action),
    openLocal: () => ipcRenderer.invoke('ddagent-desktop:open-local'),
    openLocalWebUi: () => ipcRenderer.invoke('ddagent-desktop:open-local-web-ui'),
    refreshEnvironments: () => ipcRenderer.invoke('ddagent-desktop:refresh-environments'),
    refreshActiveTab: () => ipcRenderer.invoke('ddagent-desktop:reload-active-tab'),
    api: {
      request: (method, path, opts = {}) => ipcRenderer.invoke('ddagent-desktop:api', {
        method,
        path,
        headers: opts.headers,
        body: opts.body,
      }),
    },
    remoteServers: {
      list: () => ipcRenderer.invoke('ddagent-desktop:remote-servers-list'),
      add: (payload) => ipcRenderer.invoke('ddagent-desktop:remote-servers-add', payload),
      update: (id, fields) => ipcRenderer.invoke('ddagent-desktop:remote-servers-update', id, fields),
      remove: (id) => ipcRenderer.invoke('ddagent-desktop:remote-servers-remove', id),
      check: (url) => ipcRenderer.invoke('ddagent-desktop:remote-servers-check', url),
    },
    showEnvironmentPicker: () => ipcRenderer.invoke('ddagent-desktop:show-environment-picker'),
    showLauncher: () => ipcRenderer.invoke('ddagent-desktop:show-launcher'),
    showLocalSettings: () => ipcRenderer.invoke('ddagent-desktop:show-local-settings'),
    showDesktopSettings: () => ipcRenderer.invoke('ddagent-desktop:show-desktop-settings'),
    closeSettingsWindow: () => ipcRenderer.invoke('ddagent-desktop:close-settings-window'),
    showActiveEnvironmentActionsMenu: () => ipcRenderer.invoke('ddagent-desktop:show-active-environment-actions-menu'),
    showEnvironmentActionsMenu: (environmentId) => ipcRenderer.invoke('ddagent-desktop:show-environment-actions-menu', environmentId),
    switchTab: (tabId) => ipcRenderer.invoke('ddagent-desktop:switch-tab', tabId),
    closeTab: (tabId) => ipcRenderer.invoke('ddagent-desktop:close-tab', tabId),
    updateSetting: (key, value) => ipcRenderer.invoke('ddagent-desktop:update-setting', key, value),
    onStateUpdated: onDesktopStateUpdated,
    onLauncherCommand: (callback) => {
      ipcRenderer.on('ddagent-desktop:launcher-command', (_event, command) => callback(command));
    },
  });
}

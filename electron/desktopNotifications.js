import crypto from 'node:crypto';
import fs from 'node:fs/promises';
import path from 'node:path';
import { Notification } from 'electron';
import WebSocket from 'ws';

import { fingerprintMatches } from './tlsPinning.js';

const RECONNECT_MIN_MS = 1000;
const RECONNECT_MAX_MS = 30000;
const TARGET_REGISTER_TIMEOUT_MS = 8000;

function toNotificationsWsUrl(httpUrl) {
  try {
    const parsed = new URL(httpUrl);
    parsed.protocol = parsed.protocol === 'http:' ? 'ws:' : 'wss:';
    parsed.pathname = '/desktop-notifications';
    parsed.search = '';
    parsed.hash = '';
    return parsed.toString();
  } catch {
    return null;
  }
}

function readJsonMessage(raw) {
  try {
    return JSON.parse(String(raw));
  } catch {
    return null;
  }
}

async function requestJson(url, { method = 'POST', body = null, headers = {} } = {}) {
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), TARGET_REGISTER_TIMEOUT_MS);
  try {
    const response = await fetch(url, {
      method,
      signal: controller.signal,
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
      ...(body == null ? {} : { body: JSON.stringify(body) }),
    });
    const payload = await response.json().catch(() => ({}));
    if (!response.ok) {
      throw new Error(payload.error || `Request failed with status ${response.status}`);
    }
    return payload;
  } finally {
    clearTimeout(timeout);
  }
}

export class DesktopNotificationsController {
  constructor({
    settingsPath,
    appVersion,
    appName,
    getDeviceId,
    getAccountEmail,
    getRunningEnvironmentUrls,
    getRemoteServerUrls,
    getTrustedCertFingerprint,
    requestJsonOnTarget,
    getApiKey,
    getAuthToken,
    getIconPath,
    openNotificationTarget,
    onChange,
  }) {
    this.settingsPath = settingsPath;
    this.appVersion = appVersion;
    this.appName = appName;
    this.getDeviceId = getDeviceId;
    this.getAccountEmail = getAccountEmail;
    this.getRunningEnvironmentUrls = getRunningEnvironmentUrls;
    this.getRemoteServerUrls = getRemoteServerUrls;
    this.getTrustedCertFingerprint = getTrustedCertFingerprint;
    this.requestJsonOnTarget = requestJsonOnTarget;
    this.getApiKey = getApiKey;
    this.getAuthToken = getAuthToken;
    this.getIconPath = getIconPath;
    this.openNotificationTarget = openNotificationTarget;
    this.onChange = onChange;
    this.settings = { enabled: false };
    this.deviceId = null;
    this.connections = new Map();
    this.lastEvent = null;
    this.lastError = null;
  }

  getState() {
    const connectedTargets = [];
    for (const [url, connection] of this.connections.entries()) {
      if (connection.ws?.readyState === WebSocket.OPEN) {
        connectedTargets.push(url);
      }
    }

    return {
      enabled: this.settings.enabled,
      supported: Notification.isSupported(),
      targetCount: this.connections.size,
      connectedCount: connectedTargets.length,
      connectedTargets,
      lastEvent: this.lastEvent,
      lastError: this.lastError,
    };
  }

  async loadSettings() {
    try {
      const raw = await fs.readFile(this.settingsPath, 'utf8');
      const stored = JSON.parse(raw);
      this.settings = { enabled: Boolean(stored.enabled) };
      this.deviceId = typeof stored.deviceId === 'string' && stored.deviceId ? stored.deviceId : null;
    } catch {
      this.settings = { enabled: false };
      this.deviceId = null;
    }
    if (!this.deviceId) {
      // Stable local fallback for remote-server targets — without a connected
      // ddagent account there is no cloud deviceId, and a per-boot random one
      // would accumulate dead endpoint rows on every remote server.
      this.deviceId = crypto.randomUUID();
      await this.persistSettings().catch(() => {});
    }
    return this.settings;
  }

  async persistSettings() {
    await fs.mkdir(path.dirname(this.settingsPath), { recursive: true });
    await fs.writeFile(
      this.settingsPath,
      JSON.stringify({ ...this.settings, deviceId: this.deviceId }, null, 2),
      'utf8'
    );
  }

  async saveSettings(next) {
    const enabled = Boolean(next?.enabled);
    if (!enabled && this.settings.enabled) {
      await this.disableCurrentTargets();
    }
    this.settings = { enabled };
    await this.persistSettings();
    await this.sync();
    this.onChange?.();
    return this.settings;
  }

  resolveDeviceId() {
    return this.getDeviceId?.() || this.deviceId || '';
  }

  async sync() {
    if (!this.settings.enabled) {
      this.stop();
      this.lastEvent = 'disabled';
      this.onChange?.();
      return;
    }

    if (!Notification.isSupported()) {
      this.stop();
      this.lastEvent = 'unsupported';
      this.lastError = 'Native notifications are not supported on this system.';
      this.onChange?.();
      return;
    }

    const deviceId = this.resolveDeviceId();
    if (!deviceId) {
      this.stop();
      this.lastEvent = 'missing-device';
      this.lastError = 'Connect a ddagent account before enabling desktop notifications.';
      this.onChange?.();
      return;
    }

    // includeApiKey=false for remote servers: the ddagent cloud API key is
    // only valid for control-plane environments — sending it to a self-hosted
    // host would leak the credential and break registration when that server
    // enforces its own API_KEY.
    const targets = [];
    const seenWsUrls = new Set();
    const addTargets = (httpUrls, includeApiKey) => {
      for (const httpUrl of httpUrls || []) {
        const wsUrl = toNotificationsWsUrl(httpUrl);
        if (!wsUrl || seenWsUrls.has(wsUrl)) continue;
        seenWsUrls.add(wsUrl);
        targets.push({ httpUrl, wsUrl, includeApiKey });
      }
    };
    addTargets(this.getRunningEnvironmentUrls?.(), true);
    addTargets(this.getRemoteServerUrls?.(), false);

    const nextWsUrls = new Set(targets.map((target) => target.wsUrl));
    for (const [wsUrl, connection] of this.connections.entries()) {
      if (!nextWsUrls.has(wsUrl)) {
        this.closeConnection(connection);
        this.connections.delete(wsUrl);
      }
    }

    for (const target of targets) {
      if (!this.connections.has(target.wsUrl)) {
        void this.connect(target).catch((error) => {
          this.lastEvent = 'connect-error';
          this.lastError = error instanceof Error ? error.message : String(error);
          this.onChange?.();
        });
      }
    }

    this.lastEvent = targets.length ? 'sync' : 'no-targets';
    this.onChange?.();
  }

  async connect(target, attempt = 0) {
    const existing = this.connections.get(target.wsUrl);
    if (existing?.ws && [WebSocket.CONNECTING, WebSocket.OPEN].includes(existing.ws.readyState)) {
      return;
    }

    const connection = {
      ...target,
      ws: null,
      reconnectTimer: null,
      closed: false,
      attempt,
    };
    this.connections.set(target.wsUrl, connection);

    const headers = await this.getTargetAuthHeaders(target);
    if (connection.closed || this.connections.get(target.wsUrl) !== connection) {
      return;
    }

    // Self-signed remote certs: CA verification is disabled ONLY for origins
    // the user explicitly fingerprint-trusted (remoteServers store), and the
    // peer cert is then pinned to that fingerprint on 'upgrade' — before any
    // payload is sent. A CA-valid cert passes on `socket.authorized` even when
    // it no longer matches the stored fingerprint (e.g. the server moved to a
    // real cert). No fingerprint stored → default verification stays on.
    const expectedFingerprint = target.wsUrl.startsWith('wss:')
      ? await Promise.resolve(this.getTrustedCertFingerprint?.(target.httpUrl)).catch(() => null)
      : null;
    if (connection.closed || this.connections.get(target.wsUrl) !== connection) {
      return;
    }

    const ws = new WebSocket(target.wsUrl, {
      headers: Object.keys(headers).length ? headers : undefined,
      ...(expectedFingerprint ? { rejectUnauthorized: false } : {}),
    });
    connection.ws = ws;

    if (expectedFingerprint) {
      ws.on('upgrade', (res) => {
        const socket = res.socket;
        if (socket?.authorized) return;
        const certificate = socket?.getPeerCertificate?.();
        if (certificate?.raw && fingerprintMatches(expectedFingerprint, certificate.raw)) return;
        this.lastEvent = 'cert-mismatch';
        this.lastError = `TLS certificate for ${new URL(target.wsUrl).host} does not match the trusted fingerprint.`;
        this.onChange?.();
        try { socket?.destroy(); } catch {}
        try { ws.terminate(); } catch {}
      });
    }

    ws.on('open', async () => {
      try {
        await this.registerTarget(target);
        ws.send(JSON.stringify({
          type: 'register',
          deviceId: this.resolveDeviceId(),
          label: this.getAccountEmail?.() || this.appName,
          platform: process.platform,
          appVersion: this.appVersion,
        }));
        connection.attempt = 0;
        this.lastEvent = 'connected';
        this.lastError = null;
        this.onChange?.();
      } catch (error) {
        this.lastEvent = 'register-error';
        this.lastError = error instanceof Error ? error.message : String(error);
        this.onChange?.();
        try { ws.close(); } catch {}
      }
    });

    ws.on('message', (raw) => this.handleMessage(target, ws, raw));
    ws.on('close', () => this.scheduleReconnect(target.wsUrl));
    ws.on('error', (error) => {
      this.lastEvent = 'socket-error';
      this.lastError = error instanceof Error ? error.message : String(error);
      this.onChange?.();
    });
  }

  // Remote targets ride the target's own webview fetch: Chromium already
  // applies the user's certificate trust and the page supplies its session
  // token, so main needs no second TLS stack and never sees the credential.
  async requestTargetJson(target, requestPath, { method = 'POST', body = null } = {}) {
    const url = new URL(requestPath, target.httpUrl).toString();
    if (target.includeApiKey === false && this.requestJsonOnTarget) {
      const result = await this.requestJsonOnTarget(target.httpUrl, url, { method, body });
      if (!result) {
        throw new Error('Remote view is not available for the notifications request.');
      }
      if (!result.ok) {
        throw new Error(result.payload?.error || result.error || `Request failed with status ${result.status}`);
      }
      return result.payload;
    }
    return requestJson(url, {
      method,
      headers: await this.getTargetAuthHeaders(target),
      body,
    });
  }

  async registerTarget(target) {
    await this.requestTargetJson(target, '/api/notifications/endpoints/current', {
      method: 'POST',
      body: {
        channel: 'desktop',
        endpointId: this.resolveDeviceId(),
        label: this.getAccountEmail?.() || this.appName,
        metadata: {
          platform: process.platform,
          appVersion: this.appVersion,
        },
        enabled: true,
      },
    });
  }

  async disableCurrentTargets() {
    const deviceId = this.resolveDeviceId();
    if (!deviceId) return;

    const targets = new Map();
    const addTarget = (httpUrl, includeApiKey) => {
      if (httpUrl && !targets.has(httpUrl)) {
        targets.set(httpUrl, { httpUrl, includeApiKey });
      }
    };
    for (const connection of this.connections.values()) {
      addTarget(connection.httpUrl, connection.includeApiKey);
    }
    for (const httpUrl of this.getRunningEnvironmentUrls?.() || []) {
      addTarget(httpUrl, true);
    }
    for (const httpUrl of this.getRemoteServerUrls?.() || []) {
      addTarget(httpUrl, false);
    }

    const results = await Promise.allSettled([...targets.values()].map(async (target) => {
      await this.requestTargetJson(target, `/api/notifications/endpoints/desktop/${encodeURIComponent(deviceId)}`, {
        method: 'PATCH',
        body: { enabled: false },
      });
    }));

    const rejected = results.find((result) => result.status === 'rejected');
    if (rejected) {
      this.lastEvent = 'disable-endpoint-error';
      this.lastError = rejected.reason instanceof Error ? rejected.reason.message : String(rejected.reason);
    }
  }

  async getTargetAuthHeaders(target) {
    const headers = {};
    const apiKey = target.includeApiKey === false ? null : this.getApiKey?.();
    if (apiKey) {
      headers['X-API-Key'] = apiKey;
    }

    const authToken = await Promise.resolve(this.getAuthToken?.(target.httpUrl)).catch(() => null);
    if (authToken) {
      headers.Authorization = `Bearer ${authToken}`;
    }
    return headers;
  }

  handleMessage(target, ws, raw) {
    const message = readJsonMessage(raw);
    if (!message || message.type !== 'notification' || !message.payload) {
      return;
    }

    const shown = this.showNativeNotification(target, message.payload);
    if (shown && ws.readyState === WebSocket.OPEN) {
      ws.send(JSON.stringify({
        type: 'notification_ack',
        id: message.id || message.payload?.data?.tag || null,
        action: 'shown',
      }));
    }
  }

  showNativeNotification(target, payload) {
    if (!Notification.isSupported()) return false;

    const notification = new Notification({
      title: payload.title || this.appName,
      body: payload.body || '',
      icon: this.getIconPath?.(),
      silent: false,
    });

    notification.on('click', () => {
      void this.openNotificationTarget?.({
        environmentUrl: target.httpUrl,
        sessionId: payload.data?.sessionId || null,
        provider: payload.data?.provider || null,
      }).catch((error) => {
        this.lastEvent = 'click-error';
        this.lastError = error instanceof Error ? error.message : String(error);
        this.onChange?.();
      });
    });

    notification.show();
    this.lastEvent = 'notification-shown';
    this.lastError = null;
    this.onChange?.();
    return true;
  }

  scheduleReconnect(wsUrl) {
    const connection = this.connections.get(wsUrl);
    if (!connection || connection.closed || !this.settings.enabled) {
      return;
    }

    const attempt = connection.attempt + 1;
    connection.attempt = attempt;
    const delay = Math.min(RECONNECT_MAX_MS, RECONNECT_MIN_MS * (2 ** Math.min(attempt, 5)));
    connection.reconnectTimer = setTimeout(() => {
      if (!this.connections.has(wsUrl) || !this.settings.enabled) return;
      void this.connect({
        httpUrl: connection.httpUrl,
        wsUrl: connection.wsUrl,
        includeApiKey: connection.includeApiKey,
      }, attempt).catch((error) => {
        this.lastEvent = 'connect-error';
        this.lastError = error instanceof Error ? error.message : String(error);
        this.onChange?.();
      });
    }, delay);
    this.lastEvent = 'reconnecting';
    this.onChange?.();
  }

  closeConnection(connection) {
    connection.closed = true;
    if (connection.reconnectTimer) {
      clearTimeout(connection.reconnectTimer);
      connection.reconnectTimer = null;
    }
    try { connection.ws?.close(); } catch {}
  }

  stop() {
    for (const connection of this.connections.values()) {
      this.closeConnection(connection);
    }
    this.connections.clear();
    this.onChange?.();
  }
}

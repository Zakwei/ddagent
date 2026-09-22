import { randomUUID } from 'node:crypto';
import { EventEmitter } from 'node:events';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const moduleDir = path.dirname(fileURLToPath(import.meta.url));

// electron/transport -> <appRoot>/dist-server/server. Same relative layout in
// dev (repo root) and packaged builds (app root), matching localServer.js.
const SERVER_ROOT = path.resolve(moduleDir, '..', '..', 'dist-server', 'server');

const WS_EVENT_CHANNEL_PREFIX = 'ddagent-desktop:ws-event:';

// Mirrors createWebSocketServer() (server/modules/websocket/services/
// websocket-server.service.ts): pathname of the upgrade URL picks the handler.
const ROUTE_SPECS = [
  { pathname: '/shell', module: 'modules/websocket/services/shell-websocket.service.js', handler: 'handleShellConnection', withRequest: false, depsKey: 'shell' },
  { pathname: '/ws', module: 'modules/websocket/services/chat-websocket.service.js', handler: 'handleChatConnection', withRequest: true, depsKey: 'chat' },
  { pathname: '/desktop-notifications', module: 'modules/notifications/index.js', handler: 'handleDesktopNotificationsConnection', withRequest: true, depsKey: null },
  { pathname: '/browser-view', module: 'modules/browser-view/index.js', handler: 'handleBrowserViewConnection', withRequest: true, depsKey: null },
];

const AUTH_MODULE = 'modules/websocket/services/websocket-auth.service.js';

/**
 * Default handler loader: dynamically imports the compiled backend modules.
 * Called lazily on the first connection — importing dist-server modules at
 * electron startup would evaluate DB/env-dependent module code before the
 * backend bootstrap sets the environment.
 */
async function loadServerHandlers() {
  const importServer = (rel) => import(pathToFileURL(path.join(SERVER_ROOT, rel)).href);
  const [auth, ...routeModules] = await Promise.all([
    importServer(AUTH_MODULE),
    ...ROUTE_SPECS.map((spec) => importServer(spec.module)),
  ]);
  return {
    verifyWebSocketClient: auth.verifyWebSocketClient,
    routes: ROUTE_SPECS.map((spec, index) => ({
      ...spec,
      handle: routeModules[index][spec.handler],
    })),
  };
}

/**
 * Fallback mirroring verifyWebSocketClient (websocket-auth.service.ts) for
 * injected handler sets that do not ship the real verifier: platform mode
 * skips the token, OSS reads `?token=` then the Authorization header.
 */
function defaultVerifyWebSocketClient(info, dependencies) {
  const request = info.req;
  const upgradeUrl = new URL(request.url ?? '/', 'http://localhost');
  if (dependencies.isPlatform) {
    const user = dependencies.authenticateWebSocket(null);
    if (!user) return false;
    request.user = user;
    return true;
  }
  const token =
    upgradeUrl.searchParams.get('token') ??
    request.headers.authorization?.split(' ')[1] ??
    null;
  const user = dependencies.authenticateWebSocket(token);
  if (!user) return false;
  request.user = user;
  return true;
}

function isWebContentsGone(webContents) {
  if (!webContents) return true;
  if (typeof webContents.isDestroyed === 'function') return webContents.isDestroyed();
  if (typeof webContents.destroyed === 'function') return webContents.destroyed();
  return false;
}

/**
 * Server-side WebSocket stand-in backed by an IPC channel instead of TCP.
 * A plain mutable EventEmitter: handlers store it in sets/maps by identity,
 * attach 'message'/'close'/'error'/'pong' listeners, and browser-view pins
 * `._browserViewSession` on it. No heartbeat is attached — ping/pong guards
 * dead TCP connections, which cannot happen over IPC (`ping()` is still
 * implemented for stray callers).
 */
function createSocket({ emitClose, emitMessage, emitError }) {
  const socket = new EventEmitter();

  socket.CONNECTING = 0;
  socket.OPEN = 1;
  socket.CLOSING = 2;
  socket.CLOSED = 3;
  socket.readyState = socket.CONNECTING;
  socket.bufferedAmount = 0;
  socket.protocol = '';
  socket.extensions = '';

  let finalized = false;
  const finalize = (code, reason) => {
    if (finalized) return;
    finalized = true;
    socket.readyState = socket.CLOSED;
    // Server-side listeners first (they detach state), then the renderer.
    socket.emit('close', code, reason);
    emitClose(code, reason);
  };

  socket.send = (data) => {
    // Real ws errors when sending on a non-open socket; every call site
    // guards with readyState === OPEN, so dropping is the smallest faithful
    // surface — and never throws into broadcast loops (taskmaster.routes).
    if (socket.readyState !== socket.OPEN) return;
    emitMessage(typeof data === 'string' ? data : String(data));
  };

  socket.ping = () => {
    if (finalized) return;
    setImmediate(() => socket.emit('pong', Buffer.alloc(0)));
  };

  socket.terminate = () => {
    if (socket.readyState === socket.CLOSED) return;
    socket.readyState = socket.CLOSING;
    setImmediate(() => finalize(1006, ''));
  };

  socket.close = (code = 1000, reason = '') => {
    if (socket.readyState === socket.CLOSING || socket.readyState === socket.CLOSED) return;
    socket.readyState = socket.CLOSING;
    setImmediate(() => finalize(typeof code === 'number' ? code : 1000, String(reason ?? '')));
  };

  // EventEmitter throws on an unlistened 'error'; the forwarder both prevents
  // that and reports handler-side socket errors to the renderer.
  socket.on('error', (error) => {
    emitError(error instanceof Error ? error.message : String(error));
  });

  return socket;
}

/**
 * Main-process router for WebSocket-over-IPC connections. Each renderer
 * `desktopApi.ws.connect(url)` becomes a fake server-side socket dispatched
 * to the same handle*Connection functions the real ws gateway uses, so the
 * chat/shell/notification/browser-view backends run unchanged in-process.
 *
 * Deps resolve lazily through getWsDeps() (the backend bootstrap owns env
 * setup and dist-server imports); until it reports deps, connects fail with
 * close 1011. `clients` is the open-socket set the bootstrap assigns to
 * `app.locals.wss` ({ clients }) for broadcast users like taskmaster.routes.
 */
export function createWsRouter({ getWsDeps, getApp, loadHandlers = loadServerHandlers } = {}) {
  const connections = new Map(); // connId -> { connId, webContents, socket }
  const connIdsByWebContents = new Map(); // webContents -> Set<connId>
  const clients = new Set(); // open sockets — the app.locals.wss.clients shape

  let handlersPromise = null;
  const handlers = () => (handlersPromise ??= Promise.resolve()
    .then(loadHandlers)
    .catch((error) => {
      // A failed import (e.g. dist-server swapped mid-rebuild) must not poison
      // later connects — clear the cache so the next attempt re-imports.
      handlersPromise = null;
      throw error;
    }));

  function emitToRenderer(webContents, connId, event) {
    if (isWebContentsGone(webContents)) return;
    try {
      webContents.send(`${WS_EVENT_CHANNEL_PREFIX}${connId}`, event);
    } catch {
      // webContents died between the destroyed check and send — drop.
    }
  }

  function dropConnection(entry) {
    connections.delete(entry.connId);
    clients.delete(entry.socket);
    const owned = connIdsByWebContents.get(entry.webContents);
    if (owned) {
      owned.delete(entry.connId);
      if (owned.size === 0) connIdsByWebContents.delete(entry.webContents);
    }
  }

  function dispatch(entry, route, request, wsDeps) {
    // Mirrors createWebSocketServer's signatures: /shell gets (ws, shellDeps),
    // /ws gets (ws, request, chatDeps), the rest get (ws, request).
    const deps = route.depsKey ? wsDeps[route.depsKey] : undefined;
    if (!route.withRequest) {
      route.handle(entry.socket, deps);
    } else if (route.depsKey) {
      route.handle(entry.socket, request, deps);
    } else {
      route.handle(entry.socket, request);
    }
  }

  async function handshake(entry, url) {
    const { socket } = entry;
    if (socket.readyState !== socket.CONNECTING) return; // closed mid-flight

    const wsDeps = getWsDeps?.();
    if (!wsDeps) {
      socket.close(1011, 'local backend not started');
      return;
    }

    let target;
    try {
      target = new URL(url);
    } catch {
      socket.close(1002, 'invalid WebSocket URL');
      return;
    }

    let loaded;
    try {
      loaded = await handlers();
    } catch (error) {
      console.error('[wsRouter] backend modules unavailable:', error?.message || error);
      socket.close(1011, 'backend modules unavailable');
      return;
    }
    if (socket.readyState !== socket.CONNECTING) return;

    // Same shape the ws gateway hands verifyWebSocketClient: it reads
    // info.req.url (token query) + info.req.headers.authorization and writes
    // info.req.user. `app` lets request consumers reach app.locals if needed.
    const request = {
      url: `${target.pathname}${target.search}`,
      headers: {},
      app: getApp?.() ?? undefined,
    };
    const verify = loaded.verifyWebSocketClient ?? defaultVerifyWebSocketClient;
    let verified = false;
    try {
      verified = Boolean(verify({ req: request }, wsDeps.verifyClient));
    } catch (error) {
      console.error('[wsRouter] verifyClient threw:', error?.message || error);
    }
    if (!verified) {
      socket.close(1008, 'authentication failed');
      return;
    }

    // From here the socket is "open" server-side, exactly like when the real
    // gateway's 'connection' event fires — handlers may send/close inside
    // dispatch before the renderer learns about 'open'.
    socket.readyState = socket.OPEN;
    clients.add(socket);

    const route = loaded.routes.find((candidate) => candidate.pathname === target.pathname);
    if (!route || typeof route.handle !== 'function') {
      console.warn('[wsRouter] unknown WebSocket path:', target.pathname);
      socket.close();
      return;
    }
    try {
      dispatch(entry, route, request, wsDeps);
    } catch (error) {
      console.error('[wsRouter] connection handler threw:', error?.message || error);
      socket.close(1011, 'connection handler error');
      return;
    }

    if (socket.readyState === socket.OPEN) {
      emitToRenderer(entry.webContents, entry.connId, { type: 'open' });
    }
  }

  function connect(webContents, url, _protocols) {
    const connId = `ws-${randomUUID()}`;
    const entry = { connId, webContents, socket: null };
    entry.socket = createSocket({
      emitMessage: (data) => emitToRenderer(webContents, connId, { type: 'message', data }),
      emitClose: (code, reason) => {
        emitToRenderer(webContents, connId, { type: 'close', code, reason, wasClean: code === 1000 });
        dropConnection(entry);
      },
      emitError: (message) => emitToRenderer(webContents, connId, { type: 'error', message }),
    });
    connections.set(connId, entry);

    let owned = connIdsByWebContents.get(webContents);
    if (!owned) {
      owned = new Set();
      connIdsByWebContents.set(webContents, owned);
      webContents.once?.('destroyed', () => {
        for (const id of [...owned]) connections.get(id)?.socket.terminate();
      });
    }
    owned.add(connId);

    // The handshake runs a macrotask later: the ipcRenderer.invoke response
    // carrying connId must reach the renderer (which then attaches onEvent)
    // before 'open'/'close' events are sent on the per-connection channel.
    setImmediate(() => {
      handshake(entry, url).catch((error) => {
        console.error('[wsRouter] handshake failed:', error?.message || error);
        entry.socket.close(1011, 'handshake error');
      });
    });
    return connId;
  }

  function send(connId, data) {
    const entry = connections.get(connId);
    if (!entry || entry.socket.readyState !== entry.socket.OPEN) return false;
    try {
      entry.socket.emit('message', typeof data === 'string' ? data : String(data), false);
    } catch (error) {
      entry.socket.emit('error', error instanceof Error ? error : new Error(String(error)));
    }
    return true;
  }

  function close(connId, code, reason) {
    const entry = connections.get(connId);
    if (!entry) return false;
    entry.socket.close(typeof code === 'number' ? code : 1000, typeof reason === 'string' ? reason : '');
    return true;
  }

  return { connect, send, close, clients };
}

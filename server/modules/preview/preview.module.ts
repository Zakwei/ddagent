import type { IncomingMessage, Server as HttpServer } from 'node:http';
import type { Duplex } from 'node:stream';

import type { Router } from 'express';
import type { WebSocket, WebSocketServer } from 'ws';

import { authenticateWebSocket } from '@/modules/auth/index.js';

import { createPreviewProxy, parsePreviewTarget } from './preview-proxy.service.js';
import { createPreviewRouter } from './preview.routes.js';
import { createPortDiscoveryService } from './preview.service.js';

/**
 * Builds the authenticated preview router for the server entrypoint. Mount it
 * behind `authenticateToken` at `/api/preview` — the proxy itself only guards
 * the port range; auth is the mount's job.
 */
export function createPreviewModule(): Router {
  const portDiscoveryService = createPortDiscoveryService();
  const previewProxy = createPreviewProxy({ authenticateRequest });
  return createPreviewRouter(portDiscoveryService, previewProxy);
}

/**
 * Upgrade-time auth equivalent of `authenticateToken`: reads the JWT from
 * `?token=` or the Authorization header, exactly like the ws gateway does.
 */
function authenticateRequest(request: IncomingMessage): boolean {
  const url = new URL(request.url ?? '/', 'http://localhost');
  const token =
    url.searchParams.get('token') ?? request.headers.authorization?.split(' ')[1] ?? null;
  return authenticateWebSocket(token) !== null;
}

/**
 * Minimal slice of the ws gateway needed to re-dispatch non-preview upgrades.
 */
type UpgradeGateway = Pick<WebSocketServer, 'handleUpgrade' | 'emit'> & {
  _removeListeners?: () => void;
};

/**
 * Attaches the preview WebSocket tunnel to the HTTP server.
 *
 * The bundled `ws` gateway registers a catch-all 'upgrade' listener and
 * aborts (400/401) every request it doesn't own — there is no path filter.
 * To keep preview upgrades alive this detaches the gateway's listeners and
 * re-dispatches: preview paths go to the raw TCP tunnel, everything else is
 * handed back to `gateway.handleUpgrade` (verifyClient auth still applies).
 */
export function attachPreviewUpgrade(server: HttpServer, gateway: UpgradeGateway): void {
  const previewProxy = createPreviewProxy({ authenticateRequest });

  if (typeof gateway._removeListeners === 'function') {
    gateway._removeListeners();
  } else {
    // ws internals changed — its catch-all listener will still race preview
    // upgrades. Loud failure beats silent HMR breakage.
    console.warn('[preview] ws gateway exposes no _removeListeners; preview WS upgrades may fail');
  }

  server.on('upgrade', (request: IncomingMessage, socket: Duplex, head: Buffer) => {
    if (parsePreviewTarget(request.url ?? undefined)) {
      previewProxy.handleUpgrade(request, socket, head);
      return;
    }
    gateway.handleUpgrade(request, socket, head, (ws: WebSocket) => {
      gateway.emit('connection', ws, request);
    });
  });
}

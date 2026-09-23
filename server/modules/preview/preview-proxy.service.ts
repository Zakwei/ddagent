import http from 'node:http';
import net from 'node:net';
import type { Duplex } from 'node:stream';

/**
 * Mount path the preview router is registered under. The upgrade handler needs
 * the full prefix because raw 'upgrade' requests bypass Express mounting.
 */
export const PREVIEW_MOUNT_PATH = '/api/preview';

const MIN_PREVIEW_PORT = 1024;
const MAX_PREVIEW_PORT = 65535;

// Hop-by-hop headers must not be forwarded to the upstream dev server.
const HOP_BY_HOP_HEADERS = new Set([
  'connection',
  'keep-alive',
  'proxy-authenticate',
  'proxy-authorization',
  'te',
  'trailer',
  'transfer-encoding',
  'upgrade',
]);

/**
 * SSRF guard: the proxy only ever dials 127.0.0.1, so the port is the only
 * attacker-controlled part of the target. Well-known service ports (ssh, smtp,
 * cloud metadata on link-local is IP-based anyway) stay out of reach.
 */
export function isAllowedPreviewPort(port: number): boolean {
  return Number.isInteger(port) && port >= MIN_PREVIEW_PORT && port <= MAX_PREVIEW_PORT;
}

/**
 * Parses `<mount>/<port>/<rest>` out of a raw request URL. Returns null when
 * the URL is not a preview target.
 */
export function parsePreviewTarget(
  url: string | undefined,
  mountPath = PREVIEW_MOUNT_PATH,
): { port: number; upstreamPath: string } | null {
  if (!url) return null;
  const match = new RegExp(`^${mountPath}/(\\d+)(/.*)?$`).exec(url);
  if (!match) return null;
  return {
    port: Number.parseInt(match[1], 10),
    upstreamPath: match[2] ?? '/',
  };
}

function writePlainError(socket: Duplex, status: number, message: string): void {
  socket.write(
    `HTTP/1.1 ${status} ${message}\r\nConnection: close\r\nContent-Length: 0\r\n\r\n`,
  );
  socket.destroy();
}

/**
 * Rewrites a redirect Location so the browser stays under the preview mount:
 * absolute URLs pointing at the dev server and root-relative paths both get
 * prefixed; anything else is left alone.
 */
function rewriteLocationHeader(value: string, port: number, mountPath: string): string {
  const prefix = `${mountPath}/${port}`;
  const absolute = new RegExp(`^https?://(?:127\\.0\\.0\\.1|localhost|\\[::1\\]):${port}(?=/|$)`, 'i');
  if (absolute.test(value)) {
    return value.replace(absolute, prefix);
  }
  if (value.startsWith('/') && !value.startsWith('//')) {
    return `${prefix}${value}`;
  }
  return value;
}

/**
 * Keeps upstream cookies scoped to the preview mount so a dev server cookie
 * with `Path=/` cannot leak into ddagent's own API namespace.
 */
function rewriteSetCookiePath(value: string, port: number, mountPath: string): string {
  const prefix = `${mountPath}/${port}`;
  if (/;\s*Path=\//i.test(value)) {
    return value.replace(/;\s*Path=\/([^;\s]*)/i, (_match, rest: string) => `; Path=${prefix}/${rest}`);
  }
  return `${value}; Path=${prefix}/`;
}

type ProxyRequestOptions = {
  port: number;
  upstreamPath: string;
  mountPath?: string;
  /**
   * Re-serialized body for requests Express already consumed (its global
   * json/urlencoded parsers drain the stream before the route runs).
   */
  body?: Buffer | null;
};

export type PreviewUpgradeDependencies = {
  /**
   * Authenticates a raw upgrade request (the Express authenticateToken
   * middleware never sees upgrades — they bypass the request pipeline).
   * Returns true when the request may proceed.
   */
  authenticateRequest?: (request: http.IncomingMessage) => boolean;
};

/**
 * Raw reverse proxy to localhost dev servers.
 *
 * ponytail: deliberately a plain byte-forwarding proxy — no HTML rewriting, no
 * service worker. Dev servers that emit absolute root paths need a matching
 * `base` config (e.g. vite `base`) to render under the preview prefix.
 *
 * Consumed by preview.routes.ts (HTTP) and preview.module.ts (WS upgrade).
 */
export function createPreviewProxy(dependencies: PreviewUpgradeDependencies = {}) {
  const authenticateRequest = dependencies.authenticateRequest ?? (() => true);

  return {
    /** Forwards one HTTP request/response pair to 127.0.0.1:<port>. */
    handleRequest(request: http.IncomingMessage, response: http.ServerResponse, options: ProxyRequestOptions): void {
      const { port, upstreamPath, body } = options;
      const mountPath = options.mountPath ?? PREVIEW_MOUNT_PATH;

      const headers: http.OutgoingHttpHeaders = {};
      for (const [name, value] of Object.entries(request.headers)) {
        if (HOP_BY_HOP_HEADERS.has(name)) continue;
        headers[name] = value;
      }
      // Dev servers route on Host; present the upstream's own host:port.
      headers.host = `127.0.0.1:${port}`;
      // The original client IP is more useful to dev tooling than the proxy's.
      headers['x-forwarded-for'] = request.socket.remoteAddress;
      headers['x-forwarded-host'] = request.headers.host;

      if (body !== undefined && body !== null) {
        headers['content-length'] = body.length;
      }

      const proxyRequest = http.request({
        host: '127.0.0.1',
        port,
        method: request.method,
        path: upstreamPath,
        headers,
      });

      proxyRequest.on('response', (proxyResponse) => {
        const responseHeaders: http.OutgoingHttpHeaders = {};
        for (const [name, value] of Object.entries(proxyResponse.headers)) {
          if (HOP_BY_HOP_HEADERS.has(name) || name === 'content-length' && proxyResponse.headers['transfer-encoding']) continue;
          if (name === 'location' && typeof value === 'string') {
            responseHeaders[name] = rewriteLocationHeader(value, port, mountPath);
            continue;
          }
          if (name === 'set-cookie') {
            const values = Array.isArray(value) ? value : [value as string];
            responseHeaders[name] = values.map((cookie) => rewriteSetCookiePath(cookie, port, mountPath));
            continue;
          }
          responseHeaders[name] = value;
        }

        response.writeHead(proxyResponse.statusCode ?? 502, responseHeaders);
        proxyResponse.pipe(response);
      });

      proxyRequest.on('error', () => {
        if (!response.headersSent) {
          response.writeHead(502, { 'Content-Type': 'application/json' });
        }
        response.end(JSON.stringify({ error: `Preview upstream on port ${port} is unreachable` }));
      });

      // Never leave a half-forwarded request hanging.
      request.on('aborted', () => proxyRequest.destroy());

      if (body !== undefined && body !== null) {
        proxyRequest.end(body);
      } else {
        request.pipe(proxyRequest);
      }
    },

    /**
     * Tunnels a WebSocket upgrade to the dev server (HMR, livereload). This is
     * a raw TCP splice: the HTTP request head is rewritten onto a fresh
     * connection, then both directions pipe bytes unchanged.
     */
    handleUpgrade(request: http.IncomingMessage, socket: Duplex, head: Buffer, mountPath = PREVIEW_MOUNT_PATH): void {
      const target = parsePreviewTarget(request.url ?? undefined, mountPath);
      if (!target || !isAllowedPreviewPort(target.port)) {
        writePlainError(socket, 403, 'Forbidden');
        return;
      }
      if (!authenticateRequest(request)) {
        writePlainError(socket, 401, 'Unauthorized');
        return;
      }

      const upstream = net.connect(target.port, '127.0.0.1');

      const onSocketError = () => upstream.destroy();
      socket.on('error', onSocketError);
      socket.on('close', () => upstream.destroy());

      upstream.once('error', () => {
        socket.off('error', onSocketError);
        writePlainError(socket, 502, 'Bad Gateway');
      });

      upstream.once('connect', () => {
        const lines = [`${request.method} ${target.upstreamPath} HTTP/${request.httpVersion}`];
        for (const [name, value] of Object.entries(request.headers)) {
          if (name === 'host') continue;
          const values = Array.isArray(value) ? value : [value as string];
          for (const entry of values) {
            lines.push(`${name}: ${entry}`);
          }
        }
        lines.push(`Host: 127.0.0.1:${target.port}`);
        upstream.write(lines.join('\r\n') + '\r\n\r\n');
        if (head && head.length > 0) {
          upstream.write(head);
        }
        socket.pipe(upstream);
        upstream.pipe(socket);
      });
    },
  };
}

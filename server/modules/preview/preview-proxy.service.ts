import http from 'node:http';
import net from 'node:net';
import type { Duplex } from 'node:stream';

/**
 * Mount path the preview router is registered under. Consumed by
 * preview.module.ts, whose upgrade handler needs the full prefix because raw
 * 'upgrade' requests bypass Express mounting.
 */
export const PREVIEW_MOUNT_PATH = '/api/preview';

/**
 * Name of the HttpOnly cookie that carries the JWT for preview subresource
 * requests. Consumed by preview.routes.ts (sets it), preview.module.ts
 * (reads it for upgrade auth) and this file (strips it before proxying).
 */
export const PREVIEW_AUTH_COOKIE = 'ddagent_preview_token';

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
 * ddagent's own listen port, resolved the same way the entrypoint binds it
 * (SERVER_PORT, then 3001 — the CLI normalizes PORT into SERVER_PORT before
 * index.ts binds, so a bare PORT must not shadow the real bind here).
 * Consumed by preview.routes.ts (403 message), preview.service.ts (discovery
 * exclusion) and isAllowedPreviewPort. Proxying this port would embed the app
 * inside its own preview iframe.
 */
export function selfPreviewPort(): number {
  return Number.parseInt(process.env.SERVER_PORT || '3001', 10);
}

/**
 * SSRF guard consumed by preview.routes.ts (HTTP) and handleUpgrade (WS): the
 * proxy only ever dials 127.0.0.1, so the port is the only attacker-controlled
 * part of the target. Well-known service ports (ssh, smtp, cloud metadata on
 * link-local is IP-based anyway) stay out of reach, and so does ddagent's own
 * port.
 */
export function isAllowedPreviewPort(port: number): boolean {
  return (
    Number.isInteger(port) &&
    port >= MIN_PREVIEW_PORT &&
    port <= MAX_PREVIEW_PORT &&
    port !== selfPreviewPort()
  );
}

/**
 * Parses `<mount>/<port>/<rest>` out of a raw request URL. Consumed by
 * preview.module.ts to re-dispatch upgrade requests. Returns null when the
 * URL is not a preview target.
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

/**
 * Removes one named cookie from a Cookie header value. Returns undefined when
 * nothing is left so the header is dropped entirely.
 */
function stripCookie(
  value: string | string[],
  name: string,
): string | string[] | undefined {
  const strip = (header: string) =>
    header
      .split(';')
      .map((part) => part.trim())
      .filter((part) => part !== '' && !part.startsWith(`${name}=`))
      .join('; ');
  if (Array.isArray(value)) {
    const cleaned = value.map(strip).filter((part) => part !== '');
    return cleaned.length > 0 ? cleaned : undefined;
  }
  const cleaned = strip(value);
  return cleaned === '' ? undefined : cleaned;
}

/**
 * Copies client headers for the upstream minus everything that would leak
 * ddagent's own credentials: the Authorization header and the preview-token
 * cookie would otherwise hand the session JWT to the previewed process.
 */
function sanitizeUpstreamHeaders(
  headers: http.IncomingHttpHeaders,
): http.OutgoingHttpHeaders {
  const out: http.OutgoingHttpHeaders = {};
  for (const [name, value] of Object.entries(headers)) {
    if (HOP_BY_HOP_HEADERS.has(name) || name === 'authorization') continue;
    if (name === 'cookie') {
      const cleaned = stripCookie(value as string | string[], PREVIEW_AUTH_COOKIE);
      if (cleaned !== undefined) out[name] = cleaned;
      continue;
    }
    out[name] = value;
  }
  return out;
}

/**
 * Strips the `token` query param from an upstream path — it authenticates the
 * request to ddagent and must never reach the dev server.
 */
function stripTokenParam(upstreamPath: string): string {
  const parsed = new URL(upstreamPath, 'http://localhost');
  parsed.searchParams.delete('token');
  return parsed.pathname + parsed.search;
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

      const headers = sanitizeUpstreamHeaders(request.headers);
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
      const upstreamPath = stripTokenParam(target.upstreamPath);

      const onSocketError = () => upstream.destroy();
      socket.on('error', onSocketError);
      socket.on('close', () => upstream.destroy());

      upstream.once('error', () => {
        socket.off('error', onSocketError);
        writePlainError(socket, 502, 'Bad Gateway');
      });

      upstream.once('connect', () => {
        const lines = [`${request.method} ${upstreamPath} HTTP/${request.httpVersion}`];
        // Unlike handleRequest this tunnel must relay hop-by-hop headers —
        // without Upgrade/Connection the upstream never sees a handshake.
        // Only ddagent credentials are stripped.
        for (const [name, value] of Object.entries(request.headers)) {
          if (name === 'host' || name === 'authorization') continue;
          if (name === 'cookie') {
            const cleaned = stripCookie(value as string | string[], PREVIEW_AUTH_COOKIE);
            if (cleaned === undefined) continue;
            const values = Array.isArray(cleaned) ? cleaned : [cleaned];
            for (const entry of values) {
              lines.push(`${name}: ${entry}`);
            }
            continue;
          }
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

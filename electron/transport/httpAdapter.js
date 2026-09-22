import http from 'node:http';
import { Duplex } from 'node:stream';

const DEFAULT_TIMEOUT_MS = 30_000;

/**
 * In-process stand-in for a TCP socket. The writable side receives the raw
 * HTTP response bytes that ServerResponse serializes; pushing them into the
 * readable side lets dispatch() collect them. IncomingMessage never reads the
 * socket itself (on a real server the HTTP parser feeds it) — the request body
 * is delivered via req.push() instead, so this stream carries response bytes
 * only.
 */
class MockSocket extends Duplex {
  constructor() {
    super();
    this.remoteAddress = '127.0.0.1';
    this.remoteFamily = 'IPv4';
    this.remotePort = 0;
    this.localAddress = '127.0.0.1';
    this.localPort = 0;
    this.encrypted = false;
    this.connecting = false;
  }

  _read() {}

  _write(chunk, _encoding, callback) {
    this.push(chunk);
    callback();
  }

  // net.Socket surface that Express/Node may poke at — all no-ops here.
  setTimeout() { return this; }
  setNoDelay() { return this; }
  setKeepAlive() { return this; }
  address() { return { address: this.localAddress, family: this.remoteFamily, port: this.localPort }; }
}

function normalizeRequestTarget(path) {
  if (typeof path !== 'string' || path.length === 0) return '/';
  if (path.startsWith('/')) return path;
  try {
    const url = new URL(path);
    return url.pathname + url.search;
  } catch {
    return `/${path}`;
  }
}

function toBodyBuffer(body) {
  if (body === undefined || body === null) return null;
  if (Buffer.isBuffer(body)) return body;
  if (typeof body === 'string') return Buffer.from(body, 'utf8');
  return Buffer.from(body);
}

function parseHeaderLines(lines) {
  const headers = {};
  for (const line of lines) {
    const sep = line.indexOf(':');
    if (sep === -1) continue;
    const name = line.slice(0, sep).trim().toLowerCase();
    const value = line.slice(sep + 1).trim();
    const existing = headers[name];
    if (existing === undefined) {
      headers[name] = value;
    } else if (Array.isArray(existing)) {
      existing.push(value);
    } else {
      headers[name] = [existing, value];
    }
  }
  return headers;
}

function decodeChunked(buf) {
  const chunks = [];
  let pos = 0;
  while (pos < buf.length) {
    const lineEnd = buf.indexOf('\r\n', pos);
    if (lineEnd === -1) break;
    const size = Number.parseInt(buf.subarray(pos, lineEnd).toString('latin1'), 16);
    if (!Number.isFinite(size) || size < 0) break;
    if (size === 0) break; // trailers follow — ignored
    chunks.push(buf.subarray(lineEnd + 2, lineEnd + 2 + size));
    pos = lineEnd + 2 + size + 2;
  }
  return Buffer.concat(chunks);
}

/**
 * Splits the raw HTTP response captured from the socket into status, headers,
 * and body. Interim 1xx heads (e.g. 100 Continue) are skipped. Chunked bodies
 * are de-chunked; everything else is returned verbatim. Repeated headers are
 * returned as arrays so set-cookie survives.
 */
function parseRawResponse(raw) {
  let offset = 0;
  let status = 0;
  let headers = {};

  for (;;) {
    const headEnd = raw.indexOf('\r\n\r\n', offset);
    if (headEnd === -1) {
      return { status: 502, headers: {}, body: raw };
    }
    const head = raw.subarray(offset, headEnd).toString('latin1');
    const lines = head.split('\r\n');
    const match = /^HTTP\/\d+\.\d+ (\d{3})/.exec(lines[0]);
    if (!match) {
      return { status: 502, headers: {}, body: raw };
    }
    status = Number(match[1]);
    headers = parseHeaderLines(lines.slice(1));
    offset = headEnd + 4;
    if (status < 100 || status >= 200) break;
  }

  const rest = raw.subarray(offset);
  const transferEncoding = headers['transfer-encoding'];
  const isChunked = typeof transferEncoding === 'string' && /\bchunked\b/i.test(transferEncoding);
  return { status, headers, body: isChunked ? decodeChunked(rest) : rest };
}

function errorResult(status, message) {
  return {
    status,
    headers: { 'content-type': 'application/json; charset=utf-8' },
    body: Buffer.from(JSON.stringify({ error: message }), 'utf8'),
  };
}

/**
 * Wraps an Express 4 app so callers can dispatch HTTP requests in-process —
 * no listening socket, no TCP. Each dispatch builds a real IncomingMessage and
 * ServerResponse over a MockSocket, hands them to app.handle(), and parses the
 * raw response bytes the response serializes back.
 *
 * dispatch({ method, path, headers, body }) resolves to
 *   { status: number, headers: { [name]: string | string[] }, body: Buffer }
 *
 * - `path` is the request target including query string ('/api/x?y=1');
 *   absolute URLs are reduced to path+query.
 * - `body` accepts string | Buffer | Uint8Array | undefined; content-length is
 *   set automatically when absent. content-type is the caller's job — it is
 *   what makes express.json() parse the payload.
 * - `body` in the result is ALWAYS a Buffer (empty when the route sent none);
 *   callers JSON.parse(body.toString('utf8')) when they expect JSON.
 * - Headers are the raw response headers — connection, keep-alive and
 *   transfer-encoding included. Callers bridging into a fetch Response or
 *   another transport must drop hop-by-hop headers themselves.
 * - Never rejects: handler/app exceptions and timeouts resolve to a 500/504
 *   JSON error body instead of throwing across IPC.
 *
 * Pure Node — safe to unit-test outside Electron.
 */
export function createHttpAdapter(app, { timeoutMs = DEFAULT_TIMEOUT_MS } = {}) {
  if (!app || typeof app.handle !== 'function') {
    throw new TypeError('createHttpAdapter expects an Express app (with .handle)');
  }

  return function dispatch({ method = 'GET', path = '/', headers = {}, body } = {}) {
    return new Promise((resolve) => {
      let settled = false;
      const sock = new MockSocket();

      const finish = (result) => {
        if (settled) return;
        settled = true;
        clearTimeout(timer);
        sock.destroy();
        resolve(result);
      };

      const timer = setTimeout(() => {
        res.destroy();
        finish(errorResult(504, `dispatch timed out after ${timeoutMs}ms`));
      }, timeoutMs);

      const req = new http.IncomingMessage(sock);
      req.method = String(method).toUpperCase();
      req.url = normalizeRequestTarget(path);
      req.httpVersion = '1.1';
      req.httpVersionMajor = 1;
      req.httpVersionMinor = 1;

      const reqHeaders = {};
      const rawHeaders = [];
      for (const [name, value] of Object.entries(headers || {})) {
        const lower = name.toLowerCase();
        reqHeaders[lower] = value;
        for (const v of Array.isArray(value) ? value : [value]) {
          rawHeaders.push(name, String(v));
        }
      }
      const bodyBuffer = toBodyBuffer(body);
      if (bodyBuffer && reqHeaders['content-length'] === undefined) {
        reqHeaders['content-length'] = String(bodyBuffer.length);
        rawHeaders.push('content-length', String(bodyBuffer.length));
      }
      if (reqHeaders.host === undefined) {
        reqHeaders.host = 'localhost';
        rawHeaders.push('host', 'localhost');
      }
      req.headers = reqHeaders;
      req.rawHeaders = rawHeaders;

      // Feed the body exactly like the HTTP parser would, then mark the
      // message complete. Data stays buffered until a consumer (e.g.
      // express.json -> raw-body) attaches 'data'/'end' listeners.
      if (bodyBuffer) req.push(bodyBuffer);
      req.push(null);
      req.complete = true;

      const res = new http.ServerResponse(req);
      res.assignSocket(sock);

      const chunks = [];
      sock.on('data', (chunk) => chunks.push(chunk));

      res.on('finish', () => finish(parseRawResponse(Buffer.concat(chunks))));
      res.on('close', () => {
        finish(errorResult(500, 'response closed before finishing'));
      });
      res.on('error', (err) => finish(errorResult(500, err.message)));
      sock.on('error', (err) => finish(errorResult(500, err.message)));

      try {
        app.handle(req, res);
      } catch (err) {
        finish(errorResult(500, err instanceof Error ? err.message : String(err)));
      }
    });
  };
}

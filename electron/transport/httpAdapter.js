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

function errorWebResponse(status, message) {
  return new Response(JSON.stringify({ error: message }), {
    status,
    headers: { 'content-type': 'application/json; charset=utf-8' },
  });
}

/**
 * Builds the IncomingMessage/ServerResponse pair shared by dispatch() and
 * dispatchRequest(). headerEntries is a flat [name, value] list — callers pass
 * Object.entries() for plain payloads or collect Headers.forEach() for web
 * Requests. The body is pushed into req exactly like the HTTP parser would
 * deliver it, so multipart/busyboy-style stream consumers see raw bytes.
 */
function createReqRes({ method, target, headerEntries, bodyBuffer }) {
  const sock = new MockSocket();

  const req = new http.IncomingMessage(sock);
  req.method = String(method).toUpperCase();
  req.url = normalizeRequestTarget(target);
  req.httpVersion = '1.1';
  req.httpVersionMajor = 1;
  req.httpVersionMinor = 1;

  const reqHeaders = {};
  const rawHeaders = [];
  for (const [name, value] of headerEntries) {
    const lower = name.toLowerCase();
    reqHeaders[lower] = value;
    for (const v of Array.isArray(value) ? value : [value]) {
      rawHeaders.push(name, String(v));
    }
  }
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

  if (bodyBuffer) req.push(bodyBuffer);
  req.push(null);
  req.complete = true;

  const res = new http.ServerResponse(req);
  res.assignSocket(sock);

  return { sock, req, res };
}

// Hop-by-hop / framing headers must not cross into the web Response: the
// socket bytes are already de-chunked by WireResponseParser, and a stale
// content-length would turn an early stream end into a protocol error.
const STRIPPED_RESPONSE_HEADERS = new Set([
  'connection',
  'keep-alive',
  'transfer-encoding',
  'content-length',
]);

const NULL_BODY_STATUSES = new Set([204, 205, 304]);

function toWebHeaders(rawHeaders) {
  const headers = new Headers();
  for (const [name, value] of Object.entries(rawHeaders)) {
    if (STRIPPED_RESPONSE_HEADERS.has(name)) continue;
    for (const v of Array.isArray(value) ? value : [value]) {
      try {
        headers.append(name, String(v));
      } catch {
        // Header name/value not representable in a web Headers — skip it.
      }
    }
  }
  return headers;
}

/**
 * Incremental reader for the raw HTTP/1.x bytes ServerResponse serializes onto
 * the mock socket. push() returns the decoded entity chunks contained in that
 * write; `head` is set once a final (non-1xx) head was consumed. Chunked
 * bodies are de-chunked on the fly so SSE writes surface as stream chunks
 * while they happen — the 'done' state marks the terminating 0-chunk.
 */
class WireResponseParser {
  constructor() {
    this.buf = Buffer.alloc(0);
    this.state = 'head'; // head -> identity | chunk-size -> chunk-data -> chunk-crlf | trailers -> done
    this.chunkLeft = 0;
    this.head = null; // { status, statusText, headers }
    this.malformed = false;
  }

  push(chunk) {
    const out = [];
    this.buf = this.buf.length === 0 ? chunk : Buffer.concat([this.buf, chunk]);

    for (;;) {
      if (this.state === 'done' || this.malformed) return out;

      if (this.state === 'head') {
        const headEnd = this.buf.indexOf('\r\n\r\n');
        if (headEnd === -1) return out;
        const lines = this.buf.subarray(0, headEnd).toString('latin1').split('\r\n');
        this.buf = this.buf.subarray(headEnd + 4);
        const match = /^HTTP\/\d+\.\d+ (\d{3})[ \t]*(.*)$/.exec(lines[0]);
        if (!match) {
          this.malformed = true;
          return out;
        }
        const status = Number(match[1]);
        if (status >= 100 && status < 200) continue; // interim head — keep reading
        const headers = parseHeaderLines(lines.slice(1));
        const te = headers['transfer-encoding'];
        const chunked = typeof te === 'string' && /\bchunked\b/i.test(te);
        this.state = chunked ? 'chunk-size' : 'identity';
        this.head = { status, statusText: match[2].trim(), headers };
        continue;
      }

      if (this.state === 'identity') {
        // No length bookkeeping — res 'finish' marks the end of the body.
        if (this.buf.length === 0) return out;
        out.push(this.buf);
        this.buf = Buffer.alloc(0);
        return out;
      }

      if (this.state === 'chunk-size') {
        const eol = this.buf.indexOf('\r\n');
        if (eol === -1) return out;
        const size = Number.parseInt(this.buf.subarray(0, eol).toString('latin1'), 16);
        this.buf = this.buf.subarray(eol + 2);
        if (!Number.isFinite(size) || size < 0) {
          this.malformed = true;
          return out;
        }
        if (size === 0) {
          this.state = 'trailers';
          continue;
        }
        this.chunkLeft = size;
        this.state = 'chunk-data';
        continue;
      }

      if (this.state === 'chunk-data') {
        if (this.buf.length === 0) return out;
        const take = Math.min(this.chunkLeft, this.buf.length);
        out.push(this.buf.subarray(0, take));
        this.buf = this.buf.subarray(take);
        this.chunkLeft -= take;
        if (this.chunkLeft === 0) this.state = 'chunk-crlf';
        continue;
      }

      if (this.state === 'chunk-crlf') {
        if (this.buf.length < 2) return out;
        this.buf = this.buf.subarray(2); // CRLF after chunk data
        this.state = 'chunk-size';
        continue;
      }

      // trailers — ends at the first empty line (RFC 9112 trailer section)
      const eol = this.buf.indexOf('\r\n');
      if (eol === -1) return out;
      if (eol === 0) {
        this.buf = this.buf.subarray(2);
        this.state = 'done';
        return out;
      }
      this.buf = this.buf.subarray(eol + 2);
    }
  }
}

/**
 * Wraps an Express 4 app so callers can dispatch HTTP requests in-process —
 * no listening socket, no TCP. Each dispatch builds a real IncomingMessage and
 * ServerResponse over a MockSocket, hands them to app.handle(), and parses the
 * raw response bytes the response serializes back.
 *
 * Returns { dispatch, dispatchRequest }:
 *
 * dispatch({ method, path, headers, body }) buffers the whole response and
 * resolves to
 *   { status: number, headers: { [name]: string | string[] }, body: Buffer }
 *
 * dispatchRequest(request: Request) bridges protocol.handle()'s web Request:
 * it resolves to a real web Response whose body is a ReadableStream fed by the
 * socket bytes as they are written — SSE/chunked routes stream live instead of
 * buffering to completion.
 *
 * dispatch() details:
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
 *
 * dispatchRequest() details:
 * - Method, URL (pathname+search) and headers come from the Request object;
 *   for non-GET/HEAD the raw bytes are read via request.arrayBuffer() so
 *   multipart boundaries survive intact.
 * - The returned Response resolves as soon as the app flushes headers
 *   (first write / flushHeaders / end), so SSE listeners attach before events
 *   flow. Response headers have hop-by-hop/framing fields stripped.
 * - The timeout only guards the pre-headers window — once streaming starts
 *   the route owns the lifetime (SSE stays open), like a real socket.
 *
 * - Neither entry point rejects: handler/app exceptions and timeouts resolve
 *   to a 500/504 JSON error instead of throwing across transports.
 *
 * Pure Node — safe to unit-test outside Electron.
 */
export function createHttpAdapter(app, { timeoutMs = DEFAULT_TIMEOUT_MS } = {}) {
  if (!app || typeof app.handle !== 'function') {
    throw new TypeError('createHttpAdapter expects an Express app (with .handle)');
  }

  function dispatch({ method = 'GET', path = '/', headers = {}, body } = {}) {
    return new Promise((resolve) => {
      let settled = false;
      const bodyBuffer = toBodyBuffer(body);
      const headerEntries = Object.entries(headers || {});
      const { sock, req, res } = createReqRes({
        method,
        target: path,
        headerEntries,
        bodyBuffer,
      });

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
  }

  /**
   * Web Request -> web Response variant used by the ddagent-app:// protocol
   * handler. The head resolves the Response; subsequent socket bytes are
   * de-chunked incrementally into a ReadableStream so SSE writes arrive live.
   */
  async function dispatchRequest(request) {
    const method = String(request?.method || 'GET').toUpperCase();
    const target = String(request?.url ?? '/');
    const headerEntries = [];
    if (request?.headers && typeof request.headers.forEach === 'function') {
      request.headers.forEach((value, name) => headerEntries.push([name, value]));
    }

    let bodyBuffer = null;
    if (method !== 'GET' && method !== 'HEAD' && request?.body != null) {
      try {
        bodyBuffer = Buffer.from(await request.arrayBuffer());
      } catch (err) {
        return errorWebResponse(400, `could not read request body: ${err instanceof Error ? err.message : String(err)}`);
      }
    }

    try {
      return await runStreaming(method, target, headerEntries, bodyBuffer);
    } catch (err) {
      return errorWebResponse(500, err instanceof Error ? err.message : String(err));
    }
  }

  function runStreaming(method, target, headerEntries, bodyBuffer) {
    return new Promise((resolve) => {
      const { sock, req, res } = createReqRes({ method, target, headerEntries, bodyBuffer });
      const parser = new WireResponseParser();

      let settled = false;    // head delivered (or failed) — Response resolved
      let controller = null;  // ReadableStreamController once the body streams
      let streamDone = false; // body stream closed/errored — no more enqueues

      const timer = setTimeout(() => {
        res.destroy();
        if (!settled) {
          settled = true;
          resolve(errorWebResponse(504, `dispatch timed out after ${timeoutMs}ms`));
        }
      }, timeoutMs);

      const closeStream = () => {
        if (streamDone) return;
        streamDone = true;
        try { controller?.close(); } catch { /* already settled/cancelled */ }
      };
      const failStream = (err) => {
        if (streamDone) return;
        streamDone = true;
        try { controller?.error(err); } catch { /* already settled/cancelled */ }
      };
      const failBeforeHead = (status, message) => {
        if (settled) return;
        settled = true;
        clearTimeout(timer);
        resolve(errorWebResponse(status, message));
      };

      const settleHead = () => {
        if (settled || parser.head === null) return;
        settled = true;
        clearTimeout(timer);
        const { status, statusText, headers } = parser.head;
        const webHeaders = toWebHeaders(headers);
        try {
          // 204/205/304 and HEAD must carry a null body — the Response
          // constructor throws for a stream body on those statuses.
          if (NULL_BODY_STATUSES.has(status) || method === 'HEAD') {
            streamDone = true;
            resolve(new Response(null, { status, statusText, headers: webHeaders }));
            return;
          }
          const stream = new ReadableStream({
            start(c) { controller = c; },
            cancel() {
              streamDone = true;
              res.destroy();
            },
          });
          resolve(new Response(stream, { status, statusText, headers: webHeaders }));
        } catch (err) {
          resolve(errorWebResponse(502, `could not bridge response: ${err instanceof Error ? err.message : String(err)}`));
        }
      };

      sock.on('data', (chunk) => {
        const decoded = parser.push(chunk);
        if (parser.head !== null) settleHead();
        for (const piece of decoded) {
          if (controller === null || streamDone) continue;
          try {
            controller.enqueue(new Uint8Array(piece));
          } catch {
            // consumer cancelled mid-flight — res.destroy() already ran
          }
        }
        if (parser.state === 'done') {
          closeStream();
        } else if (parser.malformed) {
          failBeforeHead(502, 'malformed HTTP response from local backend');
          failStream(new Error('malformed HTTP response from local backend'));
        }
      });

      // 'finish' fires once every socket write completed, but the pushed bytes
      // still sit in the readable queue — pushing null turns the queued data
      // into 'data' events first, then 'end' marks the true end of the body.
      res.on('finish', () => sock.push(null));
      sock.on('end', () => closeStream());

      res.on('close', () => {
        if (!settled) failBeforeHead(500, 'response closed before finishing');
        else failStream(new Error('response closed before finishing'));
      });
      res.on('error', (err) => {
        failBeforeHead(500, err.message);
        failStream(err);
      });
      sock.on('error', (err) => {
        failBeforeHead(500, err.message);
        failStream(err);
      });
      sock.on('close', () => {
        if (!settled) failBeforeHead(500, 'response socket closed before finishing');
        else closeStream();
      });

      try {
        app.handle(req, res);
      } catch (err) {
        res.destroy();
        failBeforeHead(500, err instanceof Error ? err.message : String(err));
        failStream(err);
      }
    });
  }

  return { dispatch, dispatchRequest };
}

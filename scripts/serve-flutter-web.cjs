const express = require('express');
const path = require('path');
const http = require('http');
const os = require('os');
const compression = require('compression');
const Database = require('better-sqlite3');

const app = express();
const PORT = process.env.FLUTTER_WEB_PORT || 8085;
const BACKEND_PORT = Number(process.env.FLUTTER_BACKEND_PORT || 10087);
const WEB_DIR = path.join(__dirname, '..', 'flutter', 'build', 'web');

// gzip the Flutter payload: main.dart.js is ~6.9MB and canvaskit.wasm ~7.3MB
// uncompressed (~4.7MB gzipped) — the single biggest first-load cost. Streams
// (SSE/ndjson websocket passthrough) must NOT be buffered, hence the filter.
app.use(
  compression({
    filter: (req, res) => {
      if (req.headers['x-no-compression']) return false;
      const ct = String(res.getHeader('Content-Type') || '');
      if (/event-stream|ndjson|x-ndjson/.test(ct)) return false;
      if (/^application\/wasm\b/.test(ct)) return true;
      return compression.filter(req, res);
    },
  })
);

let authDb = null;
try {
  const dbPath = process.env.DATABASE_PATH || path.join(os.homedir(), '.ddagent', 'auth.db');
  authDb = new Database(dbPath, { readonly: true, fileMustExist: true });
} catch (e) {
  console.warn('[flutter-web] Could not open auth.db:', e.message);
}

// Reverse-proxy /api/* directly to the backend
app.use('/api', (req, res) => {
  // If this is the recent sessions endpoint, enrich with lastViewedAt
  const isRecentSessions = req.url.startsWith('/providers/sessions/recent');

  const proxyReq = http.request(
    {
      hostname: '127.0.0.1',
      port: BACKEND_PORT,
      path: '/api' + req.url,
      method: req.method,
      headers: {
        ...req.headers,
        host: `127.0.0.1:${BACKEND_PORT}`,
      },
    },
    (proxyRes) => {
      if (isRecentSessions && proxyRes.statusCode === 200) {
        let rawBody = '';
        proxyRes.on('data', (chunk) => {
          rawBody += chunk;
        });
        proxyRes.on('end', () => {
          try {
            const data = JSON.parse(rawBody);
            if (data?.data?.conversations && Array.isArray(data.data.conversations)) {
              for (const conv of data.data.conversations) {
                // Newer backends send the field themselves — only fill it in
                // when the key is absent entirely, and keep a real null
                // (never viewed) so the unread dot can still appear.
                if (conv.lastViewedAt === undefined && authDb) {
                  try {
                    const row = authDb.prepare('SELECT last_viewed_at FROM sessions WHERE session_id = ?').get(conv.sessionId);
                    conv.lastViewedAt = (row && row.last_viewed_at) || null;
                  } catch (_) {}
                }
              }
            }
            const modifiedBody = JSON.stringify(data);
            const headers = { ...proxyRes.headers };
            headers['content-length'] = Buffer.byteLength(modifiedBody);
            res.writeHead(proxyRes.statusCode, headers);
            res.end(modifiedBody);
          } catch (err) {
            res.writeHead(proxyRes.statusCode, proxyRes.headers);
            res.end(rawBody);
          }
        });
        return;
      }

      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res);
    }
  );

  req.pipe(proxyReq);
  proxyReq.on('error', (err) => {
    res.status(502).json({ error: 'Backend proxy error', details: err.message });
  });
});

// The server's unauthenticated health probe lives at the root (`/health`, not
// under `/api`), but the same-origin web client calls `/health` directly for
// the version/update checks. Without this proxy it falls through to the SPA
// fallback below and returns index.html, which the client fails to decode.
app.get('/health', (req, res) => {
  const proxyReq = http.request(
    {
      hostname: '127.0.0.1',
      port: BACKEND_PORT,
      path: '/health',
      method: 'GET',
      headers: { host: `127.0.0.1:${BACKEND_PORT}` },
    },
    (proxyRes) => {
      res.writeHead(proxyRes.statusCode, proxyRes.headers);
      proxyRes.pipe(res);
    }
  );
  proxyReq.on('error', (err) => {
    res.status(502).json({ error: 'Backend proxy error', details: err.message });
  });
  proxyReq.end();
});

// Serve Flutter Web static build
app.use(express.static(WEB_DIR));

// SPA fallback: return index.html for all client-side routes
app.get('*', (req, res) => {
  res.sendFile(path.join(WEB_DIR, 'index.html'));
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`[flutter-web] Listening on http://0.0.0.0:${PORT} (proxying /api to :${BACKEND_PORT})`);
});

// WebSocket gateway passthrough — the Flutter web client resolves its sockets
// against the page origin (`ws://<host>:8085/ws`), so raw upgrades have to
// reach the backend the same way the /api proxy does. Express does not touch
// upgrades; we pipe the TCP socket manually (no extra dependency).
server.on('upgrade', (req, socket, head) => {
  const proxyReq = http.request({
    hostname: '127.0.0.1',
    port: BACKEND_PORT,
    path: req.url,
    method: req.method,
    headers: { ...req.headers, host: `127.0.0.1:${BACKEND_PORT}` },
  });
  proxyReq.on('upgrade', (proxyRes, proxySocket, proxyHead) => {
    const headerLines = [];
    for (let i = 0; i < proxyRes.rawHeaders.length; i += 2) {
      headerLines.push(`${proxyRes.rawHeaders[i]}: ${proxyRes.rawHeaders[i + 1]}`);
    }
    socket.write(`HTTP/1.1 101 Switching Protocols\r\n${headerLines.join('\r\n')}\r\n\r\n`);
    if (proxyHead && proxyHead.length > 0) proxySocket.unshift(proxyHead);
    if (head && head.length > 0) proxySocket.write(head);
    proxySocket.on('error', () => socket.destroy());
    socket.on('error', () => proxySocket.destroy());
    proxySocket.pipe(socket).pipe(proxySocket);
  });
  proxyReq.on('error', () => socket.destroy());
  proxyReq.end();
});

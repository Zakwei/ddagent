const express = require('express');
const path = require('path');
const http = require('http');
const os = require('os');
const Database = require('better-sqlite3');

const app = express();
const PORT = process.env.FLUTTER_WEB_PORT || 8085;
const BACKEND_PORT = 10087;
const WEB_DIR = path.join(__dirname, '..', 'flutter', 'build', 'web');

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

// Serve Flutter Web static build
app.use(express.static(WEB_DIR));

// SPA fallback: return index.html for all client-side routes
app.get('*', (req, res) => {
  res.sendFile(path.join(WEB_DIR, 'index.html'));
});

const server = app.listen(PORT, '0.0.0.0', () => {
  console.log(`[flutter-web] Listening on http://0.0.0.0:${PORT} (proxying /api to :${BACKEND_PORT})`);
});

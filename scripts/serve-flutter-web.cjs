const express = require('express');
const path = require('path');
const http = require('http');

const app = express();
const PORT = process.env.FLUTTER_WEB_PORT || 8085;
const BACKEND_PORT = 10087;
const WEB_DIR = path.join(__dirname, '..', 'flutter', 'build', 'web');

// Reverse-proxy /api/* directly to the backend
app.use('/api', (req, res) => {
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

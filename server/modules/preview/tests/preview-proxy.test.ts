import assert from 'node:assert/strict';
import http from 'node:http';
import type { AddressInfo } from 'node:net';
import net from 'node:net';
import test from 'node:test';

import express from 'express';

import { createPreviewProxy, isAllowedPreviewPort, parsePreviewTarget } from '../preview-proxy.service.js';
import { createPreviewRouter } from '../preview.routes.js';
import type { createPortDiscoveryService } from '../preview.service.js';

type DiscoveryStub = ReturnType<typeof createPortDiscoveryService>;

function listen(server: http.Server): Promise<number> {
  return new Promise((resolve) => {
    server.listen(0, '127.0.0.1', () => {
      resolve((server.address() as AddressInfo).port);
    });
  });
}

function close(server: http.Server): Promise<void> {
  return new Promise((resolve) => server.close(() => resolve()));
}

function request(
  port: number,
  path: string,
  options: { method?: string; body?: string; headers?: Record<string, string> } = {},
): Promise<{ status: number; headers: http.IncomingHttpHeaders; body: string }> {
  return new Promise((resolve, reject) => {
    const req = http.request(
      { host: '127.0.0.1', port, path, method: options.method ?? 'GET', headers: options.headers },
      (res) => {
        let body = '';
        res.on('data', (chunk) => (body += chunk));
        res.on('end', () => resolve({ status: res.statusCode ?? 0, headers: res.headers, body }));
      },
    );
    req.on('error', reject);
    if (options.body !== undefined) req.write(options.body);
    req.end();
  });
}

function createProxyApp(discovery?: Partial<DiscoveryStub>) {
  const stub = {
    listListeningPorts: async () => [
      { port: 5173, address: '0.0.0.0', pid: 42, processName: 'vite', cwd: '/repo' },
    ],
    ...discovery,
  } as DiscoveryStub;
  const proxy = createPreviewProxy();
  const app = express();
  app.use(express.json());
  app.use('/api/preview', createPreviewRouter(stub, proxy));
  return app;
}

test('SSRF guard allows only the 1024-65535 port range', () => {
  assert.equal(isAllowedPreviewPort(1024), true);
  assert.equal(isAllowedPreviewPort(65535), true);
  assert.equal(isAllowedPreviewPort(80), false);
  assert.equal(isAllowedPreviewPort(22), false);
  assert.equal(isAllowedPreviewPort(1023), false);
  assert.equal(isAllowedPreviewPort(65536), false);
  assert.equal(isAllowedPreviewPort(NaN), false);
});

test('parsePreviewTarget splits mount, port and upstream path', () => {
  assert.deepEqual(parsePreviewTarget('/api/preview/5173/src/main.ts?x=1'), {
    port: 5173,
    upstreamPath: '/src/main.ts?x=1',
  });
  assert.deepEqual(parsePreviewTarget('/api/preview/5173'), { port: 5173, upstreamPath: '/' });
  assert.equal(parsePreviewTarget('/api/preview/ports'), null);
  assert.equal(parsePreviewTarget('/other/5173/x'), null);
});

test('GET /ports returns the discovery result', async () => {
  const server = http.createServer(createProxyApp());
  const port = await listen(server);
  try {
    const res = await request(port, '/api/preview/ports');
    assert.equal(res.status, 200);
    assert.deepEqual(JSON.parse(res.body), {
      ports: [{ port: 5173, address: '0.0.0.0', pid: 42, processName: 'vite', cwd: '/repo' }],
    });
  } finally {
    await close(server);
  }
});

test('forwards GET/POST with path, query and JSON body to the upstream', async () => {
  const echo = http.createServer((req, res) => {
    let body = '';
    req.on('data', (chunk) => (body += chunk));
    req.on('end', () => {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify({ method: req.method, url: req.url, body, host: req.headers.host }));
    });
  });
  const echoPort = await listen(echo);
  const server = http.createServer(createProxyApp());
  const proxyPort = await listen(server);
  try {
    const get = await request(proxyPort, `/api/preview/${echoPort}/hello/world?a=1&b=2`);
    assert.equal(get.status, 200);
    assert.deepEqual(JSON.parse(get.body), {
      method: 'GET',
      url: '/hello/world?a=1&b=2',
      body: '',
      host: `127.0.0.1:${echoPort}`,
    });

    const post = await request(proxyPort, `/api/preview/${echoPort}/submit`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ hello: 'world' }),
    });
    assert.equal(post.status, 200);
    assert.deepEqual(JSON.parse(post.body), {
      method: 'POST',
      url: '/submit',
      body: '{"hello":"world"}',
      host: `127.0.0.1:${echoPort}`,
    });
  } finally {
    await close(server);
    await close(echo);
  }
});

test('SSRF: ports below 1024 and out of range are rejected with 403', async () => {
  const server = http.createServer(createProxyApp());
  const proxyPort = await listen(server);
  try {
    for (const path of ['/api/preview/80/x', '/api/preview/22/', '/api/preview/1023/x', '/api/preview/65536/x']) {
      const res = await request(proxyPort, path);
      assert.equal(res.status, 403, path);
    }
  } finally {
    await close(server);
  }
});

test('rewrites redirect Location and Set-Cookie path under the mount', async () => {
  const upstream = http.createServer((_req, res) => {
    res.writeHead(302, {
      Location: `http://127.0.0.1:${upstreamPort}/next/page`,
      'Set-Cookie': ['sid=abc; Path=/; HttpOnly', 'theme=dark'],
    });
    res.end();
  });
  const upstreamPort = await listen(upstream);
  const server = http.createServer(createProxyApp());
  const proxyPort = await listen(server);
  try {
    const res = await request(proxyPort, `/api/preview/${upstreamPort}/old`);
    assert.equal(res.status, 302);
    assert.equal(res.headers.location, `/api/preview/${upstreamPort}/next/page`);
    const cookies = res.headers['set-cookie'];
    assert.ok(Array.isArray(cookies));
    assert.equal(cookies[0], `sid=abc; Path=/api/preview/${upstreamPort}/; HttpOnly`);
    assert.equal(cookies[1], `theme=dark; Path=/api/preview/${upstreamPort}/`);
  } finally {
    await close(server);
    await close(upstream);
  }
});

test('root-relative Location is prefixed with the mount', async () => {
  const upstream = http.createServer((_req, res) => {
    res.writeHead(302, { Location: '/dashboard' });
    res.end();
  });
  const upstreamPort = await listen(upstream);
  const server = http.createServer(createProxyApp());
  const proxyPort = await listen(server);
  try {
    const res = await request(proxyPort, `/api/preview/${upstreamPort}/`);
    assert.equal(res.headers.location, `/api/preview/${upstreamPort}/dashboard`);
  } finally {
    await close(server);
    await close(upstream);
  }
});

test('unreachable upstream yields 502', async () => {
  const server = http.createServer(createProxyApp());
  const proxyPort = await listen(server);
  try {
    // Port 65000 is in range but almost certainly not listening.
    const res = await request(proxyPort, '/api/preview/65000/anything');
    assert.equal(res.status, 502);
  } finally {
    await close(server);
  }
});

test('tunnels a WebSocket upgrade end to end', async () => {
  // Upstream "ws server": completes the handshake then echoes bytes back.
  const upstream = http.createServer();
  upstream.on('upgrade', (req, socket) => {
    const key = req.headers['sec-websocket-key'];
    socket.write(
      'HTTP/1.1 101 Switching Protocols\r\n' +
        'Upgrade: websocket\r\n' +
        'Connection: Upgrade\r\n' +
        `Sec-WebSocket-Accept: ${key}-accepted\r\n\r\n`,
    );
    socket.pipe(socket); // raw echo — good enough to prove the tunnel
  });
  const upstreamPort = await listen(upstream);

  const previewProxy = createPreviewProxy({ authenticateRequest: () => true });
  const server = http.createServer();
  server.on('upgrade', (req, socket, head) => {
    previewProxy.handleUpgrade(req, socket, head);
  });
  const proxyPort = await listen(server);

  try {
    const result = await new Promise<string>((resolve, reject) => {
      const socket = net.connect(proxyPort, '127.0.0.1', () => {
        socket.write(
          `GET /api/preview/${upstreamPort}/ws HTTP/1.1\r\n` +
            `Host: 127.0.0.1:${proxyPort}\r\n` +
            'Upgrade: websocket\r\n' +
            'Connection: Upgrade\r\n' +
            'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n' +
            'Sec-WebSocket-Version: 13\r\n\r\n',
        );
      });
      let buffer = '';
      let handshaken = false;
      socket.on('data', (chunk) => {
        buffer += chunk.toString();
        if (!handshaken && buffer.includes('\r\n\r\n')) {
          handshaken = true;
          assert.ok(buffer.startsWith('HTTP/1.1 101'));
          assert.ok(buffer.includes('Sec-WebSocket-Accept: dGhlIHNhbXBsZSBub25jZQ==-accepted'));
          socket.write('ping-through-tunnel');
          buffer = '';
          return;
        }
        if (handshaken && buffer.includes('ping-through-tunnel')) {
          socket.destroy();
          resolve(buffer);
        }
      });
      socket.on('error', reject);
      setTimeout(() => reject(new Error(`ws tunnel timed out; got: ${buffer}`)), 5000);
    });
    assert.equal(result, 'ping-through-tunnel');
  } finally {
    await close(server);
    await close(upstream);
  }
});

test('rejects upgrades to disallowed ports and fails auth when configured', async () => {
  const previewProxy = createPreviewProxy({ authenticateRequest: () => false });
  const server = http.createServer();
  server.on('upgrade', (req, socket, head) => {
    previewProxy.handleUpgrade(req, socket, head);
  });
  const proxyPort = await listen(server);

  const rawUpgrade = (path: string) =>
    new Promise<string>((resolve, reject) => {
      const socket = net.connect(proxyPort, '127.0.0.1', () => {
        socket.write(
          `GET ${path} HTTP/1.1\r\nHost: x\r\nUpgrade: websocket\r\nConnection: Upgrade\r\n` +
            'Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\nSec-WebSocket-Version: 13\r\n\r\n',
        );
      });
      let buffer = '';
      socket.on('data', (chunk) => (buffer += chunk.toString()));
      socket.on('close', () => resolve(buffer));
      socket.on('error', reject);
      setTimeout(() => reject(new Error('timeout')), 5000);
    });

  try {
    assert.ok((await rawUpgrade('/api/preview/80/ws')).startsWith('HTTP/1.1 403'));
    // Authenticator says no — 401 even for a legal port.
    assert.ok((await rawUpgrade('/api/preview/65000/ws')).startsWith('HTTP/1.1 401'));
  } finally {
    await close(server);
  }
});

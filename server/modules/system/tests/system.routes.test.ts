import assert from 'node:assert/strict';
import { once } from 'node:events';
import type { AddressInfo } from 'node:net';
import { Readable } from 'node:stream';
import test from 'node:test';

import express from 'express';

import { createSystemRouter } from '../system.routes.js';

type SystemRouterArguments = Parameters<typeof createSystemRouter>;

/** Mounts the system router on a throwaway server around a stubbed update service. */
async function withSystemServer(
  updateService: Partial<SystemRouterArguments[0]>,
  run: (baseUrl: string) => Promise<void>,
): Promise<void> {
  const app = express();
  app.use(
    '/api/system',
    createSystemRouter(
      updateService as SystemRouterArguments[0],
      {} as SystemRouterArguments[1],
    ),
  );
  const server = app.listen(0);
  await once(server, 'listening');
  const { port } = server.address() as AddressInfo;
  try {
    await run(`http://127.0.0.1:${port}/api/system`);
  } finally {
    server.close();
    await once(server, 'close');
  }
}

test('latest-release passes the forwarded origin and session token to the service', async () => {
  const proxies: unknown[] = [];
  await withSystemServer({
    getLatestRelease: async (_userId, proxy) => {
      proxies.push(proxy);
      return { release: null };
    },
  }, async (baseUrl) => {
    await fetch(`${baseUrl}/latest-release`, {
      headers: {
        Authorization: 'Bearer jwt-1',
        'X-Forwarded-Host': '100.104.6.99:8085',
        'X-Forwarded-Proto': 'http',
      },
    });
    await fetch(`${baseUrl}/latest-release`);
  });
  const port = new URL((proxies[1] as { origin: string }).origin).port;
  assert.deepEqual(proxies, [
    { origin: 'http://100.104.6.99:8085', token: 'jwt-1' },
    { origin: `http://127.0.0.1:${port}`, token: null },
  ]);
});

test('release-asset rejects malformed tags and names before calling the service', async () => {
  let calls = 0;
  await withSystemServer({
    openReleaseAsset: async () => {
      calls += 1;
      return null;
    },
  }, async (baseUrl) => {
    for (const query of [
      'tag=main&name=app.apk',
      'tag=v1.2.3&name=..%2Fsecret',
      'tag=v1.2.3&name=a%2Fb.apk',
      'tag=v1.2.3',
    ]) {
      const response = await fetch(`${baseUrl}/release-asset?${query}`);
      assert.equal(response.status, 400, query);
    }
    const missing = await fetch(`${baseUrl}/release-asset?tag=v1.2.3&name=app.apk`);
    assert.equal(missing.status, 404);
  });
  assert.equal(calls, 1);
});

test('release-asset streams the asset with its type and length', async () => {
  await withSystemServer({
    openReleaseAsset: async (_userId, tag, name) => {
      assert.deepEqual([tag, name], ['v0.15.0', 'app.apk']);
      return {
        body: Readable.from([Buffer.from('APK'), Buffer.from('DATA')]),
        contentType: 'application/vnd.android.package-archive',
        contentLength: 7,
      };
    },
  }, async (baseUrl) => {
    const response = await fetch(`${baseUrl}/release-asset?tag=v0.15.0&name=app.apk`);
    assert.equal(response.status, 200);
    assert.equal(response.headers.get('content-type'), 'application/vnd.android.package-archive');
    assert.equal(response.headers.get('content-length'), '7');
    assert.match(response.headers.get('content-disposition') ?? '', /filename="app\.apk"/);
    assert.equal(await response.text(), 'APKDATA');
  });
});

import assert from 'node:assert/strict';
import { once } from 'node:events';
import type { AddressInfo } from 'node:net';
import test, { afterEach } from 'node:test';

import express, { type NextFunction, type Request, type Response } from 'express';

import type { AppPreviewTarget } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

import { appPreviewRoutes } from '../app-preview.routes.js';
import { clearAppPreviews } from '../app-preview.service.js';

type Envelope<T> = { success: boolean; data?: T; error?: { code: string; message: string } };

async function withAppPreviewServer(run: (baseUrl: string) => Promise<void>): Promise<void> {
  const app = express();
  app.use(express.json());
  app.use('/api/app-preview', appPreviewRoutes);
  app.use((error: unknown, _req: Request, res: Response, _next: NextFunction) => {
    if (error instanceof AppError) {
      res.status(error.statusCode).json({ success: false, error: { code: error.code, message: error.message } });
      return;
    }
    res.status(500).json({ success: false, error: { code: 'INTERNAL', message: String(error) } });
  });

  const server = app.listen(0);
  await once(server, 'listening');
  const { port } = server.address() as AddressInfo;
  try {
    await run(`http://127.0.0.1:${port}/api/app-preview`);
  } finally {
    server.close();
    await once(server, 'close');
  }
}

async function call<T>(url: string, init?: RequestInit): Promise<{ status: number; body: Envelope<T> }> {
  const response = await fetch(url, {
    ...init,
    headers: { 'Content-Type': 'application/json', ...(init?.headers ?? {}) },
  });
  return { status: response.status, body: (await response.json()) as Envelope<T> };
}

afterEach(() => {
  clearAppPreviews();
});

test('POST creates (201) then upserts (200), GET lists, PATCH/reload/DELETE round-trip', async () => {
  await withAppPreviewServer(async (base) => {
    const created = await call<{ preview: AppPreviewTarget; created: boolean }>(base, {
      method: 'POST',
      body: JSON.stringify({ url: 'http://localhost:8088', device: 'iphone-15-pro', title: 'Teal login' }),
    });
    assert.equal(created.status, 201);
    assert.equal(created.body.data?.created, true);
    const id = created.body.data?.preview.id as string;
    assert.equal(created.body.data?.preview.platform, 'mobile');

    const again = await call<{ created: boolean }>(base, {
      method: 'POST',
      body: JSON.stringify({ url: 'http://localhost:8088', note: 'again' }),
    });
    assert.equal(again.status, 200);
    assert.equal(again.body.data?.created, false);

    const list = await call<{ previews: AppPreviewTarget[] }>(base);
    assert.equal(list.status, 200);
    assert.equal(list.body.data?.previews.length, 1);
    assert.equal(list.body.data?.previews[0]?.note, 'again');

    const devices = await call<{ devices: Array<{ id: string }> }>(`${base}/devices`);
    assert.ok(devices.body.data?.devices.some((device) => device.id === 'pixel-8'));

    const patched = await call<{ preview: AppPreviewTarget }>(`${base}/${id}`, {
      method: 'PATCH',
      body: JSON.stringify({ orientation: 'landscape', title: null }),
    });
    assert.equal(patched.status, 200);
    assert.equal(patched.body.data?.preview.orientation, 'landscape');
    assert.equal(patched.body.data?.preview.title, 'Teal login', 'null title keeps the previous one');

    const reloaded = await call<{ preview: AppPreviewTarget }>(`${base}/${id}/reload`, { method: 'POST' });
    assert.equal(reloaded.body.data?.preview.reloadToken, 1);

    const single = await call<{ preview: AppPreviewTarget }>(`${base}/${id}`);
    assert.equal(single.body.data?.preview.reloadToken, 1);

    const removed = await call<{ removed: boolean }>(`${base}/${id}`, { method: 'DELETE' });
    assert.equal(removed.body.data?.removed, true);

    const missing = await call(`${base}/${id}`);
    assert.equal(missing.status, 404);
    assert.equal(missing.body.error?.code, 'APP_PREVIEW_NOT_FOUND');
  });
});

test('POST without url and with an unknown device answer 400', async () => {
  await withAppPreviewServer(async (base) => {
    const noUrl = await call(base, { method: 'POST', body: JSON.stringify({ title: 'x' }) });
    assert.equal(noUrl.status, 400);
    assert.equal(noUrl.body.error?.code, 'APP_PREVIEW_INVALID_INPUT');

    const badDevice = await call(base, {
      method: 'POST',
      body: JSON.stringify({ url: 'http://localhost:1', device: 'toaster' }),
    });
    assert.equal(badDevice.status, 400);
    assert.match(badDevice.body.error?.message ?? '', /Known devices/);
  });
});

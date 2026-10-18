import assert from 'node:assert/strict';
import test, { afterEach } from 'node:test';

import { connectedClients } from '@/modules/websocket/index.js';
import type { AppPreviewBroadcast, RealtimeClientConnection } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

import {
  clearAppPreviews,
  getAppPreview,
  getDefaultAppPreviewDevice,
  listAppPreviewDevices,
  listAppPreviews,
  registerAppPreview,
  reloadAppPreview,
  removeAppPreview,
  updateAppPreview,
} from '../app-preview.service.js';

/** Captures everything broadcast over `/ws` during a test. */
function captureBroadcasts(): AppPreviewBroadcast[] {
  const received: AppPreviewBroadcast[] = [];
  const client: RealtimeClientConnection = {
    readyState: 1,
    send: (data) => received.push(JSON.parse(data) as AppPreviewBroadcast),
  };
  connectedClients.add(client);
  return received;
}

afterEach(() => {
  clearAppPreviews();
  connectedClients.clear();
});

test('device catalog covers every platform and the default is its first entry', () => {
  const devices = listAppPreviewDevices();
  for (const platform of ['mobile', 'web', 'desktop'] as const) {
    const ofPlatform = devices.filter((device) => device.platform === platform);
    assert.ok(ofPlatform.length > 0, `${platform} has presets`);
    assert.equal(getDefaultAppPreviewDevice(platform).id, ofPlatform[0]?.id);
  }
  assert.equal(new Set(devices.map((device) => device.id)).size, devices.length, 'ids are unique');
  assert.ok(devices.filter((device) => device.mobile).every((device) => device.userAgent));
});

test('registerAppPreview fills defaults, normalises a bare host:port and broadcasts an upsert', () => {
  const broadcasts = captureBroadcasts();
  const { preview, created } = registerAppPreview({ url: 'localhost:5173' });

  assert.equal(created, true);
  assert.equal(preview.url, 'http://localhost:5173/');
  assert.equal(preview.title, 'localhost:5173');
  assert.equal(preview.platform, 'web');
  assert.equal(preview.device, null);
  assert.equal(preview.orientation, 'portrait');
  assert.equal(preview.reloadToken, 0);
  assert.deepEqual(listAppPreviews().map((entry) => entry.id), [preview.id]);
  assert.deepEqual(broadcasts, [{ type: 'app-preview-upserted', preview, created: true }]);
});

test('a device id implies its platform and a mismatch is rejected', () => {
  const { preview } = registerAppPreview({ url: 'http://localhost:8088', device: 'Pixel-8', title: 'Login' });
  assert.equal(preview.platform, 'mobile');
  assert.equal(preview.device, 'pixel-8');
  assert.equal(preview.title, 'Login');

  assert.throws(
    () => registerAppPreview({ url: 'http://localhost:8089', device: 'pixel-8', platform: 'desktop' }),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_INVALID_INPUT',
  );
  assert.throws(
    () => registerAppPreview({ url: 'http://localhost:8089', device: 'nokia-3310' }),
    (error: unknown) => error instanceof AppError && /Known devices/.test(error.message),
  );
  assert.throws(
    () => registerAppPreview({ url: 'ftp://files.local' }),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_INVALID_INPUT',
  );
  assert.throws(
    () => registerAppPreview({ url: 'http://localhost:8089', platform: 'watch' }),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_INVALID_INPUT',
  );
});

test('registering the same URL again updates in place instead of duplicating', () => {
  const first = registerAppPreview({ url: 'http://localhost:3000', platform: 'web' });
  const broadcasts = captureBroadcasts();
  const second = registerAppPreview({ url: 'http://localhost:3000', device: 'iphone-15-pro', note: 'after fix' });

  assert.equal(second.created, false);
  assert.equal(second.preview.id, first.preview.id);
  assert.equal(second.preview.platform, 'mobile');
  assert.equal(second.preview.device, 'iphone-15-pro');
  assert.equal(second.preview.note, 'after fix');
  assert.equal(listAppPreviews().length, 1);
  assert.equal(broadcasts.length, 1, 'one upsert broadcast, not an update plus an upsert');
  assert.equal(broadcasts[0]?.type, 'app-preview-upserted');
});

test('updateAppPreview re-validates device against platform and drops a stale device on platform switch', () => {
  const { preview } = registerAppPreview({ url: 'http://localhost:4200', device: 'ipad-pro-11' });

  const toDesktop = updateAppPreview(preview.id, { platform: 'desktop' });
  assert.equal(toDesktop.platform, 'desktop');
  assert.equal(toDesktop.device, null, 'tablet preset does not survive a desktop switch');

  const moved = updateAppPreview(preview.id, { url: 'localhost:4201', orientation: 'landscape', device: 'galaxy-s24' });
  assert.equal(moved.url, 'http://localhost:4201/');
  assert.equal(moved.orientation, 'landscape');
  assert.equal(moved.platform, 'mobile');
  assert.equal(moved.device, 'galaxy-s24');

  assert.throws(
    () => updateAppPreview(preview.id, { device: 'web-laptop', platform: 'mobile' }),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_INVALID_INPUT',
  );
  assert.throws(
    () => updateAppPreview('missing', { title: 'x' }),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_NOT_FOUND',
  );
});

test('reload bumps the token and remove broadcasts the id', () => {
  const { preview } = registerAppPreview({ url: 'http://localhost:9000' });
  const broadcasts = captureBroadcasts();

  const reloaded = reloadAppPreview(preview.id);
  assert.equal(reloaded.reloadToken, 1);
  assert.equal(getAppPreview(preview.id).reloadToken, 1);

  removeAppPreview(preview.id);
  assert.deepEqual(listAppPreviews(), []);
  assert.throws(() => getAppPreview(preview.id), (error: unknown) => error instanceof AppError && error.statusCode === 404);

  assert.deepEqual(
    broadcasts.map((entry) => entry.type),
    ['app-preview-reloaded', 'app-preview-removed'],
  );
  assert.equal((broadcasts[1] as { previewId: string }).previewId, preview.id);
});

test('the registry evicts the oldest target once the cap is reached', () => {
  for (let port = 0; port < 20; port += 1) {
    registerAppPreview({ url: `http://localhost:${10000 + port}` });
  }
  const oldest = listAppPreviews()[0];
  const broadcasts = captureBroadcasts();
  registerAppPreview({ url: 'http://localhost:20000' });

  assert.equal(listAppPreviews().length, 20);
  assert.ok(!listAppPreviews().some((entry) => entry.id === oldest?.id));
  assert.equal(broadcasts[0]?.type, 'app-preview-removed');
  assert.equal(broadcasts[1]?.type, 'app-preview-upserted');
});

test('re-stating the current platform keeps the device, a real switch drops it', () => {
  const { preview } = registerAppPreview({ url: 'http://localhost:7000', device: 'pixel-8' });
  expect(updateAppPreview(preview.id, { platform: 'mobile' }).device, 'pixel-8');
  expect(updateAppPreview(preview.id, { platform: 'web' }).device, null);
});

function expect(actual: unknown, expected: unknown): void {
  assert.equal(actual, expected);
}

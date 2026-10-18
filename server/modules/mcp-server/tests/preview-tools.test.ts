import assert from 'node:assert/strict';
import test, { afterEach } from 'node:test';

import { clearAppPreviews } from '@/modules/app-preview/index.js';
import type { AppPreviewTarget } from '@/shared/types.js';
import { AppError } from '@/shared/utils.js';

import { callMcpTool, listMcpTools } from '../mcp-tools.service.js';

type OpenResult = { preview: AppPreviewTarget; created: boolean; device: { id: string } | null; hint: string };

afterEach(() => {
  clearAppPreviews();
});

test('tools/list advertises the preview tools with the right scopes', () => {
  const tools = listMcpTools();
  const names = tools.map((tool) => tool.name);
  for (const name of ['preview_open', 'preview_update', 'preview_reload', 'preview_close', 'preview_list', 'preview_devices']) {
    assert.ok(names.includes(name), `${name} is listed`);
  }
  const open = tools.find((tool) => tool.name === 'preview_open');
  assert.deepEqual(open?.inputSchema.required, ['url']);
  assert.match(open?.description ?? '', /dev server/i);
});

test('preview_open rejects a read-scoped token while preview_list and preview_devices work', async () => {
  await assert.rejects(
    () => callMcpTool('preview_open', { url: 'http://localhost:8088' }, 'read'),
    (error: unknown) => error instanceof AppError && error.code === 'MCP_SCOPE_FORBIDDEN',
  );
  const list = (await callMcpTool('preview_list', {}, 'read')) as { previews: unknown[] };
  assert.deepEqual(list.previews, []);
  const devices = (await callMcpTool('preview_devices', {}, 'read')) as { devices: Array<{ id: string }> };
  assert.ok(devices.devices.some((device) => device.id === 'iphone-15-pro'));
});

test('preview tools open, update, reload and close a target', async () => {
  const opened = (await callMcpTool(
    'preview_open',
    { url: 'localhost:8088', device: 'iphone-15-pro', title: 'Teal login', note: 'sign-up toggle' },
    'write',
  )) as OpenResult;
  assert.equal(opened.created, true);
  assert.equal(opened.preview.url, 'http://localhost:8088/');
  assert.equal(opened.preview.platform, 'mobile');
  assert.equal(opened.device?.id, 'iphone-15-pro');
  assert.match(opened.hint, /opens automatically/);

  const reopened = (await callMcpTool('preview_open', { url: 'http://localhost:8088' }, 'write')) as OpenResult;
  assert.equal(reopened.created, false);
  assert.equal(reopened.preview.id, opened.preview.id);

  const defaulted = (await callMcpTool('preview_open', { url: 'http://localhost:5173' }, 'write')) as OpenResult;
  assert.equal(defaulted.preview.platform, 'web');
  assert.equal(defaulted.device?.id, 'web-laptop', 'default device is reported for a platform-only target');

  const updated = (await callMcpTool(
    'preview_update',
    { previewId: opened.preview.id, device: 'pixel-8', orientation: 'landscape' },
    'write',
  )) as AppPreviewTarget;
  assert.equal(updated.device, 'pixel-8');
  assert.equal(updated.orientation, 'landscape');

  const reloaded = (await callMcpTool('preview_reload', { previewId: opened.preview.id }, 'write')) as AppPreviewTarget;
  assert.equal(reloaded.reloadToken, 1);

  await callMcpTool('preview_close', { previewId: opened.preview.id }, 'write');
  const list = (await callMcpTool('preview_list', {}, 'read')) as { previews: AppPreviewTarget[] };
  assert.deepEqual(list.previews.map((preview) => preview.id), [defaulted.preview.id]);

  await assert.rejects(
    () => callMcpTool('preview_update', { previewId: opened.preview.id, title: 'gone' }, 'write'),
    (error: unknown) => error instanceof AppError && error.code === 'APP_PREVIEW_NOT_FOUND',
  );
  await assert.rejects(
    () => callMcpTool('preview_open', {}, 'write'),
    (error: unknown) => error instanceof AppError && error.code === 'MCP_INVALID_PARAMS',
  );
});

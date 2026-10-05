import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import path from 'node:path';
import test from 'node:test';

import type { WebSocket } from 'ws';

import {
  closeConnection,
  initializeDatabase,
  notificationChannelEndpointsDb,
  notificationPreferencesDb,
  userDb,
} from '@/modules/database/index.js';

import { syncChannelPreference } from '../services/channel-preferences.service.js';
import { registerDesktopNotificationClient } from '../services/desktop-notification-clients.service.js';

async function withIsolatedDatabase(runTest: () => void | Promise<void>): Promise<void> {
  const previousDatabasePath = process.env.DATABASE_PATH;
  const temporaryDirectory = await mkdtemp(path.join(tmpdir(), 'desktop-notification-clients-'));
  const databasePath = path.join(temporaryDirectory, 'auth.db');

  closeConnection();
  process.env.DATABASE_PATH = databasePath;
  await initializeDatabase();

  try {
    await runTest();
  } finally {
    closeConnection();
    if (previousDatabasePath === undefined) {
      delete process.env.DATABASE_PATH;
    } else {
      process.env.DATABASE_PATH = previousDatabasePath;
    }
    await rm(temporaryDirectory, { recursive: true, force: true });
  }
}

function fakeSocket(): WebSocket {
  return { readyState: 1, OPEN: 1, close: () => undefined } as unknown as WebSocket;
}

test('syncChannelPreference follows the enabled endpoint state', async () => {
  await withIsolatedDatabase(() => {
    const userId = Number(userDb.createUser('sync-user', 'hash').id);

    // No endpoints yet — the channel stays off.
    syncChannelPreference(userId, 'desktop');
    assert.equal(notificationPreferencesDb.getPreferences(userId).channels.desktop, false);

    notificationChannelEndpointsDb.upsertEndpoint({
      userId,
      channel: 'desktop',
      endpointId: 'device-1',
      enabled: true,
    });
    syncChannelPreference(userId, 'desktop');
    assert.equal(notificationPreferencesDb.getPreferences(userId).channels.desktop, true);

    notificationChannelEndpointsDb.setEndpointEnabled(userId, 'desktop', 'device-1', false);
    syncChannelPreference(userId, 'desktop');
    assert.equal(notificationPreferencesDb.getPreferences(userId).channels.desktop, false);
  });
});

test('registering a desktop client enables the desktop channel preference', async () => {
  await withIsolatedDatabase(() => {
    const userId = Number(userDb.createUser('register-user', 'hash').id);
    assert.equal(notificationPreferencesDb.getPreferences(userId).channels.desktop, false);

    registerDesktopNotificationClient({
      userId,
      deviceId: 'device-abc',
      label: 'Test device',
      platform: 'test',
      ws: fakeSocket(),
    });

    assert.equal(notificationPreferencesDb.getPreferences(userId).channels.desktop, true);
    assert.equal(notificationChannelEndpointsDb.getEnabledEndpoints(userId, 'desktop').length, 1);
  });
});

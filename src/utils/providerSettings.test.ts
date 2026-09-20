import assert from 'node:assert/strict';
import test from 'node:test';

import { getProviderSettingsKey, readStoredPermissionMode } from './providerSettings';

/** Minimal in-memory Storage stand-in — the util only uses getItem. */
function createStorage(initial: Record<string, string> = {}) {
  const entries = new Map(Object.entries(initial));
  return {
    getItem: (key: string) => entries.get(key) ?? null,
  };
}

test('reads the permission mode persisted by the settings tab', () => {
  const storage = createStorage({
    'devin-settings': JSON.stringify({ permissionMode: 'bypassPermissions', lastUpdated: 'x' }),
  });

  assert.equal(readStoredPermissionMode('devin', storage), 'bypassPermissions');
});

test('unset, corrupt or non-string values read as null', () => {
  const storage = createStorage({
    'opencode-settings': '{not json',
    'codex-settings': JSON.stringify({ permissionMode: 42 }),
  });

  assert.equal(readStoredPermissionMode('opencode', storage), null);
  assert.equal(readStoredPermissionMode('codex', storage), null);
  assert.equal(readStoredPermissionMode('claude', storage), null);
});

test('every provider maps to its own settings key', () => {
  assert.equal(getProviderSettingsKey('opencode'), 'opencode-settings');
  assert.equal(getProviderSettingsKey('cursor'), 'cursor-tools-settings');
});

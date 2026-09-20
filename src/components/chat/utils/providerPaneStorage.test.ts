import assert from 'node:assert/strict';
import test from 'node:test';

import { paneScopedStorageKey, readProviderSetting, writeProviderSetting } from './providerPaneStorage';

/** Minimal in-memory Storage stand-in — the util only uses get/setItem. */
function createStorage(initial: Record<string, string> = {}) {
  const entries = new Map(Object.entries(initial));
  return {
    getItem: (key: string) => entries.get(key) ?? null,
    setItem: (key: string, value: string) => void entries.set(key, value),
  };
}

test('an isolated draft pick survives a remount without rewriting the shared default', () => {
  const storage = createStorage({ 'devin-model': 'swe-2-max' });

  writeProviderSetting(storage, 'devin-model', 'deepseek-v4-1-flash-max', {
    paneId: 'pane-1',
    persistShared: false,
  });

  assert.equal(storage.getItem('devin-model'), 'swe-2-max');
  assert.equal(
    readProviderSetting(storage, 'devin-model', { paneId: 'pane-1', allowShared: false }),
    'deepseek-v4-1-flash-max',
  );
  // Once the pane owns a session the shared fallback is allowed again — the
  // pane's own pick must still win, or the draft's model would snap back to
  // the stale shared default right after the first send.
  assert.equal(
    readProviderSetting(storage, 'devin-model', { paneId: 'pane-1' }),
    'deepseek-v4-1-flash-max',
  );
});

test('another pane neither inherits an isolated pick nor its shared default', () => {
  const storage = createStorage({ 'devin-model': 'swe-2-max' });
  writeProviderSetting(storage, 'devin-model', 'deepseek-v4-1-flash-max', {
    paneId: 'pane-1',
    persistShared: false,
  });

  assert.equal(readProviderSetting(storage, 'devin-model', { paneId: 'pane-2', allowShared: false }), null);
  assert.equal(readProviderSetting(storage, 'devin-model', { paneId: 'pane-2' }), 'swe-2-max');
});

test('a non-isolated pick also becomes the shared default new chats inherit', () => {
  const storage = createStorage();

  writeProviderSetting(storage, 'devin-model', 'deepseek-v4-1-flash-max', { paneId: 'pane-1' });

  assert.equal(storage.getItem('devin-model'), 'deepseek-v4-1-flash-max');
  assert.equal(storage.getItem(paneScopedStorageKey('devin-model', 'pane-1')), 'deepseek-v4-1-flash-max');
});

test('hosts without pane identity keep the legacy single-key behaviour', () => {
  const storage = createStorage({ 'codex-model': 'gpt-5.4' });

  assert.equal(readProviderSetting(storage, 'codex-model'), 'gpt-5.4');

  writeProviderSetting(storage, 'codex-model', 'gpt-5.6', { persistShared: false });
  assert.equal(storage.getItem('codex-model'), 'gpt-5.4');

  writeProviderSetting(storage, 'codex-model', 'gpt-5.6');
  assert.equal(storage.getItem('codex-model'), 'gpt-5.6');
});

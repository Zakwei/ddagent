import AsyncStorage from '@react-native-async-storage/async-storage';
import { useCallback, useSyncExternalStore } from 'react';

import {
  DEFAULT_CLAUDE_SETTINGS,
  DEFAULT_CURSOR_SETTINGS,
  PROVIDER_SETTINGS_KEYS,
  parseClaudeSettings,
  parseCursorSettings,
  parseStoredPermissionMode,
  serializeClaudeSettings,
  serializeCursorSettings,
  serializePermissionModeSetting,
  toCodexPermissionMode,
  toProviderPermissionMode,
  type AgentProvider,
  type ClaudeSettings,
  type CodexPermissionMode,
  type CursorSettings,
  type ProviderPermissionMode,
} from './provider-settings';

type Store = {
  claude: ClaudeSettings;
  cursor: CursorSettings;
  codex: CodexPermissionMode;
  opencode: ProviderPermissionMode;
  devin: ProviderPermissionMode;
};

const initial: Store = {
  claude: { ...DEFAULT_CLAUDE_SETTINGS },
  cursor: { ...DEFAULT_CURSOR_SETTINGS },
  codex: 'default',
  opencode: 'default',
  devin: 'default',
};

let store: Store = initial;
const listeners = new Set<() => void>();

void (async () => {
  try {
    const [claude, cursor, codex, opencode, devin] = await Promise.all([
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.claude),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.cursor),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.codex),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.opencode),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.devin),
    ]);
    store = {
      claude: parseClaudeSettings(claude),
      cursor: parseCursorSettings(cursor),
      codex: toCodexPermissionMode(parseStoredPermissionMode(codex)),
      opencode: toProviderPermissionMode(parseStoredPermissionMode(opencode)),
      devin: toProviderPermissionMode(parseStoredPermissionMode(devin)),
    };
    listeners.forEach((l) => l());
  } catch {
    /* keep defaults */
  }
})();

const emit = () => listeners.forEach((l) => l());
const readStore = (): Store => store;

const subscribe = (listener: () => void) => {
  listeners.add(listener);
  return () => listeners.delete(listener);
};

function writeClaude(next: ClaudeSettings) {
  store = { ...store, claude: next };
  void AsyncStorage.setItem(PROVIDER_SETTINGS_KEYS.claude, serializeClaudeSettings(next)).catch(() => {});
  emit();
}

function writeCursor(next: CursorSettings) {
  store = { ...store, cursor: next };
  void AsyncStorage.setItem(PROVIDER_SETTINGS_KEYS.cursor, serializeCursorSettings(next)).catch(() => {});
  emit();
}

function writePermissionMode(provider: AgentProvider, mode: string) {
  const key = PROVIDER_SETTINGS_KEYS[provider];
  void AsyncStorage.setItem(key, serializePermissionModeSetting(mode)).catch(() => {});
  store = {
    ...store,
    ...(provider === 'codex' ? { codex: toCodexPermissionMode(mode) } : {}),
    ...(provider === 'opencode' ? { opencode: toProviderPermissionMode(mode) } : {}),
    ...(provider === 'devin' ? { devin: toProviderPermissionMode(mode) } : {}),
  };
  emit();
}

/** Per-provider agent settings (permissions + default permission mode). */
export function useProviderSettings() {
  const state = useSyncExternalStore(subscribe, readStore, readStore);
  const setClaude = useCallback((next: ClaudeSettings) => writeClaude(next), []);
  const setCursor = useCallback((next: CursorSettings) => writeCursor(next), []);
  const setPermissionMode = useCallback((provider: AgentProvider, mode: string) => writePermissionMode(provider, mode), []);
  return { ...state, setClaude, setCursor, setPermissionMode };
}

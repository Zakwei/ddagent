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
import {
  CODE_EDITOR_STORAGE_KEYS,
  DEFAULT_CODE_EDITOR_SETTINGS,
  parseCodeEditorSettings,
  serializeCodeEditorSettings,
  type CodeEditorSettings,
} from './appearance-settings';

type Store = {
  claude: ClaudeSettings;
  cursor: CursorSettings;
  codex: CodexPermissionMode;
  opencode: ProviderPermissionMode;
  devin: ProviderPermissionMode;
  codeEditor: CodeEditorSettings;
};

const initial: Store = {
  claude: { ...DEFAULT_CLAUDE_SETTINGS },
  cursor: { ...DEFAULT_CURSOR_SETTINGS },
  codex: 'default',
  opencode: 'default',
  devin: 'default',
  codeEditor: { ...DEFAULT_CODE_EDITOR_SETTINGS },
};

let store: Store = initial;
const listeners = new Set<() => void>();

void (async () => {
  try {
    const [claude, cursor, codex, opencode, devin, wordWrap, showMinimap, lineNumbers, fontSize] = await Promise.all([
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.claude),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.cursor),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.codex),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.opencode),
      AsyncStorage.getItem(PROVIDER_SETTINGS_KEYS.devin),
      AsyncStorage.getItem(CODE_EDITOR_STORAGE_KEYS.wordWrap),
      AsyncStorage.getItem(CODE_EDITOR_STORAGE_KEYS.showMinimap),
      AsyncStorage.getItem(CODE_EDITOR_STORAGE_KEYS.lineNumbers),
      AsyncStorage.getItem(CODE_EDITOR_STORAGE_KEYS.fontSize),
    ]);
    store = {
      claude: parseClaudeSettings(claude),
      cursor: parseCursorSettings(cursor),
      codex: toCodexPermissionMode(parseStoredPermissionMode(codex)),
      opencode: toProviderPermissionMode(parseStoredPermissionMode(opencode)),
      devin: toProviderPermissionMode(parseStoredPermissionMode(devin)),
      codeEditor: parseCodeEditorSettings({ wordWrap, showMinimap, lineNumbers, fontSize }),
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

function writeCodeEditor(next: CodeEditorSettings) {
  store = { ...store, codeEditor: next };
  const serialized = serializeCodeEditorSettings(next);
  for (const [key, value] of Object.entries(serialized)) {
    void AsyncStorage.setItem(key, value).catch(() => {});
  }
  emit();
}

/** Per-provider agent settings (permissions, default mode, code-editor prefs). */
export function useProviderSettings() {
  const state = useSyncExternalStore(subscribe, readStore, readStore);
  const setClaude = useCallback((next: ClaudeSettings) => writeClaude(next), []);
  const setCursor = useCallback((next: CursorSettings) => writeCursor(next), []);
  const setPermissionMode = useCallback((provider: AgentProvider, mode: string) => writePermissionMode(provider, mode), []);
  const setCodeEditor = useCallback((next: CodeEditorSettings) => writeCodeEditor(next), []);
  return { ...state, setClaude, setCursor, setPermissionMode, setCodeEditor };
}

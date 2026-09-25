/**
 * Per-provider settings parity with web `src/utils/providerSettings.ts` +
 * `useSettingsController` (localStorage keys + JSON shapes). Pure & Node-testable.
 */

export type AgentProvider = 'claude' | 'cursor' | 'codex' | 'opencode' | 'devin';
export type CodexPermissionMode = 'default' | 'acceptEdits' | 'bypassPermissions';
export type ProviderPermissionMode = 'default' | 'acceptEdits' | 'bypassPermissions' | 'plan';

export const PROVIDER_SETTINGS_KEYS: Record<AgentProvider, string> = {
  claude: 'claude-settings',
  cursor: 'cursor-tools-settings',
  codex: 'codex-settings',
  opencode: 'opencode-settings',
  devin: 'devin-settings',
};

export const PROVIDER_SETTINGS_CHANGED_EVENT = 'provider-settings-changed';

export const getProviderSettingsKey = (provider: AgentProvider): string => PROVIDER_SETTINGS_KEYS[provider];

export interface ClaudeSettings {
  allowedTools: string[];
  disallowedTools: string[];
  skipPermissions: boolean;
}

export interface CursorSettings {
  allowedCommands: string[];
  disallowedCommands: string[];
  skipPermissions: boolean;
}

export const DEFAULT_CLAUDE_SETTINGS: ClaudeSettings = { allowedTools: [], disallowedTools: [], skipPermissions: false };
export const DEFAULT_CURSOR_SETTINGS: CursorSettings = { allowedCommands: [], disallowedCommands: [], skipPermissions: false };

export const COMMON_CLAUDE_TOOLS = [
  'Bash(git log:*)',
  'Bash(git diff:*)',
  'Bash(git status:*)',
  'Write',
  'Read',
  'Edit',
  'Glob',
  'Grep',
  'MultiEdit',
  'Task',
  'TodoWrite',
  'TodoRead',
  'WebFetch',
  'WebSearch',
];

export const COMMON_CURSOR_COMMANDS = [
  'Shell(ls)',
  'Shell(mkdir)',
  'Shell(cd)',
  'Shell(cat)',
  'Shell(echo)',
  'Shell(git status)',
  'Shell(git diff)',
  'Shell(git log)',
  'Shell(npm install)',
  'Shell(npm run)',
  'Shell(python)',
  'Shell(node)',
];

/** Fallback permission-mode lists per provider (web `permissionModes.ts`). */
export const FALLBACK_PERMISSION_MODES: Record<AgentProvider, ProviderPermissionMode[]> = {
  claude: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  cursor: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  codex: ['default', 'acceptEdits', 'bypassPermissions'],
  opencode: ['default', 'acceptEdits', 'bypassPermissions', 'plan'],
  devin: ['default', 'acceptEdits', 'bypassPermissions'],
};

export function toCodexPermissionMode(value: unknown): CodexPermissionMode {
  return value === 'acceptEdits' || value === 'bypassPermissions' ? value : 'default';
}

export function toProviderPermissionMode(value: unknown): ProviderPermissionMode {
  return value === 'acceptEdits' || value === 'bypassPermissions' || value === 'plan' ? value : 'default';
}

function toStringArray(value: unknown): string[] {
  return Array.isArray(value) ? value.filter((v): v is string => typeof v === 'string') : [];
}

export function parseClaudeSettings(raw: string | null): ClaudeSettings {
  if (!raw) return { ...DEFAULT_CLAUDE_SETTINGS };
  try {
    const parsed = JSON.parse(raw) as Record<string, unknown>;
    return {
      allowedTools: toStringArray(parsed.allowedTools),
      disallowedTools: toStringArray(parsed.disallowedTools),
      skipPermissions: parsed.skipPermissions === true,
    };
  } catch {
    return { ...DEFAULT_CLAUDE_SETTINGS };
  }
}

export function parseCursorSettings(raw: string | null): CursorSettings {
  if (!raw) return { ...DEFAULT_CURSOR_SETTINGS };
  try {
    const parsed = JSON.parse(raw) as Record<string, unknown>;
    return {
      allowedCommands: toStringArray(parsed.allowedCommands),
      disallowedCommands: toStringArray(parsed.disallowedCommands),
      skipPermissions: parsed.skipPermissions === true,
    };
  } catch {
    return { ...DEFAULT_CURSOR_SETTINGS };
  }
}

export function serializeClaudeSettings(settings: ClaudeSettings): string {
  return JSON.stringify({ ...settings, lastUpdated: new Date().toISOString() });
}

export function serializeCursorSettings(settings: CursorSettings): string {
  return JSON.stringify({ ...settings, lastUpdated: new Date().toISOString() });
}

export function parseStoredPermissionMode(raw: string | null): string | null {
  if (!raw) return null;
  try {
    const parsed = JSON.parse(raw) as { permissionMode?: unknown };
    return typeof parsed.permissionMode === 'string' ? parsed.permissionMode : null;
  } catch {
    return null;
  }
}

export function serializePermissionModeSetting(mode: string): string {
  return JSON.stringify({ permissionMode: mode, lastUpdated: new Date().toISOString() });
}

export function addUnique(list: string[], value: string): string[] {
  const trimmed = value.trim();
  if (!trimmed || list.includes(trimmed)) return list;
  return [...list, trimmed];
}

export function removeValue(list: string[], value: string): string[] {
  return list.filter((v) => v !== value);
}

/** Best-effort browser-like event so composer handlers can re-resolve defaults. */
export function emitProviderSettingsChanged(): void {
  const g = globalThis as unknown as { dispatchEvent?: (e: unknown) => void; Event?: new (t: string) => unknown };
  if (typeof g.dispatchEvent === 'function' && typeof g.Event === 'function') {
    try {
      g.dispatchEvent(new g.Event(PROVIDER_SETTINGS_CHANGED_EVENT));
    } catch {
      /* no-op */
    }
  }
}

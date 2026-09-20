import type { LLMProvider } from '../types/app';

/**
 * localStorage keys holding each provider's persisted settings blob, written
 * by Settings → Agents and read by the chat composer.
 */
const PROVIDER_SETTINGS_KEYS: Record<LLMProvider, string> = {
  claude: 'claude-settings',
  cursor: 'cursor-tools-settings',
  codex: 'codex-settings',
  opencode: 'opencode-settings',
  devin: 'devin-settings',
};

/**
 * Fired on `window` after Settings → Agents persists a provider's settings.
 * Open chat panes re-resolve their permission-mode default from it.
 */
export const PROVIDER_SETTINGS_CHANGED_EVENT = 'provider-settings-changed';

export const getProviderSettingsKey = (provider: LLMProvider): string => PROVIDER_SETTINGS_KEYS[provider];

/**
 * Reads the permission mode persisted by Settings → Agents for one provider.
 * Returns null when unset or unreadable; callers validate the value against
 * the provider's supported modes.
 */
export function readStoredPermissionMode(
  provider: LLMProvider,
  storage: Pick<Storage, 'getItem'> = globalThis.localStorage,
): string | null {
  try {
    const raw = storage.getItem(PROVIDER_SETTINGS_KEYS[provider]);
    if (!raw) {
      return null;
    }

    const parsed = JSON.parse(raw) as { permissionMode?: unknown };
    return typeof parsed.permissionMode === 'string' ? parsed.permissionMode : null;
  } catch {
    return null;
  }
}

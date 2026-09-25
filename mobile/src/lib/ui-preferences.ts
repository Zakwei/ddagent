/**
 * Pure mirror of the web `useUiPreferences` defaults/parsing so the same six
 * user preferences survive a native port. Storage is injected by the caller.
 */
export interface UiPreferences {
  showRawParameters: boolean;
  showThinking: boolean;
  sendByCtrlEnter: boolean;
  sidebarVisible: boolean;
  focusFollowsPointer: boolean;
  preventSleep: boolean;
}

export const UI_PREFERENCES_STORAGE_KEY = 'uiPreferences';

export const UI_PREFERENCES_DEFAULTS: UiPreferences = {
  showRawParameters: false,
  showThinking: true,
  sendByCtrlEnter: false,
  sidebarVisible: true,
  focusFollowsPointer: false,
  preventSleep: false,
};

export const UI_PREFERENCE_KEYS = Object.keys(
  UI_PREFERENCES_DEFAULTS,
) as (keyof UiPreferences)[];

export function parseBoolean(value: unknown, fallback: boolean): boolean {
  if (typeof value === 'boolean') return value;
  if (value === 'true') return true;
  if (value === 'false') return false;
  return fallback;
}

/** Reads a persisted JSON blob into a complete, validated preference set. */
export function parseUiPreferences(raw: string | null | undefined): UiPreferences {
  if (!raw) return { ...UI_PREFERENCES_DEFAULTS };
  try {
    const parsed = JSON.parse(raw);
    if (!parsed || typeof parsed !== 'object' || Array.isArray(parsed)) {
      return { ...UI_PREFERENCES_DEFAULTS };
    }
    const record = parsed as Record<string, unknown>;
    return UI_PREFERENCE_KEYS.reduce((acc, key) => {
      acc[key] = parseBoolean(record[key], UI_PREFERENCES_DEFAULTS[key]);
      return acc;
    }, { ...UI_PREFERENCES_DEFAULTS });
  } catch {
    return { ...UI_PREFERENCES_DEFAULTS };
  }
}

export function serializeUiPreferences(prefs: UiPreferences): string {
  return JSON.stringify(prefs);
}

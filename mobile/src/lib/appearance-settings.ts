/**
 * Code-editor appearance prefs parity with web `useSettingsController` /
 * `AppearanceSettingsTab` (localStorage keys `codeEditorWordWrap` /
 * `codeEditorShowMinimap` / `codeEditorLineNumbers` / `codeEditorFontSize`).
 * Project sort order is owned by the provider-settings store (it lives inside
 * the `claude-settings` JSON blob). Pure & Node-testable.
 */

export interface CodeEditorSettings {
  wordWrap: boolean;
  showMinimap: boolean;
  lineNumbers: boolean;
  fontSize: string;
}

export const CODE_EDITOR_STORAGE_KEYS = {
  wordWrap: 'codeEditorWordWrap',
  showMinimap: 'codeEditorShowMinimap',
  lineNumbers: 'codeEditorLineNumbers',
  fontSize: 'codeEditorFontSize',
} as const;

export const DEFAULT_CODE_EDITOR_SETTINGS: CodeEditorSettings = {
  wordWrap: false,
  showMinimap: true,
  lineNumbers: true,
  fontSize: '14',
};

export const CODE_EDITOR_FONT_SIZES = ['10', '11', '12', '13', '14', '15', '16', '18', '20'];

/** Web stores wordWrap as `=== 'true'`, minimap/lineNumbers as `!== 'false'`. */
export function parseCodeEditorSettings(values: {
  wordWrap?: string | null;
  showMinimap?: string | null;
  lineNumbers?: string | null;
  fontSize?: string | null;
}): CodeEditorSettings {
  const fontSize = values.fontSize && CODE_EDITOR_FONT_SIZES.includes(values.fontSize)
    ? values.fontSize
    : DEFAULT_CODE_EDITOR_SETTINGS.fontSize;
  return {
    wordWrap: values.wordWrap === 'true',
    showMinimap: values.showMinimap !== 'false',
    lineNumbers: values.lineNumbers !== 'false',
    fontSize,
  };
}

export function serializeCodeEditorSettings(settings: CodeEditorSettings): Record<string, string> {
  return {
    [CODE_EDITOR_STORAGE_KEYS.wordWrap]: String(settings.wordWrap),
    [CODE_EDITOR_STORAGE_KEYS.showMinimap]: String(settings.showMinimap),
    [CODE_EDITOR_STORAGE_KEYS.lineNumbers]: String(settings.lineNumbers),
    [CODE_EDITOR_STORAGE_KEYS.fontSize]: settings.fontSize,
  };
}

export interface SortableProject {
  displayName?: string;
  name?: string;
  id: string;
  isStarred?: boolean;
  updatedAt?: string;
  lastActivity?: string;
}

export type ProjectSortOrder = 'name' | 'date';

/**
 * Web `sortProjects`: starred first, then alphabetical (default) or most-recent
 * activity. Native project lists carry no session dates, so `date` falls back to
 * `updatedAt`/`lastActivity` and then to the input order.
 */
export function sortProjectList<T extends SortableProject>(projects: T[], order: ProjectSortOrder): T[] {
  return [...projects].sort((a, b) => {
    const aStarred = Boolean(a.isStarred);
    const bStarred = Boolean(b.isStarred);
    if (aStarred !== bStarred) return aStarred ? -1 : 1;
    if (order === 'date') {
      const at = Date.parse(a.lastActivity ?? a.updatedAt ?? '') || 0;
      const bt = Date.parse(b.lastActivity ?? b.updatedAt ?? '') || 0;
      if (at !== bt) return bt - at;
    }
    const an = a.displayName ?? a.name ?? a.id;
    const bn = b.displayName ?? b.name ?? b.id;
    return an.localeCompare(bn);
  });
}

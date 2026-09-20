/**
 * Pane-scoped storage for the per-provider model/effort picks.
 *
 * A draft pane in a split workspace must not leak its pick into the other
 * panes' drafts, but the pick still has to outlive the pane's React state: a
 * remount (layout restore, reload) used to drop it and silently fall back to
 * the shared per-provider default — the way a Devin draft came back on
 * SWE-2 Max after the user had picked DeepSeek. Pane identity is persisted
 * with the workspace, so `<key>:pane:<paneId>` is the durable copy while the
 * plain key stays the shared default new chats inherit.
 */

type StorageReader = Pick<Storage, 'getItem'>;
type StorageWriter = Pick<Storage, 'setItem'>;

/** Storage key holding one pane's own copy of a provider setting. */
export function paneScopedStorageKey(baseKey: string, paneId?: string | null): string {
  return paneId ? `${baseKey}:pane:${paneId}` : baseKey;
}

/**
 * Reads one provider setting for a pane. The pane's own pick wins over the
 * shared default; `allowShared: false` (an isolated draft pane) skips the
 * shared fallback so another pane's pick cannot bleed into this draft.
 */
export function readProviderSetting(
  storage: StorageReader,
  baseKey: string,
  options: { paneId?: string | null; allowShared?: boolean } = {},
): string | null {
  const paneValue = storage.getItem(paneScopedStorageKey(baseKey, options.paneId));
  if (paneValue) return paneValue;
  return options.allowShared === false ? null : storage.getItem(baseKey);
}

/**
 * Writes one provider setting for a pane. `persistShared: false` (an isolated
 * draft pane) keeps the pick pane-local instead of rewriting the shared
 * default, and hosts without pane identity write nothing in that mode.
 */
export function writeProviderSetting(
  storage: StorageWriter,
  baseKey: string,
  value: string,
  options: { paneId?: string | null; persistShared?: boolean } = {},
): void {
  if (options.paneId) storage.setItem(paneScopedStorageKey(baseKey, options.paneId), value);
  if (options.persistShared !== false) storage.setItem(baseKey, value);
}

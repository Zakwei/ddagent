/**
 * User-driven expand/collapse state for tool UI (bash output, "show more"
 * blocks, grouped tool runs), kept outside React state so it survives tile
 * switches, message pagination and pane remounts.
 *
 * Keys are `${sessionId}:${toolId}` when both are known — tool call ids are
 * already unique, the session prefix only guards against provider id formats
 * that could collide across sessions. Entries live for the page lifetime and
 * are intentionally not persisted to storage.
 */

const expansionState = new Map<string, boolean>();

export function buildToolExpansionKey(sessionId?: string | null, toolId?: string | null): string | null {
  if (!toolId) {
    return null;
  }
  return `${sessionId ?? ''}:${toolId}`;
}

/**
 * Returns the user's remembered choice for `key`, or `undefined` when they
 * never toggled it — callers keep their default-open behavior in that case.
 */
export function getToolExpansion(key: string | null | undefined): boolean | undefined {
  if (!key) {
    return undefined;
  }
  return expansionState.get(key);
}

export function setToolExpansion(key: string | null | undefined, expanded: boolean): void {
  if (!key) {
    return;
  }
  expansionState.set(key, expanded);
}

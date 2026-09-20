import { useCallback, useMemo, useSyncExternalStore } from 'react';

const STORAGE_KEY = 'ddagent_pinned_files';

type PinnedFilesMap = Record<string, string[]>;

const EMPTY_MAP: PinnedFilesMap = {};
const EMPTY_LIST: string[] = [];

let store: PinnedFilesMap | null = null;
const listeners = new Set<() => void>();

const readStore = (): PinnedFilesMap => {
  if (store) {
    return store;
  }
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    const parsed = raw ? JSON.parse(raw) : null;
    store = parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? (parsed as PinnedFilesMap) : {};
  } catch {
    // localStorage can be unavailable (SSR, private mode, quota); fall back to memory.
    store = {};
  }
  return store;
};

const writeStore = (next: PinnedFilesMap) => {
  store = next;
  try {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(next));
  } catch {
    // Keep the in-memory store usable even when persistence fails.
  }
  listeners.forEach((listener) => listener());
};

const subscribe = (listener: () => void) => {
  listeners.add(listener);
  return () => {
    listeners.delete(listener);
  };
};

const getServerSnapshot = (): PinnedFilesMap => EMPTY_MAP;

/**
 * Pinned file paths per project, persisted in localStorage under
 * `ddagent_pinned_files` and shared across every hook instance in the tab.
 */
export function usePinnedFiles(projectId?: string) {
  const storeSnapshot = useSyncExternalStore(subscribe, readStore, getServerSnapshot);

  const pinnedFiles = useMemo(
    () => (projectId ? storeSnapshot[projectId] ?? EMPTY_LIST : EMPTY_LIST),
    [storeSnapshot, projectId],
  );

  const pinFile = useCallback(
    (path: string) => {
      if (!projectId || !path) {
        return;
      }
      const current = readStore();
      const list = current[projectId] ?? EMPTY_LIST;
      if (list.includes(path)) {
        return;
      }
      writeStore({ ...current, [projectId]: [...list, path] });
    },
    [projectId],
  );

  const unpinFile = useCallback(
    (path: string) => {
      if (!projectId) {
        return;
      }
      const current = readStore();
      const list = current[projectId];
      if (!list || !list.includes(path)) {
        return;
      }
      const remaining = list.filter((pinned) => pinned !== path);
      const next = { ...current };
      if (remaining.length > 0) {
        next[projectId] = remaining;
      } else {
        delete next[projectId];
      }
      writeStore(next);
    },
    [projectId],
  );

  const isPinned = useCallback((path: string) => pinnedFiles.includes(path), [pinnedFiles]);

  return { pinnedFiles, pinFile, unpinFile, isPinned };
}

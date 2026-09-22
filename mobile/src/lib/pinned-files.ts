import AsyncStorage from '@react-native-async-storage/async-storage';
import { useCallback, useSyncExternalStore } from 'react';

const STORAGE_KEY = 'ddagent_pinned_files';

type PinnedFilesMap = Record<string, string[]>;

const EMPTY_LIST: string[] = [];

let store: PinnedFilesMap | null = null;
const listeners = new Set<() => void>();

const readStore = (): PinnedFilesMap => store ?? {};

// AsyncStorage hydration happens once on first use; a write afterwards persists.
void AsyncStorage.getItem(STORAGE_KEY).then((raw) => {
  try {
    const parsed = raw ? JSON.parse(raw) : null;
    store = parsed && typeof parsed === 'object' && !Array.isArray(parsed) ? (parsed as PinnedFilesMap) : {};
  } catch {
    store = {};
  }
  listeners.forEach((listener) => listener());
});

const writeStore = (next: PinnedFilesMap) => {
  store = next;
  void AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next)).catch(() => {});
  listeners.forEach((listener) => listener());
};

const subscribe = (listener: () => void) => {
  listeners.add(listener);
  return () => listeners.delete(listener);
};

/**
 * Pinned file paths per project, persisted in AsyncStorage. Mirrors the web
 * `usePinnedFiles` — pins are merged into the outgoing message as a
 * "Pinned files:" list prefix.
 */
export function usePinnedFiles(projectId?: string) {
  const map = useSyncExternalStore(subscribe, readStore, readStore);
  const pinnedFiles = projectId ? (map[projectId] ?? EMPTY_LIST) : EMPTY_LIST;

  const pinFile = useCallback(
    (path: string) => {
      if (!projectId || !path.trim()) return;
      const current = readStore()[projectId] ?? EMPTY_LIST;
      if (current.includes(path)) return;
      writeStore({ ...readStore(), [projectId]: [...current, path] });
    },
    [projectId],
  );

  const unpinFile = useCallback(
    (path: string) => {
      if (!projectId) return;
      const current = readStore()[projectId] ?? EMPTY_LIST;
      writeStore({ ...readStore(), [projectId]: current.filter((p) => p !== path) });
    },
    [projectId],
  );

  const isPinned = useCallback((path: string) => pinnedFiles.includes(path), [pinnedFiles]);

  return { pinnedFiles, pinFile, unpinFile, isPinned };
}

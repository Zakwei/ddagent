import AsyncStorage from '@react-native-async-storage/async-storage';
import { useCallback, useSyncExternalStore } from 'react';

import { parsePinnedSessions, sortSessionsWithPinned, togglePinnedIn } from './session-picker';

const STORAGE_KEY = 'ddagent_pinned_sessions';

let store: string[] | null = null;
const listeners = new Set<() => void>();

const readStore = (): string[] => store ?? [];

// AsyncStorage hydration happens once on first use; a write afterwards persists.
void AsyncStorage.getItem(STORAGE_KEY).then((raw) => {
  store = parsePinnedSessions(raw);
  listeners.forEach((listener) => listener());
});

const writeStore = (next: string[]) => {
  store = next;
  void AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(next)).catch(() => {});
  listeners.forEach((listener) => listener());
};

const subscribe = (listener: () => void) => {
  listeners.add(listener);
  return () => listeners.delete(listener);
};

/**
 * Pinned sessions, persisted in AsyncStorage. Mirrors the web
 * `ddagent_pinned_sessions` key + `usePinnedSessions` API.
 */
export function usePinnedSessions() {
  const pinnedSessionIds = useSyncExternalStore(subscribe, readStore, readStore);

  const isSessionPinned = useCallback((id: string) => pinnedSessionIds.includes(id), [pinnedSessionIds]);

  const toggleSessionPinned = useCallback((id: string) => {
    const { list, pinned } = togglePinnedIn(readStore(), id);
    writeStore(list);
    return pinned;
  }, []);

  return { pinnedSessionIds, isSessionPinned, toggleSessionPinned };
}

export { sortSessionsWithPinned };

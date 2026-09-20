import { useCallback, useSyncExternalStore } from 'react';

export const PINNED_SESSIONS_STORAGE_KEY = 'ddagent_pinned_sessions';
export const PINNED_SESSIONS_CHANGED_EVENT = 'ddagent-pinned-sessions-changed';

const EMPTY_SET: ReadonlySet<string> = new Set<string>();

let memorySet: Set<string> | null = null;
let lastRaw: string | null = null;
const listeners = new Set<() => void>();

function notifyListeners(): void {
  listeners.forEach((listener) => {
    try {
      listener();
    } catch {
      // ignore listener errors
    }
  });
}

function getStorage(): Storage | null {
  if (typeof window !== 'undefined' && window.localStorage) {
    return window.localStorage;
  }
  if (typeof localStorage !== 'undefined') {
    return localStorage;
  }
  return null;
}

function readStorage(): Set<string> {
  const storage = getStorage();
  if (!storage) {
    if (!memorySet) {
      memorySet = new Set<string>();
    }
    return memorySet;
  }

  try {
    const raw = storage.getItem(PINNED_SESSIONS_STORAGE_KEY);
    if (raw === lastRaw && memorySet !== null) {
      return memorySet;
    }
    lastRaw = raw;
    if (!raw) {
      memorySet = new Set<string>();
      return memorySet;
    }
    const parsed = JSON.parse(raw);
    if (Array.isArray(parsed)) {
      memorySet = new Set<string>(
        parsed.filter((id): id is string => typeof id === 'string' && id.length > 0),
      );
    } else {
      memorySet = new Set<string>();
    }
  } catch {
    if (!memorySet) {
      memorySet = new Set<string>();
    }
  }
  return memorySet;
}

function writeStorage(nextSet: Set<string>): void {
  memorySet = nextSet;
  const list = Array.from(nextSet);
  const raw = JSON.stringify(list);
  lastRaw = raw;

  const storage = getStorage();
  try {
    storage?.setItem(PINNED_SESSIONS_STORAGE_KEY, raw);
  } catch {
    // Keep in-memory store usable even if storage fails or is quota-blocked
  }

  if (typeof window !== 'undefined') {
    try {
      window.dispatchEvent(new Event(PINNED_SESSIONS_CHANGED_EVENT));
    } catch {
      // ignore
    }
  }

  notifyListeners();
}

export function getPinnedSessionIds(): Set<string> {
  return new Set(readStorage());
}

export function isSessionPinned(sessionId: string): boolean {
  if (!sessionId || typeof sessionId !== 'string') {
    return false;
  }
  return readStorage().has(sessionId);
}

export function toggleSessionPinned(sessionId: string): boolean {
  if (!sessionId || typeof sessionId !== 'string') {
    return false;
  }
  const current = new Set(readStorage());
  const willPin = !current.has(sessionId);
  if (willPin) {
    current.add(sessionId);
  } else {
    current.delete(sessionId);
  }
  writeStorage(current);
  return willPin;
}

export function sortSessionsWithPinned<T extends { id: string | number }>(
  sessions: T[],
  isPinned: (sessionId: string) => boolean,
): T[] {
  if (!sessions || sessions.length <= 1) {
    return sessions;
  }
  const pinned: T[] = [];
  const unpinned: T[] = [];
  for (const session of sessions) {
    if (isPinned(String(session.id))) {
      pinned.push(session);
    } else {
      unpinned.push(session);
    }
  }
  return [...pinned, ...unpinned];
}

// Setup event listeners for cross-tab or external event changes
if (typeof window !== 'undefined') {
  const handleExternalEvent = (event?: StorageEvent | Event) => {
    if (event && 'key' in event && event.key !== null && event.key !== PINNED_SESSIONS_STORAGE_KEY) {
      return;
    }
    const storage = getStorage();
    const currentRaw = storage?.getItem(PINNED_SESSIONS_STORAGE_KEY) ?? null;
    if (currentRaw !== lastRaw) {
      lastRaw = null;
      readStorage();
      notifyListeners();
    }
  };

  window.addEventListener(PINNED_SESSIONS_CHANGED_EVENT, handleExternalEvent);
  window.addEventListener('storage', handleExternalEvent as EventListener);
}

const subscribe = (listener: () => void): (() => void) => {
  listeners.add(listener);
  return () => {
    listeners.delete(listener);
  };
};

const getSnapshot = (): Set<string> => readStorage();
const getServerSnapshot = (): ReadonlySet<string> => EMPTY_SET;

export function usePinnedSessions() {
  const pinnedSessionIds = useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot);

  const checkPinned = useCallback(
    (sessionId: string) => (sessionId ? pinnedSessionIds.has(sessionId) : false),
    [pinnedSessionIds],
  );

  return {
    pinnedSessionIds,
    isSessionPinned: checkPinned,
    toggleSessionPinned,
  };
}

export function _resetForTests(): void {
  memorySet = null;
  lastRaw = null;
  listeners.clear();
}

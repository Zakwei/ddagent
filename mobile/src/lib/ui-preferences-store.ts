import AsyncStorage from '@react-native-async-storage/async-storage';
import { useCallback, useSyncExternalStore } from 'react';

import {
  UI_PREFERENCES_DEFAULTS,
  UI_PREFERENCES_STORAGE_KEY,
  parseUiPreferences,
  serializeUiPreferences,
  type UiPreferences,
} from './ui-preferences';

let store: UiPreferences = { ...UI_PREFERENCES_DEFAULTS };
const listeners = new Set<() => void>();

void AsyncStorage.getItem(UI_PREFERENCES_STORAGE_KEY).then((raw) => {
  store = parseUiPreferences(raw);
  listeners.forEach((listener) => listener());
});

const readStore = (): UiPreferences => store;

const writeStore = (next: UiPreferences) => {
  store = next;
  void AsyncStorage.setItem(UI_PREFERENCES_STORAGE_KEY, serializeUiPreferences(next)).catch(() => {});
  listeners.forEach((listener) => listener());
};

const subscribe = (listener: () => void) => {
  listeners.add(listener);
  return () => listeners.delete(listener);
};

/** Native UI preferences store (AsyncStorage), shared across screens. */
export function useUiPreferences() {
  const preferences = useSyncExternalStore(subscribe, readStore, readStore);

  const setPreference = useCallback(
    (key: keyof UiPreferences, value: boolean) => {
      writeStore({ ...readStore(), [key]: value });
    },
    [],
  );

  return { preferences, setPreference };
}

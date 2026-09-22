import AsyncStorage from '@react-native-async-storage/async-storage';
import { normalizeServerUrl, wsBaseFor } from './server-url';

const STORAGE_KEY = 'ddagent.serverUrl';

let cachedUrl: string | null = null;

export { normalizeServerUrl };

/** Synchronous read for polyfills (fetch wrapper, window.location). */
export const getServerUrlSync = (): string | null => cachedUrl;

/** Hydrates the cached URL from storage; call once at bootstrap. */
export const loadServerUrl = async (): Promise<string | null> => {
  const stored = await AsyncStorage.getItem(STORAGE_KEY);
  cachedUrl = stored ? normalizeServerUrl(stored) : null;
  return cachedUrl;
};

export const setServerUrl = async (raw: string): Promise<string> => {
  const normalized = normalizeServerUrl(raw);
  cachedUrl = normalized || null;
  if (normalized) {
    await AsyncStorage.setItem(STORAGE_KEY, normalized);
  } else {
    await AsyncStorage.removeItem(STORAGE_KEY);
  }
  return normalized;
};

export const clearServerUrl = () => setServerUrl('');

/** WS base for the configured http(s) server URL. */
export const getWsBase = (): string | null => (cachedUrl ? wsBaseFor(cachedUrl) : null);

export interface ServerProbe {
  ok: boolean;
  error?: string;
}

/** GET /api/auth/status — verifies the URL points at a ddagent server. */
export const testConnection = async (raw: string): Promise<ServerProbe> => {
  const base = normalizeServerUrl(raw);
  if (!base) return { ok: false, error: 'empty-url' };
  try {
    const controller = new AbortController();
    const timeout = setTimeout(() => controller.abort(), 8000);
    const res = await fetch(`${base}/api/auth/status`, { signal: controller.signal });
    clearTimeout(timeout);
    return res.ok ? { ok: true } : { ok: false, error: `http-${res.status}` };
  } catch (err) {
    return { ok: false, error: err instanceof Error ? err.message : 'network-error' };
  }
};

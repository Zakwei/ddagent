import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import {
  api,
  expireAuthSession,
  getAuthTokenRefreshDelay,
  getStoredAuthToken,
  isValidRefreshedToken,
  storeAuthToken,
  AUTH_SESSION_EXPIRED_EVENT,
} from '~shared/utils/api';

interface AuthUser {
  username?: string;
  [key: string]: unknown;
}

interface AuthContextValue {
  user: AuthUser | null;
  token: string | null;
  isLoading: boolean;
  login: (username: string, password: string) => Promise<{ ok: boolean; error?: string }>;
  logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
};

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [token, setToken] = useState<string | null>(null);
  const [user, setUser] = useState<AuthUser | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const refreshTimer = useRef<ReturnType<typeof setTimeout> | null>(null);

  const clearSession = useCallback(() => {
    expireAuthSession();
    setToken(null);
    setUser(null);
  }, []);

  const setSession = useCallback((u: AuthUser, t: string) => {
    storeAuthToken(t);
    setToken(t);
    setUser(u);
  }, []);

  const refreshSession = useCallback(async () => {
    try {
      const res = await api.auth.refresh();
      const payload = await res.json().catch(() => null);
      if (res.ok && isValidRefreshedToken(payload?.token)) {
        setToken(payload.token);
        storeAuthToken(payload.token);
      }
    } catch {
      // network error — keep the session, retry on next scheduled tick
    }
  }, []);

  // Bootstrap: a stored token logs us straight in (server is the authority).
  useEffect(() => {
    (async () => {
      const stored = getStoredAuthToken();
      if (stored) {
        setToken(stored);
        try {
          const res = await api.auth.user();
          if (res.ok) {
            setUser(await res.json());
          } else if (res.status === 401 || res.status === 403) {
            clearSession();
          }
        } catch {
          // offline — keep token, user sees reconnect UI via WS status
        }
      }
      setIsLoading(false);
    })();
  }, [clearSession]);

  // Mid-life token refresh, same policy as the web AuthContext.
  useEffect(() => {
    if (refreshTimer.current) clearTimeout(refreshTimer.current);
    if (!token || !user) return;
    const delay = getAuthTokenRefreshDelay(token);
    if (delay === null) return;
    refreshTimer.current = setTimeout(refreshSession, delay);
    return () => {
      if (refreshTimer.current) clearTimeout(refreshTimer.current);
    };
  }, [token, user, refreshSession]);

  // Server-side expiry (X-Auth-Error) clears the session everywhere.
  useEffect(() => {
    const onExpired = () => clearSession();
    window.addEventListener(AUTH_SESSION_EXPIRED_EVENT, onExpired);
    return () => window.removeEventListener(AUTH_SESSION_EXPIRED_EVENT, onExpired);
  }, [clearSession]);

  const login = useCallback(
    async (username: string, password: string) => {
      try {
        const res = await api.auth.login(username, password);
        const payload = await res.json().catch(() => null);
        if (!res.ok || !payload?.token || !payload?.user) {
          return { ok: false, error: payload?.error || `http-${res.status}` };
        }
        setSession(payload.user, payload.token);
        return { ok: true };
      } catch (err) {
        return { ok: false, error: err instanceof Error ? err.message : 'network-error' };
      }
    },
    [setSession],
  );

  const logout = useCallback(async () => {
    try {
      await api.auth.logout();
    } catch {
      // best effort
    }
    clearSession();
  }, [clearSession]);

  const value = useMemo(
    () => ({ user, token, isLoading, login, logout }),
    [user, token, isLoading, login, logout],
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

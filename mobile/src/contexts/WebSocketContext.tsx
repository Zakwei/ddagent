import React, {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useRef,
  useState,
} from 'react';
import { AppState } from 'react-native';
import { getWsBase } from '../lib/server-config';
import { getStoredAuthToken, isAuthTokenExpired, expireAuthSession } from '~shared/utils/api';
import { useAuth } from './AuthContext';
import { registerForPushNotifications } from '../lib/push';

export type ServerEventListener = (event: any) => void;

interface WebSocketContextType {
  subscribe: (listener: ServerEventListener) => () => void;
  sendMessage: (payload: unknown) => void;
  latestMessage: any | null;
  isConnected: boolean;
}

const WebSocketContext = createContext<WebSocketContextType | null>(null);

export const useWebSocket = () => {
  const ctx = useContext(WebSocketContext);
  if (!ctx) throw new Error('useWebSocket must be used within a WebSocketProvider');
  return ctx;
};

const buildWebSocketUrl = (token: string | null) => {
  const base = getWsBase();
  if (!base || !token) return null;
  if (isAuthTokenExpired(token)) {
    expireAuthSession();
    return null;
  }
  return `${base}/ws?token=${encodeURIComponent(token)}`;
};

export function WebSocketProvider({ children }: { children: React.ReactNode }) {
  const wsRef = useRef<WebSocket | null>(null);
  const unmountedRef = useRef(false);
  const hasConnectedRef = useRef(false);
  const listenersRef = useRef(new Set<ServerEventListener>());
  const [latestMessage, setLatestMessage] = useState<any | null>(null);
  const [isConnected, setIsConnected] = useState(false);
  const reconnectTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const { isLoading: isAuthLoading, token, user } = useAuth();

  const dispatch = useCallback((event: any) => {
    for (const listener of listenersRef.current) {
      try {
        listener(event);
      } catch (error) {
        console.error('WebSocket listener error:', error);
      }
    }
    if (typeof event?.type === 'string' && event.type.startsWith('taskmaster-')) {
      setLatestMessage(event);
    }
  }, []);

  const connect = useCallback(() => {
    if (unmountedRef.current) return;
    if (isAuthLoading || !user) return;
    const wsUrl = buildWebSocketUrl(token);
    if (!wsUrl) return;

    const websocket = new WebSocket(wsUrl);
    wsRef.current = websocket;

    websocket.onopen = () => {
      setIsConnected(true);
      // Authed socket up — safe moment to (re)register the FCM device token.
      void registerForPushNotifications();
      if (hasConnectedRef.current) {
        dispatch({ kind: 'websocket_reconnected', timestamp: Date.now() });
      }
      hasConnectedRef.current = true;
    };

    websocket.onmessage = (event) => {
      try {
        dispatch(JSON.parse(event.data as string));
      } catch (error) {
        console.error('Failed to parse WebSocket message:', error);
      }
    };

    websocket.onclose = () => {
      setIsConnected(false);
      if (wsRef.current === websocket) wsRef.current = null;
      if (!unmountedRef.current && !reconnectTimeoutRef.current) {
        reconnectTimeoutRef.current = setTimeout(() => {
          reconnectTimeoutRef.current = null;
          connect();
        }, 3000);
      }
    };

    websocket.onerror = () => {
      websocket.close();
    };
  }, [dispatch, isAuthLoading, token, user]);

  useEffect(() => {
    unmountedRef.current = false;
    connect();
    return () => {
      unmountedRef.current = true;
      if (reconnectTimeoutRef.current) clearTimeout(reconnectTimeoutRef.current);
      wsRef.current?.close();
      wsRef.current = null;
    };
  }, [connect]);

  // Reconnect when the app returns to the foreground.
  useEffect(() => {
    const sub = AppState.addEventListener('change', (state) => {
      if (state === 'active' && wsRef.current === null && !unmountedRef.current) {
        connect();
      }
    });
    return () => sub.remove();
  }, [connect]);

  const subscribe = useCallback((listener: ServerEventListener) => {
    listenersRef.current.add(listener);
    return () => {
      listenersRef.current.delete(listener);
    };
  }, []);

  const sendMessage = useCallback((payload: unknown) => {
    if (wsRef.current?.readyState === WebSocket.OPEN) {
      wsRef.current.send(JSON.stringify(payload));
    }
  }, []);

  const value = useMemo(
    () => ({ subscribe, sendMessage, latestMessage, isConnected }),
    [subscribe, sendMessage, latestMessage, isConnected],
  );

  return <WebSocketContext.Provider value={value}>{children}</WebSocketContext.Provider>;
}

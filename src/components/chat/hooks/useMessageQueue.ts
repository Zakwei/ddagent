import { useCallback, useEffect, useMemo, useState } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import { api } from '../../../utils/api';
import { parseMessages, type ServerQueuedMessage } from '../utils/messageQueue';

export type { ServerQueuedMessage } from '../utils/messageQueue';

/**
 * Server-backed outbound message queue for one session.
 *
 * The queue lives on the server, so it survives page reloads and device
 * switches — unlike the previous browser-only queue. The server also drains it
 * automatically when the session's run completes, so a queued message is sent
 * even if the user closes the tab. This hook only mirrors that state into the
 * UI and exposes enqueue / send-now / remove.
 */
export function useMessageQueue(sessionId: string | null) {
  const { subscribe } = useWebSocket();
  const [messages, setMessages] = useState<ServerQueuedMessage[]>([]);

  const refresh = useCallback(async () => {
    if (!sessionId) {
      setMessages([]);
      return;
    }
    try {
      const response = await api.queue.list(sessionId);
      if (!response.ok) {
        return;
      }
      setMessages(parseMessages(await response.json()));
    } catch {
      // A transient fetch failure must not clear the visible queue.
    }
  }, [sessionId]);

  useEffect(() => {
    void refresh();
  }, [refresh]);

  // The server broadcasts queue snapshots after every mutation (enqueue,
  // dispatch, send-now, delete), so the UI stays correct across devices.
  useEffect(() => {
    if (!sessionId) {
      return;
    }
    return subscribe((event) => {
      if (event.type !== 'queued-messages-updated' || event.sessionId !== sessionId) {
        return;
      }
      const next = Array.isArray((event as { messages?: unknown }).messages)
        ? ((event as { messages: unknown[] }).messages as unknown[])
        : null;
      if (next) {
        setMessages(parseMessages({ messages: next }));
      } else {
        void refresh();
      }
    });
  }, [sessionId, subscribe, refresh]);

  const enqueue = useCallback(
    async (content: string, options?: Record<string, unknown>) => {
      if (!sessionId) {
        return null;
      }
      const response = await api.queue.enqueue(sessionId, { content, options });
      if (!response.ok) {
        return null;
      }
      const payload = await response.json().catch(() => null);
      const data = payload && typeof payload === 'object' ? (payload as { data?: unknown }).data : null;
      const created = data && typeof data === 'object' ? (data as { message?: unknown }).message : null;
      void refresh();
      return (created as ServerQueuedMessage | null) ?? null;
    },
    [sessionId, refresh],
  );

  const sendNow = useCallback(
    async (id: number) => {
      await api.queue.sendNow(id);
      void refresh();
    },
    [refresh],
  );

  const remove = useCallback(
    async (id: number) => {
      setMessages((previous) => previous.filter((message) => message.id !== id));
      await api.queue.remove(id);
    },
    [],
  );

  return useMemo(
    () => ({ messages, enqueue, sendNow, remove, refresh }),
    [messages, enqueue, sendNow, remove, refresh],
  );
}

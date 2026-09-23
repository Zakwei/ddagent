import { useEffect, useState } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import type { PresenceRosterEntry, PresenceViewing } from '../types';

/**
 * Announces what the local user is viewing and tracks the live roster.
 *
 * The socket treats the first `presence` frame as a subscription, so sending
 * on every (re)connect both registers this client and refreshes its roster.
 * `viewing` identifies the surface — `{kind:'board', id: projectId}` on the
 * board page, `{kind:'session', id}` inside a chat.
 */
export function usePresence(viewing: PresenceViewing): PresenceRosterEntry[] {
  const { sendMessage, subscribe, isConnected } = useWebSocket();
  const [roster, setRoster] = useState<PresenceRosterEntry[]>([]);

  const viewingKey = viewing ? `${viewing.kind}:${viewing.id}` : 'none';

  useEffect(() => {
    if (!isConnected) return;
    sendMessage({ type: 'presence', viewing });
    // Leaving the surface (or a transient disconnect) clears the announce so
    // the roster stops claiming this user is still viewing the board.
    return () => {
      sendMessage({ type: 'presence', viewing: null });
    };
    // viewing is serialized via viewingKey so callers may pass fresh objects.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [isConnected, viewingKey, sendMessage]);

  useEffect(
    () =>
      subscribe((event) => {
        if (event.type === 'presence-roster' && Array.isArray(event.users)) {
          setRoster(event.users as PresenceRosterEntry[]);
        }
      }),
    [subscribe],
  );

  return roster;
}

import type {
  PresenceRosterEntry,
  PresenceViewing,
  RealtimeClientConnection,
} from '@/shared/types.js';

// Mirrors WS_OPEN_STATE in the websocket module — duplicated on purpose: the
// websocket module consumes this service, so importing it back would create a
// module cycle.
const WS_OPEN_STATE = 1;
const PRESENCE_BROADCAST_THROTTLE_MS = 1000;
const PRESENCE_VIEWING_KINDS = new Set(['session', 'card', 'board']);

/**
 * Sanitizes the `viewing` field of an inbound `presence` message.
 *
 * Anything malformed is treated as "online but not viewing anything" rather
 * than rejected: presence is best-effort UI state, not a command channel.
 */
export function readPresenceViewing(value: unknown): PresenceViewing {
  if (typeof value !== 'object' || value === null) {
    return null;
  }

  const record = value as { kind?: unknown; id?: unknown };
  const kind = typeof record.kind === 'string' ? record.kind : '';
  const id = typeof record.id === 'string' ? record.id.trim() : '';

  if (!PRESENCE_VIEWING_KINDS.has(kind) || !id) {
    return null;
  }
  return { kind: kind as 'session' | 'card' | 'board', id };
}

type PresenceServiceDeps = {
  /**
   * Minimum spacing between roster broadcasts. Rapid presence flaps (tab
   * switching) coalesce into a single trailing broadcast.
   */
  throttleMs?: number;
  /** Injectable for deterministic tests. */
  scheduler?: {
    setTimeout: typeof setTimeout;
    clearTimeout: typeof clearTimeout;
  };
};

/**
 * Tracks which connected clients are present and what they are viewing, then
 * broadcasts the aggregated roster back to those same clients.
 *
 * A connection joins the roster the first time it sends a `presence` message
 * (the frontend announces on socket open), so the service doubles as the
 * subscription registry — no separate subscribe handshake is needed. The
 * roster collapses multiple connections (tabs) of the same user into one
 * entry, most recent announce wins.
 */
export function createPresenceService(deps: PresenceServiceDeps = {}) {
  const throttleMs = deps.throttleMs ?? PRESENCE_BROADCAST_THROTTLE_MS;
  const scheduler = deps.scheduler ?? { setTimeout, clearTimeout };

  // Keyed by connection so a close event removes exactly one seat; entries
  // carry the announced identity so no request context is retained.
  const clients = new Map<RealtimeClientConnection, PresenceRosterEntry>();
  let pendingTimer: ReturnType<typeof setTimeout> | null = null;
  let lastBroadcastAt = 0;

  function roster(): PresenceRosterEntry[] {
    const byUser = new Map<string, PresenceRosterEntry>();
    for (const entry of clients.values()) {
      byUser.set(String(entry.userId), entry);
    }
    return [...byUser.values()];
  }

  function broadcastRoster(): void {
    lastBroadcastAt = Date.now();
    const payload = JSON.stringify({ type: 'presence-roster', users: roster() });
    for (const client of clients.keys()) {
      if (client.readyState === WS_OPEN_STATE) {
        try {
          client.send(payload);
        } catch {
          // A socket that throws on send is dead; the close handler removes it.
        }
      }
    }
  }

  function scheduleBroadcast(): void {
    const elapsed = Date.now() - lastBroadcastAt;
    if (elapsed >= throttleMs) {
      if (pendingTimer) {
        scheduler.clearTimeout(pendingTimer);
        pendingTimer = null;
      }
      broadcastRoster();
      return;
    }

    // Inside the throttle window: schedule one trailing broadcast so the last
    // state always reaches clients, but intermediate flaps don't.
    if (!pendingTimer) {
      pendingTimer = scheduler.setTimeout(() => {
        pendingTimer = null;
        broadcastRoster();
      }, throttleMs - elapsed);
    }
  }

  return {
    /** Registers/updates one connection's presence and schedules a broadcast. */
    update(client: RealtimeClientConnection, entry: PresenceRosterEntry): void {
      clients.set(client, entry);
      scheduleBroadcast();
    },

    /** Drops a disconnected connection and rebroadcasts the roster. */
    remove(client: RealtimeClientConnection): void {
      if (clients.delete(client)) {
        scheduleBroadcast();
      }
    },

    /** Current per-user roster (most recent announce per user wins). */
    roster,

    /** Test hook: how many connections currently announce presence. */
    get size(): number {
      return clients.size;
    },

    /** Cancels a pending throttled broadcast (used by tests/shutdown). */
    dispose(): void {
      if (pendingTimer) {
        scheduler.clearTimeout(pendingTimer);
        pendingTimer = null;
      }
    },
  };
}

export type PresenceService = ReturnType<typeof createPresenceService>;

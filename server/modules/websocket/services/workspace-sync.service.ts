import { workspaceStateDb } from '@/modules/database/index.js';
import type { RealtimeClientConnection } from '@/shared/types.js';
import { safeSocketSend } from '@/shared/utils.js';

// Mirrors WS_OPEN_STATE in websocket-state.service — kept local so the sync
// service has no module-cycle risk with the connection registry.
const WS_OPEN_STATE = 1;

/** Hard cap on a serialized workspace payload; anything larger is rejected. */
const MAX_STATE_BYTES = 64 * 1024;

export type WorkspaceSyncStore = {
  get(userId: number): { state: unknown; revision: number } | null;
  put(userId: number, stateJson: string): number;
};

/**
 * Tracks which userId owns each chat socket so a `workspace.update` reaches
 * exactly the same user's other devices — every connected socket announces
 * nothing, registration happens on connect from the authenticated request.
 */
export function createWorkspaceSyncService(store: WorkspaceSyncStore = workspaceStateDb) {
  const userByClient = new Map<RealtimeClientConnection, number>();

  function sendState(
    client: RealtimeClientConnection,
    state: unknown,
    revision: number,
    originDeviceId: string | null,
  ): void {
    safeSocketSend(client, JSON.stringify({
      kind: 'workspace_state',
      state,
      revision,
      originDeviceId,
      timestamp: new Date().toISOString(),
    }));
  }

  return {
    /** Binds a freshly connected chat socket to its user bucket. */
    register(client: RealtimeClientConnection, userId: number): void {
      userByClient.set(client, userId);
    },

    /** Drops a disconnected socket from the registry. */
    unregister(client: RealtimeClientConnection): void {
      userByClient.delete(client);
    },

    /** Replies to `workspace.get` with the caller's stored state (or nulls). */
    sendCurrent(client: RealtimeClientConnection, userId: number): void {
      const row = store.get(userId);
      sendState(client, row?.state ?? null, row?.revision ?? 0, null);
    },

    /**
     * Handles `workspace.update`: validates the payload, persists it with a
     * bumped revision, then fans the state out to the user's other sockets.
     * The sender is excluded — it already holds this exact state locally.
     */
    applyUpdate(
      sender: RealtimeClientConnection,
      userId: number,
      state: unknown,
      deviceId: unknown,
    ): { ok: true } | { ok: false; error: string } {
      if (!state || typeof state !== 'object' || Array.isArray(state)) {
        return { ok: false, error: 'workspace.update requires an object state.' };
      }

      let stateJson: string;
      try {
        stateJson = JSON.stringify(state);
      } catch {
        return { ok: false, error: 'workspace.update state must be JSON-serializable.' };
      }
      if (stateJson.length > MAX_STATE_BYTES) {
        return { ok: false, error: 'workspace.update state exceeds 64KB.' };
      }

      const revision = store.put(userId, stateJson);
      const originDeviceId = typeof deviceId === 'string' && deviceId ? deviceId : null;

      for (const [client, clientUserId] of userByClient) {
        if (client === sender || clientUserId !== userId) {
          continue;
        }
        if (client.readyState !== WS_OPEN_STATE) {
          continue;
        }
        sendState(client, state, revision, originDeviceId);
      }

      return { ok: true };
    },

    /** Test hook: how many sockets currently carry a user binding. */
    get size(): number {
      return userByClient.size;
    },
  };
}

/** Shared instance consumed by the chat websocket connection handler. */
export const workspaceSync = createWorkspaceSyncService();

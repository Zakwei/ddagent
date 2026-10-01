import { sanitizeWorkspaceState, type WorkspaceState } from './workspacePanes';

/**
 * Server protocol: `workspace.get` → `workspace_state` reply to the requester;
 * `workspace.update` → persisted + broadcast `workspace_state` to the user's
 * other sockets. Conflicts are last-write-wins on the server.
 *
 * This controller owns the client decision logic (echo suppression, seeding,
 * dirty-wins tie-break) as a pure unit — the React hook only wires timers,
 * subscription, and the socket handle into it.
 */
export type WorkspaceSyncFrame = {
  kind?: string;
  state?: unknown;
  revision?: number;
  [key: string]: unknown;
};

export type WorkspaceSyncControllerOptions = {
  deviceId: string;
  /** Latest local snapshot — read lazily so handlers never see stale state. */
  getState(): WorkspaceState;
  applyRemote(state: WorkspaceState): void;
  send(message: unknown): boolean;
};

export function createWorkspaceSyncController(options: WorkspaceSyncControllerOptions) {
  // Serialized state as last seen by the server. Seeded with the boot state so
  // a fresh client doesn't push its stale localStorage copy over newer server
  // data before the workspace.get reply lands.
  let lastSyncedJson = JSON.stringify(options.getState());
  // True when a local edit couldn't reach the server (socket down). The next
  // workspace_state reply then loses to our push — unsent edits beat remote
  // state the user never saw (ponytail: LWW, so the last write still wins
  // between two simultaneously-editing connected devices).
  let dirty = false;

  function pushState(state: WorkspaceState): boolean {
    const json = JSON.stringify(state);
    if (json === lastSyncedJson) return true;
    if (options.send({ type: 'workspace.update', state, deviceId: options.deviceId })) {
      lastSyncedJson = json;
      return true;
    }
    dirty = true;
    return false;
  }

  return {
    /** Sends `workspace.get`; call whenever the socket (re)opens. */
    requestSnapshot(): void {
      options.send({ type: 'workspace.get', deviceId: options.deviceId });
    },

    /**
     * Handles one inbound ws frame. Non-workspace frames are ignored.
     * Order: dirty push → apply remote → seed empty server.
     */
    handleFrame(event: WorkspaceSyncFrame): void {
      if (event.kind !== 'workspace_state') return;

      if (dirty) {
        // pushState re-checks the serialized form, so a frame echoing our own
        // pending write becomes a no-op instead of a redundant send.
        dirty = false;
        pushState(options.getState());
        return;
      }

      if (event.state && typeof event.state === 'object') {
        const next = sanitizeWorkspaceState(event.state);
        lastSyncedJson = JSON.stringify(next);
        options.applyRemote(next);
        return;
      }

      // Server holds nothing yet — seed it with this device's workspace.
      // Forced send: the payload equals our boot state, so the lastSyncedJson
      // dedup in pushState would otherwise swallow the seed.
      const state = options.getState();
      if (options.send({ type: 'workspace.update', state, deviceId: options.deviceId })) {
        lastSyncedJson = JSON.stringify(state);
      } else {
        dirty = true;
      }
    },

    /**
     * Pushes a local edit (hook calls this after its debounce). Skipped when
     * the serialized state equals what the server already has — which is what
     * makes remote applies not echo back.
     */
    pushLocal(): void {
      pushState(options.getState());
    },

    /** Whether a local edit is still unsent — exposed for tests/diagnostics. */
    get dirty(): boolean {
      return dirty;
    },
  };
}

export type WorkspaceSyncController = ReturnType<typeof createWorkspaceSyncController>;

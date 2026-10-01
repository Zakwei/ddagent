import { useEffect, useRef } from 'react';

import { useWebSocket } from '../../../contexts/WebSocketContext';
import { createWorkspaceSyncController, type WorkspaceSyncController } from '../utils/workspaceSync';
import type { WorkspaceState } from '../utils/workspacePanes';

const DEVICE_ID_STORAGE_KEY = 'ddagent_device_id';
const PUSH_DEBOUNCE_MS = 400;

/** Stable per-browser-profile id so other devices can tell sync origins apart. */
function readOrCreateDeviceId(): string {
  try {
    const existing = localStorage.getItem(DEVICE_ID_STORAGE_KEY);
    if (existing) return existing;
    const id = typeof crypto !== 'undefined' && typeof crypto.randomUUID === 'function'
      ? crypto.randomUUID()
      : `dev-${Math.random().toString(36).slice(2)}`;
    localStorage.setItem(DEVICE_ID_STORAGE_KEY, id);
    return id;
  } catch {
    return 'unknown-device';
  }
}

/**
 * Syncs the split workspace (open session panes) between this device and the
 * account's other sockets over the existing /ws chat socket. All decisions
 * live in createWorkspaceSyncController; this hook only bridges React effects.
 */
export function useWorkspaceSync({
  state,
  applyRemoteState,
}: {
  state: WorkspaceState;
  applyRemoteState: (state: WorkspaceState) => void;
}): void {
  const { sendMessage, subscribe, isConnected } = useWebSocket();

  const stateRef = useRef(state);
  const applyRemoteRef = useRef(applyRemoteState);
  const sendRef = useRef(sendMessage);
  stateRef.current = state;
  applyRemoteRef.current = applyRemoteState;
  sendRef.current = sendMessage;

  const controllerRef = useRef<WorkspaceSyncController | null>(null);
  if (!controllerRef.current) {
    controllerRef.current = createWorkspaceSyncController({
      deviceId: readOrCreateDeviceId(),
      getState: () => stateRef.current,
      applyRemote: (next) => applyRemoteRef.current(next),
      send: (message) => sendRef.current(message),
    });
  }
  const controller = controllerRef.current;

  // Ask the server for the authoritative state whenever the socket is up.
  useEffect(() => {
    if (isConnected) controller.requestSnapshot();
  }, [controller, isConnected]);

  useEffect(() => subscribe((event) => controller.handleFrame(event)), [controller, subscribe]);

  // Local edits: debounce, then let the controller decide send vs. echo-skip.
  useEffect(() => {
    const timer = setTimeout(() => controller.pushLocal(), PUSH_DEBOUNCE_MS);
    return () => clearTimeout(timer);
  }, [controller, state]);
}

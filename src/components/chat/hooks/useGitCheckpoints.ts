import { useCallback, useEffect, useRef, useState } from 'react';

import { authenticatedFetch } from '../../../utils/api';

type GitCheckpoint = {
  ref: string;
  commit: string;
  createdAt: string | null;
  label: string;
};

type CheckpointResponse = {
  success?: boolean;
  checkpoint?: GitCheckpoint;
  checkpoints?: GitCheckpoint[];
  removedUntracked?: string[];
  error?: string;
};

// How long the "Undone" confirmation stays visible before the button reappears.
const RESTORED_STATE_TIMEOUT_MS = 4000;

export type UndoState = 'idle' | 'restoring' | 'restored' | 'failed';

interface UseGitCheckpointsResult {
  /** Snapshot created before the most recent AI turn, if any. */
  lastCheckpoint: GitCheckpoint | null;
  isCreatingCheckpoint: boolean;
  undoState: UndoState;
  error: string | null;
  /** Creates a snapshot before an AI turn. Never throws — records the error instead. */
  createCheckpoint: (label?: string) => Promise<void>;
  /** Restores the working tree to `lastCheckpoint`. */
  undoLastAiRun: () => Promise<void>;
  clearError: () => void;
}

/**
 * Non-destructive working-tree checkpoints for the chat view. A snapshot is
 * taken before each AI turn so the whole turn can be undone with one click;
 * the backend stores it under `refs/ddagent/checkpoints/*` without touching
 * the real index or working tree.
 */
export function useGitCheckpoints(projectId: string | null | undefined): UseGitCheckpointsResult {
  const [lastCheckpoint, setLastCheckpoint] = useState<GitCheckpoint | null>(null);
  const [isCreatingCheckpoint, setIsCreatingCheckpoint] = useState(false);
  const [undoState, setUndoState] = useState<UndoState>('idle');
  const [error, setError] = useState<string | null>(null);
  const checkpointRef = useRef<GitCheckpoint | null>(null);
  const restoredTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);

  const clearRestoredTimer = useCallback(() => {
    if (restoredTimerRef.current) {
      clearTimeout(restoredTimerRef.current);
      restoredTimerRef.current = null;
    }
  }, []);

  useEffect(() => clearRestoredTimer, [clearRestoredTimer]);

  const createCheckpoint = useCallback(async (label?: string) => {
    if (!projectId) {
      return;
    }
    setIsCreatingCheckpoint(true);
    setError(null);
    clearRestoredTimer();
    setUndoState('idle');
    try {
      const response = await authenticatedFetch('/api/git/checkpoint', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ project: projectId, label }),
      });
      const data = (await response.json()) as CheckpointResponse;
      if (!response.ok || !data.success || !data.checkpoint) {
        throw new Error(data.error || 'Failed to create checkpoint');
      }
      checkpointRef.current = data.checkpoint;
      setLastCheckpoint(data.checkpoint);
    } catch (caughtError) {
      // A failed checkpoint must not block the AI turn.
      setError(caughtError instanceof Error ? caughtError.message : String(caughtError));
    } finally {
      setIsCreatingCheckpoint(false);
    }
  }, [projectId, clearRestoredTimer]);

  const undoLastAiRun = useCallback(async () => {
    const checkpoint = checkpointRef.current;
    if (!projectId || !checkpoint) {
      return;
    }

    // Split panes share one physical repo: if another pane (or turn) created a
    // newer checkpoint after ours, restoring ours would silently wipe that
    // work too. Compare against the project's newest checkpoint and ask first.
    try {
      const listResponse = await authenticatedFetch(
        `/api/git/checkpoint/list?project=${encodeURIComponent(projectId)}`,
      );
      const listData = (await listResponse.json()) as CheckpointResponse;
      const newest = listResponse.ok && listData.success ? listData.checkpoints?.[0] : null;
      if (newest && newest.ref !== checkpoint.ref) {
        const confirmed = window.confirm(
          'The workspace has newer changes or checkpoints from another pane. ' +
            'Undoing this AI run will also revert those changes. Continue?',
        );
        if (!confirmed) {
          return;
        }
      }
    } catch {
      // A failed check must not block undo — proceed with the restore.
    }

    setUndoState('restoring');
    setError(null);
    try {
      const response = await authenticatedFetch('/api/git/checkpoint/restore', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ project: projectId, ref: checkpoint.ref }),
      });
      const data = (await response.json()) as CheckpointResponse;
      if (!response.ok || !data.success) {
        throw new Error(data.error || 'Failed to restore checkpoint');
      }
      setUndoState('restored');
      // The "Undone" badge is transient — return to the undo button shortly
      // after so the control does not stay hidden forever.
      clearRestoredTimer();
      restoredTimerRef.current = setTimeout(() => {
        restoredTimerRef.current = null;
        setUndoState('idle');
      }, RESTORED_STATE_TIMEOUT_MS);
    } catch (caughtError) {
      setUndoState('failed');
      setError(caughtError instanceof Error ? caughtError.message : String(caughtError));
    }
  }, [projectId, clearRestoredTimer]);

  const clearError = useCallback(() => setError(null), []);

  return {
    lastCheckpoint,
    isCreatingCheckpoint,
    undoState,
    error,
    createCheckpoint,
    undoLastAiRun,
    clearError,
  };
}

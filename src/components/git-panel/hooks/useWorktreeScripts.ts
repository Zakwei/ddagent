import { useCallback, useEffect, useRef, useState } from 'react';

import { authenticatedFetch } from '../../../utils/api';
import type { Project } from '../../../types/app';

export type WorktreeScriptsConfig = {
  setup: string | null;
  run: string | null;
  runPort: number | null;
  hasProjectOverride?: boolean;
  hasRepoFile?: boolean;
};

export type WorktreeSetupRuntime = {
  status: 'idle' | 'running' | 'done' | 'failed';
  exitCode: number | null;
  logTail: string[];
};

export type WorktreeRunRuntime = {
  status: 'idle' | 'running' | 'exited';
  exitCode: number | null;
  port: number | null;
  url: string | null;
  logTail: string[];
};

export type WorktreeRuntimeInfo = {
  setup: WorktreeSetupRuntime;
  run: WorktreeRunRuntime;
};

export type WorktreeScriptsStatus = {
  scripts: WorktreeScriptsConfig;
  runtimes: Record<string, WorktreeRuntimeInfo>;
};

type Envelope<T> = { success?: boolean; data?: T; error?: { message?: string } };

const POLL_INTERVAL_MS = 5000;

async function readEnvelope<T>(response: Response): Promise<T> {
  const body = (await response.json().catch(() => ({}))) as Envelope<T>;
  if (!response.ok || body.success === false) {
    throw new Error(body.error?.message || `request failed (${response.status})`);
  }
  return body.data as T;
}

/**
 * Setup/run script state for the worktrees panel: the effective repo config
 * plus live per-worktree runtimes, polled while the panel is mounted.
 */
export function useWorktreeScripts(selectedProject: Project | null) {
  const [status, setStatus] = useState<WorktreeScriptsStatus | null>(null);
  const [error, setError] = useState<string | null>(null);
  const projectId = selectedProject?.projectId ?? null;
  const busyRef = useRef(false);

  const refresh = useCallback(async () => {
    if (!projectId || busyRef.current) return;
    busyRef.current = true;
    try {
      const data = await readEnvelope<WorktreeScriptsStatus>(
        await authenticatedFetch(`/api/worktrees/status?project=${encodeURIComponent(projectId)}`),
      );
      setStatus(data);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'status failed');
    } finally {
      busyRef.current = false;
    }
  }, [projectId]);

  useEffect(() => {
    void refresh();
    const interval = setInterval(() => void refresh(), POLL_INTERVAL_MS);
    return () => clearInterval(interval);
  }, [refresh]);

  const saveConfig = useCallback(
    async (config: { setup: string | null; run: string | null; runPort: number | null }) => {
      if (!projectId) return;
      await readEnvelope<WorktreeScriptsConfig>(
        await authenticatedFetch('/api/worktrees/config', {
          method: 'PUT',
          body: JSON.stringify({ project: projectId, ...config }),
        }),
      );
      await refresh();
    },
    [projectId, refresh],
  );

  const runAction = useCallback(
    async (action: 'run' | 'stop', targetProjectId: string) => {
      await readEnvelope<WorktreeRunRuntime>(
        await authenticatedFetch(`/api/worktrees/${encodeURIComponent(targetProjectId)}/${action}`, {
          method: 'POST',
          body: '{}',
        }),
      );
      await refresh();
    },
    [refresh],
  );

  return { status, error, refresh, saveConfig, runAction };
}

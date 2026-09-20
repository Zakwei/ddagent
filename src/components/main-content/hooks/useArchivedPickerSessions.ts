import { useCallback, useState } from 'react';

import { api } from '../../../utils/api';
import {
  parseArchivedProjects,
  parseArchivedSessions,
  type PickerArchivedProject,
  type PickerArchivedSession,
} from '../utils/sessionPicker';

export type ArchivedPickerSessionsApi = {
  archivedSessions: PickerArchivedSession[];
  archivedProjects: PickerArchivedProject[];
  isArchivedLoading: boolean;
  archivedError: boolean;
  /** Refetches archived sessions + projects; used on toggle and retry. */
  loadArchived: () => Promise<void>;
  /** Restores one session; resolves `true` on success. */
  restoreArchivedSession: (sessionId: string) => Promise<boolean>;
  /** Restores one workspace; resolves `true` on success. */
  restoreArchivedProject: (projectId: string) => Promise<boolean>;
};

/**
 * Archive data for the in-pane session picker.
 *
 * Lives outside the picker so the component stays free of API imports (it is
 * rendered once per pane, while this state is shared and only loaded when a
 * picker actually opens its archive view).
 */
export function useArchivedPickerSessions(): ArchivedPickerSessionsApi {
  const [archivedSessions, setArchivedSessions] = useState<PickerArchivedSession[]>([]);
  const [archivedProjects, setArchivedProjects] = useState<PickerArchivedProject[]>([]);
  const [isArchivedLoading, setIsArchivedLoading] = useState(false);
  const [archivedError, setArchivedError] = useState(false);

  const loadArchived = useCallback(async () => {
    setIsArchivedLoading(true);
    setArchivedError(false);
    try {
      const [projectsResponse, sessionsResponse] = await Promise.all([
        api.archivedProjects(),
        api.getArchivedSessions(),
      ]);
      if (!projectsResponse.ok || !sessionsResponse.ok) {
        throw new Error(
          `archived fetch failed (projects: ${projectsResponse.status}, sessions: ${sessionsResponse.status})`,
        );
      }
      setArchivedProjects(parseArchivedProjects(await projectsResponse.json()));
      setArchivedSessions(parseArchivedSessions(await sessionsResponse.json()));
    } catch (error) {
      console.error('[SessionPicker] Failed to load archived sessions:', error);
      setArchivedError(true);
    } finally {
      setIsArchivedLoading(false);
    }
  }, []);

  const restoreArchivedSession = useCallback(
    async (sessionId: string) => {
      try {
        const response = await api.restoreSession(sessionId);
        if (!response.ok) {
          throw new Error(`restore session failed: ${response.status}`);
        }
        await loadArchived();
        return true;
      } catch (error) {
        console.error('[SessionPicker] Failed to restore session:', error);
        return false;
      }
    },
    [loadArchived],
  );

  const restoreArchivedProject = useCallback(
    async (projectId: string) => {
      try {
        const response = await api.restoreProject(projectId);
        if (!response.ok) {
          throw new Error(`restore project failed: ${response.status}`);
        }
        await loadArchived();
        return true;
      } catch (error) {
        console.error('[SessionPicker] Failed to restore project:', error);
        return false;
      }
    },
    [loadArchived],
  );

  return {
    archivedSessions,
    archivedProjects,
    isArchivedLoading,
    archivedError,
    loadArchived,
    restoreArchivedSession,
    restoreArchivedProject,
  };
}

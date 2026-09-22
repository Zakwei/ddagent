import { useCallback, useEffect, useRef, useState } from 'react';

import { api } from '../../../utils/api';
import type { Project } from '../../../types/app';
import {
  FILE_TREE_REFRESH_EVENT,
  type FileTreeRefreshEventDetail,
} from '../constants/constants';
import type { FileTreeNode } from '../types/types';

type UseFileTreeDataResult = {
  files: FileTreeNode[];
  loading: boolean;
  error: string | null;
  refreshFiles: () => void;
};

const DEFAULT_LOAD_ERROR = 'Unable to load the file tree for this project.';

// The API reports refusals such as FILE_TREE_TOO_LARGE as { error: message }.
// Surfacing that message tells the user why the tree is missing and what to do
// about it, instead of leaving them with an unexplained empty tree.
function readResponseErrorMessage(responseBody: string): string | null {
  try {
    const parsedBody = JSON.parse(responseBody) as unknown;
    const message = typeof parsedBody === 'object' && parsedBody !== null && 'error' in parsedBody
      ? (parsedBody as { error: unknown }).error
      : null;
    return typeof message === 'string' && message.trim() ? message : null;
  } catch {
    return null;
  }
}

export function useFileTreeData(selectedProject: Project | null): UseFileTreeDataResult {
  const [files, setFiles] = useState<FileTreeNode[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [refreshKey, setRefreshKey] = useState(0);
  const abortControllerRef = useRef<AbortController | null>(null);

  const refreshFiles = useCallback(() => {
    setRefreshKey((prev) => prev + 1);
  }, []);

  // Writes that bypass the tree (chat diff revert, external tools) broadcast a
  // refresh event so a mounted tree does not keep showing stale rows.
  useEffect(() => {
    const handleRefreshRequest = (event: Event) => {
      const detail = (event as CustomEvent<FileTreeRefreshEventDetail>).detail;
      if (detail?.projectId && detail.projectId !== selectedProject?.projectId) {
        return;
      }
      refreshFiles();
    };

    window.addEventListener(FILE_TREE_REFRESH_EVENT, handleRefreshRequest);
    return () => window.removeEventListener(FILE_TREE_REFRESH_EVENT, handleRefreshRequest);
  }, [refreshFiles, selectedProject?.projectId]);

  useEffect(() => {
    // File-tree requests use the DB projectId; the backend resolves it to the
    // project's absolute path through the projects table.
    const projectId = selectedProject?.projectId;

    if (!projectId) {
      setFiles([]);
      setLoading(false);
      setError(null);
      return;
    }

    // Abort previous request
    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
    }
    abortControllerRef.current = new AbortController();

    // Track mount state so aborted or late responses do not enqueue stale state updates.
    let isActive = true;

    const fetchFiles = async () => {
      if (isActive) {
        setLoading(true);
        setError(null);
      }
      try {
        const response = await api.getFiles(projectId, { signal: abortControllerRef.current!.signal });

        if (!response.ok) {
          const errorText = await response.text();
          // 404 means the workspace directory is gone (stale project) — the
          // section already renders the server's message as its empty state;
          // it is an expected condition, not a crash.
          if (response.status === 404) {
            console.warn('File tree unavailable for project', projectId, '(404)');
          } else {
            console.error('File fetch failed:', response.status, errorText);
          }
          if (isActive) {
            setFiles([]);
            setError(readResponseErrorMessage(errorText) ?? DEFAULT_LOAD_ERROR);
          }
          return;
        }

        const data = (await response.json()) as FileTreeNode[];
        if (isActive) {
          setFiles(data);
        }
      } catch (error) {
        if ((error as { name?: string }).name === 'AbortError') {
          return;
        }

        console.error('Error fetching files:', error);
        if (isActive) {
          setFiles([]);
          setError(DEFAULT_LOAD_ERROR);
        }
      } finally {
        if (isActive) {
          setLoading(false);
        }
      }
    };

    void fetchFiles();

    return () => {
      isActive = false;
      abortControllerRef.current?.abort();
    };
  }, [selectedProject?.projectId, refreshKey]);

  return {
    files,
    loading,
    error,
    refreshFiles,
  };
}

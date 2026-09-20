import { useCallback, useEffect, useRef, useState } from 'react';

import { api } from '../../../utils/api';
import type { PrdFile } from '../types';

type UseProjectPrdFilesOptions = {
  // DB primary key of the project (post migration).
  projectId?: string;
};

type PrdResponse = {
  prdFiles?: PrdFile[];
  prds?: PrdFile[];
};

function normalizePrdResponse(responseData: PrdResponse): PrdFile[] {
  if (Array.isArray(responseData.prdFiles)) {
    return responseData.prdFiles;
  }

  if (Array.isArray(responseData.prds)) {
    return responseData.prds;
  }

  return [];
}

export function useProjectPrdFiles({ projectId }: UseProjectPrdFilesOptions) {
  const [prdFiles, setPrdFiles] = useState<PrdFile[]>([]);
  const [isLoadingPrdFiles, setIsLoadingPrdFiles] = useState(false);
  // Detects stale responses: switching projects mid-request must not let the
  // old project's slow response overwrite the new project's PRD list.
  const latestRequestIdRef = useRef(0);

  const refreshPrdFiles = useCallback(async () => {
    const requestId = ++latestRequestIdRef.current;

    if (!projectId) {
      setPrdFiles([]);
      return;
    }

    try {
      setIsLoadingPrdFiles(true);
      const response = await api.get(`/taskmaster/prd/${encodeURIComponent(projectId)}`);

      if (requestId !== latestRequestIdRef.current) {
        return;
      }

      if (!response.ok) {
        setPrdFiles([]);
        return;
      }

      const data = (await response.json()) as PrdResponse;
      if (requestId !== latestRequestIdRef.current) {
        return;
      }
      setPrdFiles(normalizePrdResponse(data));
    } catch (error) {
      if (requestId !== latestRequestIdRef.current) {
        return;
      }
      console.error('Failed to load PRD files:', error);
      setPrdFiles([]);
    } finally {
      if (requestId === latestRequestIdRef.current) {
        setIsLoadingPrdFiles(false);
      }
    }
  }, [projectId]);

  useEffect(() => {
    void refreshPrdFiles();
  }, [refreshPrdFiles]);

  return {
    prdFiles,
    isLoadingPrdFiles,
    refreshPrdFiles,
  };
}

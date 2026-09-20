import { authenticatedFetch } from '../../../utils/api';
import type { LLMProvider, ProjectSession } from '../../../types/app';

import { useApiSource } from './useApiSource';

export type SessionResult = {
  id: string;
  label: string;
  provider?: LLMProvider;
  projectId?: string | null;
};

interface SessionsResponse {
  sessions?: ProjectSession[];
}

export function useSessionsSource(projectId: string | undefined, enabled: boolean) {
  return useApiSource<SessionResult, SessionsResponse>({
    enabled: enabled && !!projectId,
    deps: [projectId],
    fetcher: (signal) => {
      // The endpoint has no text filter — the palette filters client-side, so
      // pull the server's max page size (200) instead of cutting off at 50.
      const params = new URLSearchParams({ limit: '200', offset: '0' });
      return authenticatedFetch(
        `/api/projects/${encodeURIComponent(projectId!)}/sessions?${params.toString()}`,
        { signal },
      );
    },
    parse: (data) => {
      return (data.sessions ?? []).map<SessionResult>((s) => ({
        id: s.id,
        label: (s.title || s.summary || s.name || s.id) as string,
        provider: (s.__provider || s.provider) as LLMProvider | undefined,
        projectId: projectId ?? null,
      }));
    },
  });
}

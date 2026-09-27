import { api } from '../../../utils/api';
import type { Project } from '../../../types/app';

import type { SplitPane } from './splitWorkspace';

export interface AuditPersistedPaneSessionsOptions {
  isLoadingProjects: boolean;
  projects: readonly Project[] | Project[];
  sessionCache: ReadonlyMap<string, unknown> | Map<string, unknown>;
  panes: readonly SplitPane[] | SplitPane[];
  auditedPaneSessionIds: Set<string>;
  onArchivedSession: (sessionId: string) => void;
  fetchSessionDetails?: (sessionId: string) => Promise<{ ok: boolean; json: () => Promise<unknown> }>;
}

/**
 * Panes persist sessionIds in localStorage, but archived sessions vanish
 * from the paginated project payloads — a restored pane would mount a dead
 * chat. Audit persisted bindings once each: unknown ids resolve through
 * sessionDetails, and `isArchived` triggers the same cleanup as a delete.
 */
export function auditPersistedPaneSessions({
  isLoadingProjects,
  projects,
  sessionCache,
  panes,
  auditedPaneSessionIds,
  onArchivedSession,
  fetchSessionDetails = api.sessionDetails,
}: AuditPersistedPaneSessionsOptions): Promise<void[]> | undefined {
  if (isLoadingProjects) {
    return undefined;
  }

  const knownSessionIds = new Set<string>();
  for (const project of projects) {
    for (const session of project.sessions ?? []) {
      knownSessionIds.add(session.id);
    }
  }
  for (const cachedId of sessionCache.keys()) {
    knownSessionIds.add(cachedId);
  }

  const lookups: Promise<void>[] = [];

  for (const pane of panes) {
    const paneSessionId = pane.kind === 'chat' ? pane.sessionId : null;
    if (
      !paneSessionId ||
      knownSessionIds.has(paneSessionId) ||
      auditedPaneSessionIds.has(paneSessionId)
    ) {
      continue;
    }
    auditedPaneSessionIds.add(paneSessionId);

    const lookup = Promise.resolve()
      .then(() => fetchSessionDetails(paneSessionId))
      .then(async (response) => {
        if (!response.ok) {
          return;
        }
        const payload = (await response.json()) as { data?: { isArchived?: boolean } };
        if (payload.data?.isArchived === true) {
          onArchivedSession(paneSessionId);
        }
      })
      .catch(() => {
        // Lookup failed: leave the pane alone — the chat view already has
        // its own fallback for unresolvable sessions.
      });

    lookups.push(lookup);
  }

  return Promise.all(lookups);
}

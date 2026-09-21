import { createContext, useContext, useMemo } from 'react';
import type { ReactNode } from 'react';

import { useSplitWorkspace } from '../components/main-content/hooks/useSplitWorkspace';
import { createSplitPaneId, type SplitPane, type SplitPaneKind } from '../components/main-content/utils/splitWorkspace';

export type WorkspaceOpenOptions = {
  /** DB `projectId` the pane should work in. */
  projectId?: string | null;
  /** Session to bind immediately; omit/null opens a fresh chat draft. */
  sessionId?: string | null;
  /** Browser URL for `browser` panes. */
  url?: string | null;
  /** Reuse an existing draft chat pane when one is open. Defaults to true for chat. */
  reuseDraft?: boolean;
  /** Open the chat pane in session-picker state instead of the new-chat draft. */
  picker?: boolean;
};

export type WorkspaceApi = {
  panes: SplitPane[];
  activePaneId: string | null;
  lastUsedProjectId: string | null;
  setActivePaneId: (id: string | null) => void;
  setLastUsedProjectId: (projectId: string | null) => void;
  removePane: (id: string) => void;
  updatePane: (id: string, patch: Partial<Omit<SplitPane, 'id' | 'kind'>>) => void;
  reorderPanes: (fromId: string, toIndex: number) => void;
  canAdd: boolean;
  /** Launches a chat/browser/terminal pane from the sidebar toolbar. */
  openPane: (kind: SplitPaneKind, options?: WorkspaceOpenOptions) => string | null;
  /** Binds a session to a draft chat pane, or opens a new pane for it. */
  openSession: (sessionId: string, projectId?: string | null) => string | null;
};

const WorkspaceContext = createContext<WorkspaceApi | null>(null);

const isDraftChat = (pane: SplitPane) => pane.kind === 'chat' && !pane.sessionId;

/**
 * Owns the persisted split workspace for the whole app shell. Lives above both
 * the sidebar (which launches panes) and main content (which renders them), so
 * a launch from either place targets the same pane list.
 */
export function WorkspaceProvider({ children }: { children: ReactNode }) {
  const workspace = useSplitWorkspace();
  const { panes, activePaneId, lastUsedProjectId, setActivePaneId, setLastUsedProjectId, addPane, removePane, updatePane, reorderPanes, canAdd } = workspace;

  const openPane = useMemo(
    () => (kind: SplitPaneKind, options: WorkspaceOpenOptions = {}) => {
      const { projectId = null, sessionId = null, url = null, reuseDraft = true, picker = false } = options;

      if (kind === 'chat' && reuseDraft) {
        const draft = panes.find(isDraftChat);
        if (draft) {
          updatePane(draft.id, {
            sessionId: sessionId ?? null,
            projectId: projectId ?? draft.projectId ?? null,
            picker,
          });
          setActivePaneId(draft.id);
          return draft.id;
        }
        if (sessionId) {
          const existing = panes.find((pane) => pane.kind === 'chat' && pane.sessionId === sessionId);
          if (existing) {
            updatePane(existing.id, { picker: false });
            setActivePaneId(existing.id);
            return existing.id;
          }
        }
      }

      if (kind === 'browser' && url) {
        const existingBrowser = panes.find((pane) => pane.kind === 'browser');
        if (existingBrowser) {
          updatePane(existingBrowser.id, { url });
          setActivePaneId(existingBrowser.id);
          return existingBrowser.id;
        }
      }

      // Workspace full: retarget a chat pane instead of silently dropping the
      // request. The displaced session stays in the sidebar list.
      if (kind === 'chat' && !canAdd) {
        const target =
          panes.find((pane) => pane.id === activePaneId && pane.kind === 'chat') ??
          [...panes].reverse().find((pane) => pane.kind === 'chat');
        if (target) {
          updatePane(target.id, {
            sessionId: sessionId ?? null,
            projectId: projectId ?? target.projectId ?? null,
            picker,
          });
          setActivePaneId(target.id);
          return target.id;
        }
      }

      if (!canAdd) return null;

      const id = createSplitPaneId();
      addPane({
        id,
        kind,
        ...(kind === 'browser' ? { url } : { sessionId, projectId, picker }),
      });
      setActivePaneId(id);
      return id;
    },
    [activePaneId, addPane, canAdd, panes, setActivePaneId, updatePane],
  );

  const openSession = useMemo(
    () => (sessionId: string, projectId: string | null = null) => {
      const existing = panes.find((pane) => pane.kind === 'chat' && pane.sessionId === sessionId);
      if (existing) {
        updatePane(existing.id, { picker: false });
        setActivePaneId(existing.id);
        return existing.id;
      }

      // Retarget the chat pane the user is looking at instead of stacking a
      // new tile per sidebar click. Panes of other kinds (browser/terminal)
      // keep their content — the session opens through the normal flow then.
      const activePane = panes.find((pane) => pane.id === activePaneId);
      if (activePane?.kind === 'chat') {
        updatePane(activePane.id, {
          sessionId,
          projectId: projectId ?? activePane.projectId ?? null,
          picker: false,
        });
        return activePane.id;
      }

      return openPane('chat', { sessionId, projectId });
    },
    [activePaneId, openPane, panes, setActivePaneId, updatePane],
  );

  const value = useMemo<WorkspaceApi>(
    () => ({
      panes,
      activePaneId,
      lastUsedProjectId,
      setActivePaneId,
      setLastUsedProjectId,
      removePane,
      updatePane,
      reorderPanes,
      canAdd,
      openPane,
      openSession,
    }),
    [panes, activePaneId, lastUsedProjectId, setActivePaneId, setLastUsedProjectId, removePane, updatePane, reorderPanes, canAdd, openPane, openSession],
  );

  return <WorkspaceContext.Provider value={value}>{children}</WorkspaceContext.Provider>;
}

export function useWorkspace(): WorkspaceApi {
  const context = useContext(WorkspaceContext);
  if (!context) {
    throw new Error('useWorkspace must be used within a WorkspaceProvider');
  }
  return context;
}

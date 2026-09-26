import React, { createContext, useCallback, useContext, useEffect, useMemo, useRef, useState } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {
  addSplitPane,
  canAddSplitPane,
  createSplitPaneId,
  getSplitLayout,
  MAX_SPLIT_PANES,
  nextActivePaneIdAfterClose,
  parseWorkspaceState,
  removeSplitPane,
  reorderSplitPanes,
  serializeWorkspaceState,
  updateSplitPane,
  WORKSPACE_PANES_STORAGE_KEY,
  type PaneKind,
  type WorkspacePane,
  type WorkspaceState,
} from '../lib/workspace-panes';

export interface OpenPaneOptions {
  projectId?: string | null;
  sessionId?: string | null;
  url?: string | null;
  picker?: boolean;
}

interface WorkspaceApi {
  panes: WorkspacePane[];
  activePaneId: string | null;
  lastUsedProjectId: string | null;
  layout: { columns: number; rows: number };
  canAdd: boolean;
  setActivePaneId: (id: string | null) => void;
  setLastUsedProjectId: (id: string | null) => void;
  addPane: (pane: WorkspacePane) => void;
  openPane: (kind: PaneKind, options?: OpenPaneOptions) => string | null;
  openSession: (sessionId: string, projectId?: string | null) => string | null;
  removePane: (id: string) => void;
  updatePane: (id: string, patch: Partial<Omit<WorkspacePane, 'id' | 'kind'>>) => void;
  reorderPanes: (fromId: string, toIndex: number) => void;
  hydrate: (state: WorkspaceState) => void;
}

const WorkspaceContext = createContext<WorkspaceApi | null>(null);

export function WorkspaceProvider({ children }: { children: React.ReactNode }) {
  const [panes, setPanes] = useState<WorkspacePane[]>([]);
  const [activePaneId, setActivePaneIdRaw] = useState<string | null>(null);
  const [lastUsedProjectId, setLastUsedProjectIdRaw] = useState<string | null>(null);
  const hydratedRef = useRef(false);

  // Load persisted workspace once.
  useEffect(() => {
    let cancelled = false;
    (async () => {
      const raw = await AsyncStorage.getItem(WORKSPACE_PANES_STORAGE_KEY);
      if (cancelled) return;
      const state = parseWorkspaceState(raw);
      setPanes(state.panes);
      setActivePaneIdRaw(state.activePaneId);
      setLastUsedProjectIdRaw(state.lastUsedProjectId);
      hydratedRef.current = true;
    })();
    return () => {
      cancelled = true;
    };
  }, []);

  // Persist on every change (after hydration).
  useEffect(() => {
    if (!hydratedRef.current) return;
    void AsyncStorage.setItem(
      WORKSPACE_PANES_STORAGE_KEY,
      serializeWorkspaceState({ panes, activePaneId, lastUsedProjectId }),
    );
  }, [panes, activePaneId, lastUsedProjectId]);

  const setActivePaneId = useCallback((id: string | null) => {
    if (id === null || typeof id === 'string') setActivePaneIdRaw((prev) => (prev === id ? prev : id));
  }, []);

  const setLastUsedProjectId = useCallback((id: string | null) => {
    if (id === null || typeof id === 'string') setLastUsedProjectIdRaw((prev) => (prev === id ? prev : id));
  }, []);

  const addPane = useCallback((pane: WorkspacePane) => {
    setPanes((prev) => {
      const next = addSplitPane(prev, pane);
      if (next.length === prev.length) return prev;
      setActivePaneIdRaw(pane.id);
      return next;
    });
  }, []);

  const openPane = useCallback(
    (kind: PaneKind, options: OpenPaneOptions = {}): string | null => {
      const { projectId = null, sessionId = null, url = null, picker = false } = options;

      // Chat: reuse an existing draft pane.
      if (kind === 'chat') {
        let reused: string | null = null;
        setPanes((prev) => {
          const draft = prev.find((p) => p.kind === 'chat' && (p.picker || !p.sessionId));
          if (sessionId) {
            const sameSession = prev.find((p) => p.kind === 'chat' && p.sessionId === sessionId);
            if (sameSession) {
              reused = sameSession.id;
              return prev;
            }
          }
          if (!sessionId && draft) {
            reused = draft.id;
            return prev;
          }
          if (!canAddSplitPane(prev)) {
            const activeChat = prev.find((p) => p.id === activePaneId && p.kind === 'chat') ?? prev.find((p) => p.kind === 'chat');
            if (activeChat) {
              reused = activeChat.id;
              return updateSplitPane(prev, activeChat.id, { sessionId, projectId, picker });
            }
            return prev;
          }
          const id = createSplitPaneId();
          reused = id;
          return [...prev, { id, kind: 'chat', sessionId, projectId, picker }];
        });
        if (reused) setActivePaneIdRaw(reused);
        return reused;
      }

      // Browser: reuse an existing browser pane.
      if (kind === 'browser' && url) {
        let reused: string | null = null;
        setPanes((prev) => {
          const same = prev.find((p) => p.kind === 'browser' && p.url === url);
          if (same) {
            reused = same.id;
            return prev;
          }
          if (!canAddSplitPane(prev)) return prev;
          const id = createSplitPaneId();
          reused = id;
          return [...prev, { id, kind: 'browser', url }];
        });
        if (reused) setActivePaneIdRaw(reused);
        return reused;
      }

      let created: string | null = null;
      setPanes((prev) => {
        if (!canAddSplitPane(prev)) return prev;
        const id = createSplitPaneId();
        created = id;
        return [
          ...prev,
          { id, kind, projectId, url: kind === 'browser' ? url : undefined, sessionId: null },
        ];
      });
      if (created) setActivePaneIdRaw(created);
      return created;
    },
    [activePaneId],
  );

  const openSession = useCallback(
    (sessionId: string, projectId?: string | null): string | null => {
      let reused: string | null = null;
      setPanes((prev) => {
        const existing = prev.find((p) => p.kind === 'chat' && p.sessionId === sessionId);
        if (existing) {
          reused = existing.id;
          return prev;
        }
        if (!canAddSplitPane(prev)) {
          const activeChat = prev.find((p) => p.id === activePaneId && p.kind === 'chat') ?? prev.find((p) => p.kind === 'chat');
          if (activeChat) {
            reused = activeChat.id;
            return updateSplitPane(prev, activeChat.id, { sessionId, projectId: projectId ?? activeChat.projectId, picker: false });
          }
          return prev;
        }
        const id = createSplitPaneId();
        reused = id;
        return [...prev, { id, kind: 'chat', sessionId, projectId: projectId ?? null }];
      });
      if (reused) setActivePaneIdRaw(reused);
      return reused;
    },
    [activePaneId],
  );

  const removePane = useCallback((id: string) => {
    setPanes((prev) => {
      const index = prev.findIndex((p) => p.id === id);
      if (index < 0) return prev;
      const next = removeSplitPane(prev, id);
      setActivePaneIdRaw((cur) => (cur === id ? nextActivePaneIdAfterClose(next, index) : cur));
      return next;
    });
  }, []);

  const updatePane = useCallback((id: string, patch: Partial<Omit<WorkspacePane, 'id' | 'kind'>>) => {
    setPanes((prev) => updateSplitPane(prev, id, patch));
  }, []);

  const reorderPanes = useCallback((fromId: string, toIndex: number) => {
    setPanes((prev) => reorderSplitPanes(prev, fromId, toIndex));
  }, []);

  const hydrate = useCallback((state: WorkspaceState) => {
    const next = parseWorkspaceState(serializeWorkspaceState(state));
    setPanes(next.panes);
    setActivePaneIdRaw(next.activePaneId);
    setLastUsedProjectIdRaw(next.lastUsedProjectId);
  }, []);

  const value = useMemo<WorkspaceApi>(
    () => ({
      panes,
      activePaneId,
      lastUsedProjectId,
      layout: getSplitLayout(panes.length),
      canAdd: canAddSplitPane(panes) && panes.length < MAX_SPLIT_PANES,
      setActivePaneId,
      setLastUsedProjectId,
      addPane,
      openPane,
      openSession,
      removePane,
      updatePane,
      reorderPanes,
      hydrate,
    }),
    [
      panes,
      activePaneId,
      lastUsedProjectId,
      setActivePaneId,
      setLastUsedProjectId,
      addPane,
      openPane,
      openSession,
      removePane,
      updatePane,
      reorderPanes,
      hydrate,
    ],
  );

  return <WorkspaceContext.Provider value={value}>{children}</WorkspaceContext.Provider>;
}

export function useWorkspace(): WorkspaceApi {
  const ctx = useContext(WorkspaceContext);
  if (!ctx) throw new Error('useWorkspace must be used within a WorkspaceProvider');
  return ctx;
}

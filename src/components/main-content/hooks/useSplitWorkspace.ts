import { useCallback, useEffect, useMemo, useState } from 'react';

import {
  addSplitPane,
  canAddSplitPane,
  getSplitLayout,
  removeSplitPane,
  reorderSplitPanes,
  updateSplitPane,
  type SplitPane,
} from '../utils/splitWorkspace';
import {
  readWorkspaceState,
  sanitizeWorkspaceState,
  writeWorkspaceState,
  type WorkspaceState,
} from '../utils/workspacePanes';

/**
 * Persistent split workspace.
 *
 * Panes are first-class and survive reloads; the URL never owns a session. The
 * active pane is tracked alongside the list so focus can be restored. There is
 * deliberately no "primary" pane — every pane resolves its own session.
 */
export function useSplitWorkspace(options?: { initialPanes?: SplitPane[] }) {
  const [state, setState] = useState<WorkspaceState>(() => {
    if (options?.initialPanes) {
      const panes = sanitizeWorkspaceState({ panes: options.initialPanes }).panes;
      return { panes, activePaneId: panes[0]?.id ?? null, lastUsedProjectId: null };
    }
    return readWorkspaceState();
  });

  const { panes, activePaneId, lastUsedProjectId } = state;

  useEffect(() => {
    writeWorkspaceState(state);
  }, [state]);

  const setPanes = useCallback((next: SplitPane[] | ((current: SplitPane[]) => SplitPane[])) => {
    setState((current) => {
      const panesNext = typeof next === 'function' ? next(current.panes) : next;
      const nextState = sanitizeWorkspaceState({
        panes: panesNext,
        activePaneId: current.activePaneId,
        lastUsedProjectId: current.lastUsedProjectId,
      });
      // Keep the list even when every pane was closed — the empty workspace is
      // what the launcher renders.
      return { ...current, panes: panesNext, activePaneId: nextState.activePaneId };
    });
  }, []);

  const addPane = useCallback((pane: Omit<SplitPane, 'id'> & { id?: string }) => {
    setState((current) => {
      const panesNext = addSplitPane(current.panes, pane);
      if (panesNext === current.panes) return current;
      const added = panesNext[panesNext.length - 1];
      return { ...current, panes: panesNext, activePaneId: added?.id ?? current.activePaneId };
    });
  }, []);

  const removePane = useCallback((id: string) => {
    setState((current) => {
      const closedIndex = current.panes.findIndex((pane) => pane.id === id);
      const panesNext = removeSplitPane(current.panes, id);
      if (panesNext === current.panes) return current;
      // Focus the neighbor sliding into the closed slot (or the new last pane
      // when the rightmost tile was closed) instead of jumping back to pane 0.
      const activePaneId = current.activePaneId === id
        ? panesNext[Math.min(closedIndex, panesNext.length - 1)]?.id ?? null
        : current.activePaneId;
      return { ...current, panes: panesNext, activePaneId };
    });
  }, []);

  const updatePane = useCallback(
    (id: string, patch: Partial<Omit<SplitPane, 'id' | 'kind'>>) => {
      setState((current) => {
        const panesNext = updateSplitPane(current.panes, id, patch);
        return panesNext === current.panes ? current : { ...current, panes: panesNext };
      });
    },
    [],
  );

  const reorderPanes = useCallback((fromId: string, toIndex: number) => {
    setState((current) => {
      const panesNext = reorderSplitPanes(current.panes, fromId, toIndex);
      return panesNext === current.panes ? current : { ...current, panes: panesNext };
    });
  }, []);

  const setActivePaneId = useCallback((id: string | null) => {
    setState((current) => (current.activePaneId === id ? current : { ...current, activePaneId: id }));
  }, []);

  const setLastUsedProjectId = useCallback((projectId: string | null) => {
    setState((current) =>
      current.lastUsedProjectId === projectId ? current : { ...current, lastUsedProjectId: projectId },
    );
  }, []);

  const layout = useMemo(() => getSplitLayout(panes.length), [panes.length]);
  const canAdd = canAddSplitPane(panes);

  return {
    panes,
    activePaneId,
    lastUsedProjectId,
    setActivePaneId,
    setLastUsedProjectId,
    addPane,
    removePane,
    updatePane,
    reorderPanes,
    setPanes,
    layout,
    canAdd,
  };
}

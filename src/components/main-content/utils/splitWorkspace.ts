export type SplitPaneKind = 'chat' | 'browser' | 'terminal' | 'preview' | 'notes';

export type SplitPane = {
  id: string;
  kind: SplitPaneKind;
  sessionId?: string | null;
  projectId?: string | null;
  url?: string | null;
  /** Chat pane renders the session picker instead of the chat UI. */
  picker?: boolean;
};

export const MAX_SPLIT_PANES = 6;
export const MAX_SPLIT_COLUMNS = 3;
export const MAX_SPLIT_ROWS = 2;

export function getSplitLayout(paneCount: number): { columns: number; rows: number } {
  if (paneCount <= 1) return { columns: 1, rows: 1 };
  if (paneCount === 2) return { columns: 2, rows: 1 };
  if (paneCount === 3) return { columns: 3, rows: 1 };
  if (paneCount === 4) return { columns: 2, rows: 2 };
  return { columns: 3, rows: 2 };
}

export function canAddSplitPane(panes: SplitPane[]): boolean {
  return panes.length < MAX_SPLIT_PANES;
}

let splitPaneIdCounter = 0;

export function createSplitPaneId(): string {
  splitPaneIdCounter += 1;
  return `split-pane-${Date.now().toString(36)}-${splitPaneIdCounter.toString(36)}-${Math.random()
    .toString(36)
    .slice(2, 8)}`;
}

export function addSplitPane(
  panes: SplitPane[],
  pane: Omit<SplitPane, 'id'> & { id?: string },
): SplitPane[] {
  if (!canAddSplitPane(panes)) return panes;
  const next: SplitPane = { ...pane, id: pane.id || createSplitPaneId() };
  return [...panes, next];
}

export function removeSplitPane(panes: SplitPane[], paneId: string): SplitPane[] {
  return panes.filter((pane) => pane.id !== paneId);
}

export function updateSplitPane(
  panes: SplitPane[],
  paneId: string,
  patch: Partial<Omit<SplitPane, 'id' | 'kind'>>,
): SplitPane[] {
  return panes.map((pane) => (pane.id === paneId ? { ...pane, ...patch } : pane));
}

export function reorderSplitPanes(
  panes: SplitPane[],
  fromId: string,
  toIndex: number,
): SplitPane[] {
  const fromIndex = panes.findIndex((pane) => pane.id === fromId);
  if (fromIndex === -1) return panes;

  const clamped = Math.max(0, Math.min(toIndex, panes.length - 1));
  if (clamped === fromIndex) return panes;

  const next = [...panes];
  const [moved] = next.splice(fromIndex, 1);
  next.splice(clamped, 0, moved);
  return next;
}

export function getSplitPaneRequiredAction(
  pane: SplitPane,
  signals: {
    processingSessionIds: ReadonlySet<string>;
    pendingActionSessionIds: ReadonlySet<string>;
  },
): 'question' | 'processing' | 'idle' {
  if (pane.kind !== 'chat' || !pane.sessionId) return 'idle';
  if (signals.pendingActionSessionIds.has(pane.sessionId)) return 'question';
  if (signals.processingSessionIds.has(pane.sessionId)) return 'processing';
  return 'idle';
}

const EMPTY_SESSION_IDS: ReadonlySet<string> = new Set();

export type SplitPaneDisplay = {
  title: string;
  subtitle?: string;
  action: 'question' | 'processing' | 'idle';
};

export function getSplitPaneDisplay(
  pane: SplitPane,
  context: {
    sessionsById?: ReadonlyMap<string, { title?: string; summary?: string; name?: string }>;
    processingSessionIds?: ReadonlySet<string>;
    pendingActionSessionIds?: ReadonlySet<string>;
    projectNamesById?: ReadonlyMap<string, string>;
  },
): SplitPaneDisplay {
  const {
    sessionsById,
    processingSessionIds,
    pendingActionSessionIds,
    projectNamesById,
  } = context;

  if (pane.kind === 'browser') {
    let subtitle: string | undefined;
    try {
      subtitle = pane.url ? new URL(pane.url).hostname : undefined;
    } catch {
      subtitle = pane.url || undefined;
    }
    return { title: 'Browser', subtitle, action: 'idle' };
  }

  if (pane.kind === 'terminal') {
    return {
      title: 'Terminal',
      subtitle: pane.projectId ? projectNamesById?.get(pane.projectId) : undefined,
      action: 'idle',
    };
  }

  if (pane.kind === 'preview') {
    return {
      title: 'Preview',
      subtitle: pane.projectId ? projectNamesById?.get(pane.projectId) : undefined,
      action: 'idle',
    };
  }

  if (pane.kind === 'notes') {
    return {
      title: 'Shared notes',
      subtitle: pane.projectId ? projectNamesById?.get(pane.projectId) : undefined,
      action: 'idle',
    };
  }

  const session = pane.sessionId ? sessionsById?.get(pane.sessionId) : undefined;
  const title =
    session?.summary ||
    session?.title ||
    session?.name ||
    (pane.sessionId ? pane.sessionId.slice(0, 8) : 'Chat');

  return {
    title,
    subtitle: pane.projectId ? projectNamesById?.get(pane.projectId) : undefined,
    action: getSplitPaneRequiredAction(pane, {
      processingSessionIds: processingSessionIds || EMPTY_SESSION_IDS,
      pendingActionSessionIds: pendingActionSessionIds || EMPTY_SESSION_IDS,
    }),
  };
}

import { MAX_SPLIT_PANES, type SplitPane, type SplitPaneKind } from './splitWorkspace';

/**
 * Persisted workspace descriptor.
 *
 * Sessions are intentionally NOT part of the URL anymore. The set of open
 * panes and which one is active live in localStorage instead, so a reload or a
 * notification tap restores the exact same workspace regardless of the route.
 */
export type WorkspaceState = {
  panes: SplitPane[];
  activePaneId: string | null;
  /** Most recently chosen workspace, used as the default in the launcher. */
  lastUsedProjectId: string | null;
};

export const WORKSPACE_PANES_STORAGE_KEY = 'ddagent_workspace_panes';

const PANE_KINDS: readonly SplitPaneKind[] = ['chat', 'browser', 'terminal'];

function isPaneKind(value: unknown): value is SplitPaneKind {
  return typeof value === 'string' && (PANE_KINDS as readonly string[]).includes(value);
}

function readString(value: unknown): string | null {
  return typeof value === 'string' && value.trim() ? value : null;
}

/**
 * Validates a value parsed from storage. Unknown shapes are dropped instead of
 * crashing the app, because this data survives across releases.
 */
export function sanitizePane(value: unknown): SplitPane | null {
  if (!value || typeof value !== 'object') return null;
  const candidate = value as Record<string, unknown>;
  const id = readString(candidate.id);
  if (!id || !isPaneKind(candidate.kind)) return null;

  const pane: SplitPane = { id, kind: candidate.kind as SplitPaneKind };

  if (candidate.kind === 'browser') {
    pane.url = readString(candidate.url);
    return pane;
  }

  pane.sessionId = readString(candidate.sessionId);
  pane.projectId = readString(candidate.projectId);
  if (candidate.picker === true) {
    pane.picker = true;
  }
  return pane;
}

export function sanitizeWorkspaceState(value: unknown): WorkspaceState {
  const empty: WorkspaceState = { panes: [], activePaneId: null, lastUsedProjectId: null };
  if (!value || typeof value !== 'object') {
    return empty;
  }

  const candidate = value as Record<string, unknown>;
  const panes = Array.isArray(candidate.panes)
    ? candidate.panes
        .map((pane) => sanitizePane(pane))
        .filter((pane): pane is SplitPane => pane !== null)
        // The grid layout caps at MAX_SPLIT_PANES cells — extra persisted
        // panes (e.g. written by an older build) would deform it.
        .slice(0, MAX_SPLIT_PANES)
    : [];

  const activePaneId = readString(candidate.activePaneId);
  const hasActive = activePaneId !== null && panes.some((pane) => pane.id === activePaneId);

  return {
    panes,
    activePaneId: hasActive ? activePaneId : panes[0]?.id ?? null,
    lastUsedProjectId: readString(candidate.lastUsedProjectId),
  };
}

/**
 * Project the app context should restore from a persisted workspace.
 *
 * The focused pane wins, but a browser pane carries no project and a chat pane
 * can still be a session-less draft — falling back to any project-bound pane
 * (then to the launcher's last choice) keeps a reload from dropping the whole
 * workspace into the "choose a project" screen.
 */
export function pickWorkspaceProjectId(
  panes: readonly SplitPane[],
  activePaneId: string | null,
  lastUsedProjectId: string | null,
): string | null {
  const active = panes.find((pane) => pane.id === activePaneId);
  return active?.projectId ?? panes.find((pane) => pane.projectId)?.projectId ?? lastUsedProjectId ?? null;
}

export function readWorkspaceState(storage?: Storage): WorkspaceState {
  try {
    const target = storage ?? (typeof localStorage !== 'undefined' ? localStorage : undefined);
    if (!target) return { panes: [], activePaneId: null, lastUsedProjectId: null };
    const raw = target.getItem(WORKSPACE_PANES_STORAGE_KEY);
    if (!raw) return { panes: [], activePaneId: null, lastUsedProjectId: null };
    return sanitizeWorkspaceState(JSON.parse(raw));
  } catch {
    return { panes: [], activePaneId: null, lastUsedProjectId: null };
  }
}

export function writeWorkspaceState(state: WorkspaceState, storage?: Storage): void {
  try {
    const target = storage ?? (typeof localStorage !== 'undefined' ? localStorage : undefined);
    if (!target) return;
    target.setItem(WORKSPACE_PANES_STORAGE_KEY, JSON.stringify(state));
  } catch {
    // Storage full or unavailable — the workspace simply will not persist.
  }
}


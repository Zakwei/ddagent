// Pure split-workspace model mirroring the web `splitWorkspace.ts` /
// `workspacePanes.ts`. No React/RN imports so it can run under node in
// tests/self-check.mts.

export type PaneKind = 'chat' | 'browser' | 'terminal' | 'preview' | 'notes';

export interface WorkspacePane {
  id: string;
  kind: PaneKind;
  sessionId?: string | null;
  projectId?: string | null;
  url?: string | null;
  picker?: boolean;
}

export interface WorkspaceState {
  panes: WorkspacePane[];
  activePaneId: string | null;
  lastUsedProjectId: string | null;
}

export const MAX_SPLIT_PANES = 6;
export const WORKSPACE_PANES_STORAGE_KEY = 'ddagent_workspace_panes';
export const PANE_KINDS: PaneKind[] = ['chat', 'browser', 'terminal', 'preview', 'notes'];

export const EMPTY_WORKSPACE_STATE: WorkspaceState = {
  panes: [],
  activePaneId: null,
  lastUsedProjectId: null,
};

let paneCounter = 0;

export function createSplitPaneId(): string {
  paneCounter += 1;
  return `split-pane-${Date.now().toString(36)}-${paneCounter.toString(36)}-${Math.random()
    .toString(36)
    .slice(2, 8)}`;
}

export function getSplitLayout(count: number): { columns: number; rows: number } {
  if (count <= 1) return { columns: 1, rows: 1 };
  if (count === 2) return { columns: 2, rows: 1 };
  if (count === 3) return { columns: 3, rows: 1 };
  if (count === 4) return { columns: 2, rows: 2 };
  return { columns: 3, rows: 2 };
}

export function canAddSplitPane(panes: WorkspacePane[]): boolean {
  return panes.length < MAX_SPLIT_PANES;
}

export function addSplitPane(panes: WorkspacePane[], pane: WorkspacePane): WorkspacePane[] {
  if (!canAddSplitPane(panes)) return panes;
  return [...panes, pane];
}

export function removeSplitPane(panes: WorkspacePane[], id: string): WorkspacePane[] {
  return panes.filter((p) => p.id !== id);
}

export function updateSplitPane(
  panes: WorkspacePane[],
  id: string,
  patch: Partial<Omit<WorkspacePane, 'id' | 'kind'>>,
): WorkspacePane[] {
  return panes.map((p) => (p.id === id ? { ...p, ...patch } : p));
}

export function reorderSplitPanes(
  panes: WorkspacePane[],
  fromId: string,
  toIndex: number,
): WorkspacePane[] {
  const fromIndex = panes.findIndex((p) => p.id === fromId);
  if (fromIndex < 0) return panes;
  const clamped = Math.max(0, Math.min(toIndex, panes.length - 1));
  if (clamped === fromIndex) return panes;
  const next = [...panes];
  const [moved] = next.splice(fromIndex, 1);
  next.splice(clamped, 0, moved);
  return next;
}

function isValidKind(kind: unknown): kind is PaneKind {
  return typeof kind === 'string' && (PANE_KINDS as string[]).includes(kind);
}

export function sanitizePane(raw: unknown): WorkspacePane | null {
  if (!raw || typeof raw !== 'object') return null;
  const r = raw as Record<string, unknown>;
  if (typeof r.id !== 'string' || !isValidKind(r.kind)) return null;
  const base: WorkspacePane = { id: r.id, kind: r.kind };
  if (r.kind === 'browser') {
    base.url = typeof r.url === 'string' ? r.url : null;
    return base;
  }
  base.sessionId = typeof r.sessionId === 'string' ? r.sessionId : null;
  base.projectId = typeof r.projectId === 'string' ? r.projectId : null;
  if (r.picker === true) base.picker = true;
  return base;
}

export function sanitizeWorkspaceState(raw: unknown): WorkspaceState {
  const r = (raw && typeof raw === 'object' ? raw : {}) as Record<string, unknown>;
  const panesInput = Array.isArray(r.panes) ? r.panes : [];
  const panes = panesInput
    .map(sanitizePane)
    .filter((p): p is WorkspacePane => p !== null)
    .slice(0, MAX_SPLIT_PANES);
  let activePaneId = typeof r.activePaneId === 'string' ? r.activePaneId : null;
  if (!panes.some((p) => p.id === activePaneId)) {
    activePaneId = panes[0]?.id ?? null;
  }
  const lastUsedProjectId = typeof r.lastUsedProjectId === 'string' ? r.lastUsedProjectId : null;
  return { panes, activePaneId, lastUsedProjectId };
}

export function parseWorkspaceState(raw: string | null | undefined): WorkspaceState {
  if (!raw) return { ...EMPTY_WORKSPACE_STATE };
  try {
    return sanitizeWorkspaceState(JSON.parse(raw));
  } catch {
    return { ...EMPTY_WORKSPACE_STATE };
  }
}

export function serializeWorkspaceState(state: WorkspaceState): string {
  return JSON.stringify(sanitizeWorkspaceState(state));
}

export function pickWorkspaceProjectId(state: WorkspaceState): string | null {
  const active = state.panes.find((p) => p.id === state.activePaneId);
  if (active?.projectId) return active.projectId;
  const firstBound = state.panes.find((p) => p.projectId);
  return firstBound?.projectId ?? state.lastUsedProjectId;
}

/** Focus the neighbour at the closed index (web behaviour). */
export function nextActivePaneIdAfterClose(
  panes: WorkspacePane[],
  closedIndex: number,
): string | null {
  if (panes.length === 0) return null;
  return panes[Math.min(closedIndex, panes.length - 1)]?.id ?? null;
}

export function paneDisplayTitle(
  pane: WorkspacePane,
  ctx: { sessionTitle?: string | null; projectName?: string | null; url?: string | null },
): { title: string; subtitle: string } {
  const project = ctx.projectName ?? '';
  switch (pane.kind) {
    case 'browser': {
      const url = ctx.url ?? pane.url ?? '';
      let host = url;
      try {
        host = new URL(url).hostname || url;
      } catch {
        host = url;
      }
      return { title: 'Browser', subtitle: host };
    }
    case 'terminal':
      return { title: 'Terminal', subtitle: project };
    case 'preview':
      return { title: 'Preview', subtitle: project };
    case 'notes':
      return { title: 'Shared notes', subtitle: project };
    case 'chat':
    default: {
      const title =
        (ctx.sessionTitle && ctx.sessionTitle.trim()) ||
        (pane.sessionId ? pane.sessionId.slice(0, 8) : 'Chat');
      return { title, subtitle: project };
    }
  }
}

export function kindLabel(kind: PaneKind): string {
  switch (kind) {
    case 'browser':
      return 'Browser';
    case 'terminal':
      return 'Terminal';
    case 'preview':
      return 'Preview';
    case 'notes':
      return 'Shared notes';
    case 'chat':
    default:
      return 'Chat';
  }
}

export interface ListeningPort {
  port: number;
  address?: string | null;
  pid?: number | null;
  processName?: string | null;
  cwd?: string | null;
}

export function parsePreviewPorts(payload: unknown): ListeningPort[] {
  const p = (payload && typeof payload === 'object' ? payload : {}) as Record<string, unknown>;
  const raw = Array.isArray(p.ports) ? p.ports : [];
  return raw
    .map((entry) => {
      if (!entry || typeof entry !== 'object') return null;
      const e = entry as Record<string, unknown>;
      const port = Number(e.port);
      if (!Number.isFinite(port) || port <= 0) return null;
      return {
        port,
        address: typeof e.address === 'string' ? e.address : null,
        pid: typeof e.pid === 'number' ? e.pid : null,
        processName: typeof e.processName === 'string' ? e.processName : null,
        cwd: typeof e.cwd === 'string' ? e.cwd : null,
      } as ListeningPort;
    })
    .filter((p): p is ListeningPort => p !== null);
}

export const PREVIEW_POLL_MS = 5000;
export const SHARED_CONTEXT_MAX_BYTES = 50 * 1024;

export function buildPreviewUrl(baseUrl: string, port: number, token: string): string {
  const sep = baseUrl.includes('?') ? '&' : '?';
  return `${baseUrl}/api/preview/${port}/${sep}token=${encodeURIComponent(token)}`;
}

export function parseSharedContext(payload: unknown): { content: string; updatedAt: string | null } {
  const p = (payload && typeof payload === 'object' ? payload : {}) as Record<string, unknown>;
  const data = (p.data && typeof p.data === 'object' ? p.data : p) as Record<string, unknown>;
  return {
    content: typeof data.content === 'string' ? data.content : '',
    updatedAt: typeof data.updatedAt === 'string' ? data.updatedAt : null,
  };
}

export function sharedContextByteLength(content: string): number {
  // Manual UTF-8 byte count (Hermes has no guaranteed TextEncoder).
  let bytes = 0;
  for (let i = 0; i < content.length; i += 1) {
    const code = content.charCodeAt(i);
    if (code < 0x80) bytes += 1;
    else if (code < 0x800) bytes += 2;
    else if (code >= 0xd800 && code <= 0xdbff) {
      bytes += 4;
      i += 1;
    } else bytes += 3;
  }
  return bytes;
}

export function isSharedContextTooLarge(content: string): boolean {
  return sharedContextByteLength(content) > SHARED_CONTEXT_MAX_BYTES;
}

export interface BroadcastTarget {
  sessionId: string;
  title: string;
  projectName?: string | null;
}

export interface BroadcastResultItem {
  sessionId: string;
  ok: boolean;
  error?: string;
  messageId?: number | string;
}

export function parseBroadcastResults(payload: unknown): BroadcastResultItem[] {
  const p = (payload && typeof payload === 'object' ? payload : {}) as Record<string, unknown>;
  const data = (p.data && typeof p.data === 'object' ? p.data : p) as Record<string, unknown>;
  const raw = Array.isArray(data.results) ? data.results : [];
  return raw
    .map((entry) => {
      if (!entry || typeof entry !== 'object') return null;
      const e = entry as Record<string, unknown>;
      if (typeof e.sessionId !== 'string') return null;
      return {
        sessionId: e.sessionId,
        ok: e.ok === true,
        error: typeof e.error === 'string' ? e.error : undefined,
        messageId:
          typeof e.messageId === 'string' || typeof e.messageId === 'number'
            ? e.messageId
            : undefined,
      } as BroadcastResultItem;
    })
    .filter((r): r is BroadcastResultItem => r !== null);
}

export function broadcastButtonLabel(count: number): string {
  return count === 1 ? 'Send to 1 session' : `Send to ${count} sessions`;
}

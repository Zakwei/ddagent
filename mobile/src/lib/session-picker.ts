/**
 * Pure helpers for the in-pane session picker, mirrored from the web
 * `main-content/utils/sessionPicker.ts` + `pinnedSessions.ts`. No RN imports so
 * the self-check runner can exercise them directly.
 */

export interface PickerSession {
  id: string;
  summary?: string | null;
  title?: string | null;
  name?: string | null;
  provider?: string | null;
  projectId?: string | null;
  projectPath?: string | null;
  projectName?: string | null;
  isCurrentProject?: boolean;
  lastActivity?: string | null;
  lastViewedAt?: string | null;
  accountId?: string | null;
  messageCount?: number;
}

export interface PickerGroup<T> {
  currentProject: T[];
  currentProjectName: string;
  otherProjects: T[];
}

export interface ArchivedPickerSession {
  sessionId: string;
  provider?: string | null;
  projectId: string | null;
  projectPath?: string | null;
  projectDisplayName: string;
  sessionTitle: string;
  lastActivity: string | null;
  isProjectArchived: boolean;
  messageCount?: number;
}

export interface ArchivedPickerProject {
  projectId: string;
  displayName: string;
  fullPath?: string;
}

export interface ArchivedPickerGroup {
  key: string;
  projectId: string | null;
  projectDisplayName: string;
  projectPath: string | null;
  isProjectArchived: boolean;
  latestActivity: string | null;
  sessions: ArchivedPickerSession[];
}

export const EMPTY_SESSION_IDS: ReadonlySet<string> = new Set();

/** Title preference order matches the web picker. */
export function getPickerSessionTitle(session: PickerSession): string {
  const summary = session.summary?.trim();
  if (summary) return summary;
  const title = session.title?.trim();
  if (title) return title;
  const name = session.name?.trim();
  if (name) return name;
  return session.id.slice(0, 8);
}

export function filterPickerSessions<T extends PickerSession>(sessions: T[], query: string): T[] {
  const trimmed = query.trim().toLowerCase();
  if (!trimmed) return sessions.slice();
  return sessions.filter((s) => {
    const haystack = `${getPickerSessionTitle(s)} ${s.projectName ?? ''}`.toLowerCase();
    return haystack.includes(trimmed);
  });
}

export function groupPickerSessions<T extends PickerSession>(sessions: T[]): PickerGroup<T> {
  const currentProject = sessions.filter((s) => s.isCurrentProject);
  const otherProjects = sessions.filter((s) => !s.isCurrentProject);
  return {
    currentProject,
    currentProjectName: currentProject[0]?.projectName ?? '',
    otherProjects,
  };
}

/** Relative age, matching `formatPickerAge`. */
export function formatPickerAge(lastActivity: string | null | undefined, now: number = Date.now()): string {
  if (!lastActivity) return '';
  const then = new Date(lastActivity).getTime();
  if (!Number.isFinite(then)) return '';
  const seconds = Math.max(0, Math.floor((now - then) / 1000));
  if (seconds < 60) return '<1m';
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}hr`;
  return `${Math.floor(hours / 24)}d`;
}

export function isPickerSessionUnread(session: PickerSession): boolean {
  if (!session.lastActivity) return false;
  if (!session.lastViewedAt) return true;
  return new Date(session.lastViewedAt).getTime() < new Date(session.lastActivity).getTime();
}

/** `excludeId` removes the currently-open session; current-project first, then newest. */
export function getAvailableSplitSessions<T extends PickerSession>(sessions: T[], excludeId?: string | null): T[] {
  const filtered = sessions.filter((s) => s.id !== excludeId);
  return filtered.slice().sort((a, b) => {
    if (Boolean(a.isCurrentProject) !== Boolean(b.isCurrentProject)) {
      return a.isCurrentProject ? -1 : 1;
    }
    const at = a.lastActivity ? new Date(a.lastActivity).getTime() : 0;
    const bt = b.lastActivity ? new Date(b.lastActivity).getTime() : 0;
    return bt - at;
  });
}

// --- Archived view ---------------------------------------------------------

export function groupArchivedPickerSessions(
  sessions: ArchivedPickerSession[],
  projects: ArchivedPickerProject[],
): ArchivedPickerGroup[] {
  const groups = new Map<string, ArchivedPickerGroup>();
  const ensure = (key: string, projectId: string | null, displayName: string, projectPath: string | null, isProjectArchived: boolean) => {
    let group = groups.get(key);
    if (!group) {
      group = { key, projectId, projectDisplayName: displayName, projectPath, isProjectArchived, latestActivity: null, sessions: [] };
      groups.set(key, group);
    }
    return group;
  };

  for (const session of sessions) {
    const key = session.projectId ?? session.projectPath ?? `session:${session.sessionId}`;
    const group = ensure(key, session.projectId, session.projectDisplayName, session.projectPath ?? null, session.isProjectArchived);
    group.sessions.push(session);
  }
  for (const project of projects) {
    ensure(project.projectId, project.projectId, project.displayName, project.fullPath ?? null, true);
  }

  const list = Array.from(groups.values());
  for (const group of list) {
    const times = group.sessions.map((s) => (s.lastActivity ? new Date(s.lastActivity).getTime() : 0));
    const latest = times.length ? Math.max(...times) : null;
    group.latestActivity = latest ? new Date(latest).toISOString() : null;
  }
  // Web sorts by lexical ISO string compare (descending).
  list.sort((a, b) => (b.latestActivity ?? '').localeCompare(a.latestActivity ?? ''));
  return list;
}

// --- Pinned sessions (pure core; AsyncStorage store lives in pinned-sessions.ts)

export function parsePinnedSessions(raw: string | null): string[] {
  if (!raw) return [];
  try {
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed.filter((v): v is string => typeof v === 'string' && v.length > 0);
  } catch {
    return [];
  }
}

export function togglePinnedIn(list: string[], sessionId: string): { list: string[]; pinned: boolean } {
  if (!sessionId || typeof sessionId !== 'string') return { list, pinned: false };
  const has = list.includes(sessionId);
  return has
    ? { list: list.filter((id) => id !== sessionId), pinned: false }
    : { list: [...list, sessionId], pinned: true };
}

/** Stable partition: pinned first, preserving relative order within each bucket. */
export function sortSessionsWithPinned<T extends { id: string | number }>(sessions: T[], isPinned: (id: string) => boolean): T[] {
  const pinned: T[] = [];
  const rest: T[] = [];
  for (const session of sessions) {
    (isPinned(String(session.id)) ? pinned : rest).push(session);
  }
  return [...pinned, ...rest];
}

// --- Draft keys (web chatStorage.ts) --------------------------------------

export const DRAFT_PREFIX = 'draft_input_';

export function sessionDraftKey(sessionId: string): string {
  return `${DRAFT_PREFIX}session_${sessionId}`;
}

export function projectDraftKey(projectId: string): string {
  return `${DRAFT_PREFIX}${projectId}`;
}

/** The legacy key the mobile app used before draft parity: `chat-draft-<id>`. */
export function legacyMobileDraftKey(identifier: string): string {
  return `chat-draft-${identifier}`;
}

/** Prefer the session-scoped key, fall back to the project key. */
export function resolveDraftKey(args: { sessionId?: string | null; projectId?: string | null }): string | null {
  if (args.sessionId) return sessionDraftKey(args.sessionId);
  if (args.projectId) return projectDraftKey(args.projectId);
  return null;
}

// --- Auto-read armed set (pure core) --------------------------------------

export function parseArmedSessions(raw: string | null): string[] {
  return parsePinnedSessions(raw);
}

export function toggleArmedIn(list: string[], sessionId: string, armed: boolean): string[] {
  if (!sessionId) return list;
  const has = list.includes(sessionId);
  if (armed && !has) return [...list, sessionId];
  if (!armed && has) return list.filter((id) => id !== sessionId);
  return list;
}

export function isArmedIn(list: string[], sessionId?: string | null): boolean {
  return Boolean(sessionId && list.includes(sessionId));
}

/** Web dedups by last spoken sequence per session; seq -1 means "never spoke". */
export function shouldSpeakCompletion(lastSpokenSeq: number | undefined, seq: number | undefined): boolean {
  if (typeof seq !== 'number' || !Number.isFinite(seq)) return false;
  return (lastSpokenSeq ?? -1) < seq;
}

import type { ProjectSession } from '../../../types/app';

import type { SplitSessionCandidate } from './splitSessionUtils';

/**
 * Pure helpers behind the in-pane session picker.
 *
 * The picker lists sessions that already exist (grouped by project) plus an
 * optional archive view. Keeping the filtering/grouping here — instead of in
 * the component — makes the behaviour unit-testable and keeps the JSX thin.
 */

export type PickerSessionLike = Pick<ProjectSession, 'id' | 'title' | 'summary' | 'name'>;

/** Title shown for a session row; falls back to a short id stub. */
export function getPickerSessionTitle(session: PickerSessionLike): string {
  const title = session.summary?.trim() || session.title?.trim() || session.name?.trim();
  if (title) return title;
  return typeof session.id === 'string' ? session.id.slice(0, 8) : '';
}

function matchesQuery(query: string, ...values: Array<string | null | undefined>): boolean {
  if (!query) return true;
  return values.some((value) => typeof value === 'string' && value.toLowerCase().includes(query));
}

/**
 * Case-insensitive client-side filter over session title/summary/name and the
 * owning project's display name. An empty query keeps the input order (the
 * caller passes candidates already sorted current-project-first).
 */
export function filterPickerSessions(
  sessions: readonly SplitSessionCandidate[],
  query: string,
): SplitSessionCandidate[] {
  const normalized = query.trim().toLowerCase();
  if (!normalized) return [...sessions];
  return sessions.filter((session) =>
    matchesQuery(normalized, getPickerSessionTitle(session), session.projectName),
  );
}

export type PickerSessionGroups = {
  currentProject: SplitSessionCandidate[];
  /** Display name of the current project, taken from its first candidate. */
  currentProjectName: string;
  otherProjects: SplitSessionCandidate[];
};

export function groupPickerSessions(sessions: readonly SplitSessionCandidate[]): PickerSessionGroups {
  const currentProject: SplitSessionCandidate[] = [];
  const otherProjects: SplitSessionCandidate[] = [];

  for (const session of sessions) {
    if (session.isCurrentProject) {
      currentProject.push(session);
    } else {
      otherProjects.push(session);
    }
  }

  return {
    currentProject,
    currentProjectName: currentProject[0]?.projectName ?? '',
    otherProjects,
  };
}

/** Archived session row as returned by `/api/providers/sessions/archived`. */
export type PickerArchivedSession = {
  sessionId: string;
  provider?: string | null;
  projectId: string | null;
  projectPath?: string | null;
  projectDisplayName: string;
  sessionTitle: string;
  lastActivity: string | null;
  isProjectArchived: boolean;
  messageCount?: number;
};

/** Archived project row as returned by `/api/projects/archived`. */
export type PickerArchivedProject = {
  projectId: string;
  displayName: string;
  fullPath?: string;
};

type PickerPayloadProject = {
  projectId?: unknown;
  displayName?: unknown;
  fullPath?: unknown;
};

type PickerPayloadSession = {
  sessionId?: unknown;
  provider?: unknown;
  projectId?: unknown;
  projectPath?: unknown;
  projectDisplayName?: unknown;
  sessionTitle?: unknown;
  lastActivity?: unknown;
  isProjectArchived?: unknown;
  messageCount?: unknown;
};

/**
 * Defensive parsers for the archive payloads. The picker only needs a handful
 * of fields and must survive rows written by older releases.
 */
export function parseArchivedProjects(payload: unknown): PickerArchivedProject[] {
  const projects = (payload as { data?: { projects?: PickerPayloadProject[] } })?.data?.projects;
  if (!Array.isArray(projects)) return [];
  return projects
    .filter((project): project is PickerPayloadProject => Boolean(project))
    .map((project) => ({
      projectId: typeof project.projectId === 'string' ? project.projectId : '',
      displayName: typeof project.displayName === 'string' ? project.displayName : '',
      fullPath: typeof project.fullPath === 'string' ? project.fullPath : undefined,
    }))
    .filter((project) => project.projectId)
    .map((project) => ({
      ...project,
      displayName: project.displayName || project.projectId,
    }));
}

export function parseArchivedSessions(payload: unknown): PickerArchivedSession[] {
  const sessions = (payload as { data?: { sessions?: PickerPayloadSession[] } })?.data?.sessions;
  if (!Array.isArray(sessions)) return [];
  return sessions
    .filter((session): session is PickerPayloadSession => Boolean(session))
    .map((session) => ({
      sessionId: typeof session.sessionId === 'string' ? session.sessionId : '',
      provider: typeof session.provider === 'string' ? session.provider : null,
      projectId: typeof session.projectId === 'string' && session.projectId ? session.projectId : null,
      projectPath: typeof session.projectPath === 'string' ? session.projectPath : null,
      projectDisplayName:
        typeof session.projectDisplayName === 'string' ? session.projectDisplayName : '',
      sessionTitle:
        typeof session.sessionTitle === 'string' && session.sessionTitle
          ? session.sessionTitle
          : typeof session.sessionId === 'string'
            ? session.sessionId
            : '',
      lastActivity: typeof session.lastActivity === 'string' ? session.lastActivity : null,
      isProjectArchived: session.isProjectArchived === true,
      messageCount: Number(session.messageCount ?? 0),
    }))
    .filter((session) => session.sessionId);
}

export type PickerArchivedGroup = {
  key: string;
  projectId: string | null;
  projectDisplayName: string;
  projectPath: string | null;
  isProjectArchived: boolean;
  latestActivity: string | null;
  sessions: PickerArchivedSession[];
};

export function filterArchivedPickerSessions(
  sessions: readonly PickerArchivedSession[],
  query: string,
): PickerArchivedSession[] {
  const normalized = query.trim().toLowerCase();
  if (!normalized) return [...sessions];
  return sessions.filter((session) =>
    matchesQuery(normalized, session.sessionTitle, session.projectDisplayName),
  );
}

export function filterArchivedProjects(
  projects: readonly PickerArchivedProject[],
  query: string,
): PickerArchivedProject[] {
  const normalized = query.trim().toLowerCase();
  if (!normalized) return [...projects];
  return projects.filter((project) => matchesQuery(normalized, project.displayName, project.projectId));
}

/**
 * Groups archived sessions under their project, newest activity first.
 *
 * Archived projects without any archived session are appended as empty groups
 * so the picker can still offer restoring the workspace itself.
 */
export function groupArchivedPickerSessions(
  sessions: readonly PickerArchivedSession[],
  archivedProjects: readonly PickerArchivedProject[] = [],
): PickerArchivedGroup[] {
  const groups = new Map<string, PickerArchivedGroup>();

  for (const session of sessions) {
    const key = session.projectId ?? session.projectPath ?? `session:${session.sessionId}`;
    const existing = groups.get(key);

    if (existing) {
      existing.sessions.push(session);
      if (
        !existing.latestActivity
        || (session.lastActivity && session.lastActivity > existing.latestActivity)
      ) {
        existing.latestActivity = session.lastActivity;
      }
      continue;
    }

    groups.set(key, {
      key,
      projectId: session.projectId,
      projectDisplayName: session.projectDisplayName,
      projectPath: session.projectPath ?? null,
      isProjectArchived: session.isProjectArchived,
      latestActivity: session.lastActivity,
      sessions: [session],
    });
  }

  for (const project of archivedProjects) {
    if (groups.has(project.projectId)) continue;
    groups.set(project.projectId, {
      key: project.projectId,
      projectId: project.projectId,
      projectDisplayName: project.displayName,
      projectPath: project.fullPath ?? null,
      isProjectArchived: true,
      latestActivity: null,
      sessions: [],
    });
  }

  return [...groups.values()].sort((a, b) =>
    (b.latestActivity ?? '').localeCompare(a.latestActivity ?? ''),
  );
}

/** Compact age label ("<1m", "42m", "3hr", "2d") used by the session rows. */
export function formatPickerAge(
  dateString: string | null | undefined,
  currentTime: Date,
): string {
  if (!dateString) return '';

  const date = new Date(dateString);
  if (Number.isNaN(date.getTime())) return '';

  const minutes = Math.floor(Math.max(0, currentTime.getTime() - date.getTime()) / 60000);
  if (minutes < 1) return '<1m';
  if (minutes < 60) return `${minutes}m`;

  const hours = Math.floor(minutes / 60);
  return hours < 24 ? `${hours}hr` : `${Math.floor(hours / 24)}d`;
}

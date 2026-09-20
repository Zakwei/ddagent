import type { Project, ProjectSession } from '../types/app';

/**
 * Subagent (Task tool / worker) sessions are internal implementation details
 * and should never be visible in user-facing session lists on mobile or desktop.
 */
const SUBAGENT_TITLE_PATTERN = /\(@.+?\bsubagent\b\)|\(@subagents\/|\(subagent\)/i;

export const isSubagentSessionTitle = (title: string | null | undefined): boolean => {
  if (!title) return false;
  return SUBAGENT_TITLE_PATTERN.test(title);
};

export const isSubagentSession = (
  session:
    | {
        summary?: string | null;
        sessionTitle?: string | null;
        title?: string | null;
        name?: string | null;
        custom_name?: string | null;
        customName?: string | null;
      }
    | null
    | undefined,
): boolean => {
  if (!session) return false;
  return isSubagentSessionTitle(
    session.summary ??
      session.sessionTitle ??
      session.title ??
      session.name ??
      session.custom_name ??
      session.customName,
  );
};

/**
 * Session-list merge helpers shared by the projects state hook. Kept free of
 * browser imports so they can be unit tested directly.
 */

export const getProjectSessions = (project: Project): ProjectSession[] => {
  return (project.sessions ?? []).filter((session) => !isSubagentSession(session));
};

export const countLoadedProjectSessions = (project: Project): number => getProjectSessions(project).length;

const mergeSessionProviderLists = (baseSessions: ProjectSession[], additionalSessions: ProjectSession[]): ProjectSession[] => {
  const merged = baseSessions.filter((session) => !isSubagentSession(session));
  const seenSessionIds = new Set(merged.map((session) => String(session.id)));

  for (const session of additionalSessions) {
    if (isSubagentSession(session)) {
      continue;
    }
    const sessionId = String(session.id);
    if (seenSessionIds.has(sessionId)) {
      continue;
    }

    merged.push(session);
    seenSessionIds.add(sessionId);
  }

  return merged;
};

/**
 * Re-applies pages of sessions the user had already paginated in, which the
 * incoming snapshot does not contain (the API only returns the newest page).
 *
 * Sessions present in any incoming project are excluded from the restore: a
 * session whose workspace changed moves to a different project, and restoring
 * it to the project it left would show it twice.
 */
export const mergeExpandedSessionPages = (previousProjects: Project[], incomingProjects: Project[]): Project[] => {
  if (previousProjects.length === 0) {
    return incomingProjects;
  }

  const previousByProjectId = new Map(previousProjects.map((project) => [project.projectId, project]));
  const incomingSessionIds = new Set(
    incomingProjects.flatMap((project) => (project.sessions ?? []).map((session) => String(session.id))),
  );

  return incomingProjects.map((incomingProject) => {
    const previousProject = previousByProjectId.get(incomingProject.projectId);
    if (!previousProject) {
      return incomingProject;
    }

    const previousLoadedCount = countLoadedProjectSessions(previousProject);
    const incomingLoadedCount = countLoadedProjectSessions(incomingProject);
    if (previousLoadedCount <= incomingLoadedCount) {
      return incomingProject;
    }

    const stillLoadedSessions = (previousProject.sessions ?? []).filter(
      (session) => !incomingSessionIds.has(String(session.id)) && !isSubagentSession(session),
    );

    const mergedProject: Project = {
      ...incomingProject,
      sessions: mergeSessionProviderLists(incomingProject.sessions ?? [], stillLoadedSessions),
    };

    const totalSessions = Number(incomingProject.sessionMeta?.total ?? previousLoadedCount);
    mergedProject.sessionMeta = {
      ...incomingProject.sessionMeta,
      total: totalSessions,
      hasMore: countLoadedProjectSessions(mergedProject) < totalSessions,
    };

    return mergedProject;
  });
};

export const mergeProjectSessionPage = (
  existingProject: Project,
  sessionsPage: Pick<Project, 'sessions' | 'sessionMeta'>,
): Project => {
  const mergedProject: Project = {
    ...existingProject,
    sessions: mergeSessionProviderLists(existingProject.sessions ?? [], sessionsPage.sessions ?? []),
  };

  const totalSessions = Number(sessionsPage.sessionMeta?.total ?? existingProject.sessionMeta?.total ?? 0);
  mergedProject.sessionMeta = {
    ...existingProject.sessionMeta,
    ...sessionsPage.sessionMeta,
    total: totalSessions,
    hasMore: countLoadedProjectSessions(mergedProject) < totalSessions,
  };

  return mergedProject;
};

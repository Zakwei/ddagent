import type { Project, ProjectSession } from '../../../types/app';

export type SplitSessionCandidate = ProjectSession & {
  projectId: string;
  projectName: string;
  isCurrentProject: boolean;
};

export function getAvailableSplitSessions(
  projectsOrSessions: (Project | ProjectSession)[] | undefined,
  primarySessionId: string | undefined | null,
  currentProjectId?: string | null,
): SplitSessionCandidate[] {
  if (!projectsOrSessions || !projectsOrSessions.length) return [];

  const firstItem = projectsOrSessions[0];
  const isProjectList = Boolean(
    firstItem &&
      typeof firstItem === 'object' &&
      'projectId' in firstItem &&
      Array.isArray((firstItem as Project).sessions),
  );

  const candidates: SplitSessionCandidate[] = [];

  if (isProjectList) {
    const projects = projectsOrSessions as Project[];
    // `currentProjectId` may be unset or point at a project missing from this
    // list — then no session is "current" and everything renders under the
    // misleading "Other projects" header. When only one project contributes
    // candidates, treat it as the current project instead.
    const contributingProjects = projects.filter((project) =>
      (project.sessions || []).some(
        (session) => session && session.id && session.id !== primarySessionId,
      ),
    );
    const resolvedCurrentProjectId =
      currentProjectId && projects.some((project) => project.projectId === currentProjectId)
        ? currentProjectId
        : contributingProjects.length === 1
          ? contributingProjects[0].projectId
          : null;
    for (const project of projects) {
      const isCurrent = Boolean(
        resolvedCurrentProjectId && project.projectId === resolvedCurrentProjectId,
      );
      const projectName = project.displayName || (typeof (project as any).name === 'string' ? (project as any).name : '') || project.projectId;
      for (const session of project.sessions || []) {
        if (!session || !session.id || session.id === primarySessionId) {
          continue;
        }
        candidates.push({
          ...session,
          projectId: project.projectId,
          projectName,
          isCurrentProject: isCurrent,
        });
      }
    }
  } else {
    const sessions = projectsOrSessions as ProjectSession[];
    for (const session of sessions) {
      if (!session || !session.id || session.id === primarySessionId) {
        continue;
      }
      candidates.push({
        ...session,
        projectId: typeof (session as any).projectId === 'string' ? (session as any).projectId : (currentProjectId || ''),
        projectName: currentProjectId || '',
        isCurrentProject: true,
      });
    }
  }

  // Sort: current project sessions first, then newest lastActivity first
  return candidates.sort((a, b) => {
    if (a.isCurrentProject !== b.isCurrentProject) {
      return a.isCurrentProject ? -1 : 1;
    }
    const aTime = a.lastActivity ? new Date(a.lastActivity).getTime() : 0;
    const bTime = b.lastActivity ? new Date(b.lastActivity).getTime() : 0;
    return bTime - aTime;
  });
}



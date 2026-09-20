import { useMemo } from 'react';
import { Folder, Plus } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import type { Project } from '../../../../types/app';

export type WorkspaceLauncherProps = {
  projects: Project[];
  lastUsedProjectId?: string | null;
  onSelectProject: (project: Project) => void;
  onCreateWorkspace?: () => void;
};

/**
 * Shown inside a new chat pane that has no workspace yet. Picking one binds
 * the pane to that workspace; the first entry is the most recently used.
 */
export default function WorkspaceLauncher({
  projects,
  lastUsedProjectId,
  onSelectProject,
  onCreateWorkspace,
}: WorkspaceLauncherProps) {
  const { t } = useTranslation();

  const orderedProjects = useMemo(() => {
    const lastActivityMs = (project: Project) => {
      const value = project.lastActivity;
      return typeof value === 'string' ? new Date(value).getTime() : 0;
    };
    const sorted = [...projects].sort((a, b) => lastActivityMs(b) - lastActivityMs(a));
    if (!lastUsedProjectId) return sorted;
    const preferred = sorted.find((project) => project.projectId === lastUsedProjectId);
    if (!preferred) return sorted;
    return [preferred, ...sorted.filter((project) => project.projectId !== lastUsedProjectId)];
  }, [lastUsedProjectId, projects]);

  return (
    <div className="flex h-full flex-col items-center justify-center overflow-y-auto p-6">
      <div className="w-full max-w-md">
        <div className="mb-5 text-center">
          <div className="mx-auto mb-4 flex h-12 w-12 items-center justify-center rounded-2xl bg-muted/50">
            <Folder className="h-6 w-6 text-muted-foreground" />
          </div>
          <h2 className="mb-1 text-lg font-semibold text-foreground">
            {t('mainContent.chooseWorkspace', 'Choose a workspace')}
          </h2>
          <p className="text-sm text-muted-foreground">
            {t('mainContent.chooseWorkspaceDescription', 'Pick a workspace for this chat, or create a new one in Settings.')}
          </p>
        </div>

        {orderedProjects.length > 0 && (
          <div className="space-y-1">
            {orderedProjects.map((project) => (
              <button
                key={project.projectId}
                onClick={() => onSelectProject(project)}
                className="flex w-full items-center gap-2 rounded-lg border border-border/60 px-3 py-2 text-left text-sm transition-colors hover:border-primary/30 hover:bg-accent"
              >
                <Folder className="h-3.5 w-3.5 shrink-0 text-muted-foreground" />
                <span className="min-w-0 flex-1 truncate text-foreground">
                  {project.displayName || project.projectId}
                </span>
                <span className="shrink-0 truncate text-xs text-muted-foreground" style={{ maxWidth: '45%' }}>
                  {project.fullPath || project.path}
                </span>
              </button>
            ))}
          </div>
        )}

        {onCreateWorkspace && (
          <button
            onClick={onCreateWorkspace}
            className="mt-3 flex w-full items-center justify-center gap-2 rounded-lg border border-dashed border-border/60 px-3 py-2 text-sm text-muted-foreground transition-colors hover:border-primary/30 hover:text-foreground"
          >
            <Plus className="h-3.5 w-3.5" />
            {t('mainContent.createWorkspace', 'Create workspace in Settings')}
          </button>
        )}
      </div>
    </div>
  );
}

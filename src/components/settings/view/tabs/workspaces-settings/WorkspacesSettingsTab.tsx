import { useState } from 'react';
import { AlertTriangle, FolderPlus, Folder, Trash2 } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import ProjectCreationWizard from '../../../../project-creation-wizard';
import { api } from '../../../../../utils/api';
import { usePaletteOps } from '../../../../../contexts/PaletteOpsContext';
import { useWorkspace } from '../../../../../contexts/WorkspaceContext';
import { Button, Dialog, DialogContent, DialogTitle } from '../../../../../shared/view/ui';
import type { SettingsProject } from '../../../types/types';
import SettingsCard from '../../SettingsCard';
import SettingsSection from '../../SettingsSection';

export type WorkspacesSettingsTabProps = {
  projects: SettingsProject[];
  /** Notified after a workspace delete so app state can drop the removed project. */
  onProjectDeleted?: (projectId: string) => void;
};

/**
 * Workspace management moved out of the sidebar: creating and removing
 * workspaces lives here, while the sidebar only launches panes.
 */
export default function WorkspacesSettingsTab({
  projects,
  onProjectDeleted,
}: WorkspacesSettingsTabProps) {
  const { t } = useTranslation('settings');
  const { refreshProjects } = usePaletteOps();
  const { panes, updatePane, lastUsedProjectId, setLastUsedProjectId } = useWorkspace();
  const [showWizard, setShowWizard] = useState(false);
  const [pendingDelete, setPendingDelete] = useState<SettingsProject | null>(null);
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const handleDelete = async (project: SettingsProject) => {
    const projectId = project.projectId;
    if (!projectId) {
      return;
    }

    setPendingDelete(null);
    setDeletingId(projectId);
    setError(null);
    try {
      const response = await api.deleteProject(projectId);
      if (!response.ok) {
        const payload = (await response.json().catch(() => null)) as { error?: string } | null;
        throw new Error(payload?.error || t('workspaces.deleteFailed', 'Failed to remove workspace.'));
      }
      // Panes persist their own projectId/sessionId in localStorage — drop
      // references to the removed workspace or the tiles keep pointing at a
      // project that no longer exists (same cleanup convention as the
      // session-delete handling in AppContent).
      panes
        .filter((pane) => pane.projectId === projectId)
        .forEach((pane) => updatePane(pane.id, { projectId: null, sessionId: null }));
      if (lastUsedProjectId === projectId) {
        setLastUsedProjectId(null);
      }
      onProjectDeleted?.(projectId);
      void refreshProjects();
    } catch (deleteError) {
      setError(deleteError instanceof Error ? deleteError.message : String(deleteError));
    } finally {
      setDeletingId(null);
    }
  };

  return (
    <div className="space-y-8">
      {error && (
        <div className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700 dark:border-red-800/50 dark:bg-red-950/30 dark:text-red-300">
          {error}
        </div>
      )}

      <SettingsSection
        title={t('workspaces.title', 'Workspaces')}
        description={t('workspaces.description', 'Workspaces are directories ddagent can chat, run code, and browse inside.')}
      >
        <SettingsCard className="p-4">
          <button
            onClick={() => setShowWizard(true)}
            className="flex w-full items-center justify-center gap-2 rounded-lg border border-dashed border-border/60 px-3 py-2.5 text-sm text-muted-foreground transition-colors hover:border-primary/30 hover:text-foreground"
          >
            <FolderPlus className="h-4 w-4" />
            {t('workspaces.create', 'Add workspace')}
          </button>
        </SettingsCard>

        <div className="space-y-1">
          {projects.map((project) => (
            <SettingsCard key={project.projectId || project.name} className="flex items-center gap-3 p-3">
              <Folder className="h-4 w-4 shrink-0 text-muted-foreground" />
              <div className="min-w-0 flex-1">
                <div className="truncate text-sm font-medium text-foreground">
                  {project.displayName || project.projectId}
                </div>
                <div className="truncate text-xs text-muted-foreground">
                  {project.fullPath || project.path}
                </div>
              </div>
              {project.projectId && (
                <button
                  onClick={() => setPendingDelete(project)}
                  disabled={deletingId === project.projectId}
                  className="rounded-md p-1.5 text-muted-foreground transition-colors hover:bg-destructive/10 hover:text-destructive disabled:opacity-50"
                  aria-label={t('workspaces.remove', 'Remove workspace')}
                >
                  <Trash2 className="h-4 w-4" />
                </button>
              )}
            </SettingsCard>
          ))}
        </div>
      </SettingsSection>

      {showWizard && (
        <ProjectCreationWizard
          onClose={() => setShowWizard(false)}
          onProjectCreated={() => {
            setShowWizard(false);
            void refreshProjects();
          }}
        />
      )}

      {pendingDelete && (
        <Dialog
          open
          onOpenChange={(nextOpen) => {
            if (!nextOpen) {
              setPendingDelete(null);
            }
          }}
        >
          {/* z-[9999] matches the settings dialog layer — without it this
              nested confirm would render underneath the settings overlay. */}
          <DialogContent
            wrapperClassName="z-[9999]"
            className="max-w-md overflow-hidden border-border bg-card p-0 shadow-2xl"
          >
            <div className="p-6">
              <div className="flex items-start gap-4">
                <div className="flex h-12 w-12 flex-shrink-0 items-center justify-center rounded-full bg-orange-100 dark:bg-orange-900/30">
                  <AlertTriangle className="h-6 w-6 text-orange-600 dark:text-orange-400" />
                </div>
                <div className="min-w-0 flex-1">
                  <DialogTitle className="not-sr-only mb-2 text-lg font-semibold text-foreground">
                    {t('workspaces.deleteTitle', 'Remove workspace')}
                  </DialogTitle>
                  <p className="text-sm text-muted-foreground">
                    {t('workspaces.deleteConfirm', 'Remove this workspace from ddagent? Its files stay on disk.')}{' '}
                    <span className="font-medium text-foreground">
                      {pendingDelete.displayName || pendingDelete.projectId}
                    </span>
                  </p>
                </div>
              </div>
            </div>
            <div className="flex flex-col gap-2 border-t border-border bg-muted/30 p-4">
              <Button
                variant="destructive"
                className="w-full bg-red-600 text-white hover:bg-red-700"
                disabled={deletingId !== null}
                onClick={() => void handleDelete(pendingDelete)}
              >
                <Trash2 className="mr-2 h-4 w-4" />
                {t('workspaces.remove', 'Remove workspace')}
              </Button>
              <Button variant="ghost" className="w-full" onClick={() => setPendingDelete(null)}>
                {t('workspaces.cancel', 'Cancel')}
              </Button>
            </div>
          </DialogContent>
        </Dialog>
      )}
    </div>
  );
}

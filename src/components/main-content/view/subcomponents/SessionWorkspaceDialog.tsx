import { useCallback, useEffect, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { Button, Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import WorkspacePathField from '../../../project-creation-wizard/components/WorkspacePathField';

type SessionWorkspaceDialogProps = {
  isOpen: boolean;
  currentPath: string;
  onClose: () => void;
  onSubmit: (projectPath: string) => Promise<{ ok: boolean; error?: string }>;
};

/**
 * Lets the user repoint one chat session at a different workspace directory.
 * The server persists the change on `sessions.project_path`, which the chat
 * runtime reads on every turn, so the agent picks up the new cwd without a
 * session restart.
 */
export default function SessionWorkspaceDialog({
  isOpen,
  currentPath,
  onClose,
  onSubmit,
}: SessionWorkspaceDialogProps) {
  const { t } = useTranslation(['sidebar', 'common']);
  const [workspacePath, setWorkspacePath] = useState(currentPath);
  const [isSaving, setIsSaving] = useState(false);
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  useEffect(() => {
    if (isOpen) {
      setWorkspacePath(currentPath);
      setErrorMessage(null);
    }
  }, [currentPath, isOpen]);

  const handleOpenChange = useCallback(
    (open: boolean) => {
      if (!open && !isSaving) {
        onClose();
      }
    },
    [isSaving, onClose],
  );

  const handleSubmit = useCallback(async () => {
    const trimmedPath = workspacePath.trim();
    if (!trimmedPath) {
      setErrorMessage(t('workspace.pathRequired', 'Workspace path is required.'));
      return;
    }

    setIsSaving(true);
    setErrorMessage(null);
    try {
      const result = await onSubmit(trimmedPath);
      if (result.ok) {
        onClose();
        return;
      }

      setErrorMessage(result.error || t('messages.changeWorkspaceFailed', 'Failed to change workspace. Please try again.'));
    } catch (error) {
      console.error('[SessionWorkspaceDialog] Failed to change workspace:', error);
      setErrorMessage(t('messages.changeWorkspaceError', 'Error changing workspace. Please try again.'));
    } finally {
      setIsSaving(false);
    }
  }, [onClose, onSubmit, t, workspacePath]);

  return (
    <Dialog open={isOpen} onOpenChange={handleOpenChange}>
      <DialogContent className="max-w-lg p-0">
        <DialogTitle>{t('workspace.title', 'Change session workspace')}</DialogTitle>
        <div className="space-y-4 p-6">
          <p className="text-sm text-muted-foreground">
            {t(
              'workspace.description',
              'The agent runs its next turns in this directory. Existing session history is kept.',
            )}
          </p>
          <div className="space-y-2">
            <label className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
              {t('workspace.pathLabel', 'Workspace path')}
            </label>
            <WorkspacePathField
              value={workspacePath}
              disabled={isSaving}
              onChange={setWorkspacePath}
              onAdvanceToConfirm={() => void handleSubmit()}
            />
          </div>
          {errorMessage && <p className="text-sm text-red-500">{errorMessage}</p>}
        </div>
        <div className="flex flex-col gap-2 border-t border-border bg-muted/30 p-4">
          <Button className="w-full justify-start" disabled={isSaving} onClick={() => void handleSubmit()}>
            {isSaving
              ? t('workspace.saving', 'Changing…')
              : t('workspace.submit', 'Change workspace')}
          </Button>
          <Button variant="ghost" className="w-full" disabled={isSaving} onClick={onClose}>
            {t('actions.cancel', 'Cancel')}
          </Button>
        </div>
      </DialogContent>
    </Dialog>
  );
}

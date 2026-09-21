import { EyeOff, FolderCog, MoreHorizontal, Repeat2, Trash2 } from 'lucide-react';
import { useCallback, useState } from 'react';
import { useTranslation } from 'react-i18next';

import { api } from '../../../../utils/api';
import { ActionMenu, Button, Dialog, DialogContent, DialogTitle } from '../../../../shared/view/ui';
import type { ProjectSession } from '../../../../types/app';
import { getSessionTitle } from '../../../../utils/pageTitle';

import SessionWorkspaceDialog from './SessionWorkspaceDialog';

type PendingAction = 'archive' | 'delete' | null;

type SessionActionsMenuProps = {
  session: ProjectSession;
  onDeleted: (sessionId: string) => void;
  currentWorkspacePath?: string;
  onChangeWorkspace?: (sessionId: string, projectPath: string) => Promise<{ ok: boolean; error?: string }>;
  /** Reopens the pane in session-picker state so another session can be bound. */
  onChangeSession?: () => void;
  /** Session is mid-generation — repointing its cwd would corrupt the run. */
  isProcessing?: boolean;
  /** Session waits on a tool-permission answer — same cwd hazard. */
  needsAttention?: boolean;
};

export default function SessionActionsMenu({
  session,
  onDeleted,
  currentWorkspacePath,
  onChangeWorkspace,
  onChangeSession,
  isProcessing = false,
  needsAttention = false,
}: SessionActionsMenuProps) {
  const { t } = useTranslation(['sidebar', 'common', 'chat']);
  const [pendingAction, setPendingAction] = useState<PendingAction>(null);
  const [isDeleting, setIsDeleting] = useState(false);
  const [isWorkspaceDialogOpen, setIsWorkspaceDialogOpen] = useState(false);

  const title = getSessionTitle(session);

  const handleConfirm = useCallback(async () => {
    if (!pendingAction) return;

    setIsDeleting(true);
    try {
      const response = await api.deleteSession(session.id, pendingAction === 'delete');
      if (response.ok) {
        setPendingAction(null);
        onDeleted(session.id);
      } else {
        alert(t('messages.deleteSessionFailed', 'Failed to delete session. Please try again.'));
      }
    } catch (error) {
      console.error('[SessionActionsMenu] Failed to delete session:', error);
      alert(t('messages.deleteSessionError', 'Error deleting session. Please try again.'));
    } finally {
      setIsDeleting(false);
    }
  }, [onDeleted, pendingAction, session.id, t]);

  return (
    <>
      <ActionMenu
        label={t('deleteConfirmation.deleteSession', 'Delete Session')}
        ariaLabel={t('sessions.options', 'Session options')}
        icon={MoreHorizontal}
        iconOnly
        portal
        variant="ghost"
        size="icon"
        triggerClassName="h-7 w-7 text-muted-foreground opacity-80 hover:bg-muted hover:opacity-100"
        menuClassName="w-[240px] rounded-xl p-1.5 shadow-xl"
        items={[
          ...(onChangeSession
            ? [
                {
                  key: 'changeSession',
                  label: t('chat:sessionPicker.changeSession', 'Change session'),
                  icon: Repeat2,
                  onSelect: onChangeSession,
                },
              ]
            : []),
          ...(onChangeWorkspace
            ? [
                {
                  key: 'workspace',
                  label: t('workspace.changeAction', 'Change workspace'),
                  icon: FolderCog,
                  // Changing cwd mid-generation or during a permission wait
                  // would run tools in the wrong folder.
                  disabled: isProcessing || needsAttention,
                  onSelect: () => setIsWorkspaceDialogOpen(true),
                },
              ]
            : []),
          {
            key: 'archive',
            label: t('deleteConfirmation.archiveSession', 'Archive session'),
            icon: EyeOff,
            onSelect: () => setPendingAction('archive'),
          },
          {
            key: 'delete',
            label: t('deleteConfirmation.deleteSessionPermanently', 'Delete permanently'),
            icon: Trash2,
            isDanger: true,
            showDividerBefore: true,
            onSelect: () => setPendingAction('delete'),
          },
        ]}
      />

      {onChangeWorkspace && (
        <SessionWorkspaceDialog
          isOpen={isWorkspaceDialogOpen}
          currentPath={currentWorkspacePath ?? ''}
          onClose={() => setIsWorkspaceDialogOpen(false)}
          onSubmit={(projectPath) => onChangeWorkspace(session.id, projectPath)}
        />
      )}

      <Dialog open={pendingAction !== null} onOpenChange={(open) => { if (!open && !isDeleting) setPendingAction(null); }}>
        <DialogContent className="max-w-md overflow-hidden p-0">
          <DialogTitle>{title}</DialogTitle>
          <div className="p-6">
            <h3 className="mb-2 text-lg font-semibold text-foreground">
              {pendingAction === 'archive'
                ? t('deleteConfirmation.archiveSession', 'Archive session')
                : t('deleteConfirmation.deleteSession', 'Delete Session')}
            </h3>
            <p className="mb-1 text-sm text-muted-foreground">
              {t('deleteConfirmation.confirmDelete', 'What would you like to do with')}{' '}
              <span className="font-medium text-foreground">{title || t('sessions.unnamed', 'Unnamed')}</span>?
            </p>
            <p className="mt-3 text-xs text-muted-foreground">
              {pendingAction === 'archive'
                ? t('deleteConfirmation.archiveSessionNotice', 'Archive keeps the session out of the active list while preserving its history.')
                : t('deleteConfirmation.deleteSessionNotice', 'This permanently removes the session and its transcript. This action cannot be undone.')}
            </p>
          </div>
          <div className="flex flex-col gap-2 border-t border-border bg-muted/30 p-4">
            <Button
              variant={pendingAction === 'delete' ? 'destructive' : 'outline'}
              className={pendingAction === 'delete' ? 'w-full justify-start bg-red-600 text-white hover:bg-red-700' : 'w-full justify-start'}
              disabled={isDeleting}
              onClick={() => void handleConfirm()}
            >
              {pendingAction === 'delete' ? <Trash2 className="mr-2 h-4 w-4" /> : <EyeOff className="mr-2 h-4 w-4" />}
              {pendingAction === 'delete'
                ? t('deleteConfirmation.deleteSessionPermanently', 'Delete permanently')
                : t('deleteConfirmation.archiveSession', 'Archive session')}
            </Button>
            <Button variant="ghost" className="w-full" disabled={isDeleting} onClick={() => setPendingAction(null)}>
              {t('actions.cancel', 'Cancel')}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </>
  );
}

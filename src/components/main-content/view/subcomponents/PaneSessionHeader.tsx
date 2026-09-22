import { useEffect, useRef, useState } from 'react';
import { Check, Pencil, TriangleAlert, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../lib/utils';
import LLMProviderLogo from '../../../llm-provider-logo/LLMProviderLogo';
import type { ProjectSession } from '../../../../types/app';
import { getSessionTitle } from '../../../../utils/pageTitle';

import SessionActionsMenu from './SessionActionsMenu';

type PaneSessionHeaderProps = {
  session: ProjectSession;
  projectName: string;
  currentWorkspacePath?: string;
  onRenameSession?: (sessionId: string, summary: string) => Promise<{ ok: boolean; error?: string }>;
  onSessionDelete?: (sessionId: string) => void;
  onChangeSessionWorkspace?: (sessionId: string, projectPath: string) => Promise<{ ok: boolean; error?: string }>;
  /** Reopens the pane in session-picker state so another session can be bound. */
  onChangeSession?: () => void;
  /** Required-attention state of the pane's session (permission prompt, running). */
  requiredAction?: 'question' | 'processing' | 'idle';
};

/**
 * Per-pane session chrome: provider logo, inline-rename title and the session
 * actions menu. Rendered inside each chat pane header so every pane shows the
 * session it belongs to.
 */
export default function PaneSessionHeader({
  session,
  projectName,
  currentWorkspacePath,
  onRenameSession,
  onSessionDelete,
  onChangeSessionWorkspace,
  onChangeSession,
  requiredAction = 'idle',
}: PaneSessionHeaderProps) {
  const { t } = useTranslation(['common', 'sidebar', 'chat']);
  const [isEditing, setIsEditing] = useState(false);
  const [editingName, setEditingName] = useState('');
  const [toast, setToast] = useState<{ message: string; type: 'success' | 'error' } | null>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const sessionTitle = getSessionTitle(session);
  const canRename = Boolean(onRenameSession);

  useEffect(() => {
    setIsEditing(false);
  }, [session.id]);

  useEffect(() => {
    if (isEditing) {
      inputRef.current?.focus();
      inputRef.current?.select();
    }
  }, [isEditing]);

  // Auto-hide toast (same pattern as the file-tree notifications).
  useEffect(() => {
    if (!toast) return;
    const timer = setTimeout(() => setToast(null), 3000);
    return () => clearTimeout(timer);
  }, [toast]);

  const startEditing = () => {
    if (!canRename) return;
    setEditingName(sessionTitle);
    setIsEditing(true);
  };

  const cancelEditing = () => {
    setIsEditing(false);
    setEditingName('');
  };

  const saveEditing = async () => {
    const trimmed = editingName.trim();
    if (trimmed && trimmed !== sessionTitle) {
      const result = await onRenameSession?.(session.id, trimmed);
      if (result && !result.ok) {
        setToast({
          message:
            result.error ||
            t('messages.renameSessionFailed', 'Failed to rename session. Please try again.'),
          type: 'error',
        });
      }
    }
    cancelEditing();
  };

  return (
    <div className="flex min-w-0 flex-1 items-center gap-1.5">
      <LLMProviderLogo provider={session.__provider} className="h-3.5 w-3.5 flex-shrink-0" />

      {requiredAction === 'question' && (
        <span
          role="img"
          className="flex h-4 w-4 flex-shrink-0 items-center justify-center text-amber-500"
          title={t('chat:splitOverview.question', { defaultValue: 'Awaiting input' })}
          aria-label={t('chat:splitOverview.question', { defaultValue: 'Awaiting input' })}
        >
          <TriangleAlert className="h-3.5 w-3.5" />
        </span>
      )}

      {isEditing ? (
        <div className="flex min-w-0 flex-1 items-center gap-1">
          <input
            ref={inputRef}
            type="text"
            value={editingName}
            onChange={(event) => setEditingName(event.target.value)}
            onKeyDown={(event) => {
              event.stopPropagation();
              if (event.key === 'Enter') saveEditing();
              else if (event.key === 'Escape') cancelEditing();
            }}
            // Blur commits like Enter (standard inline-rename behavior) —
            // the X button and Escape still discard via cancelEditing, and
            // their onMouseDown preventDefault keeps this blur from firing
            // first. saveEditing no-ops when the name is unchanged/empty.
            onBlur={saveEditing}
            aria-label={t('sessions.renameSession', 'Rename session')}
            className="w-full min-w-0 rounded border border-border bg-background px-1.5 py-0.5 text-xs font-medium text-foreground focus:outline-none focus:ring-1 focus:ring-primary"
          />
          <button
            type="button"
            onMouseDown={(event) => event.preventDefault()}
            onClick={saveEditing}
            aria-label={t('actions.save', 'Save')}
            className="flex h-5 w-5 flex-shrink-0 items-center justify-center rounded text-green-600 hover:bg-green-500/10"
          >
            <Check className="h-3 w-3" />
          </button>
          <button
            type="button"
            onMouseDown={(event) => event.preventDefault()}
            onClick={cancelEditing}
            aria-label={t('actions.cancel', 'Cancel')}
            className="flex h-5 w-5 flex-shrink-0 items-center justify-center rounded text-muted-foreground hover:bg-muted"
          >
            <X className="h-3 w-3" />
          </button>
        </div>
      ) : (
        <button
          type="button"
          onClick={startEditing}
          disabled={!canRename}
          title={canRename ? t('sessions.renameSession', 'Rename session') : sessionTitle}
          className={cn(
            'group/pane-title flex min-w-0 items-center gap-1 rounded text-left',
            canRename && 'cursor-text',
          )}
        >
          <span className="truncate text-xs font-medium text-foreground">{sessionTitle}</span>
          {canRename && (
            <Pencil className="h-3 w-3 flex-shrink-0 text-muted-foreground/0 transition-colors group-hover/pane-title:text-muted-foreground" />
          )}
        </button>
      )}

      <span className="hidden flex-shrink-0 truncate text-[10px] text-muted-foreground/70 sm:inline">{projectName}</span>

      {onSessionDelete && (
        <SessionActionsMenu
          session={session}
          onDeleted={onSessionDelete}
          currentWorkspacePath={currentWorkspacePath}
          onChangeWorkspace={onChangeSessionWorkspace}
          onChangeSession={onChangeSession}
          isProcessing={requiredAction === 'processing'}
          needsAttention={requiredAction === 'question'}
        />
      )}

      {toast && (
        <div
          role="status"
          className={cn(
            'fixed bottom-[calc(1rem_+_env(safe-area-inset-bottom))] right-[calc(1rem_+_env(safe-area-inset-right))] z-[9999] flex items-center gap-2 rounded-lg px-4 py-2 text-white shadow-lg animate-in slide-in-from-bottom-2',
            toast.type === 'success' ? 'bg-green-600' : 'bg-red-600',
          )}
        >
          {toast.type === 'success' ? (
            <Check className="h-4 w-4" />
          ) : (
            <X className="h-4 w-4" />
          )}
          <span className="text-sm">{toast.message}</span>
        </div>
      )}
    </div>
  );
}

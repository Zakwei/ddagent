import { useEffect, useMemo, useRef, useState } from 'react';
import { Archive, EyeOff, Folder, Loader2, MessageSquarePlus, RotateCcw, Search, Trash2, X } from 'lucide-react';
import { useTranslation } from 'react-i18next';

import { cn } from '../../../../lib/utils';
import { Button, Dialog, DialogContent, DialogTitle, Input } from '../../../../shared/view/ui';
import LLMProviderLogo from '../../../llm-provider-logo/LLMProviderLogo';
import type { SplitSessionCandidate } from '../../utils/splitSessionUtils';
import {
  filterArchivedPickerSessions,
  filterArchivedProjects,
  filterPickerSessions,
  formatPickerAge,
  getPickerSessionTitle,
  groupArchivedPickerSessions,
  groupPickerSessions,
  type PickerArchivedGroup,
  type PickerArchivedProject,
  type PickerArchivedSession,
} from '../../utils/sessionPicker';

type SessionPickerProps = {
  /** Candidate sessions, current project first (see getAvailableSplitSessions). */
  sessions: SplitSessionCandidate[];
  /** Sessions currently mid-generation, marked with a running dot. */
  processingSessionIds?: ReadonlySet<string>;
  /** Picker rendered in the focused pane — owns autofocus and the Escape key. */
  isActive?: boolean;
  /** Pane already has a session: offer Cancel to go back to it. */
  canCancel?: boolean;
  onSelectSession: (session: SplitSessionCandidate) => void;
  onNewChat: () => void;
  onCancel?: () => void;
  /**
   * Archive view (optional). When `onLoadArchived` is omitted the picker hides
   * the Archived toggle — the data itself is owned by the parent, which keeps
   * this component free of API imports.
   */
  archivedSessions?: PickerArchivedSession[];
  archivedProjects?: PickerArchivedProject[];
  isArchivedLoading?: boolean;
  archivedError?: boolean;
  onLoadArchived?: () => Promise<void>;
  onRestoreSession?: (sessionId: string) => Promise<boolean>;
  onRestoreProject?: (projectId: string) => Promise<boolean>;
  /** Archives one session; resolves true on success. */
  onArchiveSession?: (sessionId: string) => Promise<boolean>;
  /** Permanently deletes one session; resolves true on success. */
  onDeleteSession?: (sessionId: string) => Promise<boolean>;
};

const EMPTY_SESSION_IDS: ReadonlySet<string> = new Set();
const ARCHIVE_SKELETON_ROWS = 4;

function ProviderBadge({ provider }: { provider?: string | null }) {
  return (
    <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-md bg-muted/50">
      <LLMProviderLogo provider={provider} className="h-4 w-4" />
    </span>
  );
}

const rowClass =
  'flex w-full items-center gap-2 rounded-md px-2 py-1.5 text-left transition-colors hover:bg-accent focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring';

const groupHeadingClass =
  'px-2 pb-0.5 pt-1 text-[10px] font-semibold uppercase tracking-wide text-muted-foreground/70';

const restoreButtonClass =
  'flex h-6 flex-shrink-0 items-center gap-1 rounded px-1.5 text-[10px] text-muted-foreground transition-colors hover:bg-emerald-500/10 hover:text-emerald-700 disabled:opacity-50 dark:hover:text-emerald-300';

const rowActionButtonClass =
  'flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-md text-muted-foreground transition-colors disabled:opacity-50';

const archiveRowButtonClass = `${rowActionButtonClass} hover:bg-muted hover:text-foreground`;

const deleteRowButtonClass = `${rowActionButtonClass} hover:bg-red-500/10 hover:text-red-600`;

/**
 * Session picker rendered inside a chat pane instead of the chat UI.
 *
 * Opened by "+ chat pane" (no session yet) or "Change session" on a bound
 * pane. Selecting a session binds it to the pane; "+ New chat" falls back to
 * the regular draft flow; Cancel only appears when there is a session to
 * return to. The archive toggle lists archived sessions so they can be
 * restored (together with their workspace) without leaving the pane.
 */
export default function SessionPicker({
  sessions,
  processingSessionIds = EMPTY_SESSION_IDS,
  isActive = true,
  canCancel = false,
  onSelectSession,
  onNewChat,
  onCancel,
  archivedSessions = [],
  archivedProjects = [],
  isArchivedLoading = false,
  archivedError = false,
  onLoadArchived,
  onRestoreSession,
  onRestoreProject,
  onArchiveSession,
  onDeleteSession,
}: SessionPickerProps) {
  const { t } = useTranslation(['chat', 'common', 'sidebar']);
  const [query, setQuery] = useState('');
  const [showArchived, setShowArchived] = useState(false);
  const [actionError, setActionError] = useState<string | null>(null);
  const [busySessionId, setBusySessionId] = useState<string | null>(null);
  const [busyProjectId, setBusyProjectId] = useState<string | null>(null);
  const [busyRowAction, setBusyRowAction] = useState<{
    sessionId: string;
    action: 'archive' | 'delete';
  } | null>(null);
  const [pendingDelete, setPendingDelete] = useState<{ id: string; title: string } | null>(null);
  const [now, setNow] = useState(() => new Date());
  const searchInputRef = useRef<HTMLInputElement>(null);

  const title = t('chat:sessionPicker.title', { defaultValue: 'Select session' });
  const archivedToggleLabel = t('chat:sessionPicker.archivedToggle', { defaultValue: 'Archived' });
  const restoreProjectLabel = t('chat:sessionPicker.restoreProject', { defaultValue: 'Restore workspace' });
  const restoreSessionLabel = t('chat:sessionPicker.restoreSession', { defaultValue: 'Restore session' });
  const runningLabel = t('chat:sessionPicker.running', { defaultValue: 'Session is running' });
  const archiveSessionLabel = t('sidebar:deleteConfirmation.archiveSession', 'Archive session');
  const deleteSessionLabel = t('sidebar:deleteConfirmation.deleteSessionPermanently', 'Delete permanently');

  useEffect(() => {
    if (!isActive) return;
    searchInputRef.current?.focus();
  }, [isActive]);

  useEffect(() => {
    // Ages are coarse ("42m") — refresh them once a minute like the sidebar.
    const timer = setInterval(() => setNow(new Date()), 60000);
    return () => clearInterval(timer);
  }, []);

  useEffect(() => {
    if (!isActive || !canCancel || !onCancel) return;
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onCancel();
    };
    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [canCancel, isActive, onCancel]);

  const handleToggleArchived = () => {
    const next = !showArchived;
    setShowArchived(next);
    setActionError(null);
    if (next) void onLoadArchived?.();
  };

  const handleRestoreSession = async (sessionId: string) => {
    if (!onRestoreSession) return;
    setActionError(null);
    setBusySessionId(sessionId);
    try {
      const ok = await onRestoreSession(sessionId);
      if (!ok) {
        setActionError(
          t('chat:sessionPicker.restoreSessionFailed', {
            defaultValue: 'Failed to restore session. Please try again.',
          }),
        );
      }
    } finally {
      setBusySessionId(null);
    }
  };

  const handleRestoreProject = async (projectId: string) => {
    if (!onRestoreProject) return;
    setActionError(null);
    setBusyProjectId(projectId);
    try {
      const ok = await onRestoreProject(projectId);
      if (!ok) {
        setActionError(
          t('chat:sessionPicker.restoreProjectFailed', {
            defaultValue: 'Failed to restore workspace. Please try again.',
          }),
        );
      }
    } finally {
      setBusyProjectId(null);
    }
  };

  // Archiving is reversible, so it runs without a confirmation step.
  const handleArchiveRowSession = async (sessionId: string) => {
    if (!onArchiveSession) return;
    setActionError(null);
    setBusyRowAction({ sessionId, action: 'archive' });
    try {
      const ok = await onArchiveSession(sessionId);
      if (!ok) {
        setActionError(t('chat:sessionPicker.archiveFailed', 'Failed to archive session. Please try again.'));
      }
    } finally {
      setBusyRowAction(null);
    }
  };

  const handleConfirmDeleteRowSession = async () => {
    if (!onDeleteSession || !pendingDelete) return;
    setActionError(null);
    setBusyRowAction({ sessionId: pendingDelete.id, action: 'delete' });
    try {
      const ok = await onDeleteSession(pendingDelete.id);
      if (ok) {
        setPendingDelete(null);
      } else {
        setActionError(t('chat:sessionPicker.deleteFailed', 'Failed to delete session. Please try again.'));
      }
    } finally {
      setBusyRowAction(null);
    }
  };

  const filteredSessions = useMemo(() => filterPickerSessions(sessions, query), [query, sessions]);
  const sessionGroups = useMemo(() => groupPickerSessions(filteredSessions), [filteredSessions]);
  const filteredArchivedSessions = useMemo(
    () => filterArchivedPickerSessions(archivedSessions, query),
    [archivedSessions, query],
  );
  const filteredArchivedProjects = useMemo(
    () => filterArchivedProjects(archivedProjects, query),
    [archivedProjects, query],
  );
  const archivedGroups = useMemo(
    () => groupArchivedPickerSessions(filteredArchivedSessions, filteredArchivedProjects),
    [filteredArchivedProjects, filteredArchivedSessions],
  );
  const hasQuery = query.trim().length > 0;

  const renderSessionRow = (session: SplitSessionCandidate) => {
    const isRunning = processingSessionIds.has(session.id);
    const rowAction = busyRowAction?.sessionId === session.id ? busyRowAction.action : null;
    const sessionTitle = getPickerSessionTitle(session);
    return (
      <div key={session.id} className="group flex items-center gap-1">
        <button
          type="button"
          onClick={() => onSelectSession(session)}
          className={cn(rowClass, 'min-w-0 flex-1')}
        >
          <ProviderBadge provider={session.__provider ?? session.provider} />
          <span className="min-w-0 flex-1">
            <span className="block truncate text-xs font-medium text-foreground">
              {sessionTitle}
            </span>
            <span className="block truncate text-[10px] text-muted-foreground">{session.projectName}</span>
          </span>
          {isRunning && (
            <span
              role="status"
              title={runningLabel}
              aria-label={runningLabel}
              className="h-2 w-2 flex-shrink-0 rounded-full bg-emerald-500"
            />
          )}
          <span className="flex-shrink-0 text-[10px] tabular-nums text-muted-foreground">
            {formatPickerAge(session.lastActivity, now)}
          </span>
        </button>
        {(onArchiveSession || onDeleteSession) && (
          // Row actions stay visible on touch widths and reveal on hover/focus
          // on desktop, like the other list rows in the app.
          <div className="flex flex-shrink-0 items-center gap-0.5 opacity-100 transition-opacity sm:opacity-0 sm:focus-within:opacity-100 sm:group-hover:opacity-100">
            {onArchiveSession && (
              <button
                type="button"
                onClick={() => void handleArchiveRowSession(session.id)}
                disabled={rowAction !== null}
                title={`${archiveSessionLabel}: ${sessionTitle}`}
                aria-label={`${archiveSessionLabel}: ${sessionTitle}`}
                className={archiveRowButtonClass}
              >
                {rowAction === 'archive' ? (
                  <Loader2 className="h-3.5 w-3.5 animate-spin" />
                ) : (
                  <EyeOff className="h-3.5 w-3.5" />
                )}
              </button>
            )}
            {onDeleteSession && (
              <button
                type="button"
                onClick={() => setPendingDelete({ id: session.id, title: sessionTitle })}
                disabled={rowAction !== null}
                title={`${deleteSessionLabel}: ${sessionTitle}`}
                aria-label={`${deleteSessionLabel}: ${sessionTitle}`}
                className={deleteRowButtonClass}
              >
                {rowAction === 'delete' ? (
                  <Loader2 className="h-3.5 w-3.5 animate-spin" />
                ) : (
                  <Trash2 className="h-3.5 w-3.5" />
                )}
              </button>
            )}
          </div>
        )}
      </div>
    );
  };

  const renderArchivedGroup = (group: PickerArchivedGroup) => {
    const isRestoringProject = busyProjectId === group.projectId;
    return (
      <section
        key={group.key}
        role="group"
        aria-label={group.projectDisplayName}
        className="mb-1 overflow-hidden rounded-md border border-border/60"
      >
        <div className="flex items-center gap-2 border-b border-border/50 bg-muted/30 px-2 py-1.5">
          <Folder className="h-3.5 w-3.5 flex-shrink-0 text-muted-foreground" />
          <span className="min-w-0 flex-1 truncate text-[11px] font-medium text-foreground">
            {group.projectDisplayName}
          </span>
          {group.isProjectArchived && group.projectId && onRestoreProject && (
            <button
              type="button"
              onClick={() => void handleRestoreProject(group.projectId as string)}
              disabled={isRestoringProject}
              title={restoreProjectLabel}
              aria-label={`${restoreProjectLabel}: ${group.projectDisplayName}`}
              className={restoreButtonClass}
            >
              {isRestoringProject ? (
                <Loader2 className="h-3 w-3 animate-spin" />
              ) : (
                <RotateCcw className="h-3 w-3" />
              )}
              <span>{restoreProjectLabel}</span>
            </button>
          )}
        </div>

        {group.sessions.length === 0 ? (
          <p className="px-2 py-1.5 text-[10px] text-muted-foreground">
            {t('chat:sessionPicker.archivedProjectOnly', {
              defaultValue: 'Workspace archived — restore it to see its sessions.',
            })}
          </p>
        ) : (
          group.sessions.map((session) => {
            const isRestoring = busySessionId === session.sessionId;
            const rowAction = busyRowAction?.sessionId === session.sessionId ? busyRowAction.action : null;
            return (
              <div
                key={session.sessionId}
                className="flex items-center gap-2 border-b border-border/35 px-2 py-1.5 last:border-b-0"
              >
                <ProviderBadge provider={session.provider} />
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-xs text-foreground">{session.sessionTitle}</span>
                  <span className="mt-0.5 flex items-center gap-1 text-[10px] text-muted-foreground">
                    {session.lastActivity && (
                      <span className="tabular-nums">{formatPickerAge(session.lastActivity, now)}</span>
                    )}
                    {(session.messageCount ?? 0) > 0 && (
                      <>
                        <span aria-hidden>·</span>
                        <span className="tabular-nums">{session.messageCount}</span>
                      </>
                    )}
                  </span>
                </span>
                {onRestoreSession && (
                  <button
                    type="button"
                    onClick={() => void handleRestoreSession(session.sessionId)}
                    disabled={isRestoring}
                    title={`${restoreSessionLabel}: ${session.sessionTitle}`}
                    aria-label={`${restoreSessionLabel}: ${session.sessionTitle}`}
                    className={restoreButtonClass}
                  >
                    {isRestoring ? (
                      <Loader2 className="h-3 w-3 animate-spin" />
                    ) : (
                      <RotateCcw className="h-3 w-3" />
                    )}
                    <span>{t('chat:sessionPicker.restore', { defaultValue: 'Restore' })}</span>
                  </button>
                )}
                {onDeleteSession && (
                  <button
                    type="button"
                    onClick={() => setPendingDelete({ id: session.sessionId, title: session.sessionTitle })}
                    disabled={rowAction !== null}
                    title={`${deleteSessionLabel}: ${session.sessionTitle}`}
                    aria-label={`${deleteSessionLabel}: ${session.sessionTitle}`}
                    className={deleteRowButtonClass}
                  >
                    {rowAction === 'delete' ? (
                      <Loader2 className="h-3.5 w-3.5 animate-spin" />
                    ) : (
                      <Trash2 className="h-3.5 w-3.5" />
                    )}
                  </button>
                )}
              </div>
            );
          })
        )}
      </section>
    );
  };

  const renderArchivedBody = () => {
    if (isArchivedLoading) {
      return (
        <div
          role="status"
          aria-live="polite"
          aria-label={t('chat:sessionPicker.archivedLoading', { defaultValue: 'Loading archived sessions...' })}
          className="space-y-1"
        >
          {Array.from({ length: ARCHIVE_SKELETON_ROWS }, (_, index) => (
            <div key={index} className="h-9 animate-pulse rounded-md bg-muted/60" />
          ))}
        </div>
      );
    }

    if (archivedError) {
      return (
        <div role="alert" className="flex flex-col items-center gap-2 px-2 py-6 text-center">
          <p className="text-xs text-destructive">
            {t('chat:sessionPicker.archivedError', { defaultValue: 'Could not load archived sessions' })}
          </p>
          <Button
            variant="outline"
            size="sm"
            className="h-7 text-xs"
            onClick={() => void onLoadArchived?.()}
          >
            {t('common:actions.retry', { defaultValue: 'Retry' })}
          </Button>
        </div>
      );
    }

    if (archivedGroups.length === 0) {
      return (
        <p className="px-2 py-6 text-center text-xs text-muted-foreground">
          {t('chat:sessionPicker.archivedEmpty', { defaultValue: 'No archived sessions' })}
        </p>
      );
    }

    return <>{archivedGroups.map(renderArchivedGroup)}</>;
  };

  return (
    <div
      role="region"
      aria-label={title}
      className="flex h-full min-h-0 flex-col bg-background"
      data-testid="session-picker"
    >
      <div className="flex flex-shrink-0 items-center gap-1.5 border-b border-border/50 px-2 py-1.5">
        <div className="relative min-w-0 flex-1">
          <Search className="pointer-events-none absolute left-2 top-1/2 h-3.5 w-3.5 -translate-y-1/2 text-muted-foreground" />
          <Input
            ref={searchInputRef}
            type="text"
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder={t('chat:sessionPicker.searchPlaceholder', { defaultValue: 'Search sessions...' })}
            aria-label={t('chat:sessionPicker.searchPlaceholder', { defaultValue: 'Search sessions...' })}
            className="h-8 pl-7 pr-7 text-xs"
          />
          {query && (
            <button
              type="button"
              onClick={() => setQuery('')}
              aria-label={t('chat:sessionPicker.clearSearch', { defaultValue: 'Clear search' })}
              title={t('chat:sessionPicker.clearSearch', { defaultValue: 'Clear search' })}
              className="absolute right-1 top-1/2 flex h-6 w-6 -translate-y-1/2 items-center justify-center rounded text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
            >
              <X className="h-3.5 w-3.5" />
            </button>
          )}
        </div>

        {onLoadArchived && (
          <button
            type="button"
            onClick={handleToggleArchived}
            aria-pressed={showArchived}
            aria-label={archivedToggleLabel}
            title={archivedToggleLabel}
            className={cn(
              'flex h-8 flex-shrink-0 items-center gap-1 rounded-md border border-border/60 px-2 text-[11px] transition-colors',
              showArchived
                ? 'bg-primary/10 text-primary'
                : 'text-muted-foreground hover:bg-muted hover:text-foreground',
            )}
          >
            <Archive className="h-3.5 w-3.5" />
            <span className="hidden sm:inline">{archivedToggleLabel}</span>
          </button>
        )}

        {canCancel && onCancel && (
          <Button
            variant="ghost"
            size="sm"
            onClick={onCancel}
            className="h-8 flex-shrink-0 px-2 text-xs"
          >
            {t('common:actions.cancel', { defaultValue: 'Cancel' })}
          </Button>
        )}
      </div>

      <div className="min-h-0 flex-1 overflow-y-auto p-1.5">
        {actionError && (
          <div
            role="alert"
            className="mb-1 rounded-md border border-destructive/40 bg-destructive/10 px-2 py-1.5 text-[11px] text-destructive"
          >
            {actionError}
          </div>
        )}

        <button
          type="button"
          onClick={onNewChat}
          className="mb-1 flex w-full items-center gap-2 rounded-md border border-dashed border-border/70 px-2 py-1.5 text-left transition-colors hover:border-primary/50 hover:bg-accent focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
        >
          <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-md bg-primary/10 text-primary">
            <MessageSquarePlus className="h-4 w-4" />
          </span>
          <span className="min-w-0 flex-1 truncate text-xs font-medium text-foreground">
            {t('chat:sessionPicker.newChat', { defaultValue: '+ New chat' })}
          </span>
        </button>

        {showArchived ? (
          renderArchivedBody()
        ) : filteredSessions.length === 0 ? (
          <p className="px-2 py-6 text-center text-xs text-muted-foreground">
            {hasQuery
              ? t('chat:sessionPicker.emptySearch', { defaultValue: 'No sessions match your search' })
              : t('chat:splitSession.noOtherSessions', { defaultValue: 'No other sessions available' })}
          </p>
        ) : (
          <>
            {sessionGroups.currentProject.length > 0 && (
              <section
                role="group"
                aria-label={t('chat:splitSession.currentProjectGroup', {
                  name: sessionGroups.currentProjectName,
                  defaultValue: 'Current project ({{name}})',
                })}
              >
                <p className={groupHeadingClass}>
                  {t('chat:splitSession.currentProjectGroup', {
                    name: sessionGroups.currentProjectName,
                    defaultValue: 'Current project ({{name}})',
                  })}
                </p>
                {sessionGroups.currentProject.map(renderSessionRow)}
              </section>
            )}
            {sessionGroups.otherProjects.length > 0 && (
              <section
                role="group"
                aria-label={t('chat:splitSession.otherProjectsGroup', { defaultValue: 'Other projects' })}
              >
                <p className={groupHeadingClass}>
                  {t('chat:splitSession.otherProjectsGroup', { defaultValue: 'Other projects' })}
                </p>
                {sessionGroups.otherProjects.map(renderSessionRow)}
              </section>
            )}
          </>
        )}
      </div>

      <Dialog
        open={pendingDelete !== null}
        onOpenChange={(open) => {
          if (!open && busyRowAction?.action !== 'delete') setPendingDelete(null);
        }}
      >
        <DialogContent className="max-w-md overflow-hidden p-0">
          <DialogTitle>{pendingDelete?.title ?? ''}</DialogTitle>
          <div className="p-6">
            <h3 className="mb-2 text-lg font-semibold text-foreground">
              {t('sidebar:deleteConfirmation.deleteSession', 'Delete Session')}
            </h3>
            <p className="mb-1 text-sm text-muted-foreground">
              <span className="font-medium text-foreground">{pendingDelete?.title}</span>
            </p>
            <p className="mt-3 text-xs text-muted-foreground">
              {t(
                'sidebar:deleteConfirmation.deleteSessionNotice',
                'This permanently removes the session and its transcript. This action cannot be undone.',
              )}
            </p>
          </div>
          <div className="flex flex-col gap-2 border-t border-border bg-muted/30 p-4">
            <Button
              variant="destructive"
              className="w-full justify-start bg-red-600 text-white hover:bg-red-700"
              disabled={busyRowAction?.action === 'delete'}
              onClick={() => void handleConfirmDeleteRowSession()}
            >
              <Trash2 className="mr-2 h-4 w-4" />
              {deleteSessionLabel}
            </Button>
            <Button
              variant="ghost"
              className="w-full"
              disabled={busyRowAction?.action === 'delete'}
              onClick={() => setPendingDelete(null)}
            >
              {t('common:actions.cancel', 'Cancel')}
            </Button>
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}

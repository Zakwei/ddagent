import { useEffect } from 'react';
import { AlertTriangle, ClipboardCheck, Folder, Gauge, GitBranch, MessageSquarePlus, Settings, SquareKanban, X } from 'lucide-react';
import { NavLink } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

import { useTasksSettings } from '../../../../contexts/TasksSettingsContext';

type MobileNavMenuProps = {
  open: boolean;
  onClose: () => void;
  /** Opens a chat pane in session-picker state. */
  onNewChat: () => void;
  onShowSettings: () => void;
  restartRequired?: boolean;
};

const itemClass =
  'flex h-11 w-full items-center gap-3 rounded-lg px-3 text-sm text-foreground transition-colors hover:bg-accent/60 active:scale-[0.99]';

const navLinkClass = ({ isActive }: { isActive: boolean }) =>
  `${itemClass} ${isActive ? 'bg-accent text-foreground' : 'text-muted-foreground'}`;

/**
 * Compact mobile navigation menu opened by the hamburger. It replaces the old
 * mobile sidebar drawer: app-level navigation only, no session/project lists.
 */
export default function MobileNavMenu({
  open,
  onClose,
  onNewChat,
  onShowSettings,
  restartRequired = false,
}: MobileNavMenuProps) {
  const { t } = useTranslation(['sidebar', 'common']);
  const { tasksEnabled, isTaskMasterInstalled } = useTasksSettings() as {
    tasksEnabled?: boolean;
    isTaskMasterInstalled?: boolean | null;
  };
  const showTasks = Boolean(tasksEnabled && isTaskMasterInstalled);

  useEffect(() => {
    if (!open) {
      return undefined;
    }

    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'Escape') {
        event.preventDefault();
        onClose();
      }
    };

    window.addEventListener('keydown', handleKeyDown);
    return () => window.removeEventListener('keydown', handleKeyDown);
  }, [open, onClose]);

  if (!open) {
    return null;
  }

  const closeLabel = t('common:buttons.close', 'Close');

  return (
    <div className="fixed inset-0 z-50">
      <button
        type="button"
        className="absolute inset-0 bg-background/60 backdrop-blur-sm"
        onClick={onClose}
        aria-label={closeLabel}
      />
      <div
        className="absolute left-2 top-2 w-[min(18rem,calc(100vw-1rem))] rounded-xl border border-border bg-card p-2 shadow-2xl"
        role="dialog"
        aria-modal="true"
        aria-label={t('panel.navigation', 'Navigation')}
      >
        <div className="flex items-center justify-between px-1 pb-1">
          <span className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            {t('panel.navigation', 'Navigation')}
          </span>
          <button
            type="button"
            onClick={onClose}
            className="flex h-7 w-7 items-center justify-center rounded-md text-muted-foreground transition-colors hover:bg-accent/60 hover:text-foreground"
            aria-label={closeLabel}
          >
            <X className="h-4 w-4" />
          </button>
        </div>

        <button
          type="button"
          className={`${itemClass} bg-accent/60 font-medium`}
          onClick={() => {
            onNewChat();
            onClose();
          }}
        >
          <MessageSquarePlus className="h-4 w-4" />
          {t('panel.newChat', 'New chat')}
        </button>

        <div className="nav-divider my-1.5" />

        <NavLink to="/board" className={navLinkClass} onClick={onClose}>
          <SquareKanban className="h-4 w-4" />
          {t('tabs.board', 'Agent Board')}
        </NavLink>

        {showTasks && (
          <NavLink to="/tasks" className={navLinkClass} onClick={onClose}>
            <ClipboardCheck className="h-4 w-4" />
            {t('tabs.tasks', 'Tasks')}
          </NavLink>
        )}

        <NavLink to="/usage" className={navLinkClass} onClick={onClose}>
          <Gauge className="h-4 w-4" />
          {t('tabs.usage', 'Quota & Usage')}
        </NavLink>

        <NavLink to="/source-control" className={navLinkClass} onClick={onClose}>
          <GitBranch className="h-4 w-4" />
          {t('tabs.git', 'Source Control')}
        </NavLink>

        <NavLink to="/files" className={navLinkClass} onClick={onClose}>
          <Folder className="h-4 w-4" />
          {t('tabs.files', 'Files')}
        </NavLink>

        <div className="nav-divider my-1.5" />

        <button
          type="button"
          className={itemClass}
          onClick={() => {
            onShowSettings();
            onClose();
          }}
        >
          <Settings className="h-4 w-4" />
          {t('actions.settings', 'Settings')}
        </button>

        {restartRequired && (
          <div className="mt-1 flex items-center gap-2 rounded-lg border border-amber-300/60 bg-amber-50/80 px-2.5 py-2 dark:border-amber-700/40 dark:bg-amber-900/15">
            <AlertTriangle className="h-4 w-4 flex-shrink-0 text-amber-500 dark:text-amber-400" />
            <span className="min-w-0 flex-1 text-xs font-medium text-amber-700 dark:text-amber-300">
              {t('version.restartRequired')}
            </span>
          </div>
        )}
      </div>
    </div>
  );
}

import { AlertTriangle, ClipboardCheck, Folder, Gauge, GitBranch, MessageSquarePlus, Settings, SquareKanban } from 'lucide-react';
import { NavLink } from 'react-router-dom';
import { useTranslation } from 'react-i18next';

import { useTasksSettings } from '../../../../contexts/TasksSettingsContext';

type SidebarRailProps = {
  /** Number of sessions currently running (drives the badge on the Panel button). */
  runningCount: number;
  /** Reveals the pane workspace (navigates home, no new pane). */
  onOpenPanel: () => void;
  onShowSettings: () => void;
  restartRequired: boolean;
};

const navLinkClass = ({ isActive }: { isActive: boolean }) =>
  `group flex h-9 w-9 items-center justify-center rounded-lg transition-colors ${
    isActive ? 'bg-accent text-foreground' : 'text-muted-foreground hover:bg-accent/80 hover:text-foreground'
  }`;

const iconButtonClass =
  'group flex h-9 w-9 items-center justify-center rounded-lg text-muted-foreground transition-colors hover:bg-accent/80 hover:text-foreground';

/**
 * Always-visible 48px navigation rail that replaced the session/project
 * browser. It only carries app-level actions: reveal the pane workspace,
 * switch to the standalone pages, and open settings.
 */
export default function SidebarRail({
  runningCount,
  onOpenPanel,
  onShowSettings,
  restartRequired,
}: SidebarRailProps) {
  const { t } = useTranslation(['sidebar', 'common']);
  const { tasksEnabled, isTaskMasterInstalled } = useTasksSettings() as {
    tasksEnabled?: boolean;
    isTaskMasterInstalled?: boolean | null;
  };
  const showTasks = Boolean(tasksEnabled && isTaskMasterInstalled);

  const panelLabel = t('panel.open', 'Panel');
  const panelTitle = runningCount > 0
    ? `${panelLabel} · ${t('search.runningCount', { count: runningCount, defaultValue: '{{count}} active' })}`
    : panelLabel;

  return (
    <div className="flex h-full w-12 flex-col items-center gap-1 bg-background/80 py-3 backdrop-blur-sm">
      {/* Panel: reveals the pane workspace. */}
      <button
        type="button"
        onClick={onOpenPanel}
        className="group relative flex h-9 w-9 items-center justify-center rounded-lg bg-accent/70 transition-colors hover:bg-accent"
        aria-label={panelTitle}
        title={panelTitle}
      >
        <MessageSquarePlus className="h-4 w-4 text-foreground" />
        {runningCount > 0 && (
          <span
            className="absolute -right-0.5 -top-0.5 flex h-4 min-w-4 items-center justify-center rounded-full bg-emerald-500 px-1 text-[10px] font-semibold leading-none text-white"
            data-testid="sidebar-rail-running-badge"
          >
            {runningCount > 99 ? '99+' : runningCount}
          </span>
        )}
      </button>

      <div className="nav-divider my-1 w-6" />

      {/* Agent Board */}
      <NavLink
        to="/board"
        className={navLinkClass}
        aria-label={t('tabs.board', 'Agent Board')}
        title={t('tabs.board', 'Agent Board')}
      >
        <SquareKanban className="h-4 w-4" />
      </NavLink>

      {showTasks && (
        <NavLink
          to="/tasks"
          className={navLinkClass}
          aria-label={t('tabs.tasks', 'Tasks')}
          title={t('tabs.tasks', 'Tasks')}
        >
          <ClipboardCheck className="h-4 w-4" />
        </NavLink>
      )}

      {/* Quota & Usage */}
      <NavLink
        to="/usage"
        className={navLinkClass}
        aria-label={t('tabs.usage', 'Quota & Usage')}
        title={t('tabs.usage', 'Quota & Usage')}
      >
        <Gauge className="h-4 w-4" />
      </NavLink>

      {/* Source Control */}
      <NavLink
        to="/source-control"
        className={navLinkClass}
        aria-label={t('tabs.git', 'Source Control')}
        title={t('tabs.git', 'Source Control')}
      >
        <GitBranch className="h-4 w-4" />
      </NavLink>

      {/* Files */}
      <NavLink
        to="/files"
        className={navLinkClass}
        aria-label={t('tabs.files', 'Files')}
        title={t('tabs.files', 'Files')}
      >
        <Folder className="h-4 w-4" />
      </NavLink>

      <div className="mt-auto flex flex-col items-center gap-1">
        {/* Restart-required indicator */}
        {restartRequired && (
          <div
            className="relative flex h-9 w-9 items-center justify-center rounded-lg"
            aria-label={t('version.restartRequired')}
            title={t('version.restartRequired')}
          >
            <AlertTriangle className="h-4 w-4 text-amber-500" />
            <span className="absolute right-1.5 top-1.5 h-1.5 w-1.5 animate-pulse rounded-full bg-amber-500" />
          </div>
        )}

        {/* Settings */}
        <button
          type="button"
          onClick={onShowSettings}
          className={iconButtonClass}
          aria-label={t('actions.settings', 'Settings')}
          title={t('actions.settings', 'Settings')}
        >
          <Settings className="h-4 w-4" />
        </button>
      </div>
    </div>
  );
}

import { useMemo } from 'react';
import ReactDOM from 'react-dom';

import Settings from '../../../settings/view/Settings';
import type { Project } from '../../../../types/app';
import { normalizeProjectForSettings } from '../../../sidebar/utils/utils';

type SettingsModalHostProps = {
  /** Kept mounted by the app shell so the rail, quick settings and the
   *  command palette can all reach the same modal instance. */
  showSettings: boolean;
  settingsInitialTab: string;
  onCloseSettings: () => void;
  projects: Project[];
  onProjectDeleted?: (projectId: string) => void;
};

/**
 * Settings modal host. Previously lived inside the sidebar; the sidebar
 * browser is gone, but every settings entry point still funnels through
 * `showSettings` / `settingsInitialTab` from `useProjectsState`.
 */
export default function SettingsModalHost({
  showSettings,
  settingsInitialTab,
  onCloseSettings,
  projects,
  onProjectDeleted,
}: SettingsModalHostProps) {
  // Settings expects project identity/path fields to be present for dropdown
  // labels and local-scope MCP config.
  const settingsProjects = useMemo(
    () => projects.map(normalizeProjectForSettings),
    [projects],
  );

  if (!showSettings) {
    return null;
  }

  return ReactDOM.createPortal(
    <Settings
      isOpen={showSettings}
      onClose={onCloseSettings}
      projects={settingsProjects}
      initialTab={settingsInitialTab}
      onProjectDeleted={onProjectDeleted}
    />,
    document.body,
  );
}

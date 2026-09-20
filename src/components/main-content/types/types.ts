import type { Dispatch, SetStateAction } from 'react';

import type { AppTab, Project, ProjectSession } from '../../../types/app';
import type {
  MarkSessionIdle,
  MarkSessionProcessing,
  SessionActivityMap,
} from '../../../hooks/useSessionProtection';
import type { SessionEstablishedContext } from '../../chat/types/types';
import type { SettingsMainTab } from '../../settings/types/types';

export type TaskMasterTask = {
  id: string | number;
  title?: string;
  description?: string;
  status?: string;
  priority?: string;
  details?: string;
  testStrategy?: string;
  parentId?: string | number;
  dependencies?: Array<string | number>;
  subtasks?: TaskMasterTask[];
  [key: string]: unknown;
};

export type TaskReference = {
  id: string | number;
  title?: string;
  [key: string]: unknown;
};

export type TaskSelection = TaskMasterTask | TaskReference;

export type PrdFile = {
  name: string;
  content?: string;
  isExisting?: boolean;
  [key: string]: unknown;
};

export type MainContentProps = {
  selectedProject: Project | null;
  selectedSession: ProjectSession | null;
  /** Sessions resolved outside the paginated project payloads (deep links,
   * optimistic registrations) — lets every pane resolve its session. */
  sessionCache?: ReadonlyMap<string, ProjectSession>;
  activeTab: AppTab;
  setActiveTab: Dispatch<SetStateAction<AppTab>>;
  ws: WebSocket | null;
  sendMessage: (message: unknown) => boolean;
  isMobile: boolean;
  onMenuClick: () => void;
  isLoading: boolean;
  onInputFocusChange: (focused: boolean) => void;
  onSessionProcessing: MarkSessionProcessing;
  onSessionIdle: MarkSessionIdle;
  processingSessions: SessionActivityMap;
  onSessionEstablished: (sessionId: string, context: SessionEstablishedContext) => void;
  onShowSettings: (tab?: SettingsMainTab) => void;
  externalMessageUpdate: number;
  newSessionTrigger: number;
  /** Full project list — powers the "recent projects" empty state. */
  projects: Project[];
  /** Switches the app to another project — used by the git panel's Worktrees view. */
  onProjectSelect: (project: Project) => void;
  /** Silently re-syncs the sidebar project list after worktree projects change. */
  onProjectsRefresh: () => void;
  /** Removes a session from app state after it is archived or deleted. */
  onSessionDelete: (sessionId: string) => void;
  /** Renames a session from the header title inline editor. */
  onRenameSession: (
    sessionId: string,
    summary: string,
  ) => Promise<{ ok: boolean; error?: string }>;
  /** Repoints a session at a different workspace directory. */
  onChangeSessionWorkspace: (
    sessionId: string,
    projectPath: string,
  ) => Promise<{ ok: boolean; error?: string }>;
  isFocusMode?: boolean;
  onToggleFocusMode?: () => void;
};

export type MainContentStateViewProps = {
  mode: 'loading' | 'empty';
  isMobile: boolean;
  onMenuClick: () => void;
  recentProjects?: Project[];
  onProjectSelect?: (project: Project) => void;
};

export type MobileMenuButtonProps = {
  onMenuClick: () => void;
  compact?: boolean;
};

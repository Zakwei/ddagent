import type { Dispatch, SetStateAction } from 'react';

import type { LLMProvider } from '../../../types/app';
import type { ProviderAuthStatus } from '../../provider-auth/types';

export type SettingsMainTab = 'agents' | 'orchestration' | 'appearance' | 'git' | 'api' | 'tasks' | 'browser' | 'notifications' | 'quota' | 'workspaces' | 'schedules' | 'about';
export type AgentProvider = LLMProvider;
export type AgentCategory = 'account' | 'permissions' | 'mcp' | 'skills';
export type ProjectSortOrder = 'name' | 'date';
export type SaveStatus = 'success' | 'error' | null;
export type CodexPermissionMode = 'default' | 'acceptEdits' | 'bypassPermissions';
export type ProviderPermissionMode = 'default' | 'acceptEdits' | 'bypassPermissions' | 'plan';

export type SettingsProject = {
  name: string;
  /** DB identifier; workspaces management uses it for delete/create calls. */
  projectId?: string;
  displayName?: string;
  fullPath?: string;
  path?: string;
};

export type AuthStatus = ProviderAuthStatus;

export type ClaudePermissionsState = {
  allowedTools: string[];
  disallowedTools: string[];
  skipPermissions: boolean;
};

export type NotificationPreferencesState = {
  channels: {
    inApp: boolean;
    webPush: boolean;
    desktop: boolean;
    sound: boolean;
    // Additional delivery channels (telegram, discord, fcm, ...) are toggled
    // dynamically once the user pairs them in Settings.
    [key: string]: boolean;
  };
  events: {
    actionRequired: boolean;
    stop: boolean;
    error: boolean;
  };
};

export type CursorPermissionsState = {
  allowedCommands: string[];
  disallowedCommands: string[];
  skipPermissions: boolean;
};

export type CodeEditorSettingsState = {
  wordWrap: boolean;
  showMinimap: boolean;
  lineNumbers: boolean;
  fontSize: string;
};

export type SettingsStoragePayload = {
  claude: ClaudePermissionsState & { projectSortOrder: ProjectSortOrder; lastUpdated: string };
  cursor: CursorPermissionsState & { lastUpdated: string };
  codex: { permissionMode: CodexPermissionMode; lastUpdated: string };
  opencode: { permissionMode: ProviderPermissionMode; lastUpdated: string };
  devin: { permissionMode: ProviderPermissionMode; lastUpdated: string };
};

export type SettingsProps = {
  isOpen: boolean;
  onClose: () => void;
  projects?: SettingsProject[];
  initialTab?: string;
  /** Called after a workspace is created or deleted so lists can re-sync. */
  onProjectsRefresh?: () => void;
  /** Called after a workspace delete succeeds so selection/panes can drop the removed project. */
  onProjectDeleted?: (projectId: string) => void;
};

export type SetState<T> = Dispatch<SetStateAction<T>>;

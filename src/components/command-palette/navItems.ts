import {
  ClipboardCheck,
  Folder,
  FolderGit2,
  Gauge,
  GitBranch,
  MessageSquare,
  SquareKanban,
} from 'lucide-react';

import type { AppTab } from '../../types/app';

export type NavItem = {
  id: string;
  label: string;
  keywords: string;
  icon: typeof GitBranch;
  /** Workspace tab — revealed through onShowTab (which also navigates home). */
  tab?: AppTab;
  /** Standalone route page (Agent Board sibling) — reached via navigate(). */
  to?: string;
};

// Kept in a leaf module (not the component) so tests can import it without
// pulling the UI barrel — its import.meta.env chain breaks under node:test.
export const NAV_ITEMS: NavItem[] = [
  { id: 'chat', label: 'Go to Chat', keywords: 'chat messages conversation', icon: MessageSquare, tab: 'chat' },
  { id: 'git', label: 'Go to Git', keywords: 'git diff branches', icon: GitBranch, tab: 'git' },
  { id: 'board', label: 'Go to Agent Board', keywords: 'board kanban agents projects', icon: SquareKanban, to: '/board' },
  { id: 'tasks', label: 'Go to Tasks', keywords: 'tasks taskmaster', icon: ClipboardCheck, to: '/tasks' },
  { id: 'usage', label: 'Go to Quota & Usage', keywords: 'usage quota control center tokens cost', icon: Gauge, to: '/usage' },
  { id: 'source-control', label: 'Go to Source Control', keywords: 'source control scm repositories', icon: FolderGit2, to: '/source-control' },
  { id: 'files', label: 'Go to Files', keywords: 'files explorer tree', icon: Folder, to: '/files' },
];

// Mirrors the Alt+1..5 quick-switch mapping in hooks/useAppKeyboardShortcuts.
export function navShortcut(id: string, shouldShowTasksTab: boolean): string | null {
  if (id === 'chat') return 'Alt+1';
  if (id === 'tasks') return shouldShowTasksTab ? 'Alt+2' : null;
  if (id === 'git') return shouldShowTasksTab ? 'Alt+3' : 'Alt+2';
  return null;
}

import * as React from 'react';
import {
  ArrowDownToLine,
  ArrowUpFromLine,
  ChevronRight,
  FileText,
  GitBranch,
  GitCommit,
  GitMerge,
  MessageSquare,
  MessageSquarePlus,
  RefreshCw,
  Settings,
  SquareKanban,
  SunMoon,
  X,
} from 'lucide-react';
import { useNavigate } from 'react-router-dom';

import {
  Command,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  Dialog,
  DialogContent,
  DialogTitle,
} from '../../shared/view/ui';
import { useTheme } from '../../contexts/ThemeContext';
import { usePaletteOps } from '../../contexts/PaletteOpsContext';
import { useTasksSettings } from '../../contexts/TasksSettingsContext';
import { useWorkspace } from '../../contexts/WorkspaceContext';
import { SETTINGS_MAIN_TABS } from '../settings/constants/constants';
import type { AppTab, Project } from '../../types/app';

import { useSessionsSource } from './sources/useSessionsSource';
import type { SessionResult } from './sources/useSessionsSource';
import { useFilesSource } from './sources/useFilesSource';
import { useCommitsSource } from './sources/useCommitsSource';
import { useSessionMessageSearch } from './sources/useSessionMessageSearch';
import { useBranchesSource } from './sources/useBranchesSource';
import { useGitActions } from './sources/useGitActions';
import SessionComparePanel from './SessionComparePanel';

type Page = 'actions' | 'files' | 'sessions' | 'commits' | 'branches' | 'compare';

const PAGE_LABELS: Record<Page, string> = {
  actions: 'Actions',
  files: 'Files',
  sessions: 'Sessions',
  commits: 'Commits',
  branches: 'Branches',
  compare: 'Compare',
};

type CommandPaletteProps = {
  selectedProject: Project | null;
  onStartNewChat: (project: Project) => void;
  onOpenSettings: (tab?: string) => void;
  onShowTab?: (tab: AppTab) => void;
};

const NAV_TABS: Array<{ id: AppTab; label: string; keywords: string; icon: typeof GitBranch }> = [
  { id: 'chat', label: 'Go to Chat', keywords: 'chat messages conversation', icon: MessageSquare },
  { id: 'git', label: 'Go to Git', keywords: 'git diff branches', icon: GitBranch },
  { id: 'tasks', label: 'Go to Tasks', keywords: 'tasks taskmaster', icon: SquareKanban },
];

// Mirrors the Alt+1..5 quick-switch mapping in hooks/useAppKeyboardShortcuts.
function navShortcut(id: AppTab, shouldShowTasksTab: boolean): string | null {
  if (id === 'chat') return 'Alt+1';
  if (id === 'tasks') return shouldShowTasksTab ? 'Alt+2' : null;
  if (id === 'git') return shouldShowTasksTab ? 'Alt+3' : 'Alt+2';
  return null;
}

export default function CommandPalette({
  selectedProject,
  onStartNewChat,
  onOpenSettings,
  onShowTab,
}: CommandPaletteProps) {
  const [open, setOpen] = React.useState(false);
  const [search, setSearch] = React.useState('');
  const [pages, setPages] = React.useState<Page[]>([]);
  const [compareSelection, setCompareSelection] = React.useState<[string, string]>(['', '']);
  const { toggleDarkMode } = useTheme();
  const { openSession, openPane, panes } = useWorkspace();
  const ops = usePaletteOps();
  const navigate = useNavigate();
  const tasksSettings = useTasksSettings() as {
    tasksEnabled?: boolean;
    isTaskMasterInstalled?: boolean | null;
  };
  const shouldShowTasksTab = Boolean(tasksSettings?.tasksEnabled && tasksSettings?.isTaskMasterInstalled);

  const page = pages.at(-1);

  // The palette stays mounted, so this listener also backs the shortcut
  // badges it renders (Ctrl/Cmd+, must work for the badge to be truthful).
  const onOpenSettingsRef = React.useRef(onOpenSettings);
  React.useEffect(() => {
    onOpenSettingsRef.current = onOpenSettings;
  }, [onOpenSettings]);

  React.useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      const isCtrlComma = (e.metaKey || e.ctrlKey) && !e.shiftKey && !e.altKey && e.key === ',';
      if (isCtrlComma) {
        e.preventDefault();
        setOpen(false);
        onOpenSettingsRef.current();
        return;
      }
      const isCmdShiftK = (e.metaKey || e.ctrlKey) && e.shiftKey && !e.altKey && e.key.toLowerCase() === 'k';
      if (!isCmdShiftK) return;
      e.preventDefault();
      setOpen((prev) => !prev);
    };
    document.addEventListener('keydown', handleKeyDown);
    return () => document.removeEventListener('keydown', handleKeyDown);
  }, []);

  React.useEffect(() => {
    if (!open) {
      setSearch('');
      setPages([]);
    }
  }, [open]);

  const projectId = selectedProject?.projectId;

  const showActions = !page || page === 'actions';
  const showSessions = !page || page === 'sessions' || page === 'compare';
  const showFiles = !page || page === 'files';
  const showCommits = !page || page === 'commits';
  const showBranches = !page || page === 'branches' || page === 'actions';

  const sessions = useSessionsSource(projectId, open && showSessions);
  const messageMatches = useSessionMessageSearch(projectId, search, open && showSessions);
  const files = useFilesSource(projectId, open && showFiles);
  const commits = useCommitsSource(projectId, open && showCommits);
  const branches = useBranchesSource(projectId, open && showBranches);
  const git = useGitActions(projectId);

  const sessionRows = React.useMemo(() => {
    if (!showSessions) return [];
    type Row = { id: string; label: string; provider?: string; snippet?: string; projectId?: string | null };
    const byId = new Map<string, Row>();
    for (const s of sessions) {
      byId.set(s.id, { id: s.id, label: s.label, provider: s.provider, projectId: s.projectId });
    }
    for (const m of messageMatches) {
      const existing = byId.get(m.sessionId);
      if (existing) {
        existing.snippet = m.snippet;
        existing.projectId = existing.projectId ?? m.projectId;
      } else {
        byId.set(m.sessionId, {
          id: m.sessionId,
          label: m.label,
          provider: m.provider,
          snippet: m.snippet,
          projectId: m.projectId,
        });
      }
    }
    return Array.from(byId.values());
  }, [sessions, messageMatches, showSessions]);

  const run = React.useCallback((fn: () => void) => {
    setOpen(false);
    fn();
  }, []);

  // Pane the just-executed action activated — its composer should receive
  // keyboard focus instead of the dialog's default focus restore.
  const focusPaneRef = React.useRef<string | null>(null);

  const handleCloseAutoFocus = React.useCallback((event: Event) => {
    const paneId = focusPaneRef.current;
    focusPaneRef.current = null;
    if (!paneId) return;
    event.preventDefault();
    requestAnimationFrame(() => {
      const composer = document.querySelector<HTMLElement>(
        `[data-pane-id="${paneId}"] [data-slot="prompt-input-textarea"]`,
      );
      composer?.focus();
    });
  }, []);

  const pushPage = React.useCallback((next: Page) => {
    setSearch('');
    setPages((prev) => [...prev, next]);
  }, []);

  const popPage = React.useCallback(() => {
    setSearch('');
    setPages((prev) => prev.slice(0, -1));
  }, []);

  const handleKeyDown = React.useCallback((e: React.KeyboardEvent) => {
    if (e.key === 'Backspace' && !search && pages.length > 0) {
      e.preventDefault();
      popPage();
    }
  }, [search, pages.length, popPage]);

  // Opens both compared sessions side-by-side; returns the last activated pane.
  const openComparedInSplit = React.useCallback((): string | null => {
    const [a, b] = compareSelection;
    if (!a || !b || a === b) return null;
    let lastPaneId: string | null = null;
    for (const sessionId of [a, b]) {
      const existing = panes.find((p) => p.kind === 'chat' && p.sessionId === sessionId);
      lastPaneId = existing
        ? openSession(sessionId, projectId ?? null)
        : openPane('chat', { sessionId, projectId: projectId ?? null, reuseDraft: false });
    }
    return lastPaneId;
  }, [compareSelection, openPane, openSession, panes, projectId]);

  const startNewChatDisabled = !selectedProject;
  const browseLimit = 5;
  const filesShown = page === 'files' ? files : files.slice(0, browseLimit);
  const commitsShown = page === 'commits' ? commits : commits.slice(0, browseLimit);
  const sessionsShown = page === 'sessions' ? sessionRows : sessionRows.slice(0, browseLimit);
  const branchesShown = page === 'branches' ? branches : branches.slice(0, browseLimit);

  return (
    <Dialog open={open} onOpenChange={setOpen}>
      <DialogContent className="max-w-xl overflow-hidden p-0" onCloseAutoFocus={handleCloseAutoFocus}>
        <DialogTitle>Command palette</DialogTitle>
        <Command label="Command palette" onKeyDown={handleKeyDown}>
          {page && (
            <div className="flex items-center gap-2 border-b px-3 py-2">
              <span className="inline-flex items-center gap-1 rounded-md bg-accent px-2 py-0.5 text-xs font-medium text-accent-foreground">
                {PAGE_LABELS[page]}
                <button
                  type="button"
                  onClick={popPage}
                  aria-label="Back to all"
                  className="ml-0.5 rounded-sm opacity-70 hover:opacity-100"
                >
                  <X className="h-3 w-3" />
                </button>
              </span>
              <span className="text-xs text-muted-foreground">Backspace to go back</span>
            </div>
          )}
          <CommandInput
            placeholder={page ? `Search ${PAGE_LABELS[page].toLowerCase()}…` : 'Type to search anything…'}
            value={search}
            onValueChange={setSearch}
          />
          <CommandList>
            {/* In compare mode no CommandItems render — an empty state here
                would just float above the compare panel. */}
            {page !== 'compare' && <CommandEmpty>No results.</CommandEmpty>}

            {showActions && (
              <CommandGroup heading="Actions">
                <CommandItem
                  value="Start new chat"
                  disabled={startNewChatDisabled}
                  onSelect={() => {
                    if (!selectedProject) return;
                    run(() => onStartNewChat(selectedProject));
                  }}
                >
                  <MessageSquarePlus className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Start new chat</span>
                  {startNewChatDisabled && (
                    <span className="text-xs text-muted-foreground">Select a project first</span>
                  )}
                </CommandItem>
                <CommandItem value="Open settings" onSelect={() => run(() => onOpenSettings())}>
                  <Settings className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Open settings</span>
                  <Kbd>Ctrl+,</Kbd>
                </CommandItem>
                <CommandItem value="Toggle theme dark light mode" onSelect={() => run(toggleDarkMode)}>
                  <SunMoon className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Toggle theme</span>
                </CommandItem>
                <CommandItem
                  value="Compare sessions providers"
                  disabled={!selectedProject}
                  onSelect={() => { setCompareSelection(['', '']); pushPage('compare'); }}
                >
                  <GitMerge className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Compare sessions</span>
                  <span className="text-xs text-muted-foreground">tokens &amp; cost</span>
                </CommandItem>
              </CommandGroup>
            )}

            {showActions && (
              <CommandGroup heading="Navigate">
                {NAV_TABS.map((tab) => {
                  const Icon = tab.icon;
                  const shortcut = navShortcut(tab.id, shouldShowTasksTab);
                  return (
                    <CommandItem
                      key={tab.id as string}
                      value={`${tab.label} ${tab.keywords}`}
                      onSelect={() => run(() => {
                        // Tasks are a full page (Agent Board sibling) now.
                        if (tab.id === 'tasks') {
                          navigate('/tasks');
                          return;
                        }
                        onShowTab?.(tab.id);
                      })}
                    >
                      <Icon className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                      <span className="flex-1">{tab.label}</span>
                      {shortcut && <Kbd>{shortcut}</Kbd>}
                    </CommandItem>
                  );
                })}
              </CommandGroup>
            )}

            {showActions && projectId && (
              <CommandGroup heading="Git">
                <CommandItem
                  value="Git Fetch remote"
                  onSelect={() => run(() => { void git.fetch(); onShowTab?.('git'); })}
                >
                  <RefreshCw className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Git: Fetch</span>
                </CommandItem>
                <CommandItem
                  value="Git Pull merge upstream"
                  onSelect={() => run(() => { void git.pull(); onShowTab?.('git'); })}
                >
                  <ArrowDownToLine className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Git: Pull</span>
                </CommandItem>
                <CommandItem
                  value="Git Push origin remote"
                  onSelect={() => run(() => { void git.push(); onShowTab?.('git'); })}
                >
                  <ArrowUpFromLine className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                  <span className="flex-1">Git: Push</span>
                </CommandItem>
              </CommandGroup>
            )}

            {showActions && (
              <CommandGroup heading="Settings">
                {SETTINGS_MAIN_TABS.map(({ id, label, keywords, icon: Icon }) => (
                  <CommandItem
                    key={id}
                    value={`Settings ${label} ${keywords}`}
                    onSelect={() => run(() => onOpenSettings(id))}
                  >
                    <Icon className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                    <span className="flex-1">Settings: {label}</span>
                  </CommandItem>
                ))}
              </CommandGroup>
            )}

            {showSessions && page !== 'compare' && projectId && sessionsShown.length > 0 && (
              <CommandGroup heading="Sessions">
                {sessionsShown.map((s) => (
                  <CommandItem
                    key={s.id}
                    value={`${s.label} ${s.snippet ?? ''} ${s.id}`.trim()}
                    onSelect={() => run(() => { focusPaneRef.current = openSession(s.id, s.projectId ?? projectId); })}
                  >
                    <MessageSquare className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                    <div className="flex min-w-0 flex-1 flex-col">
                      <span className="truncate">{s.label}</span>
                      {s.snippet && (
                        <span className="truncate text-xs text-muted-foreground">{s.snippet}</span>
                      )}
                    </div>
                    {s.provider && (
                      <span className="text-xs text-muted-foreground">{s.provider}</span>
                    )}
                  </CommandItem>
                ))}
                {!page && sessionRows.length > browseLimit && (
                  <BrowseAllItem label={`Browse all sessions (${sessionRows.length})`} onSelect={() => pushPage('sessions')} />
                )}
              </CommandGroup>
            )}

            {showFiles && projectId && filesShown.length > 0 && (
              <CommandGroup heading="Files">
                {filesShown.map((f) => (
                  <CommandItem
                    key={f.path}
                    value={f.path}
                    onSelect={() => run(() => ops.openFile(f.path))}
                  >
                    <FileText className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                    <span className="flex-1 truncate">{f.name}</span>
                    <span className="truncate text-xs text-muted-foreground">{f.path}</span>
                  </CommandItem>
                ))}
                {!page && files.length > browseLimit && (
                  <BrowseAllItem label={`Browse all files (${files.length})`} onSelect={() => pushPage('files')} />
                )}
              </CommandGroup>
            )}

            {showCommits && projectId && commitsShown.length > 0 && (
              <CommandGroup heading="Commits">
                {commitsShown.map((c) => (
                  <CommandItem
                    key={c.hash}
                    value={`${c.message} ${c.author} ${c.shortHash}`}
                    onSelect={() => run(() => onShowTab?.('git'))}
                  >
                    <GitCommit className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                    <span className="font-mono text-xs text-muted-foreground">{c.shortHash}</span>
                    <span className="flex-1 truncate">{c.message}</span>
                    <span className="truncate text-xs text-muted-foreground">{c.author}</span>
                  </CommandItem>
                ))}
                {!page && commits.length > browseLimit && (
                  <BrowseAllItem label={`Browse all commits (${commits.length})`} onSelect={() => pushPage('commits')} />
                )}
              </CommandGroup>
            )}

            {showBranches && projectId && branchesShown.length > 0 && (
              <CommandGroup heading="Branches">
                {branchesShown.map((b) => (
                  <CommandItem
                    key={`branch-${b.name}`}
                    value={b.name}
                    onSelect={() => run(() => { void git.checkout(b.name); onShowTab?.('git'); })}
                  >
                    <GitMerge className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
                    <span className="flex-1 truncate">Switch to: {b.name}</span>
                  </CommandItem>
                ))}
                {!page && branches.length > browseLimit && (
                  <BrowseAllItem label={`Browse all branches (${branches.length})`} onSelect={() => pushPage('branches')} />
                )}
              </CommandGroup>
            )}
          </CommandList>
          {page === 'compare' && (
            <SessionComparePanel
              sessions={sessions as SessionResult[]}
              selected={compareSelection}
              filter={search}
              onOpenSplit={() => run(() => { focusPaneRef.current = openComparedInSplit(); })}
              onSelect={(side, sessionId) =>
                setCompareSelection((prev) => {
                  const next: [string, string] = [...prev];
                  next[side] = sessionId;
                  return next;
                })
              }
            />
          )}
          {/* The compare panel swallows arrow/Enter keys for its selects, so
              these hints only apply while cmdk items are on screen. */}
          {page !== 'compare' && (
            <div className="flex items-center gap-4 border-t px-3 py-2 text-xs text-muted-foreground">
              <span className="inline-flex items-center gap-1.5">
                <Kbd>↑</Kbd>
                <Kbd>↓</Kbd>
                <span>Navigate</span>
              </span>
              <span className="inline-flex items-center gap-1.5">
                <Kbd>↵</Kbd>
                <span>Select</span>
              </span>
              <span className="inline-flex items-center gap-1.5">
                <Kbd>Esc</Kbd>
                <span>Close</span>
              </span>
              <span className="ml-auto inline-flex items-center gap-1.5">
                <Kbd>Ctrl+Shift+K</Kbd>
                <span>Toggle palette</span>
              </span>
            </div>
          )}
        </Command>
      </DialogContent>
    </Dialog>
  );
}

function BrowseAllItem({ label, onSelect }: { label: string; onSelect: () => void }) {
  return (
    <CommandItem value={label} onSelect={onSelect}>
      <ChevronRight className="h-4 w-4 shrink-0 text-muted-foreground" aria-hidden />
      <span className="flex-1 text-muted-foreground">{label}</span>
    </CommandItem>
  );
}

// Same bordered-muted chip as the kbd hints in ProviderSelectionEmptyState.
function Kbd({ children }: { children: React.ReactNode }) {
  return (
    <kbd className="inline-flex shrink-0 items-center rounded border border-border/60 bg-muted/40 px-1.5 py-0.5 font-mono text-[10px] text-muted-foreground">
      {children}
    </kbd>
  );
}

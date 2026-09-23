import React, { useCallback, useEffect, useRef, useState } from 'react';
import { useNavigate } from 'react-router-dom';

import { getAvailableSplitSessions } from '../utils/splitSessionUtils';
import { getSplitPaneDisplay, type SplitPane } from '../utils/splitWorkspace';
import { useArchivedPickerSessions } from '../hooks/useArchivedPickerSessions';
import { useWorkspace } from '../../../contexts/WorkspaceContext';
import { IN_APP_BROWSER_EVENT } from '../../../utils/inAppBrowser';
import ChatInterface from '../../chat/view/ChatInterface';
import StandaloneShell from '../../standalone-shell/view/StandaloneShell';
import { WebBrowserPane } from '../../web-browser';
import GitPanel from '../../git-panel/view/GitPanel';
import { BrowserUsePanel } from '../../browser-use';
import type { MainContentProps } from '../types/types';
import { useTaskMaster } from '../../../contexts/TaskMasterContext';
import { usePaletteOpsRegister } from '../../../contexts/PaletteOpsContext';
import { useTasksSettings } from '../../../contexts/TasksSettingsContext';
import { useUiPreferences } from '../../../hooks/useUiPreferences';
import { useFileOpenResolver } from '../../../hooks/useFileOpenResolver';
import { api, authenticatedFetch } from '../../../utils/api';
import { useEditorSidebar } from '../../code-editor/hooks/useEditorSidebar';
import EditorSidebar from '../../code-editor/view/EditorSidebar';
import type { Project, ProjectSession } from '../../../types/app';

import MainContentStateView from './subcomponents/MainContentStateView';
import MobileMenuButton from './subcomponents/MobileMenuButton';
import PaneSessionHeader from './subcomponents/PaneSessionHeader';
import SessionPicker from './subcomponents/SessionPicker';
import WorkspaceLauncher from './subcomponents/WorkspaceLauncher';
import { SplitWorkspaceGrid } from './subcomponents/SplitWorkspaceGrid';
import SplitWorkspaceControls from './subcomponents/SplitWorkspaceControls';
import ErrorBoundary from './ErrorBoundary';

type TaskMasterContextValue = {
  currentProject?: Project | null;
  setCurrentProject?: ((project: Project) => void) | null;
};

type TasksSettingsContextValue = {
  tasksEnabled: boolean;
  isTaskMasterInstalled: boolean | null;
  isTaskMasterReady: boolean | null;
};

function MainContent({
  selectedProject,
  selectedSession,
  sessionCache,
  activeTab,
  setActiveTab,
  ws,
  sendMessage,
  isMobile,
  onMenuClick,
  isLoading,
  onInputFocusChange,
  onSessionProcessing,
  onSessionIdle,
  processingSessions,
  onSessionEstablished,
  onShowSettings,
  externalMessageUpdate,
  newSessionTrigger,
  projects,
  onProjectSelect,
  onProjectsRefresh,
  onSessionDelete,
  onRenameSession,
  onChangeSessionWorkspace,
  isFocusMode,
  onToggleFocusMode,
}: MainContentProps) {
  const navigate = useNavigate();
  const { preferences } = useUiPreferences();
  const { showRawParameters, showThinking, sendByCtrlEnter } = preferences;

  const {
    panes,
    activePaneId,
    setActivePaneId,
    removePane,
    updatePane,
    reorderPanes,
    canAdd,
    openPane,
    lastUsedProjectId,
    setLastUsedProjectId,
  } = useWorkspace();
  // Archived sessions/workspaces for the in-pane session picker. Loaded lazily
  // when a picker opens its archive view, shared across panes.
  const {
    archivedSessions: archivedPickerSessions,
    archivedProjects: archivedPickerProjects,
    isArchivedLoading,
    archivedError,
    loadArchived,
    restoreArchivedSession,
    restoreArchivedProject,
  } = useArchivedPickerSessions();
  const [overviewOpen, setOverviewOpen] = useState(false);
  // Count of pending permission prompts per chat session, reported by each
  // mounted ChatInterface. Drives the "question" flag in the pane overview.
  const [pendingActionBySession, setPendingActionBySession] = useState<Record<string, number>>({});

  const handlePermissionRequestsChange = useCallback((sessionId: string, count: number) => {
    setPendingActionBySession((previous) => {
      const current = previous[sessionId];
      if (count > 0 ? current === count : current === undefined) return previous;
      const next = { ...previous };
      if (count > 0) next[sessionId] = count;
      else delete next[sessionId];
      return next;
    });
  }, []);

  const openBrowserPane = useCallback(
    (url: string) => {
      openPane('browser', { url });
    },
    [openPane],
  );

  const handleAddChatPane = useCallback(() => {
    // A new chat pane opens in session-picker state: the user chooses an
    // existing session or explicitly starts a new chat from inside the tile.
    openPane('chat', { projectId: selectedProject?.projectId ?? null, picker: true });
  }, [openPane, selectedProject?.projectId]);

  // A restore changes the active project list, so re-sync the sidebar too.
  const handleRestoreArchivedSession = useCallback(
    async (sessionId: string) => {
      const restored = await restoreArchivedSession(sessionId);
      if (restored) onProjectsRefresh?.();
      return restored;
    },
    [onProjectsRefresh, restoreArchivedSession],
  );

  const handleRestoreArchivedProject = useCallback(
    async (projectId: string) => {
      const restored = await restoreArchivedProject(projectId);
      if (restored) onProjectsRefresh?.();
      return restored;
    },
    [onProjectsRefresh, restoreArchivedProject],
  );

  const handleArchivePickerSession = useCallback(
    async (sessionId: string) => {
      try {
        const response = await api.deleteSession(sessionId);
        if (!response.ok) {
          throw new Error(`archive session failed: ${response.status}`);
        }
        onSessionDelete(sessionId);
        return true;
      } catch (error) {
        console.error('[SessionPicker] Failed to archive session:', error);
        return false;
      }
    },
    [onSessionDelete],
  );

  const handleDeletePickerSession = useCallback(
    async (sessionId: string) => {
      try {
        const response = await api.deleteSession(sessionId, true);
        if (!response.ok) {
          throw new Error(`delete session failed: ${response.status}`);
        }
        onSessionDelete(sessionId);
        return true;
      } catch (error) {
        console.error('[SessionPicker] Failed to delete session:', error);
        return false;
      }
    },
    [onSessionDelete],
  );

  const handleAddBrowserPane = useCallback(() => {
    openPane('browser');
  }, [openPane]);

  const handleAddTerminalPane = useCallback(() => {
    openPane('terminal', { projectId: selectedProject?.projectId ?? null });
  }, [openPane, selectedProject?.projectId]);

  useEffect(() => {
    const handleOpen = (event: Event) => {
      const url = (event as CustomEvent<{ url?: string }>).detail?.url;
      if (!url) return;
      // Claim the event: a dispatch nobody prevented means no pane opened, and
      // the caller falls back to the system browser.
      event.preventDefault();
      openBrowserPane(url);
    };
    window.addEventListener(IN_APP_BROWSER_EVENT, handleOpen);
    return () => window.removeEventListener(IN_APP_BROWSER_EVENT, handleOpen);
  }, [openBrowserPane]);

  const sessionsById = React.useMemo(() => {
    const map = new Map<string, ProjectSession>();
    for (const project of projects) {
      for (const session of project.sessions || []) {
        // Payload sessions lack `__projectId` (only UI-resolved sessions carry
        // it). Tag them with their containing project so panes always resolve
        // the workspace a session currently lives under — it may have moved
        // via "Change workspace" since the pane was bound.
        map.set(
          session.id,
          session.__projectId ? session : { ...session, __projectId: project.projectId },
        );
      }
    }
    // Sessions resolved on demand (deep links, optimistic registrations) live
    // outside the paginated project payloads. Merge them so every pane can
    // resolve its session — the payload copy wins when both exist because it
    // is the websocket-freshened one.
    for (const [sessionId, session] of sessionCache ?? []) {
      if (!map.has(sessionId)) {
        map.set(sessionId, session);
      }
    }
    return map;
  }, [projects, sessionCache]);

  const projectNamesById = React.useMemo(() => {
    const map = new Map<string, string>();
    for (const project of projects) {
      map.set(project.projectId, project.displayName);
    }
    return map;
  }, [projects]);

  const pendingActionSessionIds = React.useMemo(
    () => new Set(Object.keys(pendingActionBySession)),
    [pendingActionBySession],
  );

  const processingSessionIds = React.useMemo(
    () => new Set(processingSessions.keys()),
    [processingSessions],
  );

  const paneDisplay = React.useCallback(
    (pane: SplitPane) => getSplitPaneDisplay(pane, {
      sessionsById,
      processingSessionIds,
      pendingActionSessionIds,
      projectNamesById,
    }),
    [pendingActionSessionIds, processingSessionIds, projectNamesById, sessionsById],
  );

  const isChatWorkspaceActive = activeTab === 'chat';
  const overviewPanes = React.useMemo(
    () => panes.map((pane) => {
      const display = paneDisplay(pane);
      return { id: pane.id, kind: pane.kind, title: display.title, subtitle: display.subtitle, action: display.action };
    }),
    [paneDisplay, panes],
  );

  const { setCurrentProject } = useTaskMaster() as TaskMasterContextValue;
  const { tasksEnabled, isTaskMasterInstalled } = useTasksSettings() as TasksSettingsContextValue;
  const [browserUseEnabled, setBrowserUseEnabled] = useState(false);

  const shouldShowTasksTab = Boolean(tasksEnabled && isTaskMasterInstalled);
  const shouldShowBrowserTab = browserUseEnabled;

  const recentProjects = React.useMemo(() => {
    const lastActivityMs = (project: Project) => {
      const value = project.lastActivity;
      return typeof value === 'string' ? new Date(value).getTime() : 0;
    };
    return [...projects].sort((a, b) => lastActivityMs(b) - lastActivityMs(a)).slice(0, 5);
  }, [projects]);

  const {
    editingFile,
    editorWidth,
    editorExpanded,
    hasManualWidth,
    resizeHandleRef,
    handleFileOpen,
    handleCloseEditor,
    handleToggleEditorExpand,
    handleResizeStart,
  } = useEditorSidebar({
    selectedProject,
    isMobile,
  });

  // Resolves bare/partial file references (e.g. links inside chat messages) to
  // real project files before opening them in the in-app editor.
  const resolvedFileOpen = useFileOpenResolver(selectedProject, handleFileOpen);

  const handleChatFileOpen = useCallback(
    (filePath: string, diffInfo?: any, line?: number, project?: Project | null) => {
      // Keep chat active on the left for split review on desktop
      if (!isMobile) {
        setActiveTab('chat');
      }
      resolvedFileOpen(filePath, diffInfo, line, project);
    },
    [isMobile, resolvedFileOpen, setActiveTab],
  );

  // Only push the global selection into TaskMaster when the GLOBAL project
  // actually changes. Comparing against `currentProject` here made this a
  // tug-of-war with /tasks, which owns its own workspace picker — every local
  // pick got reverted to the global project on the next render.
  const lastSyncedProjectIdRef = useRef<string | null>(null);
  useEffect(() => {
    const selectedProjectId = selectedProject?.projectId ?? null;

    if (selectedProject && selectedProjectId && selectedProjectId !== lastSyncedProjectIdRef.current) {
      lastSyncedProjectIdRef.current = selectedProjectId;
      setCurrentProject?.(selectedProject);
    }
  }, [selectedProject, setCurrentProject]);

  useEffect(() => {
    // Tasks live on their own page now (Agent Board sibling), so any tab
    // request for them — mobile tab strip or the next-task banner — routes
    // there instead of rendering inside the chat workspace.
    if (activeTab !== 'tasks') {
      return;
    }

    setActiveTab('chat');
    if (shouldShowTasksTab) {
      navigate('/tasks');
    }
  }, [shouldShowTasksTab, activeTab, navigate, setActiveTab]);

  const loadBrowserUseSettings = useCallback(async () => {
    try {
      const response = await authenticatedFetch('/api/browser-use/settings');
      const data = await response.json();
      setBrowserUseEnabled(Boolean(response.ok && data?.success !== false && data?.data?.settings?.enabled));
    } catch {
      setBrowserUseEnabled(false);
    }
  }, []);

  useEffect(() => {
    void loadBrowserUseSettings();
    window.addEventListener('browserUseSettingsChanged', loadBrowserUseSettings);
    return () => window.removeEventListener('browserUseSettingsChanged', loadBrowserUseSettings);
  }, [loadBrowserUseSettings]);

  useEffect(() => {
    if (!shouldShowBrowserTab && activeTab === 'browser') {
      setActiveTab('chat');
    }
  }, [shouldShowBrowserTab, activeTab, setActiveTab]);

  const availableSplitSessions = React.useMemo(() => {
    // Sessions already bound to a pane must not be pickable again — mounting a
    // second ChatInterface for the same session duplicates its websocket
    // subscriptions and the two copies fight over shared chat state.
    const openSessionIds = new Set(
      panes
        .filter((pane) => pane.kind === 'chat' && Boolean(pane.sessionId))
        .map((pane) => pane.sessionId as string),
    );
    return getAvailableSplitSessions(projects, null, selectedProject?.projectId)
      .filter((session) => !openSessionIds.has(session.id));
  }, [panes, projects, selectedProject?.projectId]);

  const resolvePaneProject = useCallback(
    (projectId?: string | null) => projects.find((project) => project.projectId === projectId) || selectedProject,
    [projects, selectedProject],
  );

  // The open editor file carries the projectId of the pane that opened it;
  // the sidebar must use that project's path, not the globally selected one.
  const editingFileProject = React.useMemo(
    () => projects.find((project) => project.projectId === editingFile?.projectId) ?? selectedProject,
    [editingFile?.projectId, projects, selectedProject],
  );

  const renderPaneHeaderContent = useCallback(
    (pane: SplitPane) => {
      if (pane.kind !== 'chat') {
        return <span className="truncate">{paneDisplay(pane).title}</span>;
      }

      const paneSession = pane.sessionId
        ? sessionsById.get(pane.sessionId) ?? (selectedSession?.id === pane.sessionId ? selectedSession : null)
        : null;

      if (!paneSession) {
        return <span className="truncate">{paneDisplay(pane).title}</span>;
      }

      // The session object knows its current owning project; pane.projectId
      // can be stale after a "Change workspace" until the pane is repointed.
      const paneProject = resolvePaneProject(paneSession.__projectId ?? pane.projectId);
      return (
        <PaneSessionHeader
          session={paneSession}
          projectName={paneProject?.displayName ?? ''}
          currentWorkspacePath={paneProject?.fullPath || paneProject?.path || ''}
          onRenameSession={onRenameSession}
          onSessionDelete={onSessionDelete}
          onChangeSessionWorkspace={onChangeSessionWorkspace}
          // Already in the picker — re-requesting it from the menu is a no-op.
          onChangeSession={pane.picker ? undefined : () => updatePane(pane.id, { picker: true })}
          requiredAction={paneDisplay(pane).action}
        />
      );
    },
    [
      onChangeSessionWorkspace,
      onRenameSession,
      onSessionDelete,
      paneDisplay,
      resolvePaneProject,
      selectedSession,
      sessionsById,
      updatePane,
    ],
  );

  const renderChatWorkspacePane = useCallback(
    (pane: SplitPane, isActive: boolean) => {
      if (pane.kind === 'browser') {
        return (
          <ErrorBoundary showDetails>
            <WebBrowserPane
              url={pane.url}
              isActive={isActive}
              onUrlChange={(url) => updatePane(pane.id, { url })}
            />
          </ErrorBoundary>
        );
      }

      if (pane.kind === 'terminal') {
        // A terminal pane with no usable workspace binding is a dead tile —
        // offer the same project launcher a draft chat pane shows. Deliberately
        // a strict lookup: a missing/stale projectId must not silently bind the
        // shell to whatever project happens to be selected.
        const paneProject = pane.projectId
          ? projects.find((project) => project.projectId === pane.projectId) ?? null
          : null;
        if (!paneProject) {
          return (
            <div className="h-full">
              <WorkspaceLauncher
                projects={projects}
                lastUsedProjectId={lastUsedProjectId}
                onSelectProject={(project) => {
                  setLastUsedProjectId(project.projectId);
                  updatePane(pane.id, { projectId: project.projectId });
                }}
                onCreateWorkspace={onShowSettings ? () => onShowSettings('workspaces') : undefined}
              />
            </div>
          );
        }
        return (
          <ErrorBoundary showDetails>
            <StandaloneShell
              project={paneProject}
              showHeader={false}
              isActive={isActive}
              isPlainShell={true}
              onFileOpen={(path, line) => resolvedFileOpen(path, undefined, line, paneProject)}
            />
          </ErrorBoundary>
        );
      }

      // Each chat pane resolves its own session. There is no primary pane: a
      // pane with no session id is an independent new-chat draft.
      const paneSession = pane.sessionId
        ? sessionsById.get(pane.sessionId) ?? (selectedSession?.id === pane.sessionId ? selectedSession : null)
        : null;
      // Prefer the session's resolved owning project — pane.projectId is only
      // a persistence hint and goes stale after "Change workspace".
      const paneProject = resolvePaneProject(paneSession?.__projectId ?? pane.projectId);

      // Session selection lives inside the tile: a picker pane shows the
      // session list instead of the chat UI (new pane, or "Change session").
      if (pane.picker) {
        return (
          <ErrorBoundary showDetails>
            <SessionPicker
              sessions={availableSplitSessions}
              processingSessionIds={processingSessionIds}
              isActive={isActive}
              canCancel={Boolean(pane.sessionId)}
              onSelectSession={(session) => {
                updatePane(pane.id, {
                  sessionId: session.id,
                  projectId: session.projectId,
                  picker: false,
                });
              }}
              // "+ New chat" keeps the regular draft flow — including the
              // workspace launcher when the pane has no project yet.
              onNewChat={() => updatePane(pane.id, { picker: false })}
              onCancel={() => updatePane(pane.id, { picker: false })}
              archivedSessions={archivedPickerSessions}
              archivedProjects={archivedPickerProjects}
              isArchivedLoading={isArchivedLoading}
              archivedError={archivedError}
              onLoadArchived={loadArchived}
              onRestoreSession={handleRestoreArchivedSession}
              onRestoreProject={handleRestoreArchivedProject}
              onArchiveSession={handleArchivePickerSession}
              onDeleteSession={handleDeletePickerSession}
            />
          </ErrorBoundary>
        );
      }

      // A brand-new pane with no workspace yet: let the user pick one. This is
      // the "new chat asks which workspace" flow.
      if (!paneProject && !pane.sessionId) {
        return (
          <div className="h-full">
            <WorkspaceLauncher
              projects={projects}
              lastUsedProjectId={lastUsedProjectId}
              onSelectProject={(project) => {
                setLastUsedProjectId(project.projectId);
                updatePane(pane.id, { projectId: project.projectId });
                onProjectSelect(project);
              }}
              onCreateWorkspace={onShowSettings ? () => onShowSettings('workspaces') : undefined}
            />
          </div>
        );
      }

      return (
        <ErrorBoundary showDetails>
          <ChatInterface
            // Key on the stable pane id, never the resolved session: the old
            // key flipped from 'split-new-*' to the session id only once the
            // async project refresh filled sessionsById — unmounting the chat
            // mid-stream and dropping its UI state. Session transitions are
            // handled internally via boundSessionId/selectedSession props.
            key={pane.id}
            isActive={isActive}
            selectedProject={paneProject}
            selectedSession={paneSession}
            boundSessionId={pane.sessionId ?? null}
            boundPaneId={pane.id}
            ws={ws}
            sendMessage={sendMessage}
            onFileOpen={(filePath, diffInfo) =>
              handleChatFileOpen(filePath, diffInfo, undefined, paneProject)
            }
            onInputFocusChange={onInputFocusChange}
            onSessionProcessing={onSessionProcessing}
            onSessionIdle={onSessionIdle}
            processingSessions={processingSessions}
            onPermissionRequestsChange={(count) => {
              const targetId = pane.sessionId || paneSession?.id;
              if (targetId) handlePermissionRequestsChange(targetId, count);
            }}
            onNavigateToSession={(targetId) => updatePane(pane.id, { sessionId: targetId })}
            onSessionEstablished={(sessionId, context) => {
              updatePane(pane.id, { sessionId, projectId: pane.projectId ?? selectedProject?.projectId ?? null });
              onSessionEstablished?.(sessionId, context);
              onProjectsRefresh?.();
            }}
            onShowSettings={onShowSettings}
            showRawParameters={showRawParameters}
            showThinking={showThinking}
            sendByCtrlEnter={sendByCtrlEnter}
            externalMessageUpdate={externalMessageUpdate}
            newSessionTrigger={newSessionTrigger}
            onShowAllTasks={tasksEnabled ? () => navigate('/tasks') : null}
            projects={projects}
            onSelectWorkspace={(project) => {
              setLastUsedProjectId(project.projectId);
              updatePane(pane.id, { projectId: project.projectId });
              onProjectSelect(project);
            }}
          />
        </ErrorBoundary>
      );
    },
    [
      archivedError,
      archivedPickerProjects,
      archivedPickerSessions,
      availableSplitSessions,
      handleArchivePickerSession,
      handleChatFileOpen,
      handleDeletePickerSession,
      handlePermissionRequestsChange,
      handleRestoreArchivedProject,
      handleRestoreArchivedSession,
      isArchivedLoading,
      lastUsedProjectId,
      loadArchived,
      navigate,
      onInputFocusChange,
      onProjectSelect,
      onProjectsRefresh,
      onSessionEstablished,
      onSessionIdle,
      onSessionProcessing,
      onShowSettings,
      processingSessionIds,
      processingSessions,
      projects,
      resolvePaneProject,
      resolvedFileOpen,
      selectedProject?.projectId,
      selectedSession,
      sendByCtrlEnter,
      sendMessage,
      sessionsById,
      setLastUsedProjectId,
      showRawParameters,
      showThinking,
      tasksEnabled,
      updatePane,
      externalMessageUpdate,
      newSessionTrigger,
      ws,
    ],
  );

  usePaletteOpsRegister({
    openFile: (filePath: string) => {
      navigate('/files');
      handleFileOpen(filePath);
    },
    // Opens the editor side panel in place, keeping the current tab (e.g. chat).
    openFileInEditor: (filePath: string) => {
      resolvedFileOpen(filePath);
    },
  });

  if (isLoading) {
    return <MainContentStateView mode="loading" isMobile={isMobile} onMenuClick={onMenuClick} />;
  }

  // The onboarding empty state is only for a truly empty workspace. With panes
  // open (e.g. a picker pane) the workspace must render even when no project is
  // selected yet — picking a session there is how a project gets chosen now.
  if (!selectedProject && panes.length === 0) {
    return (
      <MainContentStateView
        mode="empty"
        isMobile={isMobile}
        onMenuClick={onMenuClick}
        recentProjects={recentProjects}
        onProjectSelect={onProjectSelect}
      />
    );
  }

  return (
    <div className="flex h-full flex-col">
      {/* Mobile has no persistent sidebar, so non-chat tabs still need the
          hamburger to reach the drawer. The chat tab gets it inside the
          shared workspace controls bar instead. */}
      {isMobile && activeTab !== 'chat' && (
        <div className="pwa-header-safe flex-shrink-0 border-b border-border/50 bg-background/80 p-2 backdrop-blur-sm short:p-1">
          <MobileMenuButton onMenuClick={onMenuClick} compact />
        </div>
      )}

      <div className="flex min-h-0 flex-1 overflow-hidden">
        <div
          className={`flex min-h-0 flex-1 flex-col overflow-hidden ${
            isMobile && editingFile
              ? 'hidden'
              : editorExpanded
                ? 'hidden'
                : !isMobile && editingFile && activeTab === 'chat'
                  ? 'min-w-[400px]'
                  : 'min-w-0 sm:min-w-[200px]'
          }`}
        >
          <div className={`h-full min-h-0 ${activeTab === 'chat' ? 'flex flex-col' : 'hidden'}`}>
            {isChatWorkspaceActive && (
              <SplitWorkspaceControls
                leading={isMobile ? <MobileMenuButton onMenuClick={onMenuClick} compact /> : null}
                open={overviewOpen}
                onOpenChange={setOverviewOpen}
                canAddPane={canAdd}
                onAddChatPane={handleAddChatPane}
                onAddBrowserPane={handleAddBrowserPane}
                onAddTerminalPane={handleAddTerminalPane}
                panes={overviewPanes}
                activePaneId={activePaneId}
                onSelectPane={(id) => {
                  setActivePaneId(id);
                  setOverviewOpen(false);
                }}
                isFocusMode={isFocusMode}
                onToggleFocusMode={onToggleFocusMode}
              />
            )}
            <div className="min-h-0 flex-1">
              <SplitWorkspaceGrid
                panes={panes}
                isMobile={isMobile}
                activePaneId={activePaneId}
                onActivatePane={setActivePaneId}
                onClosePane={removePane}
                onReorderPanes={reorderPanes}
                renderPane={renderChatWorkspacePane}
                renderPaneHeaderContent={renderPaneHeaderContent}
                getPaneTitle={(pane) => paneDisplay(pane).title}
                showPaneHeader
              />
            </div>
          </div>

          {activeTab === 'git' && (
            <div className="h-full overflow-hidden">
              <GitPanel
                selectedProject={selectedProject}
                isMobile={isMobile}
                onFileOpen={handleFileOpen}
                onProjectSelect={onProjectSelect}
                onProjectsRefresh={onProjectsRefresh}
              />
            </div>
          )}

          {shouldShowBrowserTab && activeTab === 'browser' && (
            <div className="h-full overflow-hidden">
              <BrowserUsePanel isVisible={activeTab === 'browser'} onShowSettings={onShowSettings} />
            </div>
          )}
        </div>

        <EditorSidebar
          editingFile={editingFile}
          isMobile={isMobile}
          editorExpanded={editorExpanded}
          editorWidth={editorWidth}
          hasManualWidth={hasManualWidth}
          resizeHandleRef={resizeHandleRef}
          onResizeStart={handleResizeStart}
          onCloseEditor={handleCloseEditor}
          onToggleEditorExpand={handleToggleEditorExpand}
          projectPath={editingFileProject?.fullPath || editingFileProject?.path || selectedProject?.path || ''}
          fillSpace={false}
        />
      </div>
    </div>
  );
}

export default React.memo(MainContent);

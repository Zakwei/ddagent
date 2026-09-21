import { useCallback, useEffect, useRef } from 'react';
import { useMatch, useNavigate, useParams } from 'react-router-dom';

import SidebarRail from '../sidebar/view/subcomponents/SidebarRail';
import MainContent from '../main-content/view/MainContent';
import BoardPage from '../kanban/view/BoardPage';
import SourceControlPage from '../git-panel/view/SourceControlPage';
import { FilesPage } from '../file-tree';
import { ControlCenterPage } from '../quota';
import { TasksPage } from '../task-master';
import CommandPalette from '../command-palette/CommandPalette';
import { QuickSettingsPanel } from '../quick-settings-panel';
import { useWebSocket } from '../../contexts/WebSocketContext';
import { PaletteOpsProvider, usePaletteOpsRegister } from '../../contexts/PaletteOpsContext';
import { WorkspaceProvider, useWorkspace } from '../../contexts/WorkspaceContext';
import { useDeviceSettings } from '../../hooks/useDeviceSettings';
import { useSessionProtection } from '../../hooks/useSessionProtection';
import { useBackgroundCompletionAlert } from '../../hooks/useBackgroundCompletionAlert';
import { useProjectsState } from '../../hooks/useProjectsState';
import { pickWorkspaceProjectId } from '../main-content/utils/workspacePanes';
import { useUiPreferences } from '../../hooks/useUiPreferences';
import { useTasksSettings } from '../../contexts/TasksSettingsContext';
import { useAppKeyboardShortcuts } from '../../hooks/useAppKeyboardShortcuts';
import { useVersionCheck } from '../../hooks/useVersionCheck';
import { api } from '../../utils/api';

import MobileNavMenu from './view/subcomponents/MobileNavMenu';
import SettingsModalHost from './view/subcomponents/SettingsModalHost';

type RunningSessionApiItem = {
  sessionId?: unknown;
  startedAt?: unknown;
  statusText?: unknown;
  canInterrupt?: unknown;
};

type RunningSessionsApiPayload = {
  data?: {
    sessions?: RunningSessionApiItem[];
  };
};

const parseStartedAt = (value: unknown): number | undefined => {
  if (typeof value === 'number' && Number.isFinite(value) && value > 0) {
    return value;
  }

  if (typeof value !== 'string') {
    return undefined;
  }

  const parsed = Date.parse(value);
  return Number.isFinite(parsed) ? parsed : undefined;
};

export default function AppContent() {
  return (
    <WorkspaceProvider>
      <PaletteOpsProvider>
        <AppContentInner />
      </PaletteOpsProvider>
    </WorkspaceProvider>
  );
}

function AppContentInner() {
  const navigate = useNavigate();
  const { sessionId: urlSessionId } = useParams<{ sessionId?: string }>();
  const isBoardRoute = Boolean(useMatch('/board'));
  const isUsageRoute = Boolean(useMatch('/usage'));
  const isSourceControlRoute = Boolean(useMatch('/source-control'));
  const isFilesRoute = Boolean(useMatch('/files'));
  const isTasksRoute = Boolean(useMatch('/tasks'));
  const { isMobile, isPWA } = useDeviceSettings();
  const { ws, sendMessage, subscribe } = useWebSocket();

  const {
    processingSessions,
    markSessionProcessing,
    markSessionIdle,
    syncProcessingSessions,
  } = useSessionProtection();

  const {
    panes,
    activePaneId,
    lastUsedProjectId,
    openSession,
    openPane,
    updatePane,
  } = useWorkspace();

  // Sessions are owned by panes (persisted in localStorage), not by the route.
  // The `/session/:id` URL survives only as a one-time intake for deep links
  // and notifications: it seeds a pane, then the address bar is normalized.
  const activePane = panes.find((pane) => pane.id === activePaneId) ?? panes[0] ?? null;
  const activePaneSessionId = activePane?.kind === 'chat' ? activePane.sessionId ?? null : null;
  const activePaneProjectId = pickWorkspaceProjectId(panes, activePaneId, lastUsedProjectId);

  const handleNewSessionPane = useCallback(
    (projectId: string | null) => {
      // `picker: true` renders the session picker inside the pane instead of a
      // fresh draft chat, so the rail's Panel button can list recent sessions.
      openPane('chat', { projectId, picker: true });
    },
    [openPane],
  );

  const handleSessionAliasResolved = useCallback(
    (canonicalSessionId: string, providerSessionId: string) => {
      const pane = panes.find(
        (candidate) => candidate.kind === 'chat' && candidate.sessionId === providerSessionId,
      );
      if (pane) {
        updatePane(pane.id, { sessionId: canonicalSessionId });
      }
    },
    [panes, updatePane],
  );

  // Panes persist their sessionId in localStorage, so a deleted session would
  // otherwise leave dead tiles behind (raw UUID header, empty draft chat).
  // Falling back to the picker keeps the tile usable instead of dead.
  const handleSessionDeleted = useCallback(
    (deletedSessionId: string) => {
      panes
        .filter((pane) => pane.kind === 'chat' && pane.sessionId === deletedSessionId)
        .forEach((pane) => updatePane(pane.id, { sessionId: null, picker: true }));
    },
    [panes, updatePane],
  );

  // Panes persist their own projectId too — after "Change workspace" they
  // must follow the session to its new owning project or the tile keeps
  // showing (and passing) the stale workspace.
  const handleSessionWorkspaceChanged = useCallback(
    (sessionId: string, projectId: string) => {
      panes
        .filter((pane) => pane.kind === 'chat' && pane.sessionId === sessionId)
        .forEach((pane) => updatePane(pane.id, { projectId }));
    },
    [panes, updatePane],
  );

  const {
    projects,
    selectedProject,
    selectedSession,
    sessionCache,
    activeTab,
    sidebarOpen,
    isLoadingProjects,
    externalMessageUpdate,
    newSessionTrigger,
    showSettings,
    settingsInitialTab,
    setActiveTab,
    setSidebarOpen,
    setIsInputFocused,
    setShowSettings,
    openSettings,
    refreshProjectsSilently,
    registerOptimisticSession,
    handleNewSession,
    handleProjectSelect,
    handleSessionDelete,
    handleProjectDelete,
    renameSession,
    changeSessionWorkspace,
  } = useProjectsState({
    sessionId: activePaneSessionId ?? urlSessionId,
    activePaneProjectId,
    navigate,
    subscribe,
    isMobile,
    activeSessions: processingSessions,
    onSessionAliasResolved: handleSessionAliasResolved,
    onOpenSession: openSession,
    onNewSessionPane: handleNewSessionPane,
    onSessionDeleted: handleSessionDeleted,
    onSessionWorkspaceChanged: handleSessionWorkspaceChanged,
  });

  // The rail "Panel" action: reveal the workspace. Sub-route pages overlay it,
  // so navigate home and switch back to the chat tab — no pane is created
  // here; the toolbar's "+ chat pane" adds one.
  const handleOpenPanel = useCallback(() => {
    if (isBoardRoute || isUsageRoute || isSourceControlRoute || isFilesRoute || isTasksRoute) {
      navigate('/');
    }

    setActiveTab('chat');
  }, [
    isBoardRoute,
    isFilesRoute,
    isSourceControlRoute,
    isTasksRoute,
    isUsageRoute,
    navigate,
    setActiveTab,
  ]);

  // Mobile hides the pane toolbar, so its nav menu keeps an explicit "New
  // chat" that opens a picker pane after revealing the workspace.
  const handleNewChatPane = useCallback(() => {
    handleOpenPanel();
    handleNewSessionPane(activePaneProjectId);
  }, [activePaneProjectId, handleNewSessionPane, handleOpenPanel]);

  // Notification bodies and clicks need the finished session's title and its
  // owning project; project session lists are paginated, so fall back to the
  // resolved-session cache when the id is not on a loaded page.
  const findSessionContext = useCallback(
    (sessionId: string) => {
      for (const project of projects) {
        const session = project.sessions?.find((candidate) => candidate.id === sessionId);
        if (session) {
          return { session, project };
        }
      }
      const cached = sessionCache.get(sessionId);
      if (!cached) {
        return null;
      }
      const project =
        projects.find((candidate) => candidate.projectId === cached.__projectId) ?? null;
      return { session: cached, project };
    },
    [projects, sessionCache],
  );

  const getSessionLabel = useCallback(
    (sessionId: string) => {
      const context = findSessionContext(sessionId);
      if (!context) return undefined;
      const title = context.session.title || context.session.summary || context.session.name;
      const projectName = context.project?.displayName;
      if (title && projectName) return `${title} (${projectName})`;
      return title || projectName || undefined;
    },
    [findSessionContext],
  );

  const handleOpenCompletedSession = useCallback(
    (sessionId: string) => {
      const context = findSessionContext(sessionId);
      openSession(sessionId, context?.project?.projectId ?? context?.session.__projectId ?? null);
    },
    [findSessionContext, openSession],
  );

  useBackgroundCompletionAlert({
    processingSessions,
    getSessionLabel,
    onOpenSession: handleOpenCompletedSession,
  });

  // An empty workspace renders nothing, which makes "new session" unreachable
  // on mobile (its pane toolbar is hidden). Seed one chat pane in picker state
  // so the session list is the first thing on screen.
  useEffect(() => {
    if (panes.length === 0 && !isLoadingProjects) {
      openPane('chat', { picker: true });
    }
  }, [isLoadingProjects, openPane, panes.length]);

  // Consume a legacy `/session/:id` deep link exactly once per id: bind it to a
  // pane, then drop it from the URL so the route stays session-free.
  const intakeHandledRef = useRef<string | null>(null);
  useEffect(() => {
    if (!urlSessionId) return;
    if (intakeHandledRef.current === urlSessionId) return;
    intakeHandledRef.current = urlSessionId;
    openSession(urlSessionId);
    if (!isBoardRoute && !isUsageRoute && !isSourceControlRoute && !isFilesRoute) {
      navigate('/', { replace: true });
    }
  }, [
    urlSessionId,
    openSession,
    navigate,
    isBoardRoute,
    isUsageRoute,
    isSourceControlRoute,
    isFilesRoute,
  ]);


  const { preferences, setPreference } = useUiPreferences();
  const { sidebarVisible } = preferences;

  // PWA mode drives safe-area/positioning rules in index.css. The sidebar used
  // to own this toggle; the app shell took it over when the sidebar was
  // replaced by the rail.
  useEffect(() => {
    if (typeof document === 'undefined') {
      return;
    }

    document.documentElement.classList.toggle('pwa-mode', isPWA);
    document.body.classList.toggle('pwa-mode', isPWA);
  }, [isPWA]);

  // The rail only exists on desktop; mobile navigation lives in a menu, so
  // focus mode is a desktop-only affordance (its toolbar button is hidden on
  // mobile too).
  const isFocusMode = !isMobile && !sidebarVisible;

  const toggleFocusMode = useCallback(() => {
    if (isMobile) {
      return;
    }

    setPreference('sidebarVisible', !sidebarVisible);
  }, [isMobile, sidebarVisible, setPreference]);

  const { restartRequired, updateAvailable, latestVersion, releaseInfo } = useVersionCheck();

  const tasksSettings = useTasksSettings() as {
    tasksEnabled?: boolean;
    isTaskMasterInstalled?: boolean | null;
  } | undefined;
  const shouldShowTasksTab = Boolean(tasksSettings?.tasksEnabled && tasksSettings?.isTaskMasterInstalled);

  useAppKeyboardShortcuts({
    activeTab,
    setActiveTab,
    shouldShowTasksTab,
    onToggleFocusMode: toggleFocusMode,
    onOpenPanel: handleOpenPanel,
    onNavigateHome: () => {
      if (isBoardRoute || isUsageRoute || isSourceControlRoute || isFilesRoute || isTasksRoute) {
        navigate('/');
      }
    },
  });

  const refreshRunningSessions = useCallback(async () => {
    try {
      const response = await api.runningSessions();
      if (!response.ok) {
        return;
      }

      const payload = (await response.json()) as RunningSessionsApiPayload;
      const sessions = Array.isArray(payload.data?.sessions) ? payload.data.sessions : [];

      syncProcessingSessions(
        sessions
          .map((session) => {
            if (typeof session.sessionId !== 'string' || !session.sessionId) {
              return null;
            }

            return {
              sessionId: session.sessionId,
              startedAt: parseStartedAt(session.startedAt),
              statusText: typeof session.statusText === 'string' ? session.statusText : undefined,
              canInterrupt: typeof session.canInterrupt === 'boolean' ? session.canInterrupt : undefined,
            };
          })
          .filter((session): session is NonNullable<typeof session> => Boolean(session)),
      );
    } catch (error) {
      console.error('[AppContent] Failed to sync running sessions:', error);
    }
  }, [syncProcessingSessions]);

  useEffect(() => {
    void refreshRunningSessions();
  }, [refreshRunningSessions]);

  useEffect(() => {
    const interval = window.setInterval(() => {
      void refreshRunningSessions();
    }, 5000);

    return () => window.clearInterval(interval);
  }, [refreshRunningSessions]);

  usePaletteOpsRegister({
    openSettings,
    refreshProjects: refreshProjectsSilently,
  });

  useEffect(() => {
    if (typeof navigator === 'undefined' || !('serviceWorker' in navigator)) {
      return undefined;
    }

    const handleServiceWorkerMessage = (event: MessageEvent) => {
      const message = event.data;
      if (!message || message.type !== 'notification:navigate') {
        return;
      }

      if (typeof message.provider === 'string' && message.provider.trim()) {
        localStorage.setItem('selected-provider', message.provider);
      }

      setActiveTab('chat');
      setSidebarOpen(false);
      void refreshProjectsSilently();

      if (typeof message.sessionId === 'string' && message.sessionId) {
        // Notifications open the session in a pane; the route stays session-free.
        const context = findSessionContext(message.sessionId);
        openSession(message.sessionId, context?.project?.projectId ?? context?.session.__projectId ?? null);
        navigate('/');
        return;
      }

      navigate('/');
    };

    navigator.serviceWorker.addEventListener('message', handleServiceWorkerMessage);

    return () => {
      navigator.serviceWorker.removeEventListener('message', handleServiceWorkerMessage);
    };
  }, [navigate, openSession, refreshProjectsSilently, setActiveTab, setSidebarOpen, findSessionContext]);

  // Pending tool permissions are recovered through the `chat.subscribe` flow:
  // the `chat_subscribed` ack carries them on session open and on reconnect,
  // so no separate permission-recovery message is needed here.

  // Adjust the app container to stay above the virtual keyboard on iOS Safari/Android.
  // On iOS the layout viewport stays full-height and the keyboard overlays it.
  // We use Visual Viewport resize and scroll events safely to track keyboard height,
  // ensure window.scrollTo(0, 0) prevents document-level scroll drift, and lock overscroll.
  useEffect(() => {
    const vv = window.visualViewport;
    if (!vv) return;

    const setLockClasses = (active: boolean) => {
      const targets = [
        document.documentElement,
        document.body,
        document.getElementById('root'),
      ].filter(Boolean) as HTMLElement[];

      for (const el of targets) {
        if (active) {
          el.classList.add('keyboard-open', 'overflow-hidden', 'overscroll-none');
        } else {
          el.classList.remove('keyboard-open', 'overflow-hidden', 'overscroll-none');
        }
      }
    };

    const resetWindowScroll = () => {
      if (window.scrollY !== 0 || window.scrollX !== 0) {
        window.scrollTo(0, 0);
      }
    };

    const handleViewportChange = () => {
      const kb = Math.max(0, window.innerHeight - vv.height);
      document.documentElement.style.setProperty('--keyboard-height', `${kb}px`);
      const isKeyboardActive = kb > 0;
      setLockClasses(isKeyboardActive);
      if (isKeyboardActive) {
        resetWindowScroll();
      }
    };

    const handleScroll = () => {
      const kb = Math.max(0, window.innerHeight - vv.height);
      if (kb > 0) {
        resetWindowScroll();
      }
    };

    vv.addEventListener('resize', handleViewportChange);
    vv.addEventListener('scroll', handleScroll);
    window.addEventListener('scroll', handleScroll, { passive: true });

    return () => {
      vv.removeEventListener('resize', handleViewportChange);
      vv.removeEventListener('scroll', handleScroll);
      window.removeEventListener('scroll', handleScroll);
      setLockClasses(false);
    };
  }, []);

  return (
    <div className="fixed inset-0 flex bg-background" style={{ bottom: 'var(--keyboard-height, 0px)' }}>
      {/* Desktop navigation rail. Focus mode (Ctrl+Shift+F) hides it. */}
      {!isMobile && sidebarVisible && (
        <div className="h-full flex-shrink-0 border-r border-border/50">
          <SidebarRail
            runningCount={processingSessions.size}
            onOpenPanel={handleOpenPanel}
            // Keeps the last-used settings tab, like the old sidebar gear.
            onShowSettings={() => setShowSettings(true)}
            restartRequired={restartRequired}
            latestVersion={updateAvailable ? latestVersion : null}
            releaseUrl={releaseInfo?.htmlUrl}
          />
        </div>
      )}

      <div className="flex min-w-0 flex-1 flex-col">
        <>
        {isBoardRoute && (
          <BoardPage
            projects={projects}
            selectedProject={selectedProject}
            isMobile={isMobile}
            onMenuClick={() => setSidebarOpen(true)}
            onOpenSession={(targetSessionId) => openSession(targetSessionId)}
          />
        )}
        {isUsageRoute && (
          <ControlCenterPage
            isMobile={isMobile}
            onMenuClick={() => setSidebarOpen(true)}
          />
        )}
        {isSourceControlRoute && (
          <SourceControlPage
            projects={projects}
            selectedProject={selectedProject}
            isMobile={isMobile}
            onMenuClick={() => setSidebarOpen(true)}
            onProjectsRefresh={() => void refreshProjectsSilently()}
          />
        )}
        {isTasksRoute && (
          <TasksPage
            projects={projects}
            selectedProject={selectedProject}
            isMobile={isMobile}
            onMenuClick={() => setSidebarOpen(true)}
          />
        )}
        {isFilesRoute && (
          <FilesPage
            projects={projects}
            selectedProject={selectedProject}
            isMobile={isMobile}
            onMenuClick={() => setSidebarOpen(true)}
          />
        )}
        {/* Sub-route pages overlay the workspace instead of replacing it —
            hiding rather than unmounting preserves pane state (expanded tool
            cards, scroll, pending permissions), the same 'hidden' pattern the
            git tab uses inside. */}
        <div className={
          isBoardRoute || isUsageRoute || isSourceControlRoute || isTasksRoute || isFilesRoute
            ? 'hidden'
            : 'contents'
        }>
        <MainContent
          selectedProject={selectedProject}
          selectedSession={selectedSession}
          sessionCache={sessionCache}
          activeTab={activeTab}
          setActiveTab={setActiveTab}
          ws={ws}
          sendMessage={sendMessage}
          isMobile={isMobile}
          onMenuClick={() => setSidebarOpen(true)}
          isLoading={isLoadingProjects}
          onInputFocusChange={setIsInputFocused}
          onSessionProcessing={markSessionProcessing}
          onSessionIdle={markSessionIdle}
          processingSessions={processingSessions}
          onSessionEstablished={(targetSessionId, context) =>
            registerOptimisticSession({ sessionId: targetSessionId, ...context })
          }
          onShowSettings={openSettings}
          externalMessageUpdate={externalMessageUpdate}
          newSessionTrigger={newSessionTrigger}
          projects={projects}
          onProjectSelect={handleProjectSelect}
          onProjectsRefresh={() => void refreshProjectsSilently()}
          onSessionDelete={(sessionId) => {
            handleSessionDelete(sessionId);
            void refreshProjectsSilently();
          }}
          onRenameSession={(sessionId, summary) => renameSession(sessionId, summary)}
          onChangeSessionWorkspace={changeSessionWorkspace}
          isFocusMode={isFocusMode}
          onToggleFocusMode={toggleFocusMode}
        />
        </div>
        </>
      </div>

      {/* Mobile navigation menu (hamburger). No rail and no drawer with
          session/project lists — app-level navigation only. */}
      <MobileNavMenu
        open={isMobile && sidebarOpen}
        onClose={() => setSidebarOpen(false)}
        onNewChat={handleNewChatPane}
        onShowSettings={() => setShowSettings(true)}
        restartRequired={restartRequired}
        latestVersion={updateAvailable ? latestVersion : null}
        releaseUrl={releaseInfo?.htmlUrl}
      />

      <CommandPalette
        selectedProject={selectedProject}
        onStartNewChat={handleNewSession}
        onOpenSettings={() => openSettings()}
        onShowTab={setActiveTab}
      />

      <QuickSettingsPanel />

      {/* Stays mounted for the rail, QuickSettingsPanel and CommandPalette. */}
      <SettingsModalHost
        showSettings={showSettings}
        settingsInitialTab={settingsInitialTab}
        onCloseSettings={() => setShowSettings(false)}
        projects={projects}
        onProjectDeleted={handleProjectDelete}
      />
    </div>
  );
}

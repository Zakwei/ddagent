import { useCallback, useEffect, useRef, useState } from 'react';
import type { NavigateFunction } from 'react-router-dom';

import { api } from '../utils/api';
import type { ServerEvent } from '../contexts/WebSocketContext';
import type {
  AppTab,
  LLMProvider,
  LoadingProgress,
  Project,
  ProjectSession,
} from '../types/app';
import { triggerHapticFeedback } from '../utils/haptics';
import { purgeSessionLocalState } from '../components/chat/utils/chatStorage';

import { countLoadedProjectSessions, getProjectSessions, isSubagentSession, mergeExpandedSessionPages, mergeProjectSessionPage } from './projectSessionMerge';
import type { SessionActivityMap } from './useSessionProtection';

type UseProjectsStateArgs = {
  sessionId?: string;
  /**
   * DB `projectId` of the active workspace pane. Panes are stored in
   * localStorage and are the source of truth for what is open; the route no
   * longer carries a session. This keeps `selectedProject` aligned with the
   * focused pane even when it is a session-less draft.
   */
  activePaneProjectId?: string | null;
  navigate: NavigateFunction;
  /** Subscription to the unified websocket event stream. */
  subscribe: (listener: (event: ServerEvent) => void) => () => void;
  isMobile: boolean;
  activeSessions: SessionActivityMap;
  /**
   * Called when a provider-native session alias resolves to the canonical app
   * session id. The workspace repoints the owning pane instead of navigating.
   */
  onSessionAliasResolved?: (canonicalSessionId: string, providerSessionId: string) => void;
  /**
   * Opens a session in a workspace pane. Replaces the old
   * `navigate('/session/:id')` flow now that the route is session-free.
   */
  onOpenSession?: (sessionId: string, projectId?: string | null) => void;
  /**
   * Creates or reuses a draft chat pane for a New Session action. Sessions are
   * rendered only inside panes, so without this the `newSessionTrigger` has no
   * consumer when the workspace is empty or the active pane is session-bound.
   */
  onNewSessionPane?: (projectId: string | null) => void;
  /**
   * Called after a session is removed from app state so workspace panes still
   * bound to it can be cleared — panes are persisted in localStorage and do
   * not learn about deletions from the project payloads.
   */
  onSessionDeleted?: (sessionId: string) => void;
  /**
   * Called after a session's workspace changed so workspace panes bound to it
   * can follow it to the new owning project — `pane.projectId` is persisted
   * and would otherwise keep pointing at the old workspace.
   */
  onSessionWorkspaceChanged?: (sessionId: string, projectId: string) => void;
};

/**
 * Shape of the per-session sidebar delta broadcast by the backend file
 * watcher (`kind: session_upserted`). It carries everything needed to upsert
 * one session row in place — no full project-list snapshot is ever pushed.
 */
type SessionUpsertedEvent = ServerEvent & {
  sessionId: string;
  providerSessionId?: string | null;
  provider: LLMProvider;
  session: ProjectSession;
  project: {
    projectId: string;
    path: string;
    fullPath: string;
    displayName: string;
    isStarred: boolean;
  } | null;
};

type FetchProjectsOptions = {
  showLoadingState?: boolean;
};

type RegisterOptimisticSessionArgs = {
  sessionId: string;
  provider: LLMProvider;
  project: Project;
  summary?: string | null;
};

/**
 * Shape of `GET /api/providers/sessions/:sessionId` — the authoritative
 * session → owning-project resolution used when a `/session/<id>` URL points
 * at a session that is not present in the paginated project payloads.
 */
type SessionDetailsApiPayload = {
  data?: {
    sessionId?: string;
    provider?: string;
    summary?: string;
    createdAt?: string | null;
    lastActivity?: string | null;
    lastViewedAt?: string | null;
    model?: string | null;
    project?: {
      projectId?: string;
      path?: string;
      fullPath?: string;
      displayName?: string;
      isStarred?: boolean;
    } | null;
  };
};

type ProjectSessionPage = Pick<Project, 'sessions' | 'sessionMeta'>;

const DEFAULT_PROVIDER: LLMProvider = 'claude';

const serialize = (value: unknown) => JSON.stringify(value ?? null);

const readSelectedProvider = (): LLMProvider => {
  try {
    const storedProvider = localStorage.getItem('selected-provider');
    return storedProvider ? storedProvider as LLMProvider : DEFAULT_PROVIDER;
  } catch {
    return DEFAULT_PROVIDER;
  }
};

const getSessionProvider = (session: ProjectSession): LLMProvider => {
  const provider = session.__provider ?? session.provider;
  return typeof provider === 'string' && provider.trim()
    ? provider as LLMProvider
    : DEFAULT_PROVIDER;
};

const normalizeSessionProvider = (session: ProjectSession): ProjectSession => ({
  ...session,
  __provider: getSessionProvider(session),
});

const projectsHaveChanges = (
  prevProjects: Project[],
  nextProjects: Project[],
): boolean => {
  if (prevProjects.length !== nextProjects.length) {
    return true;
  }

  return nextProjects.some((nextProject, index) => {
    const prevProject = prevProjects[index];
    if (!prevProject) {
      return true;
    }

    return (
      nextProject.projectId !== prevProject.projectId ||
      nextProject.displayName !== prevProject.displayName ||
      nextProject.fullPath !== prevProject.fullPath ||
      Boolean(nextProject.isStarred) !== Boolean(prevProject.isStarred) ||
      serialize(nextProject.sessionMeta) !== serialize(prevProject.sessionMeta) ||
      serialize(nextProject.sessions) !== serialize(prevProject.sessions) ||
      serialize(nextProject.taskmaster) !== serialize(prevProject.taskmaster)
    );
  });
};

const mergeTaskMasterCache = (nextProjects: Project[], previousProjects: Project[]): Project[] => {
  if (previousProjects.length === 0) {
    return nextProjects;
  }

  // Keyed by `projectId` (the DB primary key) so caches stay correct across
  // renames and other mutations that might have changed the display name.
  const previousTaskMasterByProject = new Map(
    previousProjects
      .filter((project) => Boolean(project.taskmaster))
      .map((project) => [project.projectId, project.taskmaster]),
  );

  return nextProjects.map((project) => {
    const cachedTaskMasterInfo = previousTaskMasterByProject.get(project.projectId);
    if (!cachedTaskMasterInfo) {
      return project;
    }

    return {
      ...project,
      taskmaster: cachedTaskMasterInfo,
    };
  });
};

const getSessionAliasIds = (event: SessionUpsertedEvent): Set<string> => {
  const ids = new Set<string>();
  const add = (value: unknown) => {
    if (typeof value !== 'string') {
      return;
    }

    const trimmed = value.trim();
    if (trimmed) {
      ids.add(trimmed);
    }
  };

  add(event.sessionId);
  add(event.providerSessionId);
  add(event.session?.id);

  return ids;
};

/**
 * Upserts one session into a project's normalized session list.
 *
 * Existing rows are updated in place (summary/lastActivity changes from the
 * watcher); new rows are prepended since the watcher only fires for sessions
 * with fresh activity. `sessionMeta.total` grows only on insert.
 */
const upsertSessionIntoProject = (project: Project, event: SessionUpsertedEvent): Project => {
  const sessions = project.sessions ?? [];
  const aliasIds = getSessionAliasIds(event);
  const normalizedSession: ProjectSession = {
    ...event.session,
    id: event.sessionId,
    __provider: event.provider,
  };
  const existingIndex = sessions.findIndex((session) => aliasIds.has(String(session.id)));

  let nextSessions: ProjectSession[];
  let inserted = false;
  if (existingIndex >= 0) {
    let changed = false;
    nextSessions = [];

    for (const [index, session] of sessions.entries()) {
      if (index === existingIndex) {
        const updated = { ...session, ...normalizedSession };
        // Never let a later upsert that carries an empty summary blank out a
        // title we already have. Fresh sessions momentarily broadcast an empty
        // custom_name before the disk indexer fills it in, which would
        // otherwise flash the row back to the "New session" placeholder.
        if (!normalizedSession.summary?.trim() && session.summary?.trim()) {
          updated.summary = session.summary;
        }
        if (serialize(session) !== serialize(updated)) {
          changed = true;
        }
        nextSessions.push(updated);
        continue;
      }

      if (aliasIds.has(String(session.id))) {
        changed = true;
        continue;
      }

      nextSessions.push(session);
    }

    if (!changed) {
      return project;
    }
  } else {
    nextSessions = [normalizedSession, ...sessions];
    inserted = true;
  }

  const next: Project = { ...project, sessions: nextSessions };
  if (inserted) {
    const total = Number(project.sessionMeta?.total ?? 0) + 1;
    next.sessionMeta = {
      ...project.sessionMeta,
      total,
      hasMore: countLoadedProjectSessions(next) < total,
    };
  }

  return next;
};

const projectFromRegistration = (project: Project): Project => ({
  projectId: project.projectId,
  path: project.path || project.fullPath,
  fullPath: project.fullPath || project.path || '',
  displayName: project.displayName,
  isStarred: project.isStarred,
  sessions: project.sessions ?? [],
  sessionMeta: project.sessionMeta ?? { hasMore: false, total: countLoadedProjectSessions(project) },
  taskmaster: project.taskmaster,
});

const removeSessionFromProject = (project: Project, sessionIdToDelete: string): Project => {
  const sessions = project.sessions ?? [];
  const nextSessions = sessions.filter((session) => session.id !== sessionIdToDelete);
  if (nextSessions.length === sessions.length) {
    return project;
  }

  const updatedProject: Project = {
    ...project,
    sessions: nextSessions,
  };

  const totalSessions = Math.max(0, Number(project.sessionMeta?.total ?? 0) - 1);
  updatedProject.sessionMeta = {
    ...project.sessionMeta,
    total: totalSessions,
    hasMore: countLoadedProjectSessions(updatedProject) < totalSessions,
  };

  return updatedProject;
};

const VALID_TABS: Set<string> = new Set(['chat', 'git', 'tasks', 'browser']);

const isValidTab = (tab: string): tab is AppTab => {
  return VALID_TABS.has(tab);
};

const readPersistedTab = (): AppTab => {
  try {
    const stored = localStorage.getItem('activeTab');
    if (stored && isValidTab(stored)) {
      return stored as AppTab;
    }
  } catch {
    // localStorage unavailable
  }
  return 'chat';
};

export function useProjectsState({
  sessionId,
  activePaneProjectId,
  navigate,
  subscribe,
  isMobile,
  activeSessions,
  onSessionAliasResolved,
  onOpenSession,
  onNewSessionPane,
  onSessionDeleted,
  onSessionWorkspaceChanged,
}: UseProjectsStateArgs) {
  const [projects, setProjects] = useState<Project[]>([]);
  const [selectedProject, setSelectedProject] = useState<Project | null>(null);
  const [selectedSession, setSelectedSession] = useState<ProjectSession | null>(null);
  /**
   * Sessions resolved outside the paginated project payloads (deep-link
   * lookups, optimistic registrations). Every workspace pane resolves its
   * session from a shared map, so these must live per-session — the singleton
   * `selectedSession` can only back one pane at a time.
   */
  const [sessionCache, setSessionCache] = useState<Map<string, ProjectSession>>(new Map());
  const [, setAttentionSessionIds] = useState<Set<string>>(new Set());
  const [activeTab, setActiveTab] = useState<AppTab>(readPersistedTab);

  useEffect(() => {
    try {
      localStorage.setItem('activeTab', activeTab);
    } catch {
      // Silently ignore storage errors
    }
  }, [activeTab]);

  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [isLoadingProjects, setIsLoadingProjects] = useState(true);
  const [loadingProgress, setLoadingProgress] = useState<LoadingProgress | null>(null);
  const [isInputFocused, setIsInputFocused] = useState(false);
  const [showSettings, setShowSettings] = useState(false);
  const [settingsInitialTab, setSettingsInitialTab] = useState('agents');
  const [externalMessageUpdate, setExternalMessageUpdate] = useState(0);
  /**
   * `newSessionTrigger` is an explicit, monotonic intent signal for user-driven
   * New Session actions.
   *
   * It exists because `handleNewSession` can be invoked while the app is already in
   * the same visible state (`selectedSession === null`, `activeTab === 'chat'`,
   * route already `/`). In that case, React/router updates are idempotent and no
   * downstream reset logic runs.
   *
   * Usage across the codebase:
   * 1) Produced here in `handleNewSession` via increment (always changes).
   * 2) Returned from this hook and threaded through:
   *    useProjectsState -> AppContent -> MainContent -> ChatInterface.
   * 3) Consumed in `useChatSessionState` as an effect dependency to forcibly clear
   *    chat-local state (`currentSessionId`, pending draft message, streaming flags,
   *    pending session storage keys, pagination/scroll artifacts).
   *
   * Keeping this signal dedicated avoids coupling resets to unrelated counters/events
   * (for example websocket/project refresh updates) that could cause accidental resets.
   */
  const [newSessionTrigger, setNewSessionTrigger] = useState(0);

  const loadingProgressTimeoutRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  /**
   * Ref mirrors for state the websocket subscription handler needs.
   *
   * The subscription is registered once (per `subscribe` identity) and events
   * are dispatched synchronously outside React's render cycle, so the handler
   * must read the latest values through refs instead of stale closures —
   * re-subscribing on every state change would risk missing events.
   */
  const selectedSessionRef = useRef(selectedSession);
  selectedSessionRef.current = selectedSession;
  const activeSessionsRef = useRef(activeSessions);
  activeSessionsRef.current = activeSessions;
  const selectedProjectRef = useRef(selectedProject);
  selectedProjectRef.current = selectedProject;
  const projectsRef = useRef(projects);
  projectsRef.current = projects;
  const sessionIdRef = useRef(sessionId);
  sessionIdRef.current = sessionId;
  /** URL session id whose backend lookup already ran (or is in flight) — one attempt per id. */
  const sessionLookupRef = useRef<string | null>(null);

  useEffect(() => {
    sessionLookupRef.current = null;
  }, [sessionId]);

  const cacheResolvedSession = useCallback((session: ProjectSession) => {
    if (!session?.id) {
      return;
    }

    setSessionCache((previous) => {
      const next = new Map(previous);
      next.set(session.id, session);
      return next;
    });
  }, []);

  const markSessionAttention = useCallback((targetSessionId?: string | null) => {
    if (!targetSessionId) {
      return;
    }

    const viewedSessionId = selectedSessionRef.current?.id ?? sessionId ?? null;
    if (targetSessionId === viewedSessionId) {
      return;
    }

    setAttentionSessionIds((previous) => {
      if (previous.has(targetSessionId)) {
        return previous;
      }

      triggerHapticFeedback('permissionRequested');
      const next = new Set(previous);
      next.add(targetSessionId);
      return next;
    });
  }, [sessionId]);

  const clearSessionAttention = useCallback((targetSessionId?: string | null) => {
    if (!targetSessionId) {
      return;
    }

    setAttentionSessionIds((previous) => {
      if (!previous.has(targetSessionId)) {
        return previous;
      }

      const next = new Set(previous);
      next.delete(targetSessionId);
      return next;
    });
  }, []);

  const fetchProjects = useCallback(async ({ showLoadingState = true }: FetchProjectsOptions = {}) => {
    try {
      if (showLoadingState) {
        setIsLoadingProjects(true);
      }
      const response = await api.projects();
      const projectData = (await response.json()) as Project[];

      setProjects((prevProjects) => {
        const projectsWithTaskMaster = mergeTaskMasterCache(projectData, prevProjects);
        const mergedProjects = mergeExpandedSessionPages(prevProjects, projectsWithTaskMaster);

        if (prevProjects.length === 0) {
          return mergedProjects;
        }

        return projectsHaveChanges(prevProjects, mergedProjects)
          ? mergedProjects
          : prevProjects;
      });
    } catch (error) {
      console.error('Error fetching projects:', error);
    } finally {
      if (showLoadingState) {
        setIsLoadingProjects(false);
      }
    }
  }, []);

  const refreshProjectsSilently = useCallback(async () => {
    // Keep chat view stable while still syncing sidebar/session metadata in background.
    await fetchProjects({ showLoadingState: false });
  }, [fetchProjects]);

  const registerOptimisticSession = useCallback(({
    sessionId: newSessionId,
    provider,
    project,
    summary,
  }: RegisterOptimisticSessionArgs) => {
    if (!newSessionId || !project?.projectId) {
      return;
    }

    const now = new Date().toISOString();
    const optimisticSession: ProjectSession = {
      id: newSessionId,
      summary: summary ?? '',
      messageCount: 0,
      createdAt: now,
      created_at: now,
      updated_at: now,
      lastActivity: now,
      __provider: provider,
      __projectId: project.projectId,
    };
    const upsert: SessionUpsertedEvent = {
      kind: 'session_upserted',
      sessionId: newSessionId,
      provider,
      session: optimisticSession,
      project: {
        projectId: project.projectId,
        path: project.path || project.fullPath,
        fullPath: project.fullPath || project.path || '',
        displayName: project.displayName,
        isStarred: Boolean(project.isStarred),
      },
      timestamp: now,
    };

    setProjects((previousProjects) => {
      const existingProject = previousProjects.find((candidate) => candidate.projectId === project.projectId);
      if (!existingProject) {
        return [upsertSessionIntoProject(projectFromRegistration(project), upsert), ...previousProjects];
      }

      const updatedProject = upsertSessionIntoProject(existingProject, upsert);
      if (updatedProject === existingProject) {
        return previousProjects;
      }

      return previousProjects.map((candidate) =>
        candidate.projectId === existingProject.projectId ? updatedProject : candidate,
      );
    });

    setSelectedProject((previousProject) => {
      if (!previousProject || previousProject.projectId !== project.projectId) {
        return previousProject;
      }

      const updatedProject = upsertSessionIntoProject(previousProject, upsert);
      return updatedProject === previousProject ? previousProject : updatedProject;
    });

    setSelectedSession((previousSession) => {
      if (previousSession?.id === newSessionId) {
        return { ...previousSession, ...optimisticSession };
      }

      // With multiple panes, the new session can be established in a pane the
      // user is not looking at. Substituting it unconditionally would make the
      // sidebar/header jump away from the session they are viewing — only take
      // over the selection when nothing is selected or the optimistic session
      // belongs to the same project as the current selection.
      if (previousSession && previousSession.__projectId !== project.projectId) {
        return previousSession;
      }

      return optimisticSession;
    });

    cacheResolvedSession(optimisticSession);
  }, [cacheResolvedSession]);

  // Hydrates TaskMaster details for the given `projectId`. The project
  // identifier comes directly from the DB-driven /api/projects response.
  const hydrateProjectTaskMaster = useCallback(async (projectId: string) => {
    if (!projectId) {
      return;
    }

    try {
      const response = await api.projectTaskmaster(projectId);
      if (!response.ok) {
        return;
      }

      const data = (await response.json()) as { taskmaster?: Project['taskmaster'] };
      const taskMasterInfo = data.taskmaster;
      if (!taskMasterInfo) {
        return;
      }

      setProjects((previousProjects) =>
        previousProjects.map((project) =>
          project.projectId === projectId
            ? { ...project, taskmaster: taskMasterInfo }
            : project,
        ),
      );

      setSelectedProject((previousProject) => {
        if (!previousProject || previousProject.projectId !== projectId) {
          return previousProject;
        }

        return {
          ...previousProject,
          taskmaster: taskMasterInfo,
        };
      });
    } catch (error) {
      console.error(`Error fetching TaskMaster info for project ${projectId}:`, error);
    }
  }, []);

  const openSettings = useCallback((tab = 'tools') => {
    setSettingsInitialTab(tab);
    setShowSettings(true);
  }, []);

  useEffect(() => {
    void fetchProjects();
  }, [fetchProjects]);

  useEffect(() => {
    if (!selectedProject?.projectId) {
      return;
    }

    void hydrateProjectTaskMaster(selectedProject.projectId);
  }, [hydrateProjectTaskMaster, selectedProject?.projectId]);

  // Auto-select the project when there is only one, so the user lands on the new session page
  useEffect(() => {
    if (!isLoadingProjects && projects.length === 1 && !selectedProject && !sessionId) {
      setSelectedProject(projects[0]);
    }
  }, [isLoadingProjects, projects, selectedProject, sessionId]);

  // The focused pane is the source of truth for the workspace context. When it
  // points at a different project (or a session-less draft), follow it so the
  // header, TaskMaster and chat all operate on the pane the user is looking at.
  useEffect(() => {
    if (!activePaneProjectId) {
      return;
    }

    setSelectedProject((previousProject) => {
      if (previousProject?.projectId === activePaneProjectId) {
        return previousProject;
      }
      return projectsRef.current.find((project) => project.projectId === activePaneProjectId) ?? previousProject;
    });
  }, [activePaneProjectId]);

  // Cold-load hydration. The effect above resolves the project through
  // `projectsRef`, which is still empty while `/api/projects` is in flight,
  // and `activePaneProjectId` never changes for a restored workspace — so the
  // lookup never retries. Without this, reloading with a terminal/browser pane
  // (or a session-less draft) focused leaves `selectedProject` null and
  // MainContent renders the "choose a project" screen instead of the panes.
  useEffect(() => {
    if (!activePaneProjectId || selectedProject) {
      return;
    }

    const match = projects.find((project) => project.projectId === activePaneProjectId);
    if (match) {
      setSelectedProject(match);
    }
  }, [activePaneProjectId, projects, selectedProject]);

  // Late-bound: the realtime handler below runs before handleSessionDelete's
  // declaration line is evaluated, so it must reach the callback through a ref.
  const handleSessionDeleteRef = useRef<(sessionId: string) => void>(() => {});

  // Realtime sidebar updates. The backend pushes per-session deltas
  // (`session_upserted`) instead of full project snapshots, so each event is
  // a keyed upsert that can never clobber unrelated client state — no
  // "suppress updates while a run is active" protection is needed anymore.
  useEffect(() => {
    const handleEvent = (event: ServerEvent) => {
      if (event.kind === 'session_removed') {
        // Archived or deleted on another client: run the same local cleanup
        // (deselect, drop caches, unbind panes) the deleting client ran.
        const removedSessionId = typeof event.sessionId === 'string' ? event.sessionId : null;
        if (removedSessionId) {
          handleSessionDeleteRef.current(removedSessionId);
        }
        return;
      }

      if (event.kind === 'loading_progress') {
        if (loadingProgressTimeoutRef.current) {
          clearTimeout(loadingProgressTimeoutRef.current);
          loadingProgressTimeoutRef.current = null;
        }

        setLoadingProgress(event as unknown as LoadingProgress);

        if (event.phase === 'complete') {
          loadingProgressTimeoutRef.current = setTimeout(() => {
            setLoadingProgress(null);
            loadingProgressTimeoutRef.current = null;
          }, 500);
        }

        return;
      }

      const eventSessionId = typeof event.sessionId === 'string' && event.sessionId
        ? event.sessionId
        : null;
      const viewedSessionId = selectedSessionRef.current?.id ?? sessionId ?? null;

      if (
        eventSessionId
        && eventSessionId !== viewedSessionId
        && event.kind !== 'chat_subscribed'
        && event.kind !== 'loading_progress'
        && event.kind !== 'session_upserted'
        && event.kind !== 'status'
        && event.kind !== 'stream_end'
        && event.kind !== 'permission_cancelled'
        && event.kind !== 'websocket_reconnected'
      ) {
        markSessionAttention(eventSessionId);
      }

      if (event.kind !== 'session_upserted') {
        return;
      }

      const upsert = event as SessionUpsertedEvent;
      if (!upsert.sessionId || !upsert.session || isSubagentSession(upsert.session)) {
        return;
      }

      // The transcript of the currently viewed session changed on disk while
      // no run is active here (e.g. edited from another client or the CLI):
      // signal the chat view to reload its messages.
      const currentSelectedSession = selectedSessionRef.current;
      if (
        currentSelectedSession
        && upsert.sessionId === currentSelectedSession.id
        && !activeSessionsRef.current.has(upsert.sessionId)
      ) {
        setExternalMessageUpdate((prev) => prev + 1);
      } else {
        markSessionAttention(upsert.sessionId);
      }

      setProjects((previousProjects) => {
        const targetProjectId = upsert.project?.projectId;
        const existingProject = previousProjects.find((project) =>
          targetProjectId ? project.projectId === targetProjectId : getProjectSessions(project).some((session) => session.id === upsert.sessionId),
        );

        if (!existingProject) {
          // First session of a project this client has never seen: create the
          // project entry from the event payload.
          if (!upsert.project) {
            return previousProjects;
          }

          const newProject: Project = {
            projectId: upsert.project.projectId,
            path: upsert.project.path,
            fullPath: upsert.project.fullPath,
            displayName: upsert.project.displayName,
            isStarred: upsert.project.isStarred,
            sessions: [],
            sessionMeta: { hasMore: false, total: 0 },
          } as Project;

          return [...previousProjects, upsertSessionIntoProject(newProject, upsert)];
        }

        const updatedProject = upsertSessionIntoProject(existingProject, upsert);
        if (updatedProject === existingProject) {
          return previousProjects;
        }

        return previousProjects.map((project) =>
          project.projectId === existingProject.projectId ? updatedProject : project,
        );
      });

      // Keep the selected project reference in sync with the upsert.
      setSelectedProject((previousProject) => {
        if (!previousProject) {
          return previousProject;
        }
        const matches = upsert.project
          ? previousProject.projectId === upsert.project.projectId
          : getProjectSessions(previousProject).some((session) => session.id === upsert.sessionId);
        if (!matches) {
          return previousProject;
        }
        const updated = upsertSessionIntoProject(previousProject, upsert);
        return updated === previousProject ? previousProject : updated;
      });

      const aliasedSelectedSessionId =
        typeof upsert.providerSessionId === 'string' && upsert.providerSessionId !== upsert.sessionId
          ? upsert.providerSessionId
          : null;
      if (!aliasedSelectedSessionId) {
        return;
      }

      const normalizedSelectedSession: ProjectSession = {
        ...upsert.session,
        id: upsert.sessionId,
        __provider: upsert.provider,
        __projectId: upsert.project?.projectId ?? currentSelectedSession?.__projectId,
      };

      setSelectedSession((previousSession) => {
        if (previousSession?.id !== aliasedSelectedSessionId) {
          return previousSession;
        }

        return {
          ...previousSession,
          ...normalizedSelectedSession,
        };
      });

      if (sessionId === aliasedSelectedSessionId) {
        onSessionAliasResolved?.(upsert.sessionId, aliasedSelectedSessionId);
      }
    };

    return subscribe(handleEvent);
  }, [markSessionAttention, sessionId, subscribe, onSessionAliasResolved]);

  useEffect(() => {
    return () => {
      if (loadingProgressTimeoutRef.current) {
        clearTimeout(loadingProgressTimeoutRef.current);
        loadingProgressTimeoutRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    clearSessionAttention(selectedSession?.id ?? sessionId ?? null);
  }, [clearSessionAttention, selectedSession?.id, sessionId]);

  useEffect(() => {
    if (!sessionId) {
      // The focused pane is a session-less draft (or there is no session at
      // all): drop the global selection so the sidebar highlight and header
      // actions stop pointing at a session the user is not looking at.
      setSelectedSession((previousSession) => (previousSession === null ? previousSession : null));
      return;
    }

    // Project membership is resolved through `projectId` after the migration.
    for (const project of projects) {
      const match = project.sessions?.find((session) => session.id === sessionId);
      if (match) {
        const normalizedSession = normalizeSessionProvider(match);
        const shouldUpdateProject = selectedProject?.projectId !== project.projectId;
        const shouldUpdateSession =
          selectedSession?.id !== sessionId || selectedSession.__provider !== normalizedSession.__provider;

        if (shouldUpdateProject) {
          setSelectedProject(project);
        }
        if (shouldUpdateSession) {
          setSelectedSession(normalizedSession);
        }
        return;
      }
    }

    if (selectedSession?.id === sessionId) {
      return;
    }

    // Session id is in the URL but not present on any loaded project payload.
    // The payloads are paginated (only each project's first session page is
    // loaded), so this is normal for deep links to older sessions. Never guess
    // the owning project from local state — that used to bind the session to
    // whatever project happened to be selected. Ask the backend instead; one
    // lookup per URL id.
    if (sessionLookupRef.current === sessionId) {
      return;
    }
    sessionLookupRef.current = sessionId;

    void (async () => {
      let details: SessionDetailsApiPayload['data'] | null = null;
      try {
        const response = await api.sessionDetails(sessionId);
        if (response.ok) {
          const payload = (await response.json()) as SessionDetailsApiPayload;
          details = payload.data ?? null;
        }
      } catch (error) {
        console.error(`Error resolving session ${sessionId}:`, error);
      }

      // The user navigated elsewhere while the lookup was in flight.
      if (sessionIdRef.current !== sessionId) {
        return;
      }

      if (!details) {
        // Unknown session id (or lookup failed). Fall back to the legacy
        // behavior: host a placeholder under the currently selected project so
        // chat state stays alive (without a `selectedSession`, chat clears
        // `currentSessionId` and stops reading the session store).
        const fallbackProject = selectedProjectRef.current;
        if (!fallbackProject || selectedSessionRef.current?.id === sessionId) {
          return;
        }

        const placeholderSession: ProjectSession = {
          id: sessionId,
          __provider: readSelectedProvider(),
          __projectId: fallbackProject.projectId,
          summary: '',
        };
        setSelectedSession(placeholderSession);
        cacheResolvedSession(placeholderSession);
        return;
      }

      // The pane carried a provider-native alias id: swap it for the canonical
      // app-facing id on the owning pane instead of rewriting the URL.
      if (typeof details.sessionId === 'string' && details.sessionId && details.sessionId !== sessionId) {
        onSessionAliasResolved?.(details.sessionId, sessionId);
        return;
      }

      const resolvedProjectId = details.project?.projectId;
      if (resolvedProjectId) {
        setSelectedProject((previousProject) => {
          if (previousProject?.projectId === resolvedProjectId) {
            return previousProject;
          }

          const loadedProject = projectsRef.current.find(
            (candidate) => candidate.projectId === resolvedProjectId,
          );
          if (loadedProject) {
            return loadedProject;
          }

          // Owning project is not in the active project list (e.g. archived):
          // synthesize a minimal entry so the chat view still gets its paths.
          return {
            projectId: resolvedProjectId,
            path: details.project?.path ?? details.project?.fullPath ?? '',
            fullPath: details.project?.fullPath ?? details.project?.path ?? '',
            displayName: details.project?.displayName ?? '',
            isStarred: Boolean(details.project?.isStarred),
            sessions: [],
            sessionMeta: { hasMore: false, total: 0 },
          };
        });
      }

      const resolvedSession: ProjectSession = {
        id: sessionId,
        summary: details.summary ?? '',
        createdAt: details.createdAt ?? undefined,
        lastActivity: details.lastActivity ?? undefined,
        lastViewedAt: details.lastViewedAt ?? undefined,
        model: details.model ?? null,
        __provider:
          typeof details.provider === 'string' && details.provider.trim()
            ? (details.provider as LLMProvider)
            : readSelectedProvider(),
        __projectId: resolvedProjectId,
      };

      setSelectedSession((previousSession) =>
        previousSession?.id === sessionId
          ? { ...previousSession, ...resolvedSession }
          : resolvedSession,
      );

      // Any pane may end up bound to this session while the project payloads
      // only carry page 0 — cache it so inactive panes resolve it too.
      cacheResolvedSession(resolvedSession);
    })();
  }, [sessionId, projects, selectedProject, selectedSession?.id, selectedSession?.__provider, onSessionAliasResolved, cacheResolvedSession]);

  const handleProjectSelect = useCallback(
    (project: Project, options?: { replace?: boolean }) => {
      setSelectedProject(project);
      setSelectedSession(null);
      navigate('/', { replace: options?.replace === true });

      if (isMobile) {
        setSidebarOpen(false);
      }
    },
    [isMobile, navigate],
  );

  const handleSessionSelect = useCallback(
    (session: ProjectSession) => {
      clearSessionAttention(session.id);
      setSelectedSession(session);

      if (activeTab === 'tasks' || activeTab === 'browser') {
        setActiveTab('chat');
      }

      if (isMobile) {
        // Sessions are tagged with the owning project's DB `projectId` when
        // picked from the sidebar (see useSidebarController); compare against
        // the current selection's `projectId` so we know whether to collapse
        // the sidebar after navigation.
        const sessionProjectId = session.__projectId;
        const currentProjectId = selectedProject?.projectId;

        if (sessionProjectId !== currentProjectId) {
          setSidebarOpen(false);
        }
      }

      onOpenSession?.(session.id, session.__projectId ?? selectedProject?.projectId ?? null);
    },
    [activeTab, clearSessionAttention, isMobile, onOpenSession, selectedProject?.projectId],
  );

  const handleNewSession = useCallback(
    (project: Project) => {
      setSelectedProject(project);
      setSelectedSession(null);
      setActiveTab('chat');
      setNewSessionTrigger((previous) => previous + 1);
      navigate('/');
      // Sessions render only inside panes now, so a New Session must ensure a
      // draft chat pane exists (and is focused) before the trigger can reset it.
      onNewSessionPane?.(project.projectId);

      if (isMobile) {
        setSidebarOpen(false);
      }
    },
    [isMobile, navigate, onNewSessionPane],
  );

  const handleSessionDelete = useCallback(
    (sessionIdToDelete: string) => {
      clearSessionAttention(sessionIdToDelete);
      // Browser-local leftovers (composer draft, offline queue) have no
      // session left to bind to — an offline entry would otherwise flush
      // into a guaranteed server rejection.
      purgeSessionLocalState(sessionIdToDelete);

      if (selectedSession?.id === sessionIdToDelete) {
        setSelectedSession(null);
        navigate('/');
      }

      setSessionCache((previous) => {
        if (!previous.has(sessionIdToDelete)) {
          return previous;
        }
        const next = new Map(previous);
        next.delete(sessionIdToDelete);
        return next;
      });

      setProjects((prevProjects) =>
        prevProjects.map((project) => removeSessionFromProject(project, sessionIdToDelete)),
      );

      // Workspace panes are persisted separately from projects — panes still
      // bound to the deleted session would keep a dead sessionId otherwise.
      onSessionDeleted?.(sessionIdToDelete);
    },
    [clearSessionAttention, navigate, onSessionDeleted, selectedSession?.id],
  );
  handleSessionDeleteRef.current = handleSessionDelete;

  const renameSession = useCallback(
    async (sessionIdToRename: string, summary: string): Promise<{ ok: boolean; error?: string }> => {
    const trimmed = summary.trim();
    if (!trimmed) {
      return { ok: false, error: 'Session name is required.' };
    }

    try {
      const response = await api.renameSession(sessionIdToRename, trimmed);
      if (!response.ok) {
        const payload = (await response.json().catch(() => null)) as
          | { error?: { message?: string } }
          | null;
        const message = payload?.error?.message || `Request failed (${response.status}).`;
        console.error('[App] Failed to rename session:', message);
        return { ok: false, error: message };
      }

      setProjects((previousProjects) =>
        previousProjects.map((project) => ({
          ...project,
          sessions: project.sessions?.map((session) =>
            session.id === sessionIdToRename ? { ...session, summary: trimmed } : session,
          ),
        })),
      );
      setSelectedSession((previousSession) =>
        previousSession?.id === sessionIdToRename
          ? { ...previousSession, summary: trimmed }
          : previousSession,
      );
      setSessionCache((previous) => {
        const cached = previous.get(sessionIdToRename);
        if (!cached) {
          return previous;
        }
        const next = new Map(previous);
        next.set(sessionIdToRename, { ...cached, summary: trimmed });
        return next;
      });
      return { ok: true };
    } catch (error) {
      console.error('[App] Error renaming session:', error);
      return { ok: false, error: error instanceof Error ? error.message : 'Unexpected error.' };
    }
    },
    [],
  );

  const handleSidebarRefresh = useCallback(async (): Promise<Project[] | null> => {
    try {
      const response = await api.projects();
      const freshProjects = (await response.json()) as Project[];
      const projectsWithTaskMaster = mergeTaskMasterCache(freshProjects, projects);
      const mergedProjects = mergeExpandedSessionPages(projects, projectsWithTaskMaster);

      setProjects((prevProjects) =>
        projectsHaveChanges(prevProjects, mergedProjects) ? mergedProjects : prevProjects,
      );

      if (!selectedProject) {
        return mergedProjects;
      }

      const refreshedProject = mergedProjects.find((project) => project.projectId === selectedProject.projectId);
      if (!refreshedProject) {
        return mergedProjects;
      }

      if (serialize(refreshedProject) !== serialize(selectedProject)) {
        setSelectedProject(refreshedProject);
      }

      if (!selectedSession) {
        return mergedProjects;
      }

      const refreshedSession = getProjectSessions(refreshedProject).find(
        (session) => session.id === selectedSession.id,
      );

      if (refreshedSession) {
        // Keep provider metadata stable when refreshed payload doesn't include __provider.
        const normalizedRefreshedSession =
          refreshedSession.__provider || !selectedSession.__provider
            ? refreshedSession
            : { ...refreshedSession, __provider: selectedSession.__provider };

        if (serialize(normalizedRefreshedSession) !== serialize(selectedSession)) {
          setSelectedSession(normalizedRefreshedSession);
        }
      }

      return mergedProjects;
    } catch (error) {
      console.error('Error refreshing sidebar:', error);
      return null;
    }
  }, [projects, selectedProject, selectedSession]);

  const changeSessionWorkspace = useCallback(
    async (sessionIdToMove: string, projectPath: string): Promise<{ ok: boolean; error?: string }> => {
      const trimmedPath = projectPath.trim();
      if (!trimmedPath) {
        return { ok: false, error: 'Workspace path is required.' };
      }

      try {
        const response = await api.changeSessionWorkspace(sessionIdToMove, trimmedPath);
        if (!response.ok) {
          const payload = (await response.json().catch(() => null)) as
            | { error?: { message?: string } }
            | null;
          const message = payload?.error?.message || `Request failed (${response.status}).`;
          console.error('[App] Failed to change session workspace:', message);
          return { ok: false, error: message };
        }

        // The server repoints the session onto another project row, so a full
        // refetch is the only way to re-home it in the sidebar grouping.
        const refreshedProjects = await handleSidebarRefresh();

        // Workspace panes persist their own projectId — repoint the panes
        // bound to this session at the project that now owns it.
        const owningProject =
          refreshedProjects?.find((project) =>
            (project.sessions ?? []).some((session) => session.id === sessionIdToMove),
          ) ??
          refreshedProjects?.find(
            (project) => project.fullPath === trimmedPath || project.path === trimmedPath,
          );
        if (owningProject) {
          // Session copies resolved outside the payloads (selectedSession,
          // sessionCache) still carry the old __projectId — repoint them too
          // so panes preferring session.__projectId see the new workspace.
          setSelectedSession((previousSession) =>
            previousSession?.id === sessionIdToMove &&
            previousSession.__projectId !== owningProject.projectId
              ? { ...previousSession, __projectId: owningProject.projectId }
              : previousSession,
          );
          setSessionCache((previous) => {
            const cached = previous.get(sessionIdToMove);
            if (!cached || cached.__projectId === owningProject.projectId) {
              return previous;
            }
            const next = new Map(previous);
            next.set(sessionIdToMove, { ...cached, __projectId: owningProject.projectId });
            return next;
          });
          onSessionWorkspaceChanged?.(sessionIdToMove, owningProject.projectId);
        }

        return { ok: true };
      } catch (error) {
        console.error('[App] Error changing session workspace:', error);
        return { ok: false, error: error instanceof Error ? error.message : 'Unexpected error.' };
      }
    },
    [handleSidebarRefresh, onSessionWorkspaceChanged],
  );

  const loadMoreProjectSessions = useCallback(async (projectId: string) => {
    const project = projects.find((candidate) => candidate.projectId === projectId);
    if (!project) {
      return;
    }

    const loadedCount = countLoadedProjectSessions(project);
    const totalCount = Number(project.sessionMeta?.total ?? 0);
    if (totalCount > 0 && loadedCount >= totalCount) {
      return;
    }

    const response = await api.projectSessions(projectId, {
      limit: 20,
      offset: loadedCount,
    });

    if (!response.ok) {
      const payload = (await response.json().catch(() => ({}))) as { error?: string | { message?: string } };
      const errorPayload = payload.error;
      const message =
        typeof errorPayload === 'string'
          ? errorPayload
          : errorPayload && typeof errorPayload === 'object' && errorPayload.message
            ? errorPayload.message
            : `Failed to load more sessions for project ${projectId}`;
      throw new Error(message);
    }

    const sessionsPage = (await response.json()) as ProjectSessionPage;

    let mergedProjectForSelection: Project | null = null;
    setProjects((previousProjects) =>
      previousProjects.map((candidate) => {
        if (candidate.projectId !== projectId) {
          return candidate;
        }

        const mergedProject = mergeProjectSessionPage(candidate, sessionsPage);
        mergedProjectForSelection = mergedProject;
        return mergedProject;
      }),
    );

    if (selectedProject?.projectId === projectId && mergedProjectForSelection) {
      setSelectedProject(mergedProjectForSelection);
    }
  }, [projects, selectedProject?.projectId]);

  // `projectId` is the DB identifier passed from the sidebar's delete flow
  // after the migration away from folder-derived project names.
  const handleProjectDelete = useCallback(
    (projectId: string) => {
      if (selectedProject?.projectId === projectId) {
        setSelectedProject(null);
        setSelectedSession(null);
        navigate('/');
      }

      setProjects((prevProjects) => prevProjects.filter((project) => project.projectId !== projectId));
    },
    [navigate, selectedProject?.projectId],
  );

  return {
    projects,
    selectedProject,
    selectedSession,
    sessionCache,
    activeTab,
    sidebarOpen,
    isLoadingProjects,
    loadingProgress,
    isInputFocused,
    showSettings,
    settingsInitialTab,
    externalMessageUpdate,
    newSessionTrigger,
    setActiveTab,
    setSidebarOpen,
    setIsInputFocused,
    setShowSettings,
    openSettings,
    fetchProjects,
    refreshProjectsSilently,
    registerOptimisticSession,
    handleProjectSelect,
    handleSessionSelect,
    handleNewSession,
    handleSessionDelete,
    loadMoreProjectSessions,
    handleProjectDelete,
    handleSidebarRefresh,
    renameSession,
    changeSessionWorkspace,
  };
}

import { useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';
import type { MutableRefObject } from 'react';

import { authenticatedFetch } from '../../../utils/api';
import type { MarkSessionIdle, SessionActivityMap } from '../../../hooks/useSessionProtection';
import type { Project, ProjectSession, LLMProvider } from '../../../types/app';
import type { SessionStore, NormalizedMessage } from '../../../stores/useSessionStore';
import { SESSION_MESSAGES_PAGE_SIZE } from '../../../stores/sessionMessagePagination';
import type { ChatMessage } from '../types/types';
import { createMessageHistoryRefreshCoordinator } from '../utils/messageHistoryRefreshCoordinator';
import { createCachedDiffCalculator, type DiffCalculator } from '../utils/messageTransforms';
import {
  captureScrollRestoreState,
  restoreScrollPosition,
  isNearBottom as checkNearBottom,
  shouldPinOnContentGrowth,
  type ScrollRestoreState,
} from '../utils/chatScrollAnchoring';

import { normalizedToChatMessages, sliceVisibleMessages } from './useChatMessages';

const INITIAL_VISIBLE_MESSAGES = SESSION_MESSAGES_PAGE_SIZE;

interface UseChatSessionStateArgs {
  isActive: boolean;
  selectedProject: Project | null;
  selectedSession: ProjectSession | null;
  ws: WebSocket | null;
  sendMessage: (message: unknown) => boolean;
  externalMessageUpdate?: number;
  newSessionTrigger?: number;
  processingSessions?: SessionActivityMap;
  onSessionIdle?: MarkSessionIdle;
  resetStreamingState: () => void;
  /** When each session's `chat.subscribe` was last sent; guards stale idle acks. */
  statusCheckSentAtRef: MutableRefObject<Map<string, number>>;
  /** Highest live seq observed per session; sent as `lastSeq` on subscribe. */
  lastSeqRef: MutableRefObject<Map<string, number>>;
  sessionStore: SessionStore;
}

/* ------------------------------------------------------------------ */
/*  Helper: Convert a ChatMessage to a NormalizedMessage for the store */
/* ------------------------------------------------------------------ */

function chatMessageToNormalized(
  msg: ChatMessage,
  sessionId: string,
  provider: LLMProvider,
): NormalizedMessage | null {
  const id = `local_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`;
  const ts = msg.timestamp instanceof Date
    ? msg.timestamp.toISOString()
    : typeof msg.timestamp === 'number'
      ? new Date(msg.timestamp).toISOString()
      : String(msg.timestamp);
  const base = { id, sessionId, timestamp: ts, provider };

  if (msg.isToolUse) {
    return {
      ...base,
      kind: 'tool_use',
      toolName: msg.toolName,
      toolInput: msg.toolInput,
      toolId: msg.toolId || id,
    } as NormalizedMessage;
  }
  if (msg.isThinking) {
    return { ...base, kind: 'thinking', content: msg.content || '' } as NormalizedMessage;
  }
  if (msg.isInteractivePrompt) {
    return { ...base, kind: 'interactive_prompt', content: msg.content || '' } as NormalizedMessage;
  }
  if ((msg as any).isTaskNotification) {
    return {
      ...base,
      kind: 'task_notification',
      status: (msg as any).taskStatus || 'completed',
      summary: msg.content || '',
    } as NormalizedMessage;
  }
  if (msg.type === 'error') {
    return { ...base, kind: 'error', content: msg.content || '' } as NormalizedMessage;
  }
  return {
    ...base,
    kind: 'text',
    role: msg.type === 'user' ? 'user' : 'assistant',
    content: msg.content || '',
    // Keep attachment references on the local echo so the user bubble shows
    // its files immediately, before the server-backed copy replaces it.
    images: Array.isArray(msg.images) && msg.images.length > 0 ? msg.images : undefined,
    files: Array.isArray(msg.files) && msg.files.length > 0 ? msg.files : undefined,
  } as NormalizedMessage;
}

/* ------------------------------------------------------------------ */
/*  Hook                                                              */
/* ------------------------------------------------------------------ */

export function useChatSessionState({
  isActive,
  selectedProject,
  selectedSession,
  ws,
  sendMessage,
  externalMessageUpdate,
  newSessionTrigger,
  processingSessions,
  onSessionIdle,
  resetStreamingState,
  statusCheckSentAtRef,
  lastSeqRef,
  sessionStore,
}: UseChatSessionStateArgs) {
  const [currentSessionId, setCurrentSessionId] = useState<string | null>(selectedSession?.id || null);
  const [isLoadingSessionMessages, setIsLoadingSessionMessages] = useState(false);
  const [isLoadingMoreMessages, setIsLoadingMoreMessages] = useState(false);
  const [loadOlderMessagesError, setLoadOlderMessagesError] = useState<string | null>(null);
  const [hasMoreMessages, setHasMoreMessages] = useState(false);
  const [totalMessages, setTotalMessages] = useState(0);
  const isUserScrolledUpRef = useRef(false);
  const [isUserScrolledUp, setIsUserScrolledUp] = useState(false);
  isUserScrolledUpRef.current = isUserScrolledUp;
  const [tokenBudget, setTokenBudget] = useState<Record<string, unknown> | null>(null);
  // Bumped by every live `token_budget` frame. The initial REST fetch reads it
  // before its request and discards its own result when the counter moved in
  // the meantime: a streamed snapshot is always fresher than the fetch, and a
  // 404 (providers without file-backed usage) must not clear the live value.
  const liveBudgetVersionRef = useRef(0);
  // Live frames enter through this setter so they mark the budget as streamed;
  // the hook's own REST snapshots and session resets keep using the raw setter.
  const setLiveTokenBudget = useCallback((budget: Record<string, unknown> | null) => {
    liveBudgetVersionRef.current += 1;
    setTokenBudget(budget);
  }, []);
  const [visibleMessageCount, setVisibleMessageCount] = useState(INITIAL_VISIBLE_MESSAGES);
  const [allMessagesLoaded, setAllMessagesLoaded] = useState(false);
  const [isLoadingAllMessages, setIsLoadingAllMessages] = useState(false);
  const [loadAllJustFinished, setLoadAllJustFinished] = useState(false);
  const [showLoadAllOverlay, setShowLoadAllOverlay] = useState(false);
  const [viewHiddenCount, setViewHiddenCount] = useState(0);

  const scrollContainerRef = useRef<HTMLDivElement>(null);
  // The message wrapper inside the scroll container — observed for content
  // growth that happens after the render that produced it (images decoding,
  // async diff/highlight layout).
  const contentRef = useRef<HTMLDivElement>(null);
  const wasNearTopRef = useRef(false);
  const [searchTarget, setSearchTarget] = useState<{ timestamp?: string; uuid?: string; snippet?: string } | null>(null);
  const searchScrollActiveRef = useRef(false);
  const isLoadingSessionRef = useRef(false);
  const isLoadingMoreRef = useRef(false);
  const allMessagesLoadedRef = useRef(false);
  const topLoadLockRef = useRef(false);
  const pendingScrollRestoreRef = useRef<ScrollRestoreState | null>(null);
  const messagesOffsetRef = useRef(0);
  const scrollPositionRef = useRef({ height: 0, top: 0 });

  // Track physical user interaction (wheel/touch) separately from programmatic
  // scroll events so a layout jump doesn't flip the "user scrolled up" flag.
  const isUserInteractingRef = useRef(false);
  const userInteractionTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  // scrollHeight when the current wheel/touch gesture started, so the post-
  // gesture re-pin only fires when content actually arrived mid-gesture.
  const interactionStartHeightRef = useRef(0);
  // Wheel/touch scrolls resume following after the gesture; a click (e.g.
  // expanding a tool card) must leave the viewport where the user put it.
  const interactionKindRef = useRef<'scroll' | 'pointer'>('scroll');
  const scrollAwayTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const loadAllFinishedTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const loadAllOverlayTimerRef = useRef<ReturnType<typeof setTimeout> | null>(null);
  const lastLoadedSessionKeyRef = useRef<string | null>(null);
  /**
   * Tracks the last processed value from `useProjectsState.newSessionTrigger`.
   *
   * The trigger itself is intentionally increment-only and routed via:
   * useProjectsState -> AppContent -> MainContent -> ChatInterface -> this hook.
   * We compare values to ensure each explicit New Session click runs exactly one
   * reset pass in this local chat state domain.
   */
  const previousNewSessionTriggerRef = useRef(newSessionTrigger ?? 0);

  const createDiff = useMemo<DiffCalculator>(() => createCachedDiffCalculator(), []);

  useEffect(() => {
    const trigger = newSessionTrigger ?? 0;
    if (trigger === previousNewSessionTriggerRef.current) {
      return;
    }
    previousNewSessionTriggerRef.current = trigger;

    /**
     * Consumer-side reset for explicit New Session intent.
     *
     * Why this is essential:
     * - Chat keeps local state that is not fully derived from `selectedSession`:
     *   `currentSessionId`, `pendingUserMessage`, streaming/status flags, message
     *   pagination/scroll bookkeeping, and provider-specific sessionStorage keys.
     * - If the user clicks New Session while already on the same route with no
     *   selected session, parent state updates can be idempotent and this local
     *   state would otherwise persist, making the click appear to "do nothing".
     *
     * What this reset guarantees:
     * - A deterministic clean draft state on every New Session click.
     * - No dependence on route/tab/session-object identity changes.
     * - No coupling to unrelated external update signals.
     */
    resetStreamingState();
    setCurrentSessionId(null);
    setPendingUserMessage(null);
    messagesOffsetRef.current = 0;
    setHasMoreMessages(false);
    setTotalMessages(0);
    
    setTokenBudget(null);
    setVisibleMessageCount(INITIAL_VISIBLE_MESSAGES);
    setAllMessagesLoaded(false);
    allMessagesLoadedRef.current = false;
    setIsLoadingAllMessages(false);
    setLoadAllJustFinished(false);
    setShowLoadAllOverlay(false);
    setViewHiddenCount(0);
    setSearchTarget(null);
    wasNearTopRef.current = false;
    searchScrollActiveRef.current = false;
    topLoadLockRef.current = false;
    pendingScrollRestoreRef.current = null;
    lastLoadedSessionKeyRef.current = null;

    if (loadAllOverlayTimerRef.current) {
      clearTimeout(loadAllOverlayTimerRef.current);
      loadAllOverlayTimerRef.current = null;
    }
    if (loadAllFinishedTimerRef.current) {
      clearTimeout(loadAllFinishedTimerRef.current);
      loadAllFinishedTimerRef.current = null;
    }
  }, [newSessionTrigger, onSessionIdle, resetStreamingState]);

  /* ---------------------------------------------------------------- */
  /*  Derive processing state for the viewed session                  */
  /* ---------------------------------------------------------------- */

  const activeSessionId = selectedSession?.id || currentSessionId || null;

  // The activity indicator always reflects the latest status of the session
  // being viewed — never stale local UI state from the last time it was
  // open. Session ids are concrete before any send, so no pending
  // placeholder entry exists anymore.
  const sessionActivity = (activeSessionId && processingSessions?.get(activeSessionId)) || null;
  const isProcessing = sessionActivity !== null;
  const canAbortSession = isProcessing && sessionActivity.canInterrupt;

  // Ref mirror so effects can read the latest map without re-running on
  // every activity transition.
  const processingSessionsRef = useRef(processingSessions);
  processingSessionsRef.current = processingSessions;

  const isActiveRef = useRef(isActive);
  const activeSessionIdRef = useRef(activeSessionId);
  const selectedSessionRef = useRef(selectedSession);
  const selectedProjectRef = useRef(selectedProject);
  isActiveRef.current = isActive;
  activeSessionIdRef.current = activeSessionId;
  selectedSessionRef.current = selectedSession;
  selectedProjectRef.current = selectedProject;

  // No longer auto-fetches the full transcript when a run ends.
  // `requestLatestMessages` is already triggered on the server `complete` event,
  // and the bounded tail refresh (now enlarged) bridges multi-page Devin turns.

  const latestRefreshExecutorRef = useRef<(sessionId: string) => Promise<boolean | void>>(
    async () => true,
  );
  latestRefreshExecutorRef.current = async (sessionId: string) => {
    const result = await sessionStore.refreshLatestFromServer(sessionId, {
      limit: SESSION_MESSAGES_PAGE_SIZE,
      canRequest: () => (
        isActiveRef.current
        && activeSessionIdRef.current === sessionId
      ),
    });
    const slot = result.slot;
    if (slot && activeSessionIdRef.current === sessionId) {
      setHasMoreMessages(slot.hasMore);
      setTotalMessages(slot.total);
      messagesOffsetRef.current = slot.offset;
      if (slot.tokenUsage) {
        setTokenBudget(slot.tokenUsage as Record<string, unknown>);
      }
    }
    return !result.deferred;
  };

  const refreshCoordinatorRef = useRef<ReturnType<typeof createMessageHistoryRefreshCoordinator> | null>(null);
  if (!refreshCoordinatorRef.current) {
    refreshCoordinatorRef.current = createMessageHistoryRefreshCoordinator(
      (sessionId) => latestRefreshExecutorRef.current(sessionId),
      (sessionId) => isActiveRef.current && activeSessionIdRef.current === sessionId,
    );
  }

  const requestLatestMessages = useCallback((sessionId: string, allowNetwork = isActiveRef.current) => (
    refreshCoordinatorRef.current?.request(sessionId, allowNetwork) ?? Promise.resolve()
  ), []);

  /* ---------------------------------------------------------------- */
  /*  Derive chatMessages from the store                              */
  /* ---------------------------------------------------------------- */
  const [pendingUserMessage, setPendingUserMessage] = useState<ChatMessage | null>(null);
  const flushedPendingUserMessageRef = useRef<ChatMessage | null>(null);

  // Each pane's store watches the session it displays so visible split panes
  // update live; only an empty/draft pane stays unbound.
  const activeSessionForStore = activeSessionId;
  const prevActiveForStoreRef = useRef<string | null>(null);
  if (activeSessionForStore !== prevActiveForStoreRef.current) {
    prevActiveForStoreRef.current = activeSessionForStore;
    sessionStore.setActiveSession(activeSessionForStore);
  }

  useEffect(() => {
    if (!pendingUserMessage) {
      flushedPendingUserMessageRef.current = null;
      return;
    }

    if (!activeSessionId) {
      return;
    }

    if (flushedPendingUserMessageRef.current === pendingUserMessage) {
      return;
    }

    // Split panes may run different providers, so the session's own provider
    // wins over the shared 'selected-provider' key written by whichever pane
    // rendered last. Payload sessions only carry the plain `provider` field.
    const prov = selectedSessionRef.current?.__provider
      || selectedSessionRef.current?.provider
      || (localStorage.getItem('selected-provider') as LLMProvider)
      || 'claude';
    const normalized = chatMessageToNormalized(pendingUserMessage, activeSessionId, prov);
    if (normalized) {
      sessionStore.appendRealtime(activeSessionId, normalized);
    }

    flushedPendingUserMessageRef.current = pendingUserMessage;
    setPendingUserMessage(null);
  }, [activeSessionId, pendingUserMessage, sessionStore]);

  const storeMessages = activeSessionId ? sessionStore.getMessages(activeSessionId) : [];

  // Reset viewHiddenCount when store messages change
  const prevStoreLenRef = useRef(0);
  if (storeMessages.length !== prevStoreLenRef.current) {
    prevStoreLenRef.current = storeMessages.length;
    if (viewHiddenCount > 0) setViewHiddenCount(0);
  }

  // A session switch in this tile must not display the previous session's
  // token summary while the new session's budget is still loading — reset
  // synchronously during render so no stale value is ever painted.
  const prevBudgetSessionIdRef = useRef<string | null>(selectedSession?.id ?? null);
  if (prevBudgetSessionIdRef.current !== (selectedSession?.id ?? null)) {
    prevBudgetSessionIdRef.current = selectedSession?.id ?? null;
    setTokenBudget(null);
  }

  const chatMessages = useMemo(() => {
    const all = normalizedToChatMessages(storeMessages);
    // Show pending user message when no session data exists yet (new session, pre-backend-response)
    if (pendingUserMessage && all.length === 0) {
      return [pendingUserMessage];
    }
    if (viewHiddenCount > 0 && viewHiddenCount < all.length) return all.slice(0, -viewHiddenCount);
    return all;
  }, [storeMessages, viewHiddenCount, pendingUserMessage]);

  const visibleMessages = useMemo(() => {
    if (allMessagesLoaded) return chatMessages;
    return sliceVisibleMessages(chatMessages, visibleMessageCount);
  }, [allMessagesLoaded, chatMessages, visibleMessageCount]);

  /* ---------------------------------------------------------------- */
  /*  addMessage / clearMessages / rewindMessages                     */
  /* ---------------------------------------------------------------- */

  const addMessage = useCallback((msg: ChatMessage, targetSessionId?: string) => {
    const sid = targetSessionId || activeSessionId;
    if (!sid) {
      // No session yet — show as pending until the backend creates one
      setPendingUserMessage(msg);
      return;
    }
    const prov = selectedSessionRef.current?.__provider
      || selectedSessionRef.current?.provider
      || (localStorage.getItem('selected-provider') as LLMProvider)
      || 'claude';
    const normalized = chatMessageToNormalized(msg, sid, prov);
    if (normalized) {
      sessionStore.appendRealtime(sid, normalized);
    }
  }, [activeSessionId, sessionStore]);

  const clearMessages = useCallback(() => {
    if (!activeSessionId) return;
    sessionStore.clearRealtime(activeSessionId);
  }, [activeSessionId, sessionStore]);

  const rewindMessages = useCallback((count: number) => setViewHiddenCount(count), []);

  const scrollToBottom = useCallback(() => {
    const container = scrollContainerRef.current;
    if (!container) return;
    requestAnimationFrame(() => {
      if (scrollContainerRef.current) {
        scrollContainerRef.current.scrollTop = scrollContainerRef.current.scrollHeight;
      }
    });
  }, []);

  const scrollToBottomAndReset = useCallback(() => {
    scrollToBottom();
    if (allMessagesLoaded) {
      setVisibleMessageCount(INITIAL_VISIBLE_MESSAGES);
      setAllMessagesLoaded(false);
      allMessagesLoadedRef.current = false;
    }
  }, [allMessagesLoaded, scrollToBottom]);

  const isNearBottom = useCallback(() => {
    const container = scrollContainerRef.current;
    if (!container) return false;
    return checkNearBottom(container);
  }, []);

  const markUserInteracting = useCallback((kind: 'scroll' | 'pointer' = 'scroll') => {
    const container = scrollContainerRef.current;
    if (!isUserInteractingRef.current && container) {
      interactionStartHeightRef.current = container.scrollHeight;
    }
    interactionKindRef.current = kind;
    isUserInteractingRef.current = true;
    if (userInteractionTimerRef.current) clearTimeout(userInteractionTimerRef.current);
    userInteractionTimerRef.current = setTimeout(() => {
      isUserInteractingRef.current = false;
      userInteractionTimerRef.current = null;
      // Content that arrived mid-scroll was deliberately not followed; once the
      // wheel/touch settles, land back on the bottom unless the user scrolled
      // away from it in the meantime. Clicks keep their position.
      const current = scrollContainerRef.current;
      if (
        current
        && interactionKindRef.current === 'scroll'
        && shouldPinOnContentGrowth({
          previousHeight: interactionStartHeightRef.current,
          nextHeight: current.scrollHeight,
          isUserScrolledUp: isUserScrolledUpRef.current,
          isUserInteracting: false,
        })
      ) {
        current.scrollTop = current.scrollHeight;
        scrollPositionRef.current = { height: current.scrollHeight, top: current.scrollTop };
      }
    }, 300);
  }, []);

  const loadOlderMessages = useCallback(
    async (container: HTMLDivElement) => {
      if (!isActive) return false;
      if (!container || isLoadingMoreRef.current || isLoadingMoreMessages) return false;
      if (allMessagesLoadedRef.current) return false;

      // In-memory reveals first if store has more messages than currently rendered
      if (chatMessages.length > visibleMessageCount) {
        isLoadingMoreRef.current = true;
        pendingScrollRestoreRef.current = captureScrollRestoreState(container);
        setVisibleMessageCount((prev) => Math.min(prev + SESSION_MESSAGES_PAGE_SIZE, chatMessages.length));
        isLoadingMoreRef.current = false;
        return true;
      }

      if (!hasMoreMessages || !selectedSession || !selectedProject) return false;

      isLoadingMoreRef.current = true;
      setIsLoadingMoreMessages(true);
      setLoadOlderMessagesError(null);
      const scrollRestoreState = captureScrollRestoreState(container);
      pendingScrollRestoreRef.current = scrollRestoreState;
      // Pre-emptively bump visibleMessageCount so when sessionStore notifies,
      // the prepended messages are immediately part of visibleMessages in that very render!
      setVisibleMessageCount((prev) => prev + SESSION_MESSAGES_PAGE_SIZE);

      try {
        const result = await sessionStore.fetchMore(selectedSession.id, {
          limit: SESSION_MESSAGES_PAGE_SIZE,
          canRequest: () => (
            isActiveRef.current
            && activeSessionIdRef.current === selectedSession.id
          ),
        });
        const { slot, prependedCount } = result;
        setHasMoreMessages(slot.hasMore);
        setTotalMessages(slot.total);
        messagesOffsetRef.current = slot.offset;
        if (slot.tokenUsage) {
          setTokenBudget(slot.tokenUsage as Record<string, unknown>);
        }

        if (prependedCount === 0) {
          pendingScrollRestoreRef.current = null;
          setVisibleMessageCount((prev) => Math.max(INITIAL_VISIBLE_MESSAGES, prev - SESSION_MESSAGES_PAGE_SIZE));
          if (!slot.hasMore) {
            allMessagesLoadedRef.current = true;
            setAllMessagesLoaded(true);
            if (loadAllOverlayTimerRef.current) {
              clearTimeout(loadAllOverlayTimerRef.current);
              loadAllOverlayTimerRef.current = null;
            }
            setShowLoadAllOverlay(false);
          }
          return false;
        }

        if (!slot.hasMore) {
          allMessagesLoadedRef.current = true;
          setAllMessagesLoaded(true);
          if (loadAllOverlayTimerRef.current) {
            clearTimeout(loadAllOverlayTimerRef.current);
            loadAllOverlayTimerRef.current = null;
          }
          setShowLoadAllOverlay(false);
        }
        return true;
      } catch (err) {
        pendingScrollRestoreRef.current = null;
        setVisibleMessageCount((prev) => Math.max(INITIAL_VISIBLE_MESSAGES, prev - SESSION_MESSAGES_PAGE_SIZE));
        // Surface the failure as state instead of rethrowing: handleScroll
        // awaits this callback, so a throw becomes an unhandled rejection.
        setLoadOlderMessagesError(err instanceof Error ? err.message : String(err));
        return false;
      } finally {
        isLoadingMoreRef.current = false;
        setIsLoadingMoreMessages(false);
      }
    },
    [chatMessages.length, hasMoreMessages, isActive, isLoadingMoreMessages, selectedProject, selectedSession, sessionStore, visibleMessageCount],
  );

  // Retry after a failed older-page fetch; pairs with loadOlderMessagesError.
  const retryLoadOlderMessages = useCallback(() => {
    const container = scrollContainerRef.current;
    if (!container) return;
    setLoadOlderMessagesError(null);
    void loadOlderMessages(container);
  }, [loadOlderMessages]);

  const handleScroll = useCallback(async (event?: { type?: string }) => {
    // Scroll position is tracked even while this pane is inactive: split-view
    // background panes must keep isUserScrolledUpRef/scrollPositionRef current
    // so activation restores the reading position instead of snapping to bottom.
    const container = scrollContainerRef.current;
    if (!container) return;

    // Wheel/touch/click means the user is physically controlling the pane —
    // including expanding a tool card, whose growth must not yank the viewport.
    if (event?.type === 'pointerdown') {
      markUserInteracting('pointer');
      return;
    }
    if (event?.type === 'wheel' || event?.type === 'touchmove') {
      markUserInteracting('scroll');
    }

    const nearBottom = isNearBottom();

    // Immediately reflect scroll position state. No delayed timers that can cause
    // layout effects to snap back to bottom during user scrolling or pagination.
    if (nearBottom) {
      if (scrollAwayTimerRef.current) {
        clearTimeout(scrollAwayTimerRef.current);
        scrollAwayTimerRef.current = null;
      }
      isUserScrolledUpRef.current = false;
      setIsUserScrolledUp(false);
    } else {
      if (scrollAwayTimerRef.current) {
        clearTimeout(scrollAwayTimerRef.current);
        scrollAwayTimerRef.current = null;
      }
      isUserScrolledUpRef.current = true;
      setIsUserScrolledUp(true);
    }

    scrollPositionRef.current = {
      height: container.scrollHeight,
      top: container.scrollTop,
    };

    const scrolledNearTop = container.scrollTop < 100;

    // "Load all" prompt: appear (with fade-in) when the user reaches the top
    if (scrolledNearTop && hasMoreMessages && !allMessagesLoadedRef.current) {
      if (!wasNearTopRef.current) {
        wasNearTopRef.current = true;
        if (loadAllOverlayTimerRef.current) clearTimeout(loadAllOverlayTimerRef.current);

        setShowLoadAllOverlay(true);
        loadAllOverlayTimerRef.current = setTimeout(() => {
          setShowLoadAllOverlay(false);
          loadAllOverlayTimerRef.current = null;
        }, 2500);
      }
    } else if (!scrolledNearTop) {
      wasNearTopRef.current = false;
    }

    if (!allMessagesLoadedRef.current) {
      if (!scrolledNearTop) { topLoadLockRef.current = false; return; }
      if (topLoadLockRef.current) {
        if (container.scrollTop > 20) topLoadLockRef.current = false;
        return;
      }
      let didLoad = false;
      try {
        didLoad = await loadOlderMessages(container);
      } catch (err) {
        // Failures surface via loadOlderMessagesError; never let a scroll
        // handler produce an unhandled rejection.
        console.error('Error loading older messages:', err);
      }
      if (didLoad) topLoadLockRef.current = true;
    }
  }, [hasMoreMessages, isNearBottom, loadOlderMessages, markUserInteracting]);

  const wasChatActiveRef = useRef(isActive);
  const lastRenderedVisibleMessagesRef = useRef<ChatMessage[]>(visibleMessages);
  useLayoutEffect(() => {
    const becameActive = isActive && !wasChatActiveRef.current;
    wasChatActiveRef.current = isActive;
    if (!isActive || !scrollContainerRef.current) return;

    const container = scrollContainerRef.current;
    // The "loading older messages" spinner is inserted before the fetched page
    // arrives. Its ~44px height shift must not consume pendingScrollRestoreRef,
    // or nothing remains to anchor against once real messages are prepended.
    const messagesChanged = visibleMessages !== lastRenderedVisibleMessagesRef.current;
    lastRenderedVisibleMessagesRef.current = visibleMessages;

    if (pendingScrollRestoreRef.current) {
      if (messagesChanged) {
        const restored = restoreScrollPosition(container, pendingScrollRestoreRef.current);
        if (restored) {
          pendingScrollRestoreRef.current = null;
        }
      }
      scrollPositionRef.current = { height: container.scrollHeight, top: container.scrollTop };
      return;
    }

    if (becameActive) {
      container.scrollTop = isUserScrolledUpRef.current
        ? scrollPositionRef.current.top
        : container.scrollHeight;
      scrollPositionRef.current = { height: container.scrollHeight, top: container.scrollTop };
      return;
    }

    if (
      !isUserScrolledUpRef.current
      && !isUserInteractingRef.current
      && !isLoadingMoreRef.current
      && !isLoadingMoreMessages
      && !pendingScrollRestoreRef.current
      && !searchScrollActiveRef.current
    ) {
      container.scrollTop = container.scrollHeight;
    }

    scrollPositionRef.current = { height: container.scrollHeight, top: container.scrollTop };
  }, [visibleMessages, isActive, isUserScrolledUp, isLoadingMoreMessages]);

  /* ---------------------------------------------------------------- */
  /*  Anchor the chat viewport when the composer resizes              */
  /* ---------------------------------------------------------------- */

  const lastPaneClientHeightRef = useRef(0);
  const lastPaneClientWidthRef = useRef(0);

  useLayoutEffect(() => {
    const container = scrollContainerRef.current;
    if (!container || typeof ResizeObserver === 'undefined') {
      return undefined;
    }

    let rafId = 0;
    let scheduled = false;

    const applyResize = () => {
      scheduled = false;
      const c = scrollContainerRef.current;
      if (!c) return;

      const nextClientHeight = c.clientHeight;
      const nextClientWidth = c.clientWidth;
      const prevClientHeight = lastPaneClientHeightRef.current;
      const prevClientWidth = lastPaneClientWidthRef.current;

      if (prevClientHeight === 0 || prevClientWidth === 0) {
        lastPaneClientHeightRef.current = nextClientHeight;
        lastPaneClientWidthRef.current = nextClientWidth;
        return;
      }

      // Width changes (split layout adding/removing columns) rewrap markdown
      // and code, growing scrollHeight while clientHeight stays the same —
      // both dimensions must be compared or the resize is silently ignored.
      if (nextClientHeight === prevClientHeight && nextClientWidth === prevClientWidth) return;

      // If the user is following the conversation, keep the viewport locked
      // to the bottom as the composer grows/shrinks. Otherwise preserve their
      // intentional scroll position.
      if (!isUserScrolledUpRef.current && !isUserInteractingRef.current) {
        c.scrollTop = c.scrollHeight;
      }

      scrollPositionRef.current = { height: c.scrollHeight, top: c.scrollTop };
      lastPaneClientHeightRef.current = nextClientHeight;
      lastPaneClientWidthRef.current = nextClientWidth;
    };

    const handleResize = () => {
      if (scheduled) return;
      scheduled = true;
      rafId = requestAnimationFrame(applyResize);
    };

    const ro = new ResizeObserver(handleResize);
    ro.observe(container);
    lastPaneClientHeightRef.current = container.clientHeight;
    lastPaneClientWidthRef.current = container.clientWidth;

    return () => {
      ro.disconnect();
      if (rafId) cancelAnimationFrame(rafId);
    };
  }, []);

  /* ---------------------------------------------------------------- */
  /*  Re-pin when content grows without a re-render                    */
  /* ---------------------------------------------------------------- */

  // The layout effect above only fires when the message list itself changes.
  // Late growth — images decoding, async diff/highlight layout — happens after
  // that pass and would otherwise leave the viewport silently off the bottom
  // it was pinned to.
  useLayoutEffect(() => {
    const content = contentRef.current;
    if (!content || typeof ResizeObserver === 'undefined') return undefined;

    let lastHeight = content.scrollHeight;
    const observer = new ResizeObserver(() => {
      const container = scrollContainerRef.current;
      const nextHeight = content.scrollHeight;
      const previousHeight = lastHeight;
      lastHeight = nextHeight;
      if (!container) return;
      if (
        isLoadingMoreRef.current
        || pendingScrollRestoreRef.current
        || searchScrollActiveRef.current
      ) {
        return;
      }
      if (!shouldPinOnContentGrowth({
        previousHeight,
        nextHeight,
        isUserScrolledUp: isUserScrolledUpRef.current,
        isUserInteracting: isUserInteractingRef.current,
      })) {
        return;
      }
      container.scrollTop = container.scrollHeight;
      scrollPositionRef.current = { height: container.scrollHeight, top: container.scrollTop };
    });
    observer.observe(content);
    return () => observer.disconnect();
  }, []);

  // Reset scroll/pagination state on session change
  useEffect(() => {
    if (!searchScrollActiveRef.current) {
      setVisibleMessageCount(INITIAL_VISIBLE_MESSAGES);
    }
    topLoadLockRef.current = false;
    pendingScrollRestoreRef.current = null;
    wasNearTopRef.current = false;
    setIsUserScrolledUp(false);
    setLoadOlderMessagesError(null);
    isUserInteractingRef.current = false;
    if (userInteractionTimerRef.current) clearTimeout(userInteractionTimerRef.current);
    if (scrollAwayTimerRef.current) clearTimeout(scrollAwayTimerRef.current);
  }, [selectedProject?.projectId, selectedSession?.id]);

  // Initial and incremental bottom anchoring is now handled by the single
  // useLayoutEffect that runs whenever chatMessages changes.

  // Session replay/subscription remains active regardless of which main tab is
  // visible. Only persisted-history HTTP traffic is visibility-gated below.
  useEffect(() => {
    if (!selectedSession || !selectedProject || !ws) return;

    statusCheckSentAtRef.current.set(selectedSession.id, Date.now());
    sendMessage({
      type: 'chat.subscribe',
      sessions: [{
        sessionId: selectedSession.id,
        lastSeq: lastSeqRef.current.get(selectedSession.id) ?? 0,
      }],
    });
  }, [lastSeqRef, selectedProject, selectedSession, sendMessage, statusCheckSentAtRef, ws]);

  // Main session loading effect — store-based
  useEffect(() => {
    if (!selectedSession || !selectedProject) {
      // A freshly created session can be mid-run before the router has a
      // canonical selectedSession (the URL effect synthesizes one on the
      // next render). Keep the active view intact instead of wiping it.
      if (currentSessionId && processingSessionsRef.current?.has(currentSessionId)) {
        return;
      }

      resetStreamingState();
      setCurrentSessionId(null);
      messagesOffsetRef.current = 0;
      setHasMoreMessages(false);
      setTotalMessages(0);
      setTokenBudget(null);
      lastLoadedSessionKeyRef.current = null;
      return;
    }

    if (!isActive) {
      setIsLoadingSessionMessages(false);
      return;
    }

    const selectedSessionId = selectedSession.id;
    const sessionKey = `${selectedSessionId}:${selectedProject.projectId}`;

    const existingSlot = sessionStore.getSessionSlot(selectedSessionId);
    const sessionChanged = currentSessionId !== null && currentSessionId !== selectedSessionId;

    // If the session is already hydrated in the store, reuse it instead of
    // fetching the whole transcript again. Restore the local pagination/scroll
    // state so switching between sessions does not throw away loaded history.
    if (existingSlot?.fetchedAt) {
      if (sessionChanged) {
        resetStreamingState();
      }

      setCurrentSessionId(selectedSessionId);
      lastLoadedSessionKeyRef.current = sessionKey;
      setHasMoreMessages(existingSlot.hasMore);
      setTotalMessages(existingSlot.total);
      messagesOffsetRef.current = existingSlot.offset;

      if (!existingSlot.hasMore) {
        setAllMessagesLoaded(true);
        allMessagesLoadedRef.current = true;
        setVisibleMessageCount(Infinity);
      } else {
        setAllMessagesLoaded(false);
        allMessagesLoadedRef.current = false;
        setVisibleMessageCount(existingSlot.merged.length || INITIAL_VISIBLE_MESSAGES);
      }

      setIsLoadingAllMessages(false);
      setLoadAllJustFinished(false);
      setShowLoadAllOverlay(false);
      setViewHiddenCount(0);
      wasNearTopRef.current = false;
      if (loadAllOverlayTimerRef.current) clearTimeout(loadAllOverlayTimerRef.current);
      if (loadAllFinishedTimerRef.current) clearTimeout(loadAllFinishedTimerRef.current);

      if (existingSlot.tokenUsage) {
        setTokenBudget(existingSlot.tokenUsage as Record<string, unknown>);
      }

      if (sessionStore.isStale(selectedSessionId)) {
        void requestLatestMessages(selectedSessionId);
      }
      return;
    }

    if (sessionChanged) {
      resetStreamingState();
    }

    // Reset pagination/scroll state
    messagesOffsetRef.current = 0;
    setHasMoreMessages(false);
    setTotalMessages(0);
    setVisibleMessageCount(INITIAL_VISIBLE_MESSAGES);
    setAllMessagesLoaded(false);
    allMessagesLoadedRef.current = false;
    setIsLoadingAllMessages(false);
    setLoadAllJustFinished(false);
    setShowLoadAllOverlay(false);
    setViewHiddenCount(0);
    wasNearTopRef.current = false;
    if (loadAllOverlayTimerRef.current) clearTimeout(loadAllOverlayTimerRef.current);
    if (loadAllFinishedTimerRef.current) clearTimeout(loadAllFinishedTimerRef.current);

    if (sessionChanged) {
      setTokenBudget(null);
    }

    setCurrentSessionId(selectedSessionId);

    lastLoadedSessionKeyRef.current = sessionKey;

    // Fetch from server → store updates → chatMessages re-derives automatically
    setIsLoadingSessionMessages(true);
    sessionStore.fetchFromServer(selectedSessionId, {
      limit: SESSION_MESSAGES_PAGE_SIZE,
      offset: 0,
      canRequest: () => (
        isActiveRef.current
        && activeSessionIdRef.current === selectedSessionId
      ),
    }).then(slot => {
      if (slot) {
        setHasMoreMessages(slot.hasMore);
        setTotalMessages(slot.total);
        messagesOffsetRef.current = slot.offset;
        if (slot.tokenUsage) {
          setTokenBudget(slot.tokenUsage as Record<string, unknown>);
        }
      }
      setIsLoadingSessionMessages(false);
    }).catch(() => {
      setIsLoadingSessionMessages(false);
    });
  }, [
    isActive,
    resetStreamingState,
    requestLatestMessages,
    selectedProject,
    selectedSession?.id,
    sessionStore,
  ]);

  // Hidden refresh signals are coalesced. An initial page load supersedes a
  // pending latest refresh for an unhydrated/loading slot; otherwise activation
  // flushes exactly one request for the selected session.
  useEffect(() => {
    if (!isActive || !activeSessionId) return;

    const slot = sessionStore.getSessionSlot(activeSessionId);
    if (!slot?.fetchedAt || slot.status === 'loading') {
      refreshCoordinatorRef.current?.discardPending(activeSessionId);
      return;
    }

    void refreshCoordinatorRef.current?.flushPending(activeSessionId);
  }, [activeSessionId, isActive, sessionStore]);

  // External message update (e.g. WebSocket reconnect, background refresh)
  useEffect(() => {
    if (!externalMessageUpdate || !selectedSession || !selectedProject) return;

    const reloadExternalMessages = async () => {
      try {
        // Skip store refresh during active streaming; bottom anchoring after
        // the store updates is handled by the chatMessages layout effect.
        if (!isProcessing) {
          await requestLatestMessages(selectedSession.id);
        }
      } catch (error) {
        console.error('Error reloading messages from external update:', error);
      }
    };

    reloadExternalMessages();
  }, [
    externalMessageUpdate,
    requestLatestMessages,
    selectedProject,
    selectedSession,
    isProcessing,
  ]);

  // Search navigation target
  useEffect(() => {
    const session = selectedSession as Record<string, unknown> | null;
    const targetSnippet = session?.__searchTargetSnippet;
    const targetTimestamp = session?.__searchTargetTimestamp;
    if (typeof targetSnippet === 'string' && targetSnippet) {
      searchScrollActiveRef.current = true;
      setSearchTarget({
        snippet: targetSnippet,
        timestamp: typeof targetTimestamp === 'string' ? targetTimestamp : undefined,
      });
    }
  }, [selectedSession]);

  // Scroll to search target
  useEffect(() => {
    if (!isActive || !searchTarget || chatMessages.length === 0 || isLoadingSessionMessages) return;

    const target = searchTarget;
    setSearchTarget(null);

    const scrollToTarget = async () => {
      if (!allMessagesLoadedRef.current && selectedSession && selectedProject) {
          try {
            // Load all messages into the store for search navigation
            const slot = await sessionStore.fetchFromServer(selectedSession.id, {
              limit: null,
              offset: 0,
              canRequest: () => (
                isActiveRef.current
                && activeSessionIdRef.current === selectedSession.id
              ),
            });
            if (slot) {
              setHasMoreMessages(false);
              setTotalMessages(slot.total);
              messagesOffsetRef.current = slot.offset;
              setVisibleMessageCount(Infinity);
              setAllMessagesLoaded(true);
              allMessagesLoadedRef.current = true;
              await new Promise(resolve => setTimeout(resolve, 300));
            } else if (!isActiveRef.current) {
              setSearchTarget(target);
              return;
            }
          } catch {
            // Fall through and scroll in current messages
          }
      }
      setVisibleMessageCount(Infinity);

      const findAndScroll = (retriesLeft: number) => {
        const container = scrollContainerRef.current;
        if (!container) return;

        let targetElement: Element | null = null;

        if (target.snippet) {
          const cleanSnippet = target.snippet.replace(/^\.{3}/, '').replace(/\.{3}$/, '').trim();
          const searchPhrase = cleanSnippet.slice(0, 80).toLowerCase().trim();
          if (searchPhrase.length >= 10) {
            const messageElements = container.querySelectorAll('.chat-message');
            for (const el of messageElements) {
              const text = (el.textContent || '').toLowerCase();
              if (text.includes(searchPhrase)) { targetElement = el; break; }
            }
          }
        }

        if (!targetElement && target.timestamp) {
          const targetDate = new Date(target.timestamp).getTime();
          const messageElements = container.querySelectorAll('[data-message-timestamp]');
          let closestDiff = Infinity;
          for (const el of messageElements) {
            const ts = el.getAttribute('data-message-timestamp');
            if (!ts) continue;
            const diff = Math.abs(new Date(ts).getTime() - targetDate);
            if (diff < closestDiff) { closestDiff = diff; targetElement = el; }
          }
        }

        if (targetElement) {
          targetElement.scrollIntoView({ block: 'center', behavior: 'smooth' });
          targetElement.classList.add('search-highlight-flash');
          setTimeout(() => targetElement?.classList.remove('search-highlight-flash'), 4000);
          searchScrollActiveRef.current = false;
        } else if (retriesLeft > 0) {
          setTimeout(() => findAndScroll(retriesLeft - 1), 200);
        } else {
          searchScrollActiveRef.current = false;
        }
      };

      setTimeout(() => findAndScroll(15), 150);
    };

    scrollToTarget();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [chatMessages.length, isActive, isLoadingSessionMessages, searchTarget]);

  // Initial token usage fetch for providers with file-backed usage data.
  useEffect(() => {
    if (!selectedSession?.id) {
      setTokenBudget(null);
      return;
    }
    const requestSessionId = selectedSession.id;
    const liveVersionAtRequest = liveBudgetVersionRef.current;
    const fetchInitialTokenUsage = async () => {
      try {
        // The provider module resolves storage and provider details from the session id.
        const url = `/api/providers/sessions/${encodeURIComponent(requestSessionId)}/token-usage`;
        const response = await authenticatedFetch(url);
        // Drop the result when the pane moved to another session or live frames
        // arrived while the request was in flight — both are more current than
        // this snapshot, and the live path must keep the indicator populated.
        if (activeSessionIdRef.current !== requestSessionId) return;
        if (liveBudgetVersionRef.current !== liveVersionAtRequest) return;
        if (response.ok) {
          const payload = await response.json();
          setTokenBudget(payload.data ?? null);
        } else {
          setTokenBudget(null);
        }
      } catch (error) {
        console.error('Failed to fetch initial token usage:', error);
      }
    };
    fetchInitialTokenUsage();
  }, [selectedSession?.id]);

  // Bottom anchoring for streaming, new messages, and composer resize is
  // handled by the single useLayoutEffect on chatMessages and the
  // ResizeObserver below. No additional setInterval/setTimeout loops are needed.

  useEffect(() => {
    const container = scrollContainerRef.current;
    if (!container) return;
    container.addEventListener('scroll', handleScroll);
    return () => container.removeEventListener('scroll', handleScroll);
  }, [handleScroll]);

  // "Load all" overlay visibility is driven by scroll-to-top in handleScroll;
  // timers are cleared on session change via the reset effect above.

  const loadAllMessages = useCallback(async () => {
    // No `isActive` gate: the action is bound to this tile's session, and
    // `canRequest`/the post-fetch check below still abort if the session itself
    // is swapped out — pane focus alone must not block or cancel the load.
    if (!selectedSession || !selectedProject) return;
    if (isLoadingAllMessages) return;
    const requestSessionId = selectedSession.id;
    allMessagesLoadedRef.current = true;
    isLoadingMoreRef.current = true;
    setIsLoadingAllMessages(true);
    setShowLoadAllOverlay(true);
    if (loadAllOverlayTimerRef.current) {
      clearTimeout(loadAllOverlayTimerRef.current);
      loadAllOverlayTimerRef.current = null;
    }

    const container = scrollContainerRef.current;
    const scrollRestoreState = container ? captureScrollRestoreState(container) : null;
    if (scrollRestoreState) {
      pendingScrollRestoreRef.current = scrollRestoreState;
    }

    try {
      const slot = await sessionStore.fetchFromServer(requestSessionId, {
        limit: null,
        offset: 0,
        // "Load all" is an explicit user action on this tile: it only aborts
        // when the tile's session is replaced, not when the pane merely loses
        // focus — clicking a neighboring tile must not silently kill the fetch.
        canRequest: () => activeSessionIdRef.current === requestSessionId,
      });

      if (activeSessionIdRef.current !== requestSessionId) {
        pendingScrollRestoreRef.current = null;
        return;
      }

      if (slot) {
        setHasMoreMessages(false);
        setTotalMessages(slot.total);
        messagesOffsetRef.current = slot.offset;
        setVisibleMessageCount(Infinity);
        setAllMessagesLoaded(true);

        setLoadAllJustFinished(true);
        if (loadAllFinishedTimerRef.current) clearTimeout(loadAllFinishedTimerRef.current);
        loadAllFinishedTimerRef.current = setTimeout(() => {
          setLoadAllJustFinished(false);
          setShowLoadAllOverlay(false);
          loadAllFinishedTimerRef.current = null;
        }, 2500);
      } else {
        pendingScrollRestoreRef.current = null;
        allMessagesLoadedRef.current = false;
        setShowLoadAllOverlay(false);
      }
    } catch (error) {
      pendingScrollRestoreRef.current = null;
      console.error('Error loading all messages:', error);
      allMessagesLoadedRef.current = false;
      setShowLoadAllOverlay(false);
    } finally {
      isLoadingMoreRef.current = false;
      setIsLoadingAllMessages(false);
    }
  }, [selectedSession, selectedProject, isLoadingAllMessages, sessionStore]);

  const loadEarlierMessages = useCallback(() => {
    const container = scrollContainerRef.current;
    if (container) {
      pendingScrollRestoreRef.current = captureScrollRestoreState(container);
    }
    setVisibleMessageCount((prev) => prev + SESSION_MESSAGES_PAGE_SIZE);
  }, []);

  return {
    chatMessages,
    addMessage,
    clearMessages,
    rewindMessages,
    sessionActivity,
    isProcessing,
    canAbortSession,
    currentSessionId,
    setCurrentSessionId,
    isLoadingSessionMessages,
    isLoadingMoreMessages,
    loadOlderMessagesError,
    retryLoadOlderMessages,
    hasMoreMessages,
    totalMessages,
    isUserScrolledUp,
    setIsUserScrolledUp,
    tokenBudget,
    setTokenBudget: setLiveTokenBudget,
    visibleMessageCount,
    visibleMessages,
    loadEarlierMessages,
    loadAllMessages,
    allMessagesLoaded,
    isLoadingAllMessages,
    loadAllJustFinished,
    showLoadAllOverlay,
    createDiff,
    scrollContainerRef,
    contentRef,
    scrollToBottom,
    scrollToBottomAndReset,
    isNearBottom,
    handleScroll,
    requestLatestMessages,
  };
}

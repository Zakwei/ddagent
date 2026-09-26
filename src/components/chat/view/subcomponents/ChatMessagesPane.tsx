import { useTranslation } from 'react-i18next';
import { ArrowDown, ChevronDown, ChevronUp, Filter, Search, X } from 'lucide-react';
import { memo, useCallback, useEffect, useLayoutEffect, useMemo, useRef, useState } from 'react';
import type { Dispatch, RefObject, SetStateAction } from 'react';

import type { ChatMessage } from '../../types/types';
import type {
  Project,
  ProjectSession,
  LLMProvider,
  ProviderModelActions,
  ProviderModelsDefinition,
} from '../../../../types/app';
import { getIntrinsicMessageKey } from '../../utils/messageKeys';
import { groupConsecutiveTools, isToolGroupItem } from '../../utils/toolGrouping';
import { Input } from '../../../../shared/view/ui';

import MessageComponent from './MessageComponent';
import ProviderSelectionEmptyState from './ProviderSelectionEmptyState';
import ToolGroupContainer from './ToolGroupContainer';
import LoadAllMessagesOverlay from './LoadAllMessagesOverlay';
import ChatExportMenu from './ChatExportMenu';
import ReviewFilesPanel from './ReviewFilesPanel';

function getSearchableText(message: ChatMessage): string {
  return [message.content, message.displayText, message.toolName]
    .filter((value): value is string => typeof value === 'string' && value.length > 0)
    .join(' ');
}

function messageMatches(message: ChatMessage, query: string): boolean {
  if (!query) return true;
  return getSearchableText(message).toLowerCase().includes(query.toLowerCase());
}

interface ChatMessagesPaneProps {
  scrollContainerRef: RefObject<HTMLDivElement>;
  /** The message wrapper observed for late content growth (images, async layout). */
  contentRef?: RefObject<HTMLDivElement>;
  onWheel: () => void;
  onTouchMove: () => void;
  /** Marks a physical interaction (e.g. expanding a tool card) before growth lands. */
  onPointerDown?: () => void;
  /** False for split-view background panes; gates document-level shortcuts. */
  isActive?: boolean;
  isLoadingSessionMessages: boolean;
  /** True while the viewed session has an active provider run in flight. */
  isProcessing?: boolean;
  /** True while ChatComposer's floating activity/stop tab is rendered above the input. */
  hasActivityIndicator?: boolean;
  chatMessages: ChatMessage[];
  selectedSession: ProjectSession | null;
  currentSessionId: string | null;
  /** Hosting workspace pane — scopes the draft's model pick to this tile. */
  boundPaneId?: string | null;
  provider: LLMProvider;
  setProvider: (provider: LLMProvider) => void;
  textareaRef: RefObject<HTMLTextAreaElement>;
  claudeModel: string;
  setClaudeModel: (model: string) => void;
  cursorModel: string;
  setCursorModel: (model: string) => void;
  codexModel: string;
  setCodexModel: (model: string) => void;
  opencodeModel: string;
  setOpenCodeModel: (model: string) => void;
  devinModel: string;
  setDevinModel: (model: string) => void;
  providerModelCatalog: Partial<Record<LLMProvider, ProviderModelsDefinition>>;
  providerModelActions: ProviderModelActions;
  providerModelsLoading: boolean;
  onRefreshProviderModels?: (force?: boolean) => Promise<void> | void;
  tasksEnabled: boolean;
  isTaskMasterInstalled: boolean | null;
  onShowAllTasks?: (() => void) | null;
  setInput: Dispatch<SetStateAction<string>>;
  isLoadingMoreMessages: boolean;
  /** Set when an older-page fetch failed; rendered with a retry action. */
  loadOlderMessagesError?: string | null;
  onRetryLoadOlderMessages?: () => void;
  hasMoreMessages: boolean;
  totalMessages: number;
  sessionMessagesCount: number;
  visibleMessageCount: number;
  visibleMessages: ChatMessage[];
  loadEarlierMessages: () => void;
  loadAllMessages: () => void;
  allMessagesLoaded: boolean;
  isLoadingAllMessages: boolean;
  loadAllJustFinished: boolean;
  showLoadAllOverlay: boolean;
  createDiff: any;
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  onShowSettings?: () => void;
  onGrantToolPermission: (suggestion: { entry: string; toolName: string }) => { success: boolean };
  showRawParameters?: boolean;
  showThinking?: boolean;
  selectedProject: Project;
  isUserScrolledUp?: boolean;
  onScrollToBottom?: () => void;
  /** All workspaces — lets the draft empty state rebind the pane's workspace. */
  projects?: Project[];
  /** Rebinds the draft pane to another workspace. */
  onSelectWorkspace?: (project: Project) => void;
  /** Opens a delegated child session from an orchestrator card. */
  onNavigateToSession?: (sessionId: string) => void;
}

function ChatMessagesPane({
  scrollContainerRef,
  contentRef,
  onWheel,
  onTouchMove,
  onPointerDown,
  isActive = true,
  isLoadingSessionMessages,
  isProcessing = false,
  hasActivityIndicator = false,
  chatMessages,
  selectedSession,
  currentSessionId,
  boundPaneId,
  provider,
  setProvider,
  textareaRef,
  claudeModel,
  setClaudeModel,
  cursorModel,
  setCursorModel,
  codexModel,
  setCodexModel,
  opencodeModel,
  setOpenCodeModel,
  devinModel,
  setDevinModel,
  providerModelCatalog,
  providerModelActions,
  providerModelsLoading,
  onRefreshProviderModels,
  tasksEnabled,
  isTaskMasterInstalled,
  onShowAllTasks,
  setInput,
  isLoadingMoreMessages,
  loadOlderMessagesError = null,
  onRetryLoadOlderMessages,
  hasMoreMessages,
  totalMessages,
  sessionMessagesCount,
  visibleMessageCount,
  visibleMessages,
  loadEarlierMessages,
  loadAllMessages,
  allMessagesLoaded,
  isLoadingAllMessages,
  loadAllJustFinished,
  showLoadAllOverlay,
  createDiff,
  onFileOpen,
  onShowSettings,
  onGrantToolPermission,
  showRawParameters,
  showThinking,
  selectedProject,
  isUserScrolledUp = false,
  onScrollToBottom,
  projects,
  onSelectWorkspace,
  onNavigateToSession,
}: ChatMessagesPaneProps) {
  const { t } = useTranslation('chat');
  const [reviewOpen, setReviewOpen] = useState(false);
  const savedScrollTopRef = useRef<number | null>(null);
  const groupedVisibleMessages = useMemo(
    () => groupConsecutiveTools(visibleMessages, Boolean(showThinking)),
    [visibleMessages, showThinking],
  );

  const handleReviewToggle = useCallback(() => {
    setReviewOpen((open) => {
      if (!open) {
        savedScrollTopRef.current = scrollContainerRef.current?.scrollTop ?? 0;
      }
      return !open;
    });
  }, [scrollContainerRef]);

  // Review swaps the message list for a file list, shrinking the scrollable
  // content — restoring scrollTop after close lands the user where they were.
  useLayoutEffect(() => {
    if (reviewOpen) return;
    const saved = savedScrollTopRef.current;
    savedScrollTopRef.current = null;
    const container = scrollContainerRef.current;
    if (saved !== null && container) {
      container.scrollTop = saved;
    }
  }, [reviewOpen, scrollContainerRef]);

  // The file list belongs to one session's transcript — drop it on rebind, and
  // clear the saved offset so the layout effect can't restore a stale position
  // over the next session's messages.
  useEffect(() => {
    savedScrollTopRef.current = null;
    setReviewOpen(false);
  }, [currentSessionId]);

  // If the entire visible transcript is one (or more) tool groups and there are
  // more messages to load, automatically load the rest so the collapsed row
  // reflects the whole subagent run. Cap the auto-load to avoid hammering huge
  // sessions; larger histories still get an explicit "Load all" button.
  const autoLoadAllTriggeredRef = useRef(false);
  const AUTO_LOAD_ALL_THRESHOLD = 1000;
  useEffect(() => {
    if (autoLoadAllTriggeredRef.current) return;
    if (isUserScrolledUp) return;
    if (
      groupedVisibleMessages.length > 0
      && groupedVisibleMessages.every(isToolGroupItem)
      && hasMoreMessages
      && !allMessagesLoaded
      && !isLoadingAllMessages
      && !isLoadingMoreMessages
      && totalMessages <= AUTO_LOAD_ALL_THRESHOLD
    ) {
      autoLoadAllTriggeredRef.current = true;
      loadAllMessages();
    }
  }, [
    isUserScrolledUp,
    groupedVisibleMessages,
    hasMoreMessages,
    allMessagesLoaded,
    isLoadingAllMessages,
    isLoadingMoreMessages,
    totalMessages,
    loadAllMessages,
  ]);

  // Stable, deterministic keys for the messages rendered this pass.
  //
  // The converter now reuses the same ChatMessage object for unchanged rows, and
  // keys are derived from stable intrinsic fields (id / rowid / sequence) with a
  // per-render occurrence disambiguator. We keep the key map in a ref and expose
  // a stable `getMessageKey` callback so memoized children (ToolGroupContainer)
  // do not re-render simply because the map object changed.
  const messageKeyMapRef = useRef(new Map<ChatMessage, string>());

  const getMessageKey = useCallback(
    (message: ChatMessage) =>
      messageKeyMapRef.current.get(message) ?? getIntrinsicMessageKey(message) ?? 'message-generated',
    [],
  );

  // Rebuild the key map each render so the same message object gets the same key.
  const keyOccurrences = new Map<string, number>();
  messageKeyMapRef.current = new Map<ChatMessage, string>();
  const assignKey = (message: ChatMessage) => {
    const intrinsicKey = getIntrinsicMessageKey(message) ?? 'message-generated';
    const seen = keyOccurrences.get(intrinsicKey) ?? 0;
    keyOccurrences.set(intrinsicKey, seen + 1);
    messageKeyMapRef.current.set(
      message,
      seen === 0 ? intrinsicKey : `${intrinsicKey}__${seen}`,
    );
  };
  for (const item of groupedVisibleMessages) {
    if (isToolGroupItem(item)) {
      item.messages.forEach(assignKey);
    } else {
      assignKey(item);
    }
  }

  const [hasNewMessage, setHasNewMessage] = useState(false);
  const [newMessagesCount, setNewMessagesCount] = useState(0);
  const prevChatMessagesLengthRef = useRef(chatMessages.length);
  const prevSessionIdRef = useRef(currentSessionId);

  // When not scrolled up, reset new messages count and flag
  useEffect(() => {
    if (!isUserScrolledUp) {
      setNewMessagesCount(0);
      setHasNewMessage(false);
    }
  }, [isUserScrolledUp]);

  // Reset when switching sessions
  useEffect(() => {
    autoLoadAllTriggeredRef.current = false;
    setNewMessagesCount(0);
    setHasNewMessage(false);
  }, [currentSessionId]);

  // Track whether new messages arrived while scrolled up
  useEffect(() => {
    if (prevSessionIdRef.current !== currentSessionId) {
      prevSessionIdRef.current = currentSessionId;
      prevChatMessagesLengthRef.current = chatMessages.length;
      return;
    }

    if (chatMessages.length > prevChatMessagesLengthRef.current) {
      const added = chatMessages.length - prevChatMessagesLengthRef.current;
      if (isUserScrolledUp && !isLoadingMoreMessages && !isLoadingAllMessages) {
        setNewMessagesCount((prev) => prev + added);
        setHasNewMessage(true);
      }
    }
    prevChatMessagesLengthRef.current = chatMessages.length;
  }, [chatMessages.length, currentSessionId, isUserScrolledUp, isLoadingMoreMessages, isLoadingAllMessages]);

  const showScrollToBottom = isUserScrolledUp && (isProcessing || newMessagesCount > 0 || hasNewMessage);

  const handleScrollToBottom = useCallback(() => {
    setHasNewMessage(false);
    setNewMessagesCount(0);
    onScrollToBottom?.();
  }, [onScrollToBottom]);

  // Chat history search state
  const [searchQuery, setSearchQuery] = useState('');
  const [activeMatchIndex, setActiveMatchIndex] = useState(0);
  const searchInputRef = useRef<HTMLInputElement>(null);

  const trimmedQuery = searchQuery.trim();
  const isSearchActive = trimmedQuery.length > 0;

  const filteredMessages = useMemo(
    () => (isSearchActive ? visibleMessages.filter((m) => messageMatches(m, trimmedQuery)) : []),
    [isSearchActive, visibleMessages, trimmedQuery],
  );

  const matchCount = filteredMessages.length;

  useEffect(() => {
    if (matchCount > 0 && activeMatchIndex >= matchCount) {
      setActiveMatchIndex(Math.max(0, matchCount - 1));
    }
  }, [matchCount, activeMatchIndex]);

  useEffect(() => {
    if (!isSearchActive || matchCount === 0) return;
    const element = scrollContainerRef.current?.querySelector(
      `[data-chat-search-index="${activeMatchIndex}"]`,
    );
    if (element instanceof HTMLElement) {
      element.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }, [isSearchActive, matchCount, activeMatchIndex]);

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      // Every mounted pane registers this document-level listener; only the
      // active tile may claim the shortcut or the last-mounted pane hijacks it.
      if (!isActive) return;
      if ((event.ctrlKey || event.metaKey) && event.shiftKey && event.key.toLowerCase() === 'f') {
        event.preventDefault();
        searchInputRef.current?.focus();
      }
    };
    document.addEventListener('keydown', handleKeyDown, { capture: true });
    return () => document.removeEventListener('keydown', handleKeyDown, { capture: true });
  }, [isActive]);

  const clearSearch = useCallback(() => {
    setSearchQuery('');
    setActiveMatchIndex(0);
  }, []);

  return (
    <div
      ref={scrollContainerRef}
      onWheel={onWheel}
      onTouchMove={onTouchMove}
      onPointerDown={onPointerDown}
      style={{ overflowAnchor: 'none' }}
      className={`chat-messages-pane relative min-h-0 flex-1 overflow-y-auto overflow-x-hidden pt-3 sm:pt-4 ${
        hasActivityIndicator ? 'pb-10 sm:pb-14' : 'pb-3 sm:pb-4'
      }`}
    >
      {chatMessages.length > 0 && (
        <div className="pointer-events-none mb-2 flex justify-end gap-2 sm:sticky sm:right-4 sm:top-3 sm:z-10 sm:px-4">
          <div className="pointer-events-auto">
            <ChatExportMenu
              messages={chatMessages}
              sessionTitle={selectedSession?.title || selectedSession?.summary || selectedSession?.name}
            />
          </div>
          <div className="pointer-events-auto flex items-center gap-1.5 rounded-lg border border-border/60 bg-card/95 px-2 py-1.5 shadow-sm backdrop-blur-sm">
            <button
              type="button"
              onClick={handleReviewToggle}
              aria-pressed={reviewOpen}
              title={reviewOpen ? 'Back to chat' : 'Review changed files'}
              className={`flex items-center gap-1 rounded px-1.5 py-0.5 text-xs transition-colors ${
                reviewOpen
                  ? 'bg-primary/10 text-primary'
                  : 'text-muted-foreground hover:text-foreground'
              }`}
            >
              <Filter className="h-3.5 w-3.5" aria-hidden />
              Review
            </button>
            <Search className="h-3.5 w-3.5 text-muted-foreground" aria-hidden />
            <Input
              ref={searchInputRef}
              type="text"
              value={searchQuery}
              onChange={(event) => {
                setSearchQuery(event.target.value);
                setActiveMatchIndex(0);
              }}
              onKeyDown={(event) => {
                if (event.key === 'Escape') {
                  event.preventDefault();
                  clearSearch();
                  searchInputRef.current?.blur();
                }
              }}
              placeholder="Search"
              className="h-6 w-28 border-0 bg-transparent p-0 text-xs shadow-none focus-visible:ring-0 focus-visible:ring-offset-0 sm:w-40"
            />
            {isSearchActive && (
              <span className="whitespace-nowrap text-xs text-muted-foreground">
                {matchCount > 0 ? `${activeMatchIndex + 1} of ${matchCount}` : '0 of 0'}
              </span>
            )}
            {isSearchActive && (
              <div className="flex items-center">
                <button
                  type="button"
                  onClick={() => setActiveMatchIndex((i) => (matchCount > 0 ? (i - 1 + matchCount) % matchCount : 0))}
                  disabled={matchCount === 0}
                  className="rounded p-0.5 text-muted-foreground hover:text-foreground disabled:opacity-40"
                  aria-label="Previous match"
                >
                  <ChevronUp className="h-3.5 w-3.5" />
                </button>
                <button
                  type="button"
                  onClick={() => setActiveMatchIndex((i) => (matchCount > 0 ? (i + 1) % matchCount : 0))}
                  disabled={matchCount === 0}
                  className="rounded p-0.5 text-muted-foreground hover:text-foreground disabled:opacity-40"
                  aria-label="Next match"
                >
                  <ChevronDown className="h-3.5 w-3.5" />
                </button>
              </div>
            )}
            {isSearchActive && (
              <button
                type="button"
                onClick={clearSearch}
                className="rounded p-0.5 text-muted-foreground hover:text-foreground"
                aria-label="Clear search"
              >
                <X className="h-3.5 w-3.5" />
              </button>
            )}
          </div>
        </div>
      )}
      <div ref={contentRef} className="mx-auto w-full max-w-[54.25rem] space-y-3 px-4 pr-10 sm:space-y-4 sm:pr-4">
      {reviewOpen ? (
        <ReviewFilesPanel
          sessionId={currentSessionId}
          onFileOpen={onFileOpen}
          onClose={() => setReviewOpen(false)}
        />
      ) : (isLoadingSessionMessages || isProcessing) && chatMessages.length === 0 ? (
        <div className="mt-8 text-center text-gray-500 dark:text-gray-400">
          <div className="flex items-center justify-center space-x-2">
            <div className="h-4 w-4 animate-spin rounded-full border-b-2 border-gray-400" />
            <p>{t('session.loading.sessionMessages')}</p>
          </div>
        </div>
      ) : chatMessages.length === 0 ? (
        <ProviderSelectionEmptyState
          selectedSession={selectedSession}
          currentSessionId={currentSessionId}
          boundPaneId={boundPaneId}
          provider={provider}
          setProvider={setProvider}
          textareaRef={textareaRef}
          claudeModel={claudeModel}
          setClaudeModel={setClaudeModel}
          cursorModel={cursorModel}
          setCursorModel={setCursorModel}
          codexModel={codexModel}
          setCodexModel={setCodexModel}
          opencodeModel={opencodeModel}
          setOpenCodeModel={setOpenCodeModel}
          devinModel={devinModel}
          setDevinModel={setDevinModel}
          providerModelCatalog={providerModelCatalog}
          providerModelActions={providerModelActions}
          providerModelsLoading={providerModelsLoading}
          onRefreshProviderModels={onRefreshProviderModels}
          tasksEnabled={tasksEnabled}
          isTaskMasterInstalled={isTaskMasterInstalled}
          onShowAllTasks={onShowAllTasks}
          setInput={setInput}
          selectedProject={selectedProject}
          projects={projects}
          onSelectWorkspace={onSelectWorkspace}
        />
      ) : (
        <>
          {/* Loading indicator for older messages (hide when load-all is active) */}
          {!isSearchActive && isLoadingMoreMessages && !isLoadingAllMessages && !allMessagesLoaded && (
            <div className="py-3 text-center text-gray-500 dark:text-gray-400">
              <div className="flex items-center justify-center space-x-2">
                <div className="h-4 w-4 animate-spin rounded-full border-b-2 border-gray-400" />
                <p className="text-sm">{t('session.loading.olderMessages')}</p>
              </div>
            </div>
          )}

          {/* Older-page fetch failure with explicit retry (scroll-to-top also retries) */}
          {!isSearchActive && loadOlderMessagesError && !isLoadingMoreMessages && (
            <div className="border-b border-gray-200 py-2 text-center text-sm text-red-500 dark:border-gray-700 dark:text-red-400">
              {t('session.messages.loadOlderFailed', { defaultValue: 'Failed to load older messages.' })}
              <button
                type="button"
                className="ml-1 text-blue-600 underline hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300"
                onClick={onRetryLoadOlderMessages}
              >
                {t('session.messages.retry', { defaultValue: 'Retry' })}
              </button>
            </div>
          )}

          {/* Indicator showing there are more messages to load (hide when all loaded) */}
          {!isSearchActive && hasMoreMessages && !isLoadingMoreMessages && !allMessagesLoaded && !loadOlderMessagesError && (
            <div className="border-b border-gray-200 py-2 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-400">
              {totalMessages > 0 && (
                <span>
                  {t('session.messages.showingOf', { shown: sessionMessagesCount, total: totalMessages })}{' '}
                  <span className="text-xs">{t('session.messages.scrollToLoad')}</span>
                </span>
              )}
            </div>
          )}

          {!isSearchActive && (
            <LoadAllMessagesOverlay
              showLoadAllOverlay={showLoadAllOverlay}
              isLoadingAllMessages={isLoadingAllMessages}
              loadAllJustFinished={loadAllJustFinished}
              totalMessages={totalMessages}
              onLoadAllMessages={loadAllMessages}
            />
          )}

          {/* Legacy message count indicator (for non-paginated view) */}
          {!isSearchActive && !hasMoreMessages && chatMessages.length > visibleMessageCount && (
            <div className="border-b border-gray-200 py-2 text-center text-sm text-gray-500 dark:border-gray-700 dark:text-gray-400">
              {t('session.messages.showingLast', { count: visibleMessageCount, total: chatMessages.length })} |
              <button className="ml-1 text-blue-600 underline hover:text-blue-700" onClick={loadEarlierMessages}>
                {t('session.messages.loadEarlier')}
              </button>
              {' | '}
              <button
                className="text-blue-600 underline hover:text-blue-700 dark:text-blue-400 dark:hover:text-blue-300"
                onClick={loadAllMessages}
              >
                {t('session.messages.loadAll')}
              </button>
            </div>
          )}

          {isSearchActive ? (
            filteredMessages.length === 0 ? (
              <div className="py-8 text-center text-sm text-muted-foreground">
                {t('session.messages.noSearchMatches', { defaultValue: 'No messages match your search.' })}
              </div>
            ) : (
              filteredMessages.map((message, index) => {
                const messagePrevMessage = index > 0 ? filteredMessages[index - 1] : null;
                const messageKey = getMessageKey(message);
                return (
                  <MessageComponent
                    key={messageKey}
                    messageKey={messageKey}
                    message={message}
                    prevMessage={messagePrevMessage}
                    createDiff={createDiff}
                    onFileOpen={onFileOpen}
                    onNavigateToSession={onNavigateToSession}
                    sessionId={currentSessionId}
                    onShowSettings={onShowSettings}
                    onGrantToolPermission={onGrantToolPermission}
                    showRawParameters={showRawParameters}
                    showThinking={showThinking}
                    selectedProject={selectedProject}
                    provider={provider}
                    searchQuery={trimmedQuery}
                    searchIndex={index}
                    isActiveMatch={index === activeMatchIndex}
                  />
                );
              })
            )
          ) : (() => {
            let prevMessage: ChatMessage | null = null;

            return groupedVisibleMessages.map((item, index) => {
              if (isToolGroupItem(item)) {
                const groupPrevMessage = prevMessage;
                prevMessage = item.messages[item.messages.length - 1] || prevMessage;

                const isFirstVisible = index === 0;
                const lastGroupMessage = item.messages[item.messages.length - 1] || item.messages[0];

            return (
              <ToolGroupContainer
                key={`tool-group-${getMessageKey(lastGroupMessage)}`}
                group={item}
                prevMessage={groupPrevMessage}
                createDiff={createDiff}
                getMessageKey={getMessageKey}
                onFileOpen={onFileOpen}
                onShowSettings={onShowSettings}
                onGrantToolPermission={onGrantToolPermission}
                showRawParameters={showRawParameters}
                showThinking={showThinking}
                selectedProject={selectedProject}
                provider={provider}
                isFirstVisible={isFirstVisible}
                totalMessages={totalMessages}
                sessionMessagesCount={sessionMessagesCount}
                allMessagesLoaded={allMessagesLoaded}
                isLoadingAllMessages={isLoadingAllMessages}
                loadAllMessages={loadAllMessages}
              />
            );
              }

              const messagePrevMessage = prevMessage;
              prevMessage = item;
              const messageKey = getMessageKey(item);

              return (
                <MessageComponent
                  key={messageKey}
                  messageKey={messageKey}
                  message={item}
                  prevMessage={messagePrevMessage}
                  createDiff={createDiff}
                  onFileOpen={onFileOpen}
                  onNavigateToSession={onNavigateToSession}
                  sessionId={currentSessionId}
                  onShowSettings={onShowSettings}
                  onGrantToolPermission={onGrantToolPermission}
                  showRawParameters={showRawParameters}
                  showThinking={showThinking}
                  selectedProject={selectedProject}
                  provider={provider}
                />
              );
            });
          })()}
        </>
      )}

      {showScrollToBottom && !reviewOpen && (
        <div className="pointer-events-none absolute inset-x-0 bottom-4 z-20 flex justify-center">
          <button
            type="button"
            onClick={handleScrollToBottom}
            aria-label={
              newMessagesCount > 0
                ? `${newMessagesCount > 99 ? '99+' : newMessagesCount} ${newMessagesCount === 1 ? t('input.newMessage', { defaultValue: 'New message' }) : t('input.newMessages', { count: newMessagesCount, defaultValue: 'New messages' })}`
                : t('input.scrollToBottom', { defaultValue: 'Scroll to bottom' })
            }
            title={
              newMessagesCount > 0
                ? `${newMessagesCount > 99 ? '99+' : newMessagesCount} ${newMessagesCount === 1 ? t('input.newMessage', { defaultValue: 'New message' }) : t('input.newMessages', { count: newMessagesCount, defaultValue: 'New messages' })}`
                : t('input.scrollToBottom', { defaultValue: 'Scroll to bottom' })
            }
            className="pointer-events-auto inline-flex items-center gap-1.5 rounded-full border border-border/60 bg-background/95 px-3 py-1.5 text-xs font-medium text-foreground shadow-md backdrop-blur-sm transition-all duration-200 hover:bg-accent hover:text-accent-foreground hover:shadow-lg focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 active:scale-95"
          >
            <ArrowDown className="h-3.5 w-3.5 text-muted-foreground" aria-hidden />
            {newMessagesCount > 0 ? (
              <>
                <span className="inline-flex h-5 min-w-5 items-center justify-center rounded-full bg-primary px-1.5 text-[11px] font-semibold text-primary-foreground">
                  {newMessagesCount > 99 ? '99+' : newMessagesCount}
                </span>
                <span>
                  {newMessagesCount === 1
                    ? t('input.newMessage', { defaultValue: 'New message' })
                    : t('input.newMessages', { count: newMessagesCount, defaultValue: 'New messages' })}
                </span>
              </>
            ) : (
              <span>{t('input.scrollToBottom', { defaultValue: 'Scroll to bottom' })}</span>
            )}
          </button>
        </div>
      )}
      </div>
    </div>
  );
}

export default memo(ChatMessagesPane);

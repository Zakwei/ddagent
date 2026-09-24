import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react';
import { useTranslation } from 'react-i18next';
import { Upload } from 'lucide-react';

import { useTasksSettings } from '../../../contexts/TasksSettingsContext';
import { useWebSocket } from '../../../contexts/WebSocketContext';
import type { RunReplayCursor } from '../../../contexts/WebSocketContext';
import PermissionContext from '../../../contexts/PermissionContext';
import { useKeyboardShortcuts } from '../../../hooks/useKeyboardShortcuts';
import { useUiPreferences } from '../../../hooks/useUiPreferences';
import type { ChatInterfaceProps, PermissionMode, Provider  } from '../types/types';
import { useChatProviderState } from '../hooks/useChatProviderState';
import { useChatSessionState } from '../hooks/useChatSessionState';
import { useChatRealtimeHandlers } from '../hooks/useChatRealtimeHandlers';
import { useChatComposerState } from '../hooks/useChatComposerState';
import { useGitCheckpoints } from '../hooks/useGitCheckpoints';
import { useProviderAccounts } from '../../../hooks/useProviderAccounts';
import { useSessionStore } from '../../../stores/useSessionStore';
import { api } from '../../../utils/api';

import ChatMessagesPane from './subcomponents/ChatMessagesPane';
import ChatComposer from './subcomponents/ChatComposer';
import CommandResultModal from './subcomponents/CommandResultModal';
import QuotaBadge from './subcomponents/QuotaBadge';
import { formatTokenCount, getUsedTokens } from './subcomponents/TokenUsageSummary';

function ChatInterface({
  isActive,
  selectedProject,
  selectedSession,
  boundSessionId,
  boundPaneId,
  ws,
  sendMessage,
  onFileOpen,
  onInputFocusChange,
  onSessionProcessing,
  onSessionIdle,
  processingSessions,
  onNavigateToSession,
  onSessionEstablished,
  onShowSettings,
  showRawParameters,
  showThinking,
  sendByCtrlEnter,
  externalMessageUpdate,
  newSessionTrigger,
  onShowAllTasks,
  onPermissionRequestsChange,
  projects,
  onSelectWorkspace,
}: ChatInterfaceProps) {
  const { tasksEnabled, isTaskMasterInstalled } = useTasksSettings();
  const { subscribe, isConnected } = useWebSocket();
  const { t } = useTranslation('chat');

  const sessionStore = useSessionStore();
  // Streaming flush state is keyed per session id so parallel runs never mix.
  const streamTimerRef = useRef(new Map<string, number>());
  const accumulatedStreamRef = useRef(new Map<string, string>());
  // When each session's `chat.subscribe` was last sent; idle acks older than
  // a later local request are discarded as stale.
  const statusCheckSentAtRef = useRef(new Map<string, number>());
  // Highest live `seq` observed per session. Written by the realtime handler
  // on every sequenced frame, read whenever a `chat.subscribe` is sent so the
  // server replays only the events this client actually missed.
  const lastSeqRef = useRef(new Map<string, RunReplayCursor>());

  const resetStreamingState = useCallback(() => {
    for (const timer of streamTimerRef.current.values()) {
      clearTimeout(timer);
    }
    streamTimerRef.current.clear();
    accumulatedStreamRef.current.clear();
  }, []);

  const {
    provider,
    setProvider,
    cursorModel,
    setCursorModel,
    claudeModel,
    setClaudeModel,
    codexModel,
    setCodexModel,
    currentProviderEffort,
    currentProviderEffortOptions,
    currentProviderModel,
    currentProviderModelOptions,
    opencodeModel,
    setOpenCodeModel,
    devinModel,
    setDevinModel,
    permissionMode,
    pendingPermissionRequests,
    setPendingPermissionRequests,
    availablePermissionModes,
    selectPermissionMode,
    cyclePermissionMode,
    providerModelCatalog,
    providerModelsLoading,
    loadProviderModels,
    providerModelActions,
    selectProviderModel,
    selectProviderEffort,
    resolvePermissionModeForProvider,
  } = useChatProviderState({
    selectedSession,
    selectedProject,
    boundSessionId,
    boundPaneId,
  });

  const {
    chatMessages,
    addMessage,
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
    setTokenBudget,
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
    handleScroll,
    requestLatestMessages,
  } = useChatSessionState({
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
  });

  // Brand-new conversation: the composer allocated a stable session id via
  // the session gateway before the first send. Record it locally and put it
  // in the URL — this id never changes again, so there is no later handoff.
  const handleSessionEstablished = useCallback<NonNullable<ChatInterfaceProps['onSessionEstablished']>>((sessionId, context) => {
    setCurrentSessionId(sessionId);
    onSessionEstablished?.(sessionId, context);
    onNavigateToSession?.(sessionId);
  }, [setCurrentSessionId, onSessionEstablished, onNavigateToSession]);

  const {
    lastCheckpoint,
    isCreatingCheckpoint,
    undoState,
    error: checkpointError,
    createCheckpoint,
    undoLastAiRun,
  } = useGitCheckpoints(selectedProject?.projectId);

  // Snapshot the working tree before every AI turn so it can be undone. The
  // hook reports failures itself, so the send is never blocked.
  const handleBeforeSend = useCallback(async () => {
    await createCheckpoint('before AI turn');
  }, [createCheckpoint]);

  const {
    input,
    setInput,
    textareaRef,
    inputHighlightRef,
    isTextareaExpanded,
    slashCommandsCount,
    filteredCommands,
    frequentCommands,
    commandQuery,
    showCommandMenu,
    selectedCommandIndex,
    resetCommandMenuState,
    handleCommandSelect,
    handleToggleCommandMenu,
    showMentionDropdown,
    filteredMentions,
    selectedMentionIndex,
    renderInputWithMentions,
    onSelectMention,
    attachedFiles,
    setAttachedFiles,
    handleAttachmentFiles,
    uploadingFiles,
    fileErrors,
    getRootProps,
    getInputProps,
    isDragActive,
    openAttachmentPicker,
    handleSubmit,
    queuedMessages,
    sendQueuedNow,
    editQueuedMessage,
    deleteQueuedMessage,
    handleInputChange,
    handleKeyDown,
    handlePaste: handleComposerPaste,
    handleTextareaClick,
    handleTextareaInput,
    syncInputOverlayScroll,
    handleClearInput,
    handleAbortSession,
    handlePermissionDecision,
    handleGrantToolPermission,
    handleInputFocusChange,
    isInputFocused,
    commandModalPayload,
    closeCommandModal,
    showCostModal,
    offlineQueue,
    clearOfflineQueue,
    offlineToast,
    autoContinueTasks,
    onToggleAutoContinueTasks,
    selectedAccountId,
    onSelectAccount,
  } = useChatComposerState({
    selectedProject,
    selectedSession,
    currentSessionId,
    provider,
    permissionMode,
    cyclePermissionMode,
    currentProviderModel,
    currentProviderEffort,
    isLoading: isProcessing,
    processingSessions,
    canAbortSession,
    tokenBudget,
    sendMessage,
    sendByCtrlEnter,
    isConnected,
    onSessionProcessing,
    onSessionEstablished: handleSessionEstablished,
    onInputFocusChange,
    onFileOpen,
    onShowSettings,
    scrollToBottom,
    addMessage,
    setIsUserScrolledUp,
    setPendingPermissionRequests,
    resolvePermissionModeForProvider,
    onBeforeSend: handleBeforeSend,
  });

  const { preferences } = useUiPreferences();

  // Multi-account: the new-session picker lists this provider's named accounts.
  const { accounts: providerAccounts } = useProviderAccounts(provider);

  // Focus follows pointer: hovering the chat moves keyboard focus to the input.
  // No `isActive` gate — focusing the composer is what activates the pane
  // (SplitWorkspaceGrid activates on focus capture), so gating on it would
  // leave inactive panes unreachable by hover.
  const handlePointerEnter = useCallback(
    (event: React.PointerEvent<HTMLDivElement>) => {
      if (event.pointerType !== 'mouse') {
        return;
      }

      if (!preferences.focusFollowsPointer) {
        return;
      }

      // Never steal focus from a field the user is typing in (inline session
      // rename, sidebar search, …): the forced blur would commit and close
      // the editor mid-edit. Pane-local textareas (another chat's composer,
      // xterm's helper input) blur harmlessly, so the handoff is allowed.
      const active = document.activeElement;
      const fieldHasFocus =
        active instanceof HTMLElement &&
        (active.tagName === 'INPUT' ||
          active.isContentEditable ||
          (active.tagName === 'TEXTAREA' && !active.closest('[data-pane-id]')));
      if (fieldHasFocus) {
        return;
      }

      textareaRef.current?.focus();
    },
    [preferences.focusFollowsPointer, textareaRef],
  );

  useKeyboardShortcuts({
    canAbortSession,
    onAbortSession: handleAbortSession,
    isActive,
  });

  // On WebSocket reconnect, request a bounded persisted-tail sync (deferred
  // while Chat is hidden), then re-subscribe — the
  // `chat_subscribed` ack restores or clears the activity indicator, replays
  // missed live events, and re-attaches a still-running stream to this socket.
  const handleWebSocketReconnect = useCallback(async () => {
    const targetSessionId = selectedSession?.id || currentSessionId;
    // Only the session id gates resubscribing: a transiently-null project
    // must not skip it — without re-attach the run's live frames keep going
    // to the dead socket and the response only appears after a page reload.
    if (!targetSessionId) return;
    await requestLatestMessages(targetSessionId, isActive);
    statusCheckSentAtRef.current.set(targetSessionId, Date.now());
    const cursor = lastSeqRef.current.get(targetSessionId);
    sendMessage({
      type: 'chat.subscribe',
      sessions: [{
        sessionId: targetSessionId,
        runId: cursor?.runId ?? null,
        lastSeq: cursor?.seq ?? 0,
      }],
    });
  }, [currentSessionId, isActive, requestLatestMessages, selectedSession?.id, sendMessage]);

  // Proactively synchronize session state and tail messages when the user
  // returns to this tab or unlocks their device, without requiring a manual page refresh.
  useEffect(() => {
    const targetSessionId = selectedSession?.id || currentSessionId;
    if (!targetSessionId || !isActive) return;

    const handleSync = () => {
      if (typeof document !== 'undefined' && document.visibilityState !== 'visible') {
        return;
      }
      void requestLatestMessages(targetSessionId, true);
      statusCheckSentAtRef.current.set(targetSessionId, Date.now());
      const cursor = lastSeqRef.current.get(targetSessionId);
      sendMessage({
        type: 'chat.subscribe',
        sessions: [{
          sessionId: targetSessionId,
          runId: cursor?.runId ?? null,
          lastSeq: cursor?.seq ?? 0,
        }],
      });
    };

    document.addEventListener('visibilitychange', handleSync);
    window.addEventListener('focus', handleSync);

    return () => {
      document.removeEventListener('visibilitychange', handleSync);
      window.removeEventListener('focus', handleSync);
    };
  }, [currentSessionId, isActive, requestLatestMessages, selectedSession?.id, sendMessage]);

  // While processing a long-running turn (or background subagents), run a watchdog
  // every 10 seconds to catch up on completed runs if a terminal event was missed
  // due to connection hiccup, mobile suspend, or server restart.
  useEffect(() => {
    const targetSessionId = selectedSession?.id || currentSessionId;
    if (!targetSessionId || !isProcessing || !isActive) return;

    const interval = setInterval(() => {
      void requestLatestMessages(targetSessionId, true);
      statusCheckSentAtRef.current.set(targetSessionId, Date.now());
      const cursor = lastSeqRef.current.get(targetSessionId);
      sendMessage({
        type: 'chat.subscribe',
        sessions: [{
          sessionId: targetSessionId,
          runId: cursor?.runId ?? null,
          lastSeq: cursor?.seq ?? 0,
        }],
      });
    }, 10_000);

    return () => clearInterval(interval);
  }, [currentSessionId, isActive, isProcessing, requestLatestMessages, selectedSession?.id, sendMessage]);

  // Stamp the bound session as viewed on the server while it is displayed,
  // active and idle. Fires when a session is bound/opened, and again when it
  // transitions running→idle or its lastActivity bumps while the user is
  // watching — keeps `lastViewedAt` fresh so finishing-in-view never produces
  // an unread dot. The broadcast session_upserted updates the local store;
  // no optimistic update needed. Draft panes have no boundSessionId.
  useEffect(() => {
    if (!isActive || !boundSessionId || isProcessing) return;
    void api.markSessionViewed(boundSessionId).catch(() => {});
  }, [isActive, boundSessionId, isProcessing, selectedSession?.lastActivity]);

  // Push the selected permission mode to the provider runtime so a mid-run
  // toggle (e.g. enabling bypass while a response is still streaming) takes
  // effect immediately. Providers without live support ignore the message —
  // they still receive the mode in the next `chat.send` options.
  useEffect(() => {
    const targetSessionId = selectedSession?.id;
    if (!targetSessionId) return;

    sendMessage({
      type: 'chat.set-permission-mode',
      sessionId: targetSessionId,
      permissionMode,
    });
  }, [permissionMode, selectedSession?.id, sendMessage]);

  useChatRealtimeHandlers({
    isActive,
    subscribe,
    provider,
    selectedSession,
    boundSessionId,
    currentSessionId,
    setTokenBudget,
    pendingPermissionRequests,
    setPendingPermissionRequests,
    streamTimerRef,
    accumulatedStreamRef,
    lastSeqRef,
    statusCheckSentAtRef,
    onSessionProcessing,
    onSessionIdle,
    onWebSocketReconnect: handleWebSocketReconnect,
    requestLatestMessages,
    sessionStore,
  });

  useEffect(() => {
    return () => {
      resetStreamingState();
    };
  }, [resetStreamingState]);

  const permissionContextValue = useMemo(() => ({
    pendingPermissionRequests,
    handlePermissionDecision,
  }), [pendingPermissionRequests, handlePermissionDecision]);

  useEffect(() => {
    onPermissionRequestsChange?.(pendingPermissionRequests.length);
  }, [onPermissionRequestsChange, pendingPermissionRequests.length]);

  // A composer pick becomes the default for new chats and, when a session is
  // open, is recorded against that session so reopening it restores this model.
  const handleSelectComposerModel = useCallback(async (model: string) => {
    try {
      await selectProviderModel(provider, model, currentSessionId || selectedSession?.id || null);
    } catch (error) {
      console.error('Error changing the active session model:', error);
    }
  }, [currentSessionId, provider, selectProviderModel, selectedSession?.id]);

  const onRefreshProviderModels = useCallback(async (force?: boolean) => {
    await loadProviderModels({ refresh: force });
  }, [loadProviderModels]);

  const handleSelectComposerEffort = useCallback(async (effort: string) => {
    try {
      await selectProviderEffort(provider, effort, currentSessionId || selectedSession?.id || null);
    } catch (error) {
      console.error('Error changing the active session reasoning effort:', error);
    }
  }, [currentSessionId, provider, selectProviderEffort, selectedSession?.id]);

  // Mirrors ChatComposer's own visibility check so the message pane can
  // reserve enough bottom space to keep the floating status tab from
  // overlapping the last message.
  const hasActivityIndicator = Boolean(sessionActivity && pendingPermissionRequests.length === 0);

  const selectedProviderLabel =
    provider === 'cursor'
      ? t('messageTypes.cursor')
      : provider === 'codex'
        ? t('messageTypes.codex')
        : provider === 'opencode'
            ? t('messageTypes.opencode', { defaultValue: 'OpenCode' })
            : provider === 'devin'
              ? t('messageTypes.devin', { defaultValue: 'Devin' })
              : t('messageTypes.claude');

  const ocModelLabel =
    currentProviderModelOptions.find((option) => option.value === currentProviderModel)?.label ||
    currentProviderModel;
  const ocProjectPath =
    selectedProject?.fullPath || selectedProject?.path || selectedProject?.projectId || '';
  const ocUsedTokens = getUsedTokens(tokenBudget);
  const ocTotalTokens = Number(tokenBudget?.total) || 0;
  const ocContextPercent =
    ocUsedTokens > 0 && ocTotalTokens > 0
      ? Math.min(100, Math.round((ocUsedTokens / ocTotalTokens) * 100))
      : null;
  const ocContextTone =
    ocContextPercent === null ? '' : ocContextPercent >= 85 ? 'is-high' : ocContextPercent >= 60 ? 'is-mid' : 'is-low';

  const handleScrollToBottom = useCallback(() => {
    setIsUserScrolledUp(false);
    scrollToBottomAndReset();
  }, [scrollToBottomAndReset, setIsUserScrolledUp]);

  const [isDraggingFiles, setIsDraggingFiles] = useState(false);
  const dragCounterRef = useRef(0);

  useEffect(() => {
    setIsDraggingFiles(false);
    dragCounterRef.current = 0;
  }, [selectedSession?.id, isActive]);

  const handleDragEnter = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.dataTransfer?.types && Array.from(e.dataTransfer.types).includes('Files')) {
      dragCounterRef.current += 1;
      setIsDraggingFiles(true);
    }
  }, []);

  const handleDragOver = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    if (e.dataTransfer) {
      e.dataTransfer.dropEffect = 'copy';
    }
  }, []);

  const handleDragLeave = useCallback((e: React.DragEvent) => {
    e.preventDefault();
    e.stopPropagation();
    dragCounterRef.current = Math.max(0, dragCounterRef.current - 1);
    if (dragCounterRef.current === 0 || !e.relatedTarget) {
      dragCounterRef.current = 0;
      setIsDraggingFiles(false);
    }
  }, []);

  const handleDrop = useCallback(
    (e: React.DragEvent) => {
      e.preventDefault();
      e.stopPropagation();
      dragCounterRef.current = 0;
      setIsDraggingFiles(false);
      const droppedFiles = Array.from(e.dataTransfer?.files || []);
      if (droppedFiles.length > 0) {
        handleAttachmentFiles(droppedFiles);
      }
    },
    [handleAttachmentFiles],
  );

  // Pasting a file anywhere in the tile attaches it — pastes landing in the
  // textarea itself are left to its own onPaste so they are not handled twice.
  const handlePaste = useCallback(
    (e: React.ClipboardEvent<HTMLDivElement>) => {
      if (e.target === textareaRef.current) {
        return;
      }
      handleComposerPaste(e);
    },
    [handleComposerPaste, textareaRef],
  );

  if (!selectedProject) {
    return (
      <div className="flex h-full items-center justify-center">
        <div className="text-center text-muted-foreground">
          <p className="text-sm">
            {t('projectSelection.startChatWithProvider', {
              provider: selectedProviderLabel,
              defaultValue: 'Select a project to start chatting with {{provider}}',
            })}
          </p>
        </div>
      </div>
    );
  }

  return (
    <PermissionContext.Provider value={permissionContextValue}>
      <div
        className="oc-chat dark relative flex h-full min-h-0 flex-col"
        onPointerEnter={handlePointerEnter}
        onDragEnter={handleDragEnter}
        onDragOver={handleDragOver}
        onDragLeave={handleDragLeave}
        onDrop={handleDrop}
        onPaste={handlePaste}
      >
        {isDraggingFiles && (
          <div className="pointer-events-auto absolute inset-0 z-40 flex flex-col items-center justify-center rounded-lg border-2 border-dashed border-primary/60 bg-background/80 backdrop-blur-sm">
            <div className="flex flex-col items-center gap-3 p-6 text-center">
              <div className="flex h-16 w-16 items-center justify-center rounded-full bg-primary/10 text-primary">
                <Upload className="h-8 w-8" aria-hidden="true" />
              </div>
              <p className="text-base font-medium text-foreground">
                Drop files to attach to chat
              </p>
            </div>
          </div>
        )}
        <div className="oc-banner">
          <span className="oc-banner-logo">✻ {selectedProviderLabel}</span>
          <span className="oc-banner-sep" aria-hidden="true">·</span>
          <span className="oc-banner-model">{ocModelLabel}</span>
          <span className="oc-banner-sep" aria-hidden="true">·</span>
          <span className="oc-banner-path">{ocProjectPath}</span>
          {ocContextPercent !== null && (
            <span
              className="oc-banner-ctx"
              title={`Context: ${ocUsedTokens.toLocaleString()} / ${ocTotalTokens.toLocaleString()} tokens · ${ocContextPercent}% used`}
            >
              <span className="oc-ctx-bar" aria-hidden="true">
                <span className={`oc-ctx-bar-fill ${ocContextTone}`} style={{ width: `${ocContextPercent}%` }} />
              </span>
              <span className="oc-ctx-pct">{ocContextPercent}%</span>
              <span className="oc-ctx-count">{formatTokenCount(ocTotalTokens)}</span>
            </span>
          )}
          <QuotaBadge
            provider={provider}
            model={currentProviderModel}
            className="ml-auto h-auto gap-1 px-1.5 text-[11px]"
          />
        </div>

        <ChatMessagesPane
          scrollContainerRef={scrollContainerRef}
          contentRef={contentRef}
          onWheel={handleScroll}
          onTouchMove={handleScroll}
          onPointerDown={handleScroll}
          isActive={isActive}
          isLoadingSessionMessages={isLoadingSessionMessages}
          isProcessing={isProcessing}
          hasActivityIndicator={hasActivityIndicator}
          chatMessages={chatMessages}
          selectedSession={selectedSession}
          currentSessionId={currentSessionId}
          boundPaneId={boundPaneId}
          provider={provider}
          setProvider={(nextProvider) => setProvider(nextProvider as Provider)}
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
          isLoadingMoreMessages={isLoadingMoreMessages}
          loadOlderMessagesError={loadOlderMessagesError}
          onRetryLoadOlderMessages={retryLoadOlderMessages}
          hasMoreMessages={hasMoreMessages}
          totalMessages={totalMessages}
          sessionMessagesCount={chatMessages.length}
          visibleMessageCount={visibleMessageCount}
          visibleMessages={visibleMessages}
          loadEarlierMessages={loadEarlierMessages}
          loadAllMessages={loadAllMessages}
          allMessagesLoaded={allMessagesLoaded}
          isLoadingAllMessages={isLoadingAllMessages}
          loadAllJustFinished={loadAllJustFinished}
          showLoadAllOverlay={showLoadAllOverlay}
          createDiff={createDiff}
          onFileOpen={onFileOpen}
          onShowSettings={onShowSettings}
          onGrantToolPermission={handleGrantToolPermission}
          showRawParameters={showRawParameters}
          showThinking={showThinking}
          selectedProject={selectedProject}
          isUserScrolledUp={isUserScrolledUp}
          onScrollToBottom={handleScrollToBottom}
          projects={projects}
          onSelectWorkspace={onSelectWorkspace}
        />

        <div className="relative flex-shrink-0">
          <ChatComposer
          pendingPermissionRequests={pendingPermissionRequests}
          handlePermissionDecision={handlePermissionDecision}
          handleGrantToolPermission={handleGrantToolPermission}
          activity={sessionActivity}
          isLoading={isProcessing}
          onAbortSession={handleAbortSession}
          permissionMode={permissionMode}
          availablePermissionModes={availablePermissionModes}
          onSelectPermissionMode={(mode) => selectPermissionMode(mode as PermissionMode)}
          providerLabel={selectedProviderLabel}
          effort={currentProviderEffort}
          availableEffortOptions={currentProviderEffortOptions}
          onSelectEffort={handleSelectComposerEffort}
          model={currentProviderModel}
          availableModelOptions={currentProviderModelOptions}
          onSelectModel={handleSelectComposerModel}
          onRefreshProviderModels={onRefreshProviderModels}
          modelsLoading={providerModelsLoading}
          tokenBudget={tokenBudget}
          provider={provider}
          onShowTokenUsage={showCostModal}
          slashCommandsCount={slashCommandsCount}
          onToggleCommandMenu={handleToggleCommandMenu}
          hasInput={Boolean(input.trim())}
          onClearInput={handleClearInput}
          onSubmit={handleSubmit}
          isDragActive={isDragActive}
          queuedMessages={queuedMessages}
          onSendQueuedNow={sendQueuedNow}
          onEditQueuedMessage={editQueuedMessage}
          onDeleteQueuedMessage={deleteQueuedMessage}
          attachedFiles={attachedFiles}
          onAttachFiles={handleAttachmentFiles}
          onRemoveAttachment={(index) =>
            setAttachedFiles((previous) =>
              previous.filter((_, currentIndex) => currentIndex !== index),
            )
          }
          uploadingFiles={uploadingFiles}
          fileErrors={fileErrors}
          showMentionDropdown={showMentionDropdown}
          filteredMentions={filteredMentions}
          selectedMentionIndex={selectedMentionIndex}
          onSelectMention={onSelectMention}
          filteredCommands={filteredCommands}
          selectedCommandIndex={selectedCommandIndex}
          onCommandSelect={handleCommandSelect}
          onCloseCommandMenu={resetCommandMenuState}
          isCommandMenuOpen={showCommandMenu}
          frequentCommands={commandQuery ? [] : frequentCommands}
          getRootProps={getRootProps as (...args: unknown[]) => Record<string, unknown>}
          getInputProps={getInputProps as (...args: unknown[]) => Record<string, unknown>}
          openAttachmentPicker={openAttachmentPicker}
          inputHighlightRef={inputHighlightRef}
          renderInputWithMentions={renderInputWithMentions}
          textareaRef={textareaRef}
          input={input}
          onInputChange={handleInputChange}
          onTextareaClick={handleTextareaClick}
          onTextareaKeyDown={handleKeyDown}
          onTextareaPaste={handleComposerPaste}
          onTextareaScrollSync={syncInputOverlayScroll}
          onTextareaInput={handleTextareaInput}
          isInputFocused={isInputFocused}
          onInputFocusChange={handleInputFocusChange}
          placeholder={t('input.placeholder', { provider: selectedProviderLabel })}
          isTextareaExpanded={isTextareaExpanded}
          sendByCtrlEnter={sendByCtrlEnter}
          selectedProject={selectedProject}
          onFileOpen={onFileOpen}
          hasCheckpoint={lastCheckpoint !== null}
          isCreatingCheckpoint={isCreatingCheckpoint}
          undoState={undoState}
          onUndoLastAiRun={undoLastAiRun}
          checkpointError={checkpointError}
          offlineQueue={offlineQueue}
          onClearOfflineQueue={clearOfflineQueue}
          offlineToast={offlineToast}
          autoContinueTasks={autoContinueTasks}
          onToggleAutoContinueTasks={onToggleAutoContinueTasks}
          providerAccounts={providerAccounts}
          selectedAccountId={selectedAccountId}
          onSelectAccount={onSelectAccount}
          isNewSession={!currentSessionId && !selectedSession?.id}
          autoReadSessionId={boundSessionId || currentSessionId || selectedSession?.id || null}
        />
        </div>
      </div>

      <CommandResultModal
        payload={commandModalPayload}
        onClose={closeCommandModal}
        providerModelCatalog={providerModelCatalog}
        providerModelActions={providerModelActions}
        activeProvider={provider}
        activeProviderModel={currentProviderModel}
        currentSessionId={currentSessionId || selectedSession?.id || null}
        onSelectProviderModel={selectProviderModel}
      />
    </PermissionContext.Provider>
  );
}

export default React.memo(ChatInterface);

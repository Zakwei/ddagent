import { useTranslation } from 'react-i18next';
import { useCallback, useEffect, useLayoutEffect, useRef, useState } from 'react';
import type {
  ChangeEvent,
  ClipboardEvent,
  FormEvent,
  KeyboardEvent,
  MouseEvent,
  ReactNode,
  RefObject,
  TouchEvent,
} from 'react';
import { PaperclipIcon, MessageSquare, ArrowUpIcon, FileText, ListTodo, Plus, AudioLines } from 'lucide-react';

import { api } from '../../../../utils/api';
import type { MentionableItem } from '../../hooks/useMentions';
import { usePinnedFiles } from '../../hooks/usePinnedFiles';
import { isAutoReadArmed, setAutoReadArmed, stopSpeaking } from '../../../../lib/voiceAutoRead';
import type { QueuedOfflineMessage } from '../../utils/chatStorage';
import type { ServerQueuedMessage } from '../../hooks/useMessageQueue';
import type { UndoState } from '../../hooks/useGitCheckpoints';
import type { SessionActivity } from '../../../../hooks/useSessionProtection';
import type { PendingPermissionRequest, PermissionMode } from '../../types/types';
import { resolveToolName } from '../../tools/configs/toolConfigs';
import type { LLMProvider, Project, ProviderModelOption } from '../../../../types/app';
import {
  PromptInput,
  PromptInputHeader,
  PromptInputBody,
  PromptInputTextarea,
  PromptInputFooter,
  PromptInputTools,
  PromptInputButton,
  PromptInputSubmit,
} from '../../../../shared/view/ui';

import OfflineQueueCard from './OfflineQueueCard';
import CommandMenu, { type CommandMenuPosition } from './CommandMenu';
import ActivityIndicator from './ActivityIndicator';
import ComposerAttachment from './ComposerAttachment';
import PermissionRequestsBanner from './PermissionRequestsBanner';
import QueuedMessageCard from './QueuedMessageCard';
import ComposerModelMenu from './ComposerModelMenu';
import ComposerPermissionMenu from './ComposerPermissionMenu';
import CheckpointButton from './CheckpointButton';
import PinnedFilesBar from './PinnedFilesBar';
import MobileComposerActionSheet from './MobileComposerActionSheet';

interface SlashCommand {
  name: string;
  description?: string;
  namespace?: string;
  path?: string;
  type?: string;
  metadata?: Record<string, unknown>;
  [key: string]: unknown;
}

interface ChatComposerProps {
  pendingPermissionRequests: PendingPermissionRequest[];
  handlePermissionDecision: (
    requestIds: string | string[],
    decision: { allow?: boolean; message?: string; rememberEntry?: string | null; updatedInput?: unknown },
  ) => void;
  handleGrantToolPermission: (suggestion: { entry: string; toolName: string }) => { success: boolean };
  activity: SessionActivity | null;
  isLoading: boolean;
  onAbortSession: () => void;
  permissionMode: PermissionMode | string;
  availablePermissionModes: (PermissionMode | string)[];
  onSelectPermissionMode: (mode: PermissionMode | string) => void;
  providerLabel: string;
  effort: string;
  availableEffortOptions: NonNullable<ProviderModelOption['effort']>['values'];
  onSelectEffort: (effort: string) => void;
  model: string;
  availableModelOptions: ProviderModelOption[];
  onSelectModel: (model: string) => void;
  onRefreshProviderModels?: (force?: boolean) => Promise<void> | void;
  modelsLoading: boolean;
  tokenBudget: Record<string, unknown> | null;
  provider: string;
  onShowTokenUsage: () => void;
  slashCommandsCount: number;
  onToggleCommandMenu: () => void;
  hasInput: boolean;
  onClearInput: () => void;
  onSubmit: (event: FormEvent<HTMLFormElement> | MouseEvent<HTMLButtonElement> | TouchEvent<HTMLButtonElement>) => void;
  isDragActive: boolean;
  queuedMessages: ServerQueuedMessage[];
  onSendQueuedNow: (id: number) => void;
  onEditQueuedMessage: (message: ServerQueuedMessage) => void;
  onDeleteQueuedMessage: (id: number) => void;
  attachedFiles: File[];
  onAttachFiles?: (files: File[]) => void;
  onRemoveAttachment: (index: number) => void;
  uploadingFiles: Map<string, number>;
  fileErrors: Map<string, string>;
  showMentionDropdown: boolean;
  filteredMentions: MentionableItem[];
  selectedMentionIndex: number;
  onSelectMention: (mention: MentionableItem) => void;
  filteredCommands: SlashCommand[];
  selectedCommandIndex: number;
  onCommandSelect: (command: SlashCommand, index: number, isHover: boolean) => void;
  onCloseCommandMenu: () => void;
  isCommandMenuOpen: boolean;
  frequentCommands: SlashCommand[];
  getRootProps: (...args: unknown[]) => Record<string, unknown>;
  getInputProps: (...args: unknown[]) => Record<string, unknown>;
  openAttachmentPicker: () => void;
  inputHighlightRef: RefObject<HTMLDivElement>;
  renderInputWithMentions: (text: string) => ReactNode;
  textareaRef: RefObject<HTMLTextAreaElement>;
  input: string;
  onInputChange: (event: ChangeEvent<HTMLTextAreaElement>) => void;
  onTextareaClick: (event: MouseEvent<HTMLTextAreaElement>) => void;
  onTextareaKeyDown: (event: KeyboardEvent<HTMLTextAreaElement>) => void;
  onTextareaPaste: (event: ClipboardEvent<HTMLTextAreaElement>) => void;
  onTextareaScrollSync: (target: HTMLTextAreaElement) => void;
  onTextareaInput: (event: FormEvent<HTMLTextAreaElement>) => void;
  isInputFocused?: boolean;
  onInputFocusChange?: (focused: boolean) => void;
  placeholder: string;
  isTextareaExpanded: boolean;
  sendByCtrlEnter?: boolean;
  selectedProject?: Project | null;
  onFileOpen?: (filePath: string) => void;
  hasCheckpoint: boolean;
  isCreatingCheckpoint: boolean;
  undoState: UndoState;
  onUndoLastAiRun: () => void;
  checkpointError: string | null;
  offlineQueue?: QueuedOfflineMessage[];
  onClearOfflineQueue?: () => void;
  offlineToast?: string | null;
  autoContinueTasks?: boolean;
  onToggleAutoContinueTasks?: () => void;
  /** Session the read-aloud toggle arms/disarms (the chat this pane views). */
  autoReadSessionId?: string | null;
}

export default function ChatComposer({
  pendingPermissionRequests,
  handlePermissionDecision,
  handleGrantToolPermission,
  activity,
  isLoading,
  onAbortSession,
  permissionMode,
  availablePermissionModes,
  onSelectPermissionMode,
  providerLabel,
  effort,
  availableEffortOptions,
  onSelectEffort,
  model,
  availableModelOptions,
  onSelectModel,
  onRefreshProviderModels,
  modelsLoading,
  tokenBudget,
  provider,
  onShowTokenUsage,
  slashCommandsCount,
  onToggleCommandMenu,
  hasInput,
  onClearInput,
  onSubmit,
  isDragActive,
  queuedMessages,
  onSendQueuedNow,
  onEditQueuedMessage,
  onDeleteQueuedMessage,
  attachedFiles,
  onAttachFiles,
  onRemoveAttachment,
  uploadingFiles,
  fileErrors,
  showMentionDropdown,
  filteredMentions,
  selectedMentionIndex,
  onSelectMention,
  filteredCommands,
  selectedCommandIndex,
  onCommandSelect,
  onCloseCommandMenu,
  isCommandMenuOpen,
  frequentCommands,
  getRootProps,
  getInputProps,
  openAttachmentPicker,
  inputHighlightRef,
  renderInputWithMentions,
  textareaRef,
  input,
  onInputChange,
  onTextareaClick,
  onTextareaKeyDown,
  onTextareaPaste,
  onTextareaScrollSync,
  onTextareaInput,
  isInputFocused = false,
  onInputFocusChange,
  placeholder,
  isTextareaExpanded,
  sendByCtrlEnter,
  selectedProject,
  onFileOpen,
  hasCheckpoint,
  isCreatingCheckpoint,
  undoState,
  onUndoLastAiRun,
  checkpointError,
  offlineQueue,
  onClearOfflineQueue,
  offlineToast,
  autoContinueTasks,
  onToggleAutoContinueTasks,
  autoReadSessionId = null,
}: ChatComposerProps) {
  const { t } = useTranslation('chat');
  const [isMobileToolsOpen, setIsMobileToolsOpen] = useState(false);
  const cameraInputRef = useRef<HTMLInputElement>(null);
  const mentionDropdownRef = useRef<HTMLDivElement | null>(null);
  const selectedMentionRef = useRef<HTMLDivElement | null>(null);

  const handleCameraChange = useCallback(
    (event: ChangeEvent<HTMLInputElement>) => {
      const files = event.target.files ? Array.from(event.target.files) : [];
      if (files.length > 0) {
        onAttachFiles?.(files);
      }
      if (cameraInputRef.current) {
        cameraInputRef.current.value = '';
      }
    },
    [onAttachFiles],
  );
  const [commandMenuPosition, setCommandMenuPosition] = useState<CommandMenuPosition>({
    top: 0,
    left: 16,
    bottom: 90,
  });

  const updateCommandMenuPosition = useCallback(() => {
    const textareaRect = textareaRef.current?.getBoundingClientRect();
    if (!textareaRect) {
      return;
    }
    // Bound the document-level portal to this chat tile's rect so the menu
    // cannot overflow onto a neighboring split pane.
    const paneRect = textareaRef.current
      ?.closest('[data-pane-id]')
      ?.getBoundingClientRect();
    // Anchor above the whole composer box (attachments header, pinned files,
    // wrapped tool rows), not just the textarea — otherwise the menu's lower
    // edge lands inside the composer and its sections sit behind the composer
    // border. Same anchor choice as useComposerMenuAnchor.
    const composerTop =
      textareaRef.current?.closest('[data-slot="prompt-input"]')?.getBoundingClientRect().top ??
      textareaRect.top;
    setCommandMenuPosition({
      top: Math.max(16, composerTop - 316),
      left: textareaRect.left,
      bottom: window.innerHeight - composerTop + 8,
      containerLeft: paneRect?.left ?? textareaRect.left,
      containerRight: paneRect?.right ?? textareaRect.right,
    });
  }, [textareaRef]);

  // Re-measure while the menu is open: when the virtual keyboard opens, the
  // layout viewport keeps its full height and the app shell is lifted by
  // --keyboard-height (see AppContent), which moves the composer — an anchor
  // captured only at open time leaves the menu behind the keyboard/composer
  // edge. visualViewport events cover the keyboard; window resize/scroll the
  // rest. useLayoutEffect so the fresh anchor lands before paint.
  useLayoutEffect(() => {
    if (!isCommandMenuOpen) {
      return;
    }
    updateCommandMenuPosition();
    const viewport = window.visualViewport;
    window.addEventListener('resize', updateCommandMenuPosition);
    window.addEventListener('scroll', updateCommandMenuPosition, true);
    viewport?.addEventListener('resize', updateCommandMenuPosition);
    viewport?.addEventListener('scroll', updateCommandMenuPosition);
    // The composer anchor also moves when the shell resizes while open —
    // attachments/expansion growing the box, or banners and queue cards
    // pushing it down.
    const composerShell = textareaRef.current?.closest('.oc-composer');
    const resizeObserver =
      composerShell && typeof ResizeObserver !== 'undefined'
        ? new ResizeObserver(updateCommandMenuPosition)
        : null;
    if (composerShell) {
      resizeObserver?.observe(composerShell);
    }
    return () => {
      window.removeEventListener('resize', updateCommandMenuPosition);
      window.removeEventListener('scroll', updateCommandMenuPosition, true);
      viewport?.removeEventListener('resize', updateCommandMenuPosition);
      viewport?.removeEventListener('scroll', updateCommandMenuPosition);
      resizeObserver?.disconnect();
    };
  }, [isCommandMenuOpen, updateCommandMenuPosition, textareaRef]);

  useEffect(() => {
    const dropdown = mentionDropdownRef.current;
    const selectedMention = selectedMentionRef.current;
    if (!showMentionDropdown || !dropdown || !selectedMention) {
      return;
    }

    const itemTop = selectedMention.offsetTop;
    const itemBottom = itemTop + selectedMention.offsetHeight;
    const visibleTop = dropdown.scrollTop;
    const visibleBottom = visibleTop + dropdown.clientHeight;

    if (itemTop < visibleTop) {
      dropdown.scrollTop = itemTop;
    } else if (itemBottom > visibleBottom) {
      dropdown.scrollTop = itemBottom - dropdown.clientHeight;
    }
  }, [selectedMentionIndex, showMentionDropdown]);

  // Opt-in "read the reply aloud" for the session this pane is viewing. The
  // armed set itself lives in lib/voiceAutoRead (module state) so arming
  // survives pane switches and remounts; local state only mirrors it for render.
  const [autoReadArmed, setAutoReadArmedState] = useState(() =>
    autoReadSessionId ? isAutoReadArmed(autoReadSessionId) : false,
  );
  useEffect(() => {
    setAutoReadArmedState(autoReadSessionId ? isAutoReadArmed(autoReadSessionId) : false);
  }, [autoReadSessionId]);
  const handleToggleAutoRead = useCallback(() => {
    if (!autoReadSessionId) return;
    const next = !isAutoReadArmed(autoReadSessionId);
    setAutoReadArmed(autoReadSessionId, next);
    setAutoReadArmedState(next);
    if (!next) stopSpeaking();
  }, [autoReadSessionId]);

  // Detect if the AskUserQuestion interactive panel is active — providers
  // spell the tool name differently (AskUserQuestion vs ask_user_question),
  // so match on the resolved canonical name.
  const hasQuestionPanel = pendingPermissionRequests.some(
    (r) => resolveToolName(r.toolName) === 'AskUserQuestion'
  );

  // Hide the thinking/status bar while any permission request is pending
  const hasPendingPermissions = pendingPermissionRequests.length > 0;
  const hasActivityIndicator = Boolean(activity && !hasPendingPermissions);

  const projectId = selectedProject?.projectId;
  const { pinnedFiles, unpinFile } = usePinnedFiles(projectId);
  // Token estimates are cached by path+length so switching/typing never refetches.
  const tokenCacheRef = useRef<Map<string, number>>(new Map());
  const [pinnedTokenEstimate, setPinnedTokenEstimate] = useState(0);

  useEffect(() => {
    if (pinnedFiles.length === 0 || !projectId) {
      setPinnedTokenEstimate(0);
      return;
    }

    let cancelled = false;

    const estimateTokens = async () => {
      const cache = tokenCacheRef.current;
      const totals = await Promise.all(
        pinnedFiles.map(async (path) => {
          try {
            const response = await api.readFile(projectId, path);
            if (!response.ok) {
              return 0;
            }
            const data = await response.json();
            const content = typeof data?.content === 'string' ? data.content : '';
            const key = `${path}:${content.length}`;
            const cached = cache.get(key);
            if (cached !== undefined) {
              return cached;
            }
            const estimate = Math.ceil(content.length / 4);
            cache.set(key, estimate);
            return estimate;
          } catch {
            // Ignore files that fail to read; the bar still shows the paths.
            return 0;
          }
        }),
      );

      if (!cancelled) {
        setPinnedTokenEstimate(totals.reduce((sum, value) => sum + value, 0));
      }
    };

    void estimateTokens();

    return () => {
      cancelled = true;
    };
  }, [pinnedFiles, projectId]);

  const hasQueuedDraft = queuedMessages.length > 0;
  const canQueueDraft = isLoading && Boolean(input.trim() || attachedFiles.length > 0);
  const submitHint = canQueueDraft
    ? hasQueuedDraft
      ? t('input.hintText.updateQueued', { defaultValue: 'Enter to update queued message' })
      : t('input.hintText.queue', { defaultValue: 'Enter to queue your next message' })
    : sendByCtrlEnter
      ? t('input.hintText.ctrlEnter')
      : t('input.hintText.enter');
  const submitAriaLabel = canQueueDraft
    ? hasQueuedDraft
      ? t('input.queue.update', { defaultValue: 'Update queued message' })
      : t('input.queue.sendNext', { defaultValue: 'Queue next message' })
    : isLoading
      ? t('input.stop')
      : t('input.send');

  return (
    <div className="oc-composer chat-composer-shell relative flex-shrink-0 px-2 pb-2 pt-0 sm:px-4 sm:pb-4 md:px-4 md:pb-6">
      {!hasPendingPermissions && (
        <div className="pointer-events-none absolute bottom-full left-1/2 z-10 w-[calc(100%-1rem)] max-w-[54.25rem] -translate-x-1/2 translate-y-px bg-transparent sm:w-[calc(100%-2rem)]">
          <ActivityIndicator activity={activity} onAbort={onAbortSession} isInputFocused={isInputFocused} projectId={selectedProject?.projectId} />
        </div>
      )}

      {pendingPermissionRequests.length > 0 && (
        <div className="sticky bottom-0 z-30 mx-auto mb-3 max-w-[54.25rem]">
          <PermissionRequestsBanner
            pendingPermissionRequests={pendingPermissionRequests}
            handlePermissionDecision={handlePermissionDecision}
            handleGrantToolPermission={handleGrantToolPermission}
            provider={provider}
          />
        </div>
      )}

      {offlineQueue && offlineQueue.length > 0 && (
        <OfflineQueueCard
          count={offlineQueue.length}
          onClear={onClearOfflineQueue}
        />
      )}

      {offlineToast && (
        <div
          role="status"
          aria-live="polite"
          className="settings-content-enter mx-auto mb-2 flex max-w-[54.25rem] items-center justify-between rounded-xl border border-primary/25 bg-primary/[0.08] px-3 py-2 text-xs text-primary"
        >
          <span>{offlineToast}</span>
        </div>
      )}

      {queuedMessages.map((message) => (
        <QueuedMessageCard
          key={message.id}
          message={{
            id: message.id,
            content: message.content,
            attachmentCount: Array.isArray(message.options?.attachments)
              ? message.options.attachments.length
              : 0,
            status: message.status === 'failed' ? 'failed' : 'queued',
          }}
          isSending={message.status === 'sending'}
          onSendNow={() => onSendQueuedNow(message.id)}
          onEdit={() => onEditQueuedMessage(message)}
          onDelete={() => onDeleteQueuedMessage(message.id)}
        />
      ))}

      {!hasQuestionPanel && (
        <div className="mx-auto max-w-[54.25rem]">
          <div className="relative">
        {showMentionDropdown && filteredMentions.length > 0 && (
          <div
            ref={mentionDropdownRef}
            className="absolute bottom-full left-0 right-0 z-50 mb-2 max-h-48 overflow-y-auto overscroll-contain rounded-xl border border-border/50 bg-card/95 shadow-lg backdrop-blur-md [-webkit-overflow-scrolling:touch]"
            style={{ WebkitOverflowScrolling: 'touch' }}
          >
            {filteredMentions.map((mention, index) => (
              <div
                key={`${mention.type}-${mention.id}`}
                ref={index === selectedMentionIndex ? selectedMentionRef : undefined}
                className={`flex min-h-[44px] cursor-pointer touch-manipulation items-center border-b border-border/30 px-4 py-2.5 last:border-b-0 ${
                  index === selectedMentionIndex
                    ? 'bg-primary/8 text-primary'
                    : 'text-foreground hover:bg-accent/50'
                }`}
                onMouseDown={(event) => {
                  event.preventDefault();
                  event.stopPropagation();
                }}
                onClick={(event) => {
                  event.preventDefault();
                  event.stopPropagation();
                  onSelectMention(mention);
                }}
              >
                <div className="flex w-full min-w-0 items-center gap-2.5">
                  <span className="flex h-7 w-7 shrink-0 items-center justify-center rounded-md border border-border/40 bg-muted/40">
                    {mention.type === 'file' && (
                      <FileText className="h-4 w-4 text-muted-foreground" aria-hidden="true" />
                    )}
                    {mention.type === 'session' && (
                      <MessageSquare className="h-4 w-4 text-primary" aria-hidden="true" />
                    )}
                    {mention.type === 'task' && (
                      <ListTodo className="h-4 w-4 text-amber-500" aria-hidden="true" />
                    )}
                  </span>
                  <div className="min-w-0 flex-1">
                    <div className="truncate text-sm font-medium leading-tight">{mention.title}</div>
                    {mention.subtitle && (
                      <div className="mt-0.5 truncate font-mono text-xs text-muted-foreground">
                        {mention.subtitle}
                      </div>
                    )}
                  </div>
                  <span className="ml-1 shrink-0 rounded border border-border/40 bg-muted/50 px-1.5 py-0.5 text-[10px] font-semibold uppercase tracking-wider text-muted-foreground">
                    {mention.type}
                  </span>
                </div>
              </div>
            ))}
          </div>
        )}

        <CommandMenu
          commands={filteredCommands}
          selectedIndex={selectedCommandIndex}
          onSelect={onCommandSelect}
          onClose={onCloseCommandMenu}
          position={commandMenuPosition}
          isOpen={isCommandMenuOpen}
          frequentCommands={frequentCommands}
        />

        <PromptInput
          onSubmit={onSubmit as (event: FormEvent<HTMLFormElement>) => void}
          status={isLoading ? 'streaming' : 'ready'}
          className={[
            isTextareaExpanded ? 'chat-input-expanded' : '',
            hasActivityIndicator ? 'rounded-t-none' : '',
          ].filter(Boolean).join(' ')}
          {...getRootProps()}
        >
          {isDragActive && (
            <div className="absolute inset-0 z-50 flex items-center justify-center rounded-2xl border-2 border-dashed border-primary/50 bg-primary/15">
              <div className="rounded-xl border border-border/30 bg-card p-4 shadow-lg">
                <svg className="mx-auto mb-2 h-8 w-8 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"
                  />
                </svg>
                <p className="text-sm font-medium">Drop files here</p>
              </div>
            </div>
          )}

          {attachedFiles.length > 0 && (
            <PromptInputHeader>
              <div className="oc-attachments">
                <div className="flex flex-wrap gap-1.5">
                  {attachedFiles.map((file, index) => (
                    <ComposerAttachment
                      key={`${file.name}-${file.lastModified}-${index}`}
                      file={file}
                      onRemove={() => onRemoveAttachment(index)}
                      uploadProgress={uploadingFiles.get(file.name)}
                      error={fileErrors.get(file.name)}
                    />
                  ))}
                </div>
              </div>
            </PromptInputHeader>
          )}

          <input {...getInputProps()} />
          <input
            ref={cameraInputRef}
            type="file"
            accept="image/*"
            capture="environment"
            className="hidden"
            onChange={handleCameraChange}
          />

          {pinnedFiles.length > 0 && (
            <div className="px-3 pt-3">
              <PinnedFilesBar
                files={pinnedFiles}
                tokenEstimate={pinnedTokenEstimate}
                onUnpin={unpinFile}
                onFileOpen={onFileOpen}
              />
            </div>
          )}

          <PromptInputBody>
            <span aria-hidden="true" className="oc-input-caret">&gt;</span>
            <div ref={inputHighlightRef} aria-hidden="true" className="pointer-events-none absolute inset-0 overflow-hidden rounded-xl">
              <div className="chat-input-placeholder block w-full whitespace-pre-wrap break-words px-4 py-2 pl-7 text-sm leading-6 text-transparent">
                {renderInputWithMentions(input)}
              </div>
            </div>

            <PromptInputTextarea
              ref={textareaRef}
              dir="auto"
              className="pl-7"
              value={input}
              onChange={onInputChange}
              onClick={onTextareaClick}
              onKeyDown={onTextareaKeyDown}
              onPaste={onTextareaPaste}
              onScroll={(event) => onTextareaScrollSync(event.target as HTMLTextAreaElement)}
              onFocus={() => {
                onInputFocusChange?.(true);
                if (typeof window !== 'undefined' && ('ontouchstart' in window || (typeof navigator !== 'undefined' && navigator.maxTouchPoints > 0))) {
                  requestAnimationFrame(() => {
                    if (window.scrollY !== 0 || window.scrollX !== 0) {
                      window.scrollTo(0, 0);
                    }
                  });
                }
              }}
              onBlur={() => onInputFocusChange?.(false)}
              onInput={onTextareaInput}
              placeholder={placeholder}
            />
        </PromptInputBody>

        <PromptInputFooter className="flex-wrap gap-2">
          <PromptInputTools className="min-w-0 shrink-0">
            <PromptInputButton
              tooltip={{ content: t('input.moreTools', { defaultValue: 'More tools' }) }}
              onClick={() => setIsMobileToolsOpen(true)}
              aria-label="More tools"
              className="flex sm:hidden h-8 w-8 items-center justify-center rounded-lg border border-border/60 bg-muted/40"
            >
              <Plus className="h-4 w-4 text-foreground" />
            </PromptInputButton>

            <PromptInputButton
              tooltip={{ content: t('input.attachFiles') }}
              onClick={openAttachmentPicker}
              aria-label={t('input.attachFiles')}
              className="hidden sm:inline-flex"
            >
              <PaperclipIcon />
            </PromptInputButton>

            {autoReadSessionId && (
              <PromptInputButton
                tooltip={{
                  content: autoReadArmed
                    ? t('voice.autoReadOn', { defaultValue: 'Read replies aloud: on' })
                    : t('voice.autoReadOff', { defaultValue: 'Read replies aloud: off' }),
                }}
                onClick={handleToggleAutoRead}
                aria-label={t('voice.autoRead', { defaultValue: 'Read replies aloud' })}
                aria-pressed={autoReadArmed}
                className="hidden sm:inline-flex"
              >
                <AudioLines className={autoReadArmed ? 'text-primary' : undefined} />
              </PromptInputButton>
            )}

            <CheckpointButton
              hasCheckpoint={hasCheckpoint}
              isCreatingCheckpoint={isCreatingCheckpoint}
              undoState={undoState}
              onUndo={onUndoLastAiRun}
              error={checkpointError}
              className="hidden sm:inline-flex"
            />

          </PromptInputTools>

          <div className="ml-auto flex min-w-0 flex-wrap items-center justify-end gap-1.5 sm:gap-2 [&>*]:min-w-0">
            <div
              className={`oc-submit-hint hidden min-w-0 max-w-56 truncate text-xs text-muted-foreground/50 transition-opacity duration-200 lg:inline-block ${
                input.trim() && !canQueueDraft && !sendByCtrlEnter ? 'opacity-0' : 'opacity-100'
              }`}
            >
              {submitHint}
            </div>

            <ComposerModelMenu
              effort={effort}
              effortOptions={availableEffortOptions}
              onSelectEffort={onSelectEffort}
              model={model}
              modelOptions={availableModelOptions}
              onSelectModel={onSelectModel}
              onRefreshModels={onRefreshProviderModels}
              modelsLoading={modelsLoading}
              provider={provider as LLMProvider}
            />

            <ComposerPermissionMenu
              permissionMode={permissionMode}
              permissionModes={availablePermissionModes}
              onSelectPermissionMode={onSelectPermissionMode}
              providerLabel={providerLabel}
              autoContinueTasks={autoContinueTasks}
              onToggleAutoContinueTasks={onToggleAutoContinueTasks}
            />

            <PromptInputSubmit
              onClick={
                canQueueDraft
                  ? (e: MouseEvent<HTMLButtonElement>) => {
                      e.preventDefault();
                      onSubmit(e);
                    }
                  : isLoading
                    ? onAbortSession
                    : undefined
              }
              disabled={
                isLoading ? false : !input.trim() && attachedFiles.length === 0
              }
              aria-label={submitAriaLabel}
              title={submitAriaLabel}
              className="h-10 w-10 sm:h-10 sm:w-10"
            >
              {canQueueDraft ? (
                <ArrowUpIcon className="h-4 w-4" />
              ) : undefined}
            </PromptInputSubmit>
          </div>
        </PromptInputFooter>
      </PromptInput>

      <MobileComposerActionSheet
        isOpen={isMobileToolsOpen}
        onOpenChange={setIsMobileToolsOpen}
        onAttachFiles={openAttachmentPicker}
        onTakePhoto={() => cameraInputRef.current?.click()}
        hasAutoRead={Boolean(autoReadSessionId)}
        autoReadArmed={autoReadArmed}
        onToggleAutoRead={handleToggleAutoRead}
        slashCommandsCount={slashCommandsCount}
        onToggleCommands={onToggleCommandMenu}
        hasCheckpoint={hasCheckpoint}
        isCreatingCheckpoint={isCreatingCheckpoint}
        onUndoCheckpoint={onUndoLastAiRun}
        tokenUsage={tokenBudget}
        onShowTokenUsage={onShowTokenUsage}
        hasInput={hasInput}
        onClearInput={onClearInput}
      />
          </div>
        </div>
      )}
    </div>
  );
}

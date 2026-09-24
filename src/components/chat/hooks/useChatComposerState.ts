import { useCallback, useEffect, useRef, useState } from 'react';
import type {
  ChangeEvent,
  ClipboardEvent,
  Dispatch,
  FormEvent,
  KeyboardEvent,
  MouseEvent,
  SetStateAction,
  TouchEvent,
} from 'react';
import { useDropzone } from 'react-dropzone';

import { authenticatedFetch, api } from '../../../utils/api';
import type { MarkSessionProcessing, SessionActivityMap } from '../../../hooks/useSessionProtection';
import { grantClaudeToolPermission } from '../utils/chatPermissions';
import {
  flushOfflineMessages,
  readOfflineQueue,
  safeLocalStorage,
  writeOfflineQueue,
  type QueuedOfflineMessage,
  type QueuedSendOptions,
} from '../utils/chatStorage';
import type {
  ChatAttachment,
  ChatMessage,
  PendingPermissionRequest,
  PermissionMode,
  SessionEstablishedContext,
} from '../types/types';
import type { Project, ProjectSession, LLMProvider, ProviderModelOption } from '../../../types/app';
import { escapeRegExp } from '../utils/chatFormatting';
import { collectPastedFiles } from '../utils/clipboardFiles';
import { getProviderSettingsKey } from '../../../utils/providerSettings';

import { useMentions } from './useMentions';
import { type SlashCommand, useSlashCommands } from './useSlashCommands';
import { useMessageQueue, type ServerQueuedMessage } from './useMessageQueue';
import { usePinnedFiles } from './usePinnedFiles';

interface UseChatComposerStateArgs {
  selectedProject: Project | null;
  selectedSession: ProjectSession | null;
  currentSessionId: string | null;
  provider: LLMProvider;
  permissionMode: PermissionMode | string;
  cyclePermissionMode: () => void;
  resolvePermissionModeForProvider: (provider: LLMProvider, requestedMode: PermissionMode | string) => PermissionMode;
  /**
   * Model every send and command carries: the open session's model when there
   * is one, otherwise the user's per-provider selection.
   */
  currentProviderModel: string;
  currentProviderEffort: string;
  isLoading: boolean;
  processingSessions?: SessionActivityMap;
  canAbortSession: boolean;
  tokenBudget: Record<string, unknown> | null;
  sendMessage: (message: unknown) => boolean;
  sendByCtrlEnter?: boolean;
  isConnected?: boolean;
  onSessionProcessing?: MarkSessionProcessing;
  /**
   * Invoked with the freshly allocated session id when the user sends the
   * first message of a brand-new conversation. The backend allocates the id
   * via POST /api/providers/sessions BEFORE the websocket send, so the id is
   * stable for the conversation's whole lifetime — the consumer navigates to
   * /session/:id and records it as the current session.
   */
  onSessionEstablished?: (sessionId: string, context: SessionEstablishedContext) => void;
  onInputFocusChange?: (focused: boolean) => void;
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  onShowSettings?: () => void;
  scrollToBottom: () => void;
  addMessage: (msg: ChatMessage, targetSessionId?: string) => void;
  setIsUserScrolledUp: (isScrolledUp: boolean) => void;
  setPendingPermissionRequests: Dispatch<SetStateAction<PendingPermissionRequest[]>>;
  /**
   * Awaited immediately before a turn is sent to the provider. Used by the
   * chat view to snapshot the working tree so the AI run can be undone.
   * Failures must be swallowed by the callback — they never block the send.
   */
  onBeforeSend?: () => Promise<void>;
}

interface CommandExecutionResult {
  type: 'builtin' | 'custom';
  action?: string;
  data?: any;
  content?: string;
  hasBashCommands?: boolean;
  hasFileIncludes?: boolean;
}

export type ModelCommandData = {
  current?: {
    provider?: string;
    providerLabel?: string;
    model?: string;
  };
  available?: Partial<Record<LLMProvider, string[]>>;
  availableModels?: string[];
  availableOptions?: ProviderModelOption[];
  defaultModel?: string;
};

export type CostCommandData = {
  tokenUsage?: {
    used?: number;
    total?: number;
  };
  tokenBreakdown?: {
    input?: number;
    output?: number;
    cacheRead?: number;
    cacheCreation?: number;
  };
  costUsd?: number;
  provider?: string;
  model?: string;
  unsupported?: boolean;
  message?: string;
};

export type StatusCommandData = {
  version?: string;
  packageName?: string;
  uptime?: string;
  model?: string;
  provider?: string;
  nodeVersion?: string;
  platform?: string;
  pid?: number;
  memoryUsage?: {
    rssMb?: number;
    heapUsedMb?: number;
    heapTotalMb?: number;
  };
};

export type HelpCommandData = {
  content?: string;
  format?: string;
  commands?: Array<{
    name: string;
    description?: string;
    namespace?: string;
  }>;
};

export type CommandModalKind = 'help' | 'models' | 'cost' | 'status';

export type CommandModalPayload = {
  kind: CommandModalKind;
  data: HelpCommandData | ModelCommandData | CostCommandData | StatusCommandData;
};

const createFakeSubmitEvent = () => {
  return { preventDefault: () => undefined } as unknown as FormEvent<HTMLFormElement>;
};

const MAX_ATTACHMENT_COUNT = 10;
const MAX_ATTACHMENT_SIZE = 10 * 1024 * 1024;

const isImageAttachment = (attachment: ChatAttachment) => {
  if (attachment.mimeType?.startsWith('image/')) return true;
  return /\.(gif|jpe?g|png|svg|webp)$/i.test(attachment.path || attachment.name || '');
};

const uploadAttachmentFiles = async (files: File[]): Promise<unknown[]> => {
  if (files.length === 0) {
    return [];
  }

  const formData = new FormData();
  files.forEach((file) => {
    formData.append('files', file);
  });

  const response = await authenticatedFetch('/api/assets/files', {
    method: 'POST',
    headers: {},
    body: formData,
  });

  if (!response.ok) {
    const body = await response.json().catch(() => null);
    throw new Error(body?.error || 'Failed to upload files');
  }

  const result = await response.json();
  if (!Array.isArray(result.attachments) || result.attachments.length !== files.length) {
    throw new Error('File upload returned an incomplete result');
  }
  return result.attachments;
};

export type QueuedDraft = {
  content: string;
  /** Browser files retained while this composer stays mounted, for editing. */
  attachments: File[];
  /** JSON-safe descriptors uploaded when the message is queued. */
  uploadedAttachments?: unknown[];
  /**
   * Send options snapshotted at queue time. Persisted with the draft so the
   * app-level auto-send can dispatch the message with the right model and
   * permission settings while another session is being viewed.
   */
  options?: QueuedSendOptions;
};

const getNotificationSessionSummary = (
  selectedSession: ProjectSession | null,
  fallbackInput: string,
): string | null => {
  const sessionSummary = selectedSession?.summary || selectedSession?.name || selectedSession?.title;
  if (typeof sessionSummary === 'string' && sessionSummary.trim()) {
    const normalized = sessionSummary.replace(/\s+/g, ' ').trim();
    return normalized.length > 80 ? `${normalized.slice(0, 77)}...` : normalized;
  }

  const normalizedFallback = fallbackInput.replace(/\s+/g, ' ').trim();
  if (!normalizedFallback) {
    return null;
  }

  return normalizedFallback.length > 80 ? `${normalizedFallback.slice(0, 77)}...` : normalizedFallback;
};

export function useChatComposerState({
  selectedProject,
  selectedSession,
  currentSessionId,
  provider,
  permissionMode,
  cyclePermissionMode,
  resolvePermissionModeForProvider,
  currentProviderModel,
  currentProviderEffort,
  isLoading,
  processingSessions,
  canAbortSession,
  tokenBudget,
  sendMessage,
  sendByCtrlEnter,
  isConnected,
  onSessionProcessing,
  onSessionEstablished,
  onInputFocusChange,
  onFileOpen,
  onShowSettings,
  scrollToBottom,
  addMessage,
  setIsUserScrolledUp,
  setPendingPermissionRequests,
  onBeforeSend,
}: UseChatComposerStateArgs) {
  const [input, setInput] = useState(() => {
    if (typeof window === 'undefined') {
      return '';
    }
    const boundSessionId = selectedSession?.id || currentSessionId;
    if (boundSessionId) {
      // Session-bound composers keep a per-session draft so typed text
      // survives reloads without leaking into sibling sessions or panes.
      return safeLocalStorage.getItem(`draft_input_session_${boundSessionId}`) || '';
    }
    if (selectedProject) {
      // Draft inputs are keyed by the DB projectId so per-project drafts
      // survive display-name changes.
      return safeLocalStorage.getItem(`draft_input_${selectedProject.projectId}`) || '';
    }
    return '';
  });
  const [attachedFiles, setAttachedFiles] = useState<File[]>([]);
  const [uploadingFiles, setUploadingFiles] = useState<Map<string, number>>(new Map());
  const [fileErrors, setFileErrors] = useState<Map<string, string>>(new Map());
  const [autoContinueTasks, setAutoContinueTasks] = useState(() => {
    try {
      const v = safeLocalStorage.getItem('chat-auto-continue-tasks');
      return v === 'true';
    } catch {
      return false;
    }
  });
  const [isTextareaExpanded, setIsTextareaExpanded] = useState(false);
  const [commandModalPayload, setCommandModalPayload] = useState<CommandModalPayload | null>(null);
  // Multi-account: pinned into POST /api/providers/sessions for a brand-new
  // chat; NULL lets the backend fall back to the provider's default account.
  const [selectedAccountId, setSelectedAccountId] = useState<string | null>(null);
  const previousProviderRef = useRef(provider);

  const textareaRef = useRef<HTMLTextAreaElement>(null);
  const inputHighlightRef = useRef<HTMLDivElement>(null);
  const textareaLineHeightRef = useRef<number | null>(null);
  const lastAutosizedInputRef = useRef<string | null>(null);
  const handleSubmitRef = useRef<
    ((
      event: FormEvent<HTMLFormElement> | MouseEvent | TouchEvent | KeyboardEvent<HTMLTextAreaElement>,
      queuedSubmission?: QueuedDraft,
    ) => Promise<void>) | null
  >(null);
  const inputValueRef = useRef(input);
  const selectedProjectId = selectedProject?.projectId;
  // Prefer the stable backend-allocated id (selectedSession.id) but fall back
  // to currentSessionId for a just-established session that hasn't been
  // handed back to the parent's `selectedSession` prop yet.
  const sessionKey = selectedSession?.id || currentSessionId || null;
  const sessionKeyRef = useRef(sessionKey);
  // Draft persistence is scoped per pane: two new-chat tiles in the same
  // project must not overwrite each other's draft, and a session-bound
  // composer must not clobber the new-chat draft at all. The pane id rides on
  // the split-grid tile via data-pane-id; when it can't be resolved (tests,
  // non-split hosts) we fall back to the legacy project-scoped key.
  const draftStorageKeyRef = useRef<{ projectId: string; key: string } | null>(null);
  const getComposerPaneId = useCallback((): string | null => {
    return textareaRef.current?.closest('[data-pane-id]')?.getAttribute('data-pane-id') ?? null;
  }, []);
  const getDraftStorageKey = useCallback((): string | null => {
    if (!selectedProjectId) {
      return null;
    }
    if (draftStorageKeyRef.current?.projectId !== selectedProjectId) {
      const paneId = getComposerPaneId();
      draftStorageKeyRef.current = {
        projectId: selectedProjectId,
        key: paneId ? `draft_input_${selectedProjectId}_${paneId}` : `draft_input_${selectedProjectId}`,
      };
    }
    return draftStorageKeyRef.current.key;
  }, [selectedProjectId, getComposerPaneId]);
  // The draft key that actually owns this composer's text right now: the
  // per-session key when bound, the pane/project key for draft panes.
  const getActiveDraftKey = useCallback((): string | null => {
    const boundSessionId = sessionKeyRef.current;
    return boundSessionId ? `draft_input_session_${boundSessionId}` : getDraftStorageKey();
  }, [getDraftStorageKey]);
  const processingSessionsRef = useRef<SessionActivityMap | undefined>(processingSessions);
  const isLoadingRef = useRef(isLoading);
  sessionKeyRef.current = sessionKey;
  processingSessionsRef.current = processingSessions;
  isLoadingRef.current = isLoading;

  // Files pinned in the composer are merged into the prompt text at send
  // time — the backend relays `content` verbatim and pinned paths are
  // project files, not uploaded attachments.
  const { pinnedFiles } = usePinnedFiles(selectedProjectId);

  // Attachment descriptors restored from a queued message being edited. They
  // were already uploaded before enqueueing, so the next submit merges them
  // without a second upload.
  const [restoredUploadedAttachments, setRestoredUploadedAttachments] = useState<ChatAttachment[]>([]);

  // Outbound messages are held in the server-side queue, so a queued send
  // survives a page reload or a switch to another device and is dispatched
  // even after the tab is closed. This hook mirrors that queue for the UI.
  const messageQueue = useMessageQueue(sessionKey);

  // Offline-queue entries are stored under the project, but each one belongs
  // to the pane (or, for entries written before pane tagging, the session)
  // that queued it — split-view tiles of one project must not display, flush,
  // or clear each other's pending sends. Entries whose pane is gone, and
  // session-less legacy entries, are project-owned so any pane can still
  // deliver them.
  const isOwnOfflineMessage = useCallback(
    (message: QueuedOfflineMessage) => {
      if (message.paneId) {
        if (message.paneId === getComposerPaneId()) {
          return true;
        }
        if (typeof document === 'undefined') {
          return true;
        }
        const paneMounted = Array.from(document.querySelectorAll('[data-pane-id]')).some(
          (el) => el.getAttribute('data-pane-id') === message.paneId,
        );
        return !paneMounted;
      }
      if (message.sessionId) {
        return message.sessionId === sessionKey;
      }
      return true;
    },
    [getComposerPaneId, sessionKey],
  );

  const [offlineQueue, setOfflineQueue] = useState<QueuedOfflineMessage[]>(() => {
    if (typeof window === 'undefined' || !selectedProjectId) {
      return [];
    }
    return readOfflineQueue(selectedProjectId).filter(isOwnOfflineMessage);
  });
  const [offlineToast, setOfflineToast] = useState<string | null>(null);

  useEffect(() => {
    if (selectedProjectId) {
      setOfflineQueue(readOfflineQueue(selectedProjectId).filter(isOwnOfflineMessage));
    } else {
      setOfflineQueue([]);
    }
  }, [selectedProjectId, isOwnOfflineMessage]);

  useEffect(() => {
    if (!offlineToast) return;
    const timer = setTimeout(() => {
      setOfflineToast(null);
    }, 4000);
    return () => clearTimeout(timer);
  }, [offlineToast]);

  const flushOfflineQueue = useCallback(async () => {
    if (!selectedProjectId) return;
    const storedQueue = readOfflineQueue(selectedProjectId);
    const ownQueue = storedQueue.filter(isOwnOfflineMessage);
    if (ownQueue.length === 0) return;

    const { sent, remaining: remainingOwn } = await flushOfflineMessages(ownQueue, {
      send: (sessionId, msg) =>
        sendMessage({
          type: 'chat.send',
          sessionId,
          content: msg.content,
          options: msg.options ?? {},
        }),
      createSession: async (msg) => {
        const response = await authenticatedFetch('/api/providers/sessions', {
          method: 'POST',
          body: JSON.stringify({
            provider,
            projectPath: selectedProject?.fullPath || selectedProject?.path || '',
            initialMessage: msg.content,
            ...(selectedAccountId ? { accountId: selectedAccountId } : {}),
          }),
        });
        const body = response.ok ? await response.json() : null;
        return body?.data?.sessionId ?? null;
      },
      // Rebind the pane from the placeholder id so live frames and history
      // line up under the real session.
      onSessionPromoted: (realSessionId, msg) => {
        onSessionEstablished?.(realSessionId, {
          provider,
          project: selectedProject,
          summary: msg.content.trim().slice(0, 50),
        });
      },
      // Entries leave storage only at the moment they are sent — a reload
      // during the flush replays them instead of dropping the batch, and a
      // sibling pane flushing the same orphan entries cannot send them twice.
      stillQueued: (msg) =>
        readOfflineQueue(selectedProjectId).some((m) => m.id === msg.id),
      claim: (msg) => {
        const fresh = readOfflineQueue(selectedProjectId);
        if (!fresh.some((m) => m.id === msg.id)) return false;
        writeOfflineQueue(
          selectedProjectId,
          fresh.filter((m) => m.id !== msg.id),
        );
        return true;
      },
      requeue: (msg) => {
        writeOfflineQueue(selectedProjectId, [...readOfflineQueue(selectedProjectId), msg]);
      },
    });

    for (const { sessionId } of sent) {
      onSessionProcessing?.(sessionId, {
        statusText: null,
        canInterrupt: true,
      });
    }
    const sentCount = sent.length;

    // Storage was maintained per entry by claim/requeue — only the pane's
    // view state needs the retained list.
    setOfflineQueue(remainingOwn);

    if (sentCount > 0) {
      setOfflineToast(
        sentCount === 1
          ? '1 message sent automatically after reconnecting'
          : `${sentCount} messages sent automatically after reconnecting`,
      );
    }
  }, [selectedProjectId, selectedProject, provider, selectedAccountId, sendMessage, onSessionProcessing, onSessionEstablished, isOwnOfflineMessage]);

  useEffect(() => {
    // navigator.onLine guards the flush when the socket outlives the network
    // drop (offline emulation, captive portals): the WS may stay open while
    // requests still fail.
    const browserOnline = typeof navigator === 'undefined' || navigator.onLine !== false;
    if (isConnected && browserOnline && offlineQueue.length > 0) {
      void flushOfflineQueue();
    }
  }, [isConnected, offlineQueue.length, flushOfflineQueue]);

  // `online` fires on network restore even when the socket never dropped —
  // without it, a queue parked during a no-WS-drop outage never flushes.
  useEffect(() => {
    const onOnline = () => {
      void flushOfflineQueue();
    };
    window.addEventListener('online', onOnline);
    return () => window.removeEventListener('online', onOnline);
  }, [flushOfflineQueue]);

  const clearOfflineQueueState = useCallback(() => {
    if (selectedProjectId) {
      // Clear only this pane's entries — sibling panes keep theirs.
      writeOfflineQueue(
        selectedProjectId,
        readOfflineQueue(selectedProjectId).filter((message) => !isOwnOfflineMessage(message)),
      );
    }
    setOfflineQueue([]);
  }, [selectedProjectId, isOwnOfflineMessage]);

  const handleBuiltInCommand = useCallback(
    (result: CommandExecutionResult) => {
      const { action, data } = result;
      switch (action) {
        case 'help':
          setCommandModalPayload({
            kind: 'help',
            data: (data || {}) as HelpCommandData,
          });
          break;

        case 'models':
          setCommandModalPayload({
            kind: 'models',
            data: (data || {}) as ModelCommandData,
          });
          break;

        case 'cost': {
          setCommandModalPayload({
            kind: 'cost',
            data: (data || {}) as CostCommandData,
          });
          break;
        }

        case 'status': {
          setCommandModalPayload({
            kind: 'status',
            data: (data || {}) as StatusCommandData,
          });
          break;
        }

        case 'memory':
          if (data.error) {
            addMessage({
              type: 'assistant',
              content: `Warning: ${data.message}`,
              timestamp: Date.now(),
            });
          } else {
            addMessage({
              type: 'assistant',
              content: `${data.message}\n\nPath: \`${data.path}\``,
              timestamp: Date.now(),
            });
            if (data.exists && onFileOpen) {
              onFileOpen(data.path);
            }
          }
          break;

        case 'config':
          onShowSettings?.();
          break;

        default:
          console.warn('Unknown built-in command action:', action);
      }
    },
    [onFileOpen, onShowSettings, addMessage],
  );

  const closeCommandModal = useCallback(() => {
    setCommandModalPayload(null);
  }, []);

  const handleCustomCommand = useCallback(async (result: CommandExecutionResult) => {
    const { content, hasBashCommands } = result;

    if (hasBashCommands) {
      const confirmed = window.confirm(
        'This command contains bash commands that will be executed. Do you want to proceed?',
      );
      if (!confirmed) {
        addMessage({
          type: 'assistant',
          content: 'Command execution cancelled',
          timestamp: Date.now(),
        });
        return;
      }
    }

    const commandContent = content || '';
    setInput(commandContent);
    inputValueRef.current = commandContent;

    // Defer submit to next tick so the command text is reflected in UI before dispatching.
    setTimeout(() => {
      if (handleSubmitRef.current) {
        handleSubmitRef.current(createFakeSubmitEvent());
      }
    }, 0);
  }, [addMessage]);

  const executeCommand = useCallback(
    async (command: SlashCommand, rawInput?: string, options?: { preserveInput?: boolean }) => {
      if (!command || !selectedProject) {
        return;
      }

      try {
        const effectiveInput = rawInput ?? input;
        const commandMatch = effectiveInput.match(new RegExp(`${escapeRegExp(command.name)}\\s*(.*)`));
        const args =
          commandMatch && commandMatch[1] ? commandMatch[1].trim().split(/\s+/) : [];

        // The `/api/commands/execute` context sends `projectId` now instead of
        // a folder-derived project name; the path is still included verbatim.
        const context = {
          projectPath: selectedProject.fullPath || selectedProject.path,
          projectId: selectedProject.projectId,
          sessionId: currentSessionId || selectedSession?.id || null,
          provider,
          model: currentProviderModel,
          tokenUsage: tokenBudget,
        };

        const response = await authenticatedFetch('/api/commands/execute', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify({
            commandName: command.name,
            commandPath: command.path,
            args,
            context,
          }),
        });

        if (!response.ok) {
          let errorMessage = `Failed to execute command (${response.status})`;
          try {
            const errorData = await response.json();
            errorMessage = errorData?.message || errorData?.error || errorMessage;
          } catch {
            // Ignore JSON parse failures and use fallback message.
          }
          throw new Error(errorMessage);
        }

        const result = (await response.json()) as CommandExecutionResult;
        if (result.type === 'builtin') {
          handleBuiltInCommand(result);
          if (!options?.preserveInput) {
            setInput('');
            inputValueRef.current = '';
          }
        } else if (result.type === 'custom') {
          await handleCustomCommand(result);
        }
      } catch (error) {
        const message = error instanceof Error ? error.message : 'Unknown error';
        console.error('Error executing command:', error);
        addMessage({
          type: 'assistant',
          content: `Error executing command: ${message}`,
          timestamp: Date.now(),
        });
      }
    },
    [
      currentProviderModel,
      currentSessionId,
      handleBuiltInCommand,
      handleCustomCommand,
      input,
      provider,
      selectedProject,
      selectedSession?.id,
      addMessage,
      tokenBudget,
    ],
  );

  // Switching providers invalidates the pick — account rows are provider-scoped.
  useEffect(() => {
    if (previousProviderRef.current !== provider) {
      previousProviderRef.current = provider;
      setSelectedAccountId(null);
    }
  }, [provider]);

  const showCostModal = useCallback(() => {
    executeCommand(
      {
        name: '/cost',
        description: 'Display token usage information',
        namespace: 'builtin',
        metadata: { type: 'builtin' },
      } as SlashCommand,
      '/cost',
      { preserveInput: true },
    );
  }, [executeCommand]);

  const {
    slashCommands,
    slashCommandsCount,
    filteredCommands,
    frequentCommands,
    commandQuery,
    showCommandMenu,
    selectedCommandIndex,
    resetCommandMenuState,
    handleCommandSelect,
    handleToggleCommandMenu,
    handleCommandInputChange,
    handleCommandMenuKeyDown,
  } = useSlashCommands({
    selectedProject,
    provider,
    input,
    setInput,
    textareaRef,
    onExecuteCommand: executeCommand,
  });

  const {
    showMentionDropdown,
    filteredMentions,
    selectedMentionIndex,
    renderInputWithMentions,
    selectMention,
    setCursorPosition,
    handleMentionsKeyDown,
  } = useMentions({
    selectedProject,
    input,
    setInput,
    textareaRef,
  });

  const syncInputOverlayScroll = useCallback((target: HTMLTextAreaElement) => {
    if (!inputHighlightRef.current || !target) {
      return;
    }
    inputHighlightRef.current.scrollTop = target.scrollTop;
    inputHighlightRef.current.scrollLeft = target.scrollLeft;
  }, []);

  const resizeTextarea = useCallback((target: HTMLTextAreaElement) => {
    target.style.height = 'auto';
    const nextHeight = Math.max(22, target.scrollHeight);
    target.style.height = `${nextHeight}px`;

    let lineHeight = textareaLineHeightRef.current;
    if (!lineHeight) {
      lineHeight = parseInt(window.getComputedStyle(target).lineHeight);
      textareaLineHeightRef.current = Number.isFinite(lineHeight) ? lineHeight : 24;
    }

    const expanded = nextHeight > (textareaLineHeightRef.current || 24) * 2;
    setIsTextareaExpanded((previous) => previous === expanded ? previous : expanded);
    lastAutosizedInputRef.current = target.value;
  }, []);

  const handleAttachmentFiles = useCallback((files: File[]) => {
    const validFiles = files.filter((file) => {
      try {
        if (!file || typeof file !== 'object') {
          console.warn('Invalid file object:', file);
          return false;
        }

        if (file.size > MAX_ATTACHMENT_SIZE) {
          const fileName = file.name || 'Unknown file';
          setFileErrors((previous) => {
            const next = new Map(previous);
            next.set(fileName, 'File too large (max 10MB)');
            return next;
          });
          return false;
        }

        return true;
      } catch (error) {
        console.error('Error validating file:', error, file);
        return false;
      }
    });

    if (validFiles.length > 0) {
      setAttachedFiles((previous) => [...previous, ...validFiles].slice(0, MAX_ATTACHMENT_COUNT));
    }
  }, []);

  const handlePaste = useCallback(
    (event: ClipboardEvent<HTMLElement>) => {
      // Every file on the clipboard becomes an attachment — not just images.
      // Text/code/JSON/PDF pastes arrive as file items too, and plain text
      // pastes (kind === 'string') keep their default textarea behavior.
      const pastedFiles = collectPastedFiles(event.clipboardData);
      if (pastedFiles.length > 0) {
        handleAttachmentFiles(pastedFiles);
      }
    },
    [handleAttachmentFiles],
  );

  const { getRootProps, getInputProps, isDragActive, open } = useDropzone({
    maxSize: MAX_ATTACHMENT_SIZE,
    maxFiles: MAX_ATTACHMENT_COUNT,
    onDrop: handleAttachmentFiles,
    noClick: true,
    noKeyboard: true,
  });

  // Snapshot of everything `chat.send` needs beyond the text itself. Built at
  // send time for immediate sends and at queue time for queued ones, so a
  // queued message keeps the provider settings it was composed under even if
  // it is later dispatched outside this composer (app-level auto-send).
  const buildSendOptions = useCallback((currentInput: string): QueuedSendOptions => {
    const getToolsSettings = () => {
      try {
        const settingsKey = getProviderSettingsKey(provider);
        const savedSettings = safeLocalStorage.getItem(settingsKey);
        if (savedSettings) {
          return JSON.parse(savedSettings);
        }
      } catch (error) {
        console.error('Error loading tools settings:', error);
      }

      return {
        allowedTools: [],
        disallowedTools: [],
        skipPermissions: false,
      };
    };

    const toolsSettings = getToolsSettings();

    return {
      model: currentProviderModel,
      effort: currentProviderEffort,
      permissionMode: resolvePermissionModeForProvider(provider, permissionMode),
      toolsSettings,
      skipPermissions: toolsSettings?.skipPermissions || false,
      sessionSummary: getNotificationSessionSummary(selectedSession, currentInput),
      autoContinueTasks,
    };
  }, [
    autoContinueTasks,
    currentProviderEffort,
    currentProviderModel,
    permissionMode,
    provider,
    resolvePermissionModeForProvider,
    selectedSession,
  ]);

  const handleSubmit = useCallback(
    async (
      event: FormEvent<HTMLFormElement> | MouseEvent | TouchEvent | KeyboardEvent<HTMLTextAreaElement>,
      queuedSubmission?: QueuedDraft,
    ) => {
      event.preventDefault();
      const currentInput = queuedSubmission?.content ?? inputValueRef.current;
      const currentAttachments = queuedSubmission?.attachments ?? attachedFiles;
      const previouslyUploadedAttachments = [
        ...restoredUploadedAttachments,
        ...(queuedSubmission?.uploadedAttachments ?? []),
      ];
      if (
        (
          !currentInput.trim()
          && currentAttachments.length === 0
          && previouslyUploadedAttachments.length === 0
        )
        || !selectedProject
      ) {
        return;
      }

      // Pinned files ride inside the prompt text. The block is rebuilt on
      // every send so editing and re-sending a queued message refreshes the
      // pin list instead of stacking a second copy.
      const pinnedFilePaths = pinnedFiles.filter((path) => path.trim());
      const typedInput = pinnedFilePaths.length > 0
        ? currentInput.replace(/^Pinned files:\n(?:- [^\n]*\n?)+/, '')
        : currentInput;
      const messageContent = pinnedFilePaths.length > 0
        ? `Pinned files:\n${pinnedFilePaths.map((path) => `- ${path}`).join('\n')}\n\n${typedInput}`
        : currentInput;

      // A turn is already in flight: persist this message in the server-side
      // queue instead of sending it now. Upload attached files first so the
      // queued record carries durable descriptors the server can dispatch even
      // after the tab is gone.
      if (isLoadingRef.current) {
        const queuedOptions = buildSendOptions(typedInput);
        const queuedSessionKey = sessionKey;
        setInput('');
        inputValueRef.current = '';
        setAttachedFiles([]);
        setRestoredUploadedAttachments([]);
        setUploadingFiles(new Map());
        setFileErrors(new Map());
        resetCommandMenuState();
        setIsTextareaExpanded(false);
        if (textareaRef.current) {
          textareaRef.current.style.height = 'auto';
        }
        // selectedProject is guaranteed by the guard at the top of handleSubmit.
        safeLocalStorage.removeItem(getActiveDraftKey() ?? '');

        let uploadedAttachments: unknown[] = [];
        try {
          uploadedAttachments = await uploadAttachmentFiles(currentAttachments);
        } catch (error) {
          const message = error instanceof Error ? error.message : 'Unknown error';
          console.error('Queued file upload failed:', error);
          // Restore input on failure so the user does not lose their typed message
          setInput(currentInput);
          inputValueRef.current = currentInput;
          safeLocalStorage.setItem(getActiveDraftKey() ?? '', currentInput);
          addMessage({
            type: 'error',
            content: `Failed to upload files: ${message}`,
            timestamp: new Date(),
          });
          return;
        }

        if (queuedSessionKey) {
          try {
            await api.queue.enqueue(queuedSessionKey, {
              content: messageContent,
              options: {
                ...queuedOptions,
                attachments: [...restoredUploadedAttachments, ...uploadedAttachments],
              },
            });
          } catch (error) {
            const message = error instanceof Error ? error.message : 'Unknown error';
            console.error('Failed to queue message:', error);
            setInput(currentInput);
            inputValueRef.current = currentInput;
            safeLocalStorage.setItem(getActiveDraftKey() ?? '', currentInput);
            addMessage({
              type: 'error',
              content: `Failed to queue message: ${message}`,
              timestamp: new Date(),
            });
            return;
          }
        }

        // The upload is asynchronous. If the user changed sessions while it
        // was running, the message still belongs to the session where Queue
        // was pressed — the server queue is keyed by that session id.
        if (queuedSessionKey && sessionKeyRef.current !== queuedSessionKey) {
          return;
        }
        return;
      }

      // Intercept slash commands only when "/" is the first input character.
      // Also accept exact "help" as a convenience alias for users who expect CLI-style help.
      const commandInput = currentInput.trimEnd();
      const isHelpAlias = commandInput.trim().toLowerCase() === 'help';
      if (commandInput.startsWith('/') || isHelpAlias) {
        const firstSpace = commandInput.indexOf(' ');
        const commandName = isHelpAlias
          ? '/help'
          : firstSpace > 0 ? commandInput.slice(0, firstSpace) : commandInput;
        const matchedCommand =
          slashCommands.find((cmd: SlashCommand) => cmd.name === commandName) ||
          (commandName === '/help'
            ? ({
                name: '/help',
                description: 'Show help documentation for Claude Code',
                namespace: 'builtin',
                metadata: { type: 'builtin' },
              } as SlashCommand)
            : undefined);
        if (matchedCommand && matchedCommand.type !== 'skill') {
          executeCommand(matchedCommand, isHelpAlias ? '/help' : commandInput);
          setInput('');
          inputValueRef.current = '';
          setAttachedFiles([]);
          setRestoredUploadedAttachments([]);
          setUploadingFiles(new Map());
          setFileErrors(new Map());
          resetCommandMenuState();
          setIsTextareaExpanded(false);
          if (textareaRef.current) {
            textareaRef.current.style.height = 'auto';
          }
          safeLocalStorage.removeItem(getActiveDraftKey() ?? '');
          return;
        }
      }

      // Clear input, attachments, and draft storage immediately upon submission so the
      // composer resets synchronously on send. This prevents the user from seeing stale
      // text while async operations run, and guarantees that when a new session triggers
      // a ChatInterface remount, the draft is not re-loaded from localStorage.
      setInput('');
      inputValueRef.current = '';
      resetCommandMenuState();
      setAttachedFiles([]);
      setRestoredUploadedAttachments([]);
      setUploadingFiles(new Map());
      setFileErrors(new Map());
      setIsTextareaExpanded(false);
      if (textareaRef.current) {
        textareaRef.current.style.height = 'auto';
      }
      safeLocalStorage.removeItem(getActiveDraftKey() ?? '');

      // New browser files are uploaded unless the queued submission already
      // carried their uploaded descriptors — restored descriptors and freshly
      // uploaded ones merge so nothing is sent twice or dropped.
      let uploadedAttachments = previouslyUploadedAttachments;
      if ((queuedSubmission?.uploadedAttachments?.length ?? 0) === 0 && currentAttachments.length > 0) {
        try {
          uploadedAttachments = [...uploadedAttachments, ...(await uploadAttachmentFiles(currentAttachments))];
        } catch (error) {
          const message = error instanceof Error ? error.message : 'Unknown error';
          console.error('File upload failed:', error);
          // Restore input on failure so the user does not lose their typed message
          setInput(currentInput);
          inputValueRef.current = currentInput;
          safeLocalStorage.setItem(getActiveDraftKey() ?? '', currentInput);
          addMessage({
            type: 'error',
            content: `Failed to upload files: ${message}`,
            timestamp: new Date(),
          });
          return;
        }
      }

      const resolvedProjectPath = selectedProject.fullPath || selectedProject.path || '';
      const sessionSummary = getNotificationSessionSummary(selectedSession, typedInput);

      // The conversation always has a stable backend-allocated session id
      // BEFORE the first websocket send: brand-new chats allocate one here
      // via the session gateway. There is no client-visible session-id
      // handoff later — this id stays valid for the conversation's lifetime.
      let targetSessionId = selectedSession?.id || currentSessionId || null;
      const isOnline = isConnected !== false && (typeof navigator === 'undefined' || navigator.onLine !== false);

      if (!targetSessionId) {
        let createdSessionName = sessionSummary;
        if (!isOnline) {
          targetSessionId = `offline-session-${Date.now()}`;
          onSessionEstablished?.(targetSessionId, {
            provider,
            project: selectedProject,
            summary: createdSessionName || typedInput.trim().slice(0, 50),
          });
        } else {
          try {
            const response = await authenticatedFetch('/api/providers/sessions', {
              method: 'POST',
              body: JSON.stringify({
                provider,
                projectPath: resolvedProjectPath,
                initialMessage: typedInput,
                ...(selectedAccountId ? { accountId: selectedAccountId } : {}),
              }),
            });
            if (!response.ok) {
              throw new Error(`Failed to create session (${response.status})`);
            }
            const body = await response.json();
            targetSessionId = body?.data?.sessionId || null;
            // A blank server name would leave the session unlabeled, so the local
            // summary stays the fallback unless a real name comes back.
            const returnedSessionName = typeof body?.data?.sessionName === 'string'
              ? body.data.sessionName.trim()
              : '';
            if (returnedSessionName) {
              createdSessionName = returnedSessionName;
            }
          } catch (error) {
            const isNetworkOffline = !navigator.onLine || (error instanceof Error && /network|fetch|offline|failed to fetch/i.test(error.message));
            if (isNetworkOffline) {
              targetSessionId = `offline-session-${Date.now()}`;
              onSessionEstablished?.(targetSessionId, {
                provider,
                project: selectedProject,
                summary: createdSessionName || typedInput.trim().slice(0, 50),
              });
            } else {
              const message = error instanceof Error ? error.message : 'Unknown error';
              console.error('Session creation failed:', error);
              setInput(currentInput);
              inputValueRef.current = currentInput;
              safeLocalStorage.setItem(getActiveDraftKey() ?? '', currentInput);
              addMessage({
                type: 'error',
                content: `Failed to start a new session: ${message}`,
                timestamp: new Date(),
              });
              return;
            }
          }

          if (!targetSessionId) {
            setInput(currentInput);
            inputValueRef.current = currentInput;
            safeLocalStorage.setItem(getActiveDraftKey() ?? '', currentInput);
            addMessage({
              type: 'error',
              content: 'Failed to start a new session: no session id returned.',
              timestamp: new Date(),
            });
            return;
          }

          onSessionEstablished?.(targetSessionId, {
            provider,
            project: selectedProject,
            summary: createdSessionName,
          });
        }
      }

      const attachmentRecords = uploadedAttachments as ChatAttachment[];
      const userMessage: ChatMessage = {
        type: 'user',
        content: messageContent,
        images: attachmentRecords.filter(isImageAttachment),
        files: attachmentRecords.filter((attachment) => !isImageAttachment(attachment)),
        timestamp: new Date(),
      };

      addMessage(userMessage, targetSessionId);
      setIsUserScrolledUp(false);

      // Snapshot the working tree before the AI runs so the whole turn can be
      // undone. A failure here must never block the send.
      await onBeforeSend?.();

      const sendOptions = {
        ...(queuedSubmission?.options ?? buildSendOptions(typedInput)),
        attachments: uploadedAttachments,
      };

      let sent = false;
      if (isOnline) {
        try {
          sent = sendMessage({
            type: 'chat.send',
            sessionId: targetSessionId,
            content: messageContent,
            options: sendOptions,
          });
        } catch {
          sent = false;
        }
      }

      if (sent) {
        onSessionProcessing?.(targetSessionId, {
          statusText: null,
          canInterrupt: true,
        });
      } else {
        const offlineItem: QueuedOfflineMessage = {
          id: `offline-msg-${Date.now()}-${Math.random().toString(36).slice(2, 7)}`,
          sessionId: targetSessionId,
          paneId: getComposerPaneId() ?? undefined,
          content: messageContent,
          options: sendOptions,
          attachments: uploadedAttachments,
          createdAt: Date.now(),
        };
        setOfflineQueue((prev) => {
          const next = [...prev, offlineItem];
          if (selectedProjectId) {
            // `next` holds only this pane's entries — merge back entries
            // owned by sibling panes before writing the shared queue.
            const otherEntries = readOfflineQueue(selectedProjectId).filter(
              (message) => !isOwnOfflineMessage(message),
            );
            writeOfflineQueue(selectedProjectId, [...otherEntries, ...next]);
          }
          return next;
        });
      }

      setInput('');
      inputValueRef.current = '';
      resetCommandMenuState();
      setAttachedFiles([]);
      setRestoredUploadedAttachments([]);
      setUploadingFiles(new Map());
      setFileErrors(new Map());
      setIsTextareaExpanded(false);

      if (textareaRef.current) {
        textareaRef.current.style.height = 'auto';
      }

      safeLocalStorage.removeItem(getActiveDraftKey() ?? '');
    },
    [
      selectedSession,
      attachedFiles,
      buildSendOptions,
      currentSessionId,
      executeCommand,
      getComposerPaneId,
      getDraftStorageKey,
      getActiveDraftKey,
      isConnected,
      isOwnOfflineMessage,
      onSessionProcessing,
      onSessionEstablished,
      pinnedFiles,
      provider,
      resetCommandMenuState,
      restoredUploadedAttachments,
      scrollToBottom,
      selectedProject,
      selectedProjectId,
      sendMessage,
      sessionKey,
      addMessage,
      setIsUserScrolledUp,
      slashCommands,
      onBeforeSend,
    ],
  );

  useEffect(() => {
    handleSubmitRef.current = handleSubmit;
  }, [handleSubmit]);

  // Queue actions exposed to the composer. The server drains the queue on its
  // own when the running turn ends, so there is no client-side auto-send to do;
  // these are the user-initiated actions on a queued row.
  const queuedMessages = messageQueue.messages;

  const sendQueuedNow = useCallback(
    async (id: number) => {
      await messageQueue.sendNow(id);
    },
    [messageQueue],
  );

  const editQueuedMessage = useCallback(
    async (message: ServerQueuedMessage) => {
      // The descriptors were uploaded when the message was queued — carry
      // them into the next submit instead of dropping the attachments.
      setRestoredUploadedAttachments(
        Array.isArray(message.options?.attachments)
          ? (message.options.attachments as ChatAttachment[])
          : [],
      );
      setInput((previous) => {
        // An in-progress draft is kept: the queued text appends to it rather
        // than clobbering what the user already typed.
        const next = previous.trim() ? `${previous}\n${message.content}` : message.content;
        inputValueRef.current = next;
        return next;
      });
      await messageQueue.remove(message.id);
      textareaRef.current?.focus();
    },
    [messageQueue],
  );

  const deleteQueuedMessage = useCallback(
    async (id: number) => {
      await messageQueue.remove(id);
    },
    [messageQueue],
  );

  useEffect(() => {
    inputValueRef.current = input;
  }, [input]);

  useEffect(() => {
    // Session-bound composers restore a per-session draft; draft panes restore
    // the pane-scoped project draft.
    const draftKey = sessionKey
      ? `draft_input_session_${sessionKey}`
      : selectedProjectId
        ? getDraftStorageKey()
        : null;
    if (!draftKey) {
      return;
    }
    let savedInput = safeLocalStorage.getItem(draftKey);
    if (!sessionKey && selectedProjectId) {
      // One-time migration: adopt a draft stored under the pre-pane-scoped key,
      // then drop it so sibling panes don't resurrect the same text.
      const legacyKey = `draft_input_${selectedProjectId}`;
      if (savedInput === null && draftKey !== legacyKey) {
        savedInput = safeLocalStorage.getItem(legacyKey);
        if (savedInput !== null) {
          safeLocalStorage.setItem(draftKey, savedInput);
          safeLocalStorage.removeItem(legacyKey);
        }
      }
    }
    const nextInput = savedInput ?? '';
    setInput((previous) => {
      const next = previous === nextInput ? previous : nextInput;
      inputValueRef.current = next;
      return next;
    });
  }, [selectedProjectId, sessionKey, getDraftStorageKey]);

  useEffect(() => {
    const handleRunTask = (event: Event) => {
      const detail = (event as CustomEvent<{ command?: string }>).detail;
      if (detail?.command) {
        // The live event handles it — drop the stashed copy so a later
        // composer mount does not re-apply the same command.
        try {
          window.sessionStorage.removeItem('taskmaster:pending-run-task');
        } catch {
          // Ignore storage errors
        }
        setInput(detail.command);
        inputValueRef.current = detail.command;
        textareaRef.current?.focus();
      }
    };
    window.addEventListener('taskmaster:run-task', handleRunTask);
    return () => window.removeEventListener('taskmaster:run-task', handleRunTask);
  }, [setInput]);

  // 'taskmaster:run-task' fires while the chat view is unmounted on /tasks,
  // so TaskMasterPanel also stashes the command in sessionStorage. The next
  // composer of the same project consumes it here — including session-bound
  // composers that intentionally skip the project-draft restore.
  useEffect(() => {
    if (typeof window === 'undefined' || !selectedProjectId) {
      return;
    }

    let pendingCommand: string | null = null;
    try {
      const raw = window.sessionStorage.getItem('taskmaster:pending-run-task');
      if (!raw) {
        return;
      }
      const pending = JSON.parse(raw) as { projectId?: string; command?: string };
      if (!pending.command || (pending.projectId && pending.projectId !== selectedProjectId)) {
        return;
      }
      window.sessionStorage.removeItem('taskmaster:pending-run-task');
      pendingCommand = pending.command;
    } catch {
      return;
    }

    setInput(pendingCommand);
    inputValueRef.current = pendingCommand;
    textareaRef.current?.focus();
  }, [selectedProjectId, setInput]);

  useEffect(() => {
    const draftKey = sessionKey
      ? `draft_input_session_${sessionKey}`
      : selectedProjectId
        ? getDraftStorageKey()
        : null;
    if (!draftKey) {
      return;
    }
    if (input !== '') {
      safeLocalStorage.setItem(draftKey, input);
      if (!sessionKey && selectedProjectId) {
        // Once the pane-scoped draft exists, the shared project key must not
        // linger — sibling panes would otherwise keep resurrecting it.
        const legacyKey = `draft_input_${selectedProjectId}`;
        if (draftKey !== legacyKey) {
          safeLocalStorage.removeItem(legacyKey);
        }
      }
    } else {
      safeLocalStorage.removeItem(draftKey);
      if (sessionKey && selectedProjectId) {
        // A send that promoted a draft pane leaves its stale pane-scoped copy
        // behind — drop it so the next fresh composer does not resurrect it.
        const paneKey = getDraftStorageKey();
        if (paneKey) {
          safeLocalStorage.removeItem(paneKey);
        }
      }
    }
  }, [input, selectedProjectId, sessionKey, getDraftStorageKey]);

  useEffect(() => {
    safeLocalStorage.setItem('chat-auto-continue-tasks', String(autoContinueTasks));
  }, [autoContinueTasks]);

  useEffect(() => {
    if (!textareaRef.current) {
      return;
    }
    if (lastAutosizedInputRef.current === input) {
      return;
    }
    // Re-run for restored drafts and programmatic input changes. User typing is
    // already resized in onInput, so this avoids doing the same forced layout twice.
    resizeTextarea(textareaRef.current);
  }, [input, resizeTextarea]);

  useEffect(() => {
    if (!textareaRef.current || input.trim()) {
      return;
    }
    textareaRef.current.style.height = 'auto';
    setIsTextareaExpanded(false);
  }, [input]);

  const handleInputChange = useCallback(
    (event: ChangeEvent<HTMLTextAreaElement>) => {
      const newValue = event.target.value;
      const cursorPos = event.target.selectionStart;

      setInput(newValue);
      inputValueRef.current = newValue;
      setCursorPosition(cursorPos);

      if (!newValue.trim()) {
        event.target.style.height = 'auto';
        setIsTextareaExpanded(false);
        resetCommandMenuState();
        return;
      }

      handleCommandInputChange(newValue, cursorPos);
    },
    [handleCommandInputChange, resetCommandMenuState, setCursorPosition],
  );

  const handleKeyDown = useCallback(
    (event: KeyboardEvent<HTMLTextAreaElement>) => {
      if (handleCommandMenuKeyDown(event)) {
        return;
      }

      if (handleMentionsKeyDown(event)) {
        return;
      }

      if (event.key === 'Tab' && !showMentionDropdown && !showCommandMenu) {
        event.preventDefault();
        cyclePermissionMode();
        return;
      }

      if (event.key === 'Enter') {
        if (event.nativeEvent.isComposing) {
          return;
        }

        if ((event.ctrlKey || event.metaKey) && !event.shiftKey) {
          event.preventDefault();
          handleSubmit(event);
        } else if (!event.shiftKey && !event.ctrlKey && !event.metaKey && !sendByCtrlEnter) {
          event.preventDefault();
          handleSubmit(event);
        }
      }
    },
    [
      cyclePermissionMode,
      handleCommandMenuKeyDown,
      handleMentionsKeyDown,
      handleSubmit,
      sendByCtrlEnter,
      showCommandMenu,
      showMentionDropdown,
    ],
  );

  const handleTextareaClick = useCallback(
    (event: MouseEvent<HTMLTextAreaElement>) => {
      setCursorPosition(event.currentTarget.selectionStart);
    },
    [setCursorPosition],
  );

  const handleTextareaInput = useCallback(
    (event: FormEvent<HTMLTextAreaElement>) => {
      const target = event.currentTarget;
      resizeTextarea(target);
      setCursorPosition(target.selectionStart);
      syncInputOverlayScroll(target);
    },
    [resizeTextarea, setCursorPosition, syncInputOverlayScroll],
  );

  const handleClearInput = useCallback(() => {
    setInput('');
    inputValueRef.current = '';
    setRestoredUploadedAttachments([]);
    resetCommandMenuState();
    if (textareaRef.current) {
      textareaRef.current.style.height = 'auto';
      textareaRef.current.focus();
    }
    setIsTextareaExpanded(false);
  }, [resetCommandMenuState]);

  const handleAbortSession = useCallback(() => {
    if (!canAbortSession) {
      return;
    }

    const targetSessionId = selectedSession?.id || currentSessionId || null;
    if (!targetSessionId) {
      console.warn('Abort requested but no session ID is available.');
      return;
    }

    // The backend resolves the provider from the session row, so no provider
    // field is needed here.
    sendMessage({
      type: 'chat.abort',
      sessionId: targetSessionId,
    });
  }, [canAbortSession, currentSessionId, selectedSession?.id, sendMessage]);

  const handleGrantToolPermission = useCallback(
    (suggestion: { entry: string; toolName: string }) => {
      if (!suggestion || provider !== 'claude') {
        return { success: false };
      }
      return grantClaudeToolPermission(suggestion.entry);
    },
    [provider],
  );

  const handlePermissionDecision = useCallback(
    (
      requestIds: string | string[],
      decision: { allow?: boolean; message?: string; rememberEntry?: string | null; updatedInput?: unknown },
    ) => {
      const ids = Array.isArray(requestIds) ? requestIds : [requestIds];
      const validIds = ids.filter(Boolean);
      if (validIds.length === 0) {
        return;
      }

      validIds.forEach((requestId) => {
        sendMessage({
          type: 'chat.permission-response',
          requestId,
          allow: Boolean(decision?.allow),
          updatedInput: decision?.updatedInput,
          message: decision?.message,
          rememberEntry: decision?.rememberEntry,
        });
      });

      setPendingPermissionRequests((previous) =>
        previous.filter((request) => !validIds.includes(request.requestId)),
      );
    },
    [sendMessage, setPendingPermissionRequests],
  );

  const [isInputFocused, setIsInputFocused] = useState(false);

  const handleInputFocusChange = useCallback(
    (focused: boolean) => {
      setIsInputFocused(focused);
      onInputFocusChange?.(focused);
    },
    [onInputFocusChange],
  );

  const onToggleAutoContinueTasks = useCallback(() => {
    setAutoContinueTasks((previous) => !previous);
  }, []);

  return {
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
    onSelectMention: selectMention,
    attachedFiles,
    setAttachedFiles,
    uploadingFiles,
    fileErrors,
    handleAttachmentFiles,
    attachFiles: handleAttachmentFiles,
    getRootProps,
    getInputProps,
    isDragActive,
    openAttachmentPicker: open,
    handleSubmit,
    queuedMessages,
    sendQueuedNow,
    editQueuedMessage,
    deleteQueuedMessage,
    handleInputChange,
    handleKeyDown,
    handlePaste,
    handleTextareaClick,
    handleTextareaInput,
    syncInputOverlayScroll,
    handleClearInput,
    handleAbortSession,
    handlePermissionDecision,
    handleGrantToolPermission,
    handleInputFocusChange,
    isInputFocused,
    autoContinueTasks,
    onToggleAutoContinueTasks,
    selectedAccountId,
    onSelectAccount: setSelectedAccountId,
    commandModalPayload,
    closeCommandModal,
    showCostModal,
    offlineQueue,
    clearOfflineQueue: clearOfflineQueueState,
    flushOfflineQueue,
    offlineToast,
  };
}

import { memo, useMemo, useRef } from 'react';
import { useTranslation } from 'react-i18next';

import LLMProviderLogo from '../../../llm-provider-logo/LLMProviderLogo';
import type {
  ChatMessage,
  ClaudePermissionSuggestion,
  PermissionGrantResult,
  Provider,
} from '../../types/types';
import { formatUsageLimitText, stripProposedPlanEnvelope } from '../../utils/chatFormatting';
import type { Project } from '../../../../types/app';
import { ToolRenderer, ToolErrorDisplay, shouldHideToolResult, getToolConfig, resolveToolName } from '../../tools';
import { Reasoning, ReasoningTrigger, ReasoningContent } from '../../../../shared/view/ui';

import ChatMessageImages from './ChatMessageImages';
import ChatMessageFiles from './ChatMessageFiles';
import { Markdown } from './Markdown';
import MessageCopyControl from './MessageCopyControl';
import MessageSpeakControl from './MessageSpeakControl';
import MessageTaskMasterControl from './MessageTaskMasterControl';
import { HighlightText } from './HighlightText';

type DiffLine = {
  type: string;
  content: string;
  lineNum: number;
};

type MessageComponentProps = {
  message: ChatMessage;
  messageKey?: string;
  prevMessage: ChatMessage | null;
  createDiff: (oldStr: string, newStr: string) => DiffLine[];
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  onShowSettings?: () => void;
  onGrantToolPermission?: (suggestion: ClaudePermissionSuggestion) => PermissionGrantResult | null | undefined;
  showRawParameters?: boolean;
  showThinking?: boolean;
  selectedProject?: Project | null;
  provider: Provider | string;
  searchQuery?: string;
  searchIndex?: number;
  isActiveMatch?: boolean;
};

type InteractiveOption = {
  number: string;
  text: string;
  isSelected: boolean;
};

const COPY_HIDDEN_TOOL_NAMES = new Set(['Bash', 'Edit', 'Write', 'ApplyPatch']);

const MessageComponent = memo(({
  message,
  messageKey,
  prevMessage,
  createDiff,
  onFileOpen,
  showRawParameters,
  showThinking,
  selectedProject,
  provider,
  searchQuery = '',
  searchIndex,
  isActiveMatch,
}: MessageComponentProps) => {
  const { t } = useTranslation('chat');
  const isGrouped = prevMessage && prevMessage.type === message.type &&
    ((prevMessage.type === 'assistant') ||
      (prevMessage.type === 'user') ||
      (prevMessage.type === 'tool') ||
      (prevMessage.type === 'error'));
  const messageRef = useRef<HTMLDivElement | null>(null);
  const userCopyContent = String(message.content || '');
  const formattedMessageContent = useMemo(
    () => {
      const content = formatUsageLimitText(String(message.content || ''));
      return provider === 'codex' && message.type === 'assistant' && !message.isThinking
        ? stripProposedPlanEnvelope(content)
        : content;
    },
    [message.content, message.isThinking, message.type, provider]
  );
  const assistantCopyContent = message.isToolUse
    ? String(message.displayText || message.content || '')
    : formattedMessageContent;
  const isCommandOrFileEditToolResponse = Boolean(
    message.isToolUse && COPY_HIDDEN_TOOL_NAMES.has(String(message.toolName || ''))
  );
  const shouldShowUserCopyControl = message.type === 'user' && userCopyContent.trim().length > 0;
  // Streaming rows grow every token — the controls (copy/speak) would bind to
  // partial content and the TTS id would reset per token, so hold them back
  // until the message is final.
  const shouldShowAssistantCopyControl = message.type === 'assistant' &&
    assistantCopyContent.trim().length > 0 &&
    !isCommandOrFileEditToolResponse &&
    !message.isThinking &&
    !message.isStreaming;
  const resolvedToolName = resolveToolName(message.toolName || 'UnknownTool', message.toolId);
  const toolConfig = getToolConfig(resolvedToolName);


  const formattedTime = useMemo(() => new Date(message.timestamp).toLocaleTimeString(), [message.timestamp]);

  // Per-turn latency: time between the user's prompt and the first assistant
  // reply. Best-effort and client-side (no provider reports turn duration), so
  // implausible deltas are suppressed.
  const turnLatency = useMemo(() => {
    if (message.type !== 'assistant' || message.isThinking || !prevMessage) {
      return null;
    }
    if (prevMessage.type !== 'user' && !prevMessage.isToolUse) {
      return null;
    }
    const start = new Date(prevMessage.timestamp).getTime();
    const end = new Date(message.timestamp).getTime();
    if (!Number.isFinite(start) || !Number.isFinite(end)) {
      return null;
    }
    const seconds = (end - start) / 1000;
    if (seconds < 0.5 || seconds > 600) {
      return null;
    }
    return seconds;
  }, [message.type, message.isThinking, message.timestamp, prevMessage]);

  const formatTurnLatency = (seconds: number): string =>
    seconds < 60 ? `${seconds.toFixed(1)}s` : `${Math.floor(seconds / 60)}m ${Math.round(seconds % 60)}s`;
  const shouldHideThinkingMessage = Boolean(message.isThinking && !showThinking);

  if (shouldHideThinkingMessage) {
    return null;
  }

  const activeMatchClass = isActiveMatch ? ' ring-2 ring-inset ring-primary/60' : '';

  // opencode renders a `▣ <Agent> · <model> · <duration>` footer under the
  // final assistant message of a turn. Providers don't report a model per
  // message here, so the provider label stands in for the agent name.
  const ocProviderLabel = provider === 'cursor'
    ? t('messageTypes.cursor')
    : provider === 'codex'
      ? t('messageTypes.codex')
      : provider === 'opencode'
        ? t('messageTypes.opencode', { defaultValue: 'OpenCode' })
        : provider === 'devin'
          ? t('messageTypes.devin', { defaultValue: 'Devin' })
          : t('messageTypes.claude');

  return (
    <div
      ref={messageRef}
      data-message-key={messageKey || message.id || message.uuid || undefined}
      data-message-timestamp={message.timestamp || undefined}
      data-chat-search-index={searchIndex ?? undefined}
      className={`chat-message ${message.type} ${isGrouped ? 'grouped' : ''} ${message.type === 'user' ? 'flex justify-end px-3 sm:px-0' : 'px-3 sm:px-0'}${activeMatchClass}`}
    >
      {message.type === 'user' ? (
        /* User turn on the right: claude.ai-style attachment cards above the bubble */
        <div className="flex w-full items-end space-x-0 sm:w-auto sm:max-w-[85%] sm:space-x-3 md:max-w-md lg:max-w-lg xl:max-w-xl">
          <div className="flex min-w-0 flex-1 flex-col items-end gap-2 sm:flex-initial">
            {message.images && message.images.length > 0 && (
              <ChatMessageImages
                images={message.images}
                projectId={selectedProject?.projectId}
              />
            )}
            {message.files && message.files.length > 0 && (
              <ChatMessageFiles
                files={message.files}
                projectId={selectedProject?.projectId}
              />
            )}
            {userCopyContent.trim().length > 0 || (!message.images?.length && !message.files?.length) ? (
              <div className="oc-user-body group max-w-full rounded-2xl rounded-br-md border border-border/60 bg-muted/60 px-3 py-2 text-foreground shadow-sm dark:bg-gray-800/60 sm:px-4">
                <div dir="auto" className="break-words font-serif text-sm">
                  <Markdown
                    breaks
                    className="prose prose-sm max-w-none font-serif dark:prose-invert"
                  >
                    {message.content}
                  </Markdown>
                </div>
                <div className="mt-1 flex items-center justify-end gap-1 text-xs text-muted-foreground">
                  {shouldShowUserCopyControl && (
                    <MessageCopyControl content={userCopyContent} messageType="user" />
                  )}
                  {shouldShowUserCopyControl && (
                    <MessageTaskMasterControl content={userCopyContent} projectId={selectedProject?.projectId} />
                  )}
                  <span>{formattedTime}</span>
                </div>
              </div>
            ) : (
              /* Attachment-only turn: no text bubble, but the timestamp still shows */
              <div className="flex items-center justify-end gap-1 text-xs text-muted-foreground">
                <span>{formattedTime}</span>
              </div>
            )}
          </div>
          {!isGrouped && (
            <div className="hidden h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-blue-600 text-sm text-white sm:flex">
              U
            </div>
          )}
        </div>
      ) : message.isTaskNotification ? (
        /* Compact task notification on the left */
        <div className="w-full">
          <div className="flex items-center gap-2 py-0.5">
            <span className={`inline-block h-1.5 w-1.5 flex-shrink-0 rounded-full ${message.taskStatus === 'completed' ? 'bg-green-400 dark:bg-green-500' : 'bg-amber-400 dark:bg-amber-500'}`} />
            <span className="text-xs text-gray-500 dark:text-gray-400">
              <HighlightText text={message.content || ''} query={searchQuery} />
            </span>
            <span className="ml-auto text-[11px] tabular-nums text-muted-foreground/60">
              {formattedTime}
            </span>
          </div>
        </div>
      ) : (
        /* Claude/Error/Tool messages on the left */
        <div className="w-full">
          {!isGrouped && (
            <div className="oc-msg-header mb-2 flex items-center space-x-3">
              {message.type === 'error' ? (
                <div className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-red-600 text-sm text-white">
                  !
                </div>
              ) : message.type === 'tool' ? (
                <div className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-gray-600 text-sm text-white dark:bg-gray-700">
                  🔧
                </div>
              ) : (
                <div className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full p-1 text-sm text-foreground">
                  <LLMProviderLogo provider={provider} className="h-full w-full" />
                </div>
              )}
              <div className="text-sm font-medium text-gray-900 dark:text-white">
                {message.type === 'error'
                  ? t('messageTypes.error')
                  : message.type === 'tool'
                    ? (
                      <span className="flex items-center gap-1">
                        {t('messageTypes.tool')}
                        {message.toolName && (
                          <span className="text-xs text-muted-foreground">
                            · <HighlightText text={message.toolName} query={searchQuery} />
                          </span>
                        )}
                      </span>
                    )
                    : (provider === 'cursor'
                        ? t('messageTypes.cursor')
                        : provider === 'codex'
                          ? t('messageTypes.codex')
                          : provider === 'opencode'
                              ? t('messageTypes.opencode', { defaultValue: 'OpenCode' })
                              : provider === 'devin'
                                  ? t('messageTypes.devin', { defaultValue: 'Devin' })
                                  : t('messageTypes.claude'))}
              </div>
            </div>
          )}

          <div className="w-full">

            {message.isToolUse ? (
              <>
                <div className="flex flex-col">
                  <div className="flex flex-col">
                    <Markdown className="prose prose-sm max-w-none font-sans dark:prose-invert">
                      {String(message.displayText || '')}
                    </Markdown>
                  </div>
                </div>

                {message.toolInput && (
                  <ToolRenderer
                    toolName={resolvedToolName}
                    toolInput={message.toolInput}
                    toolResult={message.toolResult}
                    toolId={message.toolId}
                    mode="input"
                    onFileOpen={onFileOpen}
                    createDiff={createDiff}
                    selectedProject={selectedProject}
                    showRawParameters={showRawParameters}
                    rawToolInput={typeof message.toolInput === 'string' ? message.toolInput : undefined}
                    isSubagentContainer={message.isSubagentContainer}
                    subagentState={message.subagentState}
                  />
                )}

                {/* Tool Result Section — Bash and inline-config tools render their output inside the input row above. */}
                {message.toolResult && resolvedToolName !== 'Bash' && !toolConfig.result?.inline && !shouldHideToolResult(resolvedToolName, message.toolResult) && (
                  message.toolResult.isError ? (
                    // Error results — collapsed red row that expands to the content
                    <div id={`tool-result-${message.toolId}`} className="scroll-mt-4">
                      <ToolErrorDisplay
                        label={t('messageTypes.error')}
                        content={String(message.toolResult.content || '')}
                      />
                    </div>
                  ) : String(message.toolResult.content || '').trim() ? (
                    // Non-error results - route through ToolRenderer (single source of truth)
                    <div id={`tool-result-${message.toolId}`} className="scroll-mt-4">
                      <ToolRenderer
                        toolName={resolvedToolName}
                        toolInput={message.toolInput}
                        toolResult={message.toolResult}
                        toolId={message.toolId}
                        mode="result"
                        onFileOpen={onFileOpen}
                        createDiff={createDiff}
                        selectedProject={selectedProject}
                      />
                    </div>
                  ) : (
                    // Pusty wynik (np. get_output zanim shell cokolwiek wypisał)
                    <div id={`tool-result-${message.toolId}`} className="scroll-mt-4 rounded-md border border-border/40 bg-muted/20 px-3 py-2 text-xs text-muted-foreground">
                      {t('tool.emptyResult', { defaultValue: '(no output yet — the tool returned an empty result)' })}
                    </div>
                  )
                )}
              </>
            ) : message.isInteractivePrompt ? (
              // Special handling for interactive prompts
              <div className="rounded-lg border border-amber-200 bg-amber-50 p-4 dark:border-amber-800 dark:bg-amber-900/20">
                <div className="flex items-start gap-3">
                  <div className="mt-0.5 flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full bg-amber-500">
                    <svg className="h-5 w-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M8.228 9c.549-1.165 2.03-2 3.772-2 2.21 0 4 1.343 4 3 0 1.4-1.278 2.575-3.006 2.907-.542.104-.994.54-.994 1.093m0 3h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                  </div>
                  <div className="flex-1">
                    <h4 className="mb-3 text-base font-semibold text-amber-900 dark:text-amber-100">
                      {t('interactive.title')}
                    </h4>
                    {(() => {
                      const lines = (message.content || '').split('\n').filter((line) => line.trim());
                      const questionLine = lines.find((line) => line.includes('?')) || lines[0] || '';
                      const options: InteractiveOption[] = [];

                      // Parse the menu options
                      lines.forEach((line) => {
                        // Match lines like "❯ 1. Yes" or "  2. No"
                        const optionMatch = line.match(/[❯\s]*(\d+)\.\s+(.+)/);
                        if (optionMatch) {
                          const isSelected = line.includes('❯');
                          options.push({
                            number: optionMatch[1],
                            text: optionMatch[2].trim(),
                            isSelected
                          });
                        }
                      });

                      return (
                        <>
                          <p className="mb-4 text-sm text-amber-800 dark:text-amber-200">
                            <HighlightText text={questionLine} query={searchQuery} />
                          </p>

                          {/* Option buttons */}
                          <div className="mb-4 space-y-2">
                            {options.map((option) => (
                              <button
                                key={option.number}
                                className={`w-full rounded-lg border-2 px-4 py-3 text-left transition-all ${option.isSelected
                                  ? 'border-amber-600 bg-amber-600 text-white shadow-md dark:border-amber-700 dark:bg-amber-700'
                                  : 'border-amber-300 bg-white text-amber-900 dark:border-amber-700 dark:bg-gray-800 dark:text-amber-100'
                                  } cursor-not-allowed opacity-75`}
                                disabled
                              >
                                <div className="flex items-center gap-3">
                                  <span className={`flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-full text-sm font-bold ${option.isSelected
                                    ? 'bg-white/20'
                                    : 'bg-amber-100 dark:bg-amber-800/50'
                                    }`}>
                                    {option.number}
                                  </span>
                                  <span className="flex-1 text-sm font-medium sm:text-base">
                                    <HighlightText text={option.text} query={searchQuery} />
                                  </span>
                                  {option.isSelected && (
                                    <span className="text-lg">❯</span>
                                  )}
                                </div>
                              </button>
                            ))}
                          </div>

                          <div className="rounded-lg bg-amber-100 p-3 dark:bg-amber-800/30">
                            <p className="mb-1 text-sm font-medium text-amber-900 dark:text-amber-100">
                              {t('interactive.waiting')}
                            </p>
                            <p className="text-xs text-amber-800 dark:text-amber-200">
                              {t('interactive.instruction')}
                            </p>
                          </div>
                        </>
                      );
                    })()}
                  </div>
                </div>
              </div>
            ) : message.isThinking ? (
              /* Thinking messages — Reasoning component (ai-elements pattern) */
              <Reasoning defaultOpen={false}>
                <ReasoningTrigger />
                <ReasoningContent>
                  <Markdown className="prose prose-sm prose-gray max-w-none font-sans dark:prose-invert">
                    {message.content}
                  </Markdown>
                  <div className="mt-3 flex items-center gap-2 text-[11px]">
                    <MessageCopyControl content={String(message.content || '')} messageType="assistant" />
                    <MessageTaskMasterControl
                      content={String(message.content || '')}
                      projectId={selectedProject?.projectId}
                    />
                  </div>
                </ReasoningContent>
              </Reasoning>
            ) : (
              <div dir="auto" className="text-sm text-gray-700 dark:text-gray-300">
                {/* Reasoning accordion */}
                {showThinking && message.reasoning && (
                  <Reasoning className="mb-3" defaultOpen={false}>
                    <ReasoningTrigger />
                    <ReasoningContent>
                      <div className="whitespace-pre-wrap">
                        {message.reasoning}
                      </div>
                    </ReasoningContent>
                  </Reasoning>
                )}

                {(() => {
                  const content = formattedMessageContent;

                  // Detect if content is pure JSON (starts with { or [)
                  const trimmedContent = content.trim();
                  if ((trimmedContent.startsWith('{') || trimmedContent.startsWith('[')) &&
                    (trimmedContent.endsWith('}') || trimmedContent.endsWith(']'))) {
                    try {
                      const parsed = JSON.parse(trimmedContent);
                      const formatted = JSON.stringify(parsed, null, 2);

                      return (
                        <div className="my-2">
                          <div className="mb-2 flex items-center gap-2 text-sm text-muted-foreground">
                            <svg className="h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M7 21h10a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2z" />
                            </svg>
                            <span className="font-medium">{t('json.response')}</span>
                          </div>
                          <div className="overflow-hidden rounded-lg border border-border bg-muted">
                            <pre className="overflow-x-auto p-4">
                              <code className="block whitespace-pre font-mono text-sm text-foreground">
                                {formatted}
                              </code>
                            </pre>
                          </div>
                        </div>
                      );
                    } catch {
                      // Not valid JSON, fall through to normal rendering
                    }
                  }

                  // Normal rendering for non-JSON content
                  return message.type === 'assistant' ? (
                    <Markdown className="prose prose-sm prose-gray max-w-none font-sans dark:prose-invert">
                      {content}
                    </Markdown>
                  ) : (
                    <div className="whitespace-pre-wrap">
                      <HighlightText text={content} query={searchQuery} />
                    </div>
                  );
                })()}
              </div>
            )}

            {message.type === 'assistant' && !message.isToolUse && !message.isThinking ? (
              <div className="oc-assistant-footer">
                <span className="oc-footer-mark">▣</span>
                <span className="oc-footer-mode">{ocProviderLabel}</span>
                <span>·</span>
                {turnLatency !== null && (
                  <>
                    <span className="tabular-nums" title="Time from your prompt to this reply">
                      {formatTurnLatency(turnLatency)}
                    </span>
                    <span>·</span>
                  </>
                )}
                <span>{formattedTime}</span>
                {shouldShowAssistantCopyControl && (
                  <div className="oc-footer-actions">
                    <MessageSpeakControl content={assistantCopyContent} messageType="assistant" />
                    <MessageCopyControl content={assistantCopyContent} messageType="assistant" />
                    <MessageTaskMasterControl content={assistantCopyContent} projectId={selectedProject?.projectId} />
                  </div>
                )}
              </div>
            ) : (
              <div className="oc-msg-meta mt-1 flex w-full items-center gap-2 text-[11px] text-gray-400 dark:text-gray-500">
                {shouldShowAssistantCopyControl && (
                  <MessageCopyControl content={assistantCopyContent} messageType="assistant" />
                )}
                {shouldShowAssistantCopyControl && (
                  <MessageTaskMasterControl content={assistantCopyContent} projectId={selectedProject?.projectId} />
                )}
                {turnLatency !== null && (
                  <span className="tabular-nums text-muted-foreground/70" title="Time from your prompt to this reply">
                    {formatTurnLatency(turnLatency)}
                  </span>
                )}
                <span>{formattedTime}</span>
              </div>
            )}
          </div>
        </div>
      )}
    </div>
  );
});

export default MessageComponent;


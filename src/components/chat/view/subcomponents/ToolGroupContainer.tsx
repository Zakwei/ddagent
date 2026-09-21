import { memo, useMemo, useState } from 'react';
import { ChevronRight } from 'lucide-react';

import type { ChatMessage, ClaudePermissionSuggestion, PermissionGrantResult, Provider } from '../../types/types';
import type { Project } from '../../../../types/app';
import type { ToolGroupItem } from '../../utils/toolGrouping';
import { buildToolExpansionKey, getToolExpansion, setToolExpansion } from '../../utils/toolExpansionState';
import { cn } from '../../../../lib/utils';
import { attachToolTitlePath, getToolConfig, ocToolIcon, resolveToolName } from '../../tools';
import { ToolStatusBadge } from '../../tools/components/ToolStatusBadge';
import type { ToolStatus } from '../../tools/components/ToolStatusBadge';

import MessageComponent from './MessageComponent';

type DiffLine = {
  type: string;
  content: string;
  lineNum: number;
};

interface ToolGroupContainerProps {
  group: ToolGroupItem;
  prevMessage: ChatMessage | null;
  createDiff: (oldStr: string, newStr: string) => DiffLine[];
  getMessageKey: (message: ChatMessage) => string;
  onFileOpen?: (filePath: string, diffInfo?: unknown, line?: number) => void;
  onShowSettings?: () => void;
  onGrantToolPermission?: (suggestion: ClaudePermissionSuggestion) => PermissionGrantResult | null | undefined;
  showRawParameters?: boolean;
  showThinking?: boolean;
  selectedProject?: Project | null;
  provider: Provider | string;
  isFirstVisible?: boolean;
  totalMessages?: number;
  sessionMessagesCount?: number;
  allMessagesLoaded?: boolean;
  isLoadingAllMessages?: boolean;
  loadAllMessages?: () => void;
}

function parseToolInput(toolInput: unknown): unknown {
  if (typeof toolInput !== 'string') {
    return toolInput;
  }

  try {
    return JSON.parse(toolInput);
  } catch {
    return toolInput;
  }
}

function getToolInputPreview(message: ChatMessage): string {
  const config = getToolConfig(message.toolName || 'UnknownTool', message.toolId).input;
  // parseToolInput can return null (toolInput="null") or undefined — the
  // config getters below destructure it, so fall back to an empty object.
  const parsedInput = attachToolTitlePath(
    parseToolInput(message.toolInput) ?? {},
    message.toolName || 'UnknownTool',
  ) ?? {};
  const title = typeof config.title === 'function' ? config.title(parsedInput) : config.title;
  const value = config.getValue?.(parsedInput);

  return String(value || title || message.displayText || message.content || '').trim();
}

function deriveGroupStatus(messages: ChatMessage[]): ToolStatus {
  if (messages.length === 0) return 'completed';
  if (messages.some((m) => !m.toolResult)) return 'running';
  if (messages.some((m) => m.toolResult?.isError)) return 'error';
  return 'completed';
}

function ToolGroupContainer({
  group,
  prevMessage,
  createDiff,
  getMessageKey,
  onFileOpen,
  onShowSettings,
  onGrantToolPermission,
  showRawParameters,
  showThinking,
  selectedProject,
  provider,
  isFirstVisible = false,
  totalMessages = 0,
  sessionMessagesCount = 0,
  allMessagesLoaded = true,
  isLoadingAllMessages = false,
  loadAllMessages,
}: ToolGroupContainerProps) {
  // Remember the user's expand/collapse choice per group (keyed by the first
  // message's session+tool id) so remounts from tile switches or history
  // pagination don't snap it shut again.
  const firstGroupMessage = group.messages[0];
  const groupExpansionKey = buildToolExpansionKey(
    typeof firstGroupMessage?.sessionId === 'string' ? firstGroupMessage.sessionId : null,
    firstGroupMessage?.toolId,
  );
  const [isExpanded, setIsExpanded] = useState(() => getToolExpansion(groupExpansionKey) ?? false);
  const setExpanded = (next: boolean) => {
    setToolExpansion(groupExpansionKey, next);
    setIsExpanded(next);
  };
  const resolvedGroupToolName = resolveToolName(group.toolName, group.messages[0]?.toolId);
  const config = getToolConfig(resolvedGroupToolName).input;
  const label = config.label || resolvedGroupToolName;

  const groupStatus = useMemo(() => deriveGroupStatus(group.messages), [group.messages]);
  const canLoadMore = isFirstVisible && !allMessagesLoaded && !isLoadingAllMessages && totalMessages > sessionMessagesCount;

  const preview = useMemo(() => {
    if (canLoadMore) {
      const missing = Math.max(0, totalMessages - sessionMessagesCount);
      return `+${missing} earlier — load all`;
    }

    const visiblePreviews = group.messages
      .slice(0, 2)
      .map(getToolInputPreview)
      .filter(Boolean);

    const extraCount = group.messages.length - visiblePreviews.length;
    const previewText = visiblePreviews.join(', ');

    if (!previewText) {
      return extraCount > 0 ? `+${extraCount} more` : '';
    }

    return extraCount > 0 ? `${previewText}, +${extraCount} more` : previewText;
  }, [group.messages, canLoadMore, sessionMessagesCount, totalMessages]);

  const lastMessage = group.messages[group.messages.length - 1];
  const firstMessage = group.messages[0];
  const lastKey = lastMessage ? getMessageKey(lastMessage) : undefined;
  const firstKey = firstMessage ? getMessageKey(firstMessage) : undefined;

  return (
    <div
      className="chat-message tool px-3 sm:px-0"
      data-message-key={lastKey}
      data-last-message-key={lastKey}
      data-first-message-key={firstKey}
      data-message-timestamp={group.timestamp || undefined}
    >
      <div className="overflow-hidden rounded-lg border border-border/60 bg-muted/40 transition-all duration-200">
        <button
          type="button"
          className="flex w-full touch-manipulation items-center gap-2 px-2.5 py-1.5 text-left outline-none transition-colors hover:bg-muted/60 focus-visible:ring-1 focus-visible:ring-ring"
          onClick={() => {
            if (canLoadMore && loadAllMessages) {
              loadAllMessages();
              setExpanded(true);
              return;
            }
            setExpanded(!isExpanded);
          }}
          aria-expanded={isExpanded}
          disabled={isLoadingAllMessages}
        >
          <ChevronRight
            className={cn(
              'h-3.5 w-3.5 flex-shrink-0 text-muted-foreground transition-transform duration-200',
              isExpanded && 'rotate-90',
            )}
            aria-hidden
          />
          <span className="oc-tool-icon flex-shrink-0 select-none" aria-hidden>
            {ocToolIcon(resolvedGroupToolName)}
          </span>
          <span className="oc-tool-label flex-shrink-0 text-xs">{label}</span>
          <span className="flex-shrink-0 rounded-full bg-muted px-1.5 py-0.5 text-[10px] font-medium text-muted-foreground">
            x{group.messages.length}
          </span>
          {preview && (
            <>
              <span className="text-[10px] text-muted-foreground">/</span>
              <span className="min-w-0 truncate font-mono text-xs text-muted-foreground">{preview}</span>
            </>
          )}
          {groupStatus !== 'completed' && (
            <ToolStatusBadge status={groupStatus} />
          )}
          {isLoadingAllMessages && (
            <div className="h-3 w-3 animate-spin rounded-full border-2 border-muted-foreground/30 border-t-muted-foreground" />
          )}
          {group.timestamp && (
            <span className="ml-auto flex-shrink-0 text-[10px] tabular-nums text-muted-foreground">
              {new Date(group.timestamp).toLocaleTimeString()}
            </span>
          )}
        </button>

        {isExpanded && (
          <div className="border-t border-border/50 bg-background/50 px-2 py-2">
            <div className="space-y-3 sm:space-y-4">
              {group.messages.map((message, index) => (
                <MessageComponent
                  key={getMessageKey(message)}
                  message={message}
                  prevMessage={index > 0 ? group.messages[index - 1] : prevMessage}
                  createDiff={createDiff}
                  onFileOpen={onFileOpen}
                  onShowSettings={onShowSettings}
                  onGrantToolPermission={onGrantToolPermission}
                  showRawParameters={showRawParameters}
                  showThinking={showThinking}
                  selectedProject={selectedProject}
                  provider={provider}
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}

function areEqual(prev: ToolGroupContainerProps, next: ToolGroupContainerProps): boolean {
  if (prev.group.toolName !== next.group.toolName) return false;
  if (prev.group.messages.length !== next.group.messages.length) return false;
  if (prev.group.messages.some((m, i) => m !== next.group.messages[i])) return false;
  if (prev.prevMessage !== next.prevMessage) return false;
  if (prev.provider !== next.provider) return false;
  if (prev.selectedProject !== next.selectedProject) return false;
  if (prev.showRawParameters !== next.showRawParameters) return false;
  if (prev.showThinking !== next.showThinking) return false;
  if (prev.createDiff !== next.createDiff) return false;
  if (prev.getMessageKey !== next.getMessageKey) return false;
  if (prev.onFileOpen !== next.onFileOpen) return false;
  if (prev.onShowSettings !== next.onShowSettings) return false;
  if (prev.onGrantToolPermission !== next.onGrantToolPermission) return false;
  if (prev.isFirstVisible !== next.isFirstVisible) return false;
  if (prev.totalMessages !== next.totalMessages) return false;
  if (prev.sessionMessagesCount !== next.sessionMessagesCount) return false;
  if (prev.allMessagesLoaded !== next.allMessagesLoaded) return false;
  if (prev.isLoadingAllMessages !== next.isLoadingAllMessages) return false;
  return true;
}

export default memo(ToolGroupContainer, areEqual);

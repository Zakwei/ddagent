/**
 * Message normalization utilities.
 * Converts NormalizedMessage[] from the session store into ChatMessage[] for the UI.
 */

import type { NormalizedMessage } from '../../../stores/useSessionStore';
import type { ChatMessage, SubagentChildTool } from '../types/types';
import { formatUsageLimitText } from '../utils/chatFormatting';

function formatToolResultContent(content: unknown): string {
  const text = typeof content === 'string' ? content : (JSON.stringify(content) ?? '');
  const toolUseErrorMatch = /^<tool_use_error>([\s\S]*)<\/tool_use_error>$/.exec(text.trim());
  return toolUseErrorMatch ? toolUseErrorMatch[1] : text;
}

type ParsedTaskNotification = {
  status: string;
  summary: string;
  result: string;
};

/**
 * Tool names that open a subagent container across providers: Claude `Task`,
 * Devin `run_subagent`, OpenCode `task`, Devin/Cursor `agent`. Provider
 * tool-name casing varies, so matching is case-insensitive.
 */
const SUBAGENT_CONTAINER_TOOL_NAMES = new Set(['task', 'run_subagent', 'agent']);

export function isSubagentToolName(toolName: unknown): boolean {
  return typeof toolName === 'string'
    && SUBAGENT_CONTAINER_TOOL_NAMES.has(toolName.trim().toLowerCase());
}

/**
 * Parses a background-agent `<task-notification>` block.
 *
 * The harness injects these as user-role messages when a background task stops.
 * Newer notifications carry extra fields (`<tool-use-id>`, `<note>`, `<usage>`,
 * and a `<result>` markdown payload) that the previous single-shot regex could
 * not match, so the whole raw XML block leaked through as plain user text.
 * Fields are extracted independently so the block renders as an assistant
 * notification plus, when present, the agent's markdown result.
 */
function parseTaskNotification(content: string): ParsedTaskNotification | null {
  if (!content.trimStart().startsWith('<task-notification>')) {
    return null;
  }

  const statusMatch = /<status>([\s\S]*?)<\/status>/.exec(content);
  const summaryMatch = /<summary>([\s\S]*?)<\/summary>/.exec(content);

  let result = '';
  const resultOpen = content.indexOf('<result>');
  if (resultOpen !== -1) {
    const afterOpen = content.slice(resultOpen + '<result>'.length);
    const closeIndex = afterOpen.indexOf('</result>');
    result =
      closeIndex === -1
        ? afterOpen.replace(/<\/task-notification>\s*$/, '').trim()
        : afterOpen.slice(0, closeIndex).trim();
  }

  return {
    status: statusMatch?.[1]?.trim() || 'completed',
    summary: summaryMatch?.[1]?.trim() || 'Background task finished',
    result,
  };
}

/**
 * Chat-text messages kept at the bottom of the pane regardless of how many
 * tool rows a turn produced.
 */
export const MIN_VISIBLE_TEXT_MESSAGES = 2;

/**
 * Slice the rendered window of a session.
 *
 * Tool rows share the render budget with chat text, so a tool-heavy turn can
 * push the newest replies out of the window entirely — they are in the store
 * but never painted, which reads as "my answer disappeared". Extend the window
 * back to the Nth-last text message so the pane always ends on conversation.
 */
export function sliceVisibleMessages(
  messages: ChatMessage[],
  visibleCount: number,
  minTextMessages: number = MIN_VISIBLE_TEXT_MESSAGES,
): ChatMessage[] {
  if (visibleCount >= messages.length) {
    return messages;
  }

  const windowStart = messages.length - visibleCount;
  let anchorStart = windowStart;
  let textSeen = 0;

  for (let index = messages.length - 1; index >= 0; index -= 1) {
    const message = messages[index];
    if (message.isToolUse || message.isThinking) continue;

    textSeen += 1;
    if (textSeen >= minTextMessages) {
      anchorStart = index;
      break;
    }
  }

  return messages.slice(Math.min(windowStart, anchorStart));
}

/**
 * One source row's converted output, reused while its inputs stay unchanged.
 */
type ConvertedRow = {
  /** Tool result attached at conversion time (tool_use rows only). */
  attachedResult: unknown;
  /** Whether the matching tool_use row was in the batch (tool_result rows only). */
  toolUsePresent: boolean | null;
  rows: ChatMessage[];
};

/**
 * Per-row conversion cache.
 *
 * The converter runs on every store notification — ~16 passes per second while
 * an agent streams. Caching by the source row keeps unchanged ChatMessage
 * objects referentially stable, so memoized message components skip the
 * re-render (and the markdown parse) and only the row that actually changed
 * repaints.
 */
const convertedRowCache = new WeakMap<NormalizedMessage, ConvertedRow>();

/**
 * Convert NormalizedMessage[] from the session store into ChatMessage[]
 * that the existing UI components expect.
 *
 * Truly internal/system content is already filtered server-side. Some Claude
 * transcript artifacts such as local slash commands and compact summaries are
 * intentionally preserved and annotated so they can render like normal chat.
 */
export function normalizedToChatMessages(messages: NormalizedMessage[]): ChatMessage[] {
  const converted: ChatMessage[] = [];

  // First pass: collect tool results for attachment
  const toolResultMap = new Map<string, NormalizedMessage>();
  const toolUseIds = new Set<string>();
  for (const msg of messages) {
    if (msg.kind === 'tool_use' && msg.toolId) {
      toolUseIds.add(msg.toolId);
    }

    if (msg.kind === 'tool_result' && msg.toolId) {
      // One tool call can carry several result rows — live snapshots, or a
      // transcript whose trailing row is empty. Attach the newest row that
      // actually holds output so the expandable result panel is never blank;
      // an error flag still wins over a stale successful row.
      const previous = toolResultMap.get(msg.toolId);
      const replacesPrevious = !previous
        || Boolean(String(msg.content || '').trim())
        || !String(previous.content || '').trim()
        || (Boolean(msg.isError) && !previous.isError);
      if (replacesPrevious) {
        toolResultMap.set(msg.toolId, msg);
      }
    }
  }

  for (const msg of messages) {
    // Reuse the previous conversion when this row and its attachments are
    // unchanged. Tool rows additionally depend on the result attached to them
    // and on whether the matching tool_use row is part of this batch.
    const attachedResult = msg.kind === 'tool_use' && msg.toolId
      ? (msg.toolResult || toolResultMap.get(msg.toolId) || null)
      : null;
    const toolUsePresent = msg.kind === 'tool_result' && msg.toolId
      ? toolUseIds.has(msg.toolId)
      : null;
    const cached = convertedRowCache.get(msg);
    if (
      cached
      && cached.attachedResult === attachedResult
      && cached.toolUsePresent === toolUsePresent
    ) {
      converted.push(...cached.rows);
      continue;
    }
    const rowsStart = converted.length;

    const sharedMetadata = {
      // Stable row identity: the render key must survive a growing live row
      // (and its changing timestamp), or React remounts the bubble on every
      // stream delta instead of updating it in place.
      messageId: msg.id,
      displayText: msg.displayText,
      commandName: msg.commandName,
      commandMessage: msg.commandMessage,
      commandArgs: msg.commandArgs,
      isLocalCommand: msg.isLocalCommand,
      isLocalCommandStdout: msg.isLocalCommandStdout,
      isCompactSummary: msg.isCompactSummary,
      // Provider travels with each row so exports/labels can attribute
      // assistant output to the right agent instead of assuming Claude.
      provider: msg.provider,
    };

    switch (msg.kind) {
      case 'text': {
        const content = msg.content || '';
        const images = Array.isArray(msg.images) && msg.images.length > 0 ? msg.images : undefined;
        const files = Array.isArray(msg.files) && msg.files.length > 0 ? msg.files : undefined;
        if (!content.trim() && !images && !files) break;

        if (msg.role === 'user') {
          // Parse task notifications
          const taskNotif = parseTaskNotification(content);
          if (taskNotif) {
            converted.push({
              type: 'assistant',
              content: taskNotif.summary,
              timestamp: msg.timestamp,
              isTaskNotification: true,
              taskStatus: taskNotif.status,
              ...sharedMetadata,
            });
            // Render the agent's result as a normal assistant message so its
            // markdown displays correctly instead of leaking raw XML.
            if (taskNotif.result) {
              converted.push({
                type: 'assistant',
                content: formatUsageLimitText(taskNotif.result),
                timestamp: msg.timestamp,
                ...sharedMetadata,
              });
            }
          } else {
            converted.push({
              type: 'user',
              content,
              timestamp: msg.timestamp,
              images,
              files,
              ...sharedMetadata,
            });
          }
        } else {
          const text = formatUsageLimitText(content);
          converted.push({
            type: 'assistant',
            content: text,
            timestamp: msg.timestamp,
            ...sharedMetadata,
          });
        }
        break;
      }

      case 'tool_use': {
        const tr = msg.toolResult || (msg.toolId ? toolResultMap.get(msg.toolId) : null);
        const isSubagentContainer = isSubagentToolName(msg.toolName);

        // Build child tools from subagentTools
        const childTools: SubagentChildTool[] = [];
        if (isSubagentContainer && msg.subagentTools && Array.isArray(msg.subagentTools)) {
          for (const tool of msg.subagentTools as any[]) {
            childTools.push({
              toolId: tool.toolId,
              toolName: tool.toolName,
              toolInput: tool.toolInput,
              toolResult: tool.toolResult || null,
              timestamp: new Date(tool.timestamp || Date.now()),
            });
          }
        }

        const toolResult = tr
          ? {
              content: formatToolResultContent(tr.content),
              isError: Boolean(tr.isError),
              toolUseResult: (tr as any).toolUseResult,
            }
          : null;

        converted.push({
          type: 'assistant',
          content: '',
          timestamp: msg.timestamp,
          isToolUse: true,
          toolName: msg.toolName,
          toolInput: typeof msg.toolInput === 'string' ? msg.toolInput : JSON.stringify(msg.toolInput ?? '', null, 2),
          toolId: msg.toolId,
          toolResult,
          isSubagentContainer,
          subagentState: isSubagentContainer
            ? {
                childTools,
                currentToolIndex: childTools.length > 0 ? childTools.length - 1 : -1,
                isComplete: Boolean(toolResult),
              }
            : undefined,
          ...sharedMetadata,
        });
        break;
      }

      case 'thinking':
        if (msg.content?.trim()) {
          converted.push({
            type: 'assistant',
            content: msg.content,
            timestamp: msg.timestamp,
            isThinking: true,
            ...sharedMetadata,
          });
        }
        break;

      case 'error':
        converted.push({
          type: 'error',
          content: msg.content || 'Unknown error',
          timestamp: msg.timestamp,
          ...sharedMetadata,
        });
        break;

      case 'interactive_prompt':
        converted.push({
          type: 'assistant',
          content: msg.content || '',
          timestamp: msg.timestamp,
          isInteractivePrompt: true,
          ...sharedMetadata,
        });
        break;

      case 'task_notification':
        converted.push({
          type: 'assistant',
          content: msg.summary || 'Background task update',
          timestamp: msg.timestamp,
          isTaskNotification: true,
          taskStatus: msg.status || 'completed',
          ...sharedMetadata,
        });
        break;

      case 'stream_delta':
        if (msg.content) {
          converted.push({
            type: 'assistant',
            content: msg.content,
            timestamp: msg.timestamp,
            isStreaming: true,
            ...sharedMetadata,
          });
        }
        break;

      // stream_end, complete, status, permission_*, session_created
      // are control events — not rendered as messages
      case 'stream_end':
      case 'complete':
      case 'status':
      case 'permission_request':
      case 'permission_cancelled':
      case 'session_created':
        // Skip — these are handled by useChatRealtimeHandlers
        break;

      // tool_result is handled via attachment to tool_use above
      case 'tool_result': {
        if (msg.toolId && toolUseIds.has(msg.toolId)) {
          break;
        }

        // A result with a toolId but no matching tool_use in the loaded set is
        // almost always a tool_use/tool_result pair split across a pagination
        // boundary (older page not loaded yet). Rendering its raw content here
        // produces an unstyled dump that "fixes itself" once the older page
        // loads; skip it and let it attach to its tool_use when that arrives.
        if (msg.toolId) {
          break;
        }

        const content = formatToolResultContent(msg.content || '');
        if (!content.trim()) {
          break;
        }

        converted.push({
          type: msg.isError ? 'error' : 'assistant',
          content,
          timestamp: msg.timestamp,
          toolId: msg.toolId,
          ...sharedMetadata,
        });
        break;
      }

      default:
        break;
    }

    convertedRowCache.set(msg, {
      attachedResult,
      toolUsePresent,
      rows: converted.slice(rowsStart),
    });
  }

  return converted;
}

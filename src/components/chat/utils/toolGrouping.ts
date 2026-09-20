import type { ChatMessage } from '../types/types';
import { resolveToolName } from '../tools/configs/toolConfigs';

export const TOOL_GROUP_THRESHOLD = 3;

// Edits always stay visible — they're the highest-signal tool calls (review mode,
// diffs) and hiding them inside a collapsed "Tools" row defeats the purpose.
const UNGROUPABLE_TOOL_NAMES = new Set(['Edit', 'Write', 'ApplyPatch']);

export interface ToolGroupItem {
  _isGroup: true;
  toolName: string;
  messages: ChatMessage[];
  timestamp: ChatMessage['timestamp'];
}

export type MessageListItem = ChatMessage | ToolGroupItem;

export function isToolGroupItem(item: MessageListItem): item is ToolGroupItem {
  return '_isGroup' in item && (item as ToolGroupItem)._isGroup === true;
}

function isGroupableToolMessage(message: ChatMessage): message is ChatMessage & { toolName: string } {
  return Boolean(
    message.isToolUse
    && message.toolName
    && !message.isSubagentContainer
    && !UNGROUPABLE_TOOL_NAMES.has(resolveToolName(message.toolName, message.toolId)),
  );
}

function getRunToolName(run: ChatMessage[]): string {
  return (run[0]?.toolName as string) || 'Tools';
}

// Messages that render nothing (e.g. reasoning hidden when showThinking is off)
// shouldn't split an otherwise-continuous run of the same tool — providers like
// Codex interleave hidden reasoning between consecutive tool calls.
function rendersNothing(message: ChatMessage, showThinking: boolean): boolean {
  return Boolean(message.isThinking && !showThinking);
}

export function groupConsecutiveTools(
  messages: ChatMessage[],
  showThinking: boolean = true,
): MessageListItem[] {
  const items: MessageListItem[] = [];
  let index = 0;

  while (index < messages.length) {
    const message = messages[index];

    if (!isGroupableToolMessage(message)) {
      items.push(message);
      index += 1;
      continue;
    }

    const run: ChatMessage[] = [message];
    // A group is one repeated tool: compare resolved names so provider aliases
    // of the same tool (e.g. opencode `bash` vs `Bash`) stay together.
    const runToolName = resolveToolName(message.toolName as string, message.toolId);
    let nextIndex = index + 1;

    while (nextIndex < messages.length) {
      const candidate = messages[nextIndex];

      // Skip invisible interleaved messages so they don't break the run.
      if (rendersNothing(candidate, showThinking)) {
        nextIndex += 1;
        continue;
      }

      if (
        isGroupableToolMessage(candidate)
        && resolveToolName(candidate.toolName, candidate.toolId) === runToolName
      ) {
        run.push(candidate);
        nextIndex += 1;
        continue;
      }

      break;
    }

    if (run.length >= TOOL_GROUP_THRESHOLD) {
      items.push({
        _isGroup: true,
        toolName: getRunToolName(run),
        messages: run,
        // Czas grupy = ostatnie wiadomość w runie (koniec pracy), z fallbackiem
        // na pierwszą — niektóre wpisy live nie mają timestampa.
        timestamp: run[run.length - 1]?.timestamp || message.timestamp,
      });
    } else {
      items.push(...run);
    }

    index = nextIndex;
  }

  return items;
}

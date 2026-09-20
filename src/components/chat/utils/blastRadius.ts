import { resolveToolName } from '../tools/configs/toolConfigs';

import { extractAffectedFilePaths } from './chatPermissions';

/**
 * "Why did it touch this?" — groups file edits by the turn (user prompt) that
 * produced them, so selecting one changed file can reveal every sibling file
 * the AI touched in the same turn. Consumers: `ChatMessagesPane` (blast-radius
 * panel) and the per-file click path in `MessageComponent`.
 */
type BlastRadiusMessage = {
  type?: unknown;
  content?: unknown;
  isToolUse?: unknown;
  toolName?: unknown;
  toolInput?: unknown;
  toolId?: string;
};

export type TurnFileEdits = {
  /** 0-based index of the user message that opened this turn. */
  turnIndex: number;
  /** Distinct file paths edited by edit tools in this turn, in first-seen order. */
  files: string[];
};

const EDIT_TOOL_NAMES = new Set(['Edit', 'Write', 'ApplyPatch', 'str_replace_editor', 'Patch']);

function readToolInput(toolInput: unknown): unknown {
  if (typeof toolInput !== 'string') {
    return toolInput;
  }
  try {
    return JSON.parse(toolInput);
  } catch {
    return toolInput;
  }
}

export function collectTurnFileEdits(messages: BlastRadiusMessage[]): TurnFileEdits[] {
  const turns: TurnFileEdits[] = [];
  let current: TurnFileEdits | null = null;

  messages.forEach((message, index) => {
    if (message.type === 'user') {
      current = { turnIndex: index, files: [] };
      turns.push(current);
      return;
    }

    if (!message.isToolUse || !message.toolName || !current) {
      return;
    }
    const toolName = resolveToolName(String(message.toolName), message.toolId);
    if (!EDIT_TOOL_NAMES.has(toolName)) {
      return;
    }

    const paths = extractAffectedFilePaths(String(message.toolName), readToolInput(message.toolInput));
    for (const filePath of paths) {
      if (!current.files.includes(filePath)) {
        current.files.push(filePath);
      }
    }
  });

  return turns.filter((turn) => turn.files.length > 0);
}

/**
 * Returns every other file edited in the same turn(s) as `filePath`. An empty
 * array means the file was either not edited, or was the only file touched.
 */
export function getBlastRadius(messages: BlastRadiusMessage[], filePath: string): string[] {
  const siblings = new Set<string>();
  for (const turn of collectTurnFileEdits(messages)) {
    if (!turn.files.includes(filePath)) {
      continue;
    }
    for (const file of turn.files) {
      if (file !== filePath) {
        siblings.add(file);
      }
    }
  }
  return Array.from(siblings);
}

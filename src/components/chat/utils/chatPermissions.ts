import type { ChatMessage, ClaudePermissionSuggestion, PermissionGrantResult } from '../types/types.js';

import { CLAUDE_SETTINGS_KEY, getClaudeSettings, safeLocalStorage } from './chatStorage';

export function buildClaudeToolPermissionEntry(toolName?: string, toolInput?: unknown) {
  if (!toolName) return null;
  if (toolName !== 'Bash') return toolName;

  let parsed: unknown = toolInput;
  if (typeof toolInput === 'string') {
    try {
      parsed = JSON.parse(toolInput) as unknown;
    } catch {
      return toolName;
    }
  }

  const command = parsed && typeof parsed === 'object' && 'command' in parsed && typeof parsed.command === 'string'
    ? parsed.command.trim()
    : '';
  if (!command) return toolName;

  const tokens = command.split(/\s+/);
  if (tokens.length === 0) return toolName;

  if (tokens[0] === 'git' && tokens[1]) {
    return `Bash(${tokens[0]} ${tokens[1]}:*)`;
  }
  return `Bash(${tokens[0]}:*)`;
}

export function formatToolInputForDisplay(input: unknown) {
  if (input === undefined || input === null) return '';
  if (typeof input === 'string') return input;
  try {
    return JSON.stringify(input, null, 2);
  } catch {
    return String(input);
  }
}

/** Canonical tool names whose input references one or more file paths. */
const FILE_EDIT_TOOL_NAMES = new Set(['Edit', 'Write', 'ApplyPatch', 'Patch', 'str_replace_editor']);

/** Aliases that map onto the canonical file-edit tools, for provider-agnostic checks. */
const FILE_EDIT_TOOL_ALIASES: Record<string, string> = {
  edit: 'Edit',
  write: 'Write',
  apply_patch: 'ApplyPatch',
  patch: 'ApplyPatch',
  str_replace_editor: 'str_replace_editor',
};

/** Resolves a possibly provider-specific tool name to its canonical form. */
export function resolveCanonicalToolName(toolName?: string): string | undefined {
  if (!toolName) return undefined;
  if (FILE_EDIT_TOOL_NAMES.has(toolName)) return toolName;
  return FILE_EDIT_TOOL_ALIASES[toolName.toLowerCase()];
}

function parseToolInput(input: unknown): unknown {
  if (typeof input !== 'string') return input;
  try {
    return JSON.parse(input) as unknown;
  } catch {
    return input;
  }
}

/** Reads the first present path-like field from a parsed tool input object. */
function readPathField(value: Record<string, unknown>): string | null {
  for (const key of ['file_path', 'filePath', 'path', 'file', 'filename']) {
    const candidate = value[key];
    if (typeof candidate === 'string' && candidate.trim()) {
      return candidate.trim();
    }
  }
  return null;
}

/**
 * Extracts the file paths a file-editing tool will touch, so the UI can show a
 * "blast radius" before the change is approved. Handles the single-file tools
 * (Edit/Write) and multi-file patch payloads (ApplyPatch / codex patches).
 *
 * Returns an empty array for tools whose targets cannot be determined up front
 * (e.g. Bash), so callers can treat "no paths" as "unknown" rather than "none".
 */
export function extractAffectedFilePaths(toolName: string | undefined, toolInput: unknown): string[] {
  const canonical = resolveCanonicalToolName(toolName);
  if (!canonical) return [];

  const parsed = parseToolInput(toolInput);
  if (typeof parsed === 'string') {
    // A raw patch string (ApplyPatch) may reference several files.
    return extractPathsFromPatch(parsed);
  }
  if (!parsed || typeof parsed !== 'object') return [];

  const record = parsed as Record<string, unknown>;
  const paths: string[] = [];

  const direct = readPathField(record);
  if (direct) {
    paths.push(direct);
  }

  // Applied patches carry a combined `patch` string with per-file headers.
  for (const patchField of ['patch', 'input', 'content']) {
    const patchText = record[patchField];
    if (typeof patchText === 'string' && patchText.includes('*** ')) {
      paths.push(...extractPathsFromPatch(patchText));
    }
  }

  return Array.from(new Set(paths));
}

/** Pulls `*** Update/Add/Delete File:` targets out of an apply_patch payload. */
function extractPathsFromPatch(patchText: string): string[] {
  const paths: string[] = [];
  const regex = /^\*\*\* (?:Update|Add|Delete|Move) File:\s*(.+)$/gm;
  let match: RegExpExecArray | null;
  while ((match = regex.exec(patchText)) !== null) {
    const candidate = match[1].trim();
    if (candidate) paths.push(candidate);
  }
  return paths;
}

export function getClaudePermissionSuggestion(
  message: ChatMessage | null | undefined,
  provider: string,
): ClaudePermissionSuggestion | null {
  if (provider !== 'claude') return null;
  if (!message?.toolResult?.isError) return null;

  const toolName = message?.toolName;
  const entry = buildClaudeToolPermissionEntry(toolName, message.toolInput);
  if (!entry) return null;

  const settings = getClaudeSettings();
  const isAllowed = settings.allowedTools.includes(entry);
  return { toolName: toolName || 'UnknownTool', entry, isAllowed };
}

export function grantClaudeToolPermission(entry: string | null): PermissionGrantResult {
  if (!entry) return { success: false };

  const settings = getClaudeSettings();
  const alreadyAllowed = settings.allowedTools.includes(entry);
  const nextAllowed = alreadyAllowed ? settings.allowedTools : [...settings.allowedTools, entry];
  const nextDisallowed = settings.disallowedTools.filter((tool) => tool !== entry);
  const updatedSettings = {
    ...settings,
    allowedTools: nextAllowed,
    disallowedTools: nextDisallowed,
    lastUpdated: new Date().toISOString(),
  };

  safeLocalStorage.setItem(CLAUDE_SETTINGS_KEY, JSON.stringify(updatedSettings));
  return { success: true, alreadyAllowed, updatedSettings };
}

export type ClaudeSettings = {
  allowedTools: string[];
  disallowedTools: string[];
  skipPermissions: boolean;
  projectSortOrder?: string;
  lastUpdated?: string;
};

export function createEmptyClaudeSettings(): ClaudeSettings {
  return { allowedTools: [], disallowedTools: [], skipPermissions: false, projectSortOrder: 'name' };
}

export function parseClaudeSettings(raw: string | null | undefined): ClaudeSettings {
  if (!raw) return createEmptyClaudeSettings();
  try {
    const parsed = JSON.parse(raw) as Partial<ClaudeSettings>;
    return {
      ...parsed,
      allowedTools: Array.isArray(parsed.allowedTools) ? parsed.allowedTools : [],
      disallowedTools: Array.isArray(parsed.disallowedTools) ? parsed.disallowedTools : [],
      skipPermissions: Boolean(parsed.skipPermissions),
      projectSortOrder: parsed.projectSortOrder || 'name',
    };
  } catch {
    return createEmptyClaudeSettings();
  }
}

/**
 * Builds the Claude `allowedTools` entry for a tool: plain name for most tools,
 * `Bash(<cmd>:*)` for shell commands (git subcommands keep two tokens).
 */
export function buildClaudeToolPermissionEntry(toolName?: string, toolInput?: unknown): string | null {
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
  const command =
    parsed && typeof parsed === 'object' && 'command' in parsed && typeof (parsed as { command?: unknown }).command === 'string'
      ? (parsed as { command: string }).command.trim()
      : '';
  if (!command) return toolName;
  const tokens = command.split(/\s+/);
  if (tokens.length === 0) return toolName;
  if (tokens[0] === 'git' && tokens[1]) return `Bash(${tokens[0]} ${tokens[1]}:*)`;
  return `Bash(${tokens[0]}:*)`;
}

export function formatToolInputForDisplay(input: unknown): string {
  if (input === undefined || input === null) return '';
  if (typeof input === 'string') return input;
  try {
    return JSON.stringify(input, null, 2);
  } catch {
    return String(input);
  }
}

const FILE_EDIT_TOOL_NAMES = new Set(['Edit', 'Write', 'ApplyPatch', 'Patch', 'str_replace_editor']);
const FILE_EDIT_TOOL_ALIASES: Record<string, string> = {
  edit: 'Edit',
  write: 'Write',
  apply_patch: 'ApplyPatch',
  patch: 'ApplyPatch',
  str_replace_editor: 'str_replace_editor',
};

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

function readPathField(value: Record<string, unknown>): string | null {
  for (const key of ['file_path', 'filePath', 'path', 'file', 'filename']) {
    const candidate = value[key];
    if (typeof candidate === 'string' && candidate.trim()) return candidate.trim();
  }
  return null;
}

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

/** File paths a file-editing tool will touch ("blast radius" before approval). */
export function extractAffectedFilePaths(toolName: string | undefined, toolInput: unknown): string[] {
  const canonical = resolveCanonicalToolName(toolName);
  if (!canonical) return [];
  const parsed = parseToolInput(toolInput);
  if (typeof parsed === 'string') return extractPathsFromPatch(parsed);
  if (!parsed || typeof parsed !== 'object') return [];
  const record = parsed as Record<string, unknown>;
  const paths: string[] = [];
  const direct = readPathField(record);
  if (direct) paths.push(direct);
  for (const patchField of ['patch', 'input', 'content']) {
    const patchText = record[patchField];
    if (typeof patchText === 'string' && patchText.includes('*** ')) {
      paths.push(...extractPathsFromPatch(patchText));
    }
  }
  return Array.from(new Set(paths));
}

/** Plan-mode approvals are rendered inline (PlanDisplay), not as a permission card. */
export function isPlanToolRequest(toolName?: string): boolean {
  return toolName === 'ExitPlanMode' || toolName === 'exit_plan_mode';
}

/** Request ids that share a permission entry, so "Allow & remember" clears them all. */
export function matchingRememberRequestIds(
  requests: { requestId: string; toolName: string; input?: unknown }[],
  entry: string | null,
  fallbackRequestId: string,
): string[] {
  if (!entry) return [fallbackRequestId];
  return requests
    .filter((item) => buildClaudeToolPermissionEntry(item.toolName, formatToolInputForDisplay(item.input)) === entry)
    .map((item) => item.requestId);
}

export function grantClaudeToolPermission(
  settings: ClaudeSettings,
  entry: string | null,
): { settings: ClaudeSettings; alreadyAllowed: boolean } {
  if (!entry) return { settings, alreadyAllowed: false };
  const alreadyAllowed = settings.allowedTools.includes(entry);
  const allowedTools = alreadyAllowed ? settings.allowedTools : [...settings.allowedTools, entry];
  return {
    settings: {
      ...settings,
      allowedTools,
      disallowedTools: settings.disallowedTools.filter((tool) => tool !== entry),
      lastUpdated: new Date().toISOString(),
    },
    alreadyAllowed,
  };
}

/** Resolves the permission mode to restore: session → pane scope → provider default. */
export function resolveStoredPermissionMode(
  validModes: string[],
  stored: { sessionMode?: string | null; paneMode?: string | null; providerMode?: string | null },
  fallback: string,
): string {
  const candidate = [stored.sessionMode, stored.paneMode, stored.providerMode].find(
    (mode): mode is string => Boolean(mode && validModes.includes(mode)),
  );
  return candidate ?? fallback;
}

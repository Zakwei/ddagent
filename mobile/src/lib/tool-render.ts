/** Pure tool-render logic — no RN deps, runnable under plain Node.
 *
 * Mirrors the web tool layer:
 *  - `src/components/chat/utils/messageTransforms.ts` (LCS diff)
 *  - `src/components/chat/tools/configs/toolConfigs.ts` (display routing)
 *  - `src/components/chat/utils/toolGrouping.ts` (consecutive grouping)
 *  - `src/components/chat/tools/components/ToolStatusBadge.tsx` (status)
 */

import type { ChatMessage } from './chat-messages';

// ---------------------------------------------------------------------------
// Status
// ---------------------------------------------------------------------------

export type ToolStatus = 'running' | 'completed' | 'error' | 'denied';

// Exact denial messages from the Claude runtime adapter — other providers
// can't reliably signal denial (web ToolRenderer.tsx:38-43).
const CLAUDE_DENIAL_MESSAGES = [
  'user denied tool use',
  'tool disallowed by settings',
  'permission request timed out',
  'permission request cancelled',
];

export function deriveToolStatus(hasResult: boolean, isError: boolean, resultContent: string): ToolStatus {
  if (!hasResult) return 'running';
  if (isError) {
    const lower = resultContent.toLowerCase().trim();
    if (CLAUDE_DENIAL_MESSAGES.some((msg) => lower.includes(msg))) return 'denied';
    return 'error';
  }
  return 'completed';
}

export const TOOL_STATUS_LABEL: Record<ToolStatus, string> = {
  running: 'Running',
  completed: 'Completed',
  error: 'Error',
  denied: 'Denied',
};

// ---------------------------------------------------------------------------
// Diff (LCS) — port of web `calculateDiff`
// ---------------------------------------------------------------------------

export interface DiffLine {
  type: 'added' | 'removed';
  content: string;
  lineNum: number;
}

const buildLcsTable = (oldLines: string[], newLines: string[]): number[][] => {
  const table: number[][] = Array.from({ length: oldLines.length + 1 }, () =>
    new Array<number>(newLines.length + 1).fill(0),
  );
  for (let oi = oldLines.length - 1; oi >= 0; oi -= 1) {
    for (let ni = newLines.length - 1; ni >= 0; ni -= 1) {
      table[oi][ni] =
        oldLines[oi] === newLines[ni]
          ? table[oi + 1][ni + 1] + 1
          : Math.max(table[oi + 1][ni], table[oi][ni + 1]);
    }
  }
  return table;
};

export const calculateDiff = (oldStr: string, newStr: string): DiffLine[] => {
  const oldLines = oldStr.split('\n');
  const newLines = newStr.split('\n');
  // Guard against pathological inputs (a whole-file paste can be huge); the
  // O(n*m) table is the web algorithm too. ponytail: no Myers/histogram.
  const lcs = buildLcsTable(oldLines, newLines);
  const out: DiffLine[] = [];
  let oi = 0;
  let ni = 0;
  while (oi < oldLines.length && ni < newLines.length) {
    if (oldLines[oi] === newLines[ni]) {
      oi += 1;
      ni += 1;
      continue;
    }
    if (lcs[oi + 1][ni] >= lcs[oi][ni + 1]) {
      out.push({ type: 'removed', content: oldLines[oi], lineNum: oi + 1 });
      oi += 1;
    } else {
      out.push({ type: 'added', content: newLines[ni], lineNum: ni + 1 });
      ni += 1;
    }
  }
  while (oi < oldLines.length) {
    out.push({ type: 'removed', content: oldLines[oi], lineNum: oi + 1 });
    oi += 1;
  }
  while (ni < newLines.length) {
    out.push({ type: 'added', content: newLines[ni], lineNum: ni + 1 });
    ni += 1;
  }
  return out;
};

// ---------------------------------------------------------------------------
// Tool display routing
// ---------------------------------------------------------------------------

export type ToolContentType =
  | 'diff'
  | 'markdown'
  | 'file-list'
  | 'todo-list'
  | 'task'
  | 'question-answer'
  | 'text';

export interface ToolDisplay {
  kind: 'one-line' | 'collapsible' | 'plan' | 'hidden';
  /** One-line label / collapsible title base. */
  label?: string;
  /** opencode InlineTool glyph. */
  icon: string;
  code?: boolean;
  contentType?: ToolContentType;
  defaultOpen?: boolean;
  /** Result hidden entirely / hidden on success. */
  hideResult?: boolean;
  hideResultOnSuccess?: boolean;
}

const OC_TOOL_ICONS: Record<string, string> = {
  Bash: '$',
  Glob: '✱',
  Grep: '✱',
  Read: '→',
  Write: '←',
  Edit: '←',
  ApplyPatch: '←',
  Task: '⚑',
  AskUserQuestion: '→',
};

export const ocToolIcon = (toolName: string): string => OC_TOOL_ICONS[toolName] || '⚙';

const DISPLAYS: Record<string, ToolDisplay> = {
  Bash: { kind: 'one-line', icon: '$', code: true, hideResultOnSuccess: true },
  Read: { kind: 'one-line', label: 'Read', icon: '→', hideResult: true },
  Ready: { kind: 'one-line', label: 'Ready', icon: '⚙' },
  Grep: { kind: 'one-line', label: 'Grep', icon: '✱' },
  Glob: { kind: 'one-line', label: 'Glob', icon: '✱' },
  Edit: { kind: 'collapsible', icon: '←', contentType: 'diff', hideResultOnSuccess: true },
  Write: { kind: 'collapsible', icon: '←', contentType: 'diff', hideResultOnSuccess: true },
  ApplyPatch: { kind: 'collapsible', icon: '←', contentType: 'diff', hideResultOnSuccess: true },
  TodoWrite: { kind: 'collapsible', label: 'Updating todo list', icon: '⚙', contentType: 'todo-list' },
  TodoRead: { kind: 'one-line', label: 'TodoRead', icon: '⚙' },
  TaskCreate: { kind: 'one-line', label: 'Task', icon: '⚑' },
  TaskUpdate: { kind: 'one-line', label: 'Task', icon: '⚑' },
  TaskList: { kind: 'one-line', label: 'Tasks', icon: '⚑' },
  TaskGet: { kind: 'one-line', label: 'Task', icon: '⚑' },
  Task: { kind: 'collapsible', icon: '⚑', contentType: 'markdown' },
  AskUserQuestion: { kind: 'collapsible', icon: '→', contentType: 'question-answer', defaultOpen: true },
  ExitPlanMode: { kind: 'plan', label: 'Implementation plan', icon: '⚑', defaultOpen: true },
  Default: { kind: 'one-line', icon: '⚙' },
};

const TOOL_NAME_ALIASES: Record<string, string> = {
  edit: 'Edit',
  edits: 'Edit',
  write: 'Write',
  apply_patch: 'ApplyPatch',
  'apply-patch': 'ApplyPatch',
  applypatch: 'ApplyPatch',
  patch: 'ApplyPatch',
  read: 'Read',
  ready: 'Ready',
  bash: 'Bash',
  exec: 'Bash',
  shell: 'Bash',
  sh: 'Bash',
  grep: 'Grep',
  glob: 'Glob',
  todo_write: 'TodoWrite',
  todowrite: 'TodoWrite',
  todo_read: 'TodoRead',
  todoread: 'TodoRead',
  task_create: 'TaskCreate',
  taskcreate: 'TaskCreate',
  task_update: 'TaskUpdate',
  taskupdate: 'TaskUpdate',
  task_list: 'TaskList',
  tasklist: 'TaskList',
  task_get: 'TaskGet',
  taskget: 'TaskGet',
  agent: 'Task',
  run_subagent: 'Task',
  exit_plan_mode: 'ExitPlanMode',
  exitplanmode: 'ExitPlanMode',
  ask_user_question: 'AskUserQuestion',
  askuserquestion: 'AskUserQuestion',
};

const TITLE_VERB_ALIASES: Record<string, string> = {
  wrote: 'Write',
  write: 'Write',
  created: 'Write',
  edited: 'Edit',
  edit: 'Edit',
  patched: 'ApplyPatch',
};

const parseToolId = (toolId?: string): string | undefined => {
  if (!toolId) return undefined;
  return toolId.replace(/:\d+$/, '').replace(/^functions\./, '') || undefined;
};

export function resolveToolName(toolName: string, toolId?: string): string {
  const name = (toolName ?? '').trim();
  if (DISPLAYS[name]) return name;
  const lower = name.toLowerCase();
  const compact = lower.replace(/[\s_-]+/g, '');
  const snake = lower.replace(/[\s-]+/g, '_');
  const alias = TOOL_NAME_ALIASES[lower] || TOOL_NAME_ALIASES[compact] || TOOL_NAME_ALIASES[snake];
  if (alias && DISPLAYS[alias]) return alias;
  const verbAlias = TITLE_VERB_ALIASES[lower.split(/\s+/)[0]];
  if (verbAlias && DISPLAYS[verbAlias]) return verbAlias;
  const fromId = parseToolId(toolId);
  if (fromId) {
    if (DISPLAYS[fromId]) return fromId;
    const idLower = fromId.toLowerCase();
    const idAlias =
      TOOL_NAME_ALIASES[idLower] ||
      TOOL_NAME_ALIASES[idLower.replace(/_/g, '')] ||
      TOOL_NAME_ALIASES[idLower.replace(/-/g, '_')];
    if (idAlias && DISPLAYS[idAlias]) return idAlias;
  }
  return name;
}

export function getToolDisplay(toolName: string, toolId?: string): ToolDisplay {
  return DISPLAYS[resolveToolName(toolName, toolId)] || DISPLAYS.Default;
}

export function shouldHideToolResult(toolName: string, isError: boolean, toolId?: string): boolean {
  const display = getToolDisplay(toolName, toolId);
  if (isError) return false; // errors stay diagnosable
  return Boolean(display.hideResult || display.hideResultOnSuccess);
}

// ---------------------------------------------------------------------------
// Input extraction helpers (snake_case + camelCase providers)
// ---------------------------------------------------------------------------

export const getFilePath = (input: any): string => input?.file_path || input?.filePath || '';
export const getOldString = (input: any): string => input?.old_string || input?.oldString || '';
export const getNewString = (input: any): string => input?.new_string || input?.newString || '';

/** Flattens a tool payload to a single display string (truncated). */
export function flattenToolValue(input: any, max = 400): string {
  if (input == null) return '';
  const raw =
    typeof input === 'string'
      ? input
      : JSON.stringify(input);
  return raw.length > max ? `${raw.slice(0, max)}…` : raw;
}

/** Primary display value + secondary hint for a one-line tool row. */
export function oneLineValues(name: string, input: any): { value: string; secondary?: string } {
  const resolved = resolveToolName(name);
  if (!input || typeof input !== 'object') return { value: flattenToolValue(input) };
  switch (resolved) {
    case 'Bash':
      return { value: String(input.command ?? ''), secondary: input.description ? String(input.description) : undefined };
    case 'Read': {
      const offset = input.offset ?? input.startLine;
      return { value: getFilePath(input), secondary: offset ? `at ${offset}` : undefined };
    }
    case 'Grep':
    case 'Glob':
      return {
        value: String(input.pattern ?? input.query ?? ''),
        secondary: input.path ? `in ${input.path}` : undefined,
      };
    case 'TaskCreate':
      return { value: String(input.subject ?? 'Creating task'), secondary: input.status ? String(input.status) : undefined };
    case 'TaskUpdate': {
      const parts: string[] = [];
      if (input.taskId) parts.push(`#${input.taskId}`);
      if (input.status) parts.push(String(input.status));
      if (input.subject) parts.push(`"${input.subject}"`);
      return { value: parts.join(' → ') || 'updating' };
    }
    case 'TaskGet':
      return { value: input.taskId ? `#${input.taskId}` : 'fetching' };
    case 'TaskList':
      return { value: 'listing tasks' };
    case 'TodoRead':
      return { value: 'reading list' };
    case 'Ready':
      return { value: String(input.message ?? input.status ?? input.text ?? 'Ready') };
    default:
      return { value: flattenToolValue(input) };
  }
}

export function collapsibleTitle(name: string, input: any): string {
  const resolved = resolveToolName(name);
  if (resolved === 'Edit' || resolved === 'Write' || resolved === 'ApplyPatch') {
    const path = getFilePath(input);
    return path?.split('/').pop() || path || 'file';
  }
  if (resolved === 'Task') {
    const subagentType = input?.subagent_type || 'Agent';
    const description = input?.description || 'Running task';
    return `Subagent / ${subagentType}: ${description}`;
  }
  if (resolved === 'AskUserQuestion') {
    const count = Array.isArray(input?.questions) ? input.questions.length : 0;
    const answered = input?.answers && Object.keys(input.answers).length > 0;
    if (count === 1) {
      const header = input.questions[0]?.header || 'Question';
      return answered ? `${header} — answered` : header;
    }
    return answered ? `${count} questions — answered` : `${count} questions`;
  }
  const display = getToolDisplay(name);
  return display.label || resolved;
}

/** Old/new text for a diff-capable tool payload. */
export function diffContentFor(name: string, input: any): { old: string; new: string; badge: 'Edit' | 'New' | 'Patch' } {
  const resolved = resolveToolName(name);
  if (resolved === 'Write') {
    return { old: '', new: String(input?.content ?? input?.contentText ?? ''), badge: 'New' };
  }
  if (resolved === 'ApplyPatch') {
    return { old: getOldString(input), new: getNewString(input), badge: 'Patch' };
  }
  return { old: getOldString(input), new: getNewString(input), badge: 'Edit' };
}

export function extractFilePaths(input: any): string[] {
  const candidates = [input?.filenames, input?.files, input?.paths, input?.toolUseResult?.filenames];
  for (const c of candidates) {
    if (Array.isArray(c)) {
      return c
        .map((f) => (typeof f === 'string' ? f : f?.path))
        .filter((f): f is string => typeof f === 'string' && f.length > 0);
    }
  }
  const single = getFilePath(input);
  return single ? [single] : [];
}

/** Parses TaskList/TaskGet text (e.g. `#15. [in_progress] Subject`). */
export interface TaskListItem {
  id: string;
  subject: string;
  status: 'pending' | 'in_progress' | 'completed';
}

export function parseTaskListContent(content: string): TaskListItem[] {
  const tasks: TaskListItem[] = [];
  for (const line of content.split('\n')) {
    const match = line.match(/#(\d+)\.?\s*(?:\[(\w+)\]\s*)?(.+?)(?:\s*\((?:owner:\s*\w+)?\))?$/);
    if (match) {
      const [, id, status, subject] = match;
      tasks.push({
        id,
        subject: subject.trim(),
        status: (status as TaskListItem['status']) || 'pending',
      });
    }
  }
  return tasks;
}

// ---------------------------------------------------------------------------
// Consecutive tool grouping (web toolGrouping.ts)
// ---------------------------------------------------------------------------

export const TOOL_GROUP_THRESHOLD = 3;
const UNGROUPABLE_TOOL_NAMES = new Set(['Edit', 'Write', 'ApplyPatch']);

export interface ToolGroupItem {
  _isGroup: true;
  toolName: string;
  messages: ChatMessage[];
  timestamp?: number;
}

export type MessageListItem = ChatMessage | ToolGroupItem;

export const isToolGroupItem = (item: MessageListItem): item is ToolGroupItem =>
  (item as ToolGroupItem)._isGroup === true;

/**
 * A message groups when it is tool-only and carries exactly one groupable tool.
 * Edit/Write/ApplyPatch stay visible (highest signal) and subagent containers
 * render on their own (web toolGrouping.ts:14-27).
 */
function groupableToolName(message: ChatMessage): string | null {
  if (message.role !== 'assistant') return null;
  if (message.text?.trim()) return null;
  if (!message.tools || message.tools.length !== 1) return null;
  if (message.isSubagentContainer) return null;
  const name = resolveToolName(message.tools[0].name, message.tools[0].id);
  if (UNGROUPABLE_TOOL_NAMES.has(name)) return null;
  return name;
}

export function groupConsecutiveTools(
  messages: ChatMessage[],
  showThinking: boolean = true,
): MessageListItem[] {
  const items: MessageListItem[] = [];
  let index = 0;
  while (index < messages.length) {
    const message = messages[index];
    const name = groupableToolName(message);
    if (!name) {
      items.push(message);
      index += 1;
      continue;
    }
    const run: ChatMessage[] = [message];
    let next = index + 1;
    while (next < messages.length) {
      const candidate = messages[next];
      // Invisible interleaved reasoning shouldn't split a run.
      if (candidate.role === 'thinking' && !showThinking) {
        next += 1;
        continue;
      }
      if (groupableToolName(candidate) === name) {
        run.push(candidate);
        next += 1;
        continue;
      }
      break;
    }
    if (run.length >= TOOL_GROUP_THRESHOLD) {
      items.push({
        _isGroup: true,
        toolName: name,
        messages: run,
        timestamp: run[run.length - 1]?.timestamp ?? message.timestamp,
      });
    } else {
      items.push(...run);
    }
    index = next;
  }
  return items;
}

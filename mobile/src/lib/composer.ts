// Pure composer helpers: @mention items, slash-command grouping, built-in
// command-result parsing and submit-button state. Mirrors the web composer
// (useMentions.tsx / useSlashCommands.ts / CommandMenu.tsx / CommandResultModal.tsx)
// without any RN or expo dependency so it can run in the Node self-check.

export type MentionType = 'file' | 'session' | 'task';

export interface MentionableItem {
  id: string;
  title: string;
  type: MentionType;
  value: string;
  subtitle?: string;
}

export interface ProjectFileNode {
  name: string;
  type: 'file' | 'directory';
  path?: string;
  children?: ProjectFileNode[];
}

export const flattenFileTree = (nodes: ProjectFileNode[], basePath = ''): MentionableItem[] => {
  let out: MentionableItem[] = [];
  for (const node of nodes || []) {
    const fullPath = basePath ? `${basePath}/${node.name}` : node.name;
    if (node.type === 'directory' && node.children) {
      out = out.concat(flattenFileTree(node.children, fullPath));
    } else if (node.type === 'file') {
      out.push({ id: fullPath, title: node.name, type: 'file', value: fullPath, subtitle: node.path ?? fullPath });
    }
  }
  return out;
};

const OPEN_TASK_STATUSES_EXCLUDED = ['done', 'cancelled'];
export const isOpenTask = (status?: string | null): boolean =>
  !status || !OPEN_TASK_STATUSES_EXCLUDED.includes(status);

export const MENTION_LIMIT = 15;

export function filterMentions(items: MentionableItem[], query: string): MentionableItem[] {
  const q = query.toLowerCase();
  // On a bare '@' surface files first so the picker reads as a file picker.
  const ordered =
    q === ''
      ? items.filter((m) => m.type === 'file').concat(items.filter((m) => m.type !== 'file'))
      : items;
  const matches = ordered
    .filter(
      (m) =>
        m.title.toLowerCase().includes(q) ||
        (m.subtitle ? m.subtitle.toLowerCase().includes(q) : false) ||
        m.id.toLowerCase().includes(q),
    )
    .slice(0, MENTION_LIMIT);
  // A spaced query with no matches means the '@' was prose — close, don't hold.
  if (q.includes(' ') && matches.length === 0) return [];
  return matches;
}

/** Locate the active @-query ending at `cursor`: returns text after '@' or null. */
export function mentionQueryAt(input: string, cursor: number): string | null {
  const before = input.slice(0, cursor);
  const at = before.lastIndexOf('@');
  if (at === -1) return null;
  const after = before.slice(at + 1);
  if (after.includes('\n')) return null;
  return after;
}

/** Replace the active @-query with the picked token; returns new text + cursor. */
export function insertMention(
  input: string,
  mention: MentionableItem,
  atPosition: number,
  cursor: number,
): { text: string; cursor: number } {
  const before = input.slice(0, atPosition);
  const after = input.slice(cursor);
  const value = `@${mention.value}`;
  const text = `${before}${value} ${after}`;
  return { text, cursor: before.length + value.length + 1 };
}

/** Ordered mention tokens present in the text (for highlight overlay). */
export function activeMentionTokens(input: string, tokens: string[]): string[] {
  if (!input || tokens.length === 0) return [];
  const present = tokens.filter((t) => input.includes(t));
  return Array.from(new Set(present)).sort((a, b) => b.length - a.length);
}

const escapeRegExp = (value: string): string => value.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

/** Split text into plain/mention parts so an overlay can highlight mentions. */
export function splitMentionParts(text: string, tokens: string[]): { text: string; mention: boolean }[] {
  const sorted = activeMentionTokens(text, tokens);
  if (sorted.length === 0) return [{ text, mention: false }];
  const re = new RegExp(`(${sorted.map(escapeRegExp).join('|')})`, 'g');
  return text
    .split(re)
    .map((part) => ({ text: part, mention: sorted.includes(part) }))
    .filter((part) => part.text.length > 0);
}

// --- Slash commands -------------------------------------------------------

export interface SlashCommand {
  name: string;
  description?: string;
  namespace?: string;
  path?: string;
  type?: 'built-in' | 'custom' | 'skill' | string;
  metadata?: Record<string, unknown>;
  [key: string]: unknown;
}

export const NAMESPACE_LABELS: Record<string, string> = {
  frequent: 'Frequently Used',
  builtin: 'Built-in Commands',
  skill: 'Skills',
  project: 'Project Commands',
  user: 'User Commands',
  other: 'Other Commands',
};

export const getNamespace = (command: SlashCommand): string => command.namespace || command.type || 'other';

export function filterSlashCommands(commands: SlashCommand[], query: string): SlashCommand[] {
  const q = query.trim().toLowerCase();
  if (!q) return commands;
  const prefix = q.startsWith('/') ? q : `/${q}`;
  const prefixMatches = commands.filter((c) => c.name.toLowerCase().startsWith(prefix));
  if (q.includes(':') || prefixMatches.length > 0) return prefixMatches;
  const substring = commands.filter((c) => c.name.toLowerCase().includes(q));
  if (substring.length > 0) return substring;
  return commands.filter((c) => c.description?.toLowerCase().includes(q));
}

/** Query typed after a leading '/' (empty string for a bare '/'). */
export function slashQueryAt(input: string): string | null {
  const match = input.match(/^\/(\S*)$/);
  return match ? match[1] : null;
}

export interface CommandRow {
  command: SlashCommand;
  commandIndex: number;
}

export interface CommandGroup {
  namespace: string;
  label: string;
  rows: CommandRow[];
}

const PREFERRED_ORDER = ['frequent', 'builtin', 'skill', 'project', 'user', 'other'];

/** Group commands by namespace, frequent first (mirrors CommandMenu.tsx). */
export function groupCommands(commands: SlashCommand[], frequent: SlashCommand[] = []): CommandGroup[] {
  const groups: Record<string, CommandRow[]> = {};
  const frequentKeys = new Set(frequent.map((c) => `${getNamespace(c)}::${c.name}`));
  const indexesByKey = new Map<string, number[]>();
  commands.forEach((command, index) => {
    const key = `${getNamespace(command)}::${command.name}`;
    const list = indexesByKey.get(key) ?? [];
    list.push(index);
    indexesByKey.set(key, list);
  });
  const occurrences = new Map<string, number>();

  commands.forEach((command, index) => {
    const key = `${getNamespace(command)}::${command.name}`;
    if (frequentKeys.has(key)) return;
    const ns = getNamespace(command);
    (groups[ns] ??= []).push({ command, commandIndex: index });
  });

  if (frequent.length > 0) {
    groups.frequent = frequent
      .map((command) => {
        const key = `${getNamespace(command)}::${command.name}`;
        const occurrence = occurrences.get(key) ?? 0;
        occurrences.set(key, occurrence + 1);
        const indexes = indexesByKey.get(key) ?? [];
        return { command, commandIndex: indexes[occurrence] ?? indexes[0] ?? -1 };
      })
      .filter((row) => row.commandIndex >= 0);
  }

  const order = frequent.length > 0 ? PREFERRED_ORDER : PREFERRED_ORDER.filter((n) => n !== 'frequent');
  const extras = Object.keys(groups).filter((n) => !PREFERRED_ORDER.includes(n));
  return [...order, ...extras]
    .filter((ns) => groups[ns] && groups[ns].length > 0)
    .map((ns) => ({ namespace: ns, label: NAMESPACE_LABELS[ns] ?? ns, rows: groups[ns] }));
}

/** Wrap-around list index stepping shared by menus. */
export function stepIndex(current: number, length: number, delta: number): number {
  if (length <= 0) return -1;
  if (current < 0) return delta > 0 ? 0 : length - 1;
  return (current + delta + length) % length;
}

/** Flatten visible command rows in render order (for keyboard nav). */
export function flattenCommandRows(groups: CommandGroup[]): CommandRow[] {
  return groups.flatMap((group) => group.rows);
}

// --- Built-in command results --------------------------------------------

export type CommandModalKind = 'help' | 'models' | 'cost' | 'status';

export interface CommandResult {
  type?: string;
  action?: string;
  command?: string;
  content?: string;
  data?: Record<string, unknown>;
}

export interface CommandModalPayload {
  kind: CommandModalKind;
  data: Record<string, unknown>;
}

const BUILTIN_MODAL_ACTIONS: Record<string, CommandModalKind> = {
  help: 'help',
  models: 'models',
  cost: 'cost',
  status: 'status',
};

/**
 * Map a /commands/execute payload to a modal. Returns null for non-modal
 * actions (memory/config/custom) and a {content} marker for custom commands
 * the caller should insert into the composer instead.
 */
export function resolveCommandResult(
  result: CommandResult | null | undefined,
): { modal: CommandModalPayload } | { insertText: string } | { action: 'memory' | 'config' } | null {
  if (!result) return null;
  if (result.type === 'custom' && typeof result.content === 'string') {
    return { insertText: result.content };
  }
  const action = result.action ?? '';
  const kind = BUILTIN_MODAL_ACTIONS[action];
  if (kind) return { modal: { kind, data: (result.data ?? {}) as Record<string, unknown> } };
  if (action === 'memory' || action === 'config') return { action };
  return null;
}

// --- Attachments ----------------------------------------------------------

export type AttachmentKind = 'image' | 'file';

export interface PendingAttachment {
  uri: string;
  name: string;
  mimeType: string;
  size?: number;
}

export function attachmentKind(mimeType?: string, name?: string): AttachmentKind {
  if (mimeType?.startsWith('image/')) return 'image';
  if (/\.(gif|jpe?g|png|svg|webp)$/i.test(name ?? '')) return 'image';
  return 'file';
}

/** Short uppercase kind label for non-image chips (web `oc-chip-kind`). */
export function attachmentKindLabel(mimeType?: string, name?: string): string {
  const ext = (name ?? '').split('.').pop() ?? '';
  if (ext && ext.toLowerCase() !== name?.toLowerCase()) return ext.slice(0, 3).toUpperCase();
  const subtype = (mimeType ?? '').split('/')[1] ?? '';
  return subtype ? subtype.slice(0, 3).toUpperCase() : 'FILE';
}

// --- Submit button --------------------------------------------------------

export type SubmitAction = 'send' | 'queue' | 'stop' | 'disabled';

export interface SubmitState {
  action: SubmitAction;
  label: string;
}

/**
 * Decide what the send button does: stop a running turn, queue the next
 * message while streaming, send normally, or disable when empty.
 */
export function submitState(opts: {
  hasText: boolean;
  hasAttachments?: boolean;
  running: boolean;
  queuedCount?: number;
}): SubmitState {
  const hasContent = opts.hasText || Boolean(opts.hasAttachments);
  if (opts.running && hasContent) {
    return { action: 'queue', label: (opts.queuedCount ?? 0) > 0 ? 'Update queued message' : 'Queue next message' };
  }
  if (opts.running) return { action: 'stop', label: 'Stop' };
  if (!hasContent) return { action: 'disabled', label: 'Send' };
  return { action: 'send', label: 'Send' };
}

/** Enter inserts a newline instead of sending when the preference is on. */
export function shouldSubmitOnEnter(sendByCtrlEnter: boolean, ctrlOrMeta: boolean): boolean {
  return sendByCtrlEnter ? ctrlOrMeta : !ctrlOrMeta;
}

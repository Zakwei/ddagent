import fsSync from 'node:fs';
import os from 'node:os';
import path from 'node:path';

import type { Database as DatabaseType } from 'better-sqlite3';

import { sessionsDb } from '@/modules/database/index.js';
import type { AnyRecord } from '@/shared/types.js';
import {
  AppError,
  getOpenCodeDatabasePath,
  openSqliteReadonlyDatabase,
  readJsonRecord,
  readObjectRecord,
  readOptionalString,
} from '@/shared/utils.js';

type ChangedFileEntry = {
  path: string;
  edits: number;
  subagent: boolean;
};

// OpenCode tool names that mutate file contents. `patch`/`apply_patch` cover
// the dedicated patch parts; the rest are the standard edit/write tools.
const OPENCODE_EDIT_TOOLS = new Set(['edit', 'write', 'multiedit', 'apply_patch', 'patch']);

// Devin tool names (lowercase compare) that mutate file contents.
const DEVIN_EDIT_TOOLS = new Set([
  'edit',
  'write',
  'notebook_edit',
  'multiedit',
  'str_replace_editor',
  'apply_patch',
]);

// Devin ACP tool titles prefix the verb ("Edit file", "Wrote ./src/a.ts",
// "Patched x"). Mirrors the verb aliases in toolConfigs.attachToolTitlePath so
// transcript rows resolve to the same edit classification the UI applies.
const DEVIN_EDIT_TITLE_PATTERN = /^(wrote|write|created|edited|edit|patched|apply.?patch)(\s|$|\()/i;
const DEVIN_TITLE_PATH_PATTERN = /^(?:wrote|write|created|edited|patched)\s+(\S+)$/i;

function mergeEditEntry(filesByPath: Map<string, ChangedFileEntry>, filePath: string, subagent: boolean): void {
  const existing = filesByPath.get(filePath);
  if (existing) {
    existing.edits += 1;
    existing.subagent = existing.subagent || subagent;
    return;
  }
  filesByPath.set(filePath, { path: filePath, edits: 1, subagent });
}

function toSortedFileList(filesByPath: Map<string, ChangedFileEntry>): ChangedFileEntry[] {
  return [...filesByPath.values()].sort((a, b) => (a.path < b.path ? -1 : a.path > b.path ? 1 : 0));
}

/**
 * Resolves the OpenCode session ids that belong to one conversation: the root
 * provider session plus every descendant subagent session linked through
 * `session.parent_id`. Older OpenCode databases predate the column, in which
 * case only the root session contributes edits.
 */
function collectOpenCodeSessionIds(db: DatabaseType, rootSessionId: string): string[] {
  const columns = db.prepare('PRAGMA table_info(session)').all() as Array<{ name: string }>;
  if (!columns.some((column) => column.name === 'parent_id')) {
    return [rootSessionId];
  }

  const rows = db.prepare(`
    WITH RECURSIVE tree(id) AS (
      SELECT id FROM session WHERE id = ?
      UNION ALL
      SELECT s.id FROM session s JOIN tree t ON s.parent_id = t.id
    ) SELECT id FROM tree
  `).all(rootSessionId) as Array<{ id: string }>;

  return rows.length > 0 ? rows.map((row) => row.id) : [rootSessionId];
}

/**
 * Exported for the provider test suite (changed-files.test.ts): merges file
 * edits recorded in OpenCode's `part` rows for one session tree. `patch` parts
 * carry a `files` array of absolute paths (each counts as one edit, so VCS-level
 * changes made via bash are captured too); `tool` parts contribute
 * `state.input.filePath`/`file_path` when the tool is an edit/write variant.
 * Parts belonging to a descendant session are flagged as subagent edits.
 */
export function collectOpenCodeChangedFiles(db: DatabaseType, rootSessionId: string): ChangedFileEntry[] {
  const sessionIds = collectOpenCodeSessionIds(db, rootSessionId);
  const placeholders = sessionIds.map(() => '?').join(', ');
  const rows = db.prepare(
    `SELECT session_id, data FROM part WHERE session_id IN (${placeholders})`,
  ).all(...sessionIds) as Array<{ session_id: string; data: string }>;

  const filesByPath = new Map<string, ChangedFileEntry>();
  for (const row of rows) {
    const data = readJsonRecord(row.data);
    if (!data) {
      continue;
    }
    const subagent = row.session_id !== rootSessionId;
    const partType = readOptionalString(data.type);

    if (partType === 'patch') {
      const files = Array.isArray(data.files) ? data.files : [];
      for (const file of files) {
        const filePath = readOptionalString(file);
        if (filePath) {
          mergeEditEntry(filesByPath, filePath, subagent);
        }
      }
      continue;
    }

    if (partType !== 'tool') {
      continue;
    }
    const toolName = readOptionalString(data.tool)?.toLowerCase();
    if (!toolName || !OPENCODE_EDIT_TOOLS.has(toolName)) {
      continue;
    }
    const input = readObjectRecord(readObjectRecord(data.state)?.input) ?? {};
    const filePath = readOptionalString(input.filePath) ?? readOptionalString(input.file_path);
    if (filePath) {
      mergeEditEntry(filesByPath, filePath, subagent);
    }
  }

  return toSortedFileList(filesByPath);
}

type DevinMessageNode = {
  nodeId: number;
  parentNodeId: number | null;
  messageId: string | null;
  toolCalls: AnyRecord[];
};

function readDevinToolCallArguments(argumentsValue: unknown): AnyRecord {
  if (typeof argumentsValue === 'string') {
    return readJsonRecord(argumentsValue) ?? {};
  }
  return readObjectRecord(argumentsValue) ?? {};
}

/**
 * Exported for the provider test suite (changed-files.test.ts): merges file
 * edits recorded as `tool_calls` on Devin `message_nodes` rows.
 *
 * Subagent attribution: Devin keeps subagent work on side branches of the same
 * session's message graph (tracked in `subagent_heads`), so nodes off the main
 * chain — the ancestor walk from `sessions.main_chain_id` — are subagent edits.
 * Two graph artifacts need correcting first: Devin ACP writes stream and
 * final-turn duplicates of the same assistant message as sibling nodes (same
 * `message_id`, same `tool_calls[].id`), so (a) a node whose `message_id`
 * appears on a main-chain node is still main-session work even when the node
 * itself sits off-chain, and (b) identical tool calls are deduped by call id
 * so one logical edit counts once. When `main_chain_id` is absent or does not
 * resolve to a known node, every node counts as main-session work.
 */
export function collectDevinDbChangedFiles(db: DatabaseType, sessionId: string): ChangedFileEntry[] {
  const rows = db.prepare(
    'SELECT node_id, parent_node_id, chat_message FROM message_nodes WHERE session_id = ?',
  ).all(sessionId) as Array<{ node_id: number; parent_node_id: number | null; chat_message: string }>;
  if (rows.length === 0) {
    return [];
  }

  const nodes: DevinMessageNode[] = [];
  const parentById = new Map<number, number | null>();
  for (const row of rows) {
    const message = readJsonRecord(row.chat_message);
    const toolCalls = Array.isArray(message?.tool_calls)
      ? message.tool_calls.map((call: unknown) => readObjectRecord(call) ?? {})
      : [];
    nodes.push({
      nodeId: row.node_id,
      parentNodeId: row.parent_node_id,
      messageId: readOptionalString(message?.message_id) ?? null,
      toolCalls,
    });
    parentById.set(row.node_id, row.parent_node_id);
  }

  let mainChainId: number | null = null;
  try {
    const sessionRow = db.prepare('SELECT main_chain_id FROM sessions WHERE id = ?')
      .get(sessionId) as { main_chain_id: number | null } | undefined;
    if (sessionRow?.main_chain_id != null && parentById.has(sessionRow.main_chain_id)) {
      mainChainId = sessionRow.main_chain_id;
    }
  } catch {
    // Older Devin databases may lack the sessions table; treat every node as
    // main-chain rather than dropping the session's own edits.
  }

  const mainChainNodeIds = new Set<number>();
  if (mainChainId !== null) {
    let currentId: number | null = mainChainId;
    while (currentId !== null && parentById.has(currentId) && !mainChainNodeIds.has(currentId)) {
      mainChainNodeIds.add(currentId);
      currentId = parentById.get(currentId) ?? null;
    }
  }
  const hasMainChain = mainChainNodeIds.size > 0;

  const mainChainMessageIds = new Set<string>();
  if (hasMainChain) {
    for (const node of nodes) {
      if (node.messageId && mainChainNodeIds.has(node.nodeId)) {
        mainChainMessageIds.add(node.messageId);
      }
    }
  }

  const isMainSessionNode = (node: DevinMessageNode): boolean => {
    if (!hasMainChain) {
      return true;
    }
    return mainChainNodeIds.has(node.nodeId)
      || (node.messageId !== null && mainChainMessageIds.has(node.messageId));
  };

  // Dedupe tool calls by provider call id: the stream/final twin of an
  // assistant node repeats the same call, and a main-session occurrence wins
  // the subagent flag (the twin is the same logical edit, not subagent work).
  const callsByCallId = new Map<string, { filePath: string; subagent: boolean }>();
  for (const node of nodes) {
    const nodeIsSubagent = !isMainSessionNode(node);
    node.toolCalls.forEach((call, index) => {
      const toolName = readOptionalString(call.name)?.toLowerCase();
      if (!toolName || !DEVIN_EDIT_TOOLS.has(toolName)) {
        return;
      }
      const args = readDevinToolCallArguments(call.arguments);
      const filePath = readOptionalString(args.file_path) ?? readOptionalString(args.filePath);
      if (!filePath) {
        return;
      }
      const callId = readOptionalString(call.id) ?? `${node.nodeId}:${index}`;
      const existing = callsByCallId.get(callId);
      if (existing) {
        existing.subagent = existing.subagent && nodeIsSubagent;
      } else {
        callsByCallId.set(callId, { filePath, subagent: nodeIsSubagent });
      }
    });
  }

  const filesByPath = new Map<string, ChangedFileEntry>();
  for (const call of callsByCallId.values()) {
    mergeEditEntry(filesByPath, call.filePath, call.subagent);
  }
  return toSortedFileList(filesByPath);
}

/**
 * Collects file edits from the ddagent JSONL transcript the Devin runtime
 * appends while a session runs. `tool_use` rows carry an ACP title ("Edit file",
 * "Wrote ./src/a.ts") plus the raw input; a row counts as an edit when the title
 * resolves to an edit verb or the input carries an `old_string`/`oldString`
 * payload. Transcript rows never carry subagent attribution, so every edit is
 * reported as main-session work.
 */
function collectDevinJsonlChangedFiles(jsonlPath: string): ChangedFileEntry[] {
  let content: string;
  try {
    content = fsSync.readFileSync(jsonlPath, 'utf8');
  } catch {
    return [];
  }

  const filesByPath = new Map<string, ChangedFileEntry>();
  for (const line of content.split(/\r?\n/)) {
    if (!line.trim()) {
      continue;
    }
    let record: AnyRecord | null = null;
    try {
      record = readObjectRecord(JSON.parse(line));
    } catch {
      // A partial final line while the runtime is mid-append — skip it.
      continue;
    }
    if (!record || record.kind !== 'tool_use') {
      continue;
    }

    const toolName = readOptionalString(record.toolName) ?? '';
    const input = typeof record.toolInput === 'string'
      ? (readJsonRecord(record.toolInput) ?? {})
      : (readObjectRecord(record.toolInput) ?? {});
    const isEditTitle = DEVIN_EDIT_TITLE_PATTERN.test(toolName.trim());
    const hasOldString = input.old_string != null || input.oldString != null;
    if (!isEditTitle && !hasOldString) {
      continue;
    }

    let filePath = readOptionalString(input.file_path) ?? readOptionalString(input.filePath);
    if (!filePath) {
      // Mirrors attachToolTitlePath: when the input lacks a path, the ACP title
      // can carry it ("Wrote ./src/a.ts"). The /[/.]/ check keeps plain verb
      // rows like "Wrote" from capturing the title's own trailing word.
      const titlePathMatch = DEVIN_TITLE_PATH_PATTERN.exec(toolName.trim());
      if (titlePathMatch && /[/.]/.test(titlePathMatch[1])) {
        filePath = titlePathMatch[1];
      }
    }
    if (filePath) {
      mergeEditEntry(filesByPath, filePath, false);
    }
  }

  return toSortedFileList(filesByPath);
}

function openReadonlyDatabaseOrNull(dbPath: string): DatabaseType | null {
  try {
    return openSqliteReadonlyDatabase(dbPath);
  } catch {
    return null;
  }
}

function resolveDevinJsonlPath(session: NonNullable<ReturnType<typeof sessionsDb.getSessionById>>, providerSessionId: string): string | null {
  if (session.jsonl_path && fsSync.existsSync(session.jsonl_path)) {
    return session.jsonl_path;
  }
  if (session.project_path) {
    const fallback = path.join(session.project_path, '.ddagent', 'devin', `${providerSessionId}.jsonl`);
    if (fsSync.existsSync(fallback)) {
      return fallback;
    }
  }
  return null;
}

/**
 * changedFilesService: used by provider.routes.ts to serve
 * `GET /api/providers/sessions/:sessionId/changed-files`.
 */
export const changedFilesService = {
  /**
   * Lists files edited during one app session, including edits performed by
   * subagents (OpenCode child sessions; Devin side branches). Providers whose
   * storage does not expose edit records return an empty list, as do draft
   * sessions that never received a provider-native id.
   */
  listSessionChangedFiles(sessionId: string): { files: ChangedFileEntry[] } {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    if (!session.provider_session_id) {
      return { files: [] };
    }
    const providerSessionId = session.provider_session_id;

    if (session.provider === 'opencode') {
      const db = openReadonlyDatabaseOrNull(getOpenCodeDatabasePath());
      if (!db) {
        return { files: [] };
      }
      try {
        return { files: collectOpenCodeChangedFiles(db, providerSessionId) };
      } catch {
        return { files: [] };
      } finally {
        try {
          db.close();
        } catch {
          // Ignore close errors on a best-effort read path.
        }
      }
    }

    if (session.provider === 'devin') {
      const filesByPath = new Map<string, ChangedFileEntry>();

      const devinDbPath = path.join(os.homedir(), '.local', 'share', 'devin', 'cli', 'sessions.db');
      const db = openReadonlyDatabaseOrNull(devinDbPath);
      if (db) {
        try {
          for (const entry of collectDevinDbChangedFiles(db, providerSessionId)) {
            filesByPath.set(entry.path, entry);
          }
        } catch {
          // A schema drift in Devin's CLI database must not hide JSONL edits.
        } finally {
          try {
            db.close();
          } catch {
            // Ignore close errors on a best-effort read path.
          }
        }
      }

      const jsonlPath = resolveDevinJsonlPath(session, providerSessionId);
      if (jsonlPath) {
        for (const entry of collectDevinJsonlChangedFiles(jsonlPath)) {
          const existing = filesByPath.get(entry.path);
          if (existing) {
            // The Devin DB and the JSONL record the same logical edits, so
            // counts are not summed — but a pruned DB can undercount, so keep
            // the larger of the two.
            existing.edits = Math.max(existing.edits, entry.edits);
            existing.subagent = existing.subagent || entry.subagent;
          } else {
            filesByPath.set(entry.path, entry);
          }
        }
      }

      return { files: toSortedFileList(filesByPath) };
    }

    return { files: [] };
  },
};

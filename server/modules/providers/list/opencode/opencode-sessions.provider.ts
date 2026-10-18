import fsSync from 'node:fs';

import Database from 'better-sqlite3';

import { parseFilesInputTag, parseImagesInputTag } from '@/shared/image-attachments.js';
import type { IProviderSessions } from '@/shared/interfaces.js';
import type { AnyRecord, FetchHistoryOptions, FetchHistoryResult, NormalizedMessage } from '@/shared/types.js';
import {
  AppError,
  createNormalizedMessage,
  formatCliToolResult,
  generateMessageId,
  getOpenCodeDatabasePath,
  normalizeProviderTimestamp,
  OPENCODE_EDIT_TOOL_NAMES,
  openSqliteReadonlyDatabase,
  readObjectRecord,
  readJsonRecord,
  readOptionalString,
  sliceTailPage,
  unwrapJsonStringLiteral,
} from '@/shared/utils.js';

const PROVIDER = 'opencode';

// Mirrors the client's realtime user-dedupe window: two identical persisted
// user rows this close together are one turn stored twice, not a resend.
const USER_ROW_DEDUPE_WINDOW_MS = 3000;

type OpenCodeHistoryRow = {
  message_id: string;
  message_time_created: number | null;
  message_data: string | null;
  part_id: string | null;
  part_time_created: number | null;
  part_data: string | null;
};

type OpenCodeTokenTotals = {
  inputTokens: number;
  outputTokens: number;
  reasoningTokens: number;
  cacheReadTokens: number;
  cacheWriteTokens: number;
  costUsd?: number;
};

const openOpenCodeDatabase = (): Database.Database | null => {
  const dbPath = getOpenCodeDatabasePath();
  if (!fsSync.existsSync(dbPath)) {
    return null;
  }

  return openSqliteReadonlyDatabase(dbPath);
};

const openCodeTableExists = (db: Database.Database, table: string): boolean =>
  Boolean(db.prepare("SELECT 1 AS present FROM sqlite_master WHERE type = 'table' AND name = ?").get(table));

/**
 * OpenCode 2 stores a session in `session_v2` with one `session_message` row
 * per transcript entry (user, assistant, idle, system, …). Sessions created
 * by 1.x stay in `session`/`message`/`part` until OpenCode migrates them, so
 * the layout is decided per session.
 */
const isOpenCodeV2Session = (db: Database.Database, sessionIds: string[]): boolean => {
  if (sessionIds.length === 0 || !openCodeTableExists(db, 'session_v2')) {
    return false;
  }
  const placeholders = sessionIds.map(() => '?').join(', ');
  return Boolean(db.prepare(`SELECT 1 AS present FROM session_v2 WHERE id IN (${placeholders}) LIMIT 1`).get(...sessionIds));
};

type OpenCodeV2MessageRow = {
  id: string;
  type: string;
  seq: number;
  time_created: number | null;
  data: string | null;
};

type SessionFingerprint = {
  messageCount: number;
  partCount: number;
  messageUpdated: number | null;
  partUpdated: number | null;
};

/**
 * "Did this session's rows change since the last fetch" — the four aggregates
 * stay inside the session's index/row span even on a multi-GB opencode.db, so
 * checking costs a few ms instead of re-normalizing the whole transcript.
 * `time_updated` covers in-place rewrites (a finishing tool part) that a row
 * count alone would miss.
 */
const readSessionFingerprint = (
  db: Database.Database,
  sessionIds: string[],
): SessionFingerprint => {
  const placeholders = sessionIds.map(() => '?').join(', ');
  const row = db.prepare(`
    SELECT
      (SELECT COUNT(*) FROM message WHERE session_id IN (${placeholders})) AS messageCount,
      (SELECT COUNT(*) FROM part WHERE session_id IN (${placeholders})) AS partCount,
      (SELECT MAX(time_updated) FROM message WHERE session_id IN (${placeholders})) AS messageUpdated,
      (SELECT MAX(time_updated) FROM part WHERE session_id IN (${placeholders})) AS partUpdated
  `).get(...sessionIds, ...sessionIds, ...sessionIds, ...sessionIds) as SessionFingerprint;
  return row;
};

/** `session_message` variant of [readSessionFingerprint] (no part rows). */
const readV2SessionFingerprint = (
  db: Database.Database,
  sessionIds: string[],
): SessionFingerprint => {
  const placeholders = sessionIds.map(() => '?').join(', ');
  const row = db.prepare(`
    SELECT
      COUNT(*) AS messageCount,
      MAX(time_updated) AS messageUpdated
    FROM session_message
    WHERE session_id IN (${placeholders})
  `).get(...sessionIds) as { messageCount: number; messageUpdated: number | null };
  return { messageCount: row.messageCount, partCount: 0, messageUpdated: row.messageUpdated, partUpdated: null };
};

const sameFingerprint = (a: SessionFingerprint, b: SessionFingerprint): boolean =>
  a.messageCount === b.messageCount
  && a.partCount === b.partCount
  && a.messageUpdated === b.messageUpdated
  && a.partUpdated === b.partUpdated;

type CachedTranscript = {
  fingerprint: SessionFingerprint;
  normalized: NormalizedMessage[];
  tokenUsage: AnyRecord | undefined;
};

// The page a pane actually renders is tiny next to a multi-thousand-row
// history, and SQL paging cannot express normalized-unit offsets (merges,
// dedupe, skipped rows) — so one fingerprinted rebuild per write plus a
// bounded in-memory cache replaces re-scanning the whole session per request.
const TRANSCRIPT_CACHE_MAX_SESSIONS = 4;
const TRANSCRIPT_CACHE_MAX_MESSAGES = 100_000;

// Kept for error/legacy payloads; tool results now render through the shared
// CLI formatter so the persisted patch/diff reaches the UI like the CLI.
const formatToolContent = (value: unknown): string => formatCliToolResult(value, undefined);

// Readable text for named OpenCode errors that carry no message of their own
// (MessageOutputLengthError's `data` is empty).
const OPENCODE_ERROR_LABELS: Record<string, string> = {
  MessageOutputLengthError: 'Output length limit reached',
  MessageAbortedError: 'The response was aborted',
  ContextOverflowError: 'Context window exceeded',
  ContentFilterError: 'The response was blocked by the provider content filter',
  ProviderAuthError: 'Provider authentication failed',
  StructuredOutputError: 'Structured output failed',
  APIError: 'Provider API error',
  UnknownError: 'OpenCode error',
};

/**
 * Extracts a human-readable error message from an OpenCode error payload.
 *
 * OpenCode emits errors in several shapes:
 * - a plain string (`error: "text"`)
 * - an object with a `message` field (`error: { message: "text" }`)
 * - an object with `data.message` (`error: { name: "UnknownError", data: { message: "text" } }`)
 * - a named error without a message (`{ name: "MessageOutputLengthError", data: {} }`),
 *   mapped to a readable label instead of the bare class name.
 *
 * Consumed by the opencode runtime (live `message.updated` / `session.error`)
 * so live and reloaded error rows read the same.
 */
export const extractOpenCodeErrorMessage = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    return value.trim() || undefined;
  }

  const record = readObjectRecord(value);
  if (!record) {
    return undefined;
  }

  // 1.x: `{ name, data: { message } }`; OpenCode 2: `{ type, message }`.
  const name = readOptionalString(record.name) ?? readOptionalString(record.type);
  return readOptionalString(record.message)
    ?? readOptionalString(readObjectRecord(record.data)?.message)
    ?? (name ? OPENCODE_ERROR_LABELS[name] ?? name.replace(/Error$/, ' error').replace(/([a-z])([A-Z])/g, '$1 $2') : undefined);
};

/** A user Stop surfaces as MessageAbortedError — not an error worth a row. */
const isOpenCodeAbortError = (value: unknown): boolean => {
  const record = readObjectRecord(value);
  const name = readOptionalString(record?.name) ?? readOptionalString(record?.type) ?? '';
  return name === 'MessageAbortedError' || /abort|interrupt/i.test(name);
};

/**
 * Text of an OpenCode 2 tool result: `content` is a list of text items and
 * file references (`{type:'file', uri, mime, name}`). Consumed by the
 * OpenCode runtime for live `session.tool.success` events and by the
 * history reader below.
 */
export const joinOpenCodeToolContent = (content: unknown): string | undefined => {
  if (!Array.isArray(content)) {
    return undefined;
  }
  const parts: string[] = [];
  for (const item of content) {
    const record = readObjectRecord(item);
    if (!record) {
      continue;
    }
    if (typeof record.text === 'string') {
      parts.push(record.text);
    } else if (typeof record.uri === 'string') {
      parts.push(`[file] ${readOptionalString(record.name) ?? ''} ${record.uri}`.replace(/\s+/g, ' ').trim());
    }
  }
  return parts.length > 0 ? parts.join('\n') : undefined;
};

/** Compaction marker shown as a persistent notice (C1). */
const compactionNoticeText = (part: AnyRecord): string =>
  part.auto === true ? 'Context compacted automatically' : 'Context compacted';

/** `subtask` parts render as an Agent tool card (the delegated prompt). */
const subtaskToolInput = (part: AnyRecord): AnyRecord => ({
  description: readOptionalString(part.description) ?? '',
  prompt: readOptionalString(part.prompt) ?? '',
  ...(readOptionalString(part.agent) ? { subagent_type: readOptionalString(part.agent) } : {}),
});

// The subtask part only records the hand-off (the run itself is the `task`
// tool), so it is settled up front instead of spinning forever.
const subtaskToolResult = (part: AnyRecord) => ({
  content: `Delegated to ${readOptionalString(part.agent) ?? 'subagent'}`,
  isError: false,
});

const extractText = (value: unknown): string => {
  if (typeof value === 'string') {
    return unwrapJsonStringLiteral(value);
  }

  const record = readObjectRecord(value);
  const text = readOptionalString(record?.text)
    ?? readOptionalString(record?.content)
    ?? '';
  return unwrapJsonStringLiteral(text);
};

const hasUserRole = (value: unknown): boolean => {
  const record = readObjectRecord(value);
  return readOptionalString(record?.role) === 'user';
};

const isUserTextEcho = (raw: AnyRecord): boolean => {
  return readOptionalString(raw.role) === 'user'
    || hasUserRole(raw.message)
    || hasUserRole(raw.part);
};

const buildTokenUsage = (totals: OpenCodeTokenTotals | undefined): AnyRecord | undefined => {
  if (!totals) {
    return undefined;
  }

  const inputTokens = totals.inputTokens;
  const outputTokens = totals.outputTokens;
  const cacheReadTokens = totals.cacheReadTokens;
  const cacheCreationTokens = totals.cacheWriteTokens;
  const used = inputTokens
    + outputTokens
    + totals.reasoningTokens
    + cacheReadTokens
    + cacheCreationTokens;

  if (used <= 0) {
    return undefined;
  }

  // Report direct input separately from cache. Folding cache into `input`
  // made cache-heavy sessions look like a giant fresh prompt and billed the
  // reads at the full input rate in the client cost estimate. When OpenCode
  // stored a provider-reported cost, surface it so the client can show the
  // real charge instead of guessing from a static price table.
  return {
    used,
    inputTokens,
    outputTokens,
    cacheReadTokens,
    cacheCreationTokens,
    ...(totals.costUsd && totals.costUsd > 0 ? { costUsd: totals.costUsd } : {}),
    breakdown: {
      input: inputTokens,
      output: outputTokens,
      cacheRead: cacheReadTokens,
      cacheCreation: cacheCreationTokens,
    },
  };
};

const readOpenCodeSessionColumnTokenUsage = (
  db: Database.Database,
  sessionId: string,
): AnyRecord | undefined => {
  const columns = db.prepare('PRAGMA table_info(session)').all() as { name: string }[];
  const columnNames = new Set(columns.map((column) => column.name));
  const requiredColumns = ['tokens_input', 'tokens_output', 'tokens_reasoning', 'tokens_cache_read', 'tokens_cache_write'];
  if (!requiredColumns.every((column) => columnNames.has(column))) {
    return undefined;
  }

  const row = db.prepare(`
    SELECT
      tokens_input AS inputTokens,
      tokens_output AS outputTokens,
      tokens_reasoning AS reasoningTokens,
      tokens_cache_read AS cacheReadTokens,
      tokens_cache_write AS cacheWriteTokens,
      cost AS costUsd
    FROM session
    WHERE id = ?
  `).get(sessionId) as (OpenCodeTokenTotals & { costUsd: number | null }) | undefined;

  if (!row) {
    return undefined;
  }

  return buildTokenUsage({
    inputTokens: Number(row.inputTokens ?? 0),
    outputTokens: Number(row.outputTokens ?? 0),
    reasoningTokens: Number(row.reasoningTokens ?? 0),
    cacheReadTokens: Number(row.cacheReadTokens ?? 0),
    cacheWriteTokens: Number(row.cacheWriteTokens ?? 0),
    costUsd: Number(row.costUsd ?? 0),
  });
};

/** OpenCode 2 keeps per-session token totals on the `session_v2` row. */
const readOpenCodeV2TokenUsage = (
  db: Database.Database,
  sessionId: string,
): AnyRecord | undefined => {
  const row = db.prepare(`
    SELECT
      tokens_input AS inputTokens,
      tokens_output AS outputTokens,
      tokens_reasoning AS reasoningTokens,
      tokens_cache_read AS cacheReadTokens,
      tokens_cache_write AS cacheWriteTokens,
      cost AS costUsd
    FROM session_v2
    WHERE id = ?
  `).get(sessionId) as (OpenCodeTokenTotals & { costUsd: number | null }) | undefined;
  if (!row) {
    return undefined;
  }
  return buildTokenUsage({
    inputTokens: Number(row.inputTokens ?? 0),
    outputTokens: Number(row.outputTokens ?? 0),
    reasoningTokens: Number(row.reasoningTokens ?? 0),
    cacheReadTokens: Number(row.cacheReadTokens ?? 0),
    cacheWriteTokens: Number(row.cacheWriteTokens ?? 0),
    costUsd: Number(row.costUsd ?? 0),
  });
};

/**
 * OpenCode 1.x stores per-message token counts on assistant `message.data`
 * objects (see MessageV2.Assistant); some 1.x builds also kept session-level
 * counters, which win when present.
 */
const aggregateOpenCodeSessionTokenUsage = (
  db: Database.Database,
  sessionId: string,
): AnyRecord | undefined => {
  const sessionColumnUsage = readOpenCodeSessionColumnTokenUsage(db, sessionId);
  if (sessionColumnUsage) {
    return sessionColumnUsage;
  }

  const rows = db.prepare('SELECT data FROM message WHERE session_id = ?').all(sessionId) as { data: string }[];

  let inputTokens = 0;
  let outputTokens = 0;
  let reasoningTokens = 0;
  let cacheReadTokens = 0;
  let cacheWriteTokens = 0;

  for (const row of rows) {
    const info = readJsonRecord(row.data);
    if (readOptionalString(info?.role) !== 'assistant') {
      continue;
    }

    const tokens = readObjectRecord(info?.tokens);
    if (!tokens) {
      continue;
    }

    inputTokens += Number(tokens.input ?? 0);
    outputTokens += Number(tokens.output ?? 0);
    reasoningTokens += Number(tokens.reasoning ?? 0);
    const cache = readObjectRecord(tokens.cache);
    cacheReadTokens += Number(cache?.read ?? 0);
    cacheWriteTokens += Number(cache?.write ?? 0);
  }

  return buildTokenUsage({
    inputTokens,
    outputTokens,
    reasoningTokens,
    cacheReadTokens,
    cacheWriteTokens,
  });
};

export class OpenCodeSessionsProvider implements IProviderSessions {
  /**
   * Parent-message roles resolved lazily from the shared session DB. Live
   * `message.part.updated` payloads carry the part but not its message's role,
   * so a user text part would otherwise be mistaken for an assistant reply.
   */
  private readonly liveMessageRoles = new Map<string, string>();

  private readonly transcriptCache = new Map<string, CachedTranscript>();

  /**
   * Looks up a persisted message's role by id, caching hits. Misses are not
   * cached — the row may simply not be committed yet when the event arrives.
   */
  private resolveLiveMessageRole(messageId: string | undefined): string | undefined {
    if (!messageId) {
      return undefined;
    }
    const cached = this.liveMessageRoles.get(messageId);
    if (cached) {
      return cached;
    }

    const db = openOpenCodeDatabase();
    if (!db) {
      return undefined;
    }
    try {
      const row = db.prepare('SELECT data FROM message WHERE id = ?').get(messageId) as { data?: string } | undefined;
      const role = readOptionalString(readJsonRecord(row?.data)?.role);
      if (role) {
        this.liveMessageRoles.set(messageId, role);
      }
      return role;
    } catch {
      return undefined;
    } finally {
      db.close();
    }
  }

  /**
   * Normalizes live `opencode run --format json` events into frontend messages.
   */
  normalizeMessage(rawMessage: unknown, sessionId: string | null): NormalizedMessage[] {
    const raw = readObjectRecord(rawMessage);
    if (!raw) {
      return [];
    }

    // OpenCode `run --format json` wraps the per-step payload in a `part`
    // object (with its own id, type and timing) while keeping the top-level
    // `type`/`sessionID` envelope. Read the part first, then fall back to the
    // legacy flat shape used by tests and older CLI versions.
    const part = readObjectRecord(raw.part) ?? {};
    const hasPart = !!readOptionalString(part.type);
    const source = hasPart ? part : raw;

    const type = readOptionalString(part.type)
      ?? readOptionalString(raw.type)
      ?? readOptionalString(raw.event);
    const eventSessionId = readOptionalString(part.sessionID)
      ?? readOptionalString(raw.sessionID)
      ?? readOptionalString(part.sessionId)
      ?? readOptionalString(raw.sessionId)
      ?? sessionId;
    const time = readObjectRecord(source.time);
    const timestamp = normalizeProviderTimestamp(
      time?.end
      ?? time?.start
      ?? source.time_created
      ?? raw.time
      ?? raw.timestamp,
    );
    const baseId = readOptionalString(part.id)
      ?? readOptionalString(raw.id)
      ?? readOptionalString(part.messageID)
      ?? readOptionalString(raw.messageID)
      ?? generateMessageId('opencode');

    // OpenCode emits the durable message and part ids in the live event.
    // Match the id used by fetchHistory so realtime rows are de-duplicated
    // by the session store once the persisted transcript arrives.
    const stableId = readOptionalString(part.messageID) && readOptionalString(part.id)
      ? `${part.messageID}_${part.id}`
      : baseId;

    if (type === 'text') {
      // The client already renders an optimistic user bubble, so provider user
      // echoes must not be streamed back as assistant text. Live part payloads
      // omit the role, so the parent message's persisted role is checked too;
      // synthetic parts (plugin-injected reminders) are not user-authored.
      if (
        part.synthetic === true
        || isUserTextEcho(raw)
        || isUserTextEcho(part)
        || this.resolveLiveMessageRole(
          readOptionalString(part.messageID) ?? readOptionalString(raw.messageID),
        ) === 'user'
      ) {
        return [];
      }

      const content = extractText(part).trim() || extractText(raw).trim();
      if (!content) {
        return [];
      }

      // Real OpenCode `text` parts carry the complete assistant reply, not a
      // true streaming delta. Emitting it as a `text` message with the stable
      // history id lets the client reconcile it with the persisted row and
      // avoids a duplicate streaming placeholder. Legacy flat events still
      // flow through as stream_delta to keep existing tests and old CLIs.
      const kind = hasPart ? 'text' : 'stream_delta';
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind,
        ...(kind === 'text' ? { role: 'assistant' } : {}),
        content,
      })];
    }

    if (type === 'reasoning') {
      const content = extractText(part).trim() || extractText(raw).trim();
      if (!content) {
        return [];
      }

      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'thinking',
        content,
      })];
    }

    if (type === 'tool' || type === 'tool_use') {
      const state = readObjectRecord(source.state) ?? {};
      const rawToolName = readOptionalString(source.tool)
        ?? readOptionalString(source.name)
        ?? 'Tool';
      const toolName = rawToolName.toLowerCase() === 'task' ? 'Task' : rawToolName;
      const toolId = readOptionalString(source.callID)
        ?? readOptionalString(source.toolCallId)
        ?? stableId;
      const toolInput = state.input ?? source.input ?? source.arguments ?? {};
      const toolOutput = state.output ?? source.output;
      const toolError = state.error ?? source.error;
      const isError = toolError !== undefined
        || state.status === 'error'
        || source.status === 'error';

      const toolMessage = createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'tool_use',
        toolName,
        toolInput,
        toolId,
      });

      const messages: NormalizedMessage[] = [toolMessage];
      const hasResult = toolOutput !== undefined
        || toolError !== undefined
        || state.status === 'completed'
        || state.status === 'error'
        || source.status === 'completed'
        || source.status === 'error';

      if (hasResult) {
        const resultContent = formatCliToolResult(
          toolOutput,
          toolError,
          state.metadata ?? source.metadata,
        );
        toolMessage.toolResult = { content: resultContent, isError };

        messages.push(createNormalizedMessage({
          id: `${stableId}_result`,
          sessionId: eventSessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'tool_result',
          toolId,
          content: resultContent,
          isError,
        }));
      }

      return messages;
    }

    if (type === 'error') {
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'error',
        content: extractOpenCodeErrorMessage(part.error)
          ?? extractOpenCodeErrorMessage(raw.error)
          ?? readOptionalString(raw.message)
          ?? 'Unknown OpenCode error',
      })];
    }

    if (type === 'step-start' || type === 'step_start') {
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'status',
        text: 'Thinking',
        canInterrupt: true,
      })];
    }

    if (type === 'step-finish' || type === 'step_finish') {
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'stream_end',
      })];
    }

    if (type === 'compaction') {
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'status',
        text: compactionNoticeText(source),
        notice: true,
      })];
    }

    if (type === 'subtask') {
      return [createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'tool_use',
        toolName: 'Agent',
        toolInput: subtaskToolInput(source),
        toolId: stableId,
        toolResult: subtaskToolResult(source),
      })];
    }

    // DCP / patch / agent live events surfaced so the UI does not lose context
    // while a distributed compute step or agent patch is in flight.
    if (type === 'patch' || type === 'agent') {
      const toolInput = source;
      const toolMessage = createNormalizedMessage({
        id: stableId,
        sessionId: eventSessionId,
        timestamp,
        provider: PROVIDER,
        kind: 'tool_use',
        toolName: type === 'patch' ? 'Patch' : 'Agent',
        toolInput,
        toolId: stableId,
      });

      const patchFiles = Array.isArray(toolInput.files) ? toolInput.files : [];
      const patchHash = readOptionalString(toolInput.hash);
      if (patchFiles.length > 0) {
        toolMessage.toolResult = {
          content: `Applied patch${patchHash ? ` (${patchHash.slice(0, 12)})` : ''} to:\n${patchFiles.map((f: unknown) => `- ${f}`).join('\n')}`,
          isError: false,
        };
      }

      return [toolMessage];
    }

    return [];
  }

  /**
   * Loads OpenCode history from the shared SQLite session database.
   */
  async fetchHistory(
    sessionId: string,
    options: FetchHistoryOptions = {},
  ): Promise<FetchHistoryResult> {
    const { limit = null, offset = 0 } = options;
    // OpenCode's shared sqlite database keys messages by the provider-native
    // session id, not the app-facing id this method is addressed with.
    const providerSessionId = options.providerSessionId ?? sessionId;
    const db = openOpenCodeDatabase();
    if (!db) {
      // Sessions only reach the sidebar because this database was scanned —
      // reporting an empty transcript here would cache a phantom "empty
      // session" client-side, so a missing store is a real failure.
      throw new AppError('OpenCode session database is not available.', {
        code: 'PROVIDER_HISTORY_UNAVAILABLE',
        statusCode: 503,
      });
    }

    try {
      const normalizedOffset = Math.max(0, offset);
      const normalizedLimit = limit === null ? null : Math.max(0, limit);
      const providerSessionIds = [...new Set([providerSessionId, sessionId].filter(Boolean))];
      const cacheKey = `${providerSessionId}${sessionId}`;
      // Older fixtures/schemas can lack time_updated — fall back to always
      // rebuilding instead of failing the fetch.
      const v2 = isOpenCodeV2Session(db, providerSessionIds);
      let fingerprint: SessionFingerprint | null = null;
      try {
        fingerprint = v2
          ? readV2SessionFingerprint(db, providerSessionIds)
          : readSessionFingerprint(db, providerSessionIds);
      } catch {
        fingerprint = null;
      }
      const cached = fingerprint ? this.transcriptCache.get(cacheKey) : undefined;

      if (cached && fingerprint && sameFingerprint(cached.fingerprint, fingerprint)) {
        // LRU touch so the session being viewed survives eviction.
        this.transcriptCache.delete(cacheKey);
        this.transcriptCache.set(cacheKey, cached);
        const { page, hasMore } = sliceTailPage(cached.normalized, normalizedLimit, normalizedOffset);
        return {
          messages: page,
          total: cached.normalized.length,
          hasMore,
          offset: normalizedOffset,
          limit: normalizedLimit,
          tokenUsage: cached.tokenUsage,
        };
      }

      const placeholders = providerSessionIds.map(() => '?').join(', ');
      let normalized: NormalizedMessage[];
      let tokenUsage: AnyRecord | undefined;
      if (v2) {
        const rows = db.prepare(`
          SELECT id, type, seq, time_created, data
          FROM session_message
          WHERE session_id IN (${placeholders})
          ORDER BY seq, time_created, id
        `).iterate(...providerSessionIds) as Iterable<OpenCodeV2MessageRow>;
        normalized = this.normalizeV2Rows(rows, sessionId);
        tokenUsage = readOpenCodeV2TokenUsage(db, providerSessionId);
      } else {
        const rows = db.prepare(`
          SELECT
            m.id AS message_id,
            m.time_created AS message_time_created,
            m.data AS message_data,
            p.id AS part_id,
            p.time_created AS part_time_created,
            p.data AS part_data
          FROM message m
          LEFT JOIN part p
            ON p.session_id = m.session_id
           AND p.message_id = m.id
          WHERE m.session_id IN (${placeholders})
          ORDER BY
            COALESCE(m.time_created, 0),
            m.id,
            COALESCE(p.time_created, 0),
            p.id
        `).iterate(...providerSessionIds) as Iterable<OpenCodeHistoryRow>;
        normalized = this.normalizeHistoryRows(rows, sessionId);
        tokenUsage = aggregateOpenCodeSessionTokenUsage(db, providerSessionId);
      }

      if (fingerprint && normalized.length <= TRANSCRIPT_CACHE_MAX_MESSAGES) {
        this.transcriptCache.set(cacheKey, { fingerprint, normalized, tokenUsage });
        while (this.transcriptCache.size > TRANSCRIPT_CACHE_MAX_SESSIONS) {
          const oldestKey = this.transcriptCache.keys().next().value;
          if (oldestKey === undefined) break;
          this.transcriptCache.delete(oldestKey);
        }
      }

      const total = normalized.length;
      const { page, hasMore } = sliceTailPage(normalized, normalizedLimit, normalizedOffset);

      return {
        messages: page,
        total,
        hasMore,
        offset: normalizedOffset,
        limit: normalizedLimit,
        tokenUsage,
      };
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn(`[OpenCodeProvider] Failed to load session ${sessionId}:`, message);
      // An empty page reads as "authoritative empty transcript" downstream and
      // is even cached as such — surface the failure instead of faking it.
      throw new AppError(`Failed to load OpenCode session history: ${message}`, {
        code: 'PROVIDER_HISTORY_UNAVAILABLE',
        statusCode: 503,
      });
    } finally {
      db.close();
    }
  }

  /**
   * OpenCode 2 transcript: one `session_message` row per entry. An assistant
   * row carries its text, reasoning and tool calls in `content`; ids are
   * `<messageID>_text_<n>` / `<messageID>_reasoning_<n>` / `<messageID>_<callID>`
   * — the same ids the live runtime emits, so streamed rows and reloaded
   * history de-duplicate in the session store.
   */
  private normalizeV2Rows(rows: Iterable<OpenCodeV2MessageRow>, sessionId: string): NormalizedMessage[] {
    const normalized: NormalizedMessage[] = [];
    let lastAssistantErrorText: string | null = null;

    for (const row of rows) {
      const data = readJsonRecord(row.data) ?? {};
      const rowTime = readObjectRecord(data.time);
      const timestamp = normalizeProviderTimestamp(rowTime?.created ?? row.time_created);

      if (row.type === 'user') {
        const rawContent = extractText(data);
        const parsedImages = parseImagesInputTag(rawContent);
        const parsedFiles = parseFilesInputTag(parsedImages.text);
        if (!parsedFiles.text.trim() && parsedImages.attachments.length === 0 && parsedFiles.attachments.length === 0) {
          continue;
        }
        normalized.push(createNormalizedMessage({
          id: row.id,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'text',
          role: 'user',
          content: parsedFiles.text,
          images: parsedImages.attachments.length > 0 ? parsedImages.attachments : undefined,
          files: parsedFiles.attachments.length > 0 ? parsedFiles.attachments : undefined,
        }));
        continue;
      }

      if (row.type === 'assistant') {
        lastAssistantErrorText = null;
        const counters = { text: 0, reasoning: 0 };
        const content = Array.isArray(data.content) ? data.content : [];
        for (const entry of content) {
          const item = readObjectRecord(entry);
          const itemType = readOptionalString(item?.type);
          if (!item || !itemType) {
            continue;
          }
          const itemTime = readObjectRecord(item.time);
          const itemTimestamp = normalizeProviderTimestamp(itemTime?.created ?? rowTime?.created ?? row.time_created);
          if (itemType === 'text' || itemType === 'reasoning') {
            const ordinal = counters[itemType]++;
            const text = extractText(item);
            if (!text.trim()) {
              continue;
            }
            normalized.push(createNormalizedMessage({
              id: `${row.id}_${itemType}_${ordinal}`,
              sessionId,
              timestamp: itemTimestamp,
              provider: PROVIDER,
              kind: itemType === 'text' ? 'text' : 'thinking',
              ...(itemType === 'text' ? { role: 'assistant' } : {}),
              content: text,
            }));
            continue;
          }
          if (itemType === 'tool') {
            const callId = readOptionalString(item.id) ?? `${row.id}_${normalized.length}`;
            const state = readObjectRecord(item.state) ?? {};
            const status = readOptionalString(state.status);
            const rawToolName = readOptionalString(item.name) ?? 'Tool';
            const toolName = rawToolName.toLowerCase() === 'task' ? 'Task' : rawToolName;
            let toolInput: unknown = state.input ?? {};
            if (typeof toolInput === 'string') {
              toolInput = readJsonRecord(toolInput) ?? { input: toolInput };
            }
            const toolMessage = createNormalizedMessage({
              id: `${row.id}_${callId}`,
              sessionId,
              timestamp: itemTimestamp,
              provider: PROVIDER,
              kind: 'tool_use',
              toolName,
              toolInput,
              toolId: callId,
            });
            if (status === 'completed' || status === 'error') {
              toolMessage.toolResult = {
                content: formatCliToolResult(joinOpenCodeToolContent(state.content), state.error, state.metadata),
                isError: status === 'error',
              };
            }
            normalized.push(toolMessage);
          }
        }
        if (data.error != null && !isOpenCodeAbortError(data.error)) {
          const text = extractOpenCodeErrorMessage(data.error) ?? formatToolContent(data.error);
          lastAssistantErrorText = text;
          normalized.push(createNormalizedMessage({
            id: `${row.id}_error`,
            sessionId,
            timestamp,
            provider: PROVIDER,
            kind: 'error',
            content: text,
          }));
        }
        continue;
      }

      if (row.type === 'idle') {
        // The turn's outcome; a failure that the assistant row already
        // reported is not repeated.
        if (readOptionalString(data.outcome) === 'failed' && data.error != null && !isOpenCodeAbortError(data.error)) {
          const text = extractOpenCodeErrorMessage(data.error) ?? formatToolContent(data.error);
          if (text !== lastAssistantErrorText) {
            normalized.push(createNormalizedMessage({
              id: `${row.id}_error`,
              sessionId,
              timestamp,
              provider: PROVIDER,
              kind: 'error',
              content: text,
            }));
          }
        }
        continue;
      }

      if (row.type === 'compaction') {
        normalized.push(createNormalizedMessage({
          id: row.id,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'status',
          text: readOptionalString(data.reason) === 'auto' ? 'Context compacted automatically' : 'Context compacted',
          notice: true,
        }));
        continue;
      }

      if (row.type === 'shell') {
        // A `!command` the user ran inside the session — shown as a Bash card.
        const output = readObjectRecord(data.output);
        const toolMessage = createNormalizedMessage({
          id: row.id,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'tool_use',
          toolName: 'Bash',
          toolInput: { command: readOptionalString(data.command) ?? '' },
          toolId: row.id,
        });
        const status = readOptionalString(data.status);
        if (status && status !== 'running') {
          toolMessage.toolResult = {
            content: readOptionalString(output?.output) ?? '',
            isError: status !== 'exited' || (typeof data.exit === 'number' && data.exit !== 0),
          };
        }
        normalized.push(toolMessage);
      }
      // system / synthetic / skill / agent-switched / model-switched /
      // location-switched rows are model context, not conversation.
    }
    return normalized;
  }

  private normalizeHistoryRows(rows: Iterable<OpenCodeHistoryRow>, sessionId: string): NormalizedMessage[] {
    const normalized: NormalizedMessage[] = [];
    const emittedMessageErrors = new Set<string>();
    const emittedUserTextByMessageId = new Map<string, NormalizedMessage>();
    // Join ordering keeps one message's part rows consecutive, so its JSON is
    // parsed once instead of once per part.
    let lastMessageId: string | null = null;
    let lastMessageInfo: AnyRecord | null = null;
    // Messages that already produced an edit tool card — their auto-generated
    // `patch` echo part is redundant and skipped below.
    const editedMessageIds = new Set<string>();
    const emittedUserRows: {
      messageId: string;
      message: NormalizedMessage;
      time: number;
      claimed: boolean;
    }[] = [];

    for (const row of rows) {
      const timestamp = normalizeProviderTimestamp(row.part_time_created ?? row.message_time_created);
      const baseId = `${row.message_id}_${row.part_id ?? normalized.length}`;
      if (row.message_id !== lastMessageId) {
        lastMessageId = row.message_id;
        lastMessageInfo = readJsonRecord(row.message_data) ?? null;
      }
      const messageInfo = lastMessageInfo;
      const messageRole = readOptionalString(messageInfo?.role);

      if (
        messageInfo
        && messageRole === 'assistant'
        && messageInfo.error != null
        && !isOpenCodeAbortError(messageInfo.error)
        && !emittedMessageErrors.has(row.message_id)
      ) {
        emittedMessageErrors.add(row.message_id);
        normalized.push(createNormalizedMessage({
          id: `${baseId}_error`,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'error',
          content: extractOpenCodeErrorMessage(messageInfo.error) ?? formatToolContent(messageInfo.error),
        }));
      }

      if (!row.part_id) {
        continue;
      }

      const partData = readJsonRecord(row.part_data) ?? {};
      const partType = readOptionalString(partData.type);
      if (!partType) {
        continue;
      }

      // Synthetic parts are injected model context (plugin reminders and the
      // like), not user-authored text — they never render, and merging them
      // into the user row would break the client-side fingerprint that drops
      // the optimistic bubble once this row lands.
      if (partData.synthetic === true) {
        continue;
      }

      if (partType === 'text') {
        const rawContent = extractText(partData);
        // User prompts sent with attachments carry an <images_input> path
        // list; strip it for display and surface the paths as images.
        const parsedImages = messageRole === 'user'
          ? parseImagesInputTag(rawContent)
          : { text: rawContent, attachments: [] };
        const parsedFiles = messageRole === 'user'
          ? parseFilesInputTag(parsedImages.text)
          : { text: rawContent, attachments: [] };
        if (
          parsedFiles.text.trim()
          || parsedImages.attachments.length > 0
          || parsedFiles.attachments.length > 0
        ) {
          const emittedUserText = messageRole === 'user'
            ? emittedUserTextByMessageId.get(row.message_id)
            : undefined;
          if (emittedUserText) {
            // OpenCode persists one logical user turn as several `text` parts
            // (the prompt plus injected reminder/context parts); merge them
            // into the first emitted row so the chat renders a single bubble.
            emittedUserText.content = [emittedUserText.content, parsedFiles.text]
              .filter((text): text is string => typeof text === 'string' && text.trim().length > 0)
              .join('\n\n');
            const mergedImages = [
              ...(Array.isArray(emittedUserText.images) ? emittedUserText.images : []),
              ...parsedImages.attachments,
            ];
            const mergedFiles = [
              ...(Array.isArray(emittedUserText.files) ? emittedUserText.files : []),
              ...parsedFiles.attachments,
            ];
            emittedUserText.images = mergedImages.length > 0 ? mergedImages : undefined;
            emittedUserText.files = mergedFiles.length > 0 ? mergedFiles : undefined;
          } else {
            // Upstream OpenCode can persist one logical turn as two separate
            // message rows when a prompt is processed twice server-side
            // (anomalyco/opencode#27928). The merge above only joins parts
            // under one message_id, so collapse an identical user row landing
            // within a few seconds into the first emitted copy. One-to-one
            // claiming keeps an intentional rapid resend visible.
            const rowTime = row.part_time_created ?? row.message_time_created ?? 0;
            const duplicate = messageRole === 'user'
              ? emittedUserRows.find((candidate) =>
                  !candidate.claimed
                  && candidate.messageId !== row.message_id
                  && (candidate.message.content || '').trim() === parsedFiles.text.trim()
                  && (Array.isArray(candidate.message.images) ? candidate.message.images.length : 0) === parsedImages.attachments.length
                  && (Array.isArray(candidate.message.files) ? candidate.message.files.length : 0) === parsedFiles.attachments.length
                  && Math.abs(candidate.time - rowTime) <= USER_ROW_DEDUPE_WINDOW_MS)
              : undefined;
            if (duplicate) {
              duplicate.claimed = true;
              continue;
            }

            const textMessage = createNormalizedMessage({
              id: baseId,
              sessionId,
              timestamp,
              provider: PROVIDER,
              kind: 'text',
              role: messageRole === 'user' ? 'user' : 'assistant',
              content: parsedFiles.text,
              images: parsedImages.attachments.length > 0 ? parsedImages.attachments : undefined,
              files: parsedFiles.attachments.length > 0 ? parsedFiles.attachments : undefined,
            });
            normalized.push(textMessage);
            if (messageRole === 'user') {
              emittedUserTextByMessageId.set(row.message_id, textMessage);
              emittedUserRows.push({ messageId: row.message_id, message: textMessage, time: rowTime, claimed: false });
            }
          }
        }
        continue;
      }

      if (partType === 'reasoning') {
        const content = extractText(partData);
        if (content.trim()) {
          normalized.push(createNormalizedMessage({
            id: baseId,
            sessionId,
            timestamp,
            provider: PROVIDER,
            kind: 'thinking',
            content,
          }));
        }
        continue;
      }

      if (partType === 'tool') {
        const state = readObjectRecord(partData.state) ?? {};
        const status = readOptionalString(state.status);
        const rawToolName = readOptionalString(partData.tool) ?? 'Tool';
        const toolName = rawToolName.toLowerCase() === 'task' ? 'Task' : rawToolName;
        if (OPENCODE_EDIT_TOOL_NAMES.has(rawToolName.toLowerCase())) {
          // OpenCode mirrors this edit with a `patch` part in the same message;
          // mark the message so that echo does not render a second card.
          editedMessageIds.add(row.message_id);
        }
        const toolMessage = createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'tool_use',
          toolName,
          toolInput: state.input ?? partData.input ?? {},
          toolId: readOptionalString(partData.callID) ?? row.part_id,
        });

        if (status === 'completed' || status === 'error') {
          toolMessage.toolResult = {
            content: formatCliToolResult(state.output, state.error, state.metadata),
            isError: status === 'error',
          };
        }

        normalized.push(toolMessage);
        continue;
      }

      if (partType === 'compaction') {
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'status',
          text: compactionNoticeText(partData),
          notice: true,
        }));
        continue;
      }

      if (partType === 'subtask') {
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'tool_use',
          toolName: 'Agent',
          toolInput: subtaskToolInput(partData),
          toolId: row.part_id,
          toolResult: subtaskToolResult(partData),
        }));
        continue;
      }

      if (partType === 'step-finish') {
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'stream_end',
        }));
        continue;
      }

      if (partType === 'patch' || partType === 'agent') {
        // Skip the auto-generated `patch` echo of an edit/write tool in the
        // same message — the tool card already shows the same diff, and the
        // CLI renders one card. Standalone patch parts (e.g. VCS-level changes
        // with no edit tool) still render.
        if (partType === 'patch' && editedMessageIds.has(row.message_id)) {
          continue;
        }
        const toolInput = partData;
        const toolMessage = createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'tool_use',
          toolName: partType === 'patch' ? 'Patch' : 'Agent',
          toolInput,
          toolId: row.part_id,
        });

        // A `patch` part with files and a hash is a completed patch record;
        // without state, still surface the affected files so the UI does not
        // render an endlessly running tool row.
        const patchFiles = Array.isArray(toolInput.files) ? toolInput.files : [];
        const patchHash = readOptionalString(toolInput.hash);
        if (patchFiles.length > 0) {
          toolMessage.toolResult = {
            content: `Applied patch${patchHash ? ` (${patchHash.slice(0, 12)})` : ''} to:\n${patchFiles.map((f: unknown) => `- ${f}`).join('\n')}`,
            isError: false,
          };
        }

        normalized.push(toolMessage);
      }
    }

    return normalized;
  }
}

import fsSync from 'node:fs';

import Database from 'better-sqlite3';

import { parseFilesInputTag, parseImagesInputTag } from '@/shared/image-attachments.js';
import type { IProviderSessions } from '@/shared/interfaces.js';
import type { AnyRecord, FetchHistoryOptions, FetchHistoryResult, NormalizedMessage } from '@/shared/types.js';
import {
  createNormalizedMessage,
  generateMessageId,
  getOpenCodeDatabasePath,
  normalizeProviderTimestamp,
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

const formatToolContent = (value: unknown): string => {
  if (value === undefined || value === null) {
    return '';
  }

  if (typeof value === 'string') {
    return value;
  }

  try {
    return JSON.stringify(value, null, 2);
  } catch {
    return String(value);
  }
};

/**
 * Extracts a human-readable error message from an OpenCode error payload.
 *
 * OpenCode emits errors in several shapes:
 * - a plain string (`error: "text"`)
 * - an object with a `message` field (`error: { message: "text" }`)
 * - an object with `data.message` (`error: { name: "UnknownError", data: { message: "text" } }`)
 */
const extractOpenCodeErrorMessage = (value: unknown): string | undefined => {
  if (typeof value === 'string') {
    return value.trim() || undefined;
  }

  const record = readObjectRecord(value);
  if (!record) {
    return undefined;
  }

  return readOptionalString(record.message)
    ?? readOptionalString(readObjectRecord(record.data)?.message)
    ?? undefined;
};

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

/**
 * OpenCode stores per-message token counts on assistant `message.data` objects
 * (see MessageV2.Assistant). Older DBs also had session-level counters; this
 * matches current `opencode.db` layouts that only persist message JSON.
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
        const resultContent = formatToolContent(toolOutput ?? toolError);
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
      return { messages: [], total: 0, hasMore: false, offset: 0, limit: null };
    }

    try {
      const providerSessionIds = [...new Set([providerSessionId, sessionId].filter(Boolean))];
      const placeholders = providerSessionIds.map(() => '?').join(', ');
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
      `).all(...providerSessionIds) as OpenCodeHistoryRow[];

      const normalized = this.normalizeHistoryRows(rows, sessionId);
      const tokenUsage = aggregateOpenCodeSessionTokenUsage(db, providerSessionId);

      const normalizedOffset = Math.max(0, offset);
      const normalizedLimit = limit === null ? null : Math.max(0, limit);
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
      return { messages: [], total: 0, hasMore: false, offset: 0, limit: null };
    } finally {
      db.close();
    }
  }

  private normalizeHistoryRows(rows: OpenCodeHistoryRow[], sessionId: string): NormalizedMessage[] {
    const normalized: NormalizedMessage[] = [];
    const emittedMessageErrors = new Set<string>();
    const emittedUserTextByMessageId = new Map<string, NormalizedMessage>();
    const emittedUserRows: {
      messageId: string;
      message: NormalizedMessage;
      time: number;
      claimed: boolean;
    }[] = [];

    for (const row of rows) {
      const timestamp = normalizeProviderTimestamp(row.part_time_created ?? row.message_time_created);
      const baseId = `${row.message_id}_${row.part_id ?? normalized.length}`;
      const messageInfo = readJsonRecord(row.message_data);
      const messageRole = readOptionalString(messageInfo?.role);

      if (
        messageInfo
        && messageRole === 'assistant'
        && messageInfo.error != null
        && !emittedMessageErrors.has(row.message_id)
      ) {
        emittedMessageErrors.add(row.message_id);
        normalized.push(createNormalizedMessage({
          id: `${baseId}_error`,
          sessionId,
          timestamp,
          provider: PROVIDER,
          kind: 'error',
          content: formatToolContent(messageInfo.error),
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
            content: formatToolContent(state.output ?? state.error),
            isError: status === 'error',
          };
        }

        normalized.push(toolMessage);
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

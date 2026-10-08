import fsSync from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';

import { sessionsDb } from '@/modules/database/index.js';
import { parseFilesInputTag, parseImagesInputTag } from '@/shared/image-attachments.js';
import type { IProviderSessions } from '@/shared/interfaces.js';
import type { AnyRecord, FetchHistoryOptions, FetchHistoryResult, NormalizedMessage } from '@/shared/types.js';
import {
  AppError,
  antigravityTranscriptDir,
  createNormalizedMessage,
  generateMessageId,
  readObjectRecord,
  readOptionalString,
  sliceTailPage,
} from '@/shared/utils.js';

const PROVIDER = 'antigravity' as const;

/**
 * Antigravity persists conversation steps as protobuf blobs inside
 * per-conversation SQLite stores (`~/.gemini/antigravity-cli/conversations`),
 * which DDAgent cannot decode directly. The antigravity runtime therefore
 * mirrors every streamed turn into `<workspace>/.ddagent/antigravity/
 * <conversation-id>.jsonl` in Command Code's v3 transcript shape — a
 * `type:"session"` header plus `type:"message"` entries whose `content`
 * blocks hold `text`/`thinking`/`tool_use`/`tool_result` — and this provider
 * reads that mirror. Sessions created natively in `agy` show their title and
 * workspace through the synchronizer but expose an empty history until they
 * are resumed through DDAgent (which starts mirroring from that turn on).
 */

/** Resolves the on-disk mirror transcript for one provider-native session id. */
export async function findAntigravityTranscriptPath(
  sessionId: string,
  providerSessionId?: string,
): Promise<string | null> {
  const indexed = sessionsDb.getSessionById(sessionId)?.jsonl_path;
  if (indexed && fsSync.existsSync(indexed)) {
    return indexed;
  }

  const projectPath = sessionsDb.getSessionById(sessionId)?.project_path;
  if (!projectPath) {
    return null;
  }

  const candidate = path.join(
    antigravityTranscriptDir(projectPath),
    `${providerSessionId ?? sessionId}.jsonl`,
  );
  return fsSync.existsSync(candidate) ? candidate : null;
}

function extractTextContent(content: unknown): string {
  if (typeof content === 'string') {
    return content;
  }
  if (!Array.isArray(content)) {
    return '';
  }
  return content
    .map((block) => {
      const record = readObjectRecord(block);
      if (!record) {
        return '';
      }
      if (record.type === 'text' || record.type === 'input_text' || record.type === 'output_text') {
        return typeof record.text === 'string' ? record.text : '';
      }
      return '';
    })
    .filter(Boolean)
    .join('\n');
}

function extractToolResultContent(content: unknown): string {
  if (typeof content === 'string') {
    return content;
  }
  if (!Array.isArray(content)) {
    return content == null ? '' : JSON.stringify(content);
  }
  return content
    .map((block) => {
      const record = readObjectRecord(block);
      if (!record) {
        return '';
      }
      if (record.type === 'text' || typeof record.text === 'string') {
        return typeof record.text === 'string' ? record.text : '';
      }
      const nested = readObjectRecord(record.content);
      return nested && typeof nested.text === 'string' ? nested.text : '';
    })
    .filter(Boolean)
    .join('\n');
}

/**
 * Normalizes one mirror-transcript `message` entry into DDAgent messages. A
 * single entry can expand into several normalized rows (text + thinking +
 * tool_use + tool_result all live in the same `content` array).
 */
function normalizeMessageEntry(
  entry: AnyRecord,
  sessionId: string | null,
  normalized: NormalizedMessage[],
  toolResultIds: Set<string>,
): void {
  const message = readObjectRecord(entry.message);
  if (!message) {
    return;
  }
  const role = readOptionalString(message.role);
  const content = message.content;
  const ts = readOptionalString(entry.timestamp) ?? new Date().toISOString();
  const baseId = readOptionalString(entry.id) ?? generateMessageId('antigravity');

  if (role === 'user') {
    const contentArray = Array.isArray(content) ? content : null;
    let partIndex = 0;
    for (const block of contentArray ?? [content]) {
      const record = readObjectRecord(block);
      if (record?.type === 'tool_result') {
        const toolId = readOptionalString(record.tool_use_id) ?? '';
        if (toolId) {
          toolResultIds.add(toolId);
        }
        normalized.push(createNormalizedMessage({
          id: `${baseId}-result-${partIndex++}`,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'tool_result',
          toolId,
          content: extractToolResultContent(record.content),
          isError: record.is_error === true || record.isError === true,
        }));
        continue;
      }
    }

    const text = extractTextContent(content);
    const parsedImages = parseImagesInputTag(text);
    const parsedFiles = parseFilesInputTag(parsedImages.text);
    if (!parsedFiles.text.trim() && !parsedImages.attachments.length && !parsedFiles.attachments.length) {
      return;
    }
    normalized.push(createNormalizedMessage({
      id: baseId,
      sessionId,
      timestamp: ts,
      provider: PROVIDER,
      kind: 'text',
      role: 'user',
      content: parsedFiles.text,
      images: parsedImages.attachments.length > 0 ? parsedImages.attachments : undefined,
      files: parsedFiles.attachments.length > 0 ? parsedFiles.attachments : undefined,
    }));
    return;
  }

  if (role === 'assistant') {
    const contentArray = Array.isArray(content) ? content : [];
    let partIndex = 0;
    for (const block of contentArray) {
      const record = readObjectRecord(block);
      if (!record) {
        continue;
      }
      if (record.type === 'text' && typeof record.text === 'string' && record.text.trim()) {
        normalized.push(createNormalizedMessage({
          id: `${baseId}-${partIndex++}`,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'text',
          role: 'assistant',
          content: record.text,
        }));
      } else if (record.type === 'thinking' && typeof record.thinking === 'string' && record.thinking.trim()) {
        normalized.push(createNormalizedMessage({
          id: `${baseId}-think-${partIndex++}`,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'thinking',
          content: record.thinking,
        }));
      } else if (record.type === 'tool_use') {
        const toolId = readOptionalString(record.id) ?? `${baseId}-tool-${partIndex}`;
        normalized.push(createNormalizedMessage({
          id: `${baseId}-tool-${partIndex++}`,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'tool_use',
          toolName: readOptionalString(record.name) ?? 'Tool',
          toolInput: record.input ?? {},
          toolId,
        }));
      }
    }
    if (typeof content === 'string' && content.trim()) {
      normalized.push(createNormalizedMessage({
        id: baseId,
        sessionId,
        timestamp: ts,
        provider: PROVIDER,
        kind: 'text',
        role: 'assistant',
        content,
      }));
    }
  }
}

/**
 * Session reader/normalizer for Antigravity mirror transcripts.
 */
export class AntigravitySessionsProvider implements IProviderSessions {
  /**
   * Normalizes one raw transcript line. Live runtime events are already emitted
   * normalized, so this only sees persisted mirror entries.
   */
  normalizeMessage(raw: unknown, sessionId: string | null): NormalizedMessage[] {
    const entry = readObjectRecord(raw);
    if (!entry) {
      return [];
    }

    const normalized: NormalizedMessage[] = [];
    const toolResultIds = new Set<string>();
    this.normalizeEntry(entry, sessionId, normalized, toolResultIds);
    return normalized;
  }

  private normalizeEntry(
    entry: AnyRecord,
    sessionId: string | null,
    normalized: NormalizedMessage[],
    toolResultIds: Set<string>,
  ): void {
    const ts = readOptionalString(entry.timestamp) ?? new Date().toISOString();
    const baseId = readOptionalString(entry.id) ?? generateMessageId('antigravity');

    switch (entry.type) {
      case 'message':
        normalizeMessageEntry(entry, sessionId, normalized, toolResultIds);
        return;
      case 'compaction': {
        const summary = readOptionalString(entry.summary);
        if (!summary?.trim()) {
          return;
        }
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'text',
          role: 'assistant',
          content: summary,
          isCompactSummary: true,
        }));
        return;
      }
      // 'session' headers and metadata rows carry metadata only —
      // token usage reads them directly, no chat row.
      default:
        return;
    }
  }

  /**
   * Loads the mirror JSONL transcript for one app session and paginates the
   * normalized message list with the shared tail-page contract.
   */
  async fetchHistory(
    sessionId: string,
    options: FetchHistoryOptions = {},
  ): Promise<FetchHistoryResult> {
    const { limit = null, offset = 0 } = options;
    const providerSessionId = options.providerSessionId ?? sessionId;

    const transcriptPath = await findAntigravityTranscriptPath(sessionId, providerSessionId);
    if (!transcriptPath) {
      return { messages: [], total: 0, hasMore: false, offset, limit };
    }

    let rawEntries: AnyRecord[];
    try {
      rawEntries = await readAntigravityTranscript(transcriptPath);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn(`[AntigravityProvider] Failed to load session ${sessionId}:`, message);
      throw new AppError(`Failed to load Antigravity session history: ${message}`, {
        code: 'PROVIDER_HISTORY_UNAVAILABLE',
        statusCode: 503,
      });
    }

    const normalized: NormalizedMessage[] = [];
    const toolResultIds = new Set<string>();
    let tokenUsage: AnyRecord | undefined;
    for (const entry of rawEntries) {
      this.normalizeEntry(entry, sessionId, normalized, toolResultIds);
      const usage = readObjectRecord(entry.usage);
      if (usage && entry.type === 'message') {
        tokenUsage = usage;
      }
    }

    // Fold tool results into their tool_use row so the client renders one
    // expandable row per call, the same merge the other providers apply.
    const toolResultMap = new Map<string, NormalizedMessage>();
    for (const msg of normalized) {
      if (msg.kind === 'tool_result' && msg.toolId) {
        toolResultMap.set(msg.toolId, msg);
      }
    }
    for (const msg of normalized) {
      if (msg.kind === 'tool_use' && msg.toolId && toolResultMap.has(msg.toolId)) {
        const toolResult = toolResultMap.get(msg.toolId);
        if (toolResult) {
          msg.toolResult = { content: toolResult.content, isError: toolResult.isError };
        }
      }
    }

    let total = 0;
    for (const msg of normalized) {
      if (msg.kind !== 'tool_result') {
        total += 1;
      }
    }
    const normalizedOffset = Math.max(0, offset);
    const normalizedLimit = limit === null ? null : Math.max(0, limit);
    const { page, hasMore } = sliceTailPage(normalized, normalizedLimit, normalizedOffset);

    return {
      messages: page,
      total,
      hasMore,
      offset: normalizedOffset,
      limit: normalizedLimit,
      ...(tokenUsage ? { tokenUsage } : {}),
    };
  }
}

/**
 * Parses a whole mirror transcript, skipping malformed lines. Exported for the
 * synchronizer and the token-usage reader.
 */
export async function readAntigravityTranscript(filePath: string): Promise<AnyRecord[]> {
  const entries: AnyRecord[] = [];
  const fileStream = fsSync.createReadStream(filePath);
  const rl = readline.createInterface({ input: fileStream, crlfDelay: Infinity });

  for await (const line of rl) {
    const trimmed = line.trim();
    if (!trimmed) {
      continue;
    }
    try {
      const entry = JSON.parse(trimmed) as AnyRecord;
      if (entry && typeof entry === 'object') {
        entries.push(entry);
      }
    } catch {
      // Torn writes while the runtime appends a line must not fail the read.
    }
  }

  return entries;
}

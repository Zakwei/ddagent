import fsSync, { promises as fsAsync } from 'node:fs';
import path from 'node:path';
import readline from 'node:readline';

import { sessionsDb } from '@/modules/database/index.js';
import { toImageAttachments } from '@/shared/image-attachments.js';
import type { IProviderSessions } from '@/shared/interfaces.js';
import type { AnyRecord, FetchHistoryOptions, FetchHistoryResult, NormalizedMessage } from '@/shared/types.js';
import {
  AppError,
  commandCodeProjectsDir,
  commandCodeProjectSlug,
  createNormalizedMessage,
  generateMessageId,
  isCommandCodeTranscriptFileName,
  readObjectRecord,
  readOptionalString,
  sliceTailPage,
} from '@/shared/utils.js';

const PROVIDER = 'commandcode' as const;

/**
 * Command Code persists one v3 JSONL transcript per session under
 * `~/.commandcode/projects/<slug>/<session-id>.jsonl`. The first line is a
 * `type: "session"` header carrying the id and the session's cwd; every later
 * line is an entry (`message`, `model_change`, `effort_change`, `compaction`,
 * `branch_summary`, `custom`, `custom_message`, `label`, `session_info`)
 * chained by `id`/`parentId`. Assistant `message` entries can carry `usage`,
 * `model` and `effort`.
 */

/** Resolves the on-disk transcript for one provider-native session id. */
export async function findCommandCodeTranscriptPath(
  sessionId: string,
  providerSessionId?: string,
): Promise<string | null> {
  const indexed = sessionsDb.getSessionById(sessionId)?.jsonl_path;
  if (indexed && fsSync.existsSync(indexed) && isCommandCodeTranscriptFileName(path.basename(indexed))) {
    return indexed;
  }

  const targetName = `${providerSessionId ?? sessionId}.jsonl`;
  const projectsRoot = commandCodeProjectsDir();

  // The session's indexed cwd usually maps straight onto its project slug —
  // take that direct hit before paying for a directory scan.
  const projectPath = sessionsDb.getSessionById(sessionId)?.project_path;
  if (projectPath) {
    const candidate = path.join(projectsRoot, commandCodeProjectSlug(projectPath), targetName);
    if (fsSync.existsSync(candidate)) {
      return candidate;
    }
  }

  // Fallback: one level of project-slug directories, filename = session id.
  try {
    const entries = await fsAsync.readdir(projectsRoot, { withFileTypes: true });
    for (const entry of entries) {
      if (!entry.isDirectory()) {
        continue;
      }
      const candidate = path.join(projectsRoot, entry.name, targetName);
      if (fsSync.existsSync(candidate)) {
        return candidate;
      }
    }
  } catch {
    // Missing ~/.commandcode/projects is the normal not-installed state.
  }

  return null;
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

function extractUserImages(content: unknown): Array<{ path?: string; data?: string }> | undefined {
  if (!Array.isArray(content)) {
    return undefined;
  }
  const images: Array<{ path?: string; data?: string }> = [];
  for (const block of content) {
    const record = readObjectRecord(block);
    if (record?.type !== 'image') {
      continue;
    }
    const source = readObjectRecord(record.source);
    const mediaType = readOptionalString(source?.media_type) ?? readOptionalString(record.mimeType) ?? 'image/png';
    const data = readOptionalString(source?.data) ?? readOptionalString(record.data);
    if (data) {
      images.push({ data: `data:${mediaType};base64,${data}` });
      continue;
    }
    const filePath = readOptionalString(source?.path) ?? readOptionalString(record.path);
    if (filePath) {
      images.push(...toImageAttachments([filePath]));
    }
  }
  return images.length > 0 ? images : undefined;
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
 * Normalizes one v3 transcript `message` entry into ddagent messages. A single
 * entry can expand into several normalized rows (text + thinking + tool_use +
 * tool_result all live in the same `content` array).
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
  const baseId = readOptionalString(entry.id) ?? generateMessageId('commandcode');

  if (role === 'user') {
    // `meta.isMeta` rows carry tool plumbing (the CLI replays them as nothing).
    const meta = readObjectRecord(message.meta) ?? readObjectRecord(entry.meta);
    if (meta?.isMeta === true) {
      return;
    }
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
    const images = extractUserImages(content);
    if (!text.trim() && !images) {
      return;
    }
    normalized.push(createNormalizedMessage({
      id: baseId,
      sessionId,
      timestamp: ts,
      provider: PROVIDER,
      kind: 'text',
      role: 'user',
      content: text,
      images,
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
    // A plain-string assistant content (older migrated rows) still renders.
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
 * Session reader/normalizer for Command Code transcripts.
 */
export class CommandCodeSessionsProvider implements IProviderSessions {
  /**
   * Normalizes one raw transcript line. Live runtime events are already emitted
   * normalized, so this only sees persisted v3 entries.
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
    const baseId = readOptionalString(entry.id) ?? generateMessageId('commandcode');

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
      case 'custom_message': {
        // Hook/mod-produced rows are informational only — never a user echo.
        const content = readOptionalString(entry.content) ?? readOptionalString(entry.display);
        if (!content?.trim()) {
          return;
        }
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'status',
          text: content,
        }));
        return;
      }
      case 'branch_summary': {
        const summary = readOptionalString(entry.summary);
        if (!summary?.trim()) {
          return;
        }
        normalized.push(createNormalizedMessage({
          id: baseId,
          sessionId,
          timestamp: ts,
          provider: PROVIDER,
          kind: 'status',
          text: summary,
        }));
        return;
      }
      // 'session' headers, 'session_info' titles, 'model_change',
      // 'effort_change', 'label' and 'custom' rows carry metadata only —
      // sessions.service/token usage read them directly, no chat row.
      default:
        return;
    }
  }

  /**
   * Loads the v3 JSONL transcript for one app session and paginates the
   * normalized message list with the shared tail-page contract.
   */
  async fetchHistory(
    sessionId: string,
    options: FetchHistoryOptions = {},
  ): Promise<FetchHistoryResult> {
    const { limit = null, offset = 0 } = options;
    const providerSessionId = options.providerSessionId ?? sessionId;

    const transcriptPath = await findCommandCodeTranscriptPath(sessionId, providerSessionId);
    if (!transcriptPath) {
      return { messages: [], total: 0, hasMore: false, offset, limit };
    }

    let rawEntries: AnyRecord[];
    try {
      rawEntries = await readCommandCodeTranscript(transcriptPath);
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.warn(`[CommandCodeProvider] Failed to load session ${sessionId}:`, message);
      throw new AppError(`Failed to load Command Code session history: ${message}`, {
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
    // expandable row per call, the same merge Claude/Codex apply.
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
 * Parses a whole v3 transcript, skipping malformed lines and the `session`
 * header. Exported for the synchronizer (header/metadata reads) and the
 * runtime's end-of-turn reconciliation.
 */
export async function readCommandCodeTranscript(filePath: string): Promise<AnyRecord[]> {
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
      // Torn writes while the CLI appends a line must not fail the read.
    }
  }

  return entries;
}

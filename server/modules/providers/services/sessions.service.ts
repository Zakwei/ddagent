import { randomUUID } from 'node:crypto';
import { readdirSync, readFileSync } from 'node:fs';
import fsp from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import { orchestratorMessagesDb, projectsDb, providerAccountsDb, queuedMessagesDb, sessionEventsDb, sessionsDb } from '@/modules/database/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import { providerRegistry } from '@/modules/providers/provider.registry.js';
import type {
  FetchHistoryOptions,
  FetchHistoryResult,
  LLMProvider,
  NormalizedMessage,
  OrchestratorMessage,
} from '@/shared/types.js';
import { AppError, countJsonlLines, readNormalizedMessageText, isOrchestratorProvider, normalizeProjectPath, ORCHESTRATOR_PROVIDER, validateWorkspacePath } from '@/shared/utils.js';

/**
 * Maps one orchestrator transcript row to the NormalizedMessage envelope the
 * chat history endpoint returns.
 *
 * Orchestrator payloads ride in `context.orchestratorKind` + the rest of the
 * payload spread into `context`, on `kind: 'status'` frames: the MessageKind
 * union stays untouched and the client switches on `context.orchestratorKind`
 * to render routing/plan/delegation cards. Plain user rows surface as regular
 * user text messages.
 */
function orchestratorMessageToNormalized(
  message: OrchestratorMessage,
  provider: string = ORCHESTRATOR_PROVIDER,
): NormalizedMessage {
  if (message.kind === 'user') {
    return {
      id: `orch-${message.id}`,
      sessionId: message.sessionId,
      timestamp: message.createdAt,
      provider: provider as LLMProvider,
      kind: 'text',
      role: 'user',
      content: typeof message.payload.content === 'string' ? message.payload.content : '',
    };
  }
  return {
    id: `orch-${message.id}`,
    sessionId: message.sessionId,
    timestamp: message.createdAt,
    provider: provider as LLMProvider,
    kind: 'status',
    role: 'assistant',
    // `orchestratorRowId` mirrors the live frame (`createOrchestratorStatusFrame`)
    // so the client can fold a live re-publication into this persisted row.
    context: { orchestratorKind: message.kind, ...message.payload, orchestratorRowId: message.id },
    summary:
      typeof message.payload.text === 'string'
        ? message.payload.text
        : `orchestrator:${message.kind}`,
  };
}

/** One processing session as `/sessions/running` reports it. */
type RunningSessionSummary = {
  sessionId: string;
  provider: LLMProvider;
  startedAt: number;
  lastSeq: number;
  /** Run owned by a process outside the app (tmux CLI) — not interruptible here. */
  external?: boolean;
};

/**
 * Claude CLIs started outside the app (tmux, a terminal) publish their state in
 * `~/.claude/sessions/<pid>.json`. Busy/waiting ones count as running so the
 * pane shows activity for them; the app's own SDK runs live in the registry.
 * Exported for `listRunningSessions` below and its module test.
 */
export function listExternalClaudeRuns(
  dir = path.join(os.homedir(), '.claude', 'sessions'),
): RunningSessionSummary[] {
  let names: string[];
  try {
    names = readdirSync(dir);
  } catch {
    return [];
  }
  const runs: RunningSessionSummary[] = [];
  for (const name of names) {
    if (!name.endsWith('.json')) continue;
    try {
      const entry = JSON.parse(readFileSync(path.join(dir, name), 'utf8'));
      if (entry.entrypoint !== 'cli' || (entry.status !== 'busy' && entry.status !== 'waiting')) continue;
      // Throws for a CLI that died and left its state file behind.
      process.kill(entry.pid, 0);
      const row = sessionsDb.getSessionByProviderSessionId(entry.sessionId);
      if (!row || row.isArchived) continue;
      runs.push({
        sessionId: row.session_id,
        provider: 'claude',
        startedAt: entry.statusUpdatedAt ?? entry.startedAt ?? Date.now(),
        lastSeq: 0,
        external: true,
      });
    } catch {
      // Unreadable, mid-write or stale state file.
    }
  }
  return runs;
}

/** Max timestamp distance for a stored row to count as the provider's own copy. */
const SESSION_EVENT_DEDUPE_WINDOW_MS = 60_000;

/**
 * Merges stored live `error` / notice `status` rows (session_events) into one
 * page of provider history, in timestamp order.
 *
 * - Only rows inside the page's time range are merged, so each row lands on
 *   exactly one page: the newest page also takes rows after its last message,
 *   the oldest page rows before its first. Pages are offset-paged in provider
 *   message units, so merged rows carry `sessionEvent: true` and must not
 *   count toward the next page's offset.
 * - A row is skipped when the provider history already holds the same kind
 *   with the same text within SESSION_EVENT_DEDUPE_WINDOW_MS, or the same id.
 *
 * shortcut: a row whose timestamp falls between two pages' messages is not
 * shown while paging; it appears once the neighboring page holds the newest
 * messages (offset 0) — fine for the bounded, latest-turn-heavy event table.
 *
 * Exported for the sessions service tests.
 */
export function mergeSessionEvents(
  messages: NormalizedMessage[],
  events: NormalizedMessage[],
  page: { isNewestPage: boolean; isOldestPage: boolean },
): NormalizedMessage[] {
  if (events.length === 0) return messages;
  const times = messages.map((message) => Date.parse(message.timestamp)).filter(Number.isFinite);
  if (times.length === 0 && !(page.isNewestPage && page.isOldestPage)) return messages;
  const from = page.isOldestPage ? -Infinity : Math.min(...times);
  const to = page.isNewestPage ? Infinity : Math.max(...times);
  const ids = new Set(messages.map((message) => message.id));

  const extra = events.filter((event) => {
    const time = Date.parse(event.timestamp);
    if (!(time >= from && time <= to) || ids.has(event.id)) return false;
    const text = readNormalizedMessageText(event);
    return !messages.some((message) => message.kind === event.kind
      && readNormalizedMessageText(message) === text
      && Math.abs(Date.parse(message.timestamp) - time) <= SESSION_EVENT_DEDUPE_WINDOW_MS);
  });
  if (extra.length === 0) return messages;

  // Stable insert: a stored row goes after every message not newer than it.
  const merged = [...messages];
  for (const event of extra) {
    const time = Date.parse(event.timestamp);
    let index = merged.length;
    while (index > 0 && Date.parse(merged[index - 1].timestamp) > time) index -= 1;
    merged.splice(index, 0, { ...event, sessionEvent: true });
  }
  return merged;
}

type CreateAppSessionResult = {
  sessionId: string;
  provider: LLMProvider;
  projectPath: string;
  sessionName: string;
};

type ArchivedSessionListItem = {
  sessionId: string;
  provider: LLMProvider;
  projectId: string | null;
  projectPath: string | null;
  projectDisplayName: string;
  sessionTitle: string;
  createdAt: string | null;
  updatedAt: string | null;
  lastActivity: string | null;
  isProjectArchived: boolean;
  messageCount: number;
};

type RecentSessionListItem = Pick<
  ArchivedSessionListItem,
  'sessionId' | 'provider' | 'projectId' | 'projectDisplayName' | 'sessionTitle' | 'lastActivity' | 'messageCount'
> & {
  /** Last time the user opened the session's output; `null` = never viewed — drives the unread dot. */
  lastViewedAt: string | null;
  /** When the latest turn finished; `null` while a turn runs or none finished — drives the green pane tab. */
  turnFinishedAt: string | null;
};

type RecentSessionsPage = {
  conversations: RecentSessionListItem[];
  total: number;
  hasMore: boolean;
};

type SessionDetails = {
  /** Canonical app-facing session id (may differ from the looked-up id when a provider-native id was given). */
  sessionId: string;
  provider: LLMProvider;
  summary: string;
  createdAt: string | null;
  updatedAt: string | null;
  lastActivity: string | null;
  /** Last time the user opened the session's output; `null` = never viewed. */
  lastViewedAt: string | null;
  /** When the latest turn finished; `null` while a turn runs or none finished. */
  turnFinishedAt: string | null;
  isArchived: boolean;
  /** Model recorded for the session; `null` until its first turn runs. */
  model: string | null;
  /** Approval mode pinned to the session; `null` until the app records one. */
  permissionMode: string | null;
  /** Provider account (multi-account login) the session runs under; `null` = default login. */
  accountId: string | null;
  project: {
    projectId: string;
    path: string;
    fullPath: string;
    displayName: string;
    isStarred: boolean;
    isArchived: boolean;
  } | null;
};

const MAX_DDAGENT_SESSION_NAME_WORDS = 4;
const MAX_DDAGENT_SESSION_NAME_LENGTH = 40;
const DDAGENT_SESSION_NAME_FALLBACK = 'Untitled session';

/**
 * Leading pleasantries/politeness that carry no task meaning. Stripped from the
 * front of a raw message before the first meaningful words become a title, so
 * "Can you please fix the login redirect" reads as "Fix the login redirect"
 * instead of "Can you please fix". Only leading tokens are removed, so a "the"
 * inside the phrase is preserved.
 */
const DDAGENT_SESSION_NAME_FILLER_PREFIX = new Set([
  'can', 'could', 'would', 'will', 'you', 'please', 'pls', 'kindly',
  'i', 'we', 'want', 'need', 'help', 'me', 'to',
  'prosze', 'proszę', 'czy', 'mozesz', 'możesz', 'chce', 'chcę',
  'chcialbym', 'chciałbym', 'pomoz', 'pomóż', 'mi',
]);

/**
 * Applies sentence case to a derived title: the first character is upper-cased
 * and the rest is left exactly as written, so proper nouns and acronyms
 * ("OAuth", "GitHub") survive while the shouting-uppercase look is gone.
 */
function toSentenceCase(value: string): string {
  return value.charAt(0).toUpperCase() + value.slice(1);
}

function countJsonlMessages(jsonlPath?: string | null): number {
  if (!jsonlPath) {
    return 0;
  }

  try {
    return countJsonlLines(jsonlPath);
  } catch {
    return 0;
  }
}

/**
 * Caps a title at `MAX_DDAGENT_SESSION_NAME_LENGTH` characters, preferring to
 * cut at the last whole word so titles never end mid-word when avoidable.
 */
function capDdagentSessionNameLength(value: string): string {
  if (value.length <= MAX_DDAGENT_SESSION_NAME_LENGTH) {
    return value;
  }

  const truncated = value.slice(0, MAX_DDAGENT_SESSION_NAME_LENGTH);
  const lastSpace = truncated.lastIndexOf(' ');
  return (lastSpace > 0 ? truncated.slice(0, lastSpace) : truncated).trim();
}

/**
 * Turns an initial user message into a short, sentence-case session title.
 *
 * Used by `sessionsService.createAppSession` (and `nameUntitledSession`) to give
 * every new app session an immediate title before any provider-owned storage
 * exists, and by the provider session tests to assert the normalization rules
 * directly. It is pure and dependency-free: markdown/code noise is stripped,
 * only letters (any Unicode script), digits, spaces, and `-`/`/`/`&` are kept,
 * leading pleasantries are dropped, the first `MAX_DDAGENT_SESSION_NAME_WORDS`
 * meaningful words are joined, length capped, and the result sentence-cased.
 * This title is the instant fallback the background LLM titler later replaces.
 * Returns `Untitled session` when nothing usable remains.
 */
export function buildDdagentSessionName(initialMessage: string): string {
  const withoutMarkdown = initialMessage
    // Fenced code blocks rarely describe the task; drop them wholesale.
    .replace(/```[\s\S]*?```/g, ' ')
    // Keep the visible label of markdown links/images, discard the target.
    .replace(/!?\[([^\]]*)\]\([^)]*\)/g, '$1')
    // Drop every character that does not belong in a title.
    .replace(/[^\p{L}\p{N}\s\-/&]+/gu, ' ');

  const words = withoutMarkdown
    .replace(/\s+/g, ' ')
    .trim()
    .split(' ')
    .map((word) => word.replace(/^[-/&]+|[-/&]+$/g, ''))
    .filter((word) => /[\p{L}\p{N}]/u.test(word));

  // Skip leading pleasantries; if that consumes everything, keep the raw words
  // so a message made only of filler ("please help") still yields a title.
  let start = 0;
  while (
    start < words.length - 1 &&
    DDAGENT_SESSION_NAME_FILLER_PREFIX.has(words[start].toLowerCase())
  ) {
    start += 1;
  }
  const meaningful = words.slice(start, start + MAX_DDAGENT_SESSION_NAME_WORDS);

  const title = capDdagentSessionNameLength(meaningful.join(' '));
  return title ? toSentenceCase(title) : DDAGENT_SESSION_NAME_FALLBACK;
}

/**
 * True when a session's current name is still the auto-derived one, i.e. the
 * background LLM titler may upgrade it. False once a user rename or a recovered
 * provider title is in place. Used by the WebSocket dispatch to decide whether
 * to fire a title-generation pass for a session's first message.
 */
export function isAutoDerivedSessionName(
  customName: string | null | undefined,
  content: string,
): boolean {
  const derived = buildDdagentSessionName(content);
  // Nothing usable to title (message was punctuation/code only).
  if (derived === DDAGENT_SESSION_NAME_FALLBACK) {
    return false;
  }
  const current = (customName ?? '').trim();
  if (!current) {
    return true;
  }
  return current === DDAGENT_SESSION_NAME_FALLBACK || current === derived;
}

/**
 * Removes one file if it exists.
 */
async function removeFileIfExists(filePath: string): Promise<boolean> {
  try {
    await fsp.unlink(filePath);
    return true;
  } catch (error) {
    const code = (error as NodeJS.ErrnoException).code;
    if (code === 'ENOENT') {
      return false;
    }
    throw error;
  }
}

/**
 * Archive rows need a stable project label even when the owning project is not
 * part of the active sidebar payload. This lightweight resolver keeps the
 * archive API self-contained while still matching the project's stored display
 * name when one exists.
 */
function resolveProjectDisplayName(
  projectPath: string | null,
  customProjectName: string | null | undefined,
): string {
  const trimmedCustomName = typeof customProjectName === 'string' ? customProjectName.trim() : '';
  if (trimmedCustomName.length > 0) {
    return trimmedCustomName;
  }

  if (!projectPath) {
    return 'Unknown Project';
  }

  return path.basename(projectPath) || projectPath;
}

/**
 * Application service for provider-backed session message operations.
 *
 * Callers pass a provider id and this service resolves the concrete provider
 * class, keeping normalization/history call sites decoupled from implementation
 * file layout.
 */
export const sessionsService = {
  /** Used by WebSocket dispatch to name empty app sessions from visible user text. */
  nameUntitledSession(sessionId: string, content: string): string | null {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session || session.isArchived || (session.custom_name?.trim()
      && session.custom_name !== DDAGENT_SESSION_NAME_FALLBACK)) {
      return null;
    }

    const sessionName = buildDdagentSessionName(content);
    // Attachment-only turns leave the placeholder available for later text.
    if (sessionName === DDAGENT_SESSION_NAME_FALLBACK) {
      return null;
    }
    sessionsDb.updateSessionCustomName(sessionId, sessionName);
    return sessionName;
  },

  /**
   * Applies a background LLM-generated title to a session, but only when the
   * row still carries the expected auto-derived name. Used by the WebSocket
   * dispatch's async titler: by re-reading the row it refuses to overwrite a
   * name the user (or a provider synchronizer) set in the meantime, and skips
   * archived sessions. Returns the stored title, or null when nothing changed.
   */
  applyGeneratedSessionTitle(
    sessionId: string,
    expectedCurrentName: string,
    title: string,
  ): string | null {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session || session.isArchived) {
      return null;
    }
    if ((session.custom_name?.trim() ?? '') !== expectedCurrentName.trim()) {
      return null;
    }
    const normalized = title.trim();
    if (!normalized || normalized === expectedCurrentName.trim()) {
      return null;
    }
    sessionsDb.updateSessionCustomName(sessionId, normalized);
    return normalized;
  },

  /**
   * Lists provider ids that can load session history and normalize live messages.
   */
  listProviderIds(): LLMProvider[] {
    return providerRegistry.listProviders().map((provider) => provider.id);
  },

  /**
   * Returns app-facing ids for provider runs that are currently processing.
   *
   * This is intentionally status-only: callers that only need sidebar activity
   * indicators should not attach to chat streams or request replayed messages.
   */
  listRunningSessions(): RunningSessionSummary[] {
    const runs: RunningSessionSummary[] = chatRunRegistry.listRunningRuns();
    const known = new Set(runs.map((run) => run.sessionId));
    for (const run of listExternalClaudeRuns()) {
      if (!known.has(run.sessionId)) runs.push(run);
    }
    return runs;
  },

  /**
   * Returns the active conversation feed in true global activity order.
   */
  listRecentSessions(limit: number, offset: number): RecentSessionsPage {
    const page = sessionsDb.getRecentSessionsPage(limit, offset);
    const projectCache = new Map<string, ReturnType<typeof projectsDb.getProjectPath>>();
    const conversations = page.sessions.map((session) => {
      const projectPath = session.project_path?.trim() ? session.project_path : null;
      let project = null;

      if (projectPath) {
        if (!projectCache.has(projectPath)) {
          projectCache.set(projectPath, projectsDb.getProjectPath(projectPath));
        }
        project = projectCache.get(projectPath) ?? null;
      }

      return {
        sessionId: session.session_id,
        provider: session.provider as LLMProvider,
        projectId: project?.project_id ?? null,
        projectDisplayName: resolveProjectDisplayName(projectPath, project?.custom_project_name),
        sessionTitle: session.custom_name?.trim() || session.session_id,
        lastActivity: session.updated_at ?? session.created_at ?? null,
        lastViewedAt: session.last_viewed_at ?? null,
        turnFinishedAt: session.turn_finished_at ?? null,
        messageCount: countJsonlMessages(session.jsonl_path),
        accountId: session.account_id ?? null,
      };
    });

    return {
      conversations,
      total: page.total,
      hasMore: offset + conversations.length < page.total,
    };
  },

  /**
   * Resolves the provider-native session id a runtime needs for resume.
   *
   * Callers hand provider runtimes the stable app session id; the provider
   * CLIs/SDKs only understand their own native id, which lives on the session
   * row. Sessions discovered on disk store the native id in both columns, so
   * `provider_session_id` may legitimately equal `session_id` and is still the
   * value to resume with. Only a missing column value means the session has no
   * provider id yet (a brand-new app session), in which case resume is skipped
   * and the runtime starts fresh and announces its own id.
   */
  resolveProviderSessionId(sessionId: string | null | undefined): string | null {
    if (!sessionId) {
      return null;
    }

    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      return null;
    }

    return session.provider_session_id ?? null;
  },

  /**
   * Normalizes one provider-native event into frontend session message events.
   */
  normalizeMessage(
    providerName: string,
    raw: unknown,
    sessionId: string | null,
  ): NormalizedMessage[] {
    return providerRegistry.resolveProvider(providerName).sessions.normalizeMessage(raw, sessionId);
  },

  /**
   * Allocates a stable app-facing session id before any provider run happens.
   *
   * This is the entry point of the session gateway: the frontend calls this
   * (via `POST /api/providers/sessions`) when the user starts a brand-new
   * chat, navigates to the returned id immediately, and the id never changes
   * for the lifetime of the conversation. The provider-native id is mapped to
   * this row later, when the provider runtime announces it mid-run. Its title
   * comes directly from the first visible DDAgent message, normalized by
   * `buildDdagentSessionName` into a short uppercase title before any
   * provider-owned storage exists.
   */
  createAppSession(
    provider: LLMProvider,
    projectPath: string,
    initialMessage: string,
    accountId?: string | null,
  ): CreateAppSessionResult {
    const normalizedProjectPath = projectPath.trim();
    if (!normalizedProjectPath) {
      throw new AppError('projectPath is required.', {
        code: 'PROJECT_PATH_REQUIRED',
        statusCode: 400,
      });
    }

    let resolvedAccountId: string | null = null;
    if (accountId) {
      const account = providerAccountsDb.get(accountId);
      if (!account || account.provider !== provider) {
        throw new AppError('accountId does not belong to this provider.', {
          code: 'ACCOUNT_NOT_FOUND',
          statusCode: 400,
        });
      }
      resolvedAccountId = account.id;
    } else {
      // No explicit pick → the provider's default account row, when one exists;
      // otherwise NULL keeps the provider's ambient login environment.
      resolvedAccountId = providerAccountsDb.getDefault(provider)?.id ?? null;
    }

    const sessionId = randomUUID();
    const sessionName = buildDdagentSessionName(initialMessage);
    sessionsDb.createAppSession(sessionId, provider, normalizedProjectPath, sessionName, resolvedAccountId);

    return {
      sessionId,
      provider,
      projectPath: normalizedProjectPath,
      sessionName,
    };
  },

  /**
   * Resolves the provider-native id only for an explicit user copy action.
   * Normal session payloads continue to expose only the stable app id.
   */
  getProviderSessionId(sessionId: string): string {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    if (!session.provider_session_id) {
      throw new AppError('This session ID is not available yet.', {
        code: 'PROVIDER_SESSION_ID_NOT_AVAILABLE',
        statusCode: 409,
      });
    }

    return session.provider_session_id;
  },

  /**
   * Fetches persisted history by app session id.
   *
   * Provider and provider-specific lookup hints are resolved from the indexed
   * session metadata in the database. The provider adapter receives the
   * provider-native session id (the one written into transcripts on disk),
   * and every returned message is remapped back to the app session id so
   * provider ids never reach the frontend.
   */
  async fetchHistory(
    sessionId: string,
    options: Pick<FetchHistoryOptions, 'limit' | 'offset'> = {},
  ): Promise<FetchHistoryResult> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    // Orchestrated sessions (full or mini) own no provider transcript: their
    // history lives in the DDAgent-owned orchestrator_messages table and is
    // mapped here to the same NormalizedMessage envelope every provider session
    // returns — tagged with the parent provider so the client routes it right.
    if (isOrchestratorProvider(session.provider)) {
      const rows = orchestratorMessagesDb.list(sessionId);
      const offset = options.offset ?? 0;
      const limited = options.limit ? rows.slice(offset, offset + options.limit) : rows.slice(offset);
      return {
        messages: limited.map((row) => orchestratorMessageToNormalized(row, session.provider)),
        total: rows.length,
        hasMore: offset + limited.length < rows.length,
        offset,
        limit: options.limit ?? null,
      };
    }

    // App-created sessions that never produced a provider transcript yet
    // (e.g. first message still streaming) have no provider history — only
    // the errors/notices stored when that first turn failed early.
    if (!session.provider_session_id) {
      return {
        messages: (options.offset ?? 0) === 0
          ? mergeSessionEvents([], sessionEventsDb.listBySession(sessionId), { isNewestPage: true, isOldestPage: true })
          : [],
        total: 0,
        hasMore: false,
        offset: options.offset ?? 0,
        limit: options.limit ?? null,
      };
    }

    const provider = session.provider as LLMProvider;
    const result = await providerRegistry.resolveProvider(provider).sessions.fetchHistory(sessionId, {
      limit: options.limit ?? null,
      offset: options.offset ?? 0,
      projectPath: session.project_path ?? '',
      providerSessionId: session.provider_session_id,
    });

    const messages = result.messages.map((message) => ({
      ...message,
      sessionId,
    }));
    return {
      ...result,
      messages: mergeSessionEvents(messages, sessionEventsDb.listBySession(sessionId), {
        isNewestPage: (options.offset ?? 0) === 0,
        isOldestPage: !result.hasMore,
      }),
    };
  },

  /**
   * Resolves one session (by app id, falling back to the provider-native id)
   * to its metadata plus the owning project.
   *
   * This backs deep links like `/session/:sessionId`: the frontend's paginated
   * project payloads only carry each project's first session page, so a
   * session opened directly by URL may not be present client-side at all —
   * this lookup is the authoritative way to learn which project owns it.
   */
  getSessionDetailsById(sessionId: string): SessionDetails {
    const session =
      sessionsDb.getSessionById(sessionId) ?? sessionsDb.getSessionByProviderSessionId(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    const projectPath = session.project_path?.trim() ? session.project_path : null;
    const project = projectPath ? projectsDb.getProjectPath(projectPath) : null;

    return {
      sessionId: session.session_id,
      provider: session.provider as LLMProvider,
      summary: session.custom_name?.trim() || '',
      createdAt: session.created_at ?? null,
      updatedAt: session.updated_at ?? null,
      lastActivity: session.updated_at ?? session.created_at ?? null,
      lastViewedAt: session.last_viewed_at ?? null,
      turnFinishedAt: session.turn_finished_at ?? null,
      isArchived: Boolean(session.isArchived),
      model: session.model ?? null,
      permissionMode: session.permission_mode ?? null,
      accountId: session.account_id ?? null,
      project: project && projectPath
        ? {
            projectId: project.project_id,
            path: projectPath,
            fullPath: projectPath,
            displayName: resolveProjectDisplayName(projectPath, project.custom_project_name),
            isStarred: Boolean(project.isStarred),
            isArchived: Boolean(project.isArchived),
          }
        : null,
    };
  },

  /**
   * Returns archived sessions with enough project metadata for the sidebar to
   * group, filter, open, and restore them without a per-row follow-up query.
   */
  listArchivedSessions(): ArchivedSessionListItem[] {
    const archivedSessions = sessionsDb.getArchivedSessions();
    const projectCache = new Map<string, ReturnType<typeof projectsDb.getProjectPath>>();

    return archivedSessions.map((session) => {
      const projectPath = session.project_path?.trim() ? session.project_path : null;
      let project = null;

      if (projectPath) {
        if (!projectCache.has(projectPath)) {
          projectCache.set(projectPath, projectsDb.getProjectPath(projectPath));
        }
        project = projectCache.get(projectPath) ?? null;
      }

      return {
        sessionId: session.session_id,
        provider: session.provider as LLMProvider,
        projectId: project?.project_id ?? null,
        projectPath,
        projectDisplayName: resolveProjectDisplayName(projectPath, project?.custom_project_name),
        sessionTitle: session.custom_name?.trim() || session.session_id,
        createdAt: session.created_at ?? null,
        updatedAt: session.updated_at ?? null,
        lastActivity: session.updated_at ?? session.created_at ?? null,
        isProjectArchived: Boolean(project?.isArchived),
        messageCount: countJsonlMessages(session.jsonl_path),
        accountId: session.account_id ?? null,
      };
    });
  },

  /**
   * Archives or permanently deletes one persisted session row by id.
   *
   * Soft-delete mirrors the project behavior by toggling `isArchived` so the
   * row disappears from active lists but remains restorable. Force-delete
   * optionally removes the transcript file before deleting the database row.
   */
  async deleteOrArchiveSessionById(
    sessionId: string,
    options: {
      force?: boolean;
      deletedFromDisk?: boolean;
    } = {},
  ): Promise<{ sessionId: string; action: 'archived' | 'deleted'; deletedFromDisk: boolean; childSessionIds: string[] }> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    // Delegated children share the parent's lifecycle: archiving or deleting
    // an orchestrated session cascades onto every child it spawned, so they
    // never linger as orphaned sidebar rows.
    const childSessionIds =
      isOrchestratorProvider(session.provider)
        ? orchestratorMessagesDb.listChildSessionIds(sessionId)
        : [];

    // A live provider run would keep appending to the transcript and draining
    // the queue after the row is archived or deleted — refuse instead of
    // orphaning it. Callers stop the run first, then retry.
    const busySessionId = [sessionId, ...childSessionIds].find((id) =>
      chatRunRegistry.isProcessing(id),
    );
    if (busySessionId) {
      throw new AppError(`Session "${busySessionId}" has an active run. Stop the run before archiving or deleting it.`, {
        code: 'SESSION_RUN_IN_PROGRESS',
        statusCode: 409,
      });
    }

    if (!options.force) {
      for (const id of [sessionId, ...childSessionIds]) {
        sessionsDb.updateSessionIsArchived(id, true);
      }
      return {
        sessionId,
        action: 'archived',
        deletedFromDisk: false,
        childSessionIds,
      };
    }

    // Children go through the same delete path first (disk transcript, row,
    // queued rows); a delegation entry can reference an already-deleted
    // child, which is skipped rather than failing the whole delete.
    for (const childSessionId of childSessionIds) {
      try {
        await sessionsService.deleteOrArchiveSessionById(childSessionId, options);
      } catch (error) {
        if ((error as AppError).code !== 'SESSION_NOT_FOUND') throw error;
      }
    }

    let removedFromDisk = false;
    if (options.deletedFromDisk && session.jsonl_path) {
      removedFromDisk = await removeFileIfExists(session.jsonl_path);
    }

    const deleted = sessionsDb.deleteSessionById(sessionId);
    if (!deleted) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    // The session id is gone — its queued rows can never dispatch and would
    // linger as dead `failed` rows forever.
    queuedMessagesDb.removeBySession(sessionId);
    sessionEventsDb.deleteForSession(sessionId);
    // Orchestrated sessions additionally own their transcript rows plus one
    // shared plan-run worktree; remove both on force-delete (archive keeps
    // them so restore can resume children).
    if (session.provider === 'orchestrator') {
      const rows = orchestratorMessagesDb.list(sessionId);
      const worktrees = new Set(
        rows
          .map((row) => row.payload.worktreePath)
          .filter((path): path is string => typeof path === 'string' && path.length > 0),
      );
      for (const worktreePath of worktrees) {
        if (!session.project_path) break;
        const { worktreeServices } = await import('@/modules/worktrees/index.js');
        await worktreeServices
          .remove({ projectPath: session.project_path, worktreePath, force: true, deleteBranch: true })
          .catch((error) => {
            console.warn('[Sessions] Orchestrator worktree cleanup failed', { sessionId, worktreePath, error });
          });
      }
    }
    orchestratorMessagesDb.deleteForSession(sessionId);

    return {
      sessionId,
      action: 'deleted',
      deletedFromDisk: removedFromDisk,
      childSessionIds,
    };
  },

  /**
   * Restores one archived session back into the active sidebar lists.
   * Delegated children are unarchived alongside their orchestrated parent —
   * the archive cascade hid them, so leaving them down would orphan rows the
   * sidebar can no longer reach.
   */
  restoreSessionById(
    sessionId: string,
  ): { sessionId: string; isArchived: false; childSessionIds: string[] } {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    const childSessionIds =
      isOrchestratorProvider(session.provider)
        ? orchestratorMessagesDb.listChildSessionIds(sessionId)
        : [];
    for (const id of [sessionId, ...childSessionIds]) {
      sessionsDb.updateSessionIsArchived(id, false);
    }
    return { sessionId, isArchived: false, childSessionIds };
  },

  /**
   * Renames one session by id without requiring the caller to pass provider.
   */
  renameSessionById(sessionId: string, summary: string): { sessionId: string; summary: string } {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    sessionsDb.updateSessionCustomName(sessionId, summary);
    return { sessionId, summary };
  },

  /**
   * Moves one session onto a different workspace directory.
   *
   * `sessions.project_path` is the single source of truth for the agent's
   * working directory, so later turns run against the new workspace without
   * restarting the session. The destination must pass `validateWorkspacePath`
   * (inside WORKSPACES_ROOT, not a system directory); it is created if missing
   * and its project row is registered so the session shows up under it.
   */
  async updateSessionWorkspaceById(
    sessionId: string,
    requestedPath: string,
  ): Promise<{ sessionId: string; projectPath: string }> {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    const validation = await validateWorkspacePath(requestedPath);
    if (!validation.valid || !validation.resolvedPath) {
      throw new AppError(validation.error ?? 'Workspace path is invalid.', {
        code: 'INVALID_WORKSPACE_PATH',
        statusCode: 400,
      });
    }

    const projectPath = normalizeProjectPath(validation.resolvedPath);
    await fsp.mkdir(projectPath, { recursive: true });
    projectsDb.createProjectPath(projectPath);
    sessionsDb.updateSessionProjectPath(sessionId, projectPath);
    return { sessionId, projectPath };
  },

  /**
   * Stamps one session's output as viewed by the user.
   *
   * Backs `POST /sessions/:sessionId/viewed`: clients render an unread marker
   * for sessions whose `updated_at` is newer than `last_viewed_at`. The
   * `session_upserted` broadcast that refreshes other devices lives in the
   * route handler — importing the sessions watcher here would create a
   * circular module dependency (watcher → projects → providers → this file).
   */
  markSessionViewed(sessionId: string): { sessionId: string; lastViewedAt: string | null } {
    const session = sessionsDb.getSessionById(sessionId);
    if (!session) {
      throw new AppError(`Session "${sessionId}" was not found.`, {
        code: 'SESSION_NOT_FOUND',
        statusCode: 404,
      });
    }

    sessionsDb.markSessionViewed(sessionId);
    const updatedSession = sessionsDb.getSessionById(sessionId);

    return { sessionId, lastViewedAt: updatedSession?.last_viewed_at ?? null };
  },
};

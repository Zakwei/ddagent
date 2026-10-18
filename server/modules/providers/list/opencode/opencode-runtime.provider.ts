import fsSync from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

import {
  appendFilesInputTag,
  appendImagesInputTag,
  isAllowedImageSourcePath,
  normalizeAttachmentDescriptors,
  normalizeImageDescriptors,
  resolveImageAbsolutePath,
  resolveImageMediaType,
  createCompleteMessage,
  createNormalizedMessage,
  getOpenCodeDatabasePath,
  openSqliteReadonlyDatabase,
  readObjectRecord,
  readOptionalString,
} from '@/shared/index.js';
import { formatCliToolResult } from '@/shared/utils.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';
import { orchestratorMessagesDb } from '@/modules/database/index.js';
import { ensureServer, getServer, serverAuthHeaders } from '@/modules/providers/list/opencode/opencode-server.manager.js';
import {
  extractOpenCodeErrorMessage,
  joinOpenCodeToolContent,
} from '@/modules/providers/list/opencode/opencode-sessions.provider.js';
import type {
  IProviderRuntime,
  AnyRecord,
  ProviderPermissionDecision,
  ProviderRuntimeContext,
  ProviderRuntimeWriter,
} from '@/shared/index.js';

const PROVIDER = 'opencode';

/**
 * How one UI permission mode maps onto OpenCode server-side behavior.
 *
 * Unlike the old one-shot `opencode run` transport, sessions driven through
 * `opencode serve` pend on `permission.asked` events until a client replies.
 * The runtime watches those events and answers them according to the active
 * mode — which is what makes toggling bypass mid-response work.
 *
 * - plan              → prompts go to the built-in read-only `plan` agent.
 * - bypassPermissions → every pending ask is auto-approved ('once' — nothing
 *                       is persisted, so toggling the mode off stops granting).
 * - acceptEdits       → edit-family asks auto-approve; everything else still
 *                       reaches the user as an interactive permission request.
 * - default           → asks are forwarded to the UI (`permission_request`)
 *                       and resolved by the user's decision.
 *
 * Exported for tests only.
 */
export function resolveOpenCodePermissionBehavior(permissionMode: string | undefined): {
  agent?: 'plan';
  autoApprove: 'all' | 'edits' | 'none';
} {
  switch (permissionMode) {
    case 'plan':
      return { agent: 'plan', autoApprove: 'none' };
    case 'bypassPermissions':
      return { autoApprove: 'all' };
    case 'acceptEdits':
      return { autoApprove: 'edits' };
    default:
      return { autoApprove: 'none' };
  }
}

// OpenCode permission names for the edit tool family — approved under
// acceptEdits. Everything else still reaches the interactive request path.
const EDIT_PERMISSIONS = new Set(['edit', 'write', 'multiedit', 'patch', 'apply_patch']);

function resolveOpenCodeEffort(model: string | undefined, effort: unknown, modelsDefinition: AnyRecord | null): string | undefined {
  const selectedModel = modelsDefinition?.OPTIONS?.find(
    (option: AnyRecord) => option.value === model,
  );
  const allowedEfforts = selectedModel?.effort?.values?.map((value: AnyRecord) => value.value) || [];
  return typeof effort === 'string' && effort !== 'default' && allowedEfforts.includes(effort)
    ? effort
    : undefined;
}

function readOpenCodeTokenUsage(sessionId: string | null): AnyRecord | null {
  const dbPath = getOpenCodeDatabasePath();
  if (!sessionId || !fsSync.existsSync(dbPath)) {
    return null;
  }

  let db: ReturnType<typeof openSqliteReadonlyDatabase> | null = null;
  try {
    db = openSqliteReadonlyDatabase(dbPath);
    // OpenCode 2 rows live in `session_v2`; a session created by 1.x (or a
    // 1.x-only database) is still in `session`.
    const tables = (db.prepare("SELECT name FROM sqlite_master WHERE type = 'table' AND name IN ('session_v2', 'session')")
      .all() as { name: string }[]).map((entry) => entry.name);
    const requiredColumns = ['tokens_input', 'tokens_output', 'tokens_reasoning', 'tokens_cache_read', 'tokens_cache_write'];
    let row: AnyRecord | undefined;
    for (const table of ['session_v2', 'session']) {
      if (!tables.includes(table)) {
        continue;
      }
      const columns = db.prepare(`PRAGMA table_info(${table})`).all() as { name: string }[];
      const columnNames = new Set(columns.map((column) => column.name));
      if (!requiredColumns.every((column) => columnNames.has(column))) {
        continue;
      }
      row = db.prepare(`
        SELECT
          tokens_input AS inputTokens,
          tokens_output AS outputTokens,
          tokens_reasoning AS reasoningTokens,
          tokens_cache_read AS cacheReadTokens,
          tokens_cache_write AS cacheWriteTokens
        FROM ${table}
        WHERE id = ?
      `).get(sessionId) as AnyRecord | undefined;
      if (row) {
        break;
      }
    }

    if (!row) {
      return null;
    }

    const inputTokens = Number(row.inputTokens || 0) + Number(row.cacheReadTokens || 0);
    const outputTokens = Number(row.outputTokens || 0);
    const used = Number(row.inputTokens || 0)
      + outputTokens
      + Number(row.reasoningTokens || 0)
      + Number(row.cacheReadTokens || 0)
      + Number(row.cacheWriteTokens || 0);
    if (used <= 0) {
      return null;
    }

    return {
      used,
      inputTokens,
      outputTokens,
      breakdown: {
        input: inputTokens,
        output: outputTokens,
      },
    };
  } catch {
    return null;
  } finally {
    if (db) {
      db.close();
    }
  }
}

type ActiveRun = {
  appSessionId: string;
  providerSessionId: string | null;
  directory: string;
  baseUrl: string | null;
  writer: ProviderRuntimeWriter;
  context: ProviderRuntimeContext;
  sessionSummary?: string;
  aborted: boolean;
  completeSent: boolean;
  /**
   * True once this run's own `prompt_async` POST went out. `session.idle` /
   * `session.error` events that arrive earlier belong to the previous turn
   * (an abort's trailing idle, or replayed state) and must not settle us.
   */
  promptPosted: boolean;
  /** Timestamp of the prompt post — grounds the stale-idle age floor. */
  promptPostedAt: number;
  /**
   * True once this run observed its own turn going busy. `session.idle` is
   * terminal only after a busy — an idle with no preceding busy is stale.
   */
  sawBusy: boolean;
  /**
   * Updated for every SSE event routed to this run — any traffic after a
   * suspect `session.idle` proves the turn is still producing, which is how
   * the stale-idle settle distinguishes a leftover idle from a real one.
   */
  lastEventAt: number;
  /** When the currently-debated stale `session.idle` was observed. */
  idleSeenAt?: number;
  /**
   * Grace timer for a `session.idle` that arrived after our prompt posted
   * but before any busy event — a real turn emits busy first, so a bare
   * idle is most likely the previous turn's leftover. If no busy follows
   * within the window the idle is accepted anyway (an OpenCode that skips
   * the busy status must not hang the run forever).
   */
  idleTimer?: ReturnType<typeof setTimeout>;
  /**
   * partID → part.type learned from `message.part.updated` (which always
   * precedes a part's deltas). `message.part.delta` carries no part type, so
   * text vs reasoning is resolved through this map.
   */
  partTypes: Map<string, string>;
  /**
   * Parts already forwarded as live deltas. A reasoning part that streamed
   * must not be re-sent as a `thinking` snapshot — the client would render
   * the same reasoning twice (live row + snapshot row; that dedupe path only
   * collapses text echoes). History still reloads it from the OpenCode DB.
   */
  streamedParts: Set<string>;
  /**
   * Part whose deltas currently feed the client's open live row. Deltas of
   * another part, or any non-text part (tool, step), end that row first so
   * text before and after a tool call never merge into one message.
   */
  livePartId: string | null;
  /**
   * messageIDs that already emitted an edit/write tool card. OpenCode mirrors
   * every such edit with an auto-generated `patch` part in the same message;
   * the live `message.part.updated` for that patch is skipped so the UI shows
   * one card, like the CLI. Reset per run — a later turn re-edits freely.
   */
  editedMessageIds: Set<string>;
  /**
   * The exact `prompt_async` body this run posted — kept so a poisoned
   * directory instance can be reset and the same turn retried once.
   */
  promptBody?: AnyRecord;
  /** True once the poisoned-instance recovery already ran for this run. */
  poisonRetried: boolean;
  /**
   * True while the poisoned-instance recovery is in flight — the killed
   * turn's trailing `session.idle`/`session.error` must not settle the run;
   * the retried turn's own events do that instead.
   */
  recovering: boolean;
  /**
   * Retry-streak bookkeeping for `session.status: retry` — `retrySince` is
   * the wall-clock start of the current stall window (0 = not retrying) and
   * `retryAttempt` the highest attempt observed. A rising attempt proves the
   * retry loop is alive; a stagnant one past RETRY_STALL_TIMEOUT_MS means
   * the provider call is wedged.
   */
  retrySince: number;
  retryAttempt: number;
  /** Set once a stalled retry already triggered the abort-and-fail path. */
  retryStallAborted: boolean;
  /**
   * Account/credential env this run's server was spawned with — needed to
   * look up or respawn the replacement serve instance on failover.
   */
  envOverrides?: Record<string, string>;
  resolve: () => void;
  reject: (error: Error) => void;
};

type ForwardedQuestion = {
  question: string;
  header?: string;
  options: { label: string; description?: string }[];
  multiSelect?: boolean;
};

// Label of the synthetic option added for `custom` questions — the client
// opens its free-text field for "Other"-style options.
const FREE_TEXT_OPTION_LABEL = 'Other';

type PendingPermission = {
  requestId: string;
  appSessionId: string | null;
  providerSessionId: string;
  permissionID: string;
  baseUrl: string;
  directory: string;
  toolName: string;
  input: unknown;
  /**
   * `question` requests (the `question` tool) look like permissions to the UI
   * but are a separate OpenCode family with their own reply/reject endpoints.
   * The discriminator routes `resolve` to the right transport.
   */
  kind: 'permission' | 'question';
  questions?: ForwardedQuestion[];
  /** Field keys/types behind [questions] — a `question` entry's form. */
  formFields?: FormFieldSpec[];
};

type EventStreamState = {
  alive: boolean;
  controller: AbortController;
  retryCount: number;
  /** Server replacements survived by this stream — reset on each connect. */
  failovers: number;
  connected: Promise<void>;
  markConnected: () => void;
  /** Last received SSE event id — sent as Last-Event-ID on reconnect. */
  lastEventId: string | null;
  /** Updated on every decoded chunk — the stall watchdog's liveness signal. */
  lastActivityAt: number;
};

// Runs are keyed by the stable app session id so abort/mode updates always
// address the right run; SSE events carry the provider-native session id and
// route through `providerToApp`.
const activeRuns = new Map<string, ActiveRun>();
const providerToApp = new Map<string, string>();
// Child provider session (spawned by the `task` subagent tool) -> its parent
// provider session, learned from `session.created`/`session.updated`. Only
// asks route through it: a child's other events (its own `session.idle`,
// text) must never drive the parent's run.
const childToParent = new Map<string, string>();

// App session that owns an ask raised in `providerSessionId` — the session
// itself, or the nearest ancestor of a subagent child session.
function resolveAskAppSessionId(providerSessionId: string): string | null {
  let current: string | undefined = providerSessionId;
  for (let depth = 0; current && depth < 8; depth += 1) {
    const appSessionId = providerToApp.get(current);
    if (appSessionId) return appSessionId;
    current = childToParent.get(current);
  }
  return null;
}
const eventStreams = new Map<string, EventStreamState>();
const pendingPermissions = new Map<string, PendingPermission>();
// Latest UI permission mode per app session — read by the permission watcher
// at each `permission.asked` event, so mid-response toggles take effect.
const sessionModes = new Map<string, string>();

const API_TIMEOUT_MS = 15000;
const SSE_RECONNECT_DELAY_MS = 1000;
const SSE_MAX_RECONNECTS = 5;
/**
 * Replacements a stream will adopt before giving up: each failover waits out
 * a full retry budget plus a serve spawn (~15–25 s), so three attempts bound
 * a crash-looping server without turning one bad spawn into a run failure.
 */
const SSE_MAX_FAILOVERS = 3;
/**
 * `opencode serve` emits `server.heartbeat` roughly every 30 s, so a stream
 * that stays silent past this window is a half-open connection — TCP keeps
 * it "open" forever while events are lost. The watchdog aborts the attempt
 * and lets the normal reconnect path take over.
 */
const SSE_STALL_TIMEOUT_MS = 90_000;
const SSE_WATCHDOG_INTERVAL_MS = 15_000;
/**
 * While any prompt-posted run is live, the session's real status is polled
 * on this cadence — independent of the SSE stream. It is the catch-all for
 * terminal events missed without a disconnect (instance-scoped drops,
 * frames lost between retries): an observed `idle` settles the run exactly
 * like the SSE event would.
 */
const STATUS_RECONCILE_INTERVAL_MS = 15_000;
/**
 * Grace window for a prompt-posted-but-never-busy `session.idle` before it
 * is accepted as terminal anyway.
 */
const STALE_IDLE_GRACE_MS = 2000;
/**
 * A run younger than this may simply be queued behind provider pickup — its
 * pre-busy idle is not trustworthy yet. The stale-idle settle re-arms at the
 * floor instead of finishing a turn that has not started.
 */
const STALE_IDLE_MIN_TURN_AGE_MS = 10_000;
/**
 * Budget for a provider `retry` status whose attempt counter stops
 * advancing. A healthy try is bounded by the provider's own upstream
 * timeout, so an attempt older than this is wedged — the request hung past
 * its timeout or OpenCode's retry loop died mid-backoff. The watchdog then
 * aborts the provider turn and fails the run, turning a silent "retry N"
 * spin into a real error callers can fail over from.
 * `OPENCODE_RETRY_STALL_MS` overrides the budget (tests).
 */
const RETRY_STALL_TIMEOUT_MS = 15 * 60_000;

/**
 * One call against the OpenCode 2 HTTP API: routes live under `/api`, every
 * request carries the serve instance's basic-auth password, and the project
 * directory travels as the `location[directory]` query parameter (the 1.x
 * `directory` parameter is gone). Response bodies are JSON envelopes
 * (`{ data: … }`) — callers unwrap what they need.
 */
async function apiRequest(
  baseUrl: string,
  path: string,
  options: { method?: string; query?: Record<string, string>; body?: unknown } = {},
): Promise<{ status: number; data: unknown }> {
  const url = new URL(`${baseUrl}/api${path}`);
  for (const [key, value] of Object.entries(options.query ?? {})) {
    url.searchParams.set(key === 'directory' ? 'location[directory]' : key, value);
  }

  const response = await fetch(url.toString(), {
    method: options.method ?? 'GET',
    headers: {
      ...serverAuthHeaders(baseUrl),
      ...(options.body !== undefined ? { 'Content-Type': 'application/json' } : {}),
    },
    body: options.body !== undefined ? JSON.stringify(options.body) : undefined,
    signal: AbortSignal.timeout(API_TIMEOUT_MS),
  });

  let data: unknown = null;
  const text = await response.text();
  if (text) {
    try {
      data = JSON.parse(text);
    } catch {
      data = text;
    }
  }
  return { status: response.status, data };
}

/**
 * `POST /session/{id}/permission/{request}/reply` — a bare `reject` halts
 * the agent; with [message] OpenCode feeds the text back and keeps going.
 */
function replyPermission(
  baseUrl: string,
  directory: string,
  providerSessionId: string,
  permissionID: string,
  decision: 'once' | 'always' | 'reject',
  message?: string,
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/session/${providerSessionId}/permission/${permissionID}/reply`, {
    method: 'POST',
    query: { directory },
    body: { decision, ...(message ? { message } : {}) },
  }).catch((error) => {
    console.warn('[OpenCode] Permission reply failed:', error instanceof Error ? error.message : String(error));
    return { status: 0, data: null };
  });
}

/** `POST /session/{id}/form/{form}/reply` — answers keyed by field key. */
function replyForm(
  baseUrl: string,
  directory: string,
  providerSessionId: string,
  formId: string,
  answer: AnyRecord,
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/session/${providerSessionId}/form/${formId}/reply`, {
    method: 'POST',
    query: { directory },
    body: { answer },
  }).catch((error) => {
    console.warn('[OpenCode] Form reply failed:', error instanceof Error ? error.message : String(error));
    return { status: 0, data: null };
  });
}

/** `DELETE /session/{id}/form/{form}` — the user declined to answer. */
function cancelForm(
  baseUrl: string,
  directory: string,
  providerSessionId: string,
  formId: string,
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/session/${providerSessionId}/form/${formId}`, {
    method: 'DELETE',
    query: { directory },
  }).catch((error) => {
    console.warn('[OpenCode] Form cancel failed:', error instanceof Error ? error.message : String(error));
    return { status: 0, data: null };
  });
}

function modeForSession(appSessionId: string | null): string {
  return (appSessionId && sessionModes.get(appSessionId)) || 'default';
}

/**
 * Delegated (orchestrator-spawned) child sessions have no one watching their
 * transcript: a forwarded question would wait forever for an answer that
 * cannot come, so those keep the non-interactive resolve path.
 */
function isDelegatedChildSession(appSessionId: string | null): boolean {
  try {
    return Boolean(appSessionId && orchestratorMessagesDb.findDelegationByChildSessionId(appSessionId));
  } catch {
    return false;
  }
}

function forwardPermissionRequest(
  run: ActiveRun | null,
  providerSessionId: string,
  props: AnyRecord,
): void {
  const requestId = String(props.id);
  const toolName = String(props.permission || 'tool');
  const input = buildPermissionInput(props);

  pendingPermissions.set(requestId, {
    requestId,
    appSessionId: run?.appSessionId ?? null,
    providerSessionId,
    permissionID: requestId,
    baseUrl: run?.baseUrl ?? '',
    directory: run?.directory ?? '',
    toolName,
    input,
    kind: 'permission',
  });

  run?.writer.send(createNormalizedMessage({
    kind: 'permission_request',
    requestId,
    toolName,
    input,
    ...openCodeRememberContext(input),
    sessionId: providerSessionId,
    provider: PROVIDER,
  }));
}

/**
 * C4: what the user is approving — OpenCode's raw ask plus the readable
 * fields the client's tool renderers already know (`command`, `file_path`,
 * `url`), pulled from metadata or, failing that, the ask's patterns.
 */
function buildPermissionInput(props: AnyRecord): AnyRecord {
  const metadata = readObjectRecord(props.metadata) ?? {};
  const patterns = Array.isArray(props.patterns)
    ? props.patterns.filter((pattern: unknown): pattern is string => typeof pattern === 'string' && pattern.length > 0)
    : [];
  const permission = String(props.permission ?? '');
  const command = readOptionalString(metadata.command)
    ?? (permission === 'bash' && patterns.length ? patterns.join('\n') : undefined);
  const filePath = readOptionalString(metadata.filepath)
    ?? readOptionalString(metadata.filePath)
    ?? readOptionalString(metadata.file_path)
    ?? readOptionalString(metadata.path)
    ?? (['read', 'external_directory', ...EDIT_PERMISSIONS].includes(permission) ? patterns[0] : undefined);
  const url = readOptionalString(metadata.url);
  return {
    permission: props.permission,
    patterns: props.patterns,
    metadata: props.metadata,
    always: props.always,
    ...(command ? { command } : {}),
    ...(filePath ? { file_path: filePath } : {}),
    ...(url ? { url } : {}),
  };
}

// OpenCode lists the patterns an "always" reply approves for the session;
// "Always" is offered only when there are some.
function openCodeRememberContext(input: AnyRecord) {
  const patterns = Array.isArray(input.always)
    ? input.always.filter((pattern: unknown) => typeof pattern === 'string' && pattern)
    : [];
  return patterns.length
    ? { context: { rememberEntry: `${String(input.permission ?? 'tool')}: ${patterns.join(', ')}` } }
    : {};
}

function handlePermissionAsked(baseUrl: string, props: AnyRecord): void {
  const providerSessionId = String(props.sessionID ?? '');
  const requestId = String(props.id ?? '');
  if (!providerSessionId || !requestId) {
    return;
  }

  const appSessionId = resolveAskAppSessionId(providerSessionId);
  const run = appSessionId ? activeRuns.get(appSessionId) : undefined;
  const mode = modeForSession(appSessionId);
  const { autoApprove } = resolveOpenCodePermissionBehavior(mode);

  // A pending ask with no owning run can only stall the provider forever —
  // there is no UI to forward it to. Match the old non-interactive `run`
  // behavior and reject it.
  if (!run || !run.baseUrl) {
    void replyPermission(baseUrl, run?.directory ?? '', providerSessionId, requestId, 'reject');
    return;
  }

  if (autoApprove === 'all') {
    void replyPermission(run.baseUrl, run.directory, providerSessionId, requestId, 'once');
    return;
  }

  const permissionName = String(props.permission ?? '');
  if (autoApprove === 'edits' && EDIT_PERMISSIONS.has(permissionName)) {
    void replyPermission(run.baseUrl, run.directory, providerSessionId, requestId, 'once');
    return;
  }

  forwardPermissionRequest(run, providerSessionId, props);
}

function handlePermissionReplied(_baseUrl: string, props: AnyRecord): void {
  // 1.18 sends `requestID`; older builds sent `permissionID`. Asks OpenCode
  // auto-resolves (an "always" reply covering siblings, a reject cascading)
  // arrive here too, so their prompts are cleared below.
  const requestId = String(props.requestID ?? props.permissionID ?? '');
  const pending = requestId ? pendingPermissions.get(requestId) : undefined;
  if (!pending) {
    return;
  }

  pendingPermissions.delete(requestId);
  // The ask was answered outside our resolve path (e.g. a second client) —
  // tell our UI to drop the request so it does not look stuck.
  const run = pending.appSessionId ? activeRuns.get(pending.appSessionId) : undefined;
  run?.writer.send(createNormalizedMessage({
    kind: 'permission_cancelled',
    requestId,
    reason: 'resolved',
    sessionId: pending.providerSessionId,
    provider: PROVIDER,
  }));
}

/**
 * A form field as the interactive panel knows it: the UI renders questions
 * with option labels, OpenCode wants `{ [field.key]: value }` back, so the
 * label → value map and the field type ride along in the pending entry.
 */
type FormFieldSpec = {
  key: string;
  type: string;
  multi: boolean;
  valueByLabel: Record<string, string>;
};

function mapFormField(field: AnyRecord): { question: ForwardedQuestion; spec: FormFieldSpec } | null {
  const key = readOptionalString(field.key);
  if (!key || field.hidden === true) {
    return null;
  }
  const type = readOptionalString(field.type) ?? 'string';
  const rawOptions = Array.isArray(field.options) ? field.options : [];
  const mapped = rawOptions
    .map((option: unknown) => {
      const record = readObjectRecord(option) ?? {};
      const value = readOptionalString(record.value) ?? readOptionalString(record.label) ?? '';
      const label = readOptionalString(record.label) ?? value;
      return { label, value, description: readOptionalString(record.description) };
    })
    .filter((option: { label: string }) => option.label);
  let options: { label: string; description?: string }[] = mapped.map(({ label, description }) => ({ label, description }));
  const valueByLabel: Record<string, string> = Object.fromEntries(mapped.map(({ label, value }) => [label, value]));
  if (type === 'boolean') {
    options = [{ label: 'Yes' }, { label: 'No' }];
    valueByLabel.Yes = 'true';
    valueByLabel.No = 'false';
  }
  // `custom` (default on for option lists) lets the user type an answer;
  // free-form fields have nothing else. Surface it as an "Other" option
  // unless the model already offered one.
  const allowCustom = type !== 'boolean' && type !== 'external' && (field.custom !== false || options.length === 0);
  if (allowCustom && !options.some((option) => /\b(other|custom)\b/i.test(option.label))) {
    options.push({ label: FREE_TEXT_OPTION_LABEL, description: 'Type your own answer' });
  }
  return {
    question: {
      question: readOptionalString(field.title) ?? key,
      header: readOptionalString(field.description),
      options,
      multiSelect: type === 'multiselect',
    },
    spec: { key, type, multi: type === 'multiselect', valueByLabel },
  };
}

/**
 * OpenCode 2 asks the user through forms (`form.created`; the `question`
 * tool produces one with `metadata.kind = "question"`). They are surfaced to
 * the UI through the same `permission_request` channel so the existing
 * interactive panel renders, and answered through the form reply endpoint
 * from `resolve`.
 */
function handleFormCreated(baseUrl: string, form: AnyRecord): void {
  const providerSessionId = String(form.sessionID ?? '');
  const formId = String(form.id ?? '');
  if (!providerSessionId || !formId) {
    return;
  }

  const appSessionId = resolveAskAppSessionId(providerSessionId);
  const run = appSessionId ? activeRuns.get(appSessionId) : undefined;
  const fields = (Array.isArray(form.fields) ? form.fields : [])
    .map((field: unknown) => mapFormField(readObjectRecord(field) ?? {}))
    .filter((entry): entry is { question: ForwardedQuestion; spec: FormFieldSpec } => entry !== null);

  // No run means there is no UI to answer through — cancelling lets the
  // provider continue instead of hanging the turn forever.
  if (!run || !run.baseUrl || fields.length === 0) {
    void cancelForm(baseUrl, run?.directory ?? '', providerSessionId, formId);
    return;
  }

  // A form is user input, not a permission: bypassPermissions must not
  // answer for the user. Only headless delegated children keep the
  // empty-answer skip — there is no one to render the panel to.
  if (
    resolveOpenCodePermissionBehavior(modeForSession(appSessionId)).autoApprove === 'all'
    && isDelegatedChildSession(appSessionId)
  ) {
    void replyForm(run.baseUrl, run.directory, providerSessionId, formId, {});
    return;
  }

  const questions = fields.map((entry) => entry.question);
  const input = { questions };
  pendingPermissions.set(formId, {
    requestId: formId,
    appSessionId: run.appSessionId,
    providerSessionId,
    permissionID: formId,
    baseUrl: run.baseUrl,
    directory: run.directory,
    toolName: 'AskUserQuestion',
    input,
    kind: 'question',
    questions,
    formFields: fields.map((entry) => entry.spec),
  });

  run.writer.send(createNormalizedMessage({
    kind: 'permission_request',
    requestId: formId,
    toolName: 'AskUserQuestion',
    input,
    sessionId: providerSessionId,
    provider: PROVIDER,
  }));
}

function handleFormSettled(formId: string): void {
  const pending = formId ? pendingPermissions.get(formId) : undefined;
  if (!pending || pending.kind !== 'question') {
    return;
  }
  pendingPermissions.delete(formId);
  const run = pending.appSessionId ? activeRuns.get(pending.appSessionId) : undefined;
  run?.writer.send(createNormalizedMessage({
    kind: 'permission_cancelled',
    requestId: formId,
    reason: 'resolved',
    sessionId: pending.providerSessionId,
    provider: PROVIDER,
  }));
}

/**
 * Turns the interactive panel's `answers` (question text → label, or labels
 * joined with ", ") into OpenCode's `{ [field.key]: value }`. Only
 * multi-select answers are split; a single-select or free-text answer is
 * kept whole (free text may contain ", "). A multi-select value equal to one
 * option label is also kept whole, so labels that themselves contain ", "
 * survive. Labels map back to option values; numbers and booleans are typed.
 */
function formAnswerFromUi(questions: ForwardedQuestion[], specs: FormFieldSpec[], answers: unknown): AnyRecord {
  const map = answers && typeof answers === 'object' && !Array.isArray(answers)
    ? (answers as Record<string, unknown>)
    : {};
  const answer: AnyRecord = {};
  specs.forEach((spec, index) => {
    const question = questions[index];
    if (!question) {
      return;
    }
    const raw = map[question.question];
    const toValue = (label: string) => spec.valueByLabel[label] ?? label;
    if (spec.multi) {
      let labels: string[] = [];
      if (Array.isArray(raw)) {
        labels = raw.map(String);
      } else if (typeof raw === 'string' && raw.trim()) {
        labels = question.options.some((option) => option.label === raw)
          ? [raw]
          : raw.split(', ').map((part) => part.trim()).filter(Boolean);
      }
      answer[spec.key] = labels.map(toValue);
      return;
    }
    if (typeof raw !== 'string' || raw.trim() === '') {
      return;
    }
    const value = toValue(raw);
    if (spec.type === 'number' || spec.type === 'integer') {
      const parsed = Number(value);
      answer[spec.key] = Number.isFinite(parsed) ? parsed : value;
    } else if (spec.type === 'boolean') {
      answer[spec.key] = value === 'true' || /^(yes|y|true)$/i.test(raw);
    } else {
      answer[spec.key] = value;
    }
  });
  return answer;
}

function finishRun(run: ActiveRun): void {
  // A retry-stall abort's trailing idle must not settle the run as a success;
  // trackRetryStatus fails it once the abort POST returns.
  if (run.completeSent || run.retryStallAborted) {
    return;
  }
  if (run.aborted) {
    run.resolve();
    return;
  }
  run.completeSent = true;

  const tokenBudget = readOpenCodeTokenUsage(run.providerSessionId);
  if (tokenBudget) {
    run.writer.send(createNormalizedMessage({
      kind: 'status',
      text: 'token_budget',
      tokenBudget,
      sessionId: run.providerSessionId ?? run.appSessionId,
      provider: PROVIDER,
    }));
  }

  run.writer.send(createCompleteMessage({
    provider: PROVIDER,
    sessionId: run.providerSessionId ?? run.appSessionId,
    exitCode: 0,
  }));
  notifyTerminalState(run, null);
  run.resolve();
}

function failRun(run: ActiveRun, error: Error): void {
  if (run.aborted) {
    run.resolve();
    return;
  }
  notifyTerminalState(run, error);
  if (!run.completeSent) {
    run.completeSent = true;
    run.writer.send(createNormalizedMessage({
      kind: 'error',
      content: error.message,
      sessionId: run.providerSessionId ?? run.appSessionId,
      provider: PROVIDER,
    }));
    run.writer.send(createCompleteMessage({
      provider: PROVIDER,
      sessionId: run.providerSessionId ?? run.appSessionId,
      exitCode: 1,
    }));
  }
  run.reject(error);
}

// Ends the client's open live row (message and reasoning) at a part boundary.
function closeLivePart(run: ActiveRun, sessionId: string): void {
  if (!run.livePartId) return;
  run.livePartId = null;
  run.writer.send(createNormalizedMessage({ kind: 'stream_end', sessionId, provider: PROVIDER }));
}

/**
 * OpenCode 2's `permission.asked` carries a `Permission.Request`
 * (`action`, `resources`, `save`, `metadata`, `source`); the handlers below
 * were written for the 1.x names and keep them, so the request is mapped.
 */
function normalizePermissionRequest(props: AnyRecord): AnyRecord {
  if (props.permission !== undefined || props.action === undefined) {
    return props;
  }
  return {
    ...props,
    permission: props.action,
    patterns: Array.isArray(props.resources) ? props.resources : [],
    always: Array.isArray(props.save) ? props.save : [],
    tool: props.source,
  };
}

const livePartKey = (messageId: string, kind: 'text' | 'reasoning', ordinal: number): string =>
  `${messageId}_${kind}_${ordinal}`;

const toolMessageId = (messageId: string, callId: string): string =>
  messageId ? `${messageId}_${callId}` : callId;

/** A turn is visibly live — a later idle/succeeded is ours to settle. */
function markTurnLive(run: ActiveRun): void {
  adoptLiveStatus(run);
  clearRetryStatus(run);
}

/**
 * Routes one server event to the run that owns the session. OpenCode 2
 * streams a turn as `session.execution.started` → `session.step.*` with
 * `session.text.*` / `session.reasoning.*` / `session.tool.*` inside →
 * `session.execution.succeeded|failed|interrupted`. Permission asks and
 * forms arrive as `permission.*` / `form.*`.
 */
function dispatchServerEvent(baseUrl: string, event: AnyRecord): void {
  // OpenCode 2 envelope: `{ id, type, data }`. The 1.x `properties` shape is
  // still read so the status reconcile's synthetic events stay simple.
  const props = (readObjectRecord(event.data) ?? readObjectRecord(event.properties) ?? {}) as AnyRecord;
  const type = String(event.type ?? '');

  if (type === 'permission.asked') {
    handlePermissionAsked(baseUrl, normalizePermissionRequest(props));
    return;
  }
  if (type === 'permission.replied' || type === 'permission.rejected') {
    handlePermissionReplied(baseUrl, props);
    return;
  }
  if (type === 'form.created') {
    handleFormCreated(baseUrl, readObjectRecord(props.form) ?? props);
    return;
  }
  if (type === 'form.replied' || type === 'form.cancelled') {
    const form = readObjectRecord(props.form);
    handleFormSettled(
      readOptionalString(props.formID) ?? readOptionalString(form?.id) ?? readOptionalString(props.id) ?? '',
    );
    return;
  }

  if (type === 'session.created' || type === 'session.updated') {
    const info = readObjectRecord(props.info);
    const childId = readOptionalString(props.sessionID) ?? readOptionalString(info?.id);
    const parentId = readOptionalString(props.parentID) ?? readOptionalString(info?.parentID);
    if (childId && parentId) childToParent.set(childId, parentId);
  }

  const providerSessionId = String(props.sessionID ?? '');
  if (!providerSessionId) {
    return;
  }
  const appSessionId = providerToApp.get(providerSessionId);
  const run = appSessionId ? activeRuns.get(appSessionId) : undefined;
  if (!run) {
    return;
  }
  run.lastEventAt = Date.now();
  const sessionId = run.providerSessionId ?? providerSessionId;
  const messageId = readOptionalString(props.assistantMessageID) ?? '';
  const ordinal = Number(props.ordinal) || 0;

  switch (type) {
    case 'session.execution.started':
      markTurnLive(run);
      return;

    case 'session.step.started':
      markTurnLive(run);
      run.writer.send(createNormalizedMessage({
        kind: 'status',
        text: 'Thinking',
        canInterrupt: true,
        sessionId,
        provider: PROVIDER,
      }));
      return;

    case 'session.text.started':
    case 'session.reasoning.started': {
      markTurnLive(run);
      const kind = type === 'session.text.started' ? 'text' : 'reasoning';
      const key = livePartKey(messageId, kind, ordinal);
      if (run.livePartId !== key) {
        closeLivePart(run, sessionId);
        run.livePartId = key;
      }
      run.partTypes.set(key, kind);
      return;
    }

    // Token-level streaming — forwarding deltas makes the reply grow live
    // instead of landing as one snapshot when the part ends.
    case 'session.text.delta':
    case 'session.reasoning.delta': {
      const delta = typeof props.delta === 'string' ? props.delta : '';
      if (!delta) {
        return;
      }
      const kind = type === 'session.text.delta' ? 'text' : 'reasoning';
      const key = livePartKey(messageId, kind, ordinal);
      if (run.livePartId !== key) {
        closeLivePart(run, sessionId);
        run.livePartId = key;
      }
      run.streamedParts.add(key);
      run.writer.send(createNormalizedMessage({
        kind: kind === 'reasoning' ? 'thought_delta' : 'stream_delta',
        content: delta,
        sessionId,
        provider: PROVIDER,
      }));
      return;
    }

    case 'session.text.ended':
    case 'session.reasoning.ended': {
      const kind = type === 'session.text.ended' ? 'text' : 'reasoning';
      const key = livePartKey(messageId, kind, ordinal);
      // A part whose deltas already streamed must not also land as a
      // snapshot — the client would render the live row plus the snapshot.
      if (run.streamedParts.has(key)) {
        if (run.livePartId === key) {
          closeLivePart(run, sessionId);
        }
        return;
      }
      const text = typeof props.text === 'string' ? props.text : '';
      if (!text.trim()) {
        return;
      }
      closeLivePart(run, sessionId);
      run.writer.send(createNormalizedMessage({
        id: key,
        kind: kind === 'text' ? 'text' : 'thinking',
        ...(kind === 'text' ? { role: 'assistant' } : {}),
        content: text,
        sessionId,
        provider: PROVIDER,
      }));
      return;
    }

    case 'session.tool.input.started': {
      markTurnLive(run);
      closeLivePart(run, sessionId);
      const callId = readOptionalString(props.id);
      const name = readOptionalString(props.name);
      if (callId && name) {
        run.partTypes.set(`tool:${callId}`, name);
      }
      return;
    }

    case 'session.tool.called': {
      closeLivePart(run, sessionId);
      const callId = readOptionalString(props.id) ?? '';
      if (!callId) {
        return;
      }
      const rawName = readOptionalString(props.name) ?? run.partTypes.get(`tool:${callId}`) ?? 'Tool';
      const toolName = rawName.toLowerCase() === 'task' ? 'Task' : rawName;
      run.writer.send(createNormalizedMessage({
        id: toolMessageId(messageId, callId),
        kind: 'tool_use',
        toolName,
        toolInput: readObjectRecord(props.input) ?? {},
        toolId: callId,
        sessionId,
        provider: PROVIDER,
      }));
      return;
    }

    case 'session.tool.success':
    case 'session.tool.failed': {
      const callId = readOptionalString(props.id) ?? '';
      if (!callId) {
        return;
      }
      const isError = type === 'session.tool.failed';
      const content = formatCliToolResult(
        joinOpenCodeToolContent(props.content),
        isError ? (props.error ?? 'Tool failed') : undefined,
        readObjectRecord(props.metadata) ?? undefined,
      );
      run.writer.send(createNormalizedMessage({
        id: `${toolMessageId(messageId, callId)}_result`,
        kind: 'tool_result',
        toolId: callId,
        content,
        isError,
        sessionId,
        provider: PROVIDER,
      }));
      return;
    }

    case 'session.step.ended':
      closeLivePart(run, sessionId);
      return;

    case 'session.retry.scheduled': {
      // The provider call failed and OpenCode is backing off: surface the
      // attempt so the pane shows progress, and track the streak so a wedged
      // retry loop is aborted instead of spinning forever. (adoptLiveStatus,
      // not markTurnLive — the latter would reset the very streak this
      // event feeds.)
      adoptLiveStatus(run);
      const attempt = Number(props.attempt) || 0;
      const reason = extractOpenCodeErrorMessage(props.error) ?? readOptionalString(props.message);
      const detail = reason ? `Provider error — retrying (${reason})` : 'Provider error — retrying';
      if (run.retrySince === 0) {
        run.writer.send(createNormalizedMessage({
          kind: 'status',
          text: `OpenCode is retrying: ${detail}`,
          notice: true,
          sessionId,
          provider: PROVIDER,
        }));
      }
      run.writer.send(createNormalizedMessage({
        kind: 'status',
        text: attempt > 0 ? `${detail} — retry ${attempt}` : detail,
        canInterrupt: true,
        sessionId,
        provider: PROVIDER,
      }));
      trackRetryStatus(run, attempt);
      return;
    }

    case 'session.execution.failed':
    case 'session.error':
      // An error predating our prompt belongs to the previous turn; the
      // retry-stall watchdog's own abort reports through trackRetryStatus.
      if (run.promptPosted && !run.recovering && !run.retryStallAborted) {
        failRun(run, new Error(extractOpenCodeErrorMessage(props.error) ?? 'OpenCode session error'));
      }
      return;

    case 'session.execution.interrupted':
      if (run.aborted) {
        run.resolve();
        return;
      }
      // Stopped from another client — the turn is over, not broken.
      if (run.promptPosted) {
        finishRun(run);
      }
      return;

    case 'session.execution.succeeded':
    case 'session.idle':
      settleIdle(run);
      return;

    default:
      return;
  }
}

/**
 * A terminal idle/succeeded is accepted only for a run whose own prompt went
 * out AND whose turn was seen live. Otherwise it is a stale event (the
 * abort's trailing idle, replayed state) — finishing now would resolve the
 * run while setup still posts the prompt, orphaning the whole turn.
 */
function settleIdle(run: ActiveRun): void {
  if (run.recovering) {
    return;
  }
  if (run.promptPosted && run.sawBusy) {
    finishRun(run);
    return;
  }
  // Fallback for a turn that never emitted a live event: the idle is
  // debated by settleStaleIdle — verified against live status and the
  // run's own event traffic instead of blindly accepted after the grace.
  if (run.promptPosted && !run.aborted && !run.completeSent && !run.idleTimer) {
    run.idleSeenAt = run.lastEventAt;
    run.idleTimer = setTimeout(() => {
      void settleStaleIdle(run);
    }, STALE_IDLE_GRACE_MS);
    run.idleTimer.unref?.();
  }
}

/**
 * Bounded re-polls for runs missing from `/session/status` after a reconnect.
 *
 * Some OpenCode builds omit finished sessions from the status map entirely —
 * a run that ended during the SSE outage then has no `idle` to observe, and a
 * single poll right after the reconnect can also race a status update. Absence
 * is therefore confirmed over several spaced polls before it is read as the
 * terminal signal.
 */
const STATUS_RESYNC_MISSING_MAX_POLLS = 3;
const STATUS_RESYNC_MISSING_DELAY_MS = 1000;

/**
 * The live status of one run's provider session, straight from
 * `/session/status`: the status string, `null` when the session is absent
 * from the map, `undefined` when the fetch itself failed (transient —
 * callers must not draw conclusions from it).
 */
async function fetchSessionStatusType(run: ActiveRun): Promise<string | null | undefined> {
  if (!run.baseUrl || !run.providerSessionId) {
    return undefined;
  }
  try {
    const { status, data } = await apiRequest(run.baseUrl, '/session/active');
    const statuses = readObjectRecord(readObjectRecord(data)?.data);
    if (status >= 400 || !statuses) {
      return undefined;
    }
    const entry = readObjectRecord(statuses[run.providerSessionId]);
    return readOptionalString(entry?.type) ?? null;
  } catch {
    return undefined;
  }
}

/**
 * Marks a run as live from an observed non-idle status. A session that
 * reports busy/retry while our prompt is posted is our turn — OpenCode runs
 * one turn per session — so the status poll can stand in for a missed SSE
 * busy, including clearing a pending stale-idle debate.
 */
function adoptLiveStatus(run: ActiveRun): void {
  run.sawBusy = true;
  if (run.idleTimer) {
    clearTimeout(run.idleTimer);
    run.idleTimer = undefined;
  }
}

/** Any non-retry status ends the streak — the turn is progressing again. */
function clearRetryStatus(run: ActiveRun): void {
  run.retrySince = 0;
  run.retryAttempt = 0;
}

/**
 * Feeds one observed `retry` status (SSE event or status-map poll). A rising
 * attempt counter resets the streak clock — the retry loop is alive and
 * making progress. An attempt that does not advance within the stall budget
 * means the provider request hung past its own timeout: abort the turn on
 * the OpenCode server and fail the run instead of letting it sit on
 * "retry N" forever.
 */
function trackRetryStatus(run: ActiveRun, attempt: number): void {
  if (run.aborted || run.completeSent || run.retryStallAborted) {
    return;
  }
  if (run.retrySince === 0 || attempt > run.retryAttempt) {
    run.retryAttempt = attempt;
    run.retrySince = Date.now();
    return;
  }
  const stallMs = Number(process.env.OPENCODE_RETRY_STALL_MS) || RETRY_STALL_TIMEOUT_MS;
  if (Date.now() - run.retrySince < stallMs) {
    return;
  }
  run.retryStallAborted = true;
  console.warn(`[OpenCode] Session ${run.providerSessionId} stuck on retry attempt ${attempt} for over ${Math.round(stallMs / 1000)}s — aborting the wedged turn.`);
  void (async () => {
    if (run.baseUrl && run.providerSessionId) {
      await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/interrupt`, {
        method: 'POST',
        query: { directory: run.directory },
      }).catch((error) => {
        console.warn('[OpenCode] Abort of a retry-stalled session failed:', error instanceof Error ? error.message : String(error));
      });
    }
    failRun(run, new Error(`Provider retry stalled after ${Math.round(stallMs / 1000)}s on attempt ${attempt} — the wedged turn was aborted. Send the prompt again or pick another provider/model.`));
  })();
}

/**
 * Decides whether a `session.idle` that arrived without a preceding busy is
 * terminal. Instead of trusting the grace window alone, this re-checks:
 *   - event traffic for the run since the idle (a live turn keeps producing)
 *   - the run's age (a just-posted prompt may legitimately sit queued)
 *   - a fresh `/session/status` read (authoritative busy/idle)
 * Only a confirmed idle-or-absent session settles the run; anything else
 * leaves it to the turn's own events or the next reconcile pass.
 */
async function settleStaleIdle(run: ActiveRun): Promise<void> {
  run.idleTimer = undefined;
  if (run.aborted || run.completeSent || run.sawBusy) {
    return;
  }
  if (run.lastEventAt > (run.idleSeenAt ?? 0)) {
    return;
  }
  const ageMs = Date.now() - run.promptPostedAt;
  if (ageMs < STALE_IDLE_MIN_TURN_AGE_MS) {
    run.idleTimer = setTimeout(() => {
      void settleStaleIdle(run);
    }, STALE_IDLE_MIN_TURN_AGE_MS - ageMs);
    run.idleTimer.unref?.();
    return;
  }
  const live = await fetchSessionStatusType(run);
  if (run.aborted || run.completeSent || run.sawBusy) {
    return;
  }
  if (live === undefined) {
    return;
  }
  if (live !== null && live !== 'idle') {
    adoptLiveStatus(run);
    return;
  }
  finishRun(run);
}

/**
 * Status poll for prompt-posted runs — fired right after the SSE stream
 * (re)connects and periodically while runs are live. Events emitted during
 * an outage are gone for good — including a terminal `session.idle` — so a
 * turn that finished mid-gap would hang forever without this. An explicit
 * `idle` settles a run; a run missing from the map is re-polled (some
 * OpenCode builds omit finished sessions entirely) and settled once its
 * absence is confirmed; a busy/retry entry marks the turn live.
 */
export async function reconcileActiveRuns(baseUrl: string): Promise<void> {
  const runsHere = [...activeRuns.values()].filter(
    (run) => run.baseUrl === baseUrl && run.promptPosted && !run.completeSent,
  );
  if (runsHere.length === 0) {
    return;
  }

  await pollRunStatuses(baseUrl, runsHere, 0);
}

async function pollRunStatuses(baseUrl: string, runs: ActiveRun[], poll: number): Promise<void> {
  const missing: ActiveRun[] = [];
  try {
    // `GET /api/session/active` lists only sessions with a running turn —
    // a finished session is simply absent.
    const { status, data } = await apiRequest(baseUrl, '/session/active');
    const statuses = readObjectRecord(readObjectRecord(data)?.data);
    if (status >= 400 || !statuses) {
      return;
    }
    for (const run of runs) {
      if (run.completeSent) {
        continue;
      }
      const entry = run.providerSessionId
        ? readObjectRecord(statuses[run.providerSessionId])
        : null;
      const statusType = readOptionalString(entry?.type);
      if (statusType === 'idle') {
        // Routed through the normal event path so the stale-idle guards
        // (promptPosted / sawBusy / grace timer) still apply.
        dispatchServerEvent(baseUrl, {
          type: 'session.idle',
          properties: { sessionID: run.providerSessionId },
        });
      } else if (entry) {
        // busy/retry/anything non-idle: the turn is alive — adopt it so a
        // missed SSE busy (or a pending stale-idle debate) cannot kill it.
        adoptLiveStatus(run);
        // The reconcile cadence doubles as the retry-stall watchdog — an
        // attempt stuck past the budget aborts the wedged turn instead of
        // waiting on a dead provider call forever.
        if (statusType === 'retry') {
          trackRetryStatus(run, Number(entry.attempt) || 0);
        } else {
          clearRetryStatus(run);
        }
      } else {
        missing.push(run);
      }
    }
  } catch {
    // Best effort — the next reconnect or reconcile cycle retries the resync.
    return;
  }

  if (missing.length === 0) {
    return;
  }
  if (poll >= STATUS_RESYNC_MISSING_MAX_POLLS) {
    // Absence confirmed across spaced polls: builds that omit finished
    // sessions never report `idle`, so the confirmed absence IS the terminal
    // signal. The synthetic idle still passes the stale-idle guards.
    try {
      for (const run of missing) {
        if (!run.completeSent) {
          dispatchServerEvent(baseUrl, {
            type: 'session.idle',
            properties: { sessionID: run.providerSessionId },
          });
        }
      }
    } catch (error) {
      console.error('[OpenCode] Status-resync settle failed:', error);
    }
    return;
  }
  setTimeout(() => {
    void pollRunStatuses(baseUrl, missing, poll + 1);
  }, STATUS_RESYNC_MISSING_DELAY_MS).unref?.();
}

/**
 * Opens (once) the server-sent event stream for a serve instance and routes
 * events to active runs. Reconnects with backoff while runs are active; a
 * server that stays unreachable fails its runs instead of hanging forever.
 *
 * Two independent safety nets sit on top of plain reconnects:
 * - a stall watchdog aborts a connection that goes silent past
 *   SSE_STALL_TIMEOUT_MS (half-open TCP reads hang forever otherwise);
 * - a periodic /session/status reconcile settles runs whose terminal event
 *   was missed with the stream still up, and adopts live turns whose busy
 *   event was missed.
 */
/**
 * Points a live stream at a replacement serve instance: every run and pending
 * permission bound to the dead port follows it, and the stream re-registers
 * under the new URL so later runs attach here instead of opening a second
 * stream to the same server.
 */
function migrateEventStream(state: EventStreamState, fromUrl: string, toUrl: string): void {
  for (const run of activeRuns.values()) {
    if (run.baseUrl === fromUrl) {
      run.baseUrl = toUrl;
    }
  }
  for (const pending of pendingPermissions.values()) {
    if (pending.baseUrl === fromUrl) {
      pending.baseUrl = toUrl;
    }
  }
  if (eventStreams.get(fromUrl) === state) {
    eventStreams.delete(fromUrl);
  }
  eventStreams.set(toUrl, state);
  state.retryCount = 0;
  // The replacement owns a fresh event log — forwarding the old server's
  // cursor would at best be ignored and at worst skip live events.
  state.lastEventId = null;
}

function ensureEventStream(baseUrl: string): Promise<void> {
  const existing = eventStreams.get(baseUrl);
  if (existing?.alive) {
    return existing.connected;
  }

  let markConnected!: () => void;
  const connected = new Promise<void>((resolve) => {
    markConnected = resolve;
  });
  const state: EventStreamState = {
    alive: true,
    controller: new AbortController(),
    retryCount: 0,
    failovers: 0,
    connected,
    markConnected,
    lastEventId: null,
    lastActivityAt: Date.now(),
  };
  eventStreams.set(baseUrl, state);

  // The serve process can be replaced mid-stream (crash or respawn): the
  // port in `baseUrl` is dead forever then, so the loop follows the current
  // server URL instead of the original one.
  let currentBaseUrl = baseUrl;

  // Per-server reconcile loop: lives across SSE reconnects and keeps running
  // while the stream is down, so a turn that ends inside an outage settles
  // on the next poll instead of waiting for the stream to come back.
  const reconcileTimer = setInterval(() => {
    void reconcileActiveRuns(currentBaseUrl);
  }, STATUS_RECONCILE_INTERVAL_MS);
  reconcileTimer.unref?.();

  void (async () => {
    while (state.alive) {
      // Per-attempt abort: the stall watchdog cancels only this connection;
      // state.controller still means "stop forever".
      const attempt = new AbortController();
      const onShutdown = () => attempt.abort();
      state.controller.signal.addEventListener('abort', onShutdown, { once: true });
      let stallWatchdog: ReturnType<typeof setInterval> | undefined;
      try {
        const response = await fetch(`${currentBaseUrl}/api/event`, {
          headers: {
            ...serverAuthHeaders(currentBaseUrl),
            Accept: 'text/event-stream',
            // Server ignores this today; if a future build replays from the
            // durable event log, the cursor makes reconnects lossless.
            ...(state.lastEventId ? { 'Last-Event-ID': state.lastEventId } : {}),
          },
          signal: attempt.signal,
        });
        if (!response.ok || !response.body) {
          throw new Error(`event stream returned ${response.status}`);
        }
        state.markConnected();
        // Each successful (re)connect earns a fresh retry budget — without
        // the reset, a long-lived server accumulates disconnects across
        // turns until SSE_MAX_RECONNECTS kills healthy runs.
        state.retryCount = 0;
        state.failovers = 0;
        state.lastActivityAt = Date.now();
        void reconcileActiveRuns(currentBaseUrl);

        // A silent stream with live runs behind it is indistinguishable from
        // a healthy idle one without heartbeats — abort and reconnect. The
        // check cadence scales with the stall budget so short test timeouts
        // are still observed promptly.
        const stallTimeoutMs = Number(process.env.OPENCODE_SSE_STALL_MS) || SSE_STALL_TIMEOUT_MS;
        const stallCheckMs = Math.min(SSE_WATCHDOG_INTERVAL_MS, Math.max(50, Math.floor(stallTimeoutMs / 3)));
        stallWatchdog = setInterval(() => {
          if (Date.now() - state.lastActivityAt > stallTimeoutMs) {
            console.warn(`[OpenCode] Event stream on ${currentBaseUrl} stalled (no events for ${stallTimeoutMs}ms) — reconnecting`);
            attempt.abort();
          }
        }, stallCheckMs);
        stallWatchdog.unref?.();

        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';
        while (true) {
          const { done, value } = await reader.read();
          if (done) {
            break;
          }
          state.lastActivityAt = Date.now();
          buffer += decoder.decode(value, { stream: true });
          let boundary = buffer.indexOf('\n\n');
          while (boundary >= 0) {
            const chunk = buffer.slice(0, boundary);
            buffer = buffer.slice(boundary + 2);
            let frameId: string | null = null;
            for (const line of chunk.split('\n')) {
              if (line.startsWith('id:')) {
                frameId = line.slice(3).trim() || frameId;
                continue;
              }
              if (!line.startsWith('data:')) {
                continue;
              }
              try {
                const parsed = JSON.parse(line.slice(5)) as AnyRecord;
                if (typeof parsed.id === 'string' && parsed.id) {
                  state.lastEventId = parsed.id;
                }
                dispatchServerEvent(currentBaseUrl, parsed);
              } catch (error) {
                console.error('[OpenCode] Failed to dispatch server event:', error);
              }
            }
            if (frameId) {
              state.lastEventId = frameId;
            }
            boundary = buffer.indexOf('\n\n');
          }
        }
        throw new Error('event stream closed');
      } catch (error) {
        if (state.controller.signal.aborted) {
          break;
        }
        const runsHere = [...activeRuns.values()].filter((run) => run.baseUrl === currentBaseUrl);
        // A respawned serve lands on a new port — hop to it at once instead
        // of burning the retry budget on a port that never answers again.
        const sample = runsHere[0];
        const fresh = sample ? getServer(sample.directory, sample.envOverrides) : undefined;
        if (fresh && fresh.baseUrl !== currentBaseUrl) {
          migrateEventStream(state, currentBaseUrl, fresh.baseUrl);
          currentBaseUrl = fresh.baseUrl;
          continue;
        }
        state.retryCount += 1;
        if (state.retryCount > SSE_MAX_RECONNECTS || runsHere.length === 0) {
          // Last resort before failing every run: spawn (or share the pending
          // spawn of) a replacement server. Provider sessions persist in
          // OpenCode's storage, so re-attached runs observe the continued
          // turn through the status reconcile instead of dying.
          const next = sample && state.failovers < SSE_MAX_FAILOVERS
            ? await ensureServer(sample.directory, sample.envOverrides).catch(() => null)
            : null;
          if (next && next.baseUrl !== currentBaseUrl) {
            state.failovers += 1;
            migrateEventStream(state, currentBaseUrl, next.baseUrl);
            currentBaseUrl = next.baseUrl;
            continue;
          }
          for (const run of runsHere) {
            failRun(run, new Error('Lost connection to the OpenCode server'));
          }
          break;
        }
        // Linear backoff: a server that is merely busy (or rate-limiting the
        // /event endpoint) gets room to recover instead of a tight retry loop.
        await new Promise((resolve) => setTimeout(resolve, SSE_RECONNECT_DELAY_MS * state.retryCount));
      } finally {
        state.controller.signal.removeEventListener('abort', onShutdown);
        if (stallWatchdog) {
          clearInterval(stallWatchdog);
        }
      }
    }
    state.alive = false;
    clearInterval(reconcileTimer);
    if (eventStreams.get(currentBaseUrl) === state) {
      eventStreams.delete(currentBaseUrl);
    }
  })();

  return connected;
}

/**
 * Images go to OpenCode as prompt file attachments (`{ uri, name }`; it reads
 * `file://` images and inlines them for the model). The `<images_input>` tag
 * stays in the text only so reloaded history can rebuild the attachment chips.
 */
function buildImageFileParts(images: unknown, cwd: string): AnyRecord[] {
  const parts: AnyRecord[] = [];
  for (const descriptor of normalizeImageDescriptors(images)) {
    const resolvedPath = resolveImageAbsolutePath(cwd, descriptor.path);
    // Same trust boundary as the Claude/Codex builders: OpenCode reads it.
    if (!isAllowedImageSourcePath(resolvedPath, cwd)) {
      console.warn(`[OpenCode] Refusing to attach image outside allowed roots: ${descriptor.path}`);
      continue;
    }
    parts.push({
      uri: pathToFileURL(resolvedPath).href,
      name: descriptor.name ?? path.basename(resolvedPath),
      description: resolveImageMediaType(descriptor) ?? undefined,
    });
  }
  return parts;
}

function splitModelRef(model: string | undefined): { providerID?: string; modelID?: string } {
  if (!model) {
    return {};
  }
  const slash = model.indexOf('/');
  if (slash <= 0) {
    return { modelID: model };
  }
  return { providerID: model.slice(0, slash), modelID: model.slice(slash + 1) };
}

async function createProviderSession(
  baseUrl: string,
  directory: string,
  title: string | undefined,
): Promise<string> {
  const { status, data } = await apiRequest(baseUrl, '/session', {
    method: 'POST',
    body: { title: title || 'DDAgent session', location: { directory } },
  });
  const id = readObjectRecord(readObjectRecord(data)?.data)?.id;
  if (status >= 400 || typeof id !== 'string' || !id) {
    throw new Error(`Failed to create OpenCode session (HTTP ${status})`);
  }
  return id;
}

async function providerSessionExists(
  baseUrl: string,
  directory: string,
  providerSessionId: string,
): Promise<boolean> {
  try {
    const { status, data } = await apiRequest(baseUrl, `/session/${providerSessionId}`, {
      query: { directory },
    });
    if (status >= 400) {
      return false;
    }
    // `opencode serve` is global: the location query only picks the request
    // context, so a session created elsewhere still returns 200. Its stored
    // location decides where prompts actually run, and a repointed workspace
    // must start a fresh provider session instead of resuming the old
    // directory's session.
    const info = readObjectRecord(readObjectRecord(data)?.data);
    const sessionDirectory = readObjectRecord(info?.location)?.directory ?? info?.directory;
    return typeof sessionDirectory !== 'string'
      || path.resolve(sessionDirectory) === path.resolve(directory);
  } catch {
    return false;
  }
}

// The notification helpers live in an untyped .js module whose `= null`
// defaults infer `null` for session fields — loosen them for this adapter.
const notifyFailed = notifyRunFailed as (args: AnyRecord) => void;
const notifyStopped = notifyRunStopped as (args: AnyRecord) => void;

function notifyTerminalState(run: ActiveRun, error: Error | null): void {
  if (error) {
    notifyFailed({
      userId: run.writer?.userId ?? null,
      provider: PROVIDER,
      sessionId: run.appSessionId,
      sessionName: run.sessionSummary,
      error: error.message,
    });
    return;
  }
  notifyStopped({
    userId: run.writer?.userId ?? null,
    provider: PROVIDER,
    sessionId: run.appSessionId,
    sessionName: run.sessionSummary,
    stopReason: 'completed',
  });
}

function cleanupRun(run: ActiveRun): void {
  if (run.idleTimer) {
    clearTimeout(run.idleTimer);
    run.idleTimer = undefined;
  }
  // A newer run for the same session may already have replaced this one —
  // never evict a run that isn't ours.
  if (activeRuns.get(run.appSessionId) === run) {
    activeRuns.delete(run.appSessionId);
  } else {
    return;
  }
  if (run.providerSessionId && providerToApp.get(run.providerSessionId) === run.appSessionId) {
    providerToApp.delete(run.providerSessionId);
  }
  for (const [childId, parentId] of childToParent) {
    if (parentId === run.providerSessionId) childToParent.delete(childId);
  }
  // The live mode map is keyed per session; the next run re-seeds it from
  // the send's options, so the entry must not linger between runs.
  sessionModes.delete(run.appSessionId);
  for (const [requestId, pending] of pendingPermissions) {
    if (pending.appSessionId === run.appSessionId) {
      pendingPermissions.delete(requestId);
      // Leftover asks die with the run — tell clients so they don't keep a
      // zombie prompt rendered (or resurrect it on replay).
      run.writer?.send?.(createNormalizedMessage({
        kind: 'permission_cancelled',
        requestId,
        reason: 'run-settled',
        sessionId: pending.providerSessionId,
        provider: PROVIDER,
      }));
    }
  }
}

/**
 * Drives one OpenCode turn through the project's `opencode serve` instance:
 * ensures the server, resolves/creates the provider session, posts the prompt
 * and settles on the session's terminal SSE event. Live controls (permission
 * replies, abort, mode switches) work because the server stays reachable for
 * the whole run.
 */
// Consumed by provider runtime services and lifecycle tests.
export async function spawnOpenCode(
  command: string,
  options: AnyRecord = {},
  ws: ProviderRuntimeWriter,
  context: ProviderRuntimeContext,
): Promise<void> {
  const {
    sessionId,
    projectPath,
    cwd,
    model,
    effort,
    sessionSummary,
    images,
    files,
    permissionMode,
  } = options as AnyRecord;
  const providerSessionId = context.resolveProviderSessionId(sessionId);
  const workingDir = cwd || projectPath || process.cwd();
  const appSessionId = sessionId || `opencode-${Date.now()}`;
  const runSummary = typeof sessionSummary === 'string' ? sessionSummary : undefined;
  // Multi-account: env overrides spawn (and cache-key) a dedicated serve
  // instance per credential set; stored on the run so a server replacement
  // can be looked up for failover.
  const envOverrides =
    options.env && typeof options.env === 'object'
      ? (options.env as Record<string, string>)
      : undefined;

  let runRef!: ActiveRun;
  const done = new Promise<void>((resolve, reject) => {
    const run: ActiveRun = {
      appSessionId,
      providerSessionId,
      directory: workingDir,
      baseUrl: null,
      writer: ws,
      context,
      sessionSummary: runSummary,
      aborted: false,
      completeSent: false,
      promptPosted: false,
      promptPostedAt: 0,
      lastEventAt: 0,
      poisonRetried: false,
      recovering: false,
      retrySince: 0,
      retryAttempt: 0,
      retryStallAborted: false,
      sawBusy: false,
      partTypes: new Map(),
      streamedParts: new Set(),
      livePartId: null,
      editedMessageIds: new Set(),
      envOverrides,
      resolve,
      reject,
    };
    runRef = run;

    activeRuns.set(appSessionId, run);
    sessionModes.set(appSessionId, typeof permissionMode === 'string' ? permissionMode : 'default');
    if (providerSessionId) {
      providerToApp.set(providerSessionId, appSessionId);
    }

    void (async () => {
      try {
        const server = await ensureServer(workingDir, envOverrides);
        run.baseUrl = server.baseUrl;
        // The prompt must not go out before the event stream is connected —
        // events emitted in between (a fast permission.asked, an early idle)
        // would be lost and stall the run forever. A dead /event endpoint
        // still lets the prompt proceed; the retry loop fails the run if the
        // stream never comes up.
        await Promise.race([
          ensureEventStream(server.baseUrl),
          new Promise<void>((resolve) => setTimeout(resolve, API_TIMEOUT_MS)),
        ]);

        if (run.providerSessionId) {
          const exists = await providerSessionExists(server.baseUrl, workingDir, run.providerSessionId);
          if (!exists) {
            if (providerToApp.get(run.providerSessionId) === appSessionId) {
              providerToApp.delete(run.providerSessionId);
            }
            run.providerSessionId = null;
          }
        }

        if (!run.providerSessionId) {
          const createdId = await createProviderSession(server.baseUrl, workingDir, runSummary);
          run.providerSessionId = createdId;
          providerToApp.set(createdId, appSessionId);
          ws.setSessionId?.(createdId);
          ws.send(createNormalizedMessage({
            kind: 'session_created',
            newSessionId: createdId,
            sessionId: createdId,
            provider: PROVIDER,
          }));
        }

        const resolvedModel = await context.resolveResumeModel(sessionId, model);
        const effortModels = await context.getProviderModels().catch((error: unknown) => {
          console.warn('[OpenCode] Unable to load provider models for effort validation:', error);
          return null;
        });
        const resolvedEffort = resolveOpenCodeEffort(resolvedModel, effort, effortModels);
        const behavior = resolveOpenCodePermissionBehavior(typeof permissionMode === 'string' ? permissionMode : undefined);

        const promptText = appendFilesInputTag(
          appendImagesInputTag(typeof command === 'string' ? command.trim() : '', images),
          files,
        );
        const hasAttachments =
          normalizeAttachmentDescriptors(images).length > 0
          || normalizeAttachmentDescriptors(files).length > 0;

        if (!promptText.trim() && !hasAttachments) {
          // A run with no prompt and no attachments has nothing to send —
          // complete immediately after session setup, like the old CLI path.
          finishRun(run);
          return;
        }

        const { providerID, modelID } = splitModelRef(resolvedModel);
        if (modelID && !providerID) {
          throw new Error(`OpenCode model "${resolvedModel}" is not a provider/model id (e.g. opencode/big-pickle).`);
        }

        if (run.aborted || run.completeSent) {
          // The run settled while the session was being set up — posting the
          // prompt now would start a turn with no listener attached.
          run.resolve();
          return;
        }

        // OpenCode 2 keeps model and agent on the session, not the prompt.
        if (modelID) {
          const modelResponse = await apiRequest(server.baseUrl, `/session/${run.providerSessionId}/model`, {
            method: 'POST',
            query: { directory: workingDir },
            body: { model: { id: modelID, providerID, ...(resolvedEffort ? { variant: resolvedEffort } : {}) } },
          });
          if (modelResponse.status >= 400) {
            throw new Error(`OpenCode rejected model "${resolvedModel}" (HTTP ${modelResponse.status}): ${extractOpenCodeErrorMessage(modelResponse.data) ?? JSON.stringify(modelResponse.data)}`);
          }
        }
        const agentResponse = await apiRequest(server.baseUrl, `/session/${run.providerSessionId}/agent`, {
          method: 'POST',
          query: { directory: workingDir },
          body: { agent: behavior.agent ?? 'build' },
        });
        if (agentResponse.status >= 400) {
          console.warn(`[OpenCode] Agent select failed (HTTP ${agentResponse.status}) — continuing with the session default.`);
        }

        // Set before the POST resolves: terminal events arriving while the
        // request is in flight already belong to this run.
        run.promptPosted = true;
        run.promptPostedAt = Date.now();
        const promptFiles = buildImageFileParts(images, workingDir);
        const promptBody: AnyRecord = {
          text: promptText,
          ...(promptFiles.length ? { files: promptFiles } : {}),
        };
        run.promptBody = promptBody;
        const { status, data } = await apiRequest(
          server.baseUrl,
          `/session/${run.providerSessionId}/prompt`,
          {
            method: 'POST',
            query: { directory: workingDir },
            body: promptBody,
          },
        );

        if (status >= 400) {
          throw new Error(`OpenCode prompt failed (HTTP ${status}): ${extractOpenCodeErrorMessage(data) ?? JSON.stringify(data)}`);
        }

        if (run.aborted) {
          run.resolve();
        }
        // Otherwise the SSE event stream settles the run on
        // session.execution.succeeded / failed.
      } catch (error) {
        if (!run.aborted) {
          const installed = await context.isProviderInstalled().catch(() => true);
          const finalError = error instanceof Error ? error : new Error(String(error));
          if (!installed) {
            failRun(run, new Error('OpenCode CLI is not installed. Install it from https://opencode.ai/docs/'));
          } else {
            failRun(run, finalError);
          }
        } else {
          run.resolve();
        }
      }
    })();
  });

  // Run bookkeeping stays live until the run settles (session.idle, failure
  // or abort) — not until the async setup above returns — because SSE events
  // route through these maps for the whole response.
  void done.then(() => cleanupRun(runRef), () => cleanupRun(runRef));
  return done;
}

/**
 * Posts a user message into the session's running turn. OpenCode appends a
 * prompt sent to a busy session to the conversation and its agent loop picks
 * it up at the next step, so the live run streams the rest and still settles
 * on the single `session.idle` at the end. Only a turn that is visibly busy
 * qualifies — before that, or once it settled, the message goes out as the
 * next turn instead.
 */
// Consumed by the provider registry (runtime.steer) for the queue's "send now".
export async function steerOpenCodeSession(sessionId: string, content: string, options: AnyRecord): Promise<boolean> {
  const run = activeRuns.get(sessionId);
  if (
    !run
    || !run.sawBusy
    || run.aborted
    || run.completeSent
    || run.recovering
    || !run.baseUrl
    || !run.providerSessionId
    || !run.promptBody
  ) {
    return false;
  }

  const text = appendFilesInputTag(appendImagesInputTag(content.trim(), options.images), options.files);
  // Model and agent live on the session, so the steer only carries the text;
  // `delivery: steer` hands it to the running turn (the default for a prompt
  // on a busy session).
  const files = buildImageFileParts(options.images, run.directory);
  const { status } = await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/prompt`, {
    method: 'POST',
    query: { directory: run.directory },
    body: { text, ...(files.length ? { files } : {}), delivery: 'steer' },
  });
  if (status >= 400) {
    return false;
  }
  // OpenCode's own echo of a user part is filtered from the live stream (the
  // client normally shows its optimistic bubble); a queued message has none.
  closeLivePart(run, run.providerSessionId);
  run.writer.send(createNormalizedMessage({
    kind: 'text',
    role: 'user',
    content: content.trim(),
    sessionId: run.providerSessionId,
    provider: PROVIDER,
  }));
  return true;
}

// Consumed by provider runtime services and lifecycle tests.
export async function abortOpenCodeSession(sessionId: string): Promise<boolean> {
  const run = activeRuns.get(sessionId);
  if (!run) {
    return false;
  }

  run.aborted = true;
  try {
    if (run.baseUrl && run.providerSessionId) {
      const response = await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/interrupt`, {
        method: 'POST',
        query: { directory: run.directory },
      });
      // `{ interrupted: false }` means no running turn was found — the same
      // refusal the 1.x endpoint reported as a bare `false`.
      const interrupted = readObjectRecord(response.data)?.interrupted;
      if (response.status < 200 || response.status >= 300 || response.data === false || interrupted === false) {
        throw new Error(`OpenCode refused abort (HTTP ${response.status})`);
      }
    }
  } catch (error) {
    run.aborted = false;
    console.warn('[OpenCode] Abort request failed:', error instanceof Error ? error.message : String(error));
    return false;
  }
  if (!run.completeSent) {
    run.resolve();
  }
  return true;
}

// Consumed by provider runtime services and lifecycle tests.
export function isOpenCodeSessionActive(sessionId: string): boolean {
  return activeRuns.has(sessionId);
}

// Consumed by provider runtime services and lifecycle tests.
export function getActiveOpenCodeSessions(): string[] {
  return Array.from(activeRuns.keys());
}

/**
 * Live permission-mode update consumed by the websocket gateway
 * (`chat.set-permission-mode`). Updates the mode the permission watcher reads
 * on the next `permission.asked`; switching to bypass also auto-approves asks
 * already pending for the session, which is what makes the toggle take effect
 * mid-response instead of on the next message.
 */
export function setOpenCodePermissionMode(sessionId: string, mode: string): void {
  sessionModes.set(sessionId, mode);

  if (mode !== 'bypassPermissions') {
    return;
  }

  const run = activeRuns.get(sessionId);
  for (const [requestId, pending] of [...pendingPermissions]) {
    // Questions are user input, not tool permissions: bypass must not
    // answer them for the user (same rule as on arrival), so they stay open.
    if (pending.appSessionId !== sessionId || !pending.baseUrl || pending.kind === 'question') {
      continue;
    }
    pendingPermissions.delete(requestId);
    void replyPermission(pending.baseUrl, pending.directory, pending.providerSessionId, pending.permissionID, 'once');
    run?.writer.send(createNormalizedMessage({
      kind: 'permission_cancelled',
      requestId,
      reason: 'auto-approved',
      sessionId: pending.providerSessionId,
      provider: PROVIDER,
    }));
  }
}

function resolveOpenCodePermission(requestId: string, decision: ProviderPermissionDecision): void {
  const pending = pendingPermissions.get(requestId);
  if (!pending) {
    return;
  }
  pendingPermissions.delete(requestId);

  // The ask was answered on one client — every other viewer still shows the
  // prompt, so drop it session-wide, not just on the answering device. The
  // provider's own `question.replied`/`permission.replied` event cannot do
  // this: it lands after this delete, so `handleQuestionSettled` /
  // `handlePermissionReplied` find nothing left to cancel.
  const run = pending.appSessionId ? activeRuns.get(pending.appSessionId) : undefined;
  run?.writer.send(createNormalizedMessage({
    kind: 'permission_cancelled',
    requestId,
    reason: 'resolved',
    sessionId: pending.providerSessionId,
    provider: PROVIDER,
  }));

  if (pending.kind === 'question') {
    if (decision.allow) {
      const answer = formAnswerFromUi(
        pending.questions ?? [],
        pending.formFields ?? [],
        (decision.updatedInput as AnyRecord | undefined)?.answers,
      );
      void replyForm(pending.baseUrl, pending.directory, pending.providerSessionId, pending.requestId, answer);
    } else {
      void cancelForm(pending.baseUrl, pending.directory, pending.providerSessionId, pending.requestId);
    }
    return;
  }

  const response = decision.allow
    ? (decision.rememberEntry ? 'always' : 'once')
    : 'reject';
  // A bare reject halts the agent; with a message OpenCode feeds it back and keeps going.
  const feedback = !decision.allow && typeof decision.message === 'string' ? decision.message.trim() : '';
  void replyPermission(
    pending.baseUrl,
    pending.directory,
    pending.providerSessionId,
    pending.permissionID,
    response,
    feedback || undefined,
  );
}

function listOpenCodePendingPermissions(sessionId: string): unknown[] {
  const pending: unknown[] = [];
  for (const entry of pendingPermissions.values()) {
    if (entry.appSessionId !== sessionId) {
      continue;
    }
    pending.push({
      requestId: entry.requestId,
      toolName: entry.toolName,
      input: entry.input,
      ...(entry.kind === 'permission' ? openCodeRememberContext(entry.input as AnyRecord) : {}),
      sessionId,
    });
  }
  return pending;
}

export const opencodeRuntime: IProviderRuntime & {
  setPermissionMode(sessionId: string, mode: string): void;
} = {
  run: spawnOpenCode,
  abort: abortOpenCodeSession,
  steer: steerOpenCodeSession,
  setPermissionMode: setOpenCodePermissionMode,
  permissions: {
    resolve: resolveOpenCodePermission,
    listPending: listOpenCodePendingPermissions,
  },
};

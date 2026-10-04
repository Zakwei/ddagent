import fsSync from 'node:fs';
import path from 'node:path';

import {
  appendFilesInputTag,
  appendImagesInputTag,
  normalizeAttachmentDescriptors,
  createCompleteMessage,
  createNormalizedMessage,
  getOpenCodeDatabasePath,
  OPENCODE_EDIT_TOOL_NAMES,
  openSqliteReadonlyDatabase,
  readObjectRecord,
  readOptionalString,
} from '@/shared/index.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';
import { orchestratorMessagesDb } from '@/modules/database/index.js';
import { ensureServer, getServer } from '@/modules/providers/list/opencode/opencode-server.manager.js';
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
    const columns = db.prepare('PRAGMA table_info(session)').all() as { name: string }[];
    const columnNames = new Set(columns.map((column) => column.name));
    const requiredColumns = ['tokens_input', 'tokens_output', 'tokens_reasoning', 'tokens_cache_read', 'tokens_cache_write'];
    if (!requiredColumns.every((column) => columnNames.has(column))) {
      return null;
    }

    const row = db.prepare(`
      SELECT
        tokens_input AS inputTokens,
        tokens_output AS outputTokens,
        tokens_reasoning AS reasoningTokens,
        tokens_cache_read AS cacheReadTokens,
        tokens_cache_write AS cacheWriteTokens
      FROM session
      WHERE id = ?
    `).get(sessionId) as AnyRecord | undefined;

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
 * Window during which a completed `/instance/dispose` still counts as the
 * reset a later poisoned run needs — two turns killed by the same poisoned
 * instance (e.g. a parent plus its orchestrated child) must not dispose
 * twice and kill each other's retry.
 */
const INSTANCE_DISPOSE_FRESH_MS = 30_000;
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
 * Per-directory dispose bookkeeping for the poisoned-instance recovery
 * (OpenCode issue #30144: an early prompt cancel leaves every later prompt
 * in that directory instantly aborted until the instance is disposed).
 */
const instanceDisposeInFlight = new Map<string, Promise<void>>();
const instanceDisposedAt = new Map<string, number>();

/**
 * Disposes the serve-side project instance once per burst: callers sharing a
 * fresh disposal skip their own so a retried turn is never killed by a
 * sibling's late dispose.
 */
async function ensureInstanceDisposed(baseUrl: string, directory: string): Promise<void> {
  const key = `${baseUrl}|${directory}`;
  if ((instanceDisposedAt.get(key) ?? 0) > Date.now() - INSTANCE_DISPOSE_FRESH_MS) {
    return;
  }
  const inFlight = instanceDisposeInFlight.get(key);
  if (inFlight) {
    return inFlight;
  }
  const pending = apiRequest(baseUrl, '/instance/dispose', {
    method: 'POST',
    query: { directory },
  }).then(() => {
    instanceDisposedAt.set(key, Date.now());
  }).catch((error) => {
    console.warn('[OpenCode] Instance dispose failed:', error instanceof Error ? error.message : String(error));
  }).finally(() => {
    if (instanceDisposeInFlight.get(key) === pending) {
      instanceDisposeInFlight.delete(key);
    }
  });
  instanceDisposeInFlight.set(key, pending);
  return pending;
}

/**
 * Total tokens a `message.updated` info reports — poisoned pre-turn aborts
 * complete with zero, which separates them from a mid-stream provider abort
 * (that one already produced output and must not be replayed).
 */
function messageTokenTotal(info: AnyRecord): number {
  const tokens = readObjectRecord(info.tokens);
  if (!tokens) {
    return 0;
  }
  const cache = readObjectRecord(tokens.cache);
  return ['input', 'output', 'reasoning']
    .map((field) => Number(tokens[field]) || 0)
    .reduce((sum, value) => sum + value, 0)
    + (cache ? (Number(cache.read) || 0) + (Number(cache.write) || 0) : 0);
}

/**
 * Resets the poisoned directory instance and reposts this run's prompt —
 * self-healing for the OpenCode stale-abort state (issue #30144). The run
 * stays open; the retried turn's own SSE events settle it.
 */
async function recoverPoisonedRun(run: ActiveRun): Promise<void> {
  console.warn(`[OpenCode] Instant MessageAbortedError on ${run.providerSessionId} — directory instance is poisoned, resetting it and retrying the prompt once.`);
  run.writer.send(createNormalizedMessage({
    kind: 'status',
    text: 'OpenCode instance wedged — resetting it and retrying the prompt',
    canInterrupt: true,
    sessionId: run.providerSessionId ?? run.appSessionId,
    provider: PROVIDER,
  }));

  if (!run.baseUrl || !run.providerSessionId || !run.promptBody) {
    failRun(run, new Error('OpenCode aborted the prompt and the run cannot be retried.'));
    return;
  }
  await ensureInstanceDisposed(run.baseUrl, run.directory);
  if (run.aborted || run.completeSent) {
    run.resolve();
    return;
  }

  let status: number;
  let data: unknown;
  try {
    ({ status, data } = await apiRequest(
      run.baseUrl,
      `/session/${run.providerSessionId}/prompt_async`,
      {
        method: 'POST',
        query: { directory: run.directory },
        body: run.promptBody,
      },
    ));
  } catch (error) {
    failRun(run, error instanceof Error ? error : new Error(String(error)));
    return;
  }
  if (status >= 400) {
    failRun(run, new Error(`OpenCode prompt failed after instance reset (HTTP ${status}): ${JSON.stringify(data)}`));
    return;
  }
  // Hand settling back to the retried turn's events — busy credit from the
  // killed turn is stale and would accept its trailing idle.
  run.sawBusy = false;
  run.promptPostedAt = Date.now();
  run.recovering = false;
}

async function apiRequest(
  baseUrl: string,
  path: string,
  options: { method?: string; query?: Record<string, string>; body?: unknown } = {},
): Promise<{ status: number; data: unknown }> {
  const url = new URL(`${baseUrl}${path}`);
  for (const [key, value] of Object.entries(options.query ?? {})) {
    url.searchParams.set(key, value);
  }

  const response = await fetch(url.toString(), {
    method: options.method ?? 'GET',
    headers: options.body !== undefined ? { 'Content-Type': 'application/json' } : undefined,
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

function replyPermission(
  baseUrl: string,
  directory: string,
  providerSessionId: string,
  permissionID: string,
  response: 'once' | 'always' | 'reject',
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/session/${providerSessionId}/permissions/${permissionID}`, {
    method: 'POST',
    query: { directory },
    body: { response },
  }).catch((error) => {
    console.warn('[OpenCode] Permission reply failed:', error instanceof Error ? error.message : String(error));
    return { status: 0, data: null };
  });
}

function replyQuestion(
  baseUrl: string,
  directory: string,
  requestId: string,
  answers: string[][],
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/question/${requestId}/reply`, {
    method: 'POST',
    query: { directory },
    body: { answers },
  }).catch((error) => {
    console.warn('[OpenCode] Question reply failed:', error instanceof Error ? error.message : String(error));
    return { status: 0, data: null };
  });
}

function rejectQuestion(
  baseUrl: string,
  directory: string,
  requestId: string,
): Promise<{ status: number; data: unknown }> {
  return apiRequest(baseUrl, `/question/${requestId}/reject`, {
    method: 'POST',
    query: { directory },
  }).catch((error) => {
    console.warn('[OpenCode] Question reject failed:', error instanceof Error ? error.message : String(error));
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
  const input = {
    permission: props.permission,
    patterns: props.patterns,
    metadata: props.metadata,
    always: props.always,
  };

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
    sessionId: providerSessionId,
    provider: PROVIDER,
  }));
}

function handlePermissionAsked(baseUrl: string, props: AnyRecord): void {
  const providerSessionId = String(props.sessionID ?? '');
  const requestId = String(props.id ?? '');
  if (!providerSessionId || !requestId) {
    return;
  }

  const appSessionId = providerToApp.get(providerSessionId) ?? null;
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
  const requestId = String(props.permissionID ?? '');
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

function mapQuestion(raw: AnyRecord): ForwardedQuestion {
  const options = Array.isArray(raw.options) ? raw.options : [];
  return {
    question: String(raw.question ?? ''),
    header: typeof raw.header === 'string' ? raw.header : undefined,
    options: options.map((option: AnyRecord) => ({
      label: String(option?.label ?? ''),
      description: typeof option?.description === 'string' ? option.description : undefined,
    })),
    multiSelect: Boolean(raw.multiple),
  };
}

/**
 * The `question` tool is a first-class OpenCode event family of its own
 * (`question.asked`), not a permission. We surface it to the UI through the
 * same `permission_request` channel so the existing interactive panel renders,
 * and answer it through `/question/{id}/reply` from `resolve`.
 */
function handleQuestionAsked(baseUrl: string, props: AnyRecord): void {
  const providerSessionId = String(props.sessionID ?? '');
  const requestId = String(props.id ?? '');
  if (!providerSessionId || !requestId) {
    return;
  }

  const appSessionId = providerToApp.get(providerSessionId) ?? null;
  const run = appSessionId ? activeRuns.get(appSessionId) : undefined;
  const questions = (Array.isArray(props.questions) ? props.questions : []).map(mapQuestion);

  // No run means there is no UI to answer through — rejecting lets the
  // provider continue instead of hanging the turn forever.
  if (!run || !run.baseUrl || questions.length === 0) {
    void rejectQuestion(baseUrl, run?.directory ?? '', requestId);
    return;
  }

  // The question tool is user input, not a permission: bypassPermissions
  // must not answer for the user. Only headless delegated children keep the
  // empty-answer skip — there is no one to render the panel to.
  if (
    resolveOpenCodePermissionBehavior(modeForSession(appSessionId)).autoApprove === 'all'
    && isDelegatedChildSession(appSessionId)
  ) {
    void replyQuestion(run.baseUrl, run.directory, requestId, questions.map(() => []));
    return;
  }

  const input = { questions };
  pendingPermissions.set(requestId, {
    requestId,
    appSessionId: run.appSessionId,
    providerSessionId,
    permissionID: requestId,
    baseUrl: run.baseUrl,
    directory: run.directory,
    toolName: 'AskUserQuestion',
    input,
    kind: 'question',
    questions,
  });

  run.writer.send(createNormalizedMessage({
    kind: 'permission_request',
    requestId,
    toolName: 'AskUserQuestion',
    input,
    sessionId: providerSessionId,
    provider: PROVIDER,
  }));
}

function handleQuestionSettled(props: AnyRecord): void {
  const requestId = String(props.requestID ?? '');
  const pending = requestId ? pendingPermissions.get(requestId) : undefined;
  if (!pending || pending.kind !== 'question') {
    return;
  }
  pendingPermissions.delete(requestId);
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
 * Turns the interactive panel's `answers` (question text → labels joined with
 * ", ") into OpenCode's positional `Array<Array<string>>`. When the value
 * equals a single option label exactly it is kept whole, so labels that
 * themselves contain ", " survive.
 */
function questionAnswersToApi(questions: ForwardedQuestion[], answers: unknown): string[][] {
  const map = answers && typeof answers === 'object' && !Array.isArray(answers)
    ? (answers as Record<string, unknown>)
    : {};
  return questions.map((question) => {
    const value = map[question.question];
    if (Array.isArray(value)) {
      return value.map(String);
    }
    if (typeof value !== 'string' || value.trim() === '') {
      return [];
    }
    if (question.options.some((option) => option.label === value)) {
      return [value];
    }
    return value.split(', ').map((part) => part.trim()).filter(Boolean);
  });
}

function finishRun(run: ActiveRun): void {
  if (run.completeSent) {
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

function dispatchServerEvent(baseUrl: string, event: AnyRecord): void {
  const props = (event.properties ?? {}) as AnyRecord;
  const type = String(event.type ?? '');

  if (type === 'permission.asked') {
    handlePermissionAsked(baseUrl, props);
    return;
  }
  if (type === 'permission.replied') {
    handlePermissionReplied(baseUrl, props);
    return;
  }

  if (type === 'question.asked' || type === 'question.v2.asked') {
    // SSE carries the payload flat under `properties`; durable variants nest
    // it under `data`. Accept either.
    handleQuestionAsked(baseUrl, (event.data ?? props.data ?? props) as AnyRecord);
    return;
  }
  if (
    type === 'question.replied'
    || type === 'question.rejected'
    || type === 'question.v2.replied'
    || type === 'question.v2.rejected'
  ) {
    const data = (event.data ?? props.data ?? props) as AnyRecord;
    handleQuestionSettled({ requestID: data.requestID ?? data.id });
    return;
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

  // Poisoned-instance abort (OpenCode issue #30144): the assistant turn dies
  // instantly with MessageAbortedError and zero tokens even though we never
  // aborted it. Reset the directory instance and repost the prompt once —
  // a mid-stream provider abort carries tokens and is left to fail normally.
  if (type === 'message.updated') {
    const info = readObjectRecord(props.info) ?? {};
    const error = readObjectRecord(info.error);
    if (
      run.promptPosted
      && !run.aborted
      && !run.completeSent
      && !run.poisonRetried
      && info.role === 'assistant'
      && error?.name === 'MessageAbortedError'
      && messageTokenTotal(info) === 0
    ) {
      run.poisonRetried = true;
      run.recovering = true;
      void recoverPoisonedRun(run);
      return;
    }
    // Any other terminal assistant-message error (provider API/auth/rate-
    // limit failure, a mid-stream abort that already emitted tokens) ends the
    // turn in OpenCode — without failing here, the trailing session.idle
    // settles the run as a success and an orchestrated step gets marked done
    // on a dead lane.
    if (
      run.promptPosted
      && !run.aborted
      && !run.completeSent
      && !run.recovering
      && info.role === 'assistant'
      && error
    ) {
      const detail =
        readOptionalString(readObjectRecord(error.data)?.message)
        ?? readOptionalString(error.message)
        ?? String(error.name ?? 'OpenCode turn failed');
      failRun(run, new Error(detail));
    }
    return;
  }

  if (type === 'message.part.updated') {
    const part = (props.part ?? {}) as AnyRecord;
    const partId = typeof part.id === 'string' ? part.id : '';
    const partType = typeof part.type === 'string' ? part.type : '';
    if (partId && partType) {
      run.partTypes.set(partId, partType);
    }
    // OpenCode mirrors every edit/write tool with an auto-generated `patch`
    // part in the same message (same diff) — the CLI shows one card, so drop
    // the patch echo once the edit tool was seen. The edit tool carries the
    // diff in its own metadata, so nothing is lost.
    const partMessageId = typeof part.messageID === 'string' ? part.messageID : '';
    if (partType === 'patch' && partMessageId && run.editedMessageIds.has(partMessageId)) {
      return;
    }
    if (partType === 'tool' && partMessageId) {
      const toolName = readOptionalString(part.tool)?.toLowerCase() ?? '';
      if (OPENCODE_EDIT_TOOL_NAMES.has(toolName)) {
        run.editedMessageIds.add(partMessageId);
      }
    }
    // A part whose deltas already streamed must not also land as a snapshot:
    // the client would render the live row plus the snapshot row, and its
    // echo dedupe only collapses *adjacent* twins — a tool row interleaved by
    // timestamp (e.g. `compress` between the text and its turn) splits them
    // into a visible duplicate. Reasoning had this guard; text was missing it.
    if ((partType === 'reasoning' || partType === 'text') && run.streamedParts.has(partId)) {
      return;
    }
    let normalized: ReturnType<ProviderRuntimeContext['normalizeMessage']> = [];
    try {
      normalized = run.context.normalizeMessage(props, run.providerSessionId ?? providerSessionId);
    } catch (error) {
      console.error('[OpenCode] Failed to normalize server event:', error);
    }
    for (const message of normalized) {
      run.writer.send(message);
    }
    return;
  }

  // Token-level streaming: OpenCode emits `message.part.delta` while the model
  // generates — forwarding them makes the reply grow live instead of landing
  // as one snapshot when the part finishes (`message.part.updated`).
  if (type === 'message.part.delta') {
    const delta = typeof props.delta === 'string' ? props.delta : '';
    const field = typeof props.field === 'string' ? props.field : '';
    if (!delta || field !== 'text') {
      return;
    }
    const partId = typeof props.partID === 'string' ? props.partID : '';
    const partType = partId ? run.partTypes.get(partId) : undefined;
    if (partType !== undefined && partType !== 'text' && partType !== 'reasoning') {
      return;
    }
    if (partId) {
      run.streamedParts.add(partId);
    }
    run.writer.send(createNormalizedMessage({
      kind: partType === 'reasoning' ? 'thought_delta' : 'stream_delta',
      content: delta,
      sessionId: run.providerSessionId ?? providerSessionId,
      provider: PROVIDER,
    }));
    return;
  }

  // Any non-idle status means a turn is live. Counted per run so a later
  // `session.idle` is known to be ours — not a leftover from the aborted or
  // pre-restart turn that shared this provider session.
  if (type === 'session.status' && props.status?.type && props.status.type !== 'idle') {
    run.sawBusy = true;
    if (run.idleTimer) {
      clearTimeout(run.idleTimer);
      run.idleTimer = undefined;
    }
    // OpenCode reports provider rate limiting as a `retry` status rather
    // than an error — surface the backoff so the turn does not look frozen.
    if (props.status.type === 'retry') {
      const attempt = Number(props.status.attempt) || 0;
      const detail = readOptionalString(props.status.message) ?? 'Rate limited';
      run.writer.send(createNormalizedMessage({
        kind: 'status',
        text: attempt > 0 ? `${detail} — retry ${attempt}` : detail,
        canInterrupt: true,
        sessionId: run.providerSessionId ?? providerSessionId,
        provider: PROVIDER,
      }));
      trackRetryStatus(run, attempt);
    } else {
      clearRetryStatus(run);
    }
    return;
  }

  const idle = type === 'session.idle'
    || (type === 'session.status' && props.status?.type === 'idle');
  if (idle) {
    if (run.recovering) {
      // The killed turn's trailing idle — the retried turn settles the run.
      return;
    }
    // An idle is terminal only for a run whose own prompt went out AND whose
    // turn was seen busy. Otherwise it is a stale event (the abort's
    // trailing idle, or replayed state) — finishing now would resolve the
    // run while setup still posts prompt_async, orphaning the whole turn.
    if (run.promptPosted && run.sawBusy) {
      finishRun(run);
      return;
    }
    // Fallback for an OpenCode that never emits a busy status: the idle is
    // debated by settleStaleIdle — verified against live status and the
    // run's own event traffic instead of blindly accepted after the grace.
    if (run.promptPosted && !run.aborted && !run.completeSent && !run.idleTimer) {
      run.idleSeenAt = run.lastEventAt;
      run.idleTimer = setTimeout(() => {
        void settleStaleIdle(run);
      }, STALE_IDLE_GRACE_MS);
      run.idleTimer.unref?.();
    }
    return;
  }

  if (type === 'session.error') {
    // Same stale-event guard: an error predating our prompt belongs to the
    // previous turn — and an error during poison recovery belongs to the
    // killed turn, not the retried one.
    if (run.promptPosted && !run.recovering) {
      const errorContent = props.error?.data?.message
        ?? props.error?.message
        ?? (typeof props.error === 'string' ? props.error : 'OpenCode session error');
      failRun(run, new Error(String(errorContent)));
    }
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
    const { status, data } = await apiRequest(run.baseUrl, '/session/status');
    const statuses = readObjectRecord(data);
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
      await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/abort`, {
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
    const { status, data } = await apiRequest(baseUrl, '/session/status');
    const statuses = readObjectRecord(data);
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
        const response = await fetch(`${currentBaseUrl}/event`, {
          headers: {
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
    query: { directory },
    body: { title: title || 'ddagent session' },
  });
  const id = (data as AnyRecord | null)?.id;
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
    // `opencode serve` is global: the `directory` query only picks the request
    // context, so a session created elsewhere still returns 200. Its stored
    // `directory` decides where prompts actually run, and a repointed
    // workspace must start a fresh provider session instead of resuming the
    // old directory's session.
    const sessionDirectory = (data as AnyRecord | null)?.directory;
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
  // The live mode map is keyed per session; the next run re-seeds it from
  // the send's options, so the entry must not linger between runs.
  sessionModes.delete(run.appSessionId);
  for (const [requestId, pending] of pendingPermissions) {
    if (pending.appSessionId === run.appSessionId) {
      pendingPermissions.delete(requestId);
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

        if (run.aborted || run.completeSent) {
          // The run settled while the session was being set up — posting the
          // prompt now would start a turn with no listener attached.
          run.resolve();
          return;
        }

        // Set before the POST resolves: terminal events arriving while the
        // request is in flight already belong to this run.
        run.promptPosted = true;
        run.promptPostedAt = Date.now();
        const promptBody: AnyRecord = {
          parts: [{ type: 'text', text: promptText }],
          ...(behavior.agent ? { agent: behavior.agent } : {}),
          ...(modelID ? { model: { providerID, modelID, ...(resolvedEffort ? { variant: resolvedEffort } : {}) } } : {}),
        };
        run.promptBody = promptBody;
        const { status, data } = await apiRequest(
          server.baseUrl,
          `/session/${run.providerSessionId}/prompt_async`,
          {
            method: 'POST',
            query: { directory: workingDir },
            body: promptBody,
          },
        );

        if (status >= 400) {
          throw new Error(`OpenCode prompt failed (HTTP ${status}): ${JSON.stringify(data)}`);
        }

        if (run.aborted) {
          run.resolve();
        }
        // Otherwise the SSE event stream settles the run on session.idle /
        // session.error.
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

// Consumed by provider runtime services and lifecycle tests.
export async function abortOpenCodeSession(sessionId: string): Promise<boolean> {
  const run = activeRuns.get(sessionId);
  if (!run) {
    return false;
  }

  run.aborted = true;
  try {
    if (run.baseUrl && run.providerSessionId) {
      const response = await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/abort`, {
        method: 'POST',
        query: { directory: run.directory },
      });
      if (response.status < 200 || response.status >= 300 || response.data === false) {
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
    if (pending.appSessionId !== sessionId || !pending.baseUrl) {
      continue;
    }
    pendingPermissions.delete(requestId);
    if (pending.kind === 'question') {
      void replyQuestion(pending.baseUrl, pending.directory, pending.requestId, (pending.questions ?? []).map(() => []));
    } else {
      void replyPermission(pending.baseUrl, pending.directory, pending.providerSessionId, pending.permissionID, 'once');
    }
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

  if (pending.kind === 'question') {
    if (decision.allow) {
      const answers = questionAnswersToApi(
        pending.questions ?? [],
        (decision.updatedInput as AnyRecord | undefined)?.answers,
      );
      void replyQuestion(pending.baseUrl, pending.directory, pending.requestId, answers);
    } else {
      void rejectQuestion(pending.baseUrl, pending.directory, pending.requestId);
    }
    return;
  }

  const response = decision.allow
    ? (decision.rememberEntry ? 'always' : 'once')
    : 'reject';
  void replyPermission(pending.baseUrl, pending.directory, pending.providerSessionId, pending.permissionID, response);
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
  setPermissionMode: setOpenCodePermissionMode,
  permissions: {
    resolve: resolveOpenCodePermission,
    listPending: listOpenCodePendingPermissions,
  },
};

import fsSync from 'node:fs';
import path from 'node:path';

import {
  appendFilesInputTag,
  appendImagesInputTag,
  normalizeAttachmentDescriptors,
} from '@/shared/image-attachments.js';
import { notifyRunFailed, notifyRunStopped } from '@/modules/notifications/index.js';
import { ensureServer } from '@/modules/providers/list/opencode/opencode-server.manager.js';
import {
  createCompleteMessage,
  createNormalizedMessage,
  getOpenCodeDatabasePath,
  openSqliteReadonlyDatabase,
} from '@/shared/utils.js';
import type { IProviderRuntime } from '@/shared/interfaces.js';
import type {
  AnyRecord,
  ProviderPermissionDecision,
  ProviderRuntimeContext,
  ProviderRuntimeWriter,
} from '@/shared/types.js';

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
  /**
   * True once this run observed its own turn going busy. `session.idle` is
   * terminal only after a busy — an idle with no preceding busy is stale.
   */
  sawBusy: boolean;
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
  resolve: () => void;
  reject: (error: Error) => void;
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
};

type EventStreamState = {
  alive: boolean;
  controller: AbortController;
  retryCount: number;
  connected: Promise<void>;
  markConnected: () => void;
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
 * Grace window for a prompt-posted-but-never-busy `session.idle` before it
 * is accepted as terminal anyway.
 */
const STALE_IDLE_GRACE_MS = 2000;

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

function modeForSession(appSessionId: string | null): string {
  return (appSessionId && sessionModes.get(appSessionId)) || 'default';
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
  if (!run.aborted) {
    notifyTerminalState(run, error);
  }
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

  const providerSessionId = String(props.sessionID ?? '');
  if (!providerSessionId) {
    return;
  }
  const appSessionId = providerToApp.get(providerSessionId);
  const run = appSessionId ? activeRuns.get(appSessionId) : undefined;
  if (!run) {
    return;
  }

  if (type === 'message.part.updated') {
    const part = (props.part ?? {}) as AnyRecord;
    const partId = typeof part.id === 'string' ? part.id : '';
    const partType = typeof part.type === 'string' ? part.type : '';
    if (partId && partType) {
      run.partTypes.set(partId, partType);
    }
    if (partType === 'reasoning' && run.streamedParts.has(partId)) {
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
    return;
  }

  const idle = type === 'session.idle'
    || (type === 'session.status' && props.status?.type === 'idle');
  if (idle) {
    // An idle is terminal only for a run whose own prompt went out AND whose
    // turn was seen busy. Otherwise it is a stale event (the abort's
    // trailing idle, or replayed state) — finishing now would resolve the
    // run while setup still posts prompt_async, orphaning the whole turn.
    if (run.promptPosted && run.sawBusy) {
      finishRun(run);
      return;
    }
    // Fallback for an OpenCode that never emits a busy status: accept the
    // idle after a short grace unless a busy shows up first.
    if (run.promptPosted && !run.aborted && !run.completeSent && !run.idleTimer) {
      run.idleTimer = setTimeout(() => {
        run.idleTimer = undefined;
        if (!run.aborted && !run.completeSent && !run.sawBusy) {
          finishRun(run);
        }
      }, STALE_IDLE_GRACE_MS);
      run.idleTimer.unref?.();
    }
    return;
  }

  if (type === 'session.error') {
    // Same stale-event guard: an error predating our prompt belongs to the
    // previous turn. Once our prompt is out, errors are ours to report.
    if (run.promptPosted) {
      const errorContent = props.error?.data?.message
        ?? props.error?.message
        ?? (typeof props.error === 'string' ? props.error : 'OpenCode session error');
      failRun(run, new Error(String(errorContent)));
    }
  }
}

/**
 * Opens (once) the server-sent event stream for a serve instance and routes
 * events to active runs. Reconnects with backoff while runs are active; a
 * server that stays unreachable fails its runs instead of hanging forever.
 */
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
    connected,
    markConnected,
  };
  eventStreams.set(baseUrl, state);

  void (async () => {
    while (state.alive) {
      try {
        const response = await fetch(`${baseUrl}/event`, {
          headers: { Accept: 'text/event-stream' },
          signal: state.controller.signal,
        });
        if (!response.ok || !response.body) {
          throw new Error(`event stream returned ${response.status}`);
        }
        state.markConnected();

        const reader = response.body.getReader();
        const decoder = new TextDecoder();
        let buffer = '';
        while (true) {
          const { done, value } = await reader.read();
          if (done) {
            break;
          }
          buffer += decoder.decode(value, { stream: true });
          let boundary = buffer.indexOf('\n\n');
          while (boundary >= 0) {
            const chunk = buffer.slice(0, boundary);
            buffer = buffer.slice(boundary + 2);
            for (const line of chunk.split('\n')) {
              if (!line.startsWith('data:')) {
                continue;
              }
              try {
                dispatchServerEvent(baseUrl, JSON.parse(line.slice(5)) as AnyRecord);
              } catch (error) {
                console.error('[OpenCode] Failed to dispatch server event:', error);
              }
            }
            boundary = buffer.indexOf('\n\n');
          }
        }
        throw new Error('event stream closed');
      } catch (error) {
        if (state.controller.signal.aborted) {
          break;
        }
        state.retryCount += 1;
        const runsHere = [...activeRuns.values()].filter((run) => run.baseUrl === baseUrl);
        if (state.retryCount > SSE_MAX_RECONNECTS || runsHere.length === 0) {
          for (const run of runsHere) {
            failRun(run, new Error('Lost connection to the OpenCode server'));
          }
          break;
        }
        await new Promise((resolve) => setTimeout(resolve, SSE_RECONNECT_DELAY_MS));
      }
    }
    state.alive = false;
    if (eventStreams.get(baseUrl) === state) {
      eventStreams.delete(baseUrl);
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
  }
  if (run.providerSessionId && providerToApp.get(run.providerSessionId) === run.appSessionId) {
    providerToApp.delete(run.providerSessionId);
  }
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
async function spawnOpenCode(
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
      sawBusy: false,
      partTypes: new Map(),
      streamedParts: new Set(),
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
        const server = await ensureServer(workingDir);
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
        const { status, data } = await apiRequest(
          server.baseUrl,
          `/session/${run.providerSessionId}/prompt_async`,
          {
            method: 'POST',
            query: { directory: workingDir },
            body: {
              parts: [{ type: 'text', text: promptText }],
              ...(behavior.agent ? { agent: behavior.agent } : {}),
              ...(modelID ? { model: { providerID, modelID, ...(resolvedEffort ? { variant: resolvedEffort } : {}) } } : {}),
            },
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

async function abortOpenCodeSession(sessionId: string): Promise<boolean> {
  const run = activeRuns.get(sessionId);
  if (!run) {
    return false;
  }

  run.aborted = true;
  if (run.baseUrl && run.providerSessionId) {
    await apiRequest(run.baseUrl, `/session/${run.providerSessionId}/abort`, {
      method: 'POST',
      query: { directory: run.directory },
    }).catch((error) => {
      console.warn('[OpenCode] Abort request failed:', error instanceof Error ? error.message : String(error));
    });
  }
  if (!run.completeSent) {
    run.resolve();
  }
  return true;
}

function isOpenCodeSessionActive(sessionId: string): boolean {
  return activeRuns.has(sessionId);
}

function getActiveOpenCodeSessions(): string[] {
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

export {
  spawnOpenCode,
  abortOpenCodeSession,
  isOpenCodeSessionActive,
  getActiveOpenCodeSessions,
};

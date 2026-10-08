import path from 'node:path';

import { orchestratorMessagesDb, providerAccountsDb, sessionsDb } from '@/modules/database/index.js';
import { accountFailoverService } from '@/modules/provider-accounts/index.js';
import { buildDdagentSessionName, isAutoDerivedSessionName, providerModelsService, sessionsService } from '@/modules/providers/index.js';
import { buildSharedContextPrefix } from '@/modules/shared-context/index.js';
import { applyUnifiedPrefix } from '@/modules/unified/index.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients, WS_OPEN_STATE } from '@/modules/websocket/services/websocket-state.service.js';
import {
  createNormalizedMessage,
  createOrchestratorStatusFrame,
  MINI_ORCHESTRATOR_PROVIDER,
  ORCHESTRATOR_PROVIDER,
  safeSocketSend,
  getGlobalImageAssetsDir,
  isImageAttachmentDescriptor,
  normalizeAttachmentDescriptors,
} from '@/shared/index.js';
import type {
  AnyRecord,
  ChatAttachmentDescriptor,
  LLMProvider,
  NormalizedMessage,
  OrchestratorMessage,
  ProviderPermissionDecision,
  ProviderRuntimeWriter,
  RealtimeClientConnection,
} from '@/shared/index.js';

/**
 * Application boundary for dispatching provider runs and approvals.
 *
 * Declared here (rather than imported from the websocket handler) so the
 * command dispatcher can be reused by every server-side sender — the live chat
 * socket and the persisted message queue — without importing each other.
 */
export type ProviderRuntimeGateway = {
  hasRuntime(provider: string): boolean;
  run(
    provider: LLMProvider,
    command: string,
    options: AnyRecord,
    writer: ProviderRuntimeWriter,
  ): Promise<unknown>;
  abort(provider: LLMProvider, sessionId: string): Promise<boolean>;
  setSessionPermissionMode?(provider: LLMProvider, sessionId: string, mode: string): void;
  steer?(provider: LLMProvider, sessionId: string, content: string, options: AnyRecord): Promise<boolean>;
  resolveToolApproval(requestId: string, payload: ProviderPermissionDecision): void;
  getPendingApprovalsForSession(sessionId: string): unknown[];
};

/**
 * Trust boundary for client-supplied image attachments: chat.send options come
 * straight from the browser, and the provider runtimes read the referenced
 * files off disk (Claude base64-encodes them into the prompt). Only images
 * that live directly inside the global upload store (`~/.ddagent/assets`,
 * where POST /api/assets/images puts them) are allowed through — anything
 * else (absolute paths elsewhere, traversal, subdirectories) is dropped.
 *
 * Exported for tests; `assetsRootOverride` exists only for them.
 */
export function filterAttachmentsToUploadStore(
  attachments: unknown,
  assetsRootOverride?: string,
): ChatAttachmentDescriptor[] {
  const assetsRoot = path.resolve(assetsRootOverride ?? getGlobalImageAssetsDir());

  return normalizeAttachmentDescriptors(attachments).filter((descriptor) => {
    // Relative paths are anchored in the store; absolute ones must already be in it.
    const resolved = path.resolve(assetsRoot, descriptor.path);
    const relative = path.relative(assetsRoot, resolved);
    const isDirectChild =
      relative.length > 0 &&
      !relative.startsWith('..') &&
      !path.isAbsolute(relative) &&
      !relative.includes(path.sep) &&
      !relative.includes('/');

    if (!isDirectChild) {
      console.warn(`[Chat] Dropping attachment outside the upload store: ${descriptor.path}`);
    }
    return isDirectChild;
  });
}

/** Backward-compatible image filter consumed by existing websocket tests. */
export function filterImagesToUploadStore(
  images: unknown,
  assetsRootOverride?: string,
): ChatAttachmentDescriptor[] {
  return filterAttachmentsToUploadStore(images, assetsRootOverride);
}

/** Minimum visible-message length before a background LLM title is worth a call. */
const MIN_TITLE_CONTENT_LENGTH = 12;

/**
 * Sessions whose background title attempt already fired. Best-effort and
 * in-memory: a restart re-attempts once, which is harmless.
 */
const titleAttempts = new Set<string>();

/** Broadcasts one `session_upserted` frame carrying only a new summary. */
function broadcastSessionName(
  sessionId: string,
  provider: LLMProvider,
  summary: string,
  connection: RealtimeClientConnection,
): void {
  const frame = JSON.stringify({
    kind: 'session_upserted',
    sessionId,
    provider,
    session: { id: sessionId, summary },
  });
  const recipients = new Set([...connectedClients, connection]);
  recipients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) safeSocketSend(client, frame);
  });
}

/**
 * Tells every client a session now runs under another provider account; the
 * session lists reload on `session_upserted`, so headers pick up the new
 * account badge.
 */
function broadcastSessionAccount(
  sessionId: string,
  provider: LLMProvider,
  accountId: string | null,
  connection: RealtimeClientConnection,
): void {
  const frame = JSON.stringify({
    kind: 'session_upserted',
    sessionId,
    provider,
    session: { id: sessionId, accountId },
  });
  const recipients = new Set([...connectedClients, connection]);
  recipients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) safeSocketSend(client, frame);
  });
}

/** One-line status shown while the switched turn starts. */
function describeAccountSwitch(change: { fromLabel: string; toLabel: string }): string {
  const from = change.fromLabel || 'default login';
  const to = change.toLabel || 'default login';
  return `Usage limit reached on "${from}" — switched to account "${to}"`;
}

/** Test seam: the background title generator contract. */
export type SessionTitleGenerator = (input: {
  sessionId: string;
  content: string;
  language?: unknown;
}) => Promise<string | null>;

/** Production titler: the orchestrator's cheap `report` lane. */
async function defaultSessionTitleGenerator(input: {
  sessionId: string;
  content: string;
  language?: unknown;
}): Promise<string | null> {
  const { orchestratorRuntime } = await import('@/modules/orchestrator/index.js');
  return orchestratorRuntime.generateSessionTitle(input);
}

let sessionTitleGenerator: SessionTitleGenerator = defaultSessionTitleGenerator;

const languageNames = new Intl.DisplayNames(['en'], { type: 'language' });

/**
 * Prefixes every outbound turn with the client's UI language, so agents keep
 * answering in it even when the rules or tool output around them are in
 * another language. The client strips the tag from the user bubble.
 */
function withAppLanguage(content: string, language: unknown): string {
  if (typeof language !== 'string' || !language.trim()) return content;
  let name: string | undefined;
  try {
    name = languageNames.of(language.trim());
  } catch {
    return content; // Not a valid BCP 47 tag.
  }
  if (!name) return content;
  return `<app-language>Always reply in ${name} (the user's app language) unless the user explicitly asks for another language.</app-language>\n\n${content}`;
}

/**
 * Test seam: replaces the background titler so unit tests never spawn a real
 * provider run. Pass null to restore the production orchestrator-backed one.
 */
export function setSessionTitleGenerator(generator: SessionTitleGenerator | null): void {
  sessionTitleGenerator = generator ?? defaultSessionTitleGenerator;
}

/**
 * Fire-and-forget: asks the orchestrator to title a new session on a cheap
 * lane, then stores + broadcasts it only if the auto-derived name is still in
 * place. Any failure leaves the derived title untouched.
 */
async function generateSessionTitleInBackground(
  sessionId: string,
  provider: LLMProvider,
  content: string,
  expectedName: string,
  options: AnyRecord,
  connection: RealtimeClientConnection,
): Promise<void> {
  try {
    const title = await sessionTitleGenerator({
      sessionId,
      content,
      language: options.language,
    });
    if (!title) {
      return;
    }
    const applied = sessionsService.applyGeneratedSessionTitle(sessionId, expectedName, title);
    if (applied) {
      broadcastSessionName(sessionId, provider, applied, connection);
    }
  } catch {
    // Best-effort metadata: the derived title stays in place.
  }
}

export type ChatDispatchResult =
  | { ok: true }
  | { ok: false; code: string; error: string; sessionId: string };

/** Minimal text preview of one outbound event, mirroring orchestrator-delegation's logic. */
function delegationPreviewOf(event: NormalizedMessage): string | null {
  if (event.kind === 'text' || event.kind === 'stream_delta' || event.kind === 'stream_replace') {
    const text = (event.content ?? (event as Record<string, unknown>).text ?? '') as string;
    return text ? text.slice(0, 500) : null;
  }
  if (event.kind === 'tool_use') {
    return `tool: ${event.toolName ?? 'unknown'}`;
  }
  if (event.kind === 'error') {
    return `error: ${event.reason ?? event.content ?? 'unknown'}`;
  }
  return null;
}

/**
 * Broadcasts a parent-transcript entry as a live `status` frame to all
 * connected clients and to the parent session's own run writer when present.
 *
 * Mirrors orchestrator.module's `publishEntry` without importing that module
 * (which would create a load-time cycle: orchestrator → websocket → orchestrator).
 *
 * Consumed by: dispatchChatCommand (child→parent delegation status sync).
 */
function publishDelegationEntry(entry: OrchestratorMessage): void {
  // The frame's provider must match the parent session's engine (full vs mini)
  // so the client folds live rows into the right transcript.
  const provider = sessionsDb.getSessionById(entry.sessionId)?.provider ?? ORCHESTRATOR_PROVIDER;
  const frame = createOrchestratorStatusFrame(entry, provider);
  const parentRun = chatRunRegistry.getRun(entry.sessionId);
  if (parentRun) {
    parentRun.writer.send(frame);
  }
  const serialized = JSON.stringify(frame);
  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      safeSocketSend(client, serialized);
    }
  });
}

/**
 * Patches a delegation row in the parent transcript and publishes the result.
 * No-op when rowId is null. Errors are swallowed so a bad patch never disrupts
 * the child run's own delivery path.
 *
 * Consumed by: dispatchChatCommand (child→parent delegation status sync).
 */
function patchAndPublishDelegation(
  rowId: number,
  parentSessionId: string,
  patch: Record<string, unknown>,
): void {
  try {
    const updated = orchestratorMessagesDb.updatePayload(rowId, patch);
    if (updated) publishDelegationEntry(updated);
  } catch (err) {
    console.warn('[Chat] Delegation status sync failed', {
      rowId,
      parentSessionId,
      error: err instanceof Error ? err.message : String(err),
    });
  }
}

/**
 * Dispatches one chat command to a provider runtime for an app session.
 *
 * This is the single code path a server-side send takes, whether it arrives
 * over the live websocket or is replayed from the persisted queue. It resolves
 * the session row (provider, project path, provider-native id all come from the
 * database — never from the client), records the model/effort so reopening the
 * session restores them, re-validates attachments against the upload store,
 * registers the run, and awaits the provider runtime.
 *
 * Returns a structured failure instead of writing to a socket so callers decide
 * how to report it (the websocket handler emits `protocol_error`; the queue
 * marks the row failed).
 */
export async function dispatchChatCommand(
  runtime: ProviderRuntimeGateway,
  input: {
    sessionId: string;
    content: string;
    options: AnyRecord;
    userId: string | number | null;
    connection: RealtimeClientConnection;
  },
): Promise<ChatDispatchResult> {
  const { sessionId, content, options, userId, connection } = input;

  // The provider child environment is server-owned: it is built only from the
  // session account's overrides (resolved below). Drop any client-supplied
  // `env` so a chat.send cannot inject variables into the provider process and
  // bypass the multi-account credential isolation.
  const clientOptions: AnyRecord = { ...options };
  delete clientOptions.env;

  const session = sessionsDb.getSessionById(sessionId);
  if (!session) {
    return {
      ok: false,
      code: 'SESSION_NOT_FOUND',
      error: `Session "${sessionId}" was not found. Create it via POST /api/providers/sessions first.`,
      sessionId,
    };
  }

  // Archived sessions are invisible in the UI: a send (or a queued row
  // draining after restart) would start a run the user cannot watch, burn
  // tokens, and write to a transcript nobody sees. Restore first.
  if (session.isArchived) {
    return {
      ok: false,
      code: 'SESSION_ARCHIVED',
      error: `Session "${sessionId}" is archived. Restore it before sending.`,
      sessionId,
    };
  }

  // A send with neither text nor attachments would open a provider run that
  // has nothing to do — reject it as a protocol error instead of burning a
  // turn (and, for some runtimes, a genuinely empty model prompt).
  const attachmentCandidates = [
    ...normalizeAttachmentDescriptors(clientOptions.images),
    ...normalizeAttachmentDescriptors(clientOptions.files),
    ...normalizeAttachmentDescriptors(clientOptions.attachments),
  ];
  if (!content.trim() && attachmentCandidates.length === 0) {
    return {
      ok: false,
      code: 'EMPTY_MESSAGE',
      error: 'chat.send requires message content or at least one attachment.',
      sessionId,
    };
  }

  // Shared-context + unified-rules injection: the project's
  // .ddagent/shared-context.md and the unified <unified-rules> prefix ride the
  // session's first outbound message — provider-agnostic, works the same for
  // every runtime (the prepend IS the fallback for providers without a
  // dedicated system-context channel). Entering history once keeps both in
  // context for the whole session without per-turn token burn.
  let effectiveContent = withAppLanguage(content, clientOptions.language);
  if (session.project_path && !session.shared_context_injected_at) {
    try {
      const prefix = await buildSharedContextPrefix(session.project_path);
      if (prefix) {
        effectiveContent = prefix + effectiveContent;
      }
      // Unified rules (workspace AGENTS.md + hygiene block) ride the same
      // first-turn gate. DDAGENT_UNIFIED_RULES=0 opts out; injection never
      // throws, so a failure still dispatches the raw content.
      effectiveContent = await applyUnifiedPrefix(effectiveContent, session.project_path);
      // Knowledge base is NOT auto-injected: agents retrieve it on demand via
      // the MCP `knowledge_get_context` tool (the Contexta model).
      // Marked even when the file is absent: "first turn" is positional, and
      // re-checking forever would keep reading the filesystem on every send.
      sessionsDb.markSharedContextInjected(sessionId);
    } catch (error) {
      // Context must never block a send — log and dispatch the raw content.
      console.warn('[Chat] Shared-context injection skipped:', error);
    }
  }

  const provider = session.provider as LLMProvider;

  // Orchestrated sessions have no provider runtime: every message is routed
  // (task type + quota) and executed as delegated child runs mirrored into
  // the parent transcript. Lazy import keeps the websocket module free of a
  // load-time dependency on the orchestrator (which imports this registry).
  if (session.provider === ORCHESTRATOR_PROVIDER) {
    // This branch bypasses provider-run naming below. Persist the title from
    // visible user text before delegation; injected context must not name it.
    const sessionName = sessionsService.nameUntitledSession(sessionId, content);
    if (sessionName) {
      broadcastSessionName(sessionId, provider, sessionName, connection);
    }
    const { orchestratorRuntime } = await import('@/modules/orchestrator/index.js');
    const result = await orchestratorRuntime.handleMessage({
      sessionId,
      content: effectiveContent,
      options: clientOptions,
      userId,
      connection,
    });
    return result.ok ? result : { ...result, sessionId };
  }

  // Mini-orchestrated sessions: a lighter two-role engine (thinker plans, worker
  // executes) that streams the same transcript frames. Lazy import keeps the
  // websocket module free of a load-time dependency on the mini module.
  if (session.provider === MINI_ORCHESTRATOR_PROVIDER) {
    const sessionName = sessionsService.nameUntitledSession(sessionId, content);
    if (sessionName) {
      broadcastSessionName(sessionId, provider, sessionName, connection);
    }
    const { miniOrchestratorRuntime } = await import('@/modules/mini-orchestrator/index.js');
    const result = await miniOrchestratorRuntime.handleMessage({
      sessionId,
      content: effectiveContent,
      options: clientOptions,
      userId,
      connection,
    });
    return result.ok ? result : { ...result, sessionId };
  }

  if (!runtime.hasRuntime(provider)) {
    return {
      ok: false,
      code: 'UNSUPPORTED_PROVIDER',
      error: `Provider "${provider}" is not available.`,
      sessionId,
    };
  }

  const run = chatRunRegistry.startRun({
    appSessionId: sessionId,
    provider,
    providerSessionId: session.provider_session_id,
    connection,
    userId,
  });

  if (!run) {
    return {
      ok: false,
      code: 'RUN_IN_PROGRESS',
      error: `Session "${sessionId}" already has a run in progress.`,
      sessionId,
    };
  }

  // Use the visible message, before project context was prepended to the prompt.
  const sessionName = sessionsService.nameUntitledSession(sessionId, content);
  if (sessionName) {
    broadcastSessionName(sessionId, provider, sessionName, connection);
  }

  // Background LLM title: fires once, for the session's first real message, and
  // only while the name is still auto-derived (never over a user rename or a
  // recovered provider title). The result is applied + broadcast only if the
  // derived name is still in place; otherwise it is dropped.
  if (
    content.trim().length >= MIN_TITLE_CONTENT_LENGTH &&
    isAutoDerivedSessionName(session.custom_name, content) &&
    !titleAttempts.has(sessionId)
  ) {
    titleAttempts.add(sessionId);
    const expectedName =
      sessionName ?? (session.custom_name?.trim() || buildDdagentSessionName(content));
    void generateSessionTitleInBackground(
      sessionId,
      provider,
      content,
      expectedName,
      clientOptions,
      connection,
    );
  }

  // Record what the session's first turn runs with, so reopening it later
  // restores the same model and reasoning effort and the resume path has a
  // session-scoped answer to use.
  //
  // Later turns never rewrite either value: the composer resolves the open
  // session's model over HTTP, so a message sent before that answer lands (or
  // replayed from a queue) carries the per-provider default and would silently
  // switch the session — e.g. a Devin session falling back to SWE-2 Max. An
  // explicit change goes through the active-model/active-effort routes.
  const recordedModel = typeof session.model === 'string' ? session.model.trim() : '';
  if (!recordedModel && typeof clientOptions.model === 'string' && clientOptions.model.trim()) {
    providerModelsService.setSessionModel(provider, sessionId, clientOptions.model);
  }
  const recordedEffort = typeof session.effort === 'string' ? session.effort.trim() : '';
  if (!recordedEffort && typeof clientOptions.effort === 'string' && clientOptions.effort.trim()) {
    providerModelsService.setSessionEffort(provider, sessionId, clientOptions.effort);
  }

  // The session's pinned approval mode follows the same contract: the first
  // send records it, and only `chat.set-permission-mode` changes it later —
  // a composer's stale default or a replayed queue row can never silently
  // flip a session the user deliberately set.
  const recordedPermissionMode =
    typeof session.permission_mode === 'string' ? session.permission_mode.trim() : '';
  const requestedPermissionMode =
    typeof clientOptions.permissionMode === 'string' ? clientOptions.permissionMode.trim() : '';
  if (!recordedPermissionMode && requestedPermissionMode) {
    sessionsDb.setSessionPermissionMode(sessionId, requestedPermissionMode);
  }
  if (recordedPermissionMode) {
    clientOptions.permissionMode = recordedPermissionMode;
  }

  const verifiedAttachments = filterAttachmentsToUploadStore(attachmentCandidates);
  const uniqueAttachments = verifiedAttachments.filter(
    (descriptor, index, all) => all.findIndex((candidate) => candidate.path === descriptor.path) === index,
  );

  // The provider runtimes receive the stable app session id. When their
  // CLI/SDK needs the provider-native id for resume, they resolve it from the
  // session row themselves (sessionsService.resolveProviderSessionId).
  // Brand-new sessions have no provider id yet, so the runtime starts fresh
  // and announces one, which the gateway writer captures and maps back to the
  // app session id.
  // Multi-account: the session's provider_accounts row carries env overrides
  // (e.g. CLAUDE_CONFIG_DIR) that each runtime merges into its child env via
  // providerChildEnv. A deleted account leaves account_id dangling — the
  // session then runs on the provider's ambient environment.
  let accountId = typeof session.account_id === 'string' && session.account_id ? session.account_id : null;
  const failoverSession = () => ({
    sessionId,
    provider,
    accountId,
    providerSessionId: session.provider_session_id ?? null,
    model: session.model ?? (typeof clientOptions.model === 'string' ? clientOptions.model : null),
  });

  // Limit auto-switch (opt-in setting): when the session's account is out of
  // quota — per the last quota sweep or a limit error seen earlier — the turn
  // moves to another account of the SAME provider that still has headroom,
  // even over the user's manual pick. Never switches agents. Awaited only
  // when enabled, so the default path still starts the runtime in the same
  // tick as the run it registered.
  const preTurnSwitch = accountFailoverService.getSettings(provider).autoSwitchOnLimit
    ? await accountFailoverService.prepareTurnAccount(failoverSession()).catch((error: unknown) => {
      console.error('[Chat] Account auto-switch check failed', { sessionId, error });
      return null;
    })
    : null;
  if (preTurnSwitch) {
    accountId = preTurnSwitch.toAccountId;
    run.writer.send(createNormalizedMessage({
      kind: 'status',
      text: describeAccountSwitch(preTurnSwitch),
      sessionId,
      provider,
    }));
    broadcastSessionAccount(sessionId, provider, accountId, connection);
  }

  const accountEnv = accountId ? providerAccountsDb.get(accountId)?.envOverrides ?? null : null;

  const runtimeOptions: AnyRecord = {
    ...clientOptions,
    ...(accountEnv ? { env: accountEnv } : {}),
    // Attachments are re-validated server-side: only direct children of the
    // global upload store may reach provider runtimes or their file tools.
    attachments: uniqueAttachments,
    images: uniqueAttachments.filter(isImageAttachmentDescriptor),
    files: uniqueAttachments.filter((descriptor) => !isImageAttachmentDescriptor(descriptor)),
    sessionId,
    cwd: clientOptions.cwd ?? session.project_path ?? undefined,
    projectPath: session.project_path ?? clientOptions.projectPath,
    // A provider process that outlives this turn (Claude, holding on for
    // background work) can start further turns on its own — a task reporting
    // back. Each gets a chat run of its own so clients show it working and
    // stream it; null while another run owns the session.
    openFollowUpRun: () => chatRunRegistry.startRun({
      appSessionId: sessionId,
      provider,
      providerSessionId: run.providerSessionId ?? session.provider_session_id,
      connection,
      userId,
    })?.writer ?? null,
  };

  // Child→parent delegation status sync: if this session was spawned by an
  // orchestrator as a delegated child, mirror run lifecycle events into its
  // parent's delegation transcript row so parent-session viewers stay current.
  const delegation = orchestratorMessagesDb.findDelegationByChildSessionId(sessionId);
  // Mirrors orchestrator-delegation's answer tracking: a `text` event carries
  // the canonical reply, while cumulative stream snapshots/deltas are the
  // fallback for providers that never emit one.
  let finalText = '';
  let streamBuffer = '';
  if (delegation) {
    const { rowId, parentSessionId } = delegation;
    patchAndPublishDelegation(rowId, parentSessionId, { status: 'running' });
    // Wrap the writer's send to project stream previews into the delegation
    // row. Throttled to 500 ms for stream_delta events (per-token deltas).
    let lastDeltaPatchAt = 0;
    const originalSend = run.writer.send.bind(run.writer) as (data: unknown) => void;
    run.writer.send = (data: unknown) => {
      // Previews track the live turn only; the registry decides what a
      // finished run may still publish (asks, late errors and notices).
      const live = chatRunRegistry.getRun(sessionId) === run && run.status === 'running';
      originalSend(data);
      if (!live) return;
      const event = (data ?? {}) as NormalizedMessage;
      if (event.role === 'user') return;
      if (event.kind === 'text') {
        finalText = (event.content ?? (event as Record<string, unknown>).text ?? '') as string;
      } else if (event.kind === 'stream_replace') {
        streamBuffer = (event.content ?? '') as string;
      } else if (event.kind === 'stream_delta') {
        streamBuffer += (event.content ?? '') as string;
      }
      const preview = delegationPreviewOf(event);
      if (preview) {
        const isDelta = event.kind === 'stream_delta';
        const now = Date.now();
        if (!isDelta || now - lastDeltaPatchAt > 500) {
          if (isDelta) lastDeltaPatchAt = now;
          patchAndPublishDelegation(rowId, parentSessionId, { lastEvent: preview });
        }
      }
    };
  }

  // Watches the turn for a usage/rate-limit hit (an error, or Claude's limit
  // banner reply). The account is benched once the turn ends, and with
  // auto-switch on the session moves so the next message runs elsewhere.
  let limitHit: ReturnType<typeof accountFailoverService.detectLimit> = null;
  const sendBeforeLimitWatch = run.writer.send.bind(run.writer) as (data: unknown) => void;
  run.writer.send = (data: unknown) => {
    sendBeforeLimitWatch(data);
    const event = (data ?? {}) as NormalizedMessage;
    if (limitHit || event.role === 'user') return;
    const text = (event.content ?? (event as Record<string, unknown>).text ?? '') as unknown;
    limitHit = accountFailoverService.detectLimit(event.kind, typeof text === 'string' ? text : '');
  };

  let runError: string | null = null;
  try {
    await runtime.run(provider, effectiveContent, runtimeOptions, run.writer);
    return { ok: true };
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    // A cancelled/completed runtime can reject after the next turn starts.
    // Its terminal event already settled the run; do not emit a session-wide
    // protocol error that the client would attribute to the new turn.
    if (run.status === 'completed' || chatRunRegistry.getRun(sessionId) !== run) {
      // Still the session's latest run (e.g. an early `complete`): surface the
      // failure as a late run-scoped error (C7). The registry drops it when a
      // newer run owns the session, after an abort, or when the same text was
      // already sent for this run.
      if (!run.aborted) {
        run.writer.send(createNormalizedMessage({ kind: 'error', content: message, sessionId, provider }));
      }
      return { ok: true };
    }
    runError = message;
    console.error(`[Chat] Provider runtime "${provider}" failed`, { sessionId, error: message });
    return { ok: false, code: 'RUNTIME_ERROR', error: message, sessionId };
  } finally {
    // Safety net: a runtime that crashed (or resolved) without emitting its
    // terminal `complete` would otherwise leave the session stuck in
    // "processing" forever on every connected client. Scoped to THIS run —
    // a queued message can start the session's next run before this promise
    // settles, and the session-keyed completeRun would kill that new run.
    chatRunRegistry.completeRunIfCurrent(run, { exitCode: 1 });
    if (limitHit) {
      void accountFailoverService.reportLimitHit(failoverSession(), limitHit)
        .then((limitSwitch) => {
          if (limitSwitch) broadcastSessionAccount(sessionId, provider, limitSwitch.toAccountId, connection);
        })
        .catch((error: unknown) => console.error('[Chat] Account auto-switch after limit failed', { sessionId, error }));
    }
    // A superseded child must not overwrite the newer turn’s running preview.
    if (delegation && chatRunRegistry.getRun(sessionId) === run) {
      const { rowId, parentSessionId } = delegation;
      const aborted = run.aborted === true;
      patchAndPublishDelegation(rowId, parentSessionId, {
        status: aborted ? 'aborted' : runError ? 'failed' : 'done',
        ...(runError ? { error: runError } : {}),
        finalText: (finalText || streamBuffer).slice(-2000),
      });
    }
  }
}

/**
 * Hands a message to the session's running turn instead of queueing it behind
 * that turn (mid-turn steering). Used by the queued-messages module for
 * "send now" while a run is live.
 *
 * Returns `true` only when the provider's live turn accepted the message; any
 * other state (no live run, archived session, orchestrated session, a provider
 * that cannot steer) yields `false` and the caller falls back to delivering it
 * as the next turn. Attachments pass the same upload-store trust boundary as
 * `dispatchChatCommand`.
 */
export async function steerChatCommand(
  runtime: ProviderRuntimeGateway,
  input: { sessionId: string; content: string; options: AnyRecord },
): Promise<boolean> {
  const { sessionId, content } = input;
  if (!runtime.steer) return false;

  const run = chatRunRegistry.getRun(sessionId);
  if (!run || run.status !== 'running' || run.aborted) return false;

  const session = sessionsDb.getSessionById(sessionId);
  if (!session || session.isArchived) return false;

  const attachments = filterAttachmentsToUploadStore([
    ...normalizeAttachmentDescriptors(input.options.images),
    ...normalizeAttachmentDescriptors(input.options.files),
    ...normalizeAttachmentDescriptors(input.options.attachments),
  ]).filter((descriptor, index, all) => all.findIndex((candidate) => candidate.path === descriptor.path) === index);
  if (!content.trim() && attachments.length === 0) return false;

  return runtime.steer(run.provider, sessionId, content, {
    images: attachments.filter(isImageAttachmentDescriptor),
    files: attachments.filter((descriptor) => !isImageAttachmentDescriptor(descriptor)),
    cwd: session.project_path ?? undefined,
  });
}

import type { WebSocket } from 'ws';

import { collabPresence, readPresenceViewing, roleAtLeast } from '@/modules/collab/index.js';
import { sessionsDb } from '@/modules/database/index.js';
import { chatRunRegistry } from '@/modules/websocket/services/chat-run-registry.service.js';
import { connectedClients } from '@/modules/websocket/services/websocket-state.service.js';
import {
  dispatchChatCommand,
  filterAttachmentsToUploadStore,
  filterImagesToUploadStore,
  type ProviderRuntimeGateway,
} from '@/modules/websocket/services/chat-dispatch.service.js';
import type {
  AnyRecord,
  AuthenticatedWebSocketRequest,
  LLMProvider,
} from '@/shared/types.js';
import { parseIncomingJsonObject, safeSocketSend } from '@/shared/utils.js';

export { filterAttachmentsToUploadStore, filterImagesToUploadStore };

/** Application boundary for dispatching provider runs and approvals. */
type ChatWebSocketDependencies = {
  /** Central dispatcher for every provider SDK/CLI runtime. */
  runtime: ProviderRuntimeGateway;
  /**
   * Server-side outbound queue. A `chat.send` that loses the race against a
   * run already in progress lands here (same behavior as the composer's
   * busy-path enqueue) instead of dying as a protocol error.
   */
  enqueueMessage?: (input: {
    sessionId: string;
    content: string;
    options: AnyRecord;
    userId: string | number | null;
  }) => void;
};

/**
 * Extracts the authenticated request user id in the formats currently produced
 * by platform and OSS auth code paths.
 */
function readRequestUserId(
  request: AuthenticatedWebSocketRequest | undefined
): string | number | null {
  const user = request?.user;
  if (!user) {
    return null;
  }

  if (typeof user.id === 'string' || typeof user.id === 'number') {
    return user.id;
  }

  if (typeof user.userId === 'string' || typeof user.userId === 'number') {
    return user.userId;
  }

  return null;
}

function sendJson(ws: WebSocket, payload: unknown): void {
  safeSocketSend(ws, JSON.stringify(payload));
}

/**
 * Reports a protocol-level failure to the requesting client.
 *
 * Protocol errors deliberately use their own `kind` (instead of the provider
 * `error` message kind) so the frontend can distinguish "your request was
 * invalid" from "the model run produced an error" without inspecting text.
 */
function sendProtocolError(
  ws: WebSocket,
  code: string,
  error: string,
  sessionId?: string
): void {
  sendJson(ws, {
    kind: 'protocol_error',
    code,
    error,
    sessionId: sessionId ?? null,
    timestamp: new Date().toISOString(),
  });
}

function readRequiredSessionId(data: AnyRecord): string | null {
  const sessionId = typeof data.sessionId === 'string' ? data.sessionId.trim() : '';
  return sessionId.length > 0 ? sessionId : null;
}

/**
 * Handles `presence`: announces what the connected user is viewing. The collab
 * presence service owns the roster and the throttled broadcast — this handler
 * only translates the frame.
 */
function handlePresenceMessage(
  ws: WebSocket,
  request: AuthenticatedWebSocketRequest,
  data: AnyRecord,
): void {
  const userId = readRequestUserId(request);
  if (userId === null) {
    // Presence without an authenticated user is meaningless; drop silently —
    // a protocol error would spam clients on every announce.
    return;
  }

  const username = typeof request.user?.username === 'string'
    ? request.user.username
    : `user-${String(userId)}`;

  collabPresence.update(ws, {
    userId,
    username,
    viewing: readPresenceViewing(data.viewing),
  });
}

/**
 * Handles `chat.send`: delegates to the shared command dispatcher, which
 * resolves the session from the database, registers the run, and awaits the
 * provider runtime. The socket only translates the structured result into a
 * protocol error.
 */
async function handleChatSend(
  ws: WebSocket,
  userId: string | number | null,
  data: AnyRecord,
  dependencies: ChatWebSocketDependencies
): Promise<void> {
  const sessionId = readRequiredSessionId(data);
  if (!sessionId) {
    sendProtocolError(ws, 'SESSION_ID_REQUIRED', 'chat.send requires a sessionId.');
    return;
  }

  const result = await dispatchChatCommand(dependencies.runtime, {
    sessionId,
    content: typeof data.content === 'string' ? data.content : '',
    options: (data.options ?? {}) as AnyRecord,
    userId,
    connection: ws,
  });

  if (!result.ok && result.code === 'RUN_IN_PROGRESS' && dependencies.enqueueMessage) {
    // The send raced a run that is already live — typically the queue's own
    // auto-drain firing right after Stop. Parking the message in the server
    // queue matches the composer's busy path; without it the text would be
    // dropped between the optimistic bubble and a dead-end error row.
    dependencies.enqueueMessage({
      sessionId,
      content: typeof data.content === 'string' ? data.content : '',
      options: (data.options ?? {}) as AnyRecord,
      userId,
    });
    return;
  }

  if (!result.ok) {
    sendProtocolError(ws, result.code, result.error, sessionId);
  }
}

/**
 * Handles `chat.abort`: cancels the run for one app session and emits the
 * terminal `complete` on its behalf (runtimes skip their own complete for
 * aborted runs, and the registry drops any duplicate).
 */
async function handleChatAbort(
  ws: WebSocket,
  data: AnyRecord,
  dependencies: ChatWebSocketDependencies
): Promise<void> {
  const sessionId = readRequiredSessionId(data);
  if (!sessionId) {
    sendProtocolError(ws, 'SESSION_ID_REQUIRED', 'chat.abort requires a sessionId.');
    return;
  }

  const run = chatRunRegistry.getRun(sessionId);
  if (!run || run.status !== 'running') {
    sendProtocolError(ws, 'NO_ACTIVE_RUN', `Session "${sessionId}" has no active run.`, sessionId);
    return;
  }

  const success = await dependencies.runtime.abort(run.provider, sessionId);

  chatRunRegistry.completeRun(sessionId, {
    exitCode: success ? 0 : 1,
    aborted: true,
  });
}

/**
 * Handles `chat.subscribe`: for each requested session, reports whether a run
 * is processing, re-attaches the live stream to this socket, replays missed
 * events (seq > lastSeq), and includes pending permission requests.
 *
 * This single message replaces the old `check-session-status`,
 * `get-pending-permissions`, and Claude-only writer reconnect flows.
 */
function handleChatSubscribe(
  ws: WebSocket,
  data: AnyRecord,
  dependencies: ChatWebSocketDependencies
): void {
  const targets = Array.isArray(data.sessions) ? data.sessions : [];

  for (const target of targets) {
    if (!target || typeof target !== 'object') {
      continue;
    }

    const sessionId = typeof (target as AnyRecord).sessionId === 'string'
      ? ((target as AnyRecord).sessionId as string).trim()
      : '';
    if (!sessionId) {
      continue;
    }

    const lastSeqRaw = (target as AnyRecord).lastSeq;
    const lastSeq = typeof lastSeqRaw === 'number' && Number.isFinite(lastSeqRaw)
      ? Math.max(0, Math.floor(lastSeqRaw))
      : 0;
    const runIdRaw = (target as AnyRecord).runId;
    const runId = typeof runIdRaw === 'string' && runIdRaw ? runIdRaw : null;

    const run = chatRunRegistry.getRun(sessionId);
    const isProcessing = chatRunRegistry.isProcessing(sessionId);

    // This socket watches the session: it gets every live frame from now on,
    // whether the current run was started here, on another client, or by the
    // server-side queue.
    chatRunRegistry.addSessionSubscriber(sessionId, ws);

    // Future live events for this run should land on the socket that asked —
    // this is what makes mid-stream page refreshes work for all providers.
    if (isProcessing) {
      chatRunRegistry.attachConnection(sessionId, ws);
    }

    // Pending approvals are tracked under the app session id inside the
    // Claude runtime, so they can be looked up directly.
    const pendingPermissions = dependencies.runtime.getPendingApprovalsForSession(sessionId);

    sendJson(ws, {
      kind: 'chat_subscribed',
      sessionId,
      isProcessing,
      lastSeq: run?.lastSeq ?? 0,
      runId: run?.id ?? null,
      pendingPermissions,
      timestamp: new Date().toISOString(),
    });

    // Replay only for RUNNING runs, strictly after the ack. Completed runs
    // are fully persisted to the provider transcript and served over REST —
    // replaying them (e.g. after a page reload where the client's lastSeq is
    // 0) would duplicate messages the history fetch already returned.
    if (isProcessing) {
      for (const event of chatRunRegistry.replayEvents(sessionId, { runId, afterSeq: lastSeq })) {
        sendJson(ws, event);
      }
    }
  }
}

/**
 * Handles `chat.permission-response`: forwards a tool-approval decision to the
 * pending approval resolver (Claude is the only provider with interactive
 * approvals today, but the message is intentionally provider-neutral).
 */
function handlePermissionResponse(data: AnyRecord, dependencies: ChatWebSocketDependencies): void {
  if (typeof data.requestId !== 'string' || data.requestId.length === 0) {
    return;
  }

  dependencies.runtime.resolveToolApproval(data.requestId, {
    allow: Boolean(data.allow),
    updatedInput: data.updatedInput,
    message: typeof data.message === 'string' ? data.message : undefined,
    rememberEntry: data.rememberEntry,
  });
}

/**
 * Handles `chat.set-permission-mode`: pushes the client's current permission
 * mode into the provider runtime while a run is in flight. Fire-and-forget —
 * runtimes that cannot apply it live (or sessions without an active run)
 * simply pick the mode up from the next `chat.send` options like before.
 */
function handleSetPermissionMode(data: AnyRecord, dependencies: ChatWebSocketDependencies): void {
  const sessionId = readRequiredSessionId(data);
  const mode = typeof data.permissionMode === 'string' ? data.permissionMode : '';
  if (!sessionId || !mode) {
    return;
  }

  const session = sessionsDb.getSessionById(sessionId);
  if (!session) {
    return;
  }

  dependencies.runtime.setSessionPermissionMode?.(session.provider as LLMProvider, sessionId, mode);
}

/**
 * Handles authenticated chat websocket messages used by the main chat panel.
 *
 * Inbound protocol (client to server):
 * - `chat.send`                { sessionId, content, options? }
 * - `chat.abort`               { sessionId }
 * - `chat.subscribe`           { sessions: [{ sessionId, lastSeq? }] }
 * - `chat.permission-response` { requestId, allow, updatedInput?, message?, rememberEntry? }
 * - `chat.set-permission-mode` { sessionId, permissionMode }
 *
 * Outbound protocol (server to client): every frame is `kind`-based — either
 * a provider `NormalizedMessage` (with `seq`) or a gateway event
 * (`chat_subscribed`, `session_upserted`, `loading_progress`,
 * `protocol_error`).
 */
export function handleChatConnection(
  ws: WebSocket,
  request: AuthenticatedWebSocketRequest,
  dependencies: ChatWebSocketDependencies
): void {
  console.log('[INFO] Chat WebSocket connected');
  connectedClients.add(ws);

  const userId = readRequestUserId(request);

  ws.on('message', async (rawMessage) => {
    try {
      const parsed = parseIncomingJsonObject(rawMessage);
      if (!parsed) {
        throw new Error('Invalid websocket payload');
      }

      const data = parsed as AnyRecord;
      const messageType = typeof data.type === 'string' ? data.type : '';

      switch (messageType) {
        case 'chat.send':
          await handleChatSend(ws, userId, data, dependencies);
          return;
        case 'chat.abort':
          await handleChatAbort(ws, data, dependencies);
          return;
        case 'chat.subscribe':
          handleChatSubscribe(ws, data, dependencies);
          return;
        case 'chat.permission-response':
          // Viewers can watch the board but must not resolve approvals.
          if (!roleAtLeast(request.user?.role, 'member')) {
            sendProtocolError(ws, 'FORBIDDEN_ROLE', 'Requires member role to respond to approvals.');
            return;
          }
          handlePermissionResponse(data, dependencies);
          return;
        case 'chat.set-permission-mode':
          handleSetPermissionMode(data, dependencies);
          return;
        case 'presence':
          handlePresenceMessage(ws, request, data);
          return;
        default:
          sendProtocolError(ws, 'UNKNOWN_MESSAGE_TYPE', `Unknown message type "${messageType}".`);
          return;
      }
    } catch (error) {
      const message = error instanceof Error ? error.message : String(error);
      console.error('[ERROR] Chat WebSocket error:', message);
      sendProtocolError(ws, 'INTERNAL_ERROR', message);
    }
  });

  ws.on('close', () => {
    console.log('[INFO] Chat client disconnected');
    connectedClients.delete(ws);
    chatRunRegistry.removeConnection(ws);
    collabPresence.remove(ws);
  });
}

import { queuedMessagesDb } from '@/modules/database/index.js';
import { createInboxRouter, createQueuedMessagesRouter } from '@/modules/queued-messages/queued-messages.routes.js';
import { createQueuedMessagesService } from '@/modules/queued-messages/queued-messages.service.js';
import { providerRuntimeService } from '@/modules/providers/index.js';
import {
  chatRunRegistry,
  connectedClients,
  dispatchChatCommand,
  steerChatCommand,
  WS_OPEN_STATE,
} from '@/modules/websocket/index.js';
import type { QueuedMessage } from '@/shared/types.js';
import { safeSocketSend } from '@/shared/utils.js';

/** Broadcasts a queue snapshot to every connected client. */
function broadcastQueueUpdate(payload: {
  type: 'queued-messages-updated';
  sessionId: string;
  messages: QueuedMessage[];
}): void {
  const message = JSON.stringify(payload);
  connectedClients.forEach((client) => {
    if (client.readyState === WS_OPEN_STATE) {
      safeSocketSend(client, message);
    }
  });
}

/**
 * Production queued-messages service.
 *
 * Composes the persisted queue with the shared provider runtime dispatcher. A
 * queued send uses the same `dispatchChatCommand` path as a live chat.send, so
 * model/effort persistence and attachment validation behave identically.
 */
/** Consumed by the REST router below and by the chat websocket handler, which enqueues a `chat.send` that loses the race against a run already in progress. */
export const queuedMessagesService = createQueuedMessagesService({
  repository: queuedMessagesDb,
  runs: chatRunRegistry,
  dispatch: async (input) => {
    const result = await dispatchChatCommand(providerRuntimeService, {
      sessionId: input.sessionId,
      content: input.content,
      options: input.options,
      userId: input.userId,
      connection: input.connection as never,
    });
    return result.ok ? { ok: true } : { ok: false, error: result.error };
  },
  // "Send now" during a live turn: providers that read input mid-turn take it
  // right away; the rest fall back to the next turn.
  steer: (input) => steerChatCommand(providerRuntimeService, input),
  // The run's writer wraps the live socket — hand the socket itself, not
  // the writer (it has no readyState and would be a dead delivery target).
  findConnection: (sessionId) => chatRunRegistry.getRun(sessionId)?.writer.ws ?? null,
  broadcast: broadcastQueueUpdate,
});

/** Queued-messages router mounted by the server entrypoint at `/api/queue`. */
export const queuedMessagesRoutes = createQueuedMessagesRouter(queuedMessagesService);

/** Agent-inbox router mounted by the server entrypoint at `/api/sessions`. */
export const inboxRoutes = createInboxRouter(queuedMessagesService);

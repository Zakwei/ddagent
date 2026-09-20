// queuedMessagesRoutes: used by the server entrypoint to mount the persisted outbound queue at `/api/queue`.
// queuedMessagesService: used by the server entrypoint to hand `chat.send`-while-busy messages to the queue.
export { queuedMessagesRoutes, queuedMessagesService } from './queued-messages.module.js';

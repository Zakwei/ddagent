export { WS_OPEN_STATE, connectedClients } from './services/websocket-state.service.js';
export { createWebSocketServer } from './services/websocket-server.service.js';
// WebSocketServerDependencies: used by the composition root (server/services.ts)
// to build the gateway deps separately from the HTTP server that hosts them.
export type { WebSocketServerDependencies } from './services/websocket-server.service.js';
export { chatRunRegistry } from './services/chat-run-registry.service.js';
// steerChatCommand: used by the queued-messages module so "send now" reaches a live turn.
export { dispatchChatCommand, steerChatCommand } from './services/chat-dispatch.service.js';
// ProviderRuntimeGateway: used by provider-accounts tests to fake the runtime.
export type { ProviderRuntimeGateway } from './services/chat-dispatch.service.js';

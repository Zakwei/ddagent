// createSharedContextRouter: mounted at /api/shared-context by services.ts.
export { createSharedContextRouter } from './shared-context.routes.js';
// buildSharedContextPrefix: used by chat-dispatch to prepend shared memory to
// a session's first outbound message.
export { buildSharedContextPrefix } from './shared-context.service.js';

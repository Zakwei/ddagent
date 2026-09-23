import { createCollabRouter } from './collab.routes.js';
import { createPresenceService } from './presence.service.js';

/**
 * Collab router exposing `GET /users` and `GET /activity` — mounted by the
 * server entrypoint behind authenticateToken (at `/api`, optionally also
 * `/api/collab`).
 */
export const collabRoutes = createCollabRouter();

/**
 * Shared presence registry consumed by the chat websocket handler: clients
 * announce `presence` frames, the service broadcasts the throttled
 * `presence-roster` back to announcing connections.
 */
export const collabPresence = createPresenceService();

// readPresenceViewing: used by the websocket module to sanitize presence frames.
export { readPresenceViewing } from './presence.service.js';
// requireRole / roleAtLeast: viewer|member|owner gating for REST routes and the websocket approval path.
export { requireRole, roleAtLeast } from './require-role.js';
// PresenceService: used by tests and the websocket handler for typing.
export type { PresenceService } from './presence.service.js';
// Collab migration functions: wired into the database migration runner by the
// coordinator (they cannot live in the database module without editing shared
// migration files).
export { addUserRoleColumn, addCardAssigneeColumn, applyCollabSchema } from './collab-migrations.js';

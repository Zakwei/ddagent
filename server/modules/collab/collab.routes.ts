import { randomUUID } from 'node:crypto';

import express from 'express';

import { activityEventsDb, collabInvitesDb, userDb } from '@/modules/database/index.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';
import type { ActivityEventsRepository, CollabUserSummary } from '@/shared/types.js';

import { requireRole } from './require-role.js';

type CollabRouteDeps = {
  users: Pick<typeof userDb, 'listActiveUsers'>;
  activity: Pick<ActivityEventsRepository, 'listByProject'>;
  invites?: Pick<typeof collabInvitesDb, 'create'>;
};

function readRequiredString(value: unknown, name: string): string {
  const parsed = typeof value === 'string' ? value.trim() : '';
  if (!parsed) {
    throw new AppError(`${name} is required`, {
      code: 'INVALID_REQUEST_QUERY',
      statusCode: 400,
    });
  }
  return parsed;
}

function readOptionalLimit(value: unknown): number | undefined {
  if (value === undefined) {
    return undefined;
  }
  const parsed = Number(value);
  return Number.isInteger(parsed) && parsed > 0 ? parsed : undefined;
}

function toUserSummary(user: { id: number; username: string; role: string; git_name: string | null }): CollabUserSummary {
  return {
    id: user.id,
    username: user.username,
    role: user.role,
    displayName: user.git_name?.trim() || user.username,
  };
}

/**
 * Collaboration HTTP routes: the user list that feeds assignee pickers and
 * the per-project activity feed.
 *
 * The coordinator mounts this router at `/api` (behind authenticateToken),
 * which exposes `GET /api/users` and `GET /api/activity?projectId=` — the
 * paths the frontend calls. Mounting the same router again at `/api/collab`
 * additionally exposes the namespaced aliases; the router only owns these
 * two paths so neither mount can shadow an existing route.
 */
export function createCollabRouter(
  deps: CollabRouteDeps = { users: userDb, activity: activityEventsDb, invites: collabInvitesDb },
): express.Router {
  const router = express.Router();

  /**
   * POST /invites — owner mints a single-use registration link.
   * Body: { role?: 'member' | 'viewer', ttlHours?: number } (defaults member / 72h).
   * The plaintext token is returned once; share it as `?invite=<token>` on the
   * register page.
   */
  router.post(
    '/invites',
    requireRole('owner'),
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const role = body.role === 'viewer' ? 'viewer' : 'member';
      const ttlHours = Number.isFinite(Number(body.ttlHours)) && Number(body.ttlHours) > 0
        ? Math.min(Number(body.ttlHours), 24 * 30)
        : 72;
      const actor = (req as express.Request & { user?: { id?: number | string } }).user;
      const expiresAt = new Date(Date.now() + ttlHours * 3600_000).toISOString();
      const invite = deps.invites!.create({
        id: randomUUID(),
        token: randomUUID(),
        role,
        createdBy: actor?.id === undefined ? null : Number(actor.id),
        expiresAt,
      });
      res.status(201).json(createApiSuccessResponse({ invite }));
    }),
  );

  router.get(
    '/users',
    asyncHandler(async (_req, res) => {
      const users = deps.users.listActiveUsers().map(toUserSummary);
      res.json(createApiSuccessResponse({ users }));
    }),
  );

  router.get(
    '/activity',
    asyncHandler(async (req, res) => {
      const projectId = readRequiredString(req.query.projectId, 'projectId');
      const events = deps.activity.listByProject(projectId, readOptionalLimit(req.query.limit));
      res.json(createApiSuccessResponse({ events }));
    }),
  );

  return router;
}

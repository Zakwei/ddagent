import type express from 'express';

import { AppError } from '@/shared/utils.js';

const ROLE_RANK: Record<string, number> = {
  viewer: 1,
  member: 2,
  owner: 3,
};

type RoleRequest = express.Request & { user?: { role?: string } };

/**
 * Gates a route on the caller's users.role (populated by authenticateToken).
 * `requireRole('member')` admits member and owner; viewers get 403.
 * Unknown/missing roles fail closed.
 */
export function requireRole(minimum: 'viewer' | 'member' | 'owner') {
  return (req: express.Request, _res: express.Response, next: express.NextFunction) => {
    const rank = ROLE_RANK[(req as RoleRequest).user?.role ?? ''] ?? 0;
    if (rank < ROLE_RANK[minimum]) {
      throw new AppError(`Requires ${minimum} role`, {
        code: 'FORBIDDEN_ROLE',
        statusCode: 403,
      });
    }
    next();
  };
}

/** Same check for the WebSocket path, where request.user carries `role`. */
export function roleAtLeast(role: unknown, minimum: 'viewer' | 'member' | 'owner'): boolean {
  return (ROLE_RANK[typeof role === 'string' ? role : ''] ?? 0) >= ROLE_RANK[minimum];
}

import { randomUUID } from 'node:crypto';

import express, { type Request, type Response } from 'express';

import { schedulesDb, type Schedule } from '@/modules/database/index.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

import { isValidCronExpression, nextCronTime } from './scheduler.service.js';

const KNOWN_PROVIDERS: readonly string[] = ['claude', 'codex', 'cursor', 'opencode', 'devin'];

const readIdParam = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (Array.isArray(value) && typeof value[0] === 'string') return value[0];
  throw new AppError('id path parameter is invalid.', {
    code: 'INVALID_PATH_PARAMETER',
    statusCode: 400,
  });
};

const readString = (value: unknown, field: string): string => {
  if (typeof value === 'string' && value.trim()) return value.trim();
  throw new AppError(`${field} is required.`, {
    code: 'VALIDATION_ERROR',
    statusCode: 400,
  });
};

const readProvider = (value: unknown): string => {
  const normalized = readString(value, 'provider').toLowerCase();
  if (!KNOWN_PROVIDERS.includes(normalized)) {
    throw new AppError(`Unsupported provider "${normalized}".`, {
      code: 'UNSUPPORTED_PROVIDER',
      statusCode: 400,
    });
  }
  return normalized;
};

const readCron = (value: unknown): string => {
  const cron = readString(value, 'cron');
  if (!isValidCronExpression(cron)) {
    throw new AppError(`Invalid cron expression "${cron}". Expected 5 fields: min hour day month weekday.`, {
      code: 'INVALID_CRON',
      statusCode: 400,
    });
  }
  return cron;
};

const toClient = (schedule: Schedule) => ({
  ...schedule,
  nextRunAt: schedule.nextRunAt,
});

/**
 * `/api/schedules` — CRUD + run-now + run history for recurring agent runs.
 * `nextRunAt` is materialized on every write so the ticker never re-parses.
 */
export function createSchedulerRouter() {
  const router = express.Router();

  router.get(
    '/',
    asyncHandler(async (_req: Request, res: Response) => {
      res.json(createApiSuccessResponse({ schedules: schedulesDb.list().map(toClient) }));
    }),
  );

  // Human-readable preview used by the create dialog.
  router.get(
    '/preview',
    asyncHandler(async (req: Request, res: Response) => {
      const cron = readCron(req.query.cron);
      const next = nextCronTime(cron, new Date());
      res.json(createApiSuccessResponse({ cron, nextRunAt: next?.toISOString() ?? null }));
    }),
  );

  router.post(
    '/',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const cron = readCron(body.cron);
      const schedule = schedulesDb.create({
        id: randomUUID(),
        projectId: readString(body.projectId, 'projectId'),
        provider: readProvider(body.provider),
        cron,
        prompt: readString(body.prompt, 'prompt'),
        useWorktree: body.useWorktree === true,
        catchUp: body.catchUp === true,
        enabled: body.enabled !== false,
        nextRunAt: body.enabled === false ? null : nextCronTime(cron, new Date())?.toISOString() ?? null,
      });
      res.status(201).json(createApiSuccessResponse({ schedule: toClient(schedule) }));
    }),
  );

  router.patch(
    '/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const id = readIdParam(req.params.id);
      const existing = schedulesDb.get(id);
      if (!existing) {
        throw new AppError('Schedule not found.', { code: 'NOT_FOUND', statusCode: 404 });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const cron = body.cron !== undefined ? readCron(body.cron) : existing.cron;
      const enabled = body.enabled !== undefined ? body.enabled === true : existing.enabled;
      const schedule = schedulesDb.update(id, {
        projectId: body.projectId !== undefined ? readString(body.projectId, 'projectId') : undefined,
        provider: body.provider !== undefined ? readProvider(body.provider) : undefined,
        cron,
        prompt: body.prompt !== undefined ? readString(body.prompt, 'prompt') : undefined,
        useWorktree: body.useWorktree !== undefined ? body.useWorktree === true : undefined,
        catchUp: body.catchUp !== undefined ? body.catchUp === true : undefined,
        enabled,
        failCount: body.enabled === true ? 0 : undefined,
        nextRunAt: enabled ? nextCronTime(cron, new Date())?.toISOString() ?? null : null,
      });
      res.json(createApiSuccessResponse({ schedule: schedule ? toClient(schedule) : null }));
    }),
  );

  router.delete(
    '/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const id = readIdParam(req.params.id);
      if (!schedulesDb.remove(id)) {
        throw new AppError('Schedule not found.', { code: 'NOT_FOUND', statusCode: 404 });
      }
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // Fires immediately, independent of the cron timetable. The interval loop
  // picks the row up through the same `fire` path.
  router.post(
    '/:id/run-now',
    asyncHandler(async (req: Request, res: Response) => {
      const id = readIdParam(req.params.id);
      const schedule = schedulesDb.get(id);
      if (!schedule) {
        throw new AppError('Schedule not found.', { code: 'NOT_FOUND', statusCode: 404 });
      }
      // Lazy import to avoid a route-module → module-entrypoint cycle at startup.
      const { schedulerService } = await import('./index.js');
      await schedulerService.fire(schedule);
      res.json(createApiSuccessResponse({ schedule: toClient(schedulesDb.get(id) as Schedule) }));
    }),
  );

  router.get(
    '/:id/runs',
    asyncHandler(async (req: Request, res: Response) => {
      const id = readIdParam(req.params.id);
      const limitRaw = Number(req.query.limit ?? 50);
      const limit = Number.isInteger(limitRaw) && limitRaw > 0 ? Math.min(limitRaw, 200) : 50;
      res.json(createApiSuccessResponse({ runs: schedulesDb.listRuns(id, limit) }));
    }),
  );

  return router;
}

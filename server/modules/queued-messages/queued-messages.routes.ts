import express from 'express';

import type { QueuedMessagesService } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

type AuthenticatedRequest = express.Request & {
  user?: { id?: string | number; userId?: string | number };
};

function readRequiredSessionId(value: unknown): string {
  const sessionId = typeof value === 'string' ? value.trim() : '';
  if (!sessionId) {
    throw new AppError('sessionId is required', {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }
  return sessionId;
}

function readRequiredId(value: unknown): number {
  const id = typeof value === 'number' ? value : Number(value);
  if (!Number.isInteger(id) || id <= 0) {
    throw new AppError('A valid queued message id is required', {
      code: 'INVALID_QUEUED_MESSAGE_ID',
      statusCode: 400,
    });
  }
  return id;
}

function readOptions(value: unknown): Record<string, unknown> {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    return {};
  }
  return value as Record<string, unknown>;
}

/**
 * Builds the queued-messages HTTP router around an injected service.
 *
 * Routes only parse transport input, call the service, and format responses;
 * queue ordering and provider dispatch stay in the service.
 */
export function createQueuedMessagesRouter(service: QueuedMessagesService): express.Router {
  const router = express.Router();

  router.get(
    '/',
    asyncHandler(async (req, res) => {
      const sessionId = readRequiredSessionId(req.query.sessionId);
      res.json(createApiSuccessResponse({ messages: service.list(sessionId) }));
    }),
  );

  router.post(
    '/',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const sessionId = readRequiredSessionId(body.sessionId);
      const content = typeof body.content === 'string' ? body.content : '';
      if (!content.trim()) {
        throw new AppError('content is required', { code: 'INVALID_REQUEST_BODY', statusCode: 400 });
      }

      const user = (req as AuthenticatedRequest).user;
      const userId = user?.id ?? user?.userId ?? null;

      const message = service.enqueue({
        userId,
        sessionId,
        content,
        options: readOptions(body.options),
      });

      res.status(201).json(createApiSuccessResponse({ message }));
    }),
  );

  router.post(
    '/:id/send-now',
    asyncHandler(async (req, res) => {
      const id = readRequiredId(req.params.id);
      const message = await service.sendNow(id);
      res.json(createApiSuccessResponse({ message }));
    }),
  );

  router.delete(
    '/:id',
    asyncHandler(async (req, res) => {
      const id = readRequiredId(req.params.id);
      service.remove(id);
      res.json(createApiSuccessResponse({ removed: true }));
    }),
  );

  return router;
}

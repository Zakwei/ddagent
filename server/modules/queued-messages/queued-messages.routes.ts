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

  // Broadcast: enqueue the same content into many sessions at once. Each
  // session drains independently — per-session results let the UI show which
  // targets accepted the message.
  router.post(
    '/broadcast',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const sessionIds = Array.isArray(body.sessionIds)
        ? body.sessionIds.filter((id): id is string => typeof id === 'string' && id.trim() !== '')
        : [];
      if (sessionIds.length === 0) {
        throw new AppError('sessionIds must be a non-empty array', {
          code: 'INVALID_REQUEST_BODY',
          statusCode: 400,
        });
      }
      const content = typeof body.content === 'string' ? body.content : '';
      if (!content.trim()) {
        throw new AppError('content is required', { code: 'INVALID_REQUEST_BODY', statusCode: 400 });
      }

      const user = (req as AuthenticatedRequest).user;
      const userId = user?.id ?? user?.userId ?? null;
      const options = readOptions(body.options);

      const results = sessionIds.map((sessionId) => {
        try {
          const message = service.enqueue({ userId, sessionId, content, options });
          return { sessionId, ok: true as const, messageId: message.id };
        } catch (error) {
          return {
            sessionId,
            ok: false as const,
            error: error instanceof Error ? error.message : String(error),
          };
        }
      });

      res.json(createApiSuccessResponse({ results }));
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

const LOOPBACK_PATTERN = /^(127\.|::1|::ffff:127\.)/;

/**
 * Agent inbox: `POST /api/sessions/:id/inbox {text, source}`.
 *
 * Lets tools and other sessions push a message into a session's queue. The
 * `source: 'agent'` marker is restricted to loopback callers — remote clients
 * can only send as 'user' (the default).
 */
export function createInboxRouter(service: QueuedMessagesService): express.Router {
  const router = express.Router();

  router.post(
    '/:sessionId/inbox',
    asyncHandler(async (req, res) => {
      const sessionId = readRequiredSessionId(req.params.sessionId);
      const body = (req.body ?? {}) as Record<string, unknown>;
      const text = typeof body.text === 'string' ? body.text : '';
      if (!text.trim()) {
        throw new AppError('text is required', { code: 'INVALID_REQUEST_BODY', statusCode: 400 });
      }

      const source = typeof body.source === 'string' ? body.source.trim() : '';
      if (source === 'agent' && !LOOPBACK_PATTERN.test(req.ip ?? '')) {
        throw new AppError('source "agent" is restricted to local callers', {
          code: 'INBOX_SOURCE_FORBIDDEN',
          statusCode: 403,
        });
      }

      const user = (req as AuthenticatedRequest).user;
      const message = service.enqueue({
        userId: user?.id ?? user?.userId ?? null,
        sessionId,
        content: source ? `[inbox:${source}]\n${text}` : text,
        options: { ...readOptions(body.options), inboxSource: source || 'user' },
      });

      res.status(201).json(createApiSuccessResponse({ message }));
    }),
  );

  return router;
}

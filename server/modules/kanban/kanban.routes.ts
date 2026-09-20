import express from 'express';

import type { KanbanServices } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

const CARD_STATUSES = ['backlog', 'ready', 'working', 'needs_decision', 'done', 'archived'] as const;
type CardStatus = (typeof CARD_STATUSES)[number];

function readRequiredString(value: unknown, name: string): string {
  const parsed = typeof value === 'string' ? value.trim() : '';
  if (!parsed) {
    throw new AppError(`${name} is required`, {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }
  return parsed;
}

function readOptionalString(value: unknown): string | undefined {
  return typeof value === 'string' ? value : undefined;
}

function readCardStatus(value: unknown): CardStatus {
  const status = typeof value === 'string' ? (value as CardStatus) : ('' as CardStatus);
  if (!CARD_STATUSES.includes(status)) {
    throw new AppError(`status must be one of: ${CARD_STATUSES.join(', ')}`, {
      code: 'INVALID_CARD_STATUS',
      statusCode: 400,
    });
  }
  return status;
}

function readOptionalPosition(value: unknown): number | undefined {
  if (value === undefined || value === null) {
    return undefined;
  }
  const parsed = typeof value === 'number' ? value : Number(value);
  if (!Number.isFinite(parsed)) {
    throw new AppError('position must be a number', {
      code: 'INVALID_CARD_POSITION',
      statusCode: 400,
    });
  }
  return parsed;
}

/**
 * Builds the Kanban HTTP router around an injected application-service API.
 *
 * Keeping construction explicit lets route tests supply deterministic services
 * and keeps parsing the route layer's only responsibility.
 */
export function createKanbanRouter(services: KanbanServices): express.Router {
  const router = express.Router();

  router.get(
    '/board-config',
    asyncHandler(async (req, res) => {
      const projectId = readRequiredString(req.query.project, 'project');
      const boardConfig = services.getBoardConfig(projectId);
      res.json(createApiSuccessResponse({ boardConfig }));
    }),
  );

  router.put(
    '/board-config',
    asyncHandler(async (req, res) => {
      const body = req.body as Record<string, unknown>;
      const boardConfig = services.saveBoardConfig(
        readRequiredString(body.projectId, 'projectId'),
        {
          provider: readOptionalString(body.provider) as never,
          model: body.model === null ? null : readOptionalString(body.model),
          effort: body.effort === null ? null : readOptionalString(body.effort),
        },
      );
      res.json(createApiSuccessResponse({ boardConfig }));
    }),
  );

  router.get(
    '/cards',
    asyncHandler(async (req, res) => {
      const projectId = readRequiredString(req.query.project, 'project');
      const includeArchived = req.query.includeArchived === '1';
      const cards = services.listCards(projectId, { includeArchived });
      res.json(createApiSuccessResponse({ cards }));
    }),
  );

  router.post(
    '/cards',
    asyncHandler(async (req, res) => {
      const body = req.body as Record<string, unknown>;
      const card = services.createCard({
        projectId: readRequiredString(body.projectId, 'projectId'),
        title: readRequiredString(body.title, 'title'),
        description: readOptionalString(body.description),
        provider: readOptionalString(body.provider) as never,
        model: readOptionalString(body.model),
        effort: readOptionalString(body.effort),
      });
      res.status(201).json(createApiSuccessResponse({ card }));
    }),
  );

  router.patch(
    '/cards/:cardId',
    asyncHandler(async (req, res) => {
      const body = req.body as Record<string, unknown>;
      const card = services.updateCard(readRequiredString(req.params.cardId, 'cardId'), {
        title: readOptionalString(body.title),
        description: readOptionalString(body.description),
        provider: readOptionalString(body.provider) as never,
        model: readOptionalString(body.model),
        effort: readOptionalString(body.effort),
        position: readOptionalPosition(body.position),
      });
      res.json(createApiSuccessResponse({ card }));
    }),
  );

  router.post(
    '/cards/:cardId/move',
    asyncHandler(async (req, res) => {
      const body = req.body as Record<string, unknown>;
      const result = await services.moveCard(
        readRequiredString(req.params.cardId, 'cardId'),
        readCardStatus(body.status),
        readOptionalPosition(body.position),
      );
      res.json(createApiSuccessResponse(result));
    }),
  );

  router.post(
    '/cards/:cardId/abort',
    asyncHandler(async (req, res) => {
      const card = await services.abortCard(readRequiredString(req.params.cardId, 'cardId'));
      res.json(createApiSuccessResponse({ card }));
    }),
  );

  router.delete(
    '/cards/:cardId',
    asyncHandler(async (req, res) => {
      services.deleteCard(readRequiredString(req.params.cardId, 'cardId'));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  return router;
}

/**
 * Builds the token-guarded agent callback router.
 *
 * This is mounted separately from the authenticated router: the agent has no
 * JWT, so the per-card report token embedded in its kickoff prompt is the only
 * credential the report endpoint requires.
 */
export function createKanbanReportRouter(services: KanbanServices): express.Router {
  const router = express.Router();

  router.post(
    '/report',
    asyncHandler(async (req, res) => {
      const body = req.body as Record<string, unknown>;
      const status = readRequiredString(body.status, 'status');
      if (status !== 'working' && status !== 'needs_decision' && status !== 'done') {
        throw new AppError('status must be one of: working, needs_decision, done', {
          code: 'INVALID_CARD_STATUS',
          statusCode: 400,
        });
      }

      const card = services.reportCardByToken({
        cardId: readRequiredString(body.cardId, 'cardId'),
        token: readRequiredString(body.token, 'token'),
        status,
        message: readOptionalString(body.message),
        prUrl: readOptionalString(body.prUrl),
      });
      res.json(createApiSuccessResponse({ card }));
    }),
  );

  return router;
}

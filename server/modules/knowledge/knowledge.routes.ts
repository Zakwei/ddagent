import express, { type Request, type Response } from 'express';

import {
  type KnowledgeEntityKind,
  knowledgeService,
} from '@/modules/knowledge/knowledge.service.js';
import { knowledgeScanService } from '@/modules/knowledge/services/knowledge-scan.service.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

const SEARCH_ENTITY_TYPES: readonly KnowledgeEntityKind[] = ['memory', 'rule', 'skill', 'personal'];

const readIdParam = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (Array.isArray(value) && typeof value[0] === 'string') return value[0];
  throw new AppError('id path parameter is invalid.', {
    code: 'INVALID_PATH_PARAMETER',
    statusCode: 400,
  });
};

const readOptionalString = (value: unknown): string | undefined => {
  if (typeof value !== 'string') return undefined;
  const trimmed = value.trim();
  return trimmed ? trimmed : undefined;
};

const readBooleanQuery = (value: unknown): boolean | undefined =>
  value === 'true' ? true : undefined;

const readNumberQuery = (value: unknown): number | undefined => {
  if (typeof value !== 'string') return undefined;
  const trimmed = value.trim();
  if (!trimmed) return undefined;
  const parsed = Number(trimmed);
  return Number.isFinite(parsed) ? parsed : undefined;
};

const readProjectIdQuery = (value: unknown): string | null | undefined => {
  const trimmed = typeof value === 'string' ? value.trim() : '';
  if (!trimmed) return undefined;
  if (trimmed === 'global') return null;
  return trimmed;
};

const readCommaSeparatedQuery = (value: unknown): string[] | undefined => {
  const raw = readOptionalString(value);
  if (!raw) return undefined;
  return raw
    .split(',')
    .map((entry) => entry.trim())
    .filter((entry) => entry.length > 0);
};

/**
 * Knowledge-base CRUD/search/graph endpoints.
 *
 * Thin transport layer only: parse/validate query and params, delegate every
 * read and write to `knowledgeService` (which owns all validation), and shape
 * the response envelope.
 */
export function createKnowledgeRouter() {
  const router = express.Router();

  // -------------------------------------------------------------- memories

  router.get(
    '/memories',
    asyncHandler(async (req: Request, res: Response) => {
      const page = knowledgeService.listMemories({
        projectId: readProjectIdQuery(req.query.projectId),
        includeGlobal: readBooleanQuery(req.query.includeGlobal),
        memoryType: readOptionalString(req.query.memoryType),
        priority: readOptionalString(req.query.priority),
        tag: readOptionalString(req.query.tag),
        limit: readNumberQuery(req.query.limit),
        offset: readNumberQuery(req.query.offset),
      });
      res.json(createApiSuccessResponse({ memories: page.items, total: page.total }));
    }),
  );

  router.post(
    '/memories',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const memory = knowledgeService.createMemory({
        projectId: body.projectId,
        title: body.title,
        content: body.content,
        memoryType: body.memoryType,
        priority: body.priority,
        source: body.source,
        tags: body.tags,
      });
      res.status(201).json(createApiSuccessResponse({ memory }));
    }),
  );

  router.patch(
    '/memories/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const memory = knowledgeService.updateMemory(readIdParam(req.params.id), {
        projectId: body.projectId,
        title: body.title,
        content: body.content,
        memoryType: body.memoryType,
        priority: body.priority,
        source: body.source,
        tags: body.tags,
      });
      res.json(createApiSuccessResponse({ memory }));
    }),
  );

  router.delete(
    '/memories/:id',
    asyncHandler(async (req: Request, res: Response) => {
      knowledgeService.deleteMemory(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // ----------------------------------------------------------------- rules

  router.get(
    '/rules',
    asyncHandler(async (req: Request, res: Response) => {
      const page = knowledgeService.listRules({
        projectId: readProjectIdQuery(req.query.projectId),
        includeGlobal: readBooleanQuery(req.query.includeGlobal),
        enabledOnly: readBooleanQuery(req.query.enabledOnly),
        priority: readOptionalString(req.query.priority),
        limit: readNumberQuery(req.query.limit),
        offset: readNumberQuery(req.query.offset),
      });
      res.json(createApiSuccessResponse({ rules: page.items, total: page.total }));
    }),
  );

  router.post(
    '/rules',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const rule = knowledgeService.createRule({
        projectId: body.projectId,
        title: body.title,
        content: body.content,
        priority: body.priority,
        enabled: body.enabled,
      });
      res.status(201).json(createApiSuccessResponse({ rule }));
    }),
  );

  router.patch(
    '/rules/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const rule = knowledgeService.updateRule(readIdParam(req.params.id), {
        projectId: body.projectId,
        title: body.title,
        content: body.content,
        priority: body.priority,
        enabled: body.enabled,
      });
      res.json(createApiSuccessResponse({ rule }));
    }),
  );

  router.delete(
    '/rules/:id',
    asyncHandler(async (req: Request, res: Response) => {
      knowledgeService.deleteRule(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // ---------------------------------------------------------------- skills

  router.get(
    '/skills',
    asyncHandler(async (req: Request, res: Response) => {
      const page = knowledgeService.listSkills({
        category: readOptionalString(req.query.category),
        limit: readNumberQuery(req.query.limit),
        offset: readNumberQuery(req.query.offset),
      });
      res.json(createApiSuccessResponse({ skills: page.items, total: page.total }));
    }),
  );

  router.post(
    '/skills',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const skill = knowledgeService.createSkill({
        name: body.name,
        description: body.description,
        content: body.content,
        category: body.category,
        icon: body.icon,
      });
      res.status(201).json(createApiSuccessResponse({ skill }));
    }),
  );

  router.patch(
    '/skills/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const skill = knowledgeService.updateSkill(readIdParam(req.params.id), {
        name: body.name,
        description: body.description,
        content: body.content,
        category: body.category,
        icon: body.icon,
      });
      res.json(createApiSuccessResponse({ skill }));
    }),
  );

  router.delete(
    '/skills/:id',
    asyncHandler(async (req: Request, res: Response) => {
      knowledgeService.deleteSkill(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // -------------------------------------------------------------- personal

  router.get(
    '/personal',
    asyncHandler(async (req: Request, res: Response) => {
      const page = knowledgeService.listPersonal({
        limit: readNumberQuery(req.query.limit),
        offset: readNumberQuery(req.query.offset),
      });
      res.json(createApiSuccessResponse({ personal: page.items, total: page.total }));
    }),
  );

  router.post(
    '/personal',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const personalInformation = knowledgeService.createPersonal({
        key: body.key,
        title: body.title,
        content: body.content,
      });
      res.status(201).json(createApiSuccessResponse({ personalInformation }));
    }),
  );

  router.patch(
    '/personal/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const personalInformation = knowledgeService.updatePersonal(readIdParam(req.params.id), {
        key: body.key,
        title: body.title,
        content: body.content,
      });
      res.json(createApiSuccessResponse({ personalInformation }));
    }),
  );

  router.delete(
    '/personal/:id',
    asyncHandler(async (req: Request, res: Response) => {
      knowledgeService.deletePersonal(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // ------------------------------------------------------------------ tags

  router.get(
    '/tags',
    asyncHandler(async (_req: Request, res: Response) => {
      res.json(createApiSuccessResponse({ tags: knowledgeService.listTags() }));
    }),
  );

  router.delete(
    '/tags/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const rawId = readIdParam(req.params.id).trim();
      if (!/^\d+$/.test(rawId)) {
        throw new AppError('tag id path parameter is invalid.', {
          code: 'INVALID_PATH_PARAMETER',
          statusCode: 400,
        });
      }
      knowledgeService.deleteTag(Number.parseInt(rawId, 10));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // ----------------------------------------------------------- connections

  router.get(
    '/connections',
    asyncHandler(async (req: Request, res: Response) => {
      const connections = knowledgeService.listConnections({
        entityId: readOptionalString(req.query.entityId),
        limit: readNumberQuery(req.query.limit),
      });
      res.json(createApiSuccessResponse({ connections }));
    }),
  );

  router.post(
    '/connections',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const connection = knowledgeService.createConnection({
        sourceId: body.sourceId,
        sourceType: body.sourceType,
        targetId: body.targetId,
        targetType: body.targetType,
        relationship: body.relationship,
        weight: body.weight,
      });
      res.status(201).json(createApiSuccessResponse({ connection }));
    }),
  );

  router.delete(
    '/connections/:id',
    asyncHandler(async (req: Request, res: Response) => {
      knowledgeService.deleteConnection(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  // --------------------------------------------------------------- history

  router.get(
    '/history',
    asyncHandler(async (req: Request, res: Response) => {
      const history = knowledgeService.listHistory({
        entityType: readOptionalString(req.query.entityType),
        entityId: readOptionalString(req.query.entityId),
        limit: readNumberQuery(req.query.limit),
      });
      res.json(createApiSuccessResponse({ history }));
    }),
  );

  // ---------------------------------------------------------------- search

  router.get(
    '/search',
    asyncHandler(async (req: Request, res: Response) => {
      const q = readOptionalString(req.query.q);
      if (!q) {
        throw new AppError('q is required.', { code: 'INVALID_QUERY', statusCode: 400 });
      }
      const type = readOptionalString(req.query.type);
      if (type !== undefined && !(SEARCH_ENTITY_TYPES as readonly string[]).includes(type)) {
        throw new AppError(`type must be one of ${SEARCH_ENTITY_TYPES.join(', ')}.`, {
          code: 'INVALID_QUERY',
          statusCode: 400,
        });
      }
      const results = knowledgeService.search(q, {
        entityType: type as KnowledgeEntityKind | undefined,
        projectId: readProjectIdQuery(req.query.projectId),
        limit: readNumberQuery(req.query.limit),
      });
      res.json(createApiSuccessResponse({ results }));
    }),
  );

  // ----------------------------------------------------------------- graph

  router.get(
    '/graph',
    asyncHandler(async (req: Request, res: Response) => {
      const graph = knowledgeService.graph({
        projectId: readProjectIdQuery(req.query.projectId),
        entityTypes: readCommaSeparatedQuery(req.query.types),
        limit: readNumberQuery(req.query.limit),
      });
      res.json(createApiSuccessResponse({ graph }));
    }),
  );

  // ----------------------------------------------------------- stats/io

  router.get(
    '/stats',
    asyncHandler(async (_req: Request, res: Response) => {
      res.json(createApiSuccessResponse(knowledgeService.stats()));
    }),
  );

  router.get(
    '/export',
    asyncHandler(async (_req: Request, res: Response) => {
      res.json(createApiSuccessResponse(knowledgeService.exportAll()));
    }),
  );

  router.post(
    '/import',
    asyncHandler(async (req: Request, res: Response) => {
      const imported = knowledgeService.importAll(req.body);
      res.status(201).json(createApiSuccessResponse({ imported }));
    }),
  );

  // --------------------------------------------------------------- scan

  router.post(
    '/scan',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const projectId = readOptionalString(body.projectId);
      if (!projectId) {
        throw new AppError('projectId is required.', { code: 'INVALID_REQUEST', statusCode: 400 });
      }
      const result = await knowledgeScanService.scanProject(projectId);
      res.json(createApiSuccessResponse(result));
    }),
  );

  return router;
}

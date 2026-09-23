import express from 'express';

import { projectsDb } from '@/modules/database/index.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

import { readSharedContext, writeSharedContext } from './shared-context.service.js';

function resolveProjectPath(projectId: unknown): string {
  const id = typeof projectId === 'string' ? projectId.trim() : '';
  if (!id) {
    throw new AppError('project is required', { code: 'INVALID_REQUEST', statusCode: 400 });
  }
  const projectPath = projectsDb.getProjectPathById(id);
  if (!projectPath) {
    throw new AppError(`Project "${id}" was not found`, {
      code: 'PROJECT_NOT_FOUND',
      statusCode: 404,
    });
  }
  return projectPath;
}

/**
 * Thin HTTP layer over the shared-context file store: GET returns the current
 * document (or null fields when absent), PUT replaces it.
 */
export function createSharedContextRouter(): express.Router {
  const router = express.Router();

  router.get(
    '/',
    asyncHandler(async (req, res) => {
      const projectPath = resolveProjectPath(req.query.project);
      const doc = await readSharedContext(projectPath);
      res.json(createApiSuccessResponse(doc ?? { content: '', updatedAt: null }));
    }),
  );

  router.put(
    '/',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const projectPath = resolveProjectPath(body.project);
      const content = typeof body.content === 'string' ? body.content : '';
      const doc = await writeSharedContext(projectPath, content);
      res.json(createApiSuccessResponse(doc));
    }),
  );

  return router;
}

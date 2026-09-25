import express from 'express';

import type { OrchestratorConfigService } from '@/modules/orchestrator/services/orchestrator-config.service.js';
import type { AnyRecord, LLMProvider } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse, ORCHESTRATOR_PROVIDER } from '@/shared/utils.js';

type PlanConfirmHandler = (
  sessionId: string,
  steps: unknown,
  options: AnyRecord,
) => Promise<{ ok: true } | { ok: false; code: string; error: string }>;

function readConfigBody(value: unknown): unknown {
  if (!value || typeof value !== 'object' || Array.isArray(value)) {
    throw new AppError('config body must be an object', {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }
  return value;
}

/**
 * Orchestrator HTTP router mounted at `/api/orchestrator`.
 *
 * Routes only parse transport input and delegate to the config service;
 * routing and dispatch logic live in the orchestrator services.
 */
export function createOrchestratorRouter(
  config: OrchestratorConfigService,
  handlers: { confirmPlan?: PlanConfirmHandler } = {},
): express.Router {
  const router = express.Router();

  router.get(
    '/config',
    asyncHandler(async (_req, res) => {
      res.json(createApiSuccessResponse({ config: config.get() }));
    }),
  );

  router.put(
    '/config',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const updated = config.put(readConfigBody(body.config));
      res.json(createApiSuccessResponse({ config: updated }));
    }),
  );

  /**
   * Allocates a stable app session id for a new orchestrated ("Auto") chat —
   * the counterpart of POST /api/providers/sessions for real providers. The
   * row carries provider='orchestrator' so dispatch/history route through the
   * orchestrator instead of a provider runtime.
   */
  router.post(
    '/sessions',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const projectPath = typeof body.projectPath === 'string' ? body.projectPath.trim() : '';
      if (!projectPath) {
        throw new AppError('projectPath is required', {
          code: 'PROJECT_PATH_REQUIRED',
          statusCode: 400,
        });
      }
      const initialMessage = typeof body.initialMessage === 'string' ? body.initialMessage : '';
      const { sessionsService } = await import('@/modules/providers/index.js');
      const result = sessionsService.createAppSession(
        ORCHESTRATOR_PROVIDER as LLMProvider,
        projectPath,
        initialMessage,
        null,
      );
      res.status(201).json(createApiSuccessResponse(result));
    }),
  );

  /**
   * Confirms a plan emitted with `awaitingConfirm`: the client posts back the
   * (possibly edited) step list and the executor runs it. With
   * `planner.requireConfirm` off this is a no-op path — plans auto-run.
   */
  router.post(
    '/plan/confirm',
    asyncHandler(async (req, res) => {
      if (!handlers.confirmPlan) {
        throw new AppError('Plan confirmation is not available.', {
          code: 'PLAN_CONFIRM_UNAVAILABLE',
          statusCode: 501,
        });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const sessionId = typeof body.sessionId === 'string' ? body.sessionId.trim() : '';
      if (!sessionId) {
        throw new AppError('sessionId is required', {
          code: 'SESSION_ID_REQUIRED',
          statusCode: 400,
        });
      }
      if (!Array.isArray(body.steps)) {
        throw new AppError('steps must be an array', {
          code: 'INVALID_REQUEST_BODY',
          statusCode: 400,
        });
      }
      const result = await handlers.confirmPlan(sessionId, body.steps, {
        permissionMode: typeof body.permissionMode === 'string' ? body.permissionMode : undefined,
      });
      if (!result.ok) {
        throw new AppError(result.error, {
          code: result.code,
          statusCode: result.code === 'SESSION_NOT_FOUND' ? 404 : result.code === 'RUN_IN_PROGRESS' ? 409 : 400,
        });
      }
      res.json(createApiSuccessResponse({ sessionId, started: true }));
    }),
  );

  return router;
}

import express from 'express';

import type { MiniOrchestratorConfigService } from '@/modules/mini-orchestrator/services/mini-orchestrator-config.service.js';
import {
  AppError,
  MINI_ORCHESTRATOR_PROVIDER,
  asyncHandler,
  createApiSuccessResponse,
} from '@/shared/utils.js';
import type { AnyRecord, LLMProvider } from '@/shared/types.js';

type PlanConfirmHandler = (
  sessionId: string,
  steps: unknown,
  options: AnyRecord,
) => Promise<{ ok: true } | { ok: false; code: string; error: string }>;

type ResumeHandler = (
  sessionId: string,
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

function statusForCode(code: string): number {
  if (code === 'SESSION_NOT_FOUND' || code === 'NOTHING_TO_RESUME' || code === 'NOTHING_TO_CONFIRM') return 404;
  if (code === 'RUN_IN_PROGRESS') return 409;
  return 400;
}

/**
 * Mini-orchestrator HTTP router mounted at `/api/mini-orchestrator`.
 *
 * Routes only parse transport input and delegate to the config service /
 * runtime handlers; engine logic lives in the mini-orchestrator services.
 */
export function createMiniOrchestratorRouter(
  config: MiniOrchestratorConfigService,
  handlers: {
    confirmPlan?: PlanConfirmHandler;
    resume?: ResumeHandler;
  } = {},
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
   * Allocates a stable app session id for a new mini-orchestrated chat. The row
   * carries provider='mini-orchestrator' so dispatch/history route through the
   * mini engine instead of a provider runtime.
   */
  router.post(
    '/sessions',
    asyncHandler(async (req, res) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const projectPath = typeof body.projectPath === 'string' ? body.projectPath.trim() : '';
      if (!projectPath) {
        throw new AppError('projectPath is required', { code: 'PROJECT_PATH_REQUIRED', statusCode: 400 });
      }
      const initialMessage = typeof body.initialMessage === 'string' ? body.initialMessage : '';
      const { sessionsService } = await import('@/modules/providers/index.js');
      const result = sessionsService.createAppSession(
        MINI_ORCHESTRATOR_PROVIDER as LLMProvider,
        projectPath,
        initialMessage,
        null,
      );
      res.status(201).json(createApiSuccessResponse(result));
    }),
  );

  /**
   * Confirms a plan emitted with `awaitingConfirm`: the client posts back the
   * (possibly edited) step list and the engine runs it.
   */
  router.post(
    '/plan/confirm',
    asyncHandler(async (req, res) => {
      if (!handlers.confirmPlan) {
        throw new AppError('Plan confirmation is not available.', { code: 'PLAN_CONFIRM_UNAVAILABLE', statusCode: 501 });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const sessionId = typeof body.sessionId === 'string' ? body.sessionId.trim() : '';
      if (!sessionId) {
        throw new AppError('sessionId is required', { code: 'SESSION_ID_REQUIRED', statusCode: 400 });
      }
      if (!Array.isArray(body.steps)) {
        throw new AppError('steps must be an array', { code: 'INVALID_REQUEST_BODY', statusCode: 400 });
      }
      const result = await handlers.confirmPlan(sessionId, body.steps, {
        permissionMode: typeof body.permissionMode === 'string' ? body.permissionMode : undefined,
        prompt: typeof body.prompt === 'string' ? body.prompt : undefined,
      });
      if (!result.ok) {
        throw new AppError(result.error, { code: result.code, statusCode: statusForCode(result.code) });
      }
      res.json(createApiSuccessResponse({ sessionId, started: true }));
    }),
  );

  /** Re-runs the session's last plan — the "Continue" affordance. */
  router.post(
    '/sessions/:sessionId/resume',
    asyncHandler(async (req, res) => {
      req.setTimeout(0);
      if (!handlers.resume) {
        throw new AppError('Resume is not available.', { code: 'RESUME_UNAVAILABLE', statusCode: 501 });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const result = await handlers.resume(String(req.params.sessionId), {
        permissionMode: typeof body.permissionMode === 'string' ? body.permissionMode : undefined,
        prompt: typeof body.prompt === 'string' ? body.prompt : undefined,
      });
      if (!result.ok) {
        throw new AppError(result.error, { code: result.code, statusCode: statusForCode(result.code) });
      }
      res.json(createApiSuccessResponse({ sessionId: String(req.params.sessionId), resumed: true }));
    }),
  );

  return router;
}

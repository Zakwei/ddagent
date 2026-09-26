import express from 'express';

import type { OrchestratorConfigService } from '@/modules/orchestrator/services/orchestrator-config.service.js';
import type { AnyRecord, LLMProvider } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse, ORCHESTRATOR_PROVIDER } from '@/shared/utils.js';

type PlanConfirmHandler = (
  sessionId: string,
  steps: unknown,
  options: AnyRecord,
) => Promise<{ ok: true } | { ok: false; code: string; error: string }>;

type StepDecisionHandler = (
  sessionId: string,
  stepId: string,
  action: string,
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
  handlers: { confirmPlan?: PlanConfirmHandler; decideStep?: StepDecisionHandler } = {},
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
   * Child→parent lookup: a delegated child session resolves to the
   * orchestrated parent session id that spawned it (null when none).
   */
  router.get(
    '/sessions/:sessionId/parent',
    asyncHandler(async (req, res) => {
      const { orchestratorMessagesDb } = await import('@/modules/database/index.js');
      const parentSessionId = orchestratorMessagesDb.findParentByChildSessionId(
        String(req.params.sessionId),
      );
      res.json(createApiSuccessResponse({ parentSessionId }));
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

  /**
   * Resolves the decision parked on a step that stayed failed after its
   * automatic retry: `continue` unblocks dependents, `retry` launches one
   * more attempt, `abort` stops the rest of the plan run.
   */
  router.post(
    '/steps/decision',
    asyncHandler(async (req, res) => {
      if (!handlers.decideStep) {
        throw new AppError('Step decisions are not available.', {
          code: 'STEP_DECISION_UNAVAILABLE',
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
      const stepId = typeof body.stepId === 'string' ? body.stepId.trim() : '';
      if (!stepId) {
        throw new AppError('stepId is required', {
          code: 'STEP_ID_REQUIRED',
          statusCode: 400,
        });
      }
      const result = await handlers.decideStep(
        sessionId,
        stepId,
        typeof body.action === 'string' ? body.action : '',
      );
      if (!result.ok) {
        throw new AppError(result.error, {
          code: result.code,
          statusCode: result.code === 'DECISION_NOT_FOUND' ? 404 : 400,
        });
      }
      res.json(createApiSuccessResponse({ sessionId, stepId, decided: true }));
    }),
  );

  return router;
}

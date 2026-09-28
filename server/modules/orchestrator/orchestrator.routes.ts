import express from 'express';

import type { OrchestratorConfigService } from '@/modules/orchestrator/services/orchestrator-config.service.js';
import type { AnyRecord, LLMProvider } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse, ORCHESTRATOR_PROVIDER } from '@/shared/utils.js';

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

/**
 * Orchestrator HTTP router mounted at `/api/orchestrator`.
 *
 * Routes only parse transport input and delegate to the config service;
 * routing and dispatch logic live in the orchestrator services.
 */
export function createOrchestratorRouter(
  config: OrchestratorConfigService,
  handlers: {
    confirmPlan?: PlanConfirmHandler;
    resume?: ResumeHandler;
    /** Returns the per-candidate telemetry snapshot (GET /metrics). */
    metrics?: () => unknown;
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
   * Per-candidate telemetry (runs, success rate, latency, error classes)
   * aggregated from delegation transcript rows — feeds the usage dashboard.
   */
  router.get(
    '/metrics',
    asyncHandler(async (_req, res) => {
      if (!handlers.metrics) {
        throw new AppError('Orchestrator metrics are not available.', {
          code: 'METRICS_UNAVAILABLE',
          statusCode: 501,
        });
      }
      res.json(createApiSuccessResponse(handlers.metrics()));
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
        language: typeof body.language === 'string' ? body.language : undefined,
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
   * Re-runs the failed steps of the session's last finished plan — the
   * "Continue" affordance on the summary card. With `mode:
   * 'complete-all-tasks'` it instead drives the TaskMaster queue: each
   * unfinished task is planned, delegated and marked done until the queue
   * drains or a task fails (`maxTasks` bounds the run). Returns once the run
   * settles; live progress streams over the websocket as usual.
   */
  router.post(
    '/sessions/:sessionId/resume',
    asyncHandler(async (req, res) => {
      // These requests stay open for the whole run; Node's default
      // requestTimeout would kill them mid-run while the loop keeps
      // executing server-side (progress streams over WS anyway).
      req.setTimeout(0);
      if (!handlers.resume) {
        throw new AppError('Resume is not available.', {
          code: 'RESUME_UNAVAILABLE',
          statusCode: 501,
        });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const maxTasks = Number(body.maxTasks);
      const result = await handlers.resume(String(req.params.sessionId), {
        permissionMode: typeof body.permissionMode === 'string' ? body.permissionMode : undefined,
        stepId: typeof body.stepId === 'string' ? body.stepId : undefined,
        prompt: typeof body.prompt === 'string' ? body.prompt : undefined,
        mode: typeof body.mode === 'string' ? body.mode : undefined,
        maxTasks: Number.isFinite(maxTasks) && maxTasks > 0 ? maxTasks : undefined,
        language: typeof body.language === 'string' ? body.language : undefined,
      });
      if (!result.ok) {
        throw new AppError(result.error, {
          code: result.code,
          statusCode:
            result.code === 'SESSION_NOT_FOUND' ||
            result.code === 'NOTHING_TO_RESUME' ||
            result.code === 'STEP_NOT_FOUND' ||
            result.code === 'NO_TASKMASTER'
              ? 404
              : result.code === 'RUN_IN_PROGRESS' || result.code === 'TASKS_BLOCKED'
                ? 409
                : 400,
        });
      }
      res.json(createApiSuccessResponse({ sessionId: String(req.params.sessionId), resumed: true }));
    }),
  );

  /**
   * Continues the session's work by scheduling follow-up steps.
   */
  router.post(
    '/sessions/:sessionId/continue',
    asyncHandler(async (req, res) => {
      req.setTimeout(0);
      if (!handlers.resume) {
        throw new AppError('Resume is not available.', {
          code: 'RESUME_UNAVAILABLE',
          statusCode: 501,
        });
      }
      const body = (req.body ?? {}) as Record<string, unknown>;
      const result = await handlers.resume(String(req.params.sessionId), {
        permissionMode: typeof body.permissionMode === 'string' ? body.permissionMode : undefined,
        stepId: typeof body.stepId === 'string' ? body.stepId : undefined,
        prompt: typeof body.prompt === 'string' ? body.prompt : undefined,
        customSteps: Array.isArray(body.steps) ? body.steps : body.customSteps,
        mode: 'continue',
        language: typeof body.language === 'string' ? body.language : undefined,
      });
      if (!result.ok) {
        throw new AppError(result.error, {
          code: result.code,
          statusCode:
            result.code === 'SESSION_NOT_FOUND' ||
            result.code === 'NOTHING_TO_RESUME' ||
            result.code === 'STEP_NOT_FOUND'
              ? 404
              : result.code === 'RUN_IN_PROGRESS'
                ? 409
                : 400,
        });
      }
      res.json(createApiSuccessResponse({ sessionId: String(req.params.sessionId), continued: true }));
    }),
  );

  return router;
}

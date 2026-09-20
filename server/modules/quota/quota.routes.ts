import express from 'express';

import type { QuotaService } from '@/modules/quota/services/quota.service.js';
import type { AgentFleetService } from '@/modules/quota/services/agents.service.js';
import type { UsageService } from '@/modules/quota/services/usage.service.js';
import { isInsightPeriod, isUsageGroupBy } from '@/modules/quota/services/usage.service.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

/** Services the Quota router exposes over HTTP. */
export type QuotaRouterServices = {
  quota: QuotaService;
  usage: UsageService;
  agents: AgentFleetService;
};

/**
 * Builds the Quota/Insights HTTP router around the injected services.
 *
 * Quota endpoints return the snapshot shape; `refresh` additionally bypasses the
 * cache. Usage and agent endpoints are read-only projections over the same
 * module so the QuotaOps screens share one mount point.
 */
export function createQuotaRouter(services: QuotaRouterServices): express.Router {
  const router = express.Router();

  router.get(
    '/',
    asyncHandler(async (_req, res) => {
      res.json(createApiSuccessResponse(await services.quota.getSnapshot(false)));
    }),
  );

  router.post(
    '/refresh',
    asyncHandler(async (_req, res) => {
      res.json(createApiSuccessResponse(await services.quota.getSnapshot(true)));
    }),
  );

  router.get(
    '/config',
    asyncHandler(async (_req, res) => {
      res.json(createApiSuccessResponse(services.quota.getConfig()));
    }),
  );

  router.put(
    '/config',
    asyncHandler(async (req, res) => {
      const body = req.body;
      if (typeof body !== 'object' || body === null || Array.isArray(body)) {
        throw new AppError('Quota config must be a JSON object.', {
          code: 'QUOTA_CONFIG_INVALID',
          statusCode: 400,
        });
      }
      res.json(createApiSuccessResponse(services.quota.saveConfig(body)));
    }),
  );

  router.get(
    '/accounts/:accountId/history',
    asyncHandler(async (req, res) => {
      const accountId = String(req.params.accountId);
      const rawLimit = Number(req.query.limit);
      const limit = Number.isFinite(rawLimit) && rawLimit > 0 ? Math.floor(rawLimit) : undefined;
      res.json(createApiSuccessResponse(services.quota.getHistory(accountId, limit)));
    }),
  );

  router.get(
    '/usage',
    asyncHandler(async (req, res) => {
      const period = String(req.query.period ?? '7d');
      const groupBy = String(req.query.groupBy ?? 'provider');
      if (!isInsightPeriod(period)) {
        throw new AppError(`Unknown usage period "${period}".`, {
          code: 'USAGE_PERIOD_INVALID',
          statusCode: 400,
        });
      }
      if (!isUsageGroupBy(groupBy)) {
        throw new AppError(`Unknown usage groupBy "${groupBy}".`, {
          code: 'USAGE_GROUP_INVALID',
          statusCode: 400,
        });
      }
      res.json(createApiSuccessResponse(services.usage.getSummary({ period, groupBy })));
    }),
  );

  router.get(
    '/agents',
    asyncHandler(async (_req, res) => {
      res.json(createApiSuccessResponse(services.agents.getSnapshot()));
    }),
  );

  return router;
}

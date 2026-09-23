import express, { type Request, type Response } from 'express';

import { providerAccountsService } from '@/modules/provider-accounts/provider-accounts.service.js';
import type { LLMProvider } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

const KNOWN_PROVIDERS: readonly string[] = ['claude', 'codex', 'cursor', 'opencode', 'devin'];

const readIdParam = (value: unknown): string => {
  if (typeof value === 'string') return value;
  if (Array.isArray(value) && typeof value[0] === 'string') return value[0];
  throw new AppError('id path parameter is invalid.', {
    code: 'INVALID_PATH_PARAMETER',
    statusCode: 400,
  });
};

const parseProvider = (value: unknown): LLMProvider => {
  const normalized = typeof value === 'string' ? value.trim().toLowerCase() : '';
  if (KNOWN_PROVIDERS.includes(normalized)) {
    return normalized as LLMProvider;
  }
  throw new AppError(`Unsupported provider "${normalized}".`, {
    code: 'UNSUPPORTED_PROVIDER',
    statusCode: 400,
  });
};

/**
 * Multi-account CRUD: `/api/provider-accounts`.
 *
 * An account row binds a provider to a set of env overrides (typically an
 * isolated config dir like CLAUDE_CONFIG_DIR). Sessions pin `account_id` at
 * creation and every provider runtime merges the overrides into its child env.
 */
export function createProviderAccountsRouter() {
  const router = express.Router();

  router.get(
    '/',
    asyncHandler(async (req: Request, res: Response) => {
      const provider = req.query.provider ? parseProvider(req.query.provider) : undefined;
      res.json(createApiSuccessResponse({ accounts: providerAccountsService.list(provider) }));
    }),
  );

  router.post(
    '/',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const account = providerAccountsService.create({
        provider: parseProvider(body.provider),
        label: body.label,
        envOverrides: body.envOverrides,
        isDefault: body.isDefault,
      });
      res.status(201).json(createApiSuccessResponse({ account }));
    }),
  );

  router.patch(
    '/:id',
    asyncHandler(async (req: Request, res: Response) => {
      const body = (req.body ?? {}) as Record<string, unknown>;
      const account = providerAccountsService.update(readIdParam(req.params.id), {
        label: body.label,
        envOverrides: body.envOverrides,
        isDefault: body.isDefault,
      });
      res.json(createApiSuccessResponse({ account }));
    }),
  );

  router.delete(
    '/:id',
    asyncHandler(async (_req: Request, res: Response) => {
      providerAccountsService.remove(readIdParam(_req.params.id));
      res.json(createApiSuccessResponse({ deleted: true }));
    }),
  );

  router.get(
    '/:id/usage',
    asyncHandler(async (req: Request, res: Response) => {
      const usage = await providerAccountsService.getAccountUsage(readIdParam(req.params.id));
      res.json(createApiSuccessResponse({ usage }));
    }),
  );

  return router;
}

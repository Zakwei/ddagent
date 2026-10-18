import express, { type Request, type Response } from 'express';

import type { RegisterAppPreviewInput, UpdateAppPreviewInput } from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

import {
  getAppPreview,
  listAppPreviewDevices,
  listAppPreviews,
  registerAppPreview,
  reloadAppPreview,
  removeAppPreview,
  updateAppPreview,
} from './app-preview.service.js';

/**
 * `/api/app-preview` — the Flutter preview pane's REST surface, mounted behind
 * `authenticateToken` in services.ts. Agents use the MCP `preview_*` tools
 * instead; both end up in the same service, so the pane and the agent always
 * see one registry.
 */

function readIdParam(value: unknown): string {
  if (typeof value === 'string' && value.trim()) return value;
  if (Array.isArray(value) && typeof value[0] === 'string') return value[0];
  throw new AppError('id path parameter is invalid.', {
    code: 'INVALID_PATH_PARAMETER',
    statusCode: 400,
  });
}

function readNullableString(value: unknown): string | null | undefined {
  if (value === undefined) return undefined;
  if (value === null) return null;
  return String(value);
}

/** Body → service input; strings only, everything else is left to the service to validate. */
function readPreviewPatch(body: unknown): UpdateAppPreviewInput {
  const record = body && typeof body === 'object' ? (body as Record<string, unknown>) : {};
  return {
    url: typeof record.url === 'string' ? record.url : undefined,
    title: readNullableString(record.title),
    platform: readNullableString(record.platform),
    device: readNullableString(record.device),
    orientation: readNullableString(record.orientation),
    projectPath: readNullableString(record.projectPath),
    note: readNullableString(record.note),
  };
}

/** App-preview router; mounted at `/api/app-preview` by services.ts. */
export const appPreviewRoutes = express.Router();

appPreviewRoutes.get(
  '/',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse({ previews: listAppPreviews() }));
  }),
);

appPreviewRoutes.get(
  '/devices',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse({ devices: listAppPreviewDevices() }));
  }),
);

appPreviewRoutes.get(
  '/:id',
  asyncHandler(async (req: Request, res: Response) => {
    res.json(createApiSuccessResponse({ preview: getAppPreview(readIdParam(req.params.id)) }));
  }),
);

appPreviewRoutes.post(
  '/',
  asyncHandler(async (req: Request, res: Response) => {
    const patch = readPreviewPatch(req.body);
    if (!patch.url) {
      throw new AppError('url is required.', { code: 'APP_PREVIEW_INVALID_INPUT', statusCode: 400 });
    }
    const input: RegisterAppPreviewInput = { ...patch, url: patch.url };
    const result = registerAppPreview(input);
    res.status(result.created ? 201 : 200).json(createApiSuccessResponse(result));
  }),
);

appPreviewRoutes.patch(
  '/:id',
  asyncHandler(async (req: Request, res: Response) => {
    const preview = updateAppPreview(readIdParam(req.params.id), readPreviewPatch(req.body));
    res.json(createApiSuccessResponse({ preview }));
  }),
);

appPreviewRoutes.post(
  '/:id/reload',
  asyncHandler(async (req: Request, res: Response) => {
    const preview = reloadAppPreview(readIdParam(req.params.id));
    res.json(createApiSuccessResponse({ preview }));
  }),
);

appPreviewRoutes.delete(
  '/:id',
  asyncHandler(async (req: Request, res: Response) => {
    removeAppPreview(readIdParam(req.params.id));
    res.json(createApiSuccessResponse({ removed: true }));
  }),
);

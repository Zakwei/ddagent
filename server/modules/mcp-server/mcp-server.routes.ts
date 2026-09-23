import { createHash, randomBytes, randomUUID } from 'node:crypto';

import express, { type Request, type Response } from 'express';

import { mcpTokensDb, type McpTokenScope } from '@/modules/database/index.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';

import { getMcpServerInfo, handleMcpRequest } from './mcp-server.service.js';

/**
 * MCP Streamable-HTTP endpoint (`/mcp`) plus its session-authenticated token
 * admin API (`/api/mcp`).
 *
 * `mcpRouter` does bearer-token auth itself — MCP clients hold long-lived
 * `mcp_*` tokens, not the app's JWT — so it must be mounted outside
 * `authenticateToken`. `mcpTokensRouter` is plain CRUD and relies on the
 * session-auth middleware applied at mount time.
 */

function readBearerToken(header: unknown): string | null {
  if (typeof header !== 'string') {
    return null;
  }
  const match = /^Bearer\s+(\S.*)$/i.exec(header.trim());
  return match?.[1]?.trim() || null;
}

/** sha256 hex digest — the only form of a token that ever touches the DB. */
function hashToken(plainToken: string): string {
  return createHash('sha256').update(plainToken).digest('hex');
}

function readIdParam(value: unknown): string {
  if (typeof value === 'string') return value;
  if (Array.isArray(value) && typeof value[0] === 'string') return value[0];
  throw new AppError('id path parameter is invalid.', {
    code: 'INVALID_PATH_PARAMETER',
    statusCode: 400,
  });
}

/**
 * Token-authenticated MCP JSON-RPC router, mounted at `/mcp` by services.ts.
 *
 * POST `/` accepts one JSON-RPC 2.0 request (`initialize`, `ping`,
 * `tools/list`, `tools/call`, `notifications/*`) and returns the JSON-RPC
 * response — or HTTP 202 with an empty body for notifications. GET `/`
 * returns the server info document for capability probes.
 */
export const mcpRouter = express.Router();

mcpRouter.use((req: Request, res: Response, next) => {
  const token = readBearerToken(req.headers.authorization);
  const record = token ? mcpTokensDb.findByToken(token, hashToken) : null;
  if (!record) {
    res.status(401).json({
      success: false,
      error: { code: 'MCP_UNAUTHORIZED', message: 'A valid MCP bearer token is required.' },
    });
    return;
  }
  res.locals.mcpTokenScope = record.scope;
  res.locals.mcpTokenId = record.id;
  next();
});

mcpRouter.get('/', (_req: Request, res: Response) => {
  res.json(getMcpServerInfo());
});

mcpRouter.post(
  '/',
  asyncHandler(async (req: Request, res: Response) => {
    const scope = (res.locals.mcpTokenScope ?? 'read') as McpTokenScope;
    const response = await handleMcpRequest(req.body, scope);
    if (response === null) {
      // JSON-RPC notification: accepted, nothing to return.
      res.status(202).end();
      return;
    }
    res.json(response);
  }),
);

/**
 * Token-management router, mounted at `/api/mcp` behind `authenticateToken`.
 *
 * `POST /tokens` is the only place a plaintext token exists: it is returned in
 * this one response; the row stores only its sha256 digest.
 */
export const mcpTokensRouter = express.Router();

mcpTokensRouter.get(
  '/tokens',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse({ tokens: mcpTokensDb.list() }));
  }),
);

mcpTokensRouter.post(
  '/tokens',
  asyncHandler(async (req: Request, res: Response) => {
    const body = (req.body ?? {}) as Record<string, unknown>;
    const label = typeof body.label === 'string' ? body.label.trim() : '';
    if (!label) {
      throw new AppError('label is required.', {
        code: 'MCP_TOKEN_LABEL_REQUIRED',
        statusCode: 400,
      });
    }
    const scope = body.scope === 'write' ? 'write' : body.scope === 'read' ? 'read' : null;
    if (!scope) {
      throw new AppError('scope must be "read" or "write".', {
        code: 'MCP_TOKEN_SCOPE_INVALID',
        statusCode: 400,
      });
    }

    const plainToken = `mcp_${randomBytes(32).toString('base64url')}`;
    const record = mcpTokensDb.create({
      id: randomUUID(),
      label,
      tokenHash: hashToken(plainToken),
      scope,
    });

    res.status(201).json(createApiSuccessResponse({ token: plainToken, record }));
  }),
);

mcpTokensRouter.delete(
  '/tokens/:id',
  asyncHandler(async (req: Request, res: Response) => {
    const id = readIdParam(req.params.id);
    if (!mcpTokensDb.revoke(id)) {
      throw new AppError(`MCP token "${id}" was not found.`, {
        code: 'MCP_TOKEN_NOT_FOUND',
        statusCode: 404,
      });
    }
    res.json(createApiSuccessResponse({ revoked: true }));
  }),
);

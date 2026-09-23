import fs from 'node:fs';
import path from 'node:path';

import type { McpTokenScope } from '@/modules/database/index.js';
import type { AnyRecord } from '@/shared/types.js';
import { AppError, findApplicationRoot, getModuleDirectory, readObjectRecord } from '@/shared/utils.js';

import { callMcpTool, listMcpTools } from './mcp-tools.service.js';

/**
 * Minimal MCP endpoint over HTTP (Streamable-HTTP style) without the official
 * SDK: plain JSON-RPC 2.0 request → JSON-RPC 2.0 response.
 *
 * Supported methods: `initialize`, `ping`, `tools/list`, `tools/call`, plus
 * `notifications/*` (accepted, never answered — the route returns HTTP 202).
 * Bearer-token auth and scope resolution happen in the route middleware; this
 * service only receives the resolved scope.
 */

const MCP_PROTOCOL_VERSION = '2024-11-05';

export type JsonRpcId = string | number | null;

export type JsonRpcResponse = {
  jsonrpc: '2.0';
  id: JsonRpcId;
  result?: unknown;
  error?: { code: number; message: string; data?: unknown };
};

const INVALID_REQUEST = -32600;
const METHOD_NOT_FOUND = -32601;
const INVALID_PARAMS = -32602;
const INTERNAL_ERROR = -32603;

class JsonRpcError extends Error {
  constructor(
    readonly code: number,
    message: string,
  ) {
    super(message);
    this.name = 'JsonRpcError';
  }
}

let cachedVersion: string | null = null;

/** Reads the app version from the repository package.json, resolved once per process. */
function serverVersion(): string {
  if (cachedVersion !== null) return cachedVersion;
  try {
    const appRoot = findApplicationRoot(getModuleDirectory(import.meta.url));
    const pkg = JSON.parse(fs.readFileSync(path.join(appRoot, 'package.json'), 'utf8')) as {
      version?: string;
    };
    cachedVersion = pkg.version || '0.0.0';
  } catch {
    cachedVersion = '0.0.0';
  }
  return cachedVersion;
}

/** Server identity shared by the `initialize` result and `GET /mcp`. */
export function getMcpServerInfo(): {
  name: string;
  version: string;
  protocolVersion: string;
  capabilities: { tools: AnyRecord };
} {
  return {
    name: 'ddagent',
    version: serverVersion(),
    protocolVersion: MCP_PROTOCOL_VERSION,
    capabilities: { tools: {} },
  };
}

function normalizeId(value: unknown): JsonRpcId | undefined {
  if (value === undefined) return undefined;
  if (value === null || typeof value === 'string' || typeof value === 'number') {
    return value;
  }
  throw new JsonRpcError(INVALID_REQUEST, 'Invalid request id.');
}

function errorResponse(id: JsonRpcId, code: number, message: string): JsonRpcResponse {
  return { jsonrpc: '2.0', id, error: { code, message } };
}

/**
 * Dispatches one JSON-RPC request payload.
 *
 * Returns `null` for notifications (messages without an `id`) so the route can
 * answer HTTP 202 with an empty body — per JSON-RPC, notifications never get a
 * response object.
 *
 * ponytail: batch arrays are not supported — each POST carries exactly one
 * request, which covers the MCP clients this endpoint targets. If a client
 * sends an array it receives -32600; add a Promise.all fan-out if that ever
 * becomes a real requirement.
 */
export async function handleMcpRequest(
  payload: unknown,
  scope: McpTokenScope,
): Promise<JsonRpcResponse | null> {
  const request = readObjectRecord(payload);

  let id: JsonRpcId | undefined;
  try {
    id = normalizeId(request?.id);
  } catch {
    return errorResponse(null, INVALID_REQUEST, 'Invalid JSON-RPC request id.');
  }

  if (!request || typeof request.method !== 'string' || request.method.trim() === '') {
    return errorResponse(id ?? null, INVALID_REQUEST, 'Invalid JSON-RPC request.');
  }

  const method = request.method;
  const isNotification = id === undefined;

  try {
    const result = await dispatchMethod(method, request.params, scope);
    if (isNotification) return null;
    return { jsonrpc: '2.0', id: id ?? null, result };
  } catch (error) {
    // Notifications never produce a response object — even on failure.
    if (isNotification) return null;
    if (error instanceof JsonRpcError) {
      return errorResponse(id ?? null, error.code, error.message);
    }
    const message = error instanceof Error ? error.message : String(error);
    return errorResponse(id ?? null, INTERNAL_ERROR, message);
  }
}

async function dispatchMethod(
  method: string,
  params: unknown,
  scope: McpTokenScope,
): Promise<unknown> {
  switch (method) {
    case 'initialize':
      return {
        protocolVersion: MCP_PROTOCOL_VERSION,
        capabilities: { tools: {} },
        serverInfo: { name: 'ddagent', version: serverVersion() },
      };

    case 'ping':
      return {};

    case 'tools/list':
      return { tools: listMcpTools() };

    case 'tools/call': {
      const toolParams = readObjectRecord(params);
      const toolName = typeof toolParams?.name === 'string' ? toolParams.name : '';
      if (!toolName) {
        throw new JsonRpcError(INVALID_PARAMS, 'tools/call requires params.name.');
      }
      try {
        const output = await callMcpTool(toolName, toolParams?.arguments, scope);
        return {
          content: [{ type: 'text', text: JSON.stringify(output ?? null, null, 2) }],
        };
      } catch (error) {
        // Unknown tool names are a params problem (-32602). Everything else —
        // including scope violations and service failures — is a tool-level
        // error, which MCP reports as a result with `isError`, not a
        // JSON-RPC protocol error.
        if (error instanceof AppError && error.code === 'MCP_UNKNOWN_TOOL') {
          throw new JsonRpcError(INVALID_PARAMS, error.message);
        }
        const message = error instanceof Error ? error.message : String(error);
        return {
          content: [{ type: 'text', text: message }],
          isError: true,
        };
      }
    }

    default:
      if (method.startsWith('notifications/')) {
        // Known client lifecycle notifications (notifications/initialized,
        // notifications/cancelled, ...) need no state on this endpoint.
        return {};
      }
      throw new JsonRpcError(METHOD_NOT_FOUND, `Method not found: ${method}`);
  }
}

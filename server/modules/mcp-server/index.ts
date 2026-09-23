// mcpRouter: token-authenticated MCP Streamable-HTTP endpoint — services.ts mounts it at `/mcp` (no JWT; the router validates `mcp_*` bearer tokens itself).
// mcpTokensRouter: token-management CRUD — services.ts mounts it at `/api/mcp` behind `authenticateToken`.
export { mcpRouter, mcpTokensRouter } from './mcp-server.routes.js';

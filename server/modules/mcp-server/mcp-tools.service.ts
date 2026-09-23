import { randomUUID } from 'node:crypto';

import { kanbanCardsDb, projectsDb, sessionsDb, type McpTokenScope } from '@/modules/database/index.js';
import { queuedMessagesService } from '@/modules/queued-messages/index.js';
import { chatRunRegistry } from '@/modules/websocket/index.js';
import { worktreeServices } from '@/modules/worktrees/index.js';
import type { AnyRecord, LLMProvider } from '@/shared/types.js';
import { AppError, readObjectRecord } from '@/shared/utils.js';

/**
 * MCP tool catalog: thin adapters over existing ddagent services.
 *
 * Each definition carries the minimum token `scope` required to call it —
 * `read` tools (list_sessions, get_status) work for every token, `write`
 * tools require a write-scoped token. The adapters only parse arguments and
 * delegate; all business rules live in the underlying modules.
 */
type McpToolDefinition = {
  name: string;
  description: string;
  scope: McpTokenScope;
  inputSchema: AnyRecord;
};

const STRING = { type: 'string' } as const;

const MCP_TOOL_DEFINITIONS: McpToolDefinition[] = [
  {
    name: 'list_sessions',
    description: 'List recent ddagent chat sessions across all projects.',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        limit: { type: 'integer', description: 'Max sessions to return (default 20, max 100).' },
      },
    },
  },
  {
    name: 'get_status',
    description: 'Return ddagent runtime status: running agent sessions and project count.',
    scope: 'read',
    inputSchema: { type: 'object', properties: {} },
  },
  {
    name: 'create_task',
    description:
      'Create a kanban card in the "ready" column of a project board, carrying a prompt for the agent.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        projectId: STRING,
        projectPath: { type: 'string', description: 'Alternative to projectId: an absolute project path already known to ddagent.' },
        prompt: { type: 'string', description: 'Full task description the agent will work on.' },
        title: { type: 'string', description: 'Card title; defaults to the first prompt line.' },
        provider: STRING,
        model: STRING,
        effort: STRING,
      },
      required: ['prompt'],
    },
  },
  {
    name: 'send_message',
    description: 'Enqueue a message into a ddagent session (delivered when the session is idle).',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        sessionId: STRING,
        message: { type: 'string', description: 'Message body sent to the session.' },
      },
      required: ['sessionId', 'message'],
    },
  },
  {
    name: 'create_worktree',
    description: 'Create a git worktree (and branch) for a project repository.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        projectPath: STRING,
        branch: STRING,
        baseBranch: { type: 'string', description: 'Branch to fork from; defaults to the main worktree branch.' },
      },
      required: ['projectPath', 'branch'],
    },
  },
];

/** tools/list payload: name/description/inputSchema for every tool the server supports. */
export function listMcpTools(): Array<Pick<McpToolDefinition, 'name' | 'description' | 'inputSchema'>> {
  return MCP_TOOL_DEFINITIONS.map(({ name, description, inputSchema }) => ({
    name,
    description,
    inputSchema,
  }));
}

function readRequiredString(value: unknown, field: string): string {
  const normalized = typeof value === 'string' ? value.trim() : '';
  if (!normalized) {
    throw new AppError(`Tool argument "${field}" is required.`, {
      code: 'MCP_INVALID_PARAMS',
      statusCode: 400,
    });
  }
  return normalized;
}

function readOptionalString(value: unknown): string | undefined {
  return typeof value === 'string' && value.trim() ? value.trim() : undefined;
}

/**
 * Executes one `tools/call` request.
 *
 * Throws `AppError(MCP_UNKNOWN_TOOL)` for unknown names so the JSON-RPC layer
 * can map it to -32602, and `AppError(MCP_SCOPE_FORBIDDEN)` when a read-scoped
 * token reaches for a write tool. Every other failure propagates as-is and is
 * reported to the MCP client as a tool-level `isError` result.
 */
export async function callMcpTool(
  name: string,
  args: unknown,
  scope: McpTokenScope,
): Promise<unknown> {
  const definition = MCP_TOOL_DEFINITIONS.find((tool) => tool.name === name);
  if (!definition) {
    throw new AppError(`Unknown MCP tool "${name}".`, {
      code: 'MCP_UNKNOWN_TOOL',
      statusCode: 400,
    });
  }
  if (definition.scope === 'write' && scope !== 'write') {
    throw new AppError(`Tool "${name}" requires a write-scoped MCP token.`, {
      code: 'MCP_SCOPE_FORBIDDEN',
      statusCode: 403,
    });
  }

  const input = readObjectRecord(args) ?? {};

  switch (definition.name) {
    case 'list_sessions': {
      const rawLimit = input.limit;
      const limit =
        typeof rawLimit === 'number' && Number.isInteger(rawLimit) && rawLimit > 0
          ? Math.min(rawLimit, 100)
          : 20;
      const page = sessionsDb.getRecentSessionsPage(limit, 0);
      return {
        total: page.total,
        sessions: page.sessions.map((session) => ({
          sessionId: session.session_id,
          provider: session.provider,
          projectPath: session.project_path,
          customName: session.custom_name,
          model: session.model,
          createdAt: session.created_at,
          updatedAt: session.updated_at,
        })),
      };
    }

    case 'get_status': {
      const running = chatRunRegistry.listRunningRuns();
      return {
        runningSessions: running.length,
        running: running.map((run) => ({
          sessionId: run.sessionId,
          provider: run.provider,
          startedAt: run.startedAt,
        })),
        projects: projectsDb.getProjectPaths().length,
      };
    }

    case 'create_task': {
      const prompt = readRequiredString(input.prompt, 'prompt');
      // Cards are keyed by project_id; accepting projectPath keeps the tool
      // usable for callers that only know the workspace directory.
      let projectId: string | null = readOptionalString(input.projectId) ?? null;
      if (!projectId) {
        const projectPath = readOptionalString(input.projectPath);
        if (projectPath) {
          projectId = projectsDb.getProjectPath(projectPath)?.project_id ?? null;
        }
      }
      if (!projectId) {
        throw new AppError('Tool argument "projectId" (or a known "projectPath") is required.', {
          code: 'MCP_INVALID_PARAMS',
          statusCode: 400,
        });
      }
      const title =
        readOptionalString(input.title) ??
        (prompt.split('\n', 1)[0] ?? prompt).slice(0, 120);
      const card = kanbanCardsDb.create({
        cardId: randomUUID(),
        projectId,
        title,
        description: prompt,
        provider: readOptionalString(input.provider) as LLMProvider | undefined,
        model: readOptionalString(input.model),
        effort: readOptionalString(input.effort),
      });
      // Repository `create` always lands in `backlog`; the MCP contract is a
      // card already staged for pickup, so it is moved to `ready` directly.
      // ponytail: bypassing kanbanCardService means no board broadcast and no
      // immediate agent dispatch — wire kanbanCardService through the kanban
      // barrel if MCP-created cards must start runs on arrival.
      return kanbanCardsDb.move(card.cardId, 'ready', card.position) ?? card;
    }

    case 'send_message': {
      const sessionId = readRequiredString(input.sessionId, 'sessionId');
      const message =
        readOptionalString(input.message) ?? readRequiredString(input.content, 'message');
      return queuedMessagesService.enqueue({
        userId: null,
        sessionId,
        content: message,
        options: { inboxSource: 'mcp' },
      });
    }

    case 'create_worktree': {
      return worktreeServices.create({
        projectPath: readRequiredString(input.projectPath, 'projectPath'),
        branch: readRequiredString(input.branch, 'branch'),
        baseBranch: readOptionalString(input.baseBranch) ?? null,
      });
    }

    default:
      throw new AppError(`Unknown MCP tool "${name}".`, {
        code: 'MCP_UNKNOWN_TOOL',
        statusCode: 400,
      });
  }
}

import { randomUUID } from 'node:crypto';

import { kanbanCardsDb, projectsDb, sessionsDb, type McpTokenScope } from '@/modules/database/index.js';
import { buildProjectContext, knowledgeService } from '@/modules/knowledge/index.js';
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
  // ------------------------------------------------- knowledge base (read)
  {
    name: 'knowledge_search',
    description: 'Full-text search across the knowledge base (memories, rules, skills, personal info).',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        query: STRING,
        entityType: { type: 'string', enum: ['memory', 'rule', 'skill', 'personal'] },
        projectId: STRING,
        limit: { type: 'integer' },
      },
      required: ['query'],
    },
  },
  {
    name: 'knowledge_get_context',
    description:
      'Build the project context for a query: critical rules first, then query-matched rules, memories (+1-hop), skills and personal info, as a token-budgeted Markdown block.',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        projectId: STRING,
        projectPath: STRING,
        query: STRING,
        maxResults: { type: 'integer' },
        maxTokens: { type: 'integer' },
      },
    },
  },
  {
    name: 'knowledge_get_rules',
    description: 'List stored rules, optionally for a project (global rules included).',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        projectId: STRING,
        projectPath: STRING,
        priority: STRING,
        enabledOnly: { type: 'boolean' },
      },
    },
  },
  {
    name: 'knowledge_get_memories',
    description: 'List stored memories, optionally scoped to a project and filtered by priority or tag.',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        projectId: STRING,
        projectPath: STRING,
        priority: STRING,
        tag: STRING,
        limit: { type: 'integer' },
      },
    },
  },
  {
    name: 'knowledge_get_skills',
    description: 'List skills stored in the knowledge base.',
    scope: 'read',
    inputSchema: { type: 'object', properties: { category: STRING } },
  },
  {
    name: 'knowledge_get_personal',
    description: 'List personal information entries.',
    scope: 'read',
    inputSchema: { type: 'object', properties: {} },
  },
  {
    name: 'knowledge_get_graph',
    description: 'Return the relation graph (nodes and connections) for the knowledge base.',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: {
        projectId: STRING,
        projectPath: STRING,
        entityTypes: { type: 'array', items: STRING },
        limit: { type: 'integer' },
      },
    },
  },
  {
    name: 'knowledge_history',
    description: 'List the version history of a knowledge entity.',
    scope: 'read',
    inputSchema: {
      type: 'object',
      properties: { entityType: STRING, entityId: STRING, limit: { type: 'integer' } },
    },
  },
  // ------------------------------------------------ knowledge base (write)
  {
    name: 'knowledge_add_memory',
    description: 'Store a memory (fact, decision, note) in the knowledge base.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        title: STRING,
        content: STRING,
        projectId: STRING,
        projectPath: STRING,
        memoryType: STRING,
        priority: STRING,
        tags: { type: 'array', items: STRING },
      },
      required: ['title'],
    },
  },
  {
    name: 'knowledge_update_memory',
    description: 'Update a stored memory by id.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        id: STRING,
        title: STRING,
        content: STRING,
        memoryType: STRING,
        priority: STRING,
        tags: { type: 'array', items: STRING },
      },
      required: ['id'],
    },
  },
  {
    name: 'knowledge_delete_memory',
    description: 'Delete a stored memory by id.',
    scope: 'write',
    inputSchema: { type: 'object', properties: { id: STRING }, required: ['id'] },
  },
  {
    name: 'knowledge_add_rule',
    description: 'Store a rule (binding convention) in the knowledge base.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        title: STRING,
        content: STRING,
        projectId: STRING,
        projectPath: STRING,
        priority: STRING,
        enabled: { type: 'boolean' },
      },
      required: ['title'],
    },
  },
  {
    name: 'knowledge_update_rule',
    description: 'Update a stored rule by id.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: { id: STRING, title: STRING, content: STRING, priority: STRING, enabled: { type: 'boolean' } },
      required: ['id'],
    },
  },
  {
    name: 'knowledge_delete_rule',
    description: 'Delete a stored rule by id.',
    scope: 'write',
    inputSchema: { type: 'object', properties: { id: STRING }, required: ['id'] },
  },
  {
    name: 'knowledge_add_skill',
    description: 'Store a skill in the knowledge base.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: { name: STRING, description: STRING, content: STRING, category: STRING },
      required: ['name'],
    },
  },
  {
    name: 'knowledge_update_skill',
    description: 'Update a stored skill by id.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: { id: STRING, name: STRING, description: STRING, content: STRING, category: STRING },
      required: ['id'],
    },
  },
  {
    name: 'knowledge_delete_skill',
    description: 'Delete a stored skill by id.',
    scope: 'write',
    inputSchema: { type: 'object', properties: { id: STRING }, required: ['id'] },
  },
  {
    name: 'knowledge_add_personal',
    description: 'Store a personal information entry.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: { key: STRING, title: STRING, content: STRING },
      required: ['key', 'title'],
    },
  },
  {
    name: 'knowledge_update_personal',
    description: 'Update a personal information entry by id.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: { id: STRING, key: STRING, title: STRING, content: STRING },
      required: ['id'],
    },
  },
  {
    name: 'knowledge_delete_personal',
    description: 'Delete a personal information entry by id.',
    scope: 'write',
    inputSchema: { type: 'object', properties: { id: STRING }, required: ['id'] },
  },
  {
    name: 'knowledge_link',
    description: 'Create a relation between two knowledge entities.',
    scope: 'write',
    inputSchema: {
      type: 'object',
      properties: {
        sourceId: STRING,
        sourceType: STRING,
        targetId: STRING,
        targetType: STRING,
        relationship: STRING,
        weight: { type: 'number' },
      },
      required: ['sourceId', 'sourceType', 'targetId', 'targetType'],
    },
  },
  {
    name: 'knowledge_unlink',
    description: 'Delete a relation by id.',
    scope: 'write',
    inputSchema: { type: 'object', properties: { id: STRING }, required: ['id'] },
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

function readOptionalNumber(value: unknown): number | undefined {
  return typeof value === 'number' && Number.isFinite(value) ? value : undefined;
}

/**
 * Resolves the project scope of a knowledge tool call.
 *
 * `undefined` means "no scope filter" (return everything), a string scopes to
 * that project id, and `null` is returned when a supplied projectPath is not a
 * project ddagent knows about. Accepting projectPath keeps the tools usable for
 * callers that only know the workspace directory.
 */
function resolveKnowledgeProjectId(input: AnyRecord): string | null | undefined {
  const projectId = readOptionalString(input.projectId);
  if (projectId) return projectId;
  const projectPath = readOptionalString(input.projectPath);
  if (projectPath) {
    return projectsDb.getProjectPath(projectPath)?.project_id ?? null;
  }
  return undefined;
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

    // --------------------------------------------------- knowledge base
    case 'knowledge_search': {
      const query = readRequiredString(input.query, 'query');
      return {
        results: knowledgeService.search(query, {
          entityType: readOptionalString(input.entityType) as
            | 'memory'
            | 'rule'
            | 'skill'
            | 'personal'
            | undefined,
          projectId: resolveKnowledgeProjectId(input) ?? undefined,
          limit: readOptionalNumber(input.limit),
        }),
      };
    }

    case 'knowledge_get_context': {
      return buildProjectContext({
        projectId: resolveKnowledgeProjectId(input),
        projectPath: readOptionalString(input.projectPath),
        query: readOptionalString(input.query),
        maxResults: readOptionalNumber(input.maxResults),
        maxTokens: readOptionalNumber(input.maxTokens),
      });
    }

    case 'knowledge_get_rules': {
      return knowledgeService.listRules({
        projectId: resolveKnowledgeProjectId(input),
        includeGlobal: true,
        priority: readOptionalString(input.priority),
        enabledOnly: input.enabledOnly === true,
      });
    }

    case 'knowledge_get_memories': {
      return knowledgeService.listMemories({
        projectId: resolveKnowledgeProjectId(input),
        includeGlobal: true,
        priority: readOptionalString(input.priority),
        tag: readOptionalString(input.tag),
        limit: readOptionalNumber(input.limit),
      });
    }

    case 'knowledge_get_skills': {
      return knowledgeService.listSkills({ category: readOptionalString(input.category) });
    }

    case 'knowledge_get_personal': {
      return knowledgeService.listPersonal({});
    }

    case 'knowledge_get_graph': {
      const entityTypes = Array.isArray(input.entityTypes)
        ? input.entityTypes.filter((value): value is string => typeof value === 'string')
        : undefined;
      return knowledgeService.graph({
        projectId: resolveKnowledgeProjectId(input),
        entityTypes,
        limit: readOptionalNumber(input.limit),
      });
    }

    case 'knowledge_history': {
      return knowledgeService.listHistory({
        entityType: readOptionalString(input.entityType),
        entityId: readOptionalString(input.entityId),
        limit: readOptionalNumber(input.limit),
      });
    }

    case 'knowledge_add_memory': {
      return knowledgeService.createMemory({
        projectId: resolveKnowledgeProjectId(input),
        title: input.title,
        content: input.content,
        memoryType: input.memoryType,
        priority: input.priority,
        tags: input.tags,
      });
    }

    case 'knowledge_update_memory': {
      return knowledgeService.updateMemory(readRequiredString(input.id, 'id'), {
        title: input.title,
        content: input.content,
        memoryType: input.memoryType,
        priority: input.priority,
        tags: input.tags,
      });
    }

    case 'knowledge_delete_memory': {
      knowledgeService.deleteMemory(readRequiredString(input.id, 'id'));
      return { deleted: true };
    }

    case 'knowledge_add_rule': {
      return knowledgeService.createRule({
        projectId: resolveKnowledgeProjectId(input),
        title: input.title,
        content: input.content,
        priority: input.priority,
        enabled: input.enabled,
      });
    }

    case 'knowledge_update_rule': {
      return knowledgeService.updateRule(readRequiredString(input.id, 'id'), {
        title: input.title,
        content: input.content,
        priority: input.priority,
        enabled: input.enabled,
      });
    }

    case 'knowledge_delete_rule': {
      knowledgeService.deleteRule(readRequiredString(input.id, 'id'));
      return { deleted: true };
    }

    case 'knowledge_add_skill': {
      return knowledgeService.createSkill({
        name: input.name,
        description: input.description,
        content: input.content,
        category: input.category,
      });
    }

    case 'knowledge_update_skill': {
      return knowledgeService.updateSkill(readRequiredString(input.id, 'id'), {
        name: input.name,
        description: input.description,
        content: input.content,
        category: input.category,
      });
    }

    case 'knowledge_delete_skill': {
      knowledgeService.deleteSkill(readRequiredString(input.id, 'id'));
      return { deleted: true };
    }

    case 'knowledge_add_personal': {
      return knowledgeService.createPersonal({
        key: input.key,
        title: input.title,
        content: input.content,
      });
    }

    case 'knowledge_update_personal': {
      return knowledgeService.updatePersonal(readRequiredString(input.id, 'id'), {
        key: input.key,
        title: input.title,
        content: input.content,
      });
    }

    case 'knowledge_delete_personal': {
      knowledgeService.deletePersonal(readRequiredString(input.id, 'id'));
      return { deleted: true };
    }

    case 'knowledge_link': {
      return knowledgeService.createConnection({
        sourceId: input.sourceId,
        sourceType: input.sourceType,
        targetId: input.targetId,
        targetType: input.targetType,
        relationship: input.relationship,
        weight: input.weight,
      });
    }

    case 'knowledge_unlink': {
      knowledgeService.deleteConnection(readRequiredString(input.id, 'id'));
      return { deleted: true };
    }

    default:
      throw new AppError(`Unknown MCP tool "${name}".`, {
        code: 'MCP_UNKNOWN_TOOL',
        statusCode: 400,
      });
  }
}

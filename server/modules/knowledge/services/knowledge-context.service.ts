import path from 'node:path';

import {
  knowledgeDb,
  projectsDb,
  type KbMemory,
  type KbPersonalInfo,
  type KbRule,
  type KbSkill,
} from '@/modules/database/index.js';

/**
 * Contexta-style project ContextBuilder (faithful port of Contexta's
 * `context.rs::build_project_context`).
 *
 * Consumers: the MCP tool `knowledge_get_context` and the REST `GET
 * /api/knowledge/context` preview. There is no automatic injection into
 * sessions — agents call the tool with a query (the Contexta model).
 *
 * Order and limits mirror Contexta:
 * 1. Rules: ALL enabled rules (project + global), `critical` first, cap 20.
 * 2. Memories: query -> FTS-ranked (project-scoped); empty -> top by priority.
 * 3. One hop over explicit connections (memory neighbours only, cap 5).
 * 4. Skills: FTS-ranked by the query; empty query -> most recent skills.
 * 5. Personal info only when the query matches it (cap 3).
 * Rendered to a whole-item, token-budgeted Markdown block.
 */

const TOKEN_BUDGET = 4000;
const MAX_RULES = 20;
const MAX_SKILLS = 10;
const MAX_PERSONAL = 3;
const NEIGHBOUR_CAP = 5;

const PRIORITY_RANK: Record<string, number> = { critical: 0, high: 1, normal: 2, low: 3 };

const priorityRank = (priority: string): number => PRIORITY_RANK[priority] ?? 2;
const byPriority = <T extends { priority: string; updatedAt: string }>(a: T, b: T): number =>
  priorityRank(a.priority) - priorityRank(b.priority) || b.updatedAt.localeCompare(a.updatedAt);

const oneLine = (value: string): string => value.replace(/\s+/g, ' ').trim();

function truncate(value: string, max: number): string {
  const text = oneLine(value);
  return text.length <= max ? text : `${text.slice(0, max).trimEnd()}...`;
}

/** Query terms: lowercased word runs of length >= 2, de-duplicated. */
function tokenize(query: string): string[] {
  const tokens = query.toLowerCase().match(/[\p{L}\p{N}_]+/gu) ?? [];
  return [...new Set(tokens.filter((token) => token.length >= 2))];
}

const matches = (terms: string[], ...fields: string[]): boolean => {
  if (terms.length === 0) return false;
  const haystack = fields.join(' ').toLowerCase();
  return terms.some((term) => haystack.includes(term));
};

export type KnowledgeContextResult = {
  projectId: string | null;
  query: string;
  rules: KbRule[];
  memories: KbMemory[];
  skills: KbSkill[];
  personal: KbPersonalInfo[];
  markdown: string;
  estimatedTokens: number;
  tokenBudget: number;
  truncated: boolean;
};

/** Contexta's `push_section`: whole items only; counts what the budget dropped. */
function pushSection(
  sections: string[],
  state: { used: number },
  budget: number,
  header: string,
  items: string[],
): number {
  if (items.length === 0) return 0;
  const kept: string[] = [];
  let keptLen = 0;
  let omitted = 0;
  for (const item of items) {
    if (state.used + header.length + keptLen + item.length + 1 > budget) {
      omitted += 1;
    } else {
      keptLen += item.length + 1;
      kept.push(item);
    }
  }
  if (kept.length === 0) return omitted;
  sections.push(`${header}\n${kept.join('\n')}`);
  state.used += header.length + keptLen + 2;
  return omitted;
}

/**
 * Builds the Contexta-style context for a project + optional query.
 * `maxResults` caps the memory count; `maxTokens` caps the rendered Markdown.
 */
export async function buildProjectContext(input: {
  projectId?: string | null;
  projectPath?: string;
  query?: string;
  maxResults?: number;
  maxTokens?: number;
}): Promise<KnowledgeContextResult> {
  const maxResults = Math.min(Math.max(input.maxResults ?? 10, 1), 50);
  const tokenBudget = Math.min(Math.max(input.maxTokens ?? TOKEN_BUDGET, 256), 64_000);
  const budget = tokenBudget * 4;
  const query = (input.query ?? '').trim();
  const terms = tokenize(query);

  let projectId = input.projectId ?? null;
  if (!projectId && input.projectPath) {
    projectId = projectsDb.getProjectPath(input.projectPath)?.project_id ?? null;
  }
  const projectRow = projectId ? projectsDb.getProjectById(projectId) : null;
  const projectName =
    projectRow?.custom_project_name?.trim() || (projectRow ? path.basename(projectRow.project_path) : 'General');

  // 1. Rules: all enabled, critical first.
  const rules = knowledgeDb
    .listRules({ projectId, includeGlobal: true, enabledOnly: true, limit: 500 })
    .items.sort(byPriority)
    .slice(0, MAX_RULES);

  // 2. Memories: query -> FTS (project-scoped); empty -> top by priority.
  let memories: KbMemory[];
  if (terms.length) {
    const hits = knowledgeDb.search(query, { entityType: 'memory', projectId, limit: maxResults * 2 });
    memories = hits
      .filter((hit) => !projectId || hit.projectId === projectId)
      .map((hit) => knowledgeDb.getMemory(hit.entityId))
      .filter((memory): memory is KbMemory => memory !== null)
      .slice(0, maxResults);
  } else if (projectId) {
    memories = knowledgeDb
      .listMemories({ projectId, limit: 500 })
      .items.sort(byPriority)
      .slice(0, maxResults);
  } else {
    memories = [];
  }

  // 3. One hop over explicit connections (memory neighbours only, capped).
  const seen = new Set(memories.map((memory) => memory.id));
  const neighbours: KbMemory[] = [];
  for (const memory of memories) {
    if (neighbours.length >= NEIGHBOUR_CAP) break;
    for (const connection of knowledgeDb.listConnections({ entityId: memory.id, limit: 50 })) {
      if (neighbours.length >= NEIGHBOUR_CAP) break;
      const other = connection.sourceId === memory.id ? connection.targetId : connection.sourceId;
      if (seen.has(other)) continue;
      const neighbour = knowledgeDb.getMemory(other);
      if (!neighbour) continue;
      seen.add(other);
      neighbours.push(neighbour);
    }
  }
  memories = [...memories, ...neighbours];

  // 4. Skills: FTS-ranked; empty query -> most recent skills.
  let skills: KbSkill[];
  if (terms.length) {
    skills = knowledgeDb
      .search(query, { entityType: 'skill', limit: MAX_SKILLS })
      .map((hit) => knowledgeDb.getSkill(hit.entityId))
      .filter((skill): skill is KbSkill => skill !== null);
  } else {
    skills = knowledgeDb
      .listSkills({ limit: 500 })
      .items.sort((a, b) => b.updatedAt.localeCompare(a.updatedAt))
      .slice(0, MAX_SKILLS);
  }

  // 5. Personal info only when the query matches it.
  let personal: KbPersonalInfo[] = [];
  if (terms.length) {
    personal = knowledgeDb
      .search(query, { entityType: 'personal', limit: MAX_PERSONAL })
      .map((hit) => knowledgeDb.getPersonal(hit.entityId))
      .filter((info): info is KbPersonalInfo => info !== null);
    if (personal.length === 0) {
      personal = knowledgeDb
        .listPersonal({ limit: 500 })
        .items.filter((info) => matches(terms, info.key, info.title, info.content))
        .slice(0, MAX_PERSONAL);
    }
  }

  // Rendering (markdown, whole items, budget).
  const sections: string[] = [`# Project\n${projectName}`];
  const state = { used: sections[0].length };
  let truncated = false;
  const critical = rules.filter((rule) => rule.priority === 'critical');
  const other = rules.filter((rule) => rule.priority !== 'critical');
  truncated =
    pushSection(
      sections,
      state,
      budget,
      '## Critical Rules',
      critical.map((rule) => `- **${rule.title}**: ${truncate(rule.content, 800)}`),
    ) > 0 || truncated;
  truncated =
    pushSection(
      sections,
      state,
      budget,
      '## Rules',
      other.map((rule) => `- **[${rule.priority}] ${rule.title}**: ${truncate(rule.content, 800)}`),
    ) > 0 || truncated;
  truncated =
    pushSection(
      sections,
      state,
      budget,
      '## Relevant Memories',
      memories.map(
        (memory) => `- **[${memory.priority}] ${memory.title}**: ${truncate(memory.content, 1000)}`,
      ),
    ) > 0 || truncated;
  truncated =
    pushSection(
      sections,
      state,
      budget,
      '## Relevant Skills',
      skills.map((skill) => `- **${skill.name}** (${skill.category}): ${truncate(skill.description, 600)}`),
    ) > 0 || truncated;
  truncated =
    pushSection(
      sections,
      state,
      budget,
      '## Personal Context',
      personal.map((info) => `- **${info.title}**: ${truncate(info.content, 600)}`),
    ) > 0 || truncated;

  const markdown = sections.join('\n\n');
  return {
    projectId,
    query,
    rules,
    memories,
    skills,
    personal,
    markdown,
    estimatedTokens: Math.ceil(markdown.length / 4),
    tokenBudget,
    truncated,
  };
}

/** Preview of the always-served rules block — used by the client meter. */
export type KnowledgeContextPreview = {
  projectId: string | null;
  markdown: string | null;
  chars: number;
  estimatedTokens: number;
  tokenBudget: number;
};

/**
 * Renders the enabled rules a `get_project_context` call always returns
 * (critical first), so the client can show the guaranteed context size.
 */
export function buildKnowledgeContextPreview(projectId: string | null): KnowledgeContextPreview {
  const empty: KnowledgeContextPreview = {
    projectId,
    markdown: null,
    chars: 0,
    estimatedTokens: 0,
    tokenBudget: TOKEN_BUDGET,
  };
  if (process.env.DDAGENT_KNOWLEDGE === '0') return empty;
  if (!projectId) return empty;
  const rules = knowledgeDb
    .listRules({ projectId, includeGlobal: true, enabledOnly: true, limit: 500 })
    .items.sort(byPriority)
    .slice(0, MAX_RULES);
  if (rules.length === 0) return empty;
  const markdown = rules.map((rule) => `- **[${rule.priority}] ${rule.title}**: ${truncate(rule.content, 800)}`).join('\n');
  return {
    projectId,
    markdown,
    chars: markdown.length,
    estimatedTokens: Math.ceil(markdown.length / 4),
    tokenBudget: TOKEN_BUDGET,
  };
}

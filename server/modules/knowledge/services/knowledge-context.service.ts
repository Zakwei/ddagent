import {
  knowledgeDb,
  projectsDb,
  type KbMemory,
  type KbPersonalInfo,
  type KbRule,
  type KbSkill,
} from '@/modules/database/index.js';

/**
 * Contexta-style project ContextBuilder.
 *
 * Consumers: the MCP tool `knowledge_get_context` and the REST `GET
 * /api/knowledge/context` preview. Given a project and an optional query it
 * returns, in order: the project's `critical` rules (always), query-matched
 * rules, relevant memories (+1-hop connection expansion), keyword-matched
 * skills, and personal information only when the query matches — all rendered
 * to a token-budgeted Markdown block.
 *
 * There is no automatic injection into sessions: agents call the tool with a
 * query (the Contexta model). `DDAGENT_KNOWLEDGE=0` disables the preview.
 */

const DEFAULT_TOKEN_BUDGET = 4000;
const oneLine = (value: string): string => value.replace(/\s+/g, ' ').trim();

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

/** Keeps lines while the remaining character budget allows, skipping oversized ones. */
function takeWithinBudget(lines: string[], budget: number): { lines: string[]; used: number } {
  const out: string[] = [];
  let remaining = budget;
  for (const line of lines) {
    if (line.length > remaining) continue;
    out.push(line);
    remaining -= line.length;
  }
  return { lines: out, used: budget - remaining };
}

const formatRule = (rule: KbRule): string => `- ${oneLine(rule.title)}: ${oneLine(rule.content)}`;
const formatMemory = (memory: KbMemory): string =>
  `- ${oneLine(memory.title)}: ${oneLine(memory.content)}`;
const formatSkill = (skill: KbSkill): string =>
  `- ${oneLine(skill.name)}: ${oneLine(skill.description)}`;
const formatPersonal = (info: KbPersonalInfo): string =>
  `- ${oneLine(info.title)}: ${oneLine(info.content)}`;

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

/**
 * Builds the Contexta-style context for a project + optional query.
 * `maxResults` caps each section; `maxTokens` caps the rendered Markdown.
 */
export async function buildProjectContext(input: {
  projectId?: string | null;
  projectPath?: string;
  query?: string;
  maxResults?: number;
  maxTokens?: number;
}): Promise<KnowledgeContextResult> {
  const maxResults = Math.min(Math.max(input.maxResults ?? 10, 1), 50);
  const tokenBudget = Math.min(Math.max(input.maxTokens ?? DEFAULT_TOKEN_BUDGET, 500), 32_000);
  const charBudget = tokenBudget * 4;
  const query = (input.query ?? '').trim();
  const terms = tokenize(query);

  let projectId = input.projectId ?? null;
  if (!projectId && input.projectPath) {
    projectId = projectsDb.getProjectPath(input.projectPath)?.project_id ?? null;
  }
  const scope = { projectId, includeGlobal: true };

  // 1. Critical rules are always included (Contexta: critical first).
  const criticalRules = knowledgeDb.listRules({
    ...scope,
    enabledOnly: true,
    priority: 'critical',
    limit: 50,
  }).items;
  // Other rules only when the query matches.
  const criticalIds = new Set(criticalRules.map((rule) => rule.id));
  const matchedRules = terms.length
    ? knowledgeDb
        .listRules({ ...scope, enabledOnly: true, limit: 300 })
        .items.filter((rule) => !criticalIds.has(rule.id) && matches(terms, rule.title, rule.content))
        .slice(0, maxResults)
    : [];
  const rules = [...criticalRules, ...matchedRules];

  // 2. Memories: query -> FTS + 1-hop expansion; no query -> top entries.
  let memories: KbMemory[];
  if (terms.length) {
    const hits = knowledgeDb.search(query, { entityType: 'memory', projectId, limit: maxResults });
    const expanded = new Map<string, KbMemory>();
    for (const hit of hits) {
      const memory = knowledgeDb.getMemory(hit.entityId);
      if (memory) expanded.set(memory.id, memory);
    }
    for (const memory of [...expanded.values()]) {
      if (expanded.size >= maxResults * 2) break;
      for (const connection of knowledgeDb.listConnections({ entityId: memory.id, limit: 20 })) {
        const other = connection.sourceId === memory.id ? connection.targetId : connection.sourceId;
        if (expanded.has(other)) continue;
        const neighbour = knowledgeDb.getMemory(other);
        if (neighbour) expanded.set(neighbour.id, neighbour);
      }
    }
    memories = [...expanded.values()].slice(0, Math.max(maxResults, 5));
  } else {
    memories = knowledgeDb.listMemories({ ...scope, limit: maxResults }).items;
  }

  // 3. Skills matched by keyword (name/description/category).
  const skills = terms.length
    ? knowledgeDb
        .listSkills({ limit: 300 })
        .items.filter((skill) => matches(terms, skill.name, skill.description, skill.category))
        .slice(0, maxResults)
    : [];

  // 4. Personal info only when the query matches it.
  const personal = terms.length
    ? knowledgeDb
        .listPersonal({ limit: 300 })
        .items.filter((info) => matches(terms, info.key, info.title, info.content))
        .slice(0, maxResults)
    : [];

  // 5. Token-budgeted Markdown rendering.
  let remaining = charBudget;
  const sections: string[] = [];
  const push = (heading: string, entries: string[]) => {
    if (entries.length === 0) return;
    const { lines, used } = takeWithinBudget(entries, remaining);
    if (lines.length === 0) return;
    sections.push(`## ${heading}\n${lines.join('\n')}`);
    remaining -= used;
  };
  push('Critical rules', criticalRules.map(formatRule));
  push('Relevant rules', matchedRules.map(formatRule));
  push('Memories', memories.map(formatMemory));
  push('Skills', skills.map(formatSkill));
  push('Personal', personal.map(formatPersonal));

  const header = query ? `# Context: ${query}` : '# Context';
  const markdown = sections.length > 0 ? `${header}\n\n${sections.join('\n\n')}` : '';
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
    truncated: sections.join('\n').length >= charBudget,
  };
}

/** Preview of the always-included critical block — used by the client meter. */
export type KnowledgeContextPreview = {
  projectId: string | null;
  markdown: string | null;
  chars: number;
  estimatedTokens: number;
  tokenBudget: number;
};

/**
 * Renders just the critical rules a `get_project_context` call always returns,
 * so the client can show how much of the budget the guaranteed context takes.
 * Returns an empty preview (no markdown) when the feature is disabled or the
 * project has no critical rules.
 */
export function buildKnowledgeContextPreview(projectId: string | null): KnowledgeContextPreview {
  const empty: KnowledgeContextPreview = {
    projectId,
    markdown: null,
    chars: 0,
    estimatedTokens: 0,
    tokenBudget: DEFAULT_TOKEN_BUDGET,
  };
  if (process.env.DDAGENT_KNOWLEDGE === '0') return empty;
  if (!projectId) return empty;
  const rules = knowledgeDb.listRules({
    projectId,
    includeGlobal: true,
    enabledOnly: true,
    priority: 'critical',
    limit: 50,
  }).items;
  if (rules.length === 0) return empty;
  const markdown = `## Critical rules\n${rules.map(formatRule).join('\n')}`;
  return {
    projectId,
    markdown,
    chars: markdown.length,
    estimatedTokens: Math.ceil(markdown.length / 4),
    tokenBudget: DEFAULT_TOKEN_BUDGET,
  };
}

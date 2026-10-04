import { knowledgeDb, projectsDb, type KbMemory, type KbRule } from '@/modules/database/index.js';

/**
 * Knowledge-base context builder (Contexta-style ContextBuilder).
 *
 * Consumers: `dispatchChatCommand` in the WebSocket module, which prepends the
 * built block to a session's first outbound message. The builder emits the
 * project's `critical` rules and `critical` memories within a token budget so
 * binding conventions and durable facts ride along on every session without
 * burning tokens on every turn.
 *
 * `DDAGENT_KNOWLEDGE=0` opts out entirely. Building never throws: a failure
 * degrades to no prefix so context can never block a send.
 */

const INJECTION_HEADER =
  'The following project knowledge is maintained by the ddagent knowledge base. Treat critical rules as binding and the memories as durable context.';

/** Approximate context budget; ~4 characters per token as a cheap estimate. */
const TOKEN_BUDGET = 4000;
const CHAR_BUDGET = TOKEN_BUDGET * 4;

const oneLine = (value: string): string => value.replace(/\s+/g, ' ').trim();

/** Keeps lines while the remaining character budget allows, skipping oversized ones. */
function takeWithinBudget(lines: string[], budget: number): string[] {
  const out: string[] = [];
  let remaining = budget;
  for (const line of lines) {
    if (line.length > remaining) continue;
    out.push(line);
    remaining -= line.length;
  }
  return out;
}

/**
 * Builds the `<knowledge>` prefix for a session in `projectPath`.
 *
 * Includes the project's (plus global) `critical` rules and memories, every
 * personal-information entry, and the 1-hop neighbours of the included
 * memories reached through explicit connections. Returns null when the feature
 * is disabled or nothing is stored.
 */
export async function buildKnowledgePrefix(projectPath: string): Promise<string | null> {
  if (process.env.DDAGENT_KNOWLEDGE === '0') return null;
  const projectId = projectsDb.getProjectPath(projectPath)?.project_id ?? null;

  const rules = knowledgeDb.listRules({
    projectId,
    includeGlobal: true,
    enabledOnly: true,
    priority: 'critical',
    limit: 50,
  }).items;
  const memories = knowledgeDb.listMemories({
    projectId,
    includeGlobal: true,
    priority: 'critical',
    limit: 100,
  }).items;
  const personal = knowledgeDb.listPersonal({ limit: 100 }).items;
  const related = collectRelated(memories, rules, personal);

  if (rules.length === 0 && memories.length === 0 && personal.length === 0 && related.length === 0) {
    return null;
  }

  let budget = CHAR_BUDGET;
  const sections: string[] = [];
  const push = (heading: string, lines: string[]) => {
    if (lines.length === 0) return;
    sections.push(`## ${heading}\n${lines.join('\n')}`);
    budget -= lines.join('\n').length;
  };

  push('Critical rules', takeWithinBudget(rules.map(formatRule), budget));
  push('Critical memories', takeWithinBudget(memories.map(formatMemory), budget));
  push(
    'Personal',
    takeWithinBudget(
      personal.map((info) => `- ${oneLine(info.title)}: ${oneLine(info.content)}`),
      budget,
    ),
  );
  push(
    'Related',
    takeWithinBudget(
      related.map((entry) => `- ${oneLine(entry.label)} (${entry.entityType})`),
      budget,
    ),
  );

  if (sections.length === 0) return null;
  return `<knowledge>\n${INJECTION_HEADER}\n\n${sections.join('\n\n')}\n</knowledge>\n\n`;
}

/**
 * Labels of the entities one connection away from the included critical
 * memories, excluding anything already in the prefix. Capped so a densely
 * connected memory cannot blow the budget.
 */
function collectRelated(
  memories: KbMemory[],
  rules: KbRule[],
  personal: Array<{ id: string }>,
): Array<{ label: string; entityType: string }> {
  const included = new Set<string>([
    ...memories.map((memory) => memory.id),
    ...rules.map((rule) => rule.id),
    ...personal.map((entry) => entry.id),
  ]);
  const neighbourIds = new Set<string>();
  for (const memory of memories) {
    for (const connection of knowledgeDb.listConnections({ entityId: memory.id, limit: 50 })) {
      const other = connection.sourceId === memory.id ? connection.targetId : connection.sourceId;
      if (!included.has(other)) neighbourIds.add(other);
    }
  }
  return knowledgeDb
    .labelsFor([...neighbourIds].slice(0, 20))
    .map((entry) => ({ label: entry.label, entityType: entry.entityType }));
}

const formatRule = (rule: KbRule): string => `- ${oneLine(rule.title)}: ${oneLine(rule.content)}`;

const formatMemory = (memory: KbMemory): string =>
  `- ${oneLine(memory.title)}: ${oneLine(memory.content)}`;

/**
 * Prepends the knowledge prefix to `content`. Never throws — a build failure
 * returns the content unchanged, matching `applyUnifiedPrefix`.
 */
export async function applyKnowledgePrefix(content: string, projectPath: string): Promise<string> {
  try {
    const prefix = await buildKnowledgePrefix(projectPath);
    return prefix ? prefix + content : content;
  } catch (error) {
    console.warn('[Knowledge] Context injection skipped:', error);
    return content;
  }
}

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
 * Returns null when the feature is disabled or nothing critical is stored.
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

  if (rules.length === 0 && memories.length === 0) return null;

  let budget = CHAR_BUDGET;
  const sections: string[] = [];

  const ruleLines = takeWithinBudget(
    rules.map((rule) => formatRule(rule)),
    budget,
  );
  if (ruleLines.length > 0) {
    sections.push(`## Critical rules\n${ruleLines.join('\n')}`);
    budget -= ruleLines.join('\n').length;
  }

  const memoryLines = takeWithinBudget(
    memories.map((memory) => formatMemory(memory)),
    budget,
  );
  if (memoryLines.length > 0) {
    sections.push(`## Critical memories\n${memoryLines.join('\n')}`);
  }

  if (sections.length === 0) return null;
  return `<knowledge>\n${INJECTION_HEADER}\n\n${sections.join('\n\n')}\n</knowledge>\n\n`;
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

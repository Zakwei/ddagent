import {
  knowledgeDb,
  type KbConnection,
  type KbHistoryEntry,
  type KbMemory,
  type KbPage,
  type KbPersonalInfo,
  type KbRule,
  type KbSearchResult,
  type KbSkill,
} from '@/modules/database/index.js';
import { AppError } from '@/shared/utils.js';

/**
 * Knowledge-base business logic (Contexta-style local memory layer).
 *
 * Consumers: the Knowledge HTTP routes (`createKnowledgeRouter`), the project
 * scanner, the auto-inject context builder and the MCP tool adapters. Routes
 * stay thin and delegate all validation and persistence here; every mutation is
 * snapshotted into `kb_entity_history` so agent/MCP writes can be reviewed.
 */

const PRIORITIES = ['critical', 'high', 'normal', 'low'] as const;
const MAX_TITLE = 300;
const MAX_CONTENT = 200_000;
const MAX_TAGS = 25;
const MAX_TAG_LENGTH = 40;
const MAX_ICON_BYTES = 64 * 1024;
const ICON_PATTERN = /^data:image\/(png|jpe?g|webp|gif|svg\+xml);base64,[A-Za-z0-9+/=\s]+$/;

/** Entity kind shared by history, connections and the graph. */
export type KnowledgeEntityKind = 'memory' | 'rule' | 'skill' | 'personal';

export type KnowledgeListFilter = {
  projectId?: string | null;
  includeGlobal?: boolean;
  memoryType?: string;
  tag?: string;
  priority?: string;
  enabledOnly?: boolean;
  category?: string;
  limit?: number;
  offset?: number;
};

export type KnowledgeGraph = {
  nodes: Array<{
    id: string;
    nodeType: string;
    label: string;
    projectId: string | null;
    priority: string | null;
    icon: string | null;
  }>;
  edges: Array<{
    id: string;
    source: string;
    target: string;
    relationship: string;
    weight: number;
  }>;
  truncated: boolean;
  counts: Record<string, number>;
};

export type KnowledgeExport = {
  version: number;
  exportedAt: string;
  memories: KbMemory[];
  rules: KbRule[];
  skills: KbSkill[];
  personal: KbPersonalInfo[];
  connections: KbConnection[];
};

const badRequest = (message: string, code = 'INVALID_KNOWLEDGE_INPUT'): AppError =>
  new AppError(message, { code, statusCode: 400 });

const notFound = (kind: string): AppError =>
  new AppError(`${kind} not found.`, { code: 'KNOWLEDGE_NOT_FOUND', statusCode: 404 });

const conflict = (message: string): AppError =>
  new AppError(message, { code: 'KNOWLEDGE_CONFLICT', statusCode: 409 });

/** Maps a raw SQLite unique-constraint error to a 409 instead of a 500. */
function rethrowConstraint(error: unknown, message: string): never {
  const code = (error as { code?: string })?.code ?? '';
  if (code.startsWith('SQLITE_CONSTRAINT')) {
    throw conflict(message);
  }
  throw error;
}

function readTitle(value: unknown, field = 'title'): string {
  const title = typeof value === 'string' ? value.trim() : '';
  if (!title || title.length > MAX_TITLE) {
    throw badRequest(`${field} is required (1-${MAX_TITLE} characters).`);
  }
  return title;
}

function readContent(value: unknown): string {
  if (value === undefined || value === null) return '';
  if (typeof value !== 'string') throw badRequest('content must be a string.');
  if (value.length > MAX_CONTENT) {
    throw badRequest(`content exceeds ${MAX_CONTENT} characters.`);
  }
  return value;
}

function readPriority(value: unknown, fallback = 'normal'): string {
  if (value === undefined || value === null) return fallback;
  const priority = typeof value === 'string' ? value.trim() : '';
  if (!(PRIORITIES as readonly string[]).includes(priority)) {
    throw badRequest(`priority must be one of ${PRIORITIES.join(', ')}.`);
  }
  return priority;
}

function readBoolean(value: unknown, fallback: boolean): boolean {
  if (value === undefined || value === null) return fallback;
  if (typeof value !== 'boolean') throw badRequest('expected a boolean value.');
  return value;
}

function readOptionalProjectId(value: unknown): string | null | undefined {
  if (value === undefined) return undefined;
  if (value === null || value === '') return null;
  if (typeof value !== 'string') throw badRequest('projectId must be a string or null.');
  return value.trim();
}

function readTags(value: unknown): string[] | undefined {
  if (value === undefined) return undefined;
  if (!Array.isArray(value)) throw badRequest('tags must be an array of strings.');
  const tags = new Set<string>();
  for (const raw of value) {
    if (typeof raw !== 'string') throw badRequest('tags must be an array of strings.');
    const tag = raw.trim();
    if (!tag) continue;
    if (tag.length > MAX_TAG_LENGTH) {
      throw badRequest(`tags may be at most ${MAX_TAG_LENGTH} characters.`);
    }
    tags.add(tag);
  }
  if (tags.size > MAX_TAGS) throw badRequest(`at most ${MAX_TAGS} tags are allowed.`);
  return [...tags];
}

function readMemoryType(value: unknown, fallback = 'fact'): string {
  if (value === undefined || value === null) return fallback;
  const memoryType = typeof value === 'string' ? value.trim() : '';
  if (!memoryType || memoryType.length > 40) {
    throw badRequest('memoryType must be 1-40 characters.');
  }
  return memoryType;
}

function readSource(value: unknown, fallback = 'manual'): string {
  if (value === undefined || value === null) return fallback;
  const source = typeof value === 'string' ? value.trim() : '';
  if (!source || source.length > 200) throw badRequest('source must be 1-200 characters.');
  return source;
}

function readKey(value: unknown): string {
  const key = typeof value === 'string' ? value.trim() : '';
  if (!/^[A-Za-z0-9_.-]{1,64}$/.test(key)) {
    throw badRequest('key must be 1-64 characters of letters, digits, dot, dash or underscore.');
  }
  return key;
}

/** Validates an optional base64 image data URL used as a skill icon. */
function readIcon(value: unknown): string {
  if (value === undefined || value === null || value === '') return '';
  if (typeof value !== 'string' || !ICON_PATTERN.test(value)) {
    throw badRequest('icon must be an image data URL (base64).');
  }
  if (Buffer.byteLength(value, 'utf8') > MAX_ICON_BYTES) {
    throw badRequest(`icon exceeds ${MAX_ICON_BYTES} bytes.`);
  }
  return value;
}

function readRequiredString(value: unknown, field: string, max = 200): string {
  const text = typeof value === 'string' ? value.trim() : '';
  if (!text || text.length > max) {
    throw badRequest(`${field} is required (1-${max} characters).`);
  }
  return text;
}

function snapshot(
  entityType: KnowledgeEntityKind,
  entity: { id: string; content: string; title?: string; name?: string },
): void {
  knowledgeDb.recordHistory({
    entityType,
    entityId: entity.id,
    title: entity.title ?? entity.name ?? '',
    content: entity.content,
  });
}

function collectAll<T>(fetch: (offset: number) => KbPage<T>): T[] {
  const out: T[] = [];
  let offset = 0;
  for (;;) {
    const page = fetch(offset);
    out.push(...page.items);
    if (page.items.length === 0 || out.length >= page.total) break;
    offset += page.items.length;
  }
  return out;
}

export const knowledgeService = {
  // -------------------------------------------------------------- memories

  listMemories(filter: KnowledgeListFilter): KbPage<KbMemory> {
    return knowledgeDb.listMemories({
      projectId: filter.projectId,
      includeGlobal: filter.includeGlobal,
      memoryType: filter.memoryType,
      tag: filter.tag,
      limit: filter.limit,
      offset: filter.offset,
    });
  },

  getMemory(id: string): KbMemory {
    const memory = knowledgeDb.getMemory(id);
    if (!memory) throw notFound('Memory');
    return memory;
  },

  createMemory(input: {
    projectId?: unknown;
    title: unknown;
    content?: unknown;
    memoryType?: unknown;
    priority?: unknown;
    source?: unknown;
    tags?: unknown;
  }): KbMemory {
    const memory = knowledgeDb.createMemory({
      projectId: readOptionalProjectId(input.projectId) ?? null,
      title: readTitle(input.title),
      content: readContent(input.content),
      memoryType: readMemoryType(input.memoryType),
      priority: readPriority(input.priority),
      source: readSource(input.source),
      tags: readTags(input.tags),
    });
    snapshot('memory', memory);
    return memory;
  },

  updateMemory(
    id: string,
    patch: {
      projectId?: unknown;
      title?: unknown;
      content?: unknown;
      memoryType?: unknown;
      priority?: unknown;
      source?: unknown;
      tags?: unknown;
    },
  ): KbMemory {
    const existing = knowledgeDb.getMemory(id);
    if (!existing) throw notFound('Memory');
    const updated = knowledgeDb.updateMemory(id, {
      projectId: readOptionalProjectId(patch.projectId),
      title: patch.title === undefined ? undefined : readTitle(patch.title),
      content: patch.content === undefined ? undefined : readContent(patch.content),
      memoryType: patch.memoryType === undefined ? undefined : readMemoryType(patch.memoryType),
      priority: patch.priority === undefined ? undefined : readPriority(patch.priority),
      source: patch.source === undefined ? undefined : readSource(patch.source),
      tags: readTags(patch.tags),
    });
    if (!updated) throw notFound('Memory');
    snapshot('memory', updated);
    return updated;
  },

  deleteMemory(id: string): void {
    const existing = knowledgeDb.getMemory(id);
    if (!existing) throw notFound('Memory');
    snapshot('memory', existing);
    knowledgeDb.deleteMemory(id);
  },

  // ----------------------------------------------------------------- rules

  listRules(filter: KnowledgeListFilter): KbPage<KbRule> {
    return knowledgeDb.listRules({
      projectId: filter.projectId,
      includeGlobal: filter.includeGlobal,
      enabledOnly: filter.enabledOnly,
      priority: filter.priority,
      limit: filter.limit,
      offset: filter.offset,
    });
  },

  getRule(id: string): KbRule {
    const rule = knowledgeDb.getRule(id);
    if (!rule) throw notFound('Rule');
    return rule;
  },

  createRule(input: {
    projectId?: unknown;
    title: unknown;
    content?: unknown;
    priority?: unknown;
    enabled?: unknown;
  }): KbRule {
    const rule = knowledgeDb.createRule({
      projectId: readOptionalProjectId(input.projectId) ?? null,
      title: readTitle(input.title),
      content: readContent(input.content),
      priority: readPriority(input.priority),
      enabled: readBoolean(input.enabled, true),
    });
    snapshot('rule', rule);
    return rule;
  },

  updateRule(
    id: string,
    patch: {
      projectId?: unknown;
      title?: unknown;
      content?: unknown;
      priority?: unknown;
      enabled?: unknown;
    },
  ): KbRule {
    const existing = knowledgeDb.getRule(id);
    if (!existing) throw notFound('Rule');
    const updated = knowledgeDb.updateRule(id, {
      projectId: readOptionalProjectId(patch.projectId),
      title: patch.title === undefined ? undefined : readTitle(patch.title),
      content: patch.content === undefined ? undefined : readContent(patch.content),
      priority: patch.priority === undefined ? undefined : readPriority(patch.priority),
      enabled: patch.enabled === undefined ? undefined : readBoolean(patch.enabled, true),
    });
    if (!updated) throw notFound('Rule');
    snapshot('rule', updated);
    return updated;
  },

  deleteRule(id: string): void {
    const existing = knowledgeDb.getRule(id);
    if (!existing) throw notFound('Rule');
    snapshot('rule', existing);
    knowledgeDb.deleteRule(id);
  },

  // ---------------------------------------------------------------- skills

  listSkills(filter: KnowledgeListFilter): KbPage<KbSkill> {
    return knowledgeDb.listSkills({
      category: filter.category,
      limit: filter.limit,
      offset: filter.offset,
    });
  },

  getSkill(id: string): KbSkill {
    const skill = knowledgeDb.getSkill(id);
    if (!skill) throw notFound('Skill');
    return skill;
  },

  createSkill(input: {
    name: unknown;
    description?: unknown;
    content?: unknown;
    category?: unknown;
    icon?: unknown;
  }): KbSkill {
    const name = readRequiredString(input.name, 'name', 120);
    let skill: KbSkill;
    try {
      skill = knowledgeDb.createSkill({
        name,
        description: input.description === undefined ? '' : readRequiredString(input.description, 'description', 2000).trim(),
        content: readContent(input.content),
        category: input.category === undefined ? 'general' : readRequiredString(input.category, 'category', 60),
        icon: readIcon(input.icon),
      });
    } catch (error) {
      rethrowConstraint(error, `A skill named "${name}" already exists.`);
    }
    snapshot('skill', skill);
    return skill;
  },

  updateSkill(
    id: string,
    patch: { name?: unknown; description?: unknown; content?: unknown; category?: unknown; icon?: unknown },
  ): KbSkill {
    const existing = knowledgeDb.getSkill(id);
    if (!existing) throw notFound('Skill');
    let updated: KbSkill | null;
    try {
      updated = knowledgeDb.updateSkill(id, {
        name: patch.name === undefined ? undefined : readRequiredString(patch.name, 'name', 120),
        description:
          patch.description === undefined
            ? undefined
            : patch.description === ''
              ? ''
              : readRequiredString(patch.description, 'description', 2000),
        content: patch.content === undefined ? undefined : readContent(patch.content),
        category:
          patch.category === undefined ? undefined : readRequiredString(patch.category, 'category', 60),
        icon: patch.icon === undefined ? undefined : readIcon(patch.icon),
      });
    } catch (error) {
      rethrowConstraint(error, 'A skill with that name already exists.');
    }
    if (!updated) throw notFound('Skill');
    snapshot('skill', updated);
    return updated;
  },

  deleteSkill(id: string): void {
    const existing = knowledgeDb.getSkill(id);
    if (!existing) throw notFound('Skill');
    snapshot('skill', existing);
    knowledgeDb.deleteSkill(id);
  },

  // -------------------------------------------------------------- personal

  listPersonal(filter: KnowledgeListFilter): KbPage<KbPersonalInfo> {
    return knowledgeDb.listPersonal({ limit: filter.limit, offset: filter.offset });
  },

  getPersonal(id: string): KbPersonalInfo {
    const info = knowledgeDb.getPersonal(id);
    if (!info) throw notFound('Personal information');
    return info;
  },

  createPersonal(input: { key: unknown; title: unknown; content?: unknown }): KbPersonalInfo {
    const key = readKey(input.key);
    let info: KbPersonalInfo;
    try {
      info = knowledgeDb.createPersonal({
        key,
        title: readTitle(input.title),
        content: readContent(input.content),
      });
    } catch (error) {
      rethrowConstraint(error, `Personal key "${key}" already exists.`);
    }
    snapshot('personal', info);
    return info;
  },

  updatePersonal(id: string, patch: { key?: unknown; title?: unknown; content?: unknown }): KbPersonalInfo {
    const existing = knowledgeDb.getPersonal(id);
    if (!existing) throw notFound('Personal information');
    let updated: KbPersonalInfo | null;
    try {
      updated = knowledgeDb.updatePersonal(id, {
        key: patch.key === undefined ? undefined : readKey(patch.key),
        title: patch.title === undefined ? undefined : readTitle(patch.title),
        content: patch.content === undefined ? undefined : readContent(patch.content),
      });
    } catch (error) {
      rethrowConstraint(error, 'Personal key already exists.');
    }
    if (!updated) throw notFound('Personal information');
    snapshot('personal', updated);
    return updated;
  },

  deletePersonal(id: string): void {
    const existing = knowledgeDb.getPersonal(id);
    if (!existing) throw notFound('Personal information');
    snapshot('personal', existing);
    knowledgeDb.deletePersonal(id);
  },

  // ------------------------------------------------------------------ tags

  listTags(): Array<{ id: number; name: string; count: number }> {
    return knowledgeDb.listTags();
  },

  deleteTag(id: number): void {
    if (!knowledgeDb.deleteTag(id)) throw notFound('Tag');
  },

  // ----------------------------------------------------------- connections

  listConnections(filter: { entityId?: string; limit?: number }): KbConnection[] {
    return knowledgeDb.listConnections(filter);
  },

  createConnection(input: {
    sourceId: unknown;
    sourceType: unknown;
    targetId: unknown;
    targetType: unknown;
    relationship?: unknown;
    weight?: unknown;
  }): KbConnection {
    const weight =
      input.weight === undefined || input.weight === null ? 1 : Number(input.weight);
    if (!Number.isFinite(weight) || weight < 0 || weight > 1) {
      throw badRequest('weight must be a number between 0 and 1.');
    }
    return knowledgeDb.createConnection({
      sourceId: readRequiredString(input.sourceId, 'sourceId'),
      sourceType: readRequiredString(input.sourceType, 'sourceType', 40),
      targetId: readRequiredString(input.targetId, 'targetId'),
      targetType: readRequiredString(input.targetType, 'targetType', 40),
      relationship:
        input.relationship === undefined
          ? 'related'
          : readRequiredString(input.relationship, 'relationship', 60),
      weight,
    });
  },

  deleteConnection(id: string): void {
    if (!knowledgeDb.deleteConnection(id)) throw notFound('Connection');
  },

  // --------------------------------------------------------------- history

  listHistory(filter: { entityType?: string; entityId?: string; limit?: number }): KbHistoryEntry[] {
    return knowledgeDb.listHistory(filter);
  },

  // ---------------------------------------------------------------- search

  search(
    query: string,
    filter: { entityType?: KnowledgeEntityKind; projectId?: string | null; limit?: number } = {},
  ): KbSearchResult[] {
    const trimmed = query.trim();
    if (!trimmed) return [];
    return knowledgeDb.search(trimmed, filter);
  },

  stats(): ReturnType<typeof knowledgeDb.stats> {
    return knowledgeDb.stats();
  },

  // ----------------------------------------------------------------- graph

  /**
   * Assembles the relation graph for the UI: capped entity nodes (optionally
   * scoped to a project) plus the explicit connections whose endpoints are both
   * present. Never materializes the whole database — the node cap is hard.
   */
  graph(filter: { projectId?: string | null; entityTypes?: string[]; limit?: number } = {}): KnowledgeGraph {
    const limit = Math.min(Math.max(filter.limit ?? 300, 1), 500);
    const wanted = (kind: string) => !filter.entityTypes || filter.entityTypes.includes(kind);
    const scope = { projectId: filter.projectId, includeGlobal: true, limit };
    const nodes: KnowledgeGraph['nodes'] = [];
    const counts: Record<string, number> = { memory: 0, rule: 0, skill: 0, personal: 0 };

    if (wanted('memory')) {
      for (const memory of knowledgeDb.listMemories(scope).items) {
        nodes.push({
          id: memory.id,
          nodeType: 'memory',
          label: memory.title,
          projectId: memory.projectId,
          priority: memory.priority,
          icon: null,
        });
      }
    }
    if (wanted('rule')) {
      for (const rule of knowledgeDb.listRules(scope).items) {
        nodes.push({
          id: rule.id,
          nodeType: 'rule',
          label: rule.title,
          projectId: rule.projectId,
          priority: rule.priority,
          icon: null,
        });
      }
    }
    if (wanted('skill')) {
      for (const skill of knowledgeDb.listSkills({ limit }).items) {
        nodes.push({
          id: skill.id,
          nodeType: 'skill',
          label: skill.name,
          projectId: null,
          priority: null,
          icon: skill.icon || null,
        });
      }
    }
    if (wanted('personal')) {
      for (const info of knowledgeDb.listPersonal({ limit }).items) {
        nodes.push({
          id: info.id,
          nodeType: 'personal',
          label: info.title,
          projectId: null,
          priority: null,
          icon: null,
        });
      }
    }

    const truncated = nodes.length > limit;
    const capped = nodes.slice(0, limit);
    for (const node of capped) counts[node.nodeType] = (counts[node.nodeType] ?? 0) + 1;
    const included = new Set(capped.map((node) => node.id));
    const edges = knowledgeDb
      .listConnections({ limit: 5000 })
      .filter((edge) => included.has(edge.sourceId) && included.has(edge.targetId))
      .map((edge) => ({
        id: edge.id,
        source: edge.sourceId,
        target: edge.targetId,
        relationship: edge.relationship,
        weight: edge.weight,
      }));
    return { nodes: capped, edges, truncated, counts };
  },

  // ---------------------------------------------------------- export/import

  exportAll(): KnowledgeExport {
    return {
      version: 1,
      exportedAt: new Date().toISOString(),
      memories: collectAll((offset) => knowledgeDb.listMemories({ limit: 200, offset })),
      rules: collectAll((offset) => knowledgeDb.listRules({ limit: 300, offset })),
      skills: collectAll((offset) => knowledgeDb.listSkills({ limit: 300, offset })),
      personal: collectAll((offset) => knowledgeDb.listPersonal({ limit: 300, offset })),
      connections: knowledgeDb.listConnections({ limit: 5000 }),
    };
  },

  /**
   * Best-effort import of an exported payload. Entries are created as new rows
   * (ids are reassigned) and invalid rows are skipped rather than aborting the
   * whole import, so a partially corrupted backup still restores the rest.
   */
  importAll(payload: unknown): { memories: number; rules: number; skills: number; personal: number } {
    if (!payload || typeof payload !== 'object') {
      throw badRequest('Invalid import payload.');
    }
    const data = payload as Record<string, unknown>;
    const counts = { memories: 0, rules: 0, skills: 0, personal: 0 };
    const forEach = (value: unknown, run: (entry: Record<string, unknown>) => void) => {
      if (!Array.isArray(value)) return;
      for (const entry of value) {
        if (entry && typeof entry === 'object') run(entry as Record<string, unknown>);
      }
    };
    forEach(data.memories, (entry) => {
      try {
        knowledgeDb.createMemory({
          projectId: readOptionalProjectId(entry.projectId) ?? null,
          title: readTitle(entry.title),
          content: readContent(entry.content),
          memoryType: readMemoryType(entry.memoryType),
          priority: readPriority(entry.priority),
          source: readSource(entry.source, 'import'),
          tags: readTags(entry.tags) ?? [],
        });
        counts.memories += 1;
      } catch {
        // Skip malformed rows; import stays best-effort.
      }
    });
    forEach(data.rules, (entry) => {
      try {
        knowledgeDb.createRule({
          projectId: readOptionalProjectId(entry.projectId) ?? null,
          title: readTitle(entry.title),
          content: readContent(entry.content),
          priority: readPriority(entry.priority),
          enabled: readBoolean(entry.enabled, true),
        });
        counts.rules += 1;
      } catch {
        // Skip malformed rows.
      }
    });
    forEach(data.skills, (entry) => {
      try {
        const name = readRequiredString(entry.name, 'name', 120);
        if (knowledgeDb.findSkillByName(name)) return;
        knowledgeDb.createSkill({
          name,
          description: typeof entry.description === 'string' ? entry.description : '',
          content: readContent(entry.content),
          category: typeof entry.category === 'string' && entry.category ? entry.category : 'general',
          icon: readIcon(entry.icon),
        });
        counts.skills += 1;
      } catch {
        // Skip malformed rows.
      }
    });
    forEach(data.personal, (entry) => {
      try {
        const key = readKey(entry.key);
        if (knowledgeDb.findPersonalByKey(key)) return;
        knowledgeDb.createPersonal({ key, title: readTitle(entry.title), content: readContent(entry.content) });
        counts.personal += 1;
      } catch {
        // Skip malformed rows.
      }
    });
    return counts;
  },
};

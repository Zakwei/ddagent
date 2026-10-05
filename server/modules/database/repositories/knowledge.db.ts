import { randomUUID } from 'node:crypto';

import { getConnection } from '@/modules/database/connection.js';

/**
 * Knowledge-base persistence (Contexta-style local memory layer).
 *
 * Consumers: the Knowledge module (CRUD services, search, context builder,
 * project scanner) and the MCP tool adapters. Rows are returned as camelCase
 * DTOs; `project_id` stays a plain string (no FK) and is resolved by the
 * Projects module at read time — see `KB_TABLES_SCHEMA_SQL` in schema.ts.
 */

export type KbPriority = 'critical' | 'high' | 'normal' | 'low';

export type KbMemoryType = 'fact' | 'decision' | 'note' | 'reference' | string;

export type KbEntityType = 'memory' | 'rule' | 'skill' | 'personal';

export type KbMemory = {
  id: string;
  projectId: string | null;
  title: string;
  content: string;
  memoryType: string;
  priority: string;
  source: string;
  tags: string[];
  createdAt: string;
  updatedAt: string;
};

export type KbRule = {
  id: string;
  projectId: string | null;
  title: string;
  content: string;
  priority: string;
  enabled: boolean;
  createdAt: string;
  updatedAt: string;
};

export type KbSkill = {
  id: string;
  name: string;
  description: string;
  content: string;
  category: string;
  icon: string;
  createdAt: string;
  updatedAt: string;
};

export type KbPersonalInfo = {
  id: string;
  key: string;
  title: string;
  content: string;
  createdAt: string;
  updatedAt: string;
};

export type KbConnection = {
  id: string;
  sourceId: string;
  sourceType: string;
  targetId: string;
  targetType: string;
  relationship: string;
  weight: number;
  createdAt: string;
};

export type KbHistoryEntry = {
  id: string;
  entityType: string;
  entityId: string;
  title: string;
  content: string;
  createdAt: string;
};

export type KbSearchResult = {
  entityType: string;
  entityId: string;
  projectId: string | null;
  title: string;
  snippet: string;
  score: number;
};

export type KbScanStateRow = {
  projectId: string;
  path: string;
  contentHash: string;
  entityType: string;
  entityId: string | null;
  updatedAt: string;
};

type MemoryRow = {
  id: string;
  project_id: string | null;
  title: string;
  content: string;
  memory_type: string;
  priority: string;
  source: string;
  created_at: string;
  updated_at: string;
};

type RuleRow = {
  id: string;
  project_id: string | null;
  title: string;
  content: string;
  priority: string;
  enabled: number;
  created_at: string;
  updated_at: string;
};

type SkillRow = {
  id: string;
  name: string;
  description: string;
  content: string;
  category: string;
  icon: string;
  created_at: string;
  updated_at: string;
};

type PersonalRow = {
  id: string;
  key: string;
  title: string;
  content: string;
  created_at: string;
  updated_at: string;
};

type ConnectionRow = {
  id: string;
  source_id: string;
  source_type: string;
  target_id: string;
  target_type: string;
  relationship: string;
  weight: number;
  created_at: string;
};

type HistoryRow = {
  id: string;
  entity_type: string;
  entity_id: string;
  title: string;
  content: string;
  created_at: string;
};

type ScanStateDbRow = {
  project_id: string;
  path: string;
  content_hash: string;
  entity_type: string;
  entity_id: string | null;
  updated_at: string;
};

/**
 * Turns arbitrary user text into a safe FTS5 MATCH expression (Contexta's
 * `sanitize_match`): each whitespace word is reduced to its alphanumeric /
 * `_` / `-` characters, the first 10 are kept, and every term becomes a
 * double-quoted **prefix** query (`"term"*`), joined with implicit AND. A
 * prefix lets "auth" match "authentication". Returns null when no usable term
 * remains (caller falls back to a recency listing).
 */
function buildFtsQuery(raw: string): string | null {
  const terms = raw
    .split(/\s+/)
    .map((token) => token.replace(/[^\p{L}\p{N}_-]+/gu, ''))
    .filter((token) => token.length > 0)
    .slice(0, 10);
  if (terms.length === 0) return null;
  return terms.map((term) => `"${term}"*`).join(' ');
}

// ---------------------------------------------------------------------------
// Hybrid search helpers (Contexta's search.rs: fuzzy trigram + priority/recency)
// ---------------------------------------------------------------------------

/** Char-trigram counts over words of length >= 3 (padded so short words yield one). */
function trigramCounts(value: string): Map<string, number> {
  const counts = new Map<string, number>();
  const words = value
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s]+/gu, '')
    .split(/\s+/)
    .filter((word) => word.length >= 3);
  for (const word of words) {
    const padded = ` ${word} `;
    for (let i = 0; i + 3 <= padded.length; i += 1) {
      const trigram = padded.slice(i, i + 3);
      counts.set(trigram, (counts.get(trigram) ?? 0) + 1);
    }
  }
  return counts;
}

/** Cosine similarity of two trigram-count vectors. */
function cosine(a: Map<string, number>, b: Map<string, number>): number {
  if (a.size === 0 || b.size === 0) return 0;
  const [small, big] = a.size <= b.size ? [a, b] : [b, a];
  let dot = 0;
  for (const [key, value] of small) dot += value * (big.get(key) ?? 0);
  const norm = (map: Map<string, number>) =>
    Math.sqrt([...map.values()].reduce((sum, value) => sum + value * value, 0));
  return dot / (norm(a) * norm(b));
}

/** Contexta's priority bonus (lower priorities rank well below critical). */
function priorityBonus(priority: string | null): number {
  switch (priority) {
    case 'critical':
      return 8;
    case 'high':
      return 4;
    case 'normal':
      return 1.5;
    case 'low':
      return 0;
    default:
      return 1;
  }
}

/** Contexta's recency bonus over an ISO/SQLite timestamp. */
function recencyBonus(updatedAt: string): number {
  const timestamp = Date.parse(updatedAt.includes('T') ? updatedAt : `${updatedAt.replace(' ', 'T')}Z`);
  if (Number.isNaN(timestamp)) return 0;
  const days = (Date.now() - timestamp) / 86_400_000;
  if (days < 1) return 3;
  if (days < 7) return 2;
  if (days < 30) return 1;
  return 0;
}


const toMemory = (row: MemoryRow): KbMemory => ({
  id: row.id,
  projectId: row.project_id,
  title: row.title,
  content: row.content,
  memoryType: row.memory_type,
  priority: row.priority,
  source: row.source,
  tags: [],
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const toRule = (row: RuleRow): KbRule => ({
  id: row.id,
  projectId: row.project_id,
  title: row.title,
  content: row.content,
  priority: row.priority,
  enabled: row.enabled === 1,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const toSkill = (row: SkillRow): KbSkill => ({
  id: row.id,
  name: row.name,
  description: row.description,
  content: row.content,
  category: row.category,
  icon: row.icon,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const toPersonal = (row: PersonalRow): KbPersonalInfo => ({
  id: row.id,
  key: row.key,
  title: row.title,
  content: row.content,
  createdAt: row.created_at,
  updatedAt: row.updated_at,
});

const toConnection = (row: ConnectionRow): KbConnection => ({
  id: row.id,
  sourceId: row.source_id,
  sourceType: row.source_type,
  targetId: row.target_id,
  targetType: row.target_type,
  relationship: row.relationship,
  weight: row.weight,
  createdAt: row.created_at,
});

const toHistory = (row: HistoryRow): KbHistoryEntry => ({
  id: row.id,
  entityType: row.entity_type,
  entityId: row.entity_id,
  title: row.title,
  content: row.content,
  createdAt: row.created_at,
});

/**
 * Builds the SQL fragment that scopes a query by project.
 *
 * `undefined` = no scoping filter; `null` = global rows only; a project id with
 * `includeGlobal` matches the project plus global rows, otherwise the project
 * only. Returned as { clause, params } so callers append it to their own WHERE.
 */
function projectScopeClause(
  projectId: string | null | undefined,
  includeGlobal: boolean,
): { clause: string | null; params: string[] } {
  if (projectId === undefined) return { clause: null, params: [] };
  if (projectId === null) return { clause: 'project_id IS NULL', params: [] };
  if (includeGlobal) {
    return { clause: '(project_id = ? OR project_id IS NULL)', params: [projectId] };
  }
  return { clause: 'project_id = ?', params: [projectId] };
}

/** Paged result shared by every knowledge list endpoint. */
export type KbPage<T> = { items: T[]; total: number };

type FtsHit = {
  entity_type: string;
  entity_id: string;
  project_id: string | null;
  title: string;
  snippet: string;
  rank: number;
};

type MergedHit = {
  entityType: string;
  entityId: string;
  projectId: string | null;
  title: string;
  snippet: string;
  fts: number;
  similarity: number;
};

/** Entity tables fuzzy search scans (title col, content col, project-scoped). */
const FUZZY_BRANCHES: Array<{
  entityType: string;
  table: string;
  titleCol: string;
  contentCol: string;
  projectScoped: boolean;
}> = [
  { entityType: 'memory', table: 'kb_memories', titleCol: 'title', contentCol: 'content', projectScoped: true },
  { entityType: 'rule', table: 'kb_rules', titleCol: 'title', contentCol: 'content', projectScoped: true },
  { entityType: 'skill', table: 'kb_skills', titleCol: 'name', contentCol: 'description', projectScoped: false },
  {
    entityType: 'personal',
    table: 'kb_personal_information',
    titleCol: 'title',
    contentCol: 'content',
    projectScoped: false,
  },
];

/**
 * Contexta's `fuzzy_hits`: char-trigram cosine over `title + content head` of
 * the 120 most-recent rows per table, keeping hits above 0.12. Catches typos
 * and near-synonyms FTS prefix matching misses. Bounded — never scans a whole
 * table.
 */
function fuzzyHits(
  db: ReturnType<typeof getConnection>,
  query: string,
  filter: { entityType?: KbEntityType; projectId?: string | null },
  cap: number,
): Array<{
  entityType: string;
  entityId: string;
  projectId: string | null;
  title: string;
  snippet: string;
  similarity: number;
}> {
  const queryVector = trigramCounts(query);
  if (queryVector.size === 0) return [];
  const hits: Array<{
    entityType: string;
    entityId: string;
    projectId: string | null;
    title: string;
    snippet: string;
    similarity: number;
  }> = [];
  for (const branch of FUZZY_BRANCHES) {
    if (filter.entityType && filter.entityType !== branch.entityType) continue;
    const projectCol = branch.projectScoped ? 'project_id' : 'NULL';
    const rows = db
      .prepare(
        `SELECT id AS id, ${branch.titleCol} AS title,
                ${branch.titleCol} || ' ' || substr(${branch.contentCol}, 1, 200) AS text,
                ${projectCol} AS project_id
         FROM ${branch.table} ORDER BY updated_at DESC LIMIT 120`,
      )
      .all() as Array<{ id: string; title: string; text: string; project_id: string | null }>;
    for (const row of rows) {
      if (branch.projectScoped && filter.projectId !== undefined) {
        if (filter.projectId === null) {
          if (row.project_id !== null) continue;
        } else if (row.project_id !== filter.projectId) {
          continue;
        }
      }
      const similarity = cosine(queryVector, trigramCounts(row.text));
      if (similarity > 0.12) {
        hits.push({
          entityType: branch.entityType,
          entityId: row.id,
          projectId: row.project_id,
          title: row.title,
          snippet: row.text.slice(0, 160),
          similarity,
        });
      }
    }
  }
  hits.sort((a, b) => b.similarity - a.similarity);
  return hits.slice(0, Math.min(Math.max(cap, 1), 50));
}

/** Loads `{ priority, updatedAt }` for a batch of hits, grouped by entity type. */
function hydrateMeta(
  db: ReturnType<typeof getConnection>,
  hits: MergedHit[],
): Map<string, { priority: string | null; updatedAt: string }> {
  const meta = new Map<string, { priority: string | null; updatedAt: string }>();
  const byType = new Map<string, string[]>();
  for (const hit of hits) {
    const list = byType.get(hit.entityType) ?? [];
    list.push(hit.entityId);
    byType.set(hit.entityType, list);
  }
  const table = (entityType: string) =>
    FUZZY_BRANCHES.find((branch) => branch.entityType === entityType)?.table;
  for (const [entityType, ids] of byType) {
    const source = table(entityType);
    if (!source) continue;
    const placeholders = ids.map(() => '?').join(', ');
    const hasPriority = entityType === 'memory' || entityType === 'rule';
    const rows = db
      .prepare(
        `SELECT id, ${hasPriority ? 'priority' : 'NULL'} AS priority, updated_at
         FROM ${source} WHERE id IN (${placeholders})`,
      )
      .all(...ids) as Array<{ id: string; priority: string | null; updated_at: string }>;
    for (const row of rows) {
      meta.set(`${entityType}:${row.id}`, { priority: row.priority, updatedAt: row.updated_at });
    }
  }
  return meta;
}

export const knowledgeDb = {
  // ----------------------------------------------------------------- memories

  listMemories(filter: {
    projectId?: string | null;
    includeGlobal?: boolean;
    memoryType?: string;
    priority?: string;
    tag?: string;
    limit?: number;
    offset?: number;
  }): KbPage<KbMemory> {
    const db = getConnection();
    const clauses: string[] = [];
    const params: unknown[] = [];
    const scope = projectScopeClause(filter.projectId, filter.includeGlobal === true);
    if (scope.clause) {
      clauses.push(scope.clause);
      params.push(...scope.params);
    }
    if (filter.memoryType) {
      clauses.push('memory_type = ?');
      params.push(filter.memoryType);
    }
    if (filter.priority) {
      clauses.push('priority = ?');
      params.push(filter.priority);
    }
    if (filter.tag) {
      clauses.push(
        'EXISTS (SELECT 1 FROM kb_memory_tags mt JOIN kb_tags t ON t.id = mt.tag_id WHERE mt.memory_id = kb_memories.id AND t.name = ?)',
      );
      params.push(filter.tag);
    }
    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
    const total = (
      db.prepare(`SELECT COUNT(*) AS n FROM kb_memories ${where}`).get(...params) as { n: number }
    ).n;
    const limit = Math.min(Math.max(filter.limit ?? 50, 1), 200);
    const offset = Math.max(filter.offset ?? 0, 0);
    const rows = db
      .prepare(
        `SELECT * FROM kb_memories ${where} ORDER BY updated_at DESC, id LIMIT ? OFFSET ?`,
      )
      .all(...params, limit, offset) as MemoryRow[];
    const items = rows.map(toMemory);
    this.attachMemoryTags(items);
    return { items, total };
  },

  /** Every memory row (no cap) — used by the one-time migration/dedupe pass. */
  allMemories(): KbMemory[] {
    const items = (
      getConnection().prepare('SELECT * FROM kb_memories ORDER BY rowid').all() as MemoryRow[]
    ).map(toMemory);
    this.attachMemoryTags(items);
    return items;
  },

  getMemory(id: string): KbMemory | null {
    const row = getConnection().prepare('SELECT * FROM kb_memories WHERE id = ?').get(id) as
      | MemoryRow
      | undefined;
    if (!row) return null;
    const memory = toMemory(row);
    this.attachMemoryTags([memory]);
    return memory;
  },

  createMemory(input: {
    projectId?: string | null;
    title: string;
    content: string;
    memoryType?: string;
    priority?: string;
    source?: string;
    tags?: string[];
  }): KbMemory {
    const id = randomUUID();
    getConnection()
      .prepare(
        `INSERT INTO kb_memories (id, project_id, title, content, memory_type, priority, source)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
      )
      .run(
        id,
        input.projectId ?? null,
        input.title,
        input.content,
        input.memoryType ?? 'fact',
        input.priority ?? 'normal',
        input.source ?? 'manual',
      );
    if (input.tags) this.setMemoryTags(id, input.tags);
    return this.getMemory(id) as KbMemory;
  },

  updateMemory(
    id: string,
    patch: {
      projectId?: string | null;
      title?: string;
      content?: string;
      memoryType?: string;
      priority?: string;
      source?: string;
      tags?: string[];
    },
  ): KbMemory | null {
    const existing = this.getMemory(id);
    if (!existing) return null;
    const sets: string[] = [];
    const params: unknown[] = [];
    const assign = (column: string, value: unknown, present: boolean) => {
      if (!present) return;
      sets.push(`${column} = ?`);
      params.push(value);
    };
    assign('project_id', patch.projectId, patch.projectId !== undefined);
    assign('title', patch.title, patch.title !== undefined);
    assign('content', patch.content, patch.content !== undefined);
    assign('memory_type', patch.memoryType, patch.memoryType !== undefined);
    assign('priority', patch.priority, patch.priority !== undefined);
    assign('source', patch.source, patch.source !== undefined);
    if (sets.length > 0) {
      getConnection()
        .prepare(
          `UPDATE kb_memories SET ${sets.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
        )
        .run(...params, id);
    }
    if (patch.tags !== undefined) this.setMemoryTags(id, patch.tags);
    return this.getMemory(id);
  },

  deleteMemory(id: string): boolean {
    return getConnection().prepare('DELETE FROM kb_memories WHERE id = ?').run(id).changes > 0;
  },

  /** Attaches each memory's tag names in place (n+1 avoided by one grouped query). */
  attachMemoryTags(memories: KbMemory[]): void {
    if (memories.length === 0) return;
    const db = getConnection();
    const placeholders = memories.map(() => '?').join(', ');
    const rows = db
      .prepare(
        `SELECT mt.memory_id AS memory_id, t.name AS name
         FROM kb_memory_tags mt JOIN kb_tags t ON t.id = mt.tag_id
         WHERE mt.memory_id IN (${placeholders})
         ORDER BY t.name`,
      )
      .all(...memories.map((m) => m.id)) as Array<{ memory_id: string; name: string }>;
    const byMemory = new Map<string, string[]>();
    for (const row of rows) {
      const list = byMemory.get(row.memory_id) ?? [];
      list.push(row.name);
      byMemory.set(row.memory_id, list);
    }
    for (const memory of memories) {
      memory.tags = byMemory.get(memory.id) ?? [];
    }
  },

  /** Replaces a memory's tag links with the given names, creating missing tags. */
  setMemoryTags(memoryId: string, tagNames: string[]): void {
    const db = getConnection();
    db.prepare('DELETE FROM kb_memory_tags WHERE memory_id = ?').run(memoryId);
    const cleaned = [...new Set(tagNames.map((name) => name.trim()).filter(Boolean))];
    for (const name of cleaned) {
      const tagId = this.ensureTag(name);
      db.prepare('INSERT OR IGNORE INTO kb_memory_tags (memory_id, tag_id) VALUES (?, ?)').run(
        memoryId,
        tagId,
      );
    }
  },

  // --------------------------------------------------------------------- tags

  ensureTag(name: string): number {
    const db = getConnection();
    db.prepare('INSERT OR IGNORE INTO kb_tags (name) VALUES (?)').run(name);
    return (db.prepare('SELECT id FROM kb_tags WHERE name = ?').get(name) as { id: number }).id;
  },

  listTags(): Array<{ id: number; name: string; count: number }> {
    return getConnection()
      .prepare(
        `SELECT t.id AS id, t.name AS name, COUNT(mt.memory_id) AS count
         FROM kb_tags t LEFT JOIN kb_memory_tags mt ON mt.tag_id = t.id
         GROUP BY t.id, t.name ORDER BY t.name`,
      )
      .all() as Array<{ id: number; name: string; count: number }>;
  },

  deleteTag(id: number): boolean {
    return getConnection().prepare('DELETE FROM kb_tags WHERE id = ?').run(id).changes > 0;
  },

  // -------------------------------------------------------------------- rules

  listRules(filter: {
    projectId?: string | null;
    includeGlobal?: boolean;
    enabledOnly?: boolean;
    priority?: string;
    limit?: number;
    offset?: number;
  }): KbPage<KbRule> {
    const db = getConnection();
    const clauses: string[] = [];
    const params: unknown[] = [];
    const scope = projectScopeClause(filter.projectId, filter.includeGlobal === true);
    if (scope.clause) {
      clauses.push(scope.clause);
      params.push(...scope.params);
    }
    if (filter.enabledOnly) clauses.push('enabled = 1');
    if (filter.priority) {
      clauses.push('priority = ?');
      params.push(filter.priority);
    }
    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
    const total = (
      db.prepare(`SELECT COUNT(*) AS n FROM kb_rules ${where}`).get(...params) as { n: number }
    ).n;
    const limit = Math.min(Math.max(filter.limit ?? 100, 1), 300);
    const offset = Math.max(filter.offset ?? 0, 0);
    const rows = db
      .prepare(`SELECT * FROM kb_rules ${where} ORDER BY updated_at DESC, id LIMIT ? OFFSET ?`)
      .all(...params, limit, offset) as RuleRow[];
    return { items: rows.map(toRule), total };
  },

  /** Every rule row (no cap) — used by the one-time migration/dedupe pass. */
  allRules(): KbRule[] {
    return (
      getConnection().prepare('SELECT * FROM kb_rules ORDER BY rowid').all() as RuleRow[]
    ).map(toRule);
  },

  getRule(id: string): KbRule | null {
    const row = getConnection().prepare('SELECT * FROM kb_rules WHERE id = ?').get(id) as
      | RuleRow
      | undefined;
    return row ? toRule(row) : null;
  },

  createRule(input: {
    projectId?: string | null;
    title: string;
    content: string;
    priority?: string;
    enabled?: boolean;
  }): KbRule {
    const id = randomUUID();
    getConnection()
      .prepare(
        `INSERT INTO kb_rules (id, project_id, title, content, priority, enabled)
         VALUES (?, ?, ?, ?, ?, ?)`,
      )
      .run(
        id,
        input.projectId ?? null,
        input.title,
        input.content,
        input.priority ?? 'normal',
        input.enabled === false ? 0 : 1,
      );
    return this.getRule(id) as KbRule;
  },

  updateRule(
    id: string,
    patch: {
      projectId?: string | null;
      title?: string;
      content?: string;
      priority?: string;
      enabled?: boolean;
    },
  ): KbRule | null {
    const existing = this.getRule(id);
    if (!existing) return null;
    const sets: string[] = [];
    const params: unknown[] = [];
    const assign = (column: string, value: unknown, present: boolean) => {
      if (!present) return;
      sets.push(`${column} = ?`);
      params.push(value);
    };
    assign('project_id', patch.projectId, patch.projectId !== undefined);
    assign('title', patch.title, patch.title !== undefined);
    assign('content', patch.content, patch.content !== undefined);
    assign('priority', patch.priority, patch.priority !== undefined);
    assign('enabled', patch.enabled === undefined ? undefined : patch.enabled ? 1 : 0, patch.enabled !== undefined);
    if (sets.length > 0) {
      getConnection()
        .prepare(`UPDATE kb_rules SET ${sets.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`)
        .run(...params, id);
    }
    return this.getRule(id);
  },

  deleteRule(id: string): boolean {
    return getConnection().prepare('DELETE FROM kb_rules WHERE id = ?').run(id).changes > 0;
  },

  // ------------------------------------------------------------------- skills

  listSkills(filter: { category?: string; limit?: number; offset?: number }): KbPage<KbSkill> {
    const db = getConnection();
    const clauses: string[] = [];
    const params: unknown[] = [];
    if (filter.category) {
      clauses.push('category = ?');
      params.push(filter.category);
    }
    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
    const total = (
      db.prepare(`SELECT COUNT(*) AS n FROM kb_skills ${where}`).get(...params) as { n: number }
    ).n;
    const limit = Math.min(Math.max(filter.limit ?? 100, 1), 300);
    const offset = Math.max(filter.offset ?? 0, 0);
    const rows = db
      .prepare(`SELECT * FROM kb_skills ${where} ORDER BY name LIMIT ? OFFSET ?`)
      .all(...params, limit, offset) as SkillRow[];
    return { items: rows.map(toSkill), total };
  },

  getSkill(id: string): KbSkill | null {
    const row = getConnection().prepare('SELECT * FROM kb_skills WHERE id = ?').get(id) as
      | SkillRow
      | undefined;
    return row ? toSkill(row) : null;
  },

  findSkillByName(name: string): KbSkill | null {
    const row = getConnection().prepare('SELECT * FROM kb_skills WHERE name = ?').get(name) as
      | SkillRow
      | undefined;
    return row ? toSkill(row) : null;
  },

  createSkill(input: {
    name: string;
    description?: string;
    content?: string;
    category?: string;
    icon?: string;
  }): KbSkill {
    const id = randomUUID();
    getConnection()
      .prepare(
        `INSERT INTO kb_skills (id, name, description, content, category, icon)
         VALUES (?, ?, ?, ?, ?, ?)`,
      )
      .run(
        id,
        input.name,
        input.description ?? '',
        input.content ?? '',
        input.category ?? 'general',
        input.icon ?? '',
      );
    return this.getSkill(id) as KbSkill;
  },

  updateSkill(
    id: string,
    patch: {
      name?: string;
      description?: string;
      content?: string;
      category?: string;
      icon?: string;
    },
  ): KbSkill | null {
    const existing = this.getSkill(id);
    if (!existing) return null;
    const sets: string[] = [];
    const params: unknown[] = [];
    const assign = (column: string, value: unknown, present: boolean) => {
      if (!present) return;
      sets.push(`${column} = ?`);
      params.push(value);
    };
    assign('name', patch.name, patch.name !== undefined);
    assign('description', patch.description, patch.description !== undefined);
    assign('content', patch.content, patch.content !== undefined);
    assign('category', patch.category, patch.category !== undefined);
    assign('icon', patch.icon, patch.icon !== undefined);
    if (sets.length > 0) {
      getConnection()
        .prepare(`UPDATE kb_skills SET ${sets.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`)
        .run(...params, id);
    }
    return this.getSkill(id);
  },

  deleteSkill(id: string): boolean {
    return getConnection().prepare('DELETE FROM kb_skills WHERE id = ?').run(id).changes > 0;
  },

  // ----------------------------------------------------------------- personal

  listPersonal(filter: { limit?: number; offset?: number } = {}): KbPage<KbPersonalInfo> {
    const db = getConnection();
    const total = (db.prepare('SELECT COUNT(*) AS n FROM kb_personal_information').get() as {
      n: number;
    }).n;
    const limit = Math.min(Math.max(filter.limit ?? 100, 1), 300);
    const offset = Math.max(filter.offset ?? 0, 0);
    const rows = db
      .prepare('SELECT * FROM kb_personal_information ORDER BY key LIMIT ? OFFSET ?')
      .all(limit, offset) as PersonalRow[];
    return { items: rows.map(toPersonal), total };
  },

  getPersonal(id: string): KbPersonalInfo | null {
    const row = getConnection()
      .prepare('SELECT * FROM kb_personal_information WHERE id = ?')
      .get(id) as PersonalRow | undefined;
    return row ? toPersonal(row) : null;
  },

  findPersonalByKey(key: string): KbPersonalInfo | null {
    const row = getConnection()
      .prepare('SELECT * FROM kb_personal_information WHERE key = ?')
      .get(key) as PersonalRow | undefined;
    return row ? toPersonal(row) : null;
  },

  createPersonal(input: { key: string; title: string; content: string }): KbPersonalInfo {
    const id = randomUUID();
    getConnection()
      .prepare(
        'INSERT INTO kb_personal_information (id, key, title, content) VALUES (?, ?, ?, ?)',
      )
      .run(id, input.key, input.title, input.content);
    return this.getPersonal(id) as KbPersonalInfo;
  },

  updatePersonal(
    id: string,
    patch: { key?: string; title?: string; content?: string },
  ): KbPersonalInfo | null {
    const existing = this.getPersonal(id);
    if (!existing) return null;
    const sets: string[] = [];
    const params: unknown[] = [];
    const assign = (column: string, value: unknown, present: boolean) => {
      if (!present) return;
      sets.push(`${column} = ?`);
      params.push(value);
    };
    assign('key', patch.key, patch.key !== undefined);
    assign('title', patch.title, patch.title !== undefined);
    assign('content', patch.content, patch.content !== undefined);
    if (sets.length > 0) {
      getConnection()
        .prepare(
          `UPDATE kb_personal_information SET ${sets.join(', ')}, updated_at = CURRENT_TIMESTAMP WHERE id = ?`,
        )
        .run(...params, id);
    }
    return this.getPersonal(id);
  },

  deletePersonal(id: string): boolean {
    return getConnection()
      .prepare('DELETE FROM kb_personal_information WHERE id = ?')
      .run(id).changes > 0;
  },

  // -------------------------------------------------------------- connections

  listConnections(filter: { entityId?: string; limit?: number } = {}): KbConnection[] {
    const db = getConnection();
    const limit = Math.min(Math.max(filter.limit ?? 1000, 1), 5000);
    if (filter.entityId) {
      return (
        db
          .prepare(
            `SELECT * FROM kb_connections
             WHERE source_id = ? OR target_id = ?
             ORDER BY created_at DESC LIMIT ?`,
          )
          .all(filter.entityId, filter.entityId, limit) as ConnectionRow[]
      ).map(toConnection);
    }
    return (
      db.prepare('SELECT * FROM kb_connections ORDER BY created_at DESC LIMIT ?').all(limit) as
        ConnectionRow[]
    ).map(toConnection);
  },

  createConnection(input: {
    sourceId: string;
    sourceType: string;
    targetId: string;
    targetType: string;
    relationship?: string;
    weight?: number;
  }): KbConnection {
    const id = randomUUID();
    getConnection()
      .prepare(
        `INSERT INTO kb_connections (id, source_id, source_type, target_id, target_type, relationship, weight)
         VALUES (?, ?, ?, ?, ?, ?, ?)`,
      )
      .run(
        id,
        input.sourceId,
        input.sourceType,
        input.targetId,
        input.targetType,
        input.relationship ?? 'related',
        input.weight ?? 1,
      );
    return toConnection(
      getConnection().prepare('SELECT * FROM kb_connections WHERE id = ?').get(id) as ConnectionRow,
    );
  },

  deleteConnection(id: string): boolean {
    return getConnection().prepare('DELETE FROM kb_connections WHERE id = ?').run(id).changes > 0;
  },

  /**
   * Resolves `id -> { entityType, label, priority }` across every knowledge
   * table in one query. Consumers: the context builder (1-hop expansion labels)
   * and the graph service when it needs labels for arbitrary node ids.
   */
  labelsFor(
    ids: string[],
  ): Array<{ id: string; entityType: string; label: string; priority: string | null }> {
    if (ids.length === 0) return [];
    const placeholders = ids.map(() => '?').join(', ');
    const rows = getConnection()
      .prepare(
        `SELECT id, 'memory' AS entity_type, title AS label, priority FROM kb_memories WHERE id IN (${placeholders})
         UNION ALL SELECT id, 'rule', title, priority FROM kb_rules WHERE id IN (${placeholders})
         UNION ALL SELECT id, 'skill', name, NULL FROM kb_skills WHERE id IN (${placeholders})
         UNION ALL SELECT id, 'personal', title, NULL FROM kb_personal_information WHERE id IN (${placeholders})`,
      )
      .all(...ids, ...ids, ...ids, ...ids) as Array<{
      id: string;
      entity_type: string;
      label: string;
      priority: string | null;
    }>;
    return rows.map((row) => ({
      id: row.id,
      entityType: row.entity_type,
      label: row.label,
      priority: row.priority,
    }));
  },

  // ------------------------------------------------------------------ history

  /**
   * Snapshots an entity write. The Knowledge service records the *previous*
   * state before a mutation so agent/MCP writes can be reviewed and reverted;
   * history is bounded per entity by `listHistory`.
   */
  recordHistory(entry: {
    entityType: string;
    entityId: string;
    title?: string;
    content?: string;
  }): void {
    getConnection()
      .prepare(
        'INSERT INTO kb_entity_history (id, entity_type, entity_id, title, content) VALUES (?, ?, ?, ?, ?)',
      )
      .run(randomUUID(), entry.entityType, entry.entityId, entry.title ?? '', entry.content ?? '');
  },

  listHistory(filter: { entityType?: string; entityId?: string; limit?: number }): KbHistoryEntry[] {
    const clauses: string[] = [];
    const params: unknown[] = [];
    if (filter.entityType) {
      clauses.push('entity_type = ?');
      params.push(filter.entityType);
    }
    if (filter.entityId) {
      clauses.push('entity_id = ?');
      params.push(filter.entityId);
    }
    const where = clauses.length ? `WHERE ${clauses.join(' AND ')}` : '';
    const limit = Math.min(Math.max(filter.limit ?? 100, 1), 500);
    return (
      getConnection()
        .prepare(
          // Ordered by rowid (insertion order): created_at has second
          // resolution, so several writes in the same second would otherwise
          // come back in a random order.
          `SELECT * FROM kb_entity_history ${where} ORDER BY rowid DESC LIMIT ?`,
        )
        .all(...params, limit) as HistoryRow[]
    ).map(toHistory);
  },

  // -------------------------------------------------------------------- stats

  stats(): {
    memories: number;
    rules: number;
    skills: number;
    personal: number;
    connections: number;
  } {
    const db = getConnection();
    const count = (table: string) =>
      (db.prepare(`SELECT COUNT(*) AS n FROM ${table}`).get() as { n: number }).n;
    return {
      memories: count('kb_memories'),
      rules: count('kb_rules'),
      skills: count('kb_skills'),
      personal: count('kb_personal_information'),
      connections: count('kb_connections'),
    };
  },

  // -------------------------------------------------------------------- search

  /**
   * Hybrid search (Contexta's `search_hybrid`): FTS5 prefix matching first,
   * fuzzy trigram hits merged in, then reranked by `bm25 + priority + recency`
   * (`-bm25 * 2 + similarity * 10 + priorityBonus + recencyBonus`).
   */
  search(
    query: string,
    filter: { entityType?: KbEntityType; projectId?: string | null; limit?: number } = {},
  ): KbSearchResult[] {
    const matcher = buildFtsQuery(query);
    if (!matcher) return [];
    const db = getConnection();
    const limit = Math.min(Math.max(filter.limit ?? 30, 1), 100);

    const clauses: string[] = ['kb_search_index_fts MATCH ?'];
    const params: unknown[] = [matcher];
    if (filter.entityType) {
      clauses.push('entity_type = ?');
      params.push(filter.entityType);
    }
    if (filter.projectId !== undefined) {
      if (filter.projectId === null) {
        clauses.push('project_id IS NULL');
      } else {
        clauses.push('(project_id = ? OR project_id IS NULL)');
        params.push(filter.projectId);
      }
    }
    const ftsRows = db
      .prepare(
        `SELECT entity_type, entity_id, project_id, title,
                snippet(kb_search_index_fts, 4, '[', ']', ' … ', 12) AS snippet,
                bm25(kb_search_index_fts) AS rank
         FROM kb_search_index_fts
         WHERE ${clauses.join(' AND ')}
         ORDER BY rank LIMIT ?`,
      )
      .all(...params, limit * 2) as FtsHit[];

    const merged = new Map<string, MergedHit>();
    for (const row of ftsRows) {
      merged.set(`${row.entity_type}:${row.entity_id}`, {
        entityType: row.entity_type,
        entityId: row.entity_id,
        projectId: row.project_id,
        title: row.title,
        snippet: row.snippet,
        fts: -row.rank,
        similarity: 0,
      });
    }
    for (const hit of fuzzyHits(db, query, filter, limit)) {
      const key = `${hit.entityType}:${hit.entityId}`;
      const existing = merged.get(key);
      if (existing) {
        existing.similarity = hit.similarity;
      } else {
        merged.set(key, {
          entityType: hit.entityType,
          entityId: hit.entityId,
          projectId: hit.projectId,
          title: hit.title,
          snippet: hit.snippet,
          fts: 0,
          similarity: hit.similarity,
        });
      }
    }

    const hits = [...merged.values()];
    const meta = hydrateMeta(db, hits);
    const results = hits.map((hit) => {
      const info = meta.get(`${hit.entityType}:${hit.entityId}`);
      return {
        entityType: hit.entityType,
        entityId: hit.entityId,
        projectId: hit.projectId,
        title: hit.title,
        snippet: hit.snippet,
        score:
          hit.fts * 2 +
          hit.similarity * 10 +
          priorityBonus(info?.priority ?? null) +
          recencyBonus(info?.updatedAt ?? ''),
      };
    });
    results.sort((a, b) => b.score - a.score);
    return results.slice(0, limit);
  },

  // --------------------------------------------------------------- scan state

  getScanState(projectId: string): KbScanStateRow[] {
    return (
      getConnection()
        .prepare('SELECT * FROM kb_scan_state WHERE project_id = ?')
        .all(projectId) as ScanStateDbRow[]
    ).map((row) => ({
      projectId: row.project_id,
      path: row.path,
      contentHash: row.content_hash,
      entityType: row.entity_type,
      entityId: row.entity_id,
      updatedAt: row.updated_at,
    }));
  },

  upsertScanState(input: {
    projectId: string;
    path: string;
    contentHash: string;
    entityType: string;
    entityId: string | null;
  }): void {
    getConnection()
      .prepare(
        `INSERT INTO kb_scan_state (project_id, path, content_hash, entity_type, entity_id, updated_at)
         VALUES (?, ?, ?, ?, ?, CURRENT_TIMESTAMP)
         ON CONFLICT(project_id, path) DO UPDATE SET
           content_hash = excluded.content_hash,
           entity_type = excluded.entity_type,
           entity_id = excluded.entity_id,
           updated_at = CURRENT_TIMESTAMP`,
      )
      .run(input.projectId, input.path, input.contentHash, input.entityType, input.entityId);
  },

  deleteScanState(projectId: string, path: string): void {
    getConnection()
      .prepare('DELETE FROM kb_scan_state WHERE project_id = ? AND path = ?')
      .run(projectId, path);
  },
};

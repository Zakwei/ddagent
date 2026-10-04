import { knowledgeDb, projectsDb, type KbRule } from '@/modules/database/index.js';

import { knowledgeScanService, type KnowledgeScanResult } from './knowledge-scan.service.js';

/**
 * One-time migration/curation pass over an existing, file-scattered rule set.
 *
 * Consumers: the knowledge routes (`POST /api/knowledge/migrate`) driven from
 * the client's migration dialog. It (1) scans projects so their instruction
 * files become rules/skills/memories, (2) reports duplicate entities that exist
 * across projects (same normalized title + content), and — when not a dry run —
 * (3) merges those duplicates into a single global row and/or promotes every
 * rule to `critical` so it enters the injected context.
 *
 * Dry-run is the default: nothing is written unless `dryRun` is explicitly
 * false, and the destructive actions stay behind their own flags.
 */

export type KnowledgeDuplicateGroup = {
  entityType: 'rule' | 'memory';
  title: string;
  count: number;
  keepId: string;
  dropIds: string[];
};

export type KnowledgeMigrationReport = {
  dryRun: boolean;
  scanned: KnowledgeScanResult[];
  duplicates: KnowledgeDuplicateGroup[];
  rules: { total: number; critical: number; high: number; normal: number; low: number };
  memories: number;
  removed: number;
  promoted: number;
};

const normalize = (value: string): string => value.toLowerCase().replace(/\s+/g, ' ').trim();

const groupKey = (entity: { title: string; content: string }): string =>
  `${normalize(entity.title)}\u0000${normalize(entity.content)}`;

/** Groups rows by normalized title+content; the oldest (listed first) is kept. */
function collectDuplicates(
  entityType: 'rule' | 'memory',
  rows: Array<{ id: string; title: string; content: string }>,
): KnowledgeDuplicateGroup[] {
  const groups = new Map<string, Array<{ id: string; title: string; content: string }>>();
  for (const row of rows) {
    const key = groupKey(row);
    const list = groups.get(key);
    if (list) list.push(row);
    else groups.set(key, [row]);
  }
  const duplicates: KnowledgeDuplicateGroup[] = [];
  for (const list of groups.values()) {
    if (list.length < 2) continue;
    const [keep, ...rest] = list;
    duplicates.push({
      entityType,
      title: keep.title,
      count: list.length,
      keepId: keep.id,
      dropIds: rest.map((row) => row.id),
    });
  }
  return duplicates;
}

const ruleCounts = (rules: KbRule[]): KnowledgeMigrationReport['rules'] => ({
  total: rules.length,
  critical: rules.filter((rule) => rule.priority === 'critical').length,
  high: rules.filter((rule) => rule.priority === 'high').length,
  normal: rules.filter((rule) => rule.priority === 'normal').length,
  low: rules.filter((rule) => rule.priority === 'low').length,
});

export const knowledgeMigrationService = {
  /**
   * Runs the migration pass. `dryRun` defaults to true; `dedupe` and
   * `promoteRules` only take effect when `dryRun` is false.
   */
  async migrate(input: {
    projectIds?: unknown;
    dryRun?: unknown;
    dedupe?: unknown;
    promoteRules?: unknown;
  }): Promise<KnowledgeMigrationReport> {
    const dryRun = input.dryRun !== false;
    const dedupe = input.dedupe === true;
    const promoteRules = input.promoteRules === true;

    const projectIds =
      Array.isArray(input.projectIds) && input.projectIds.length > 0
        ? input.projectIds.map((value) => String(value))
        : projectsDb.getProjectPaths().map((project) => project.project_id);

    // 1. Import each project's instruction files.
    const scanned: KnowledgeScanResult[] = [];
    for (const projectId of projectIds) {
      try {
        scanned.push(await knowledgeScanService.scanProject(projectId));
      } catch {
        // Unknown project / missing folder — skip it, keep migrating the rest.
      }
    }

    // 2. Report duplicates across projects (same normalized title + content).
    const duplicates = [
      ...collectDuplicates('rule', knowledgeDb.allRules()),
      ...collectDuplicates('memory', knowledgeDb.allMemories()),
    ];

    let removed = 0;
    let promoted = 0;

    if (!dryRun && dedupe) {
      for (const group of duplicates) {
        if (group.entityType === 'rule') {
          // Keep one row and make it global so the merged rule applies everywhere.
          knowledgeDb.updateRule(group.keepId, { projectId: null });
          for (const id of group.dropIds) {
            if (knowledgeDb.deleteRule(id)) removed += 1;
          }
        } else {
          knowledgeDb.updateMemory(group.keepId, { projectId: null });
          for (const id of group.dropIds) {
            if (knowledgeDb.deleteMemory(id)) removed += 1;
          }
        }
      }
    }

    if (!dryRun && promoteRules) {
      for (const rule of knowledgeDb.allRules()) {
        if (rule.priority !== 'critical') {
          knowledgeDb.updateRule(rule.id, { priority: 'critical' });
          promoted += 1;
        }
      }
    }

    const rules = knowledgeDb.allRules();
    return {
      dryRun,
      scanned,
      duplicates,
      rules: ruleCounts(rules),
      memories: knowledgeDb.allMemories().length,
      removed,
      promoted,
    };
  },
};

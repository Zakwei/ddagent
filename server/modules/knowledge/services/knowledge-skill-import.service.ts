import { readFile } from 'node:fs/promises';
import path from 'node:path';

import { knowledgeDb } from '@/modules/database/index.js';
import { providerSkillsService } from '@/modules/providers/index.js';
import { parseFrontMatter } from '@/shared/frontmatter.js';

/**
 * Imports the skills that agent CLIs already ship or have installed (global /
 * user / system / plugin scopes) into the knowledge base as **skills**.
 *
 * Consumers: the knowledge routes (`POST /api/knowledge/import-skills`) driven
 * from the client. Project-scoped skills are intentionally excluded — those are
 * imported per project by the scanner. Each provider skill is read from its
 * `sourcePath` markdown file (frontmatter name/description/category), and a
 * name that already exists in the knowledge base is skipped, so the import is
 * idempotent. Dry-run by default.
 */

export type KnowledgeSkillImportReport = {
  dryRun: boolean;
  providers: string[];
  found: number;
  imported: number;
  skipped: number;
  skills: Array<{
    name: string;
    provider: string;
    scope: string;
    imported: boolean;
    reason?: string;
  }>;
};

/** Global/default scopes; `project` comes from the per-project scan instead. */
const DEFAULT_SCOPES = ['user', 'system', 'admin', 'plugin', 'repo'];

const readString = (value: unknown): string => (typeof value === 'string' ? value.trim() : '');

export const knowledgeSkillImportService = {
  /**
   * Lists provider skills for the chosen scopes and creates the missing ones as
   * knowledge skills. `dryRun` defaults to true (nothing is written).
   */
  async importProviderSkills(input: {
    providers?: unknown;
    scopes?: unknown;
    dryRun?: unknown;
  }): Promise<KnowledgeSkillImportReport> {
    const dryRun = input.dryRun !== false;
    const providers =
      Array.isArray(input.providers) && input.providers.length > 0
        ? input.providers.map((value) => String(value))
        : providerSkillsService.listProviderIds();
    const scopes = new Set(
      Array.isArray(input.scopes) && input.scopes.length > 0
        ? input.scopes.map((value) => String(value))
        : DEFAULT_SCOPES,
    );

    const seenNames = new Set<string>();
    const skills: KnowledgeSkillImportReport['skills'] = [];
    let found = 0;
    let imported = 0;
    let skipped = 0;

    for (const provider of providers) {
      let list;
      try {
        list = await providerSkillsService.listProviderSkills(provider);
      } catch {
        // Provider with no skill support — skip it.
        continue;
      }
      for (const skill of list) {
        if (!scopes.has(skill.scope)) continue;
        found += 1;

        if (seenNames.has(skill.name)) {
          skipped += 1;
          skills.push({ name: skill.name, provider, scope: skill.scope, imported: false, reason: 'duplicate name' });
          continue;
        }
        seenNames.add(skill.name);

        if (knowledgeDb.findSkillByName(skill.name)) {
          skipped += 1;
          skills.push({
            name: skill.name,
            provider,
            scope: skill.scope,
            imported: false,
            reason: 'already in knowledge base',
          });
          continue;
        }

        let content = '';
        let description = skill.description;
        let category = '';
        try {
          content = await readFile(skill.sourcePath, 'utf8');
          const { data } = parseFrontMatter(content);
          if (readString(data.description)) description = readString(data.description);
          if (readString(data.category)) category = readString(data.category);
        } catch {
          // Unreadable source — import with whatever the adapter reported.
        }
        const parent = path.basename(path.dirname(skill.sourcePath));
        if (!category) category = parent || 'agent';

        if (!dryRun) {
          knowledgeDb.createSkill({ name: skill.name, description, content, category });
        }
        imported += 1;
        skills.push({ name: skill.name, provider, scope: skill.scope, imported: true });
      }
    }

    return { dryRun, providers, found, imported, skipped, skills };
  },
};

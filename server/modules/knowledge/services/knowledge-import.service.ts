import { knowledgeMigrationService } from './knowledge-migration.service.js';
import { knowledgeSkillImportService } from './knowledge-skill-import.service.js';

/**
 * One-shot "import everything into ddagent" orchestration.
 *
 * Consumers: the knowledge routes (`POST /api/knowledge/import-all`) driven from
 * the client's confirm dialog. It runs the project migration (scan instruction
 * files + optional dedupe/promote) and the agent-skill import together.
 *
 * Every step only READS the agents' files and writes to ddagent's own SQLite
 * database — no CLI file or config is modified. The only destructive-in-DB
 * steps are `dedupe` (removes duplicate rows in ddagent's base) and
 * `promoteRules` (marks all rules critical); both are opt-in and only run when
 * `dryRun` is false.
 */
export type KnowledgeImportAllReport = {
  dryRun: boolean;
  migration: Awaited<ReturnType<typeof knowledgeMigrationService.migrate>>;
  skills: Awaited<ReturnType<typeof knowledgeSkillImportService.importProviderSkills>>;
};

export const knowledgeImportService = {
  /** Runs the project migration + agent-skill import. `dryRun` defaults to true. */
  async importAll(input: {
    dryRun?: unknown;
    dedupe?: unknown;
    promoteRules?: unknown;
  }): Promise<KnowledgeImportAllReport> {
    const dryRun = input.dryRun !== false;
    const migration = await knowledgeMigrationService.migrate({
      dryRun,
      dedupe: input.dedupe,
      promoteRules: input.promoteRules,
    });
    const skills = await knowledgeSkillImportService.importProviderSkills({ dryRun });
    return { dryRun, migration, skills };
  },
};

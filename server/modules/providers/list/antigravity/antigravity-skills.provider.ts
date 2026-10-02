import os from 'node:os';
import path from 'node:path';

import { SkillsProvider } from '@/modules/providers/shared/skills/skills.provider.js';
import type { ProviderSkillSource } from '@/shared/types.js';
import {
  addUniqueProviderSkillSource,
  antigravityConfigDir,
} from '@/shared/utils.js';

// Antigravity loads workspace customizations from `.agents/` (skills, agents,
// rules, hooks) and user-level skills from `~/.gemini/config/skills/` plus the
// shared `~/.agents/skills/` compat dir — verified against the CLI's bundled
// customization docs and binary path tables.
const ANTIGRAVITY_PROJECT_SKILL_DIRS = [
  ['.agents', 'skills'],
];

const ANTIGRAVITY_USER_SKILL_DIRS = [
  [path.join(os.homedir(), '.gemini', 'config', 'skills')],
  [path.join(os.homedir(), '.agents', 'skills')],
];

export class AntigravitySkillsProvider extends SkillsProvider {
  constructor() {
    super('antigravity');
  }

  protected async getSkillSources(workspacePath: string): Promise<ProviderSkillSource[]> {
    const sources: ProviderSkillSource[] = [];
    const seenRootDirs = new Set<string>();

    for (const skillDir of ANTIGRAVITY_PROJECT_SKILL_DIRS) {
      addUniqueProviderSkillSource(sources, seenRootDirs, {
        scope: 'project',
        rootDir: path.join(workspacePath, ...skillDir),
        commandPrefix: '/',
      });
    }

    for (const skillDir of ANTIGRAVITY_USER_SKILL_DIRS) {
      addUniqueProviderSkillSource(sources, seenRootDirs, {
        scope: 'user',
        rootDir: path.join(...skillDir),
        commandPrefix: '/',
      });
    }

    return sources;
  }

  protected async getGlobalSkillSource(): Promise<ProviderSkillSource> {
    // Managed installs land in Antigravity's own user config dir — never in
    // the shared .agents compat root, which other providers own too.
    return {
      scope: 'user',
      rootDir: path.join(antigravityConfigDir(), 'skills'),
      commandPrefix: '/',
    };
  }
}

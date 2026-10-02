import os from 'node:os';
import path from 'node:path';

import { SkillsProvider } from '@/modules/providers/shared/skills/skills.provider.js';
import type { ProviderSkillSource } from '@/shared/types.js';
import {
  addUniqueProviderSkillSource,
  commandCodeDir,
} from '@/shared/utils.js';

// Command Code resolves skills in priority order — project `.commandcode`
// beats the shared `.agents` compat dir, which beats the user-level pair —
// so sources are listed in that order and name collisions keep the first hit.
const COMMANDCODE_PROJECT_SKILL_DIRS = [
  ['.commandcode', 'skills'],
  ['.agents', 'skills'],
];

const COMMANDCODE_USER_SKILL_DIRS = [
  ['.commandcode', 'skills'],
  ['.agents', 'skills'],
];

export class CommandCodeSkillsProvider extends SkillsProvider {
  constructor() {
    super('commandcode');
  }

  protected async getSkillSources(workspacePath: string): Promise<ProviderSkillSource[]> {
    const sources: ProviderSkillSource[] = [];
    const seenRootDirs = new Set<string>();

    for (const skillDir of COMMANDCODE_PROJECT_SKILL_DIRS) {
      addUniqueProviderSkillSource(sources, seenRootDirs, {
        scope: 'project',
        rootDir: path.join(workspacePath, ...skillDir),
        commandPrefix: '/',
      });
    }

    for (const skillDir of COMMANDCODE_USER_SKILL_DIRS) {
      addUniqueProviderSkillSource(sources, seenRootDirs, {
        scope: 'user',
        rootDir: path.join(os.homedir(), ...skillDir),
        commandPrefix: '/',
      });
    }

    return sources;
  }

  protected async getGlobalSkillSource(): Promise<ProviderSkillSource> {
    // Managed installs land in Command Code's own user directory — never in
    // the shared .agents compat root, which other providers own too.
    return {
      scope: 'user',
      rootDir: path.join(commandCodeDir(), 'skills'),
      commandPrefix: '/',
    };
  }
}

import os from 'node:os';
import path from 'node:path';

import { SkillsProvider } from '@/modules/providers/shared/skills/skills.provider.js';
import type { ProviderSkillSource } from '@/shared/types.js';

export class CursorSkillsProvider extends SkillsProvider {
  constructor() {
    super('cursor');
  }

  protected async getSkillSources(workspacePath: string): Promise<ProviderSkillSource[]> {
    return [
      {
        scope: 'project',
        rootDir: path.join(workspacePath, '.agents', 'skills'),
        commandPrefix: '/',
      },
      {
        scope: 'project',
        rootDir: path.join(workspacePath, '.cursor', 'skills'),
        commandPrefix: '/',
      },
      {
        scope: 'user',
        rootDir: path.join(os.homedir(), '.cursor', 'skills'),
        commandPrefix: '/',
      },
    ];
  }

  protected async getGlobalSkillSource(): Promise<ProviderSkillSource> {
    return {
      scope: 'user',
      rootDir: path.join(os.homedir(), '.cursor', 'skills'),
      commandPrefix: '/',
    };
  }

  // Cursor reads both `.agents/skills` and `.cursor/skills` project dirs, but
  // moves target its own native directory rather than the shared compat root.
  protected async getProjectSkillSource(
    workspacePath?: string,
  ): Promise<ProviderSkillSource | null> {
    if (!workspacePath) {
      return null;
    }
    return {
      scope: 'project',
      rootDir: path.join(path.resolve(workspacePath), '.cursor', 'skills'),
      commandPrefix: '/',
    };
  }
}

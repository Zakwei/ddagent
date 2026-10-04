import path from 'node:path';
import { cp, mkdir, rename, rm, stat, writeFile } from 'node:fs/promises';

import type { IProviderSkills } from '@/shared/interfaces.js';
import type {
  LLMProvider,
  ProviderSkillCreateInput,
  ProviderSkillMoveInput,
  ProviderSkillMoveResult,
  ProviderSkillRemoveInput,
  ProviderSkill,
  ProviderSkillListOptions,
  ProviderSkillSource,
} from '@/shared/types.js';
import {
  findProviderSkillMarkdownFiles,
  readOptionalString,
  readProviderSkillMarkdownDefinitionFromContent,
  readProviderSkillMarkdownDefinition,
  AppError,
} from '@/shared/utils.js';

const resolveWorkspacePath = (workspacePath?: string): string =>
  path.resolve(workspacePath ?? process.cwd());

const stripMarkdownExtension = (value: string): string => value.replace(/\.md$/i, '');

const normalizeSkillDirectoryName = (value: string): string => (
  value
    .trim()
    .replace(/[\\/]+/g, '-')
    .replace(/[<>:"|?*\x00-\x1F]/g, '-')
    .replace(/\s+/g, '-')
    .replace(/-+/g, '-')
    .replace(/^\.+|\.+$/g, '')
    .replace(/^-+|-+$/g, '')
);

type PendingSkillInstall = {
  skillDirectoryPath: string;
  skillPath: string;
  content: string;
  supportingFiles: Array<{
    targetPath: string;
    content: string | Buffer;
  }>;
  skill: ProviderSkill;
};

const resolveSkillSupportingFilePath = (
  skillDirectoryPath: string,
  relativePath: string,
  entryIndex: number,
): string => {
  const normalizedRelativePath = relativePath.trim().replace(/\\/g, '/');
  const pathSegments = normalizedRelativePath.split('/');
  if (
    !normalizedRelativePath
    || path.isAbsolute(normalizedRelativePath)
    || pathSegments.some((segment) => !segment || segment === '.' || segment === '..')
    || normalizedRelativePath.toLowerCase() === 'skill.md'
  ) {
    throw new AppError(
      `Skill entry ${entryIndex + 1} includes an invalid supporting file path "${relativePath}".`,
      {
        code: 'PROVIDER_SKILL_FILE_PATH_INVALID',
        statusCode: 400,
      },
    );
  }

  const resolvedSkillDirectoryPath = path.resolve(skillDirectoryPath);
  const resolvedFilePath = path.resolve(resolvedSkillDirectoryPath, ...pathSegments);
  if (!resolvedFilePath.startsWith(`${resolvedSkillDirectoryPath}${path.sep}`)) {
    throw new AppError(
      `Skill entry ${entryIndex + 1} supporting files must stay inside the skill directory.`,
      {
        code: 'PROVIDER_SKILL_FILE_PATH_INVALID',
        statusCode: 400,
      },
    );
  }

  return resolvedFilePath;
};

/** True when [candidatePath] equals [rootPath] or is nested below it. */
const isInsideRoot = (candidatePath: string, rootPath: string): boolean => {
  const resolvedCandidate = path.resolve(candidatePath);
  const resolvedRoot = path.resolve(rootPath);
  return resolvedCandidate === resolvedRoot
    || resolvedCandidate.startsWith(`${resolvedRoot}${path.sep}`);
};

/**
 * Relocates a skill directory, falling back to copy-then-remove when source
 * and destination live on different filesystems (`EXDEV`) — a global home
 * directory and a project mount commonly differ.
 */
const moveSkillDirectory = async (
  sourceDirectoryPath: string,
  targetDirectoryPath: string,
): Promise<void> => {
  try {
    await rename(sourceDirectoryPath, targetDirectoryPath);
    return;
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code !== 'EXDEV') {
      throw error;
    }
  }

  await cp(sourceDirectoryPath, targetDirectoryPath, {
    recursive: true,
    force: false,
    errorOnExist: true,
  });
  await rm(sourceDirectoryPath, { recursive: true, force: true });
};

/**
 * Shared skills provider for provider-specific skill source discovery.
 */
export abstract class SkillsProvider implements IProviderSkills {
  protected readonly provider: LLMProvider;

  protected constructor(provider: LLMProvider) {
    this.provider = provider;
  }

  async listSkills(options?: ProviderSkillListOptions): Promise<ProviderSkill[]> {
    const workspacePath = resolveWorkspacePath(options?.workspacePath);
    const sources = await this.getSkillSources(workspacePath);
    const skills: ProviderSkill[] = [];

    for (const source of sources) {
      const skillFiles = await findProviderSkillMarkdownFiles(source.rootDir, {
        recursive: source.recursive,
      });
      for (const skillPath of skillFiles) {
        try {
          const definition = await readProviderSkillMarkdownDefinition(skillPath);
          const command = source.commandForSkill
            ? source.commandForSkill(definition.name)
            : `${source.commandPrefix ?? '/'}${definition.name}`;

          skills.push({
            provider: this.provider,
            name: definition.name,
            description: definition.description,
            command,
            scope: source.scope,
            sourcePath: skillPath,
            pluginName: source.pluginName,
            pluginId: source.pluginId,
          });
        } catch {
          // A malformed or unreadable skill markdown file should not hide other valid skills.
        }
      }
    }

    return skills;
  }

  async addSkills(input: ProviderSkillCreateInput): Promise<ProviderSkill[]> {
    const globalSkillSource = await this.getGlobalSkillSource();
    if (!globalSkillSource) {
      throw new AppError(`${this.provider} does not support managed global skills.`, {
        code: 'PROVIDER_SKILLS_WRITE_UNSUPPORTED',
        statusCode: 400,
      });
    }

    if (!Array.isArray(input.entries) || input.entries.length === 0) {
      throw new AppError('At least one skill entry is required.', {
        code: 'PROVIDER_SKILLS_REQUIRED',
        statusCode: 400,
      });
    }

    const seenSkillPaths = new Set<string>();
    const pendingInstalls: PendingSkillInstall[] = [];

    for (const [index, entry] of input.entries.entries()) {
      const content = typeof entry.content === 'string' ? entry.content.trim() : '';
      if (!content) {
        throw new AppError(`Skill entry ${index + 1} must include markdown content.`, {
          code: 'PROVIDER_SKILL_CONTENT_REQUIRED',
          statusCode: 400,
        });
      }

      const fileNameFallback = readOptionalString(entry.fileName);
      const requestedDirectoryName = readOptionalString(entry.directoryName);
      const fallbackSkillName = normalizeSkillDirectoryName(
        requestedDirectoryName
          ?? (fileNameFallback ? stripMarkdownExtension(fileNameFallback) : `skill-${index + 1}`),
      );
      const definition = readProviderSkillMarkdownDefinitionFromContent(content, fallbackSkillName);
      const resolvedDirectoryName = normalizeSkillDirectoryName(
        requestedDirectoryName ?? definition.name,
      );

      if (!resolvedDirectoryName) {
        throw new AppError(`Skill entry ${index + 1} must include a valid skill name.`, {
          code: 'PROVIDER_SKILL_NAME_REQUIRED',
          statusCode: 400,
        });
      }

      const skillDirectoryPath = path.join(globalSkillSource.rootDir, resolvedDirectoryName);
      const skillPath = path.join(skillDirectoryPath, 'SKILL.md');
      const normalizedSkillPath = path.resolve(skillPath);
      if (seenSkillPaths.has(normalizedSkillPath)) {
        throw new AppError(`Duplicate skill target "${resolvedDirectoryName}" in one request.`, {
          code: 'PROVIDER_SKILL_DUPLICATE_TARGET',
          statusCode: 400,
        });
      }

      seenSkillPaths.add(normalizedSkillPath);
      const supportingFiles = (entry.files ?? []).map((file) => ({
        targetPath: resolveSkillSupportingFilePath(skillDirectoryPath, file.relativePath, index),
        content: file.encoding === 'base64'
          ? Buffer.from(file.content, 'base64')
          : file.content,
      }));
      const seenSupportingPaths = new Set<string>();
      for (const file of supportingFiles) {
        if (seenSupportingPaths.has(file.targetPath)) {
          throw new AppError(`Skill entry ${index + 1} includes a duplicate supporting file path.`, {
            code: 'PROVIDER_SKILL_DUPLICATE_FILE',
            statusCode: 400,
          });
        }
        seenSupportingPaths.add(file.targetPath);
      }

      const command = globalSkillSource.commandForSkill
        ? globalSkillSource.commandForSkill(definition.name)
        : `${globalSkillSource.commandPrefix ?? '/'}${definition.name}`;

      pendingInstalls.push({
        skillDirectoryPath,
        skillPath,
        content,
        supportingFiles,
        skill: {
          provider: this.provider,
          name: definition.name,
          description: definition.description,
          command,
          scope: globalSkillSource.scope,
          sourcePath: skillPath,
          pluginName: globalSkillSource.pluginName,
          pluginId: globalSkillSource.pluginId,
        },
      });
    }

    for (const install of pendingInstalls) {
      // Replace the complete skill directory so removed scripts or assets do not remain stale.
      await rm(install.skillDirectoryPath, { recursive: true, force: true });
      await mkdir(install.skillDirectoryPath, { recursive: true });
      await writeFile(install.skillPath, `${install.content}\n`, 'utf8');
      for (const file of install.supportingFiles) {
        await mkdir(path.dirname(file.targetPath), { recursive: true });
        await writeFile(file.targetPath, file.content);
      }
    }

    return pendingInstalls.map((install) => install.skill);
  }

  async removeSkill(
    input: ProviderSkillRemoveInput,
  ): Promise<{ removed: boolean; provider: LLMProvider; directoryName: string }> {
    const globalSkillSource = await this.getGlobalSkillSource();
    if (!globalSkillSource) {
      throw new AppError(`${this.provider} does not support managed global skills.`, {
        code: 'PROVIDER_SKILLS_WRITE_UNSUPPORTED',
        statusCode: 400,
      });
    }

    const directoryName = normalizeSkillDirectoryName(input.directoryName);
    if (!directoryName) {
      throw new AppError('Skill directoryName is required.', {
        code: 'PROVIDER_SKILL_DIRECTORY_REQUIRED',
        statusCode: 400,
      });
    }

    const skillDirectoryPath = path.join(globalSkillSource.rootDir, directoryName);
    const resolvedRoot = path.resolve(globalSkillSource.rootDir);
    const resolvedSkillDirectoryPath = path.resolve(skillDirectoryPath);
    if (
      resolvedSkillDirectoryPath !== resolvedRoot
      && !resolvedSkillDirectoryPath.startsWith(`${resolvedRoot}${path.sep}`)
    ) {
      throw new AppError('Skill directory must stay inside the managed skill root.', {
        code: 'PROVIDER_SKILL_DIRECTORY_INVALID',
        statusCode: 400,
      });
    }

    const removed = await stat(resolvedSkillDirectoryPath)
      .then((stats) => stats.isDirectory())
      .catch(() => false);
    if (removed) {
      await rm(resolvedSkillDirectoryPath, { recursive: true, force: true });
    }

    return { removed, provider: this.provider, directoryName };
  }

  /**
   * Relocates one managed skill directory between this provider's global user
   * skill root and a project-scoped skill root. Consumed by
   * providerSkillsService and the unified hub service.
   */
  async moveSkill(input: ProviderSkillMoveInput): Promise<ProviderSkillMoveResult> {
    const sourcePathInput = readOptionalString(input.sourcePath);
    if (!sourcePathInput) {
      throw new AppError('sourcePath is required.', {
        code: 'PROVIDER_SKILL_SOURCE_REQUIRED',
        statusCode: 400,
      });
    }

    if (input.targetScope !== 'global' && input.targetScope !== 'project') {
      throw new AppError('targetScope must be "global" or "project".', {
        code: 'PROVIDER_SKILL_TARGET_SCOPE_INVALID',
        statusCode: 400,
      });
    }

    const resolvedSourcePath = path.resolve(sourcePathInput);
    if (path.basename(resolvedSourcePath).toLowerCase() !== 'skill.md') {
      throw new AppError('sourcePath must point at a SKILL.md file.', {
        code: 'PROVIDER_SKILL_SOURCE_INVALID',
        statusCode: 400,
      });
    }

    const sourceDirectoryPath = path.dirname(resolvedSourcePath);
    const directoryName = path.basename(sourceDirectoryPath);
    if (!directoryName || directoryName === '.' || directoryName === '..') {
      throw new AppError('Could not resolve the skill directory name.', {
        code: 'PROVIDER_SKILL_DIRECTORY_REQUIRED',
        statusCode: 400,
      });
    }

    const targetWorkspacePath = readOptionalString(input.targetWorkspacePath);
    const targetSource = input.targetScope === 'global'
      ? await this.getGlobalSkillSource()
      : await this.getProjectSkillSource(targetWorkspacePath);
    if (!targetSource) {
      throw new AppError(
        input.targetScope === 'global'
          ? `${this.provider} does not support managed global skills.`
          : `${this.provider} does not support project-scoped skills for this workspace.`,
        {
          code: 'PROVIDER_SKILLS_WRITE_UNSUPPORTED',
          statusCode: 400,
        },
      );
    }

    const targetRootPath = path.resolve(targetSource.rootDir);
    const targetDirectoryPath = path.join(targetRootPath, directoryName);
    if (!isInsideRoot(targetDirectoryPath, targetRootPath)) {
      throw new AppError('Skill directory must stay inside the managed skill root.', {
        code: 'PROVIDER_SKILL_DIRECTORY_INVALID',
        statusCode: 400,
      });
    }

    const allowedSourceRoots = await this.getMovableSourceRoots(
      readOptionalString(input.sourceWorkspacePath),
    );
    const resolvedSourceParent = path.resolve(path.dirname(sourceDirectoryPath));
    const sourceIsManaged = allowedSourceRoots.some(
      (root) => path.resolve(root) === resolvedSourceParent,
    );
    if (!sourceIsManaged) {
      throw new AppError('Only provider-managed skills can be moved.', {
        code: 'PROVIDER_SKILL_NOT_MANAGED',
        statusCode: 400,
      });
    }

    const sourceExists = await stat(sourceDirectoryPath)
      .then((stats) => stats.isDirectory())
      .catch(() => false);
    if (!sourceExists) {
      throw new AppError('The skill directory no longer exists.', {
        code: 'PROVIDER_SKILL_SOURCE_MISSING',
        statusCode: 404,
      });
    }

    if (path.resolve(sourceDirectoryPath) === path.resolve(targetDirectoryPath)) {
      throw new AppError('The skill is already in the requested scope.', {
        code: 'PROVIDER_SKILL_ALREADY_IN_SCOPE',
        statusCode: 400,
      });
    }

    const targetExists = await stat(targetDirectoryPath)
      .then(() => true)
      .catch(() => false);
    if (targetExists) {
      throw new AppError(
        `A skill directory named "${directoryName}" already exists in the target scope.`,
        {
          code: 'PROVIDER_SKILL_TARGET_EXISTS',
          statusCode: 409,
        },
      );
    }

    await mkdir(targetRootPath, { recursive: true });
    await moveSkillDirectory(sourceDirectoryPath, targetDirectoryPath);

    return {
      moved: true,
      provider: this.provider,
      directoryName,
      sourcePath: resolvedSourcePath,
      targetPath: path.join(targetDirectoryPath, path.basename(resolvedSourcePath)),
      targetScope: input.targetScope,
    };
  }

  protected abstract getSkillSources(workspacePath: string): Promise<ProviderSkillSource[]>;

  /**
   * The provider's preferred project-scoped skill root for [workspacePath].
   * Defaults to the first project/repo source returned by getSkillSources;
   * providers whose native project directory is not first override this.
   */
  protected async getProjectSkillSource(
    workspacePath?: string,
  ): Promise<ProviderSkillSource | null> {
    const normalizedWorkspacePath = readOptionalString(workspacePath);
    if (!normalizedWorkspacePath) {
      return null;
    }

    const sources = await this.getSkillSources(resolveWorkspacePath(normalizedWorkspacePath));
    return sources.find((source) => source.scope === 'project' || source.scope === 'repo') ?? null;
  }

  /**
   * Skill roots a move may read from: the managed global root plus every
   * project/repo root of [workspacePath]. Keep module-private — only
   * moveSkill consumes it.
   */
  private async getMovableSourceRoots(workspacePath?: string): Promise<string[]> {
    const roots: string[] = [];
    const globalSource = await this.getGlobalSkillSource();
    if (globalSource) {
      roots.push(globalSource.rootDir);
    }

    const normalizedWorkspacePath = readOptionalString(workspacePath);
    if (normalizedWorkspacePath) {
      const sources = await this.getSkillSources(resolveWorkspacePath(normalizedWorkspacePath));
      for (const source of sources) {
        if (source.scope === 'project' || source.scope === 'repo') {
          roots.push(source.rootDir);
        }
      }
    }

    return roots;
  }

  protected async getGlobalSkillSource(): Promise<ProviderSkillSource | null> {
    return null;
  }
}

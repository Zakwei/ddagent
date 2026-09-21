import fs from 'node:fs';
import path from 'node:path';

type SystemUpdateCommandResult = {
  exitCode: number | null;
  output: string;
  errorOutput: string;
};

type SystemUpdateDependencies = {
  appRoot: string;
  homeDirectory: string;
  installMode: 'git' | 'npm';
  isPlatform: boolean;
  environment: NodeJS.ProcessEnv;
  githubTokens: {
    getActiveGithubToken(userId: number): string | null;
  };
  runShellCommand(
    command: string,
    workingDirectory: string,
    environment: NodeJS.ProcessEnv,
    onOutput: (output: string) => void,
    onErrorOutput: (errorOutput: string) => void,
  ): Promise<SystemUpdateCommandResult>;
  logInfo(message: string, detail?: string): void;
  logError(message: string, detail?: string): void;
};

/**
 * Creates the update workflow used by the system module and its focused tests.
 * Runtime-specific process spawning stays behind the injected command adapter.
 */
export function createSystemUpdateService(dependencies: SystemUpdateDependencies) {
  // The launcher on this deployment restores a patch mirror over dist/ on every
  // start, so after a git update the mirror must be synced or the next restart
  // reverts the client. `DDAGENT_PATCH_DIR` overrides the conventional
  // `<repo>/.ddagent-patch` sibling location.
  const patchMirrorDirectory = dependencies.environment.DDAGENT_PATCH_DIR
    ?? path.join(dependencies.appRoot, '..', '.ddagent-patch');

  return {
    /** Selects and executes the correct update workflow for this installation. */
    async updateSystem() {
      // Platform mode on a git checkout (this deployment) has no platform
      // updater — git pull is the real upgrade path there.
      const updateCommand = dependencies.isPlatform && dependencies.installMode !== 'git'
        ? 'npm run update:platform'
        : dependencies.installMode === 'git'
          // `git pull` follows the checked-out branch's upstream — hardcoding
          // `main` breaks forks whose default branch has another name.
          ? 'git pull && npm install && npm run build'
          : 'npm install -g @ddagent-ai/ddagent@latest';
      const workingDirectory = dependencies.isPlatform || dependencies.installMode === 'git'
        ? dependencies.appRoot
        : dependencies.homeDirectory;

      dependencies.logInfo('Starting system update from directory:', workingDirectory);

      const runOptions = [
        workingDirectory,
        dependencies.environment,
        (output: string) => dependencies.logInfo('Update output:', output),
        (errorOutput: string) => dependencies.logError('Update error:', errorOutput),
      ] as const;

      try {
        const result = await dependencies.runShellCommand(updateCommand, ...runOptions);

        if (result.exitCode !== 0) {
          return {
            success: false as const,
            error: 'Update command failed',
            output: result.output,
            errorOutput: result.errorOutput,
          };
        }

        if (dependencies.installMode === 'git' && fs.existsSync(patchMirrorDirectory)) {
          const sync = await dependencies.runShellCommand(
            `mkdir -p "${patchMirrorDirectory}/dist" && cp -r dist/. "${patchMirrorDirectory}/dist/"` +
            ` && cp dist-server/server/modules/providers/list/claude/claude-runtime.provider.js "${patchMirrorDirectory}/claude-runtime.provider.js"` +
            ` && cp dist-server/server/modules/providers/list/devin/devin-sessions.provider.js "${patchMirrorDirectory}/devin-sessions.provider.js"`,
            ...runOptions,
          );
          if (sync.exitCode !== 0) {
            return {
              success: false as const,
              error: 'Patch mirror sync failed',
              output: sync.output,
              errorOutput: sync.errorOutput,
            };
          }
        }

        return {
          success: true as const,
          output: result.output || 'Update completed successfully',
          message: 'Update completed. Please restart the server to apply changes.',
        };
      } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        dependencies.logError('Update process error:', message);
        return {
          success: false as const,
          error: message,
        };
      }
    },

    /**
     * Newest GitHub release for the update channel. Goes through the server so
     * the user's stored GitHub token can be attached — the releases API returns
     * 404 on private repos for anonymous callers, which is why the frontend
     * cannot check directly.
     */
    async getLatestRelease(userId: number) {
      const repo = dependencies.environment.DDAGENT_RELEASES_REPO || 'Zakwei/ddagent';
      const token = dependencies.githubTokens.getActiveGithubToken(userId);
      try {
        const response = await fetch(`https://api.github.com/repos/${repo}/releases/latest`, {
          headers: {
            Accept: 'application/vnd.github+json',
            'User-Agent': 'ddagent-update-check',
            ...(token ? { Authorization: `Bearer ${token}` } : {}),
          },
        });
        if (!response.ok) {
          return { release: null };
        }
        const data = (await response.json()) as {
          tag_name?: string;
          name?: string;
          body?: string;
          html_url?: string;
          published_at?: string;
        };
        if (!data.tag_name) {
          return { release: null };
        }
        return {
          release: {
            tagName: data.tag_name,
            name: data.name || data.tag_name,
            body: data.body || '',
            htmlUrl: data.html_url || `https://github.com/${repo}/releases/latest`,
            publishedAt: data.published_at,
          },
        };
      } catch (error) {
        dependencies.logError('Latest release check failed:', error instanceof Error ? error.message : String(error));
        return { release: null };
      }
    },
  };
}

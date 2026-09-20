import os from 'node:os';
import path from 'node:path';
import { execFile } from 'node:child_process';
import { promisify } from 'node:util';
import { stat } from 'node:fs/promises';
import { SkillsProvider } from '../../../../modules/providers/shared/skills/skills.provider.js';

const execFileAsync = promisify(execFile);

const GLOBAL_SKILL_ROOTS = [
    path.join(os.homedir(), '.local', 'share', 'devin', 'skills'),
    path.join(os.homedir(), '.config', 'devin', 'skills'),
    path.join(os.homedir(), '.agents', 'skills'),
];

let devinSkillsCache = null;
let devinSkillsCacheAt = 0;
const DEVIN_SKILLS_CACHE_TTL_MS = 60_000;

async function directoryExists(dirPath) {
    try {
        const info = await stat(dirPath);
        return info.isDirectory();
    }
    catch {
        return false;
    }
}

function createSkillSource(rootDir) {
    return {
        rootDir: path.resolve(rootDir),
        scope: 'global',
        commandForSkill: (name) => `/${name}`,
        recursive: true,
    };
}

function resolveWorkspacePath(workspacePath) {
    return workspacePath ? path.resolve(workspacePath) : process.cwd();
}

function inferSkillScope(skill, workspacePath) {
    const baseDir = skill.base_dir ? path.resolve(skill.base_dir) : '';
    if (!baseDir) {
        return 'global';
    }
    if (workspacePath && baseDir.startsWith(`${path.resolve(workspacePath)}${path.sep}`)) {
        return 'project';
    }
    if (baseDir.includes(`${path.sep}plugins${path.sep}cache${path.sep}`)) {
        return 'plugin';
    }
    return 'global';
}

export class DevinSkillsProvider extends SkillsProvider {
    constructor() {
        super('devin');
    }

    async getSkillSources(workspacePath) {
        const sources = [];
        for (const rootDir of GLOBAL_SKILL_ROOTS) {
            if (await directoryExists(rootDir)) {
                sources.push(createSkillSource(rootDir));
            }
        }
        if (workspacePath) {
            const workspaceSkills = path.join(path.resolve(workspacePath), '.devin', 'skills');
            if (await directoryExists(workspaceSkills)) {
                sources.push(createSkillSource(workspaceSkills));
            }
        }
        return sources;
    }

    async getGlobalSkillSource() {
        for (const rootDir of GLOBAL_SKILL_ROOTS) {
            if (await directoryExists(rootDir)) {
                return createSkillSource(rootDir);
            }
        }
        return null;
    }

    async listSkills(options) {
        const workspacePath = resolveWorkspacePath(options?.workspacePath);

        const now = Date.now();
        if (devinSkillsCache && (now - devinSkillsCacheAt) < DEVIN_SKILLS_CACHE_TTL_MS) {
            return this._normalizeDevinSkills(devinSkillsCache, workspacePath);
        }

        try {
            const { stdout } = await execFileAsync(
                'devin',
                ['skills', 'list', '--json'],
                { cwd: workspacePath, timeout: 30_000, maxBuffer: 16 * 1024 * 1024 },
            );
            const skills = JSON.parse(stdout);
            if (!Array.isArray(skills)) {
                throw new Error('Unexpected devin skills list output');
            }
            devinSkillsCache = skills;
            devinSkillsCacheAt = now;
            return this._normalizeDevinSkills(skills, workspacePath);
        }
        catch (error) {
            console.error('[DevinSkillsProvider] Failed to list skills via devin CLI:', error?.message || error);
            // Fallback to filesystem-based discovery if the CLI is unavailable.
            return super.listSkills(options);
        }
    }

    _normalizeDevinSkills(skills, workspacePath) {
        return skills
            .filter((skill) => skill && typeof skill.name === 'string' && skill.name.trim())
            .filter((skill) => (skill.triggers || []).includes('user'))
            .map((skill) => {
                const scope = inferSkillScope(skill, workspacePath);
                const baseDir = skill.base_dir ? path.resolve(skill.base_dir) : '';
                const sourcePath = baseDir ? path.join(baseDir, 'SKILL.md') : null;
                return {
                    provider: this.provider,
                    name: skill.name,
                    displayName: skill.display_name || skill.name,
                    description: skill.description || '',
                    command: `/${skill.name}`,
                    scope,
                    sourcePath,
                    triggers: skill.triggers || [],
                };
            });
    }
}

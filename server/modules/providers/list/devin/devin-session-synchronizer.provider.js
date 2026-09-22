import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import readline from 'node:readline';

import crossSpawn from 'cross-spawn';

import { projectsDb, sessionsDb } from '../../../database/index.js';
import { isSubagentSessionTitle, normalizeSessionName, resolveSqliteNativeBinding } from '../../../../shared/utils.js';

const ROOT_WORKSPACE = '/workspace';
const LIST_TIMEOUT_MS = 60_000;
const SCAN_DEPTH = 2;
const GIT_ROOTS_CACHE_TTL_MS = 5 * 60 * 1000;
const DEVIN_LIST_CACHE_TTL_MS = 60 * 1000;
const DEVIN_DB_PATH = path.join(os.homedir(), '.local/share/devin/cli/sessions.db');

let gitRootsCache = null;
const devinListCache = new Map();

function normalizeDevinTimestamp(value) {
    if (value === null || value === undefined) {
        return null;
    }
    const numeric = typeof value === 'number' ? value : Number(value);
    if (Number.isFinite(numeric)) {
        const millis = numeric < 1_000_000_000_000 ? numeric * 1000 : numeric;
        const date = new Date(millis);
        if (!Number.isNaN(date.getTime())) {
            return date.toISOString();
        }
    }
    if (typeof value === 'string') {
        const date = new Date(value);
        if (!Number.isNaN(date.getTime())) {
            return date.toISOString();
        }
    }
    return null;
}

function runDevinListOnce(cwd = os.homedir()) {
    return new Promise((resolve, reject) => {
        const child = crossSpawn('devin', ['list', '--format', 'json'], {
            cwd,
            stdio: ['pipe', 'pipe', 'pipe'],
        });

        const timeout = setTimeout(() => {
            child.kill('SIGTERM');
            reject(new Error(`devin list timed out after ${LIST_TIMEOUT_MS}ms in ${cwd}`));
        }, LIST_TIMEOUT_MS);

        let stdout = '';
        let stderr = '';

        child.stdout?.setEncoding('utf8');
        child.stderr?.setEncoding('utf8');
        child.stdout?.on('data', (chunk) => {
            stdout += chunk;
        });
        child.stderr?.on('data', (chunk) => {
            stderr += chunk;
        });

        child.on('error', (error) => {
            clearTimeout(timeout);
            reject(error);
        });

        child.on('close', (code) => {
            clearTimeout(timeout);
            if (code !== 0) {
                reject(new Error(`devin list exited with code ${code} in ${cwd}: ${stderr.trim() || 'unknown error'}`));
                return;
            }
            resolve(stdout.trim());
        });
    });
}

async function runDevinList(cwd = os.homedir(), attempts = 3) {
    let lastError;
    for (let i = 0; i < attempts; i++) {
        try {
            return await runDevinListOnce(cwd);
        } catch (error) {
            lastError = error;
            if (i < attempts - 1) {
                await new Promise(r => setTimeout(r, 2000 * (i + 1)));
            }
        }
    }
    throw lastError;
}

function findGitRoots(rootPath, depth = SCAN_DEPTH) {
    const roots = new Set();
    function scan(dir, currentDepth) {
        if (currentDepth > depth) return;
        try {
            const entries = fs.readdirSync(dir, { withFileTypes: true });
            for (const entry of entries) {
                if (!entry.isDirectory()) continue;
                const fullPath = path.join(dir, entry.name);
                if (entry.name === '.git') {
                    roots.add(dir);
                    return;
                }
                scan(fullPath, currentDepth + 1);
            }
        } catch {
            // skip directories we can read
        }
    }
    scan(rootPath, 0);
    return Array.from(roots).sort();
}

function findGitRootsCached() {
    const now = Date.now();
    if (gitRootsCache && now - gitRootsCache.ts < GIT_ROOTS_CACHE_TTL_MS) {
        return gitRootsCache.roots;
    }
    const roots = findGitRoots(ROOT_WORKSPACE);
    gitRootsCache = { ts: now, roots };
    return roots;
}

function importSessionItems(items) {
    const byProject = new Map();
    for (const item of items) {
        if (!item || typeof item !== 'object') continue;
        const id = typeof item.id === 'string' ? item.id : typeof item.short_id === 'string' ? item.short_id : null;
        if (!id) continue;
        const projectPath = typeof item.working_directory === 'string' ? item.working_directory : ROOT_WORKSPACE;
        if (!projectPath.startsWith(ROOT_WORKSPACE)) continue;

        if (isSubagentSessionTitle(item.title)) continue;

        const title = typeof item.title === 'string' && item.title.trim()
            ? normalizeSessionName(item.title, null)
            : null;
        const createdAt = normalizeDevinTimestamp(item.created_at ?? item.last_activity_at);
        const updatedAt = normalizeDevinTimestamp(item.updated_at ?? item.last_activity_at);

        if (!byProject.has(projectPath)) byProject.set(projectPath, []);
        byProject.get(projectPath).push({ id, title, createdAt, updatedAt });
    }
    return byProject;
}

async function getDevinListForRepo(repoPath) {
    const now = Date.now();
    const cached = devinListCache.get(repoPath);
    if (cached && now - cached.ts < DEVIN_LIST_CACHE_TTL_MS) {
        return cached.items;
    }

    const output = await runDevinList(repoPath);
    const parsed = JSON.parse(output);
    const sessions = Array.isArray(parsed) ? parsed : [];
    const byProject = importSessionItems(sessions);
    const items = byProject.get(repoPath) ?? [];

    devinListCache.set(repoPath, { ts: Date.now(), items });
    return items;
}

function isAfterSince(value, since) {
    if (!since) return true;
    const sinceDate = typeof since === 'string' ? new Date(since) : since;
    if (Number.isNaN(sinceDate.getTime())) return true;
    const valueDate = typeof value === 'string' ? new Date(value) : null;
    if (!valueDate || Number.isNaN(valueDate.getTime())) return true;
    return valueDate.getTime() > sinceDate.getTime();
}

async function readFirstJsonlObject(filePath) {
    if (!fs.existsSync(filePath)) {
        return null;
    }

    const stream = fs.createReadStream(filePath, { encoding: 'utf8' });
    const rl = readline.createInterface({ input: stream, crlfDelay: Infinity });
    try {
        for await (const line of rl) {
            const trimmed = line.trim();
            if (!trimmed) continue;
            try {
                return JSON.parse(trimmed);
            } catch {
                return null;
            }
        }
    } finally {
        rl.close();
        stream.destroy();
    }
    return null;
}

async function getDevinNativeSessionMeta(sessionId) {
    try {
        const { default: Database } = await import('better-sqlite3');
        const db = new Database(DEVIN_DB_PATH, { readonly: true, nativeBinding: resolveSqliteNativeBinding() });
        try {
            const row = db
                .prepare('SELECT title, created_at, last_activity_at FROM sessions WHERE id = ?')
                .get(sessionId);
            if (!row) {
                return null;
            }
            return {
                title: typeof row.title === 'string' ? row.title : null,
                createdAt: normalizeDevinTimestamp(row.created_at),
                updatedAt: normalizeDevinTimestamp(row.last_activity_at),
            };
        } finally {
            db.close();
        }
    } catch {
        return null;
    }
}

async function getDevinWorkingDirectories() {
    try {
        const { default: Database } = await import('better-sqlite3');
        const db = new Database(DEVIN_DB_PATH, { readonly: true, nativeBinding: resolveSqliteNativeBinding() });
        try {
            const rows = db
                .prepare('SELECT DISTINCT working_directory FROM sessions WHERE working_directory LIKE ?')
                .all('/workspace%');
            return new Set(rows.map((row) => row.working_directory));
        } finally {
            db.close();
        }
    } catch {
        return null;
    }
}

async function queryAllDevinSessions() {
    try {
        const { default: Database } = await import('better-sqlite3');
        const db = new Database(DEVIN_DB_PATH, { readonly: true, nativeBinding: resolveSqliteNativeBinding() });
        try {
            const rows = db
                .prepare(`SELECT id, working_directory, title, created_at, last_activity_at
                          FROM sessions
                          WHERE working_directory LIKE '/workspace%'
                            AND (hidden IS NULL OR hidden = 0)`)
                .all();
            return rows.map((row) => ({
                id: row.id,
                short_id: row.id,
                working_directory: row.working_directory,
                title: row.title,
                created_at: row.created_at,
                last_activity_at: row.last_activity_at,
            }));
        } finally {
            db.close();
        }
    } catch (error) {
        const message = error instanceof Error ? error.message : String(error);
        console.warn(`[DevinSessionSynchronizer] Failed to query all Devin sessions:`, message);
        return [];
    }
}

export class DevinSessionSynchronizer {
    provider = 'devin';

    async synchronize(since) {
        const roots = findGitRootsCached();
        const allRoots = roots.includes(ROOT_WORKSPACE)
            ? [...roots]
            : [ROOT_WORKSPACE, ...roots];

        // Ensure every git repo and the root workspace exist as projects.
        for (const repoPath of allRoots) {
            try {
                projectsDb.ensureProjectPath(repoPath, path.basename(repoPath));
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                console.warn(`[DevinSessionSynchronizer] Failed to create project for ${repoPath}:`, message);
            }
        }

        const failures = [];

        const allSessions = await queryAllDevinSessions();
        const sessionsByRepo = importSessionItems(allSessions);

        let total = 0;
        for (const repoPath of allRoots) {
            let processed = 0;
            const items = sessionsByRepo.get(repoPath) ?? [];

            try {
                for (const item of items) {
                    const existing = await sessionsDb.getSessionByProviderSessionId(item.id);
                    if (existing && existing.updated_at === item.updatedAt) {
                        continue;
                    }
                    if (!isAfterSince(item.updatedAt, since) && existing) {
                        continue;
                    }

                    const jsonlPath = path.join(repoPath, '.ddagent', 'devin', `${item.id}.jsonl`);
                    await sessionsDb.createSession(item.id, 'devin', repoPath, item.title, item.createdAt, item.updatedAt, jsonlPath);
                    processed += 1;
                }
            } catch (error) {
                const message = error instanceof Error ? error.message : String(error);
                console.warn(`[DevinSessionSynchronizer] Failed to sync ${repoPath}:`, message);
                failures.push(`${repoPath}: ${message}`);
            }

            total += processed;
        }

        if (failures.length) {
            console.warn(`[DevinSessionSynchronizer] ${failures.length} failures:`, failures);
        }
        return total;
    }

    async synchronizeFile(filePath) {
        const resolvedPath = path.resolve(filePath);
        if (!resolvedPath.endsWith('.jsonl')) {
            return null;
        }

        const devinDir = path.dirname(resolvedPath);
        const ddagentDir = path.dirname(devinDir);
        const repoPath = path.dirname(ddagentDir);

        if (path.basename(ddagentDir) !== '.ddagent' || path.basename(devinDir) !== 'devin') {
            return null;
        }

        let sessionId = path.basename(resolvedPath, '.jsonl');
        if (!sessionId) {
            return null;
        }

        let firstLine = null;
        try {
            firstLine = await readFirstJsonlObject(resolvedPath);
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            console.warn(`[DevinSessionSynchronizer] Failed to read first line of ${resolvedPath}:`, message);
        }

        if (firstLine && typeof firstLine.sessionId === 'string' && firstLine.sessionId.trim()) {
            sessionId = firstLine.sessionId.trim();
        }

        let title = null;
        let createdAt = null;
        let updatedAt = null;

        const native = await getDevinNativeSessionMeta(sessionId);
        if (native) {
            title = native.title;
            createdAt = native.createdAt;
            updatedAt = native.updatedAt;
        }

        if (isSubagentSessionTitle(title)) {
            return null;
        }

        if (!updatedAt && firstLine && typeof firstLine.timestamp === 'string') {
            const ts = normalizeDevinTimestamp(firstLine.timestamp);
            if (ts) {
                updatedAt = ts;
                if (!createdAt) {
                    createdAt = ts;
                }
            }
        }

        try {
            projectsDb.ensureProjectPath(repoPath, path.basename(repoPath));
            const normalizedTitle = title ? normalizeSessionName(title, null) : null;
            sessionsDb.createSession(sessionId, 'devin', repoPath, normalizedTitle, createdAt, updatedAt, resolvedPath);
        } catch (error) {
            const message = error instanceof Error ? error.message : String(error);
            console.warn(`[DevinSessionSynchronizer] Failed to sync file ${resolvedPath}:`, message);
            return null;
        }

        return sessionId;
    }
}

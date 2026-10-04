import { createHash } from 'node:crypto';
import { readdir, readFile, stat } from 'node:fs/promises';
import path from 'node:path';

import { knowledgeDb, projectsDb } from '@/modules/database/index.js';
import { parseFrontMatter } from '@/shared/frontmatter.js';
import { AppError } from '@/shared/utils.js';

/**
 * Project scanner: imports the AI-context files found in a project folder into
 * the knowledge base, classified by intent.
 *
 * Consumers: the Knowledge routes (`POST /api/knowledge/scan`) and the Flutter
 * Knowledge screen. Sources: `AGENTS.md`, `CLAUDE.md`, `MUSE.md`, `GEMINI.md`,
 * `CODEX.md`, `.cursorrules`, `.muserules`, every markdown file under
 * `.cursor/rules`, and `SKILL.md` files under `skills` / `.agents/skills`.
 *
 * Classification (so a scan reaches the right place):
 * - instruction/config files -> **rules** (critical, enabled; the workspace
 *   `AGENTS.md`, already injected by unified-rules, is `high` to avoid double
 *   injection) — these therefore reach the agent context.
 * - `SKILL.md` -> **skills** (name/description from frontmatter).
 * - any other markdown under the scanned dirs -> **reference memories**.
 *
 * Each imported file is remembered in `kb_scan_state` by content hash, so a
 * rescan only touches changed files and deletes the entities whose source file
 * is gone.
 */

const ROOT_FILES = [
  'AGENTS.md',
  'CLAUDE.md',
  'MUSE.md',
  'GEMINI.md',
  'CODEX.md',
  '.cursorrules',
  '.muserules',
];

const SCAN_DIRS = ['.cursor/rules', 'skills', '.agents/skills'];

const IGNORED_DIRS = new Set([
  'node_modules',
  '.git',
  'dist',
  'build',
  '.next',
  'target',
  'vendor',
  '.venv',
  '__pycache__',
  'coverage',
]);

const MAX_FILE_BYTES = 300 * 1024;
const MAX_FILES = 500;
const MAX_DEPTH = 6;

type KnowledgeScanKind = 'memory' | 'rule' | 'skill';

export type KnowledgeScanResult = {
  projectId: string;
  scanned: number;
  imported: number;
  updated: number;
  skipped: number;
  deleted: number;
  files: string[];
};

const toPosix = (value: string): string => value.split(path.sep).join('/');

async function pathExists(target: string): Promise<boolean> {
  try {
    await stat(target);
    return true;
  } catch {
    return false;
  }
}

async function walkMarkdownFiles(
  dir: string,
  root: string,
  depth: number,
  out: Set<string>,
): Promise<void> {
  if (depth > MAX_DEPTH || out.size >= MAX_FILES) return;
  let entries;
  try {
    entries = await readdir(dir, { withFileTypes: true });
  } catch {
    return;
  }
  for (const entry of entries) {
    if (out.size >= MAX_FILES) return;
    const absolute = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      if (IGNORED_DIRS.has(entry.name)) continue;
      await walkMarkdownFiles(absolute, root, depth + 1, out);
    } else if (entry.isFile() && /\.(md|mdc)$/i.test(entry.name)) {
      out.add(toPosix(path.relative(root, absolute)));
    }
  }
}

/** Collects the scannable markdown/rule files for a project, relative to its root. */
async function collectScanFiles(root: string): Promise<string[]> {
  const files = new Set<string>();
  for (const name of ROOT_FILES) {
    if (await pathExists(path.join(root, name))) files.add(name);
  }
  for (const dir of SCAN_DIRS) {
    const absolute = path.join(root, dir);
    if (await pathExists(absolute)) {
      await walkMarkdownFiles(absolute, root, 0, files);
    }
  }
  return [...files];
}

/** Reads a text source file, returning null for missing, oversized or binary files. */
async function readTextFile(absolute: string): Promise<string | null> {
  try {
    const info = await stat(absolute);
    if (!info.isFile() || info.size > MAX_FILE_BYTES) return null;
    const content = await readFile(absolute, 'utf8');
    // A NUL byte anywhere marks a binary file with a misleading .md extension.
    return content.includes('\u0000') ? null : content;
  } catch {
    return null;
  }
}

/** Title = first markdown heading, falling back to the file name without extension. */
function deriveTitle(content: string, relPath: string): string {
  for (const line of content.split('\n')) {
    const match = /^#\s+(.+?)\s*$/.exec(line);
    if (match) return match[1].slice(0, 300);
  }
  const base = path.posix.basename(relPath).replace(/\.(md|mdc)$/i, '');
  return base.slice(0, 300) || relPath;
}

/** Maps a scanned file to the entity kind it should become. */
function classify(relPath: string): KnowledgeScanKind {
  const base = path.posix.basename(relPath).toLowerCase();
  if (base === 'skill.md') return 'skill';
  if (relPath.startsWith('.cursor/rules/')) return 'rule';
  if (ROOT_FILES.includes(relPath)) return 'rule';
  return 'memory';
}

/**
 * Priority for an imported rule. The workspace `AGENTS.md` is already injected
 * by the unified-rules prefix, so it stays `high` (visible, user-toggleable)
 * while every other instruction source is `critical` and injected.
 */
function rulePriority(relPath: string): string {
  return relPath === 'AGENTS.md' ? 'high' : 'critical';
}

const readString = (value: unknown): string => (typeof value === 'string' ? value.trim() : '');

/** Resolves a collision-free skill name, suffixing with the source folder. */
function skillNameFor(content: string, relPath: string, currentName?: string): string {
  const { data } = parseFrontMatter(content);
  const base = (readString(data.name) || deriveTitle(content, relPath)).slice(0, 120);
  const existing = knowledgeDb.findSkillByName(base);
  if (!existing || existing.name === currentName) return base;
  const parent = path.posix.dirname(relPath);
  const suffix = parent && parent !== '.' ? ` (${parent})` : ` (${relPath})`;
  let candidate = `${base}${suffix}`.slice(0, 120);
  let counter = 2;
  while (knowledgeDb.findSkillByName(candidate)) {
    candidate = `${base}${suffix} #${counter}`.slice(0, 120);
    counter += 1;
  }
  return candidate;
}

function createEntity(
  kind: KnowledgeScanKind,
  projectId: string,
  relPath: string,
  title: string,
  content: string,
): string {
  if (kind === 'rule') {
    return knowledgeDb.createRule({
      projectId,
      title,
      content,
      priority: rulePriority(relPath),
      enabled: true,
    }).id;
  }
  if (kind === 'skill') {
    const { data } = parseFrontMatter(content);
    const parent = path.posix.dirname(relPath);
    return knowledgeDb.createSkill({
      name: skillNameFor(content, relPath),
      description: readString(data.description),
      content,
      category: readString(data.category) || (parent !== '.' ? parent : 'general'),
    }).id;
  }
  return knowledgeDb.createMemory({
    projectId,
    title,
    content,
    memoryType: 'reference',
    source: `file:${relPath}`,
  }).id;
}

function updateEntity(
  kind: KnowledgeScanKind,
  id: string,
  relPath: string,
  title: string,
  content: string,
): boolean {
  if (kind === 'rule') {
    return Boolean(
      knowledgeDb.updateRule(id, {
        title,
        content,
        priority: rulePriority(relPath),
        enabled: true,
      }),
    );
  }
  if (kind === 'skill') {
    const current = knowledgeDb.getSkill(id);
    if (!current) return false;
    const { data } = parseFrontMatter(content);
    const parent = path.posix.dirname(relPath);
    return Boolean(
      knowledgeDb.updateSkill(id, {
        name: skillNameFor(content, relPath, current.name),
        description: readString(data.description),
        content,
        category: readString(data.category) || (parent !== '.' ? parent : 'general'),
      }),
    );
  }
  return Boolean(
    knowledgeDb.updateMemory(id, {
      title,
      content,
      memoryType: 'reference',
      source: `file:${relPath}`,
    }),
  );
}

function getEntity(kind: string, id: string): unknown {
  if (kind === 'rule') return knowledgeDb.getRule(id);
  if (kind === 'skill') return knowledgeDb.getSkill(id);
  return knowledgeDb.getMemory(id);
}

function deleteEntity(kind: string, id: string): void {
  if (kind === 'rule') knowledgeDb.deleteRule(id);
  else if (kind === 'skill') knowledgeDb.deleteSkill(id);
  else knowledgeDb.deleteMemory(id);
}

export const knowledgeScanService = {
  /**
   * Scans (or rescans) a project's AI-context files into the knowledge base.
   *
   * Incremental by content hash: unchanged files are skipped, changed files
   * update their linked entity in place, and files that disappeared delete
   * their entity. Best-effort per file — one unreadable file never aborts the
   * whole scan.
   */
  async scanProject(projectId: string): Promise<KnowledgeScanResult> {
    const root = projectsDb.getProjectPathById(projectId);
    if (!root) {
      throw new AppError(`Project "${projectId}" was not found`, {
        code: 'PROJECT_NOT_FOUND',
        statusCode: 404,
      });
    }
    if (!(await pathExists(root))) {
      throw new AppError(`Project folder "${root}" does not exist`, {
        code: 'PROJECT_FOLDER_MISSING',
        statusCode: 400,
      });
    }

    const candidates = await collectScanFiles(root);
    const previous = new Map(knowledgeDb.getScanState(projectId).map((row) => [row.path, row]));
    const seen = new Set<string>();
    const result: KnowledgeScanResult = {
      projectId,
      scanned: 0,
      imported: 0,
      updated: 0,
      skipped: 0,
      deleted: 0,
      files: [],
    };

    for (const relPath of candidates) {
      const content = await readTextFile(path.join(root, relPath));
      if (content === null) continue;
      seen.add(relPath);
      result.scanned += 1;

      const contentHash = createHash('sha256').update(content).digest('hex');
      const kind = classify(relPath);
      const title = deriveTitle(content, relPath);
      const existingState = previous.get(relPath);

      if (!existingState) {
        const entityId = createEntity(kind, projectId, relPath, title, content);
        knowledgeDb.upsertScanState({
          projectId,
          path: relPath,
          contentHash,
          entityType: kind,
          entityId,
        });
        result.imported += 1;
        result.files.push(relPath);
        continue;
      }

      if (existingState.contentHash === contentHash && existingState.entityType === kind) {
        result.skipped += 1;
        continue;
      }

      const linked =
        existingState.entityId && existingState.entityType === kind ? existingState.entityId : null;
      if (linked && getEntity(kind, linked)) {
        updateEntity(kind, linked, relPath, title, content);
        knowledgeDb.upsertScanState({
          projectId,
          path: relPath,
          contentHash,
          entityType: kind,
          entityId: linked,
        });
        result.updated += 1;
      } else {
        // First import, or the file was reclassified to another entity kind.
        if (existingState.entityId) deleteEntity(existingState.entityType, existingState.entityId);
        const entityId = createEntity(kind, projectId, relPath, title, content);
        knowledgeDb.upsertScanState({
          projectId,
          path: relPath,
          contentHash,
          entityType: kind,
          entityId,
        });
        result.imported += 1;
      }
      result.files.push(relPath);
    }

    // Files that vanished since the last scan take their imported entity with them.
    for (const [relPath, state] of previous) {
      if (seen.has(relPath)) continue;
      if (state.entityId && getEntity(state.entityType, state.entityId)) {
        deleteEntity(state.entityType, state.entityId);
      }
      knowledgeDb.deleteScanState(projectId, relPath);
      result.deleted += 1;
    }

    return result;
  },
};

import { mkdir, readFile, stat, writeFile } from 'node:fs/promises';
import path from 'node:path';

import { AppError } from '@/shared/utils.js';

/**
 * Per-project shared memory file: `<projectPath>/.ddagent/shared-context.md`.
 *
 * Every session in the project receives the file's content prepended to its
 * first outbound message (see dispatchChatCommand), so broadcast learnings
 * and conventions live in one place all agents can read.
 */
const SHARED_CONTEXT_SEGMENTS = ['.ddagent', 'shared-context.md'];
const MAX_CONTEXT_BYTES = 50 * 1024;

export type SharedContextDocument = {
  content: string;
  updatedAt: string | null;
};

export function sharedContextPath(projectPath: string): string {
  return path.join(projectPath, ...SHARED_CONTEXT_SEGMENTS);
}

/** Returns null when the file does not exist — absence is normal. */
export async function readSharedContext(projectPath: string): Promise<SharedContextDocument | null> {
  try {
    const content = await readFile(sharedContextPath(projectPath), 'utf8');
    const fileStat = await stat(sharedContextPath(projectPath));
    return { content, updatedAt: fileStat.mtime.toISOString() };
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
      return null;
    }
    throw error;
  }
}

export async function writeSharedContext(
  projectPath: string,
  content: string,
): Promise<SharedContextDocument> {
  if (Buffer.byteLength(content, 'utf8') > MAX_CONTEXT_BYTES) {
    throw new AppError(`Shared context exceeds ${MAX_CONTEXT_BYTES} bytes`, {
      code: 'SHARED_CONTEXT_TOO_LARGE',
      statusCode: 413,
    });
  }
  const filePath = sharedContextPath(projectPath);
  await mkdir(path.dirname(filePath), { recursive: true });
  await writeFile(filePath, content, 'utf8');
  const fileStat = await stat(filePath);
  return { content, updatedAt: fileStat.mtime.toISOString() };
}

const INJECTION_HEADER =
  'The following shared context is maintained by the ddagent workspace for all agents in this project. Read it before acting, and keep it in mind for the whole session.';

/**
 * Builds the first-turn prompt prefix for a session in `projectPath`.
 * Returns null when no shared context file exists (or it is empty), so
 * providers without a dedicated system-context channel need no flag — the
 * prepend IS the fallback and works for every provider uniformly.
 */
export async function buildSharedContextPrefix(projectPath: string): Promise<string | null> {
  const doc = await readSharedContext(projectPath);
  const trimmed = doc?.content.trim();
  if (!trimmed) {
    return null;
  }
  return `${INJECTION_HEADER}\n\n${trimmed}\n\n---\n\n`;
}

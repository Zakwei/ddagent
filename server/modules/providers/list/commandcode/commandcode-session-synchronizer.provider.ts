import path from 'node:path';

import { sessionsDb } from '@/modules/database/index.js';
import type { IProviderSessionSynchronizer } from '@/shared/interfaces.js';
import type { AnyRecord } from '@/shared/types.js';
import {
  commandCodeProjectsDir,
  extractFirstValidJsonlData,
  findFilesRecursivelyCreatedAfter,
  isCommandCodeTranscriptFileName,
  isSubagentSessionTitle,
  normalizeSessionName,
  readFileTimestamps,
  readJsonConfig,
  readOptionalString,
} from '@/shared/utils.js';

import { readCommandCodeTranscript } from './commandcode-sessions.provider.js';

type ParsedSession = {
  sessionId: string;
  projectPath: string;
  sessionName?: string;
};

const FALLBACK_TITLE = 'Untitled Command Code Session';

/**
 * Reads the `<session-id>.meta.json` sidecar next to a transcript. The CLI
 * stores the user/title metadata there (`title`, `userRenamed`, `model`,
 * `parentSessionId`, `forkedAt`); a missing or malformed file is not an error.
 */
async function readSessionMetaTitle(transcriptPath: string): Promise<string | undefined> {
  const metaPath = transcriptPath.replace(/\.jsonl$/, '.meta.json');
  try {
    const meta = await readJsonConfig(metaPath);
    return readOptionalString(meta.title);
  } catch {
    return undefined;
  }
}

/**
 * Finds the newest `session_info` name and the first real user text in one
 * transcript parse. `session_info` is how `cmd` records a generated or
 * user-renamed title; the first user message is the fallback label.
 */
async function readTranscriptMetadata(
  transcriptPath: string,
): Promise<{ title?: string; firstUserText?: string }> {
  try {
    const entries = await readCommandCodeTranscript(transcriptPath);
    let title: string | undefined;
    let firstUserText: string | undefined;
    for (const entry of entries) {
      if (entry.type === 'session_info') {
        const name = readOptionalString(entry.name);
        if (name?.trim()) {
          title = name.trim();
        }
        continue;
      }
      if (entry.type !== 'message' || firstUserText) {
        continue;
      }
      const message = entry.message as AnyRecord | undefined;
      if (message?.role !== 'user' || message?.meta?.isMeta === true) {
        continue;
      }
      const text = extractUserText(message.content);
      if (text) {
        firstUserText = text;
      }
    }
    return { title, firstUserText };
  } catch {
    return {};
  }
}

function extractUserText(content: unknown): string | undefined {
  if (typeof content === 'string' && content.trim()) {
    return content.trim();
  }
  if (!Array.isArray(content)) {
    return undefined;
  }
  for (const block of content) {
    const record = block as AnyRecord;
    if (record?.type === 'text' && typeof record.text === 'string' && record.text.trim()) {
      return record.text.trim();
    }
  }
  return undefined;
}

/**
 * Session indexer for Command Code transcript artifacts.
 *
 * Every project gets a `~/.commandcode/projects/<slug>/` directory holding one
 * `<session-id>.jsonl` transcript per session plus sidecars
 * (`.meta.json`, `.checkpoints.jsonl`, `.prompts.jsonl`, `.share.json`,
 * `.v2.bak`). Only the primary `.jsonl` files index as sessions.
 */
export class CommandCodeSessionSynchronizer implements IProviderSessionSynchronizer {
  private readonly provider = 'commandcode' as const;

  /**
   * Scans ~/.commandcode/projects and upserts discovered sessions into DB.
   */
  async synchronize(since?: Date): Promise<number> {
    const files = await findFilesRecursivelyCreatedAfter(
      commandCodeProjectsDir(),
      '.jsonl',
      since ?? null,
    );

    let processed = 0;
    for (const filePath of files) {
      if (!isCommandCodeTranscriptFileName(path.basename(filePath))) {
        continue;
      }
      if (await this.processSessionFile(filePath)) {
        processed += 1;
      }
    }

    return processed;
  }

  /**
   * Parses and upserts one transcript file for a watcher event.
   */
  async synchronizeFile(filePath: string): Promise<string | null> {
    if (!isCommandCodeTranscriptFileName(path.basename(filePath))) {
      return null;
    }

    return this.processSessionFile(filePath);
  }

  /**
   * Reads the v3 session header + title metadata and upserts the session row.
   * Returns the stored row id so watcher-triggered `session_upserted` events
   * stay on the app session once `provider_session_id` is mapped.
   */
  private async processSessionFile(filePath: string): Promise<string | null> {
    const parsed = await extractFirstValidJsonlData(filePath, (rawData) => {
      const data = rawData as AnyRecord;
      if (data?.type !== 'session') {
        return null;
      }
      const sessionId = readOptionalString(data.id);
      const projectPath = readOptionalString(data.cwd);
      if (!sessionId || !projectPath) {
        return null;
      }
      return { sessionId, projectPath };
    });

    if (!parsed) {
      return null;
    }

    const metaTitle = await readSessionMetaTitle(filePath);

    const pendingAppSession = sessionsDb.getSessionByProviderSessionId(parsed.sessionId)
      ?? sessionsDb.getSessionById(parsed.sessionId)
      ?? sessionsDb.findLatestPendingAppSession(this.provider, parsed.projectPath);
    if (pendingAppSession && !pendingAppSession.provider_session_id) {
      // The watcher can index the transcript before the runtime reports its
      // provider id back; bind it to the fresh app row so the sidebar does not
      // get a duplicate provider-id entry for the same session.
      sessionsDb.assignProviderSessionId(pendingAppSession.session_id, parsed.sessionId);
    }

    const existingSession = sessionsDb.getSessionByProviderSessionId(parsed.sessionId)
      ?? sessionsDb.getSessionById(parsed.sessionId);
    const existingName = existingSession?.custom_name;
    if (existingName && existingName !== FALLBACK_TITLE) {
      // An explicit name (user rename in-app or an earlier session_info) wins
      // over a later disk read so rescan never clobbers it.
      const timestamps = await readFileTimestamps(filePath);
      return sessionsDb.createSession(
        parsed.sessionId,
        this.provider,
        parsed.projectPath,
        normalizeSessionName(existingName, FALLBACK_TITLE),
        timestamps.createdAt,
        timestamps.updatedAt,
        filePath,
      );
    }

    const { title, firstUserText } = metaTitle
      ? { title: metaTitle, firstUserText: undefined }
      : await readTranscriptMetadata(filePath);
    const nextName = title ?? firstUserText;

    if (isSubagentSessionTitle(nextName)) {
      return null;
    }

    const timestamps = await readFileTimestamps(filePath);
    return sessionsDb.createSession(
      parsed.sessionId,
      this.provider,
      parsed.projectPath,
      normalizeSessionName(nextName, FALLBACK_TITLE),
      timestamps.createdAt,
      timestamps.updatedAt,
      filePath,
    );
  }
}

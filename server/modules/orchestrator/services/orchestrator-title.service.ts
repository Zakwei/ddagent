import type { OrchestratorCandidate } from '@/shared/index.js';

import type { OrchestratorDelegationService } from './orchestrator-delegation.service.js';
import type { OrchestratorRouter } from './orchestrator-router.service.js';

/** Bounds the generated title: at most this many words, then this many chars. */
const MAX_TITLE_WORDS = 6;
const MAX_TITLE_LENGTH = 60;

/** How long the background title call may take before it is abandoned. */
const TITLE_TIMEOUT_MS = 15_000;

/**
 * Builds the one-shot prompt asking a cheap lane to title a session from its
 * first user message. Consumed by `createOrchestratorSessionTitleService` and
 * asserted directly by the orchestrator tests.
 */
export function buildSessionTitlePrompt(input: {
  content: string;
  languageName?: string | null;
}): string {
  const parts = [
    "You name chat sessions. Given the user's first message, reply with ONLY a short title describing what the user is asking the assistant to do.",
    'Rules: at most 6 words; sentence case; no quotes, markdown, code fences, or trailing period; describe the task, not the wording; never mention providers or models.',
    '',
    'USER MESSAGE:',
    input.content.trim(),
  ];
  if (input.languageName) {
    parts.push('', `Write the title in ${input.languageName}.`);
  }
  parts.push('', 'Output only the title:');
  return parts.join('\n');
}

/**
 * Normalizes a raw model answer into a display title, or null when nothing
 * usable remains. It drops fenced code, markdown emphasis, a leading
 * "Title:" label, surrounding quotes, and any lines after the first; caps the
 * word count and length; and applies sentence case. Consumed by the title
 * service and its tests.
 */
export function cleanSessionTitle(raw: string): string | null {
  let text = (raw ?? '').trim();
  if (!text) {
    return null;
  }
  text = text
    .replace(/```[\s\S]*?```/g, ' ')
    .replace(/[`*_#>]+/g, ' ');
  text = text
    .split('\n')
    .map((line) => line.trim())
    .find((line) => line.length > 0) ?? '';
  text = text.replace(/^title\s*[:\-]\s*/i, '');
  text = text.replace(/^["'“”‘’\s]+|["'“”‘’\s]+$/g, '');
  text = text.replace(/\s+/g, ' ').trim();
  if (!text) {
    return null;
  }

  const words = text.split(' ').filter(Boolean);
  if (words.length > MAX_TITLE_WORDS) {
    text = words.slice(0, MAX_TITLE_WORDS).join(' ');
  }
  if (text.length > MAX_TITLE_LENGTH) {
    const cut = text.slice(0, MAX_TITLE_LENGTH);
    const lastSpace = cut.lastIndexOf(' ');
    text = (lastSpace > 0 ? cut.slice(0, lastSpace) : cut).trim();
  }
  if (!text) {
    return null;
  }
  return text.charAt(0).toUpperCase() + text.slice(1);
}

export type SessionTitleService = {
  /**
   * Generates a title for `content` using the cheapest viable `report` lane.
   * Best-effort: routing failure, provider error, or timeout resolves to null
   * so the caller keeps the derived title.
   */
  generate(input: {
    content: string;
    languageName?: string | null;
    parentSessionId: string;
    cwd: string;
  }): Promise<string | null>;
};

/**
 * Session-title generator used by the orchestrator runtime's
 * `generateSessionTitle`. Reuses the config-driven router (`report` is the
 * cheapest-first summarization lane) and the delegation service to run one
 * hidden child, so no routing/run plumbing is duplicated.
 */
export function createOrchestratorSessionTitleService(deps: {
  router: OrchestratorRouter;
  delegation: OrchestratorDelegationService;
  /** Overridable for tests; defaults to TITLE_TIMEOUT_MS. */
  timeoutMs?: number;
}): SessionTitleService {
  const timeoutMs = deps.timeoutMs ?? TITLE_TIMEOUT_MS;
  return {
    async generate(input): Promise<string | null> {
      if (!input.content.trim()) {
        return null;
      }
      const routed = deps.router.route('report');
      if (!routed.ok) {
        return null;
      }
      const candidate: OrchestratorCandidate = routed.candidate;
      const handle = await deps.delegation.run({
        parentSessionId: input.parentSessionId,
        delegationRowId: null,
        provider: candidate.provider,
        model: candidate.model,
        effort: candidate.effort ?? null,
        accountId: candidate.accountId ?? null,
        cwd: input.cwd,
        command: buildSessionTitlePrompt({
          content: input.content,
          languageName: input.languageName,
        }),
        permissionMode: 'bypassPermissions',
        hidden: true,
      });

      let timer: ReturnType<typeof setTimeout> | undefined;
      const result = await Promise.race([
        handle.completed,
        new Promise<'timed-out'>((resolve) => {
          timer = setTimeout(() => resolve('timed-out'), timeoutMs);
          timer.unref?.();
        }),
      ]).finally(() => {
        if (timer) clearTimeout(timer);
      });

      if (result === 'timed-out') {
        await handle.abort().catch(() => undefined);
        return null;
      }
      if (!result.ok) {
        return null;
      }
      return cleanSessionTitle(result.finalText);
    },
  };
}

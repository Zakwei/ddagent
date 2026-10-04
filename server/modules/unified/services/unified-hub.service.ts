import { lstat, mkdir, readFile, rm, symlink, writeFile } from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';

import { providerSkillsService } from '@/modules/providers/index.js';
import type {
  ProviderSkill,
  ProviderSkillCreateInput,
  ProviderSkillListOptions,
  ProviderSkillMoveInput,
  ProviderSkillMoveResult,
} from '@/shared/types.js';

// ----------------- Canonical skill store -----------------
//
// The shared skill root is Codex's global dir (`~/.agents/skills`): six of the
// seven providers (codex, cursor, opencode, devin, antigravity, commandcode)
// read it natively, so writing once here is visible to all of them without
// fan-out. Claude is the exception (`~/.claude/skills`) and gets a mirror
// below. Writes reuse the providers module's validated Codex adapter, so
// unified installs follow byte-identical rules (name normalization, SKILL.md
// front-matter, supporting-file sandboxing) — this service adds no validation
// of its own.

/** Shared skill root every provider except Claude reads natively. */
export function unifiedGlobalSkillsDir(): string {
  return path.join(os.homedir(), '.agents', 'skills');
}

/** Claude's native skill dir — kept as a mirror of the canonical root. */
export function claudeGlobalSkillsDir(): string {
  return path.join(os.homedir(), '.claude', 'skills');
}

/**
 * Points Claude's skill dir at the canonical root. Creates a symlink only
 * when `~/.claude/skills` is absent — an existing real directory (user-owned
 * skills) is never replaced or merged, it just keeps working unmanaged.
 * Consumed by addUnifiedSkills and the resync route.
 */
export async function ensureClaudeMirror(): Promise<{ mirrored: boolean; target: string }> {
  const target = unifiedGlobalSkillsDir();
  const linkPath = claudeGlobalSkillsDir();
  await mkdir(target, { recursive: true });

  try {
    await lstat(linkPath);
    return { mirrored: false, target };
  } catch {
    await mkdir(path.dirname(linkPath), { recursive: true });
    await symlink(target, linkPath);
    return { mirrored: true, target };
  }
}

/**
 * Lists skills in the shared root (global `~/.agents/skills`, plus project
 * `.agents/skills` when `workspacePath` is given) through the Codex adapter,
 * which is that root's native reader. The result is what every non-Claude
 * provider sees; Claude sees the same set once the mirror exists.
 * Consumed by unified.routes (`GET /api/unified/skills`).
 */
export async function listUnifiedSkills(options?: ProviderSkillListOptions): Promise<ProviderSkill[]> {
  return providerSkillsService.listProviderSkills('codex', options);
}

/**
 * Writes skills once into the canonical root (validated by the Codex
 * adapter) and ensures the Claude mirror afterwards. Returned skills carry
 * `provider: 'codex'` — the adapter that owns the shared root — which the
 * unified UI reads as "shared with every provider". Consumed by
 * unified.routes (`POST /api/unified/skills`).
 */
export async function addUnifiedSkills(input: ProviderSkillCreateInput): Promise<ProviderSkill[]> {
  const skills = await providerSkillsService.addProviderSkills('codex', input);
  await ensureClaudeMirror();
  return skills;
}

/**
 * Removes one skill from the canonical root and, best-effort, from a
 * real-directory Claude mirror (a symlink mirror needs no cleanup).
 * Consumed by unified.routes (`DELETE /api/unified/skills/:directoryName`).
 */
export async function removeUnifiedSkill(
  directoryName: string,
): Promise<{ removed: boolean; provider: string; directoryName: string }> {
  const result = await providerSkillsService.removeProviderSkill('codex', { directoryName });
  try {
    const stats = await lstat(claudeGlobalSkillsDir());
    if (!stats.isSymbolicLink()) {
      await rm(path.join(claudeGlobalSkillsDir(), result.directoryName), { recursive: true, force: true });
    }
  } catch {
    // No mirror dir — nothing to clean up.
  }
  return result;
}

/**
 * Relocates one shared skill between the canonical global root
 * (`~/.agents/skills`) and a project's `.agents/skills`, reusing the Codex
 * adapter that owns that root. A move into the global root re-checks the
 * Claude mirror afterwards, matching addUnifiedSkills. Consumed by
 * unified.routes (`POST /api/unified/skills/move`).
 */
export async function moveUnifiedSkill(
  input: ProviderSkillMoveInput,
): Promise<ProviderSkillMoveResult> {
  const result = await providerSkillsService.moveProviderSkill('codex', input);
  if (result.moved && input.targetScope === 'global') {
    await ensureClaudeMirror();
  }
  return result;
}

/**
 * Re-points a missing Claude mirror at the canonical root. There is nothing
 * else to copy: the canonical root is already native to the other six
 * providers. Consumed by unified.routes (`POST /api/unified/skills/resync`).
 */
export async function resyncUnifiedSkills(): Promise<{ mirrored: boolean; target: string }> {
  return ensureClaudeMirror();
}

// ----------------- Unified rules -----------------
//
// Rule sources both agents and CLIs already honor: the workspace AGENTS.md
// (read natively by all seven providers) and the global ~/.agents/AGENTS.md.
// This module never writes rule files — it aggregates them and builds the
// first-turn prefix chat-dispatch prepends (same prepend pattern as the
// shared-context module), gated by DDAGENT_UNIFIED_RULES=0.

/** Rule files aggregated into the unified prefix, in precedence order. */
export function unifiedRulePaths(workspacePath?: string): string[] {
  const globalRules = path.join(os.homedir(), '.agents', 'AGENTS.md');
  if (!workspacePath) {
    return [globalRules];
  }
  return [path.join(path.resolve(workspacePath), 'AGENTS.md'), globalRules];
}

/** Always-on hygiene block: the DCP-class behavioral contract for providers without a native DCP plugin. */
export const UNIFIED_HYGIENE_BLOCK = [
  '<unified-hygiene>',
  'Do not paste full tool outputs, file contents, or error bursts back into the conversation.',
  'Summarize results briefly; re-read from disk when you need details again.',
  'Keep working context lean: drop exploration dead ends instead of quoting them.',
  '</unified-hygiene>',
].join('\n');

/**
 * Reads the unified rule sources that exist on disk. Missing files are
 * skipped — a workspace without AGENTS.md simply contributes no rules.
 * Consumed by buildUnifiedPrefix and unified.routes (`GET /api/unified/rules`).
 */
export async function readUnifiedRules(
  workspacePath?: string,
): Promise<{ sources: Array<{ path: string; present: boolean }>; text: string }> {
  const sources: Array<{ path: string; present: boolean }> = [];
  const chunks: string[] = [];
  for (const filePath of unifiedRulePaths(workspacePath)) {
    try {
      const text = (await readFile(filePath, 'utf8')).trim();
      sources.push({ path: filePath, present: true });
      if (text) {
        chunks.push(text);
      }
    } catch {
      sources.push({ path: filePath, present: false });
    }
  }
  return { sources, text: chunks.join('\n\n') };
}

/**
 * Builds the `<unified-rules>` first-turn prefix: aggregated rule files plus
 * the hygiene block. Returns null when there is nothing to inject (rules
 * disabled via DDAGENT_UNIFIED_RULES=0, or no rule files and no hygiene —
 * hygiene is always on, so null only means explicitly disabled).
 * Consumed by applyUnifiedPrefix.
 */
export async function buildUnifiedPrefix(workspacePath?: string): Promise<string | null> {
  if (process.env.DDAGENT_UNIFIED_RULES === '0') {
    return null;
  }
  const { text } = await readUnifiedRules(workspacePath);
  const body = [text.trim(), UNIFIED_HYGIENE_BLOCK].filter(Boolean).join('\n\n');
  if (!body) {
    return null;
  }
  return `<unified-rules>\n${body}\n</unified-rules>\n\n`;
}

/**
 * Prepends the unified prefix to one outbound user message. Used by
 * chat-dispatch on the session's first turn (same positional pattern as the
 * shared-context prefix: entering history once keeps it in context for the
 * whole session without per-turn token burn). Never throws — injection must
 * not block a send. Consumed by chat-dispatch.service.
 */
export async function applyUnifiedPrefix(content: string, workspacePath?: string): Promise<string> {
  try {
    const prefix = await buildUnifiedPrefix(workspacePath);
    return prefix ? prefix + content : content;
  } catch (error) {
    console.warn('[Unified] Rules injection skipped:', error);
    return content;
  }
}

// ----------------- Context (DCP-class) coverage -----------------

export type ContextCoverage = {
  /** Per-provider DCP-class mechanism currently in effect. */
  providers: Record<string, string>;
  /** Whether the opencode_dcp plugin is active on this machine. */
  opencodeDcp: { enabled: boolean; detail: string };
  /** Whether the managed Claude SessionStart hook is installed. */
  claudeHook: { installed: boolean; settingsPath: string };
};

/**
 * Detects the native opencode_dcp plugin by scanning opencode.jsonc for a
 * plugin entry mentioning dcp. Best-effort text match: the plugin has no
 * queryable runtime state from outside opencode. Consumed by
 * getContextCoverage.
 */
export async function isOpencodeDcpEnabled(): Promise<{ enabled: boolean; detail: string }> {
  const candidates = [
    path.join(os.homedir(), '.config', 'opencode', 'opencode.jsonc'),
    path.join(os.homedir(), '.config', 'opencode', 'opencode.json'),
  ];
  for (const filePath of candidates) {
    try {
      const text = await readFile(filePath, 'utf8');
      if (/dcp/i.test(text)) {
        return { enabled: true, detail: `mentioned in ${filePath}` };
      }
    } catch {
      // Absent config — try the next candidate.
    }
  }
  return { enabled: false, detail: 'no dcp plugin entry in opencode.jsonc' };
}

/** Marker comment identifying the hook entry this module manages. */
export const CLAUDE_HOOK_MARKER = 'ddagent-unified-context';

/**
 * Checks whether the managed SessionStart hook entry is present in the
 * user's claude settings.json. Consumed by getContextCoverage.
 */
export async function isClaudeHookInstalled(): Promise<{ installed: boolean; settingsPath: string }> {
  const settingsPath = path.join(os.homedir(), '.claude', 'settings.json');
  try {
    const text = await readFile(settingsPath, 'utf8');
    return {
      installed: text.includes(CLAUDE_HOOK_MARKER) || text.includes('claude-session-start.mjs'),
      settingsPath,
    };
  } catch {
    return { installed: false, settingsPath };
  }
}

/**
 * Reports which DCP-class mechanism covers each provider: native DCP on
 * opencode, the managed SessionStart hook on claude, and the always-on
 * hygiene prefix everywhere else. Consumed by unified.routes
 * (`GET /api/unified/context`).
 */
export async function getContextCoverage(): Promise<ContextCoverage> {
  const [opencodeDcp, claudeHook] = await Promise.all([isOpencodeDcpEnabled(), isClaudeHookInstalled()]);
  const hygiene = 'unified hygiene prefix (first-turn)';
  return {
    providers: {
      opencode: opencodeDcp.enabled ? 'native opencode_dcp plugin' : `${hygiene} — native plugin not detected`,
      claude: claudeHook.installed ? `managed SessionStart hook + ${hygiene}` : `${hygiene} only — hook not installed`,
      codex: hygiene,
      cursor: hygiene,
      devin: hygiene,
      antigravity: hygiene,
      commandcode: hygiene,
    },
    opencodeDcp,
    claudeHook,
  };
}

// ----------------- Managed Claude hook -----------------

/**
 * Absolute path of the SessionStart hook script this module installs. The
 * script lives in the repo so every checkout carries the same hook logic;
 * settings.json only points at it. Consumed by install/uninstall below.
 */
export function claudeHookScriptPath(): string {
  return path.join(process.cwd(), 'scripts', 'unified-hooks', 'claude-session-start.mjs');
}

type ClaudeSettings = {
  hooks?: Record<string, Array<{ matcher?: string; hooks: Array<{ type: string; command: string }> }>>;
};

/**
 * Registers the unified SessionStart hook in the user's claude
 * settings.json, merged with existing hooks (never overwritten). Idempotent
 * — a second install leaves one entry. Consumed by unified.routes
 * (`POST /api/unified/context/install-claude-hook`).
 */
export async function installClaudeHook(): Promise<{ installed: boolean; settingsPath: string }> {
  const settingsPath = path.join(os.homedir(), '.claude', 'settings.json');
  let settings: ClaudeSettings = {};
  try {
    settings = JSON.parse(await readFile(settingsPath, 'utf8')) as ClaudeSettings;
  } catch {
    settings = {};
  }

  const script = claudeHookScriptPath();
  const sessionStart = settings.hooks?.SessionStart ?? [];
  const already = sessionStart.some((entry) =>
    entry.hooks?.some((hook) => hook.command.includes(CLAUDE_HOOK_MARKER) || hook.command.includes('claude-session-start.mjs')),
  );
  if (already) {
    return { installed: false, settingsPath };
  }

  await mkdir(path.dirname(settingsPath), { recursive: true });
  const next: ClaudeSettings = {
    ...settings,
    hooks: {
      ...(settings.hooks ?? {}),
      SessionStart: [
        ...sessionStart,
        { matcher: '', hooks: [{ type: 'command', command: `node "${script}" # ${CLAUDE_HOOK_MARKER}` }] },
      ],
    },
  };
  await writeFile(settingsPath, `${JSON.stringify(next, null, 2)}\n`, 'utf8');
  return { installed: true, settingsPath };
}

/**
 * Removes the unified SessionStart hook again, leaving all other hooks
 * untouched. Consumed by unified.routes
 * (`POST /api/unified/context/uninstall-claude-hook`).
 */
export async function uninstallClaudeHook(): Promise<{ removed: boolean; settingsPath: string }> {
  const settingsPath = path.join(os.homedir(), '.claude', 'settings.json');
  let settings: ClaudeSettings;
  try {
    settings = JSON.parse(await readFile(settingsPath, 'utf8')) as ClaudeSettings;
  } catch {
    return { removed: false, settingsPath };
  }

  const sessionStart = settings.hooks?.SessionStart ?? [];
  const kept = sessionStart.filter(
    (entry) => !entry.hooks?.some((hook) => hook.command.includes(CLAUDE_HOOK_MARKER) || hook.command.includes('claude-session-start.mjs')),
  );
  if (kept.length === sessionStart.length) {
    return { removed: false, settingsPath };
  }

  await writeFile(
    settingsPath,
    `${JSON.stringify({ ...settings, hooks: { ...(settings.hooks ?? {}), SessionStart: kept } }, null, 2)}\n`,
    'utf8',
  );
  return { removed: true, settingsPath };
}

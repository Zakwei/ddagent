// unifiedHubService: single write path for skills/rules/context shared by every
// provider. Unified writes land in the shared ~/.agents/skills root (native to
// six providers); Claude reads them through a symlink mirror. Used by
// unified.routes and chat-dispatch.service (first-turn rules prefix).
export {
  addUnifiedSkills,
  applyUnifiedPrefix,
  buildUnifiedPrefix,
  claudeGlobalSkillsDir,
  claudeHookScriptPath,
  ensureClaudeMirror,
  getContextCoverage,
  installClaudeHook,
  isClaudeHookInstalled,
  isOpencodeDcpEnabled,
  listUnifiedSkills,
  readUnifiedRules,
  removeUnifiedSkill,
  resyncUnifiedSkills,
  uninstallClaudeHook,
  unifiedGlobalSkillsDir,
  unifiedRulePaths,
  CLAUDE_HOOK_MARKER,
  UNIFIED_HYGIENE_BLOCK,
} from './services/unified-hub.service.js';
export type { ContextCoverage } from './services/unified-hub.service.js';

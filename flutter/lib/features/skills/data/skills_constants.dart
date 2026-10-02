import 'dart:ui';

import 'package:ddagent_app/features/skills/data/skill_models.dart';

/// Skills constants — port of the maps in `ProviderSkills.tsx`.

/// `PROVIDER_NAMES`.
const kSkillProviderNames = <String, String>{
  'unified': 'Shared',
  'claude': 'Claude',
  'codex': 'Codex',
  'cursor': 'Cursor',
  'opencode': 'OpenCode',
  'commandcode': 'Command Code',
  'antigravity': 'Antigravity',
  'devin': 'Devin',
  'orchestrator': 'Auto',
};

/// Provider ids shown in the standalone screen's selector — the Agents
/// settings `VISIBLE_AGENTS` set. `unified` first: one shared list backed by
/// `/api/unified/skills` (canonical `~/.agents/skills` + Claude mirror),
// as opposed to per-provider configuration.
const kSkillProviders = [
  'unified',
  'claude',
  'cursor',
  'codex',
  'opencode',
  'commandcode',
  'antigravity',
  'devin',
];

/// `PROVIDER_MANAGED_SKILL_DIRS` — skills rooted under these directories are
/// provider-managed: installs write here and
/// `DELETE /api/providers/:provider/skills/:directoryName` removes them.
/// Devin picks its managed root dynamically, so its skills get no delete UI.
const kSkillManagedDirs = <String, String>{
  // Unified installs land in the shared root every provider reads natively.
  'unified': '.agents/skills',
  'claude': '.claude/skills',
  'codex': '.agents/skills',
  'cursor': '.cursor/skills',
  'opencode': '.config/opencode/skills',
  'commandcode': '.commandcode/skills',
  'antigravity': '.agents/skills',
};

/// `MAX_SKILL_FOLDER_FILES` / `MAX_SKILL_FOLDER_BYTES` — client-side upload
/// caps (the API has no explicit limit; these mirror the web checks).
const kSkillFolderMaxFiles = 500;
const kSkillFolderMaxBytes = 30 * 1024 * 1024;

/// Queued-install cap (`nextMap.values().slice(0, 20)` in the web drop
/// handler).
const kSkillQueueMax = 20;

/// `SCOPE_ORDER` — group headers render in this order.
const kSkillScopeOrder = SkillScope.values;

String skillProviderName(String provider) => kSkillProviderNames[provider] ?? provider;

/// `SCOPE_BADGE_CLASSES` — tailwind 500/30 border, 500/10 bg, 700 (light) /
/// 300 (dark) text.
({Color border, Color background, Color foreground}) skillScopeBadgeColors(
  SkillScope scope, {
  required bool isDark,
}) {
  final (base, light, dark) = switch (scope) {
    SkillScope.user => (
      const Color(0xFF10B981), // emerald-500
      const Color(0xFF047857), // emerald-700
      const Color(0xFF6EE7B7), // emerald-300
    ),
    SkillScope.plugin => (
      const Color(0xFF0EA5E9), // sky-500
      const Color(0xFF0369A1), // sky-700
      const Color(0xFF7DD3FC), // sky-300
    ),
    SkillScope.repo => (
      const Color(0xFFF59E0B), // amber-500
      const Color(0xFFB45309), // amber-700
      const Color(0xFFFCD34D), // amber-300
    ),
    SkillScope.project => (
      const Color(0xFFF97316), // orange-500
      const Color(0xFFC2410C), // orange-700
      const Color(0xFFFDBA74), // orange-300
    ),
    SkillScope.admin => (
      const Color(0xFFF43F5E), // rose-500
      const Color(0xFFBE123C), // rose-700
      const Color(0xFFFDA4AF), // rose-300
    ),
    SkillScope.system => (
      const Color(0xFF64748B), // slate-500
      const Color(0xFF334155), // slate-700
      const Color(0xFFCBD5E1), // slate-300
    ),
  };
  return (
    border: base.withValues(alpha: 0.3),
    background: base.withValues(alpha: 0.1),
    foreground: isDark ? dark : light,
  );
}

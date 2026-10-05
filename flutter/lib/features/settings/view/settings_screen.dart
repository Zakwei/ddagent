import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/features/settings/view/sections/about_section.dart';
import 'package:ddagent_app/features/settings/view/sections/agents_section.dart';
import 'package:ddagent_app/features/settings/view/sections/api_section.dart';
import 'package:ddagent_app/features/settings/view/sections/appearance_section.dart';
import 'package:ddagent_app/features/settings/view/sections/git_section.dart';
import 'package:ddagent_app/features/settings/view/sections/notifications_section.dart';
import 'package:ddagent_app/features/settings/view/sections/orchestration_section.dart';
import 'package:ddagent_app/features/settings/view/sections/shortcuts_section.dart';
import 'package:ddagent_app/features/settings/view/sections/tools_section.dart';
import 'package:ddagent_app/features/settings/view/sections/workspaces_section.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One settings section: `id` is the `:section` path param, `label` resolves
/// the localized tab title, `build` renders the body. Follow-up tasks
/// (flutter-parity-gaps F1.4–7) swap each `_PendingSection` stub for the real
/// tab widget — the registry below is the only place that changes.
class SettingsSection {
  const SettingsSection({
    required this.id,
    required this.icon,
    required this.label,
    required this.build,
  });

  final String id;
  final IconData icon;
  final String Function(Translations t) label;
  final WidgetBuilder build;
}

/// Settings sections — mirrors the web client's `SettingsMainTab` order
/// (src/components/settings/types/types.ts).
final settingsSections = <SettingsSection>[
  SettingsSection(
    id: 'agents',
    icon: LucideIcons.bot,
    label: (t) => t.settings.mainTabs.agents,
    build: (_) => const AgentsSection(),
  ),
  SettingsSection(
    id: 'orchestration',
    icon: LucideIcons.workflow,
    label: (t) => t.settings.mainTabs.orchestration,
    build: (_) => const OrchestrationSection(),
  ),
  SettingsSection(
    id: 'appearance',
    icon: LucideIcons.palette,
    label: (t) => t.settings.mainTabs.appearance,
    build: (_) => const AppearanceSection(),
  ),
  SettingsSection(
    id: 'git',
    icon: LucideIcons.gitBranch,
    label: (t) => t.settings.mainTabs.git,
    build: (_) => const GitSection(),
  ),
  SettingsSection(
    id: 'api',
    icon: LucideIcons.key,
    label: (t) => t.settings.mainTabs.apiTokens,
    build: (_) => const ApiSection(),
  ),
  // Merged Tasks + Browser into one "Tools" page — both are optional agent
  // capabilities. In the web client these were separate `SettingsMainTab`s.
  SettingsSection(
    id: 'tools',
    icon: LucideIcons.wrench,
    label: (t) => t.settings.mainTabs.tools,
    build: (_) => const ToolsSection(),
  ),
  SettingsSection(
    id: 'notifications',
    icon: LucideIcons.bell,
    label: (t) => t.settings.mainTabs.notifications,
    build: (_) => const NotificationsSection(),
  ),
  SettingsSection(
    id: 'workspaces',
    icon: LucideIcons.folderCog,
    label: (t) => t.settings.mainTabs.workspaces,
    build: (_) => const WorkspacesSection(),
  ),
  SettingsSection(
    id: 'shortcuts',
    icon: LucideIcons.keyboard,
    label: (t) => t.settings.mainTabs.shortcuts,
    build: (_) => const ShortcutsSection(),
  ),
  SettingsSection(
    id: 'about',
    icon: LucideIcons.info,
    label: (t) => t.settings.mainTabs.about,
    build: (_) => const AboutSection(),
  ),
];

SettingsSection? settingsSectionFor(String? id) {
  for (final s in settingsSections) {
    if (s.id == id) return s;
  }
  return null;
}

const _storageBox = 'settings';
const _storageKey = 'lastSettingsSection';

/// Last opened `/settings/:section` — read by the router's `/settings`
/// redirect. Falls back to the first section when nothing (valid) is stored
/// or the `settings` Hive box isn't open yet.
String lastSettingsSection() {
  if (Hive.isBoxOpen(_storageBox)) {
    final stored = Hive.box<dynamic>(_storageBox).get(_storageKey);
    if (stored is String && settingsSectionFor(stored) != null) {
      return stored;
    }
  }
  return settingsSections.first.id;
}

void saveLastSettingsSection(String id) {
  if (Hive.isBoxOpen(_storageBox)) {
    unawaited(Hive.box<dynamic>(_storageBox).put(_storageKey, id));
  }
}

/// Settings shell (port of `Settings.tsx` + `SettingsSidebar.tsx`): section
/// navigation as a left rail on medium+ widths, horizontal pills on compact —
/// the same adaptive split `QuotaScreen` uses. Mounted at `/settings/:section`.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, required this.section});

  /// Active section id — the router already validated it against
  /// [settingsSectionFor] (unknown ids redirect to `/settings`).
  final String section;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    saveLastSettingsSection(widget.section);
  }

  @override
  void didUpdateWidget(SettingsScreen old) {
    super.didUpdateWidget(old);
    if (old.section != widget.section) saveLastSettingsSection(widget.section);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final compact = context.breakpoint.isCompact;
    final active = settingsSectionFor(widget.section) ?? settingsSections.first;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SubpageHeader(
              icon: LucideIcons.settings,
              title: t.settings.mainTabs.label,
              trailing: const [LogoutButton()],
            ),
            // Section nav — pill bar on compact, side rail otherwise.
            if (compact)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
                child: Row(
                  children: [
                    for (final s in settingsSections)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: ChoiceChip(
                          avatar: Icon(s.icon, size: 14),
                          label: Text(s.label(t)),
                          selected: active.id == s.id,
                          onSelected: (_) => context.go('/settings/${s.id}'),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!compact)
                    Container(
                      width: 224,
                      decoration: BoxDecoration(
                        color: c.muted.withValues(alpha: 0.3),
                        border: Border(right: BorderSide(color: c.border.withValues(alpha: 0.6))),
                      ),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ListView(
                        children: [
                          for (final s in settingsSections) _navItem(s, active: s.id == active.id),
                        ],
                      ),
                    ),
                  Expanded(child: active.build(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(SettingsSection s, {required bool active}) {
    final c = context.appColors;
    final t = Translations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: InkWell(
        borderRadius: AppRadii.borderMd,
        onTap: () => context.go('/settings/${s.id}'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
          decoration: BoxDecoration(
            color: active ? c.accent : null,
            borderRadius: AppRadii.borderLg,
          ),
          child: Row(
            children: [
              Icon(s.icon, size: 16, color: active ? c.foreground : c.mutedForeground),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  s.label(t),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: active ? FontWeight.w600 : null,
                    color: active ? c.foreground : c.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

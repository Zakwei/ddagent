import 'dart:async';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/subpage_header.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/features/chat/view/model_library_panel.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/view/sections/about_section.dart';
import 'package:ddagent_app/features/settings/view/sections/agents_section.dart';
import 'package:ddagent_app/features/settings/view/sections/api_section.dart';
import 'package:ddagent_app/features/settings/view/sections/appearance_section.dart';
import 'package:ddagent_app/features/settings/view/sections/browser_section.dart';
import 'package:ddagent_app/features/settings/view/sections/git_section.dart';
import 'package:ddagent_app/features/settings/view/sections/notifications_section.dart';
import 'package:ddagent_app/features/settings/view/sections/orchestration_section.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/settings/view/sections/shortcuts_section.dart';
import 'package:ddagent_app/features/settings/view/sections/tasks_section.dart';
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
/// (src/components/settings/types/types.ts). The old `SettingsSidebar` has no
/// entry for `schedules`; it keeps its union position here and deep-links to
/// the standalone `/scheduler` screen, same as `quota` → `/quota`.
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
  // Web `SettingsMainTab` order — 'models' follows 'apiTokens'.
  SettingsSection(
    id: 'models',
    icon: LucideIcons.boxes,
    label: (t) => t.settings.mainTabs.models,
    build: (_) => const ModelLibraryPanel(),
  ),
  SettingsSection(
    id: 'tasks',
    icon: LucideIcons.listChecks,
    label: (t) => t.settings.mainTabs.tasks,
    build: (_) => const TasksSection(),
  ),
  SettingsSection(
    id: 'browser',
    icon: LucideIcons.monitorPlay,
    label: (t) => t.settings.mainTabs.browser,
    build: (_) => const BrowserSection(),
  ),
  SettingsSection(
    id: 'notifications',
    icon: LucideIcons.bell,
    label: (t) => t.settings.mainTabs.notifications,
    build: (_) => const NotificationsSection(),
  ),
  SettingsSection(
    id: 'quota',
    icon: LucideIcons.gauge,
    label: (t) => t.settings.mainTabs.quota,
    build: (_) => _LinkedSection(
      'quota',
      '/quota',
      // No dedicated key — literal is fine per project i18n convention.
      (_) =>
          'Usage limits, account quotas and the agent fleet live in the '
          'AI Control Center.',
    ),
  ),
  SettingsSection(
    id: 'workspaces',
    icon: LucideIcons.folderCog,
    label: (t) => t.settings.mainTabs.workspaces,
    build: (_) => const WorkspacesSection(),
  ),
  SettingsSection(
    id: 'schedules',
    icon: LucideIcons.calendarClock,
    label: (t) => t.settings.schedules.title,
    build: (_) => _LinkedSection(
      'schedules',
      '/scheduler',
      (t) => t.settings.schedules.description,
      // Web SchedulesSettingsTab row — the only pref living on that tab.
      const _PreventSleepToggle(),
    ),
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

/// Body for sections that already exist as standalone screens — link card
/// instead of nesting a second Scaffold inside the settings shell.
class _LinkedSection extends StatelessWidget {
  const _LinkedSection(this.id, this.route, [this.description, this.extra]);

  final String id;
  final String route;
  final String Function(Translations t)? description;

  /// Optional content between the description and the open-link button.
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final s = settingsSectionFor(id)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(s.icon, size: 28, color: c.mutedForeground),
            const SizedBox(height: AppSpacing.sm),
            Text(s.label(t), style: tt.titleMedium),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description!(t),
                textAlign: TextAlign.center,
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
            ],
            if (extra != null) ...[const SizedBox(height: AppSpacing.md), extra!],
            const SizedBox(height: AppSpacing.md),
            AppButton(
              variant: AppButtonVariant.outline,
              size: AppButtonSize.sm,
              onPressed: () => context.go(route),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [Icon(LucideIcons.arrowRight, size: 14), Text('Open')],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// `preventSleep` toggle — the only pref on the web SchedulesSettingsTab
/// (keeps display awake while agents run). Consumers live in
/// `AdaptiveScaffold` (wakelock sync).
class _PreventSleepToggle extends ConsumerWidget {
  const _PreventSleepToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final prefs = ref.watch(uiPreferencesProvider);
    return SettingsRow(
      label: t.settings.schedules.preventSleep,
      description: t.settings.schedules.preventSleepHint,
      child: Switch(
        value: prefs.preventSleep,
        onChanged: (v) =>
            ref.read(uiPreferencesProvider.notifier).update((p) => p.copyWith(preventSleep: v)),
      ),
    );
  }
}

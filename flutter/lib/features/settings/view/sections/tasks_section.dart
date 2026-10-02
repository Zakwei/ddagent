import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/taskmaster/state/tasks_settings_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tasks section — port of `tasks-settings/TasksSettingsTab.tsx`:
/// TaskMaster installation-status check (spinner → warning card or the
/// global `tasks-enabled` toggle). `isReady`/`installationStatus` details
/// beyond installed/not-installed are not surfaced by the web tab either.
class TasksSection extends ConsumerWidget {
  const TasksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final install = ref.watch(taskmasterInstallStatusProvider);
    final tasksEnabled = ref.watch(tasksEnabledProvider);
    final tasks = t.settings.tasks;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: t.settings.mainTabs.tasks,
          children: [
            install.when(
              loading: () => AppCard(
                child: Row(
                  spacing: AppSpacing.md,
                  children: [
                    const AppSpinner(),
                    Text(tasks.checking, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              error: (e, _) => const _TaskmasterNotInstalled(),
              data: (config) => config.isInstalled
                  ? AppCard(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.xs,
                      ),
                      child: SettingsRow(
                        label: tasks.settings.enableLabel,
                        description: tasks.settings.enableDescription,
                        child: Switch(
                          value: tasksEnabled,
                          onChanged: (v) =>
                              unawaited(ref.read(tasksEnabledProvider.notifier).set(v)),
                        ),
                      ),
                    )
                  : const _TaskmasterNotInstalled(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Orange "TaskMaster CLI not installed" card — install command, GitHub
/// link, post-install steps (1:1 with the web warning block).
class _TaskmasterNotInstalled extends StatelessWidget {
  const _TaskmasterNotInstalled();

  static const _orange = Color(0xFFEA580C);

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.tasks.notInstalled;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: _orange.withValues(alpha: 0.08),
        border: Border.all(color: _orange.withValues(alpha: 0.3)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSpacing.md,
        children: [
          Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.only(top: 2),
            decoration: BoxDecoration(
              color: _orange.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.triangleAlert, size: 16, color: _orange),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: tt.titleSmall?.copyWith(color: _orange)),
                const SizedBox(height: AppSpacing.sm),
                Text(t.description, style: tt.bodySmall),
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: _orange.withValues(alpha: 0.12),
                    borderRadius: AppRadii.borderMd,
                  ),
                  child: Text(
                    t.installCommand,
                    style: tt.bodySmall?.copyWith(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () => unawaited(
                    launchUrl(
                      Uri.parse('https://github.com/eyaltoledano/claude-task-master'),
                      mode: LaunchMode.externalApplication,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      const Icon(LucideIcons.gitBranch, size: 14, color: Colors.blue),
                      Text(
                        t.viewOnGitHub,
                        style: tt.bodySmall?.copyWith(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(LucideIcons.externalLink, size: 12, color: Colors.blue),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  t.afterInstallation,
                  style: tt.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                for (final (i, step) in [
                  t.steps.restart,
                  t.steps.autoAvailable,
                  t.steps.initCommand,
                ].indexed)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text('${i + 1}. $step', style: tt.labelSmall?.copyWith(color: _orange)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

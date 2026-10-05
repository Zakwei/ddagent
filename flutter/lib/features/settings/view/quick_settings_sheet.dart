import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/ui/language_picker.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Port of `QuickSettingsPanel` — the web app's edge-handle slide-over with
/// dark mode, language, and the uiPreferences toggles. Surfaced here as a
/// dialog from the rail / nav drawer (the mobile drawer has no edge handle).
Future<void> showQuickSettings(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const QuickSettingsDialog());

class QuickSettingsDialog extends ConsumerWidget {
  const QuickSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Translations.of(context);
    final prefs = ref.watch(uiPreferencesProvider);
    final mode = ref.watch(themeModeProvider);
    final notifier = ref.read(uiPreferencesProvider.notifier);

    return Dialog(
      backgroundColor: c.card,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.borderLg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Quick settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 16),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              _Section(
                title: t.settings.tabs.appearance,
                children: [
                  _ToggleRow(
                    label: t.common.common.darkMode,
                    icon: mode == ThemeMode.dark ? LucideIcons.moon : LucideIcons.sun,
                    value: mode == ThemeMode.dark,
                    onChanged: (v) => ref
                        .read(themeModeProvider.notifier)
                        .set(v ? ThemeMode.dark : ThemeMode.light),
                  ),
                  const SizedBox(height: 8),
                  const Align(alignment: Alignment.centerLeft, child: LanguagePicker()),
                ],
              ),
              _Section(
                title: t.settings.quickSettings.sections.toolDisplay,
                children: [
                  _ToggleRow(
                    label: t.settings.quickSettings.showRawParameters,
                    icon: LucideIcons.eye,
                    value: prefs.showRawParameters,
                    onChanged: (v) => notifier.update((p) => p.copyWith(showRawParameters: v)),
                  ),
                  _ToggleRow(
                    label: t.settings.quickSettings.showThinking,
                    icon: LucideIcons.brain,
                    value: prefs.showThinking,
                    onChanged: (v) => notifier.update((p) => p.copyWith(showThinking: v)),
                  ),
                ],
              ),
              _Section(
                title: t.settings.quickSettings.sections.inputSettings,
                children: [
                  _ToggleRow(
                    label: t.settings.quickSettings.sendWithCtrlEnter,
                    icon: LucideIcons.languages,
                    value: prefs.sendByCtrlEnter,
                    onChanged: (v) => notifier.update((p) => p.copyWith(sendByCtrlEnter: v)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      'When off, Enter sends and Shift+Enter inserts a newline.',
                      style: TextStyle(fontSize: 12, color: c.mutedForeground),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: c.mutedForeground,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: c.muted.withValues(alpha: 0.6),
      borderRadius: AppRadii.borderLg,
      child: InkWell(
        onTap: () => onChanged(!value),
        borderRadius: AppRadii.borderLg,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 16, color: c.mutedForeground),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

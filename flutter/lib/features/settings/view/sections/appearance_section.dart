import 'package:ddagent_app/core/theme/theme_controller.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/settings/ui/language_picker.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/voice/view/auto_read_voice_picker.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Appearance section — port of `AppearanceSettingsTab.tsx`: theme, language,
/// read-aloud voice, focus-follows-pointer, code-editor prefs. All controls
/// bind to persisted controllers (Hive `settings` box).
class AppearanceSection extends ConsumerWidget {
  const AppearanceSection({super.key});

  /// Web font-size select options (`10px`–`20px`).
  static const _fontSizes = [10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0, 18.0, 20.0];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final mode = ref.watch(themeModeProvider);
    final editor = ref.watch(editorSettingsProvider);
    final prefs = ref.watch(uiPreferencesProvider);
    final appearance = t.settings.appearanceSettings;

    Widget card(List<Widget> rows, {bool divided = false}) => AppCard(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (divided && i > 0) Divider(height: 1, color: c.border),
            rows[i],
          ],
        ],
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: appearance.darkMode.label,
          children: [
            card([
              SettingsRow(
                label: appearance.darkMode.label,
                description: appearance.darkMode.description,
                child: SegmentedButton<ThemeMode>(
                  showSelectedIcon: false,
                  segments: [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text(t.settings.appearance.themeModes.system),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text(t.settings.appearance.themeModes.light),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text(t.settings.appearance.themeModes.dark),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (s) => ref.read(themeModeProvider.notifier).set(s.first),
                ),
              ),
            ]),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: t.settings.mainTabs.appearance,
          children: [
            card([SettingsRow(label: t.settings.account.language, child: const LanguagePicker())]),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: t.chat.voice.autoRead,
          children: [
            card([
              SettingsRow(label: t.chat.voice.autoReadVoice, child: const AutoReadVoicePicker()),
            ]),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: appearance.terminal.title,
          children: [
            card([
              SettingsRow(
                label: appearance.terminal.focusFollowsPointer.label,
                description: appearance.terminal.focusFollowsPointer.description,
                child: Switch(
                  value: prefs.focusFollowsPointer,
                  onChanged: (v) =>
                      ref.read(uiPreferencesProvider.notifier).setFocusFollowsPointer(v),
                ),
              ),
            ]),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: appearance.codeEditor.title,
          children: [
            card(divided: true, [
              SettingsRow(
                label: appearance.codeEditor.wordWrap.label,
                description: appearance.codeEditor.wordWrap.description,
                child: Switch(
                  value: editor.wordWrap,
                  onChanged: (v) => ref.read(editorSettingsProvider.notifier).setWordWrap(v),
                ),
              ),
              SettingsRow(
                label: appearance.codeEditor.showMinimap.label,
                description: appearance.codeEditor.showMinimap.description,
                child: Switch(
                  value: editor.minimap,
                  onChanged: (_) => ref.read(editorSettingsProvider.notifier).toggleMinimap(),
                ),
              ),
              // Web also has a line-numbers toggle; the Flutter
              // EditorSettings/gutter don't support it yet — skipped.
              SettingsRow(
                label: appearance.codeEditor.fontSize.label,
                description: appearance.codeEditor.fontSize.description,
                child: DropdownButton<double>(
                  value: _fontSizes.contains(editor.fontSize) ? editor.fontSize : 13.0,
                  underline: const SizedBox.shrink(),
                  items: [
                    for (final size in _fontSizes)
                      DropdownMenuItem(value: size, child: Text('${size.toInt()}px')),
                  ],
                  onChanged: (v) {
                    if (v != null) {
                      ref.read(editorSettingsProvider.notifier).setFontSize(v);
                    }
                  },
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}

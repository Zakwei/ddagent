import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/theme/typography.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

/// Keyboard shortcuts reference — every binding in the app, split into
/// Windows/Linux and macOS columns (modifier chords differ, the actions
/// don't). Keep in sync with adaptive_scaffold's `_globalKey`, the
/// composer/terminal/editor keymaps.
class ShortcutsSection extends StatelessWidget {
  const ShortcutsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.shortcuts;
    final groups = <(String, List<(String, List<String>, List<String>)>)>[
      (
        t.navigation,
        [
          (t.navWorkspace, const ['Alt+1'], const ['⌥1']),
          (t.navTasks, const ['Alt+2'], const ['⌥2']),
          (t.navGit, const ['Alt+3'], const ['⌥3']),
          (t.navFocus, const ['Ctrl+Shift+F'], const ['⌘⇧F']),
          (t.navSwitcher, const ['Ctrl+K'], const ['⌘K']),
          (t.navPalette, const ['Ctrl+Shift+K'], const ['⌘⇧K']),
          (t.navSettings, const ['Ctrl+,'], const ['⌘,']),
          (t.navClose, const ['Esc'], const ['Esc']),
        ],
      ),
      (
        t.composer,
        [
          (t.compSend, const ['Enter', 'Ctrl+Enter'], const ['Enter', '⌘Enter']),
          (t.compNewline, const ['Shift+Enter'], const ['⇧Enter']),
          (t.compNav, const ['↑ ↓'], const ['↑ ↓']),
          (t.compAccept, const ['Tab', 'Enter'], const ['Tab', 'Enter']),
          (t.compCloseSuggest, const ['Esc'], const ['Esc']),
        ],
      ),
      (
        t.transcript,
        [
          (t.trCopy, const ['Ctrl+C'], const ['⌘C']),
          (t.trClose, const ['Esc'], const ['Esc']),
        ],
      ),
      (
        t.terminal,
        [
          (t.termCopy, const ['Ctrl+C', 'Ctrl+Shift+C'], const ['⌘C']),
          (t.termInterrupt, const ['Ctrl+C'], const ['⌃C']),
          (t.termPaste, const ['Ctrl+V', 'Shift+Ins'], const ['⌘V']),
          (t.termSelectAll, const ['Ctrl+A'], const ['⌘A']),
        ],
      ),
      (
        t.editor,
        [
          (t.edSave, const ['Ctrl+S'], const ['⌘S']),
          (t.edSaveAll, const ['Ctrl+Shift+S'], const ['⌘⇧S']),
          (t.edClose, const ['Ctrl+W'], const ['⌘W']),
          (t.edNextTab, const ['Ctrl+Tab', 'Ctrl+PgDn'], const ['⌃Tab', '⌃⇟']),
          (t.edPrevTab, const ['Ctrl+Shift+Tab', 'Ctrl+PgUp'], const ['⌃⇧Tab', '⌃⇞']),
          (t.edIndent, const ['Tab', 'Shift+Tab'], const ['Tab', '⇧Tab']),
        ],
      ),
      (
        t.palette,
        [
          (t.palNav, const ['↑ ↓'], const ['↑ ↓']),
          (t.palRun, const ['Enter'], const ['Enter']),
          (t.palBack, const ['Backspace'], const ['Backspace']),
          (t.palClose, const ['Esc'], const ['Esc']),
        ],
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final (title, rows) in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: SettingsSectionBlock(
              title: title,
              description: title == t.navigation ? t.description : null,
              children: [
                AppCard(
                  child: Column(
                    children: [
                      if (title == t.navigation)
                        _HeaderRow(action: t.action, win: t.winLinux, mac: t.mac),
                      for (final (label, win, mac) in rows)
                        _ShortcutRow(label: label, win: win, mac: mac),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.action, required this.win, required this.mac});

  final String action;
  final String win;
  final String mac;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final style = tt.labelSmall?.copyWith(color: c.mutedForeground);
    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
      ),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(action, style: style)),
          Expanded(flex: 4, child: Text(win, style: style)),
          Expanded(flex: 3, child: Text(mac, style: style)),
        ],
      ),
    );
  }
}

class _ShortcutRow extends StatelessWidget {
  const _ShortcutRow({required this.label, required this.win, required this.mac});

  final String label;
  final List<String> win;
  final List<String> mac;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(flex: 5, child: Text(label, style: tt.bodySmall)),
          Expanded(
            flex: 4,
            child: Wrap(spacing: 4, runSpacing: 4, children: [for (final k in win) _KeyChip(k)]),
          ),
          Expanded(
            flex: 3,
            child: Wrap(spacing: 4, runSpacing: 4, children: [for (final k in mac) _KeyChip(k)]),
          ),
        ],
      ),
    );
  }
}

class _KeyChip extends StatelessWidget {
  const _KeyChip(this.keyLabel);

  final String keyLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.4),
        border: Border.all(color: c.border),
        borderRadius: AppRadii.borderSm,
      ),
      child: Text(
        keyLabel,
        style: TextStyle(fontFamilyFallback: AppFonts.mono, fontSize: 11, color: c.foreground),
      ),
    );
  }
}

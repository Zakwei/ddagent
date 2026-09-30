import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/features/user/data/user_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Git section — port of `GitSettingsTab.tsx` + `useGitSettings.ts`:
/// gitName/gitEmail form backed by GET/POST `/api/user/git-config`
/// (`user_repository.dart`), with the same transient save-status feedback.
class GitSection extends ConsumerStatefulWidget {
  const GitSection({super.key});

  @override
  ConsumerState<GitSection> createState() => _GitSectionState();
}

enum _SaveStatus { success, error }

class _GitSectionState extends ConsumerState<GitSection> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  _SaveStatus? _status;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final cfg = await ref.read(userRepositoryProvider).gitConfig();
      if (!mounted) return;
      _name.text = cfg.gitName ?? '';
      _email.text = cfg.gitEmail ?? '';
    } on AppError {
      // Unreachable server shows the empty form — same as the web tab.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _status = null;
    });
    try {
      await ref
          .read(userRepositoryProvider)
          .updateGitConfig(
            gitName: _name.text.trim(),
            gitEmail: _email.text.trim(),
          );
      _setStatus(_SaveStatus.success);
    } on AppError {
      _setStatus(_SaveStatus.error);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  /// Web parity: the status line clears itself after 3 seconds.
  void _setStatus(_SaveStatus status) {
    _statusTimer?.cancel();
    _statusTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _status = null);
    });
    if (mounted) setState(() => _status = status);
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final git = t.settings.git;
    final canSave =
        !_loading &&
        !_saving &&
        _name.text.trim().isNotEmpty &&
        _email.text.trim().isNotEmpty;

    Widget field({
      required String label,
      required String help,
      required TextEditingController controller,
      required String placeholder,
      TextInputType? keyboardType,
    }) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppSpacing.sm),
        AppInput(
          controller: controller,
          hint: placeholder,
          enabled: !_loading,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(help, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
      ],
    );

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: git.title,
          description: git.description,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  field(
                    label: git.name.label,
                    help: git.name.help,
                    controller: _name,
                    placeholder: 'John Doe',
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  field(
                    label: git.email.label,
                    help: git.email.help,
                    controller: _email,
                    placeholder: 'john@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      AppButton(
                        loading: _saving,
                        onPressed: canSave ? _save : null,
                        child: Text(
                          _saving ? git.actions.saving : git.actions.save,
                        ),
                      ),
                      if (_status == _SaveStatus.success) ...[
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(
                          LucideIcons.check,
                          size: 16,
                          color: Colors.green,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          git.status.success,
                          style: tt.bodySmall?.copyWith(color: Colors.green),
                        ),
                      ],
                      if (_status == _SaveStatus.error) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          LucideIcons.circleAlert,
                          size: 16,
                          color: c.destructive,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          git.status.error,
                          style: tt.bodySmall?.copyWith(color: c.destructive),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

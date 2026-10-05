import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Checkpoints management dialog (port of the web CheckpointsModal): list of
/// saved working-tree checkpoints with restore + a create-with-label row.
class CheckpointsDialog extends ConsumerStatefulWidget {
  const CheckpointsDialog({super.key});

  @override
  ConsumerState<CheckpointsDialog> createState() => _CheckpointsDialogState();
}

class _CheckpointsDialogState extends ConsumerState<CheckpointsDialog> {
  final _label = TextEditingController();

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  String _fmtDate(String iso) {
    final d = DateTime.tryParse(iso);
    if (d == null) return iso;
    final l = d.toLocal();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${l.year}-${two(l.month)}-${two(l.day)} ${two(l.hour)}:${two(l.minute)}';
  }

  Future<void> _restore(BuildContext context, String cpRef) async {
    final i18n = Translations.of(context);
    final ok = await AppDialog.confirm(
      context,
      title: i18n.git.checkpoints.restoreTitle,
      message: i18n.git.checkpoints.restoreMessage,
      confirmLabel: i18n.chat.sessionPicker.restore,
    );
    if (!ok || !context.mounted) return;
    final done = await ref.read(gitProvider.notifier).restoreCheckpoint(cpRef);
    if (!context.mounted) return;
    if (done) {
      AppToast.show(context, i18n.git.checkpoints.restored);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitProvider);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final checkpoints = state.checkpoints;

    return AppDialog(
      title: i18n.git.checkpoints.title,
      content: SizedBox(
        width: 440,
        height: 360,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInput(controller: _label, hint: i18n.git.checkpoints.labelHint),
                ),
                const SizedBox(width: AppSpacing.sm),
                AppButton(
                  size: AppButtonSize.sm,
                  loading: state.busy,
                  onPressed: () async {
                    final ok = await ref
                        .read(gitProvider.notifier)
                        .createCheckpoint(
                          label: _label.text.trim().isEmpty ? null : _label.text.trim(),
                        );
                    if (ok && mounted) _label.clear();
                  },
                  child: Text(i18n.git.checkpoints.create),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Expanded(
              child: checkpoints.isEmpty
                  ? Center(
                      child: Text(
                        i18n.git.checkpoints.empty,
                        style: t.bodySmall?.copyWith(color: c.mutedForeground),
                      ),
                    )
                  : ListView.separated(
                      itemCount: checkpoints.length,
                      separatorBuilder: (_, _) => Divider(height: 1, color: c.border),
                      itemBuilder: (context, i) {
                        final cp = checkpoints[i];
                        final title = cp.label.isNotEmpty
                            ? cp.label
                            : cp.ref.isNotEmpty
                            ? cp.ref
                            : cp.commit;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.bodySmall,
                                    ),
                                    Text(
                                      [
                                        if (cp.commit.isNotEmpty)
                                          cp.commit.length > 7
                                              ? cp.commit.substring(0, 7)
                                              : cp.commit,
                                        if (cp.createdAt != null) _fmtDate(cp.createdAt!),
                                      ].join(' · '),
                                      style: t.labelSmall?.copyWith(
                                        color: c.mutedForeground,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppButton(
                                variant: AppButtonVariant.ghost,
                                size: AppButtonSize.sm,
                                onPressed: state.busy
                                    ? null
                                    : () => unawaited(_restore(context, cp.ref)),
                                child: Text(i18n.chat.sessionPicker.restore),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.chat.common.close),
        ),
      ],
    );
  }
}

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Git destructive-action kinds — mirrors the web `ConfirmActionType` keys so
/// titles/labels/button colors line up with CONFIRMATION_* constants.
enum GitConfirmType { discard, delete, commit, pull, push, publish, revert, deleteBranch }

/// Optional second, more destructive choice rendered as a checkbox card —
/// web `alternateConfirmation` (e.g. force-delete an unmerged branch).
class GitAlternate {
  const GitAlternate({required this.label, required this.description, required this.actionLabel});

  final String label;
  final String description;
  final String actionLabel;
}

/// Result of [gitConfirm]: null = cancelled, false = normal confirm,
/// true = the checked alternate action (force delete etc).
Future<bool?> gitConfirm(
  BuildContext context, {
  required GitConfirmType type,
  required String message,
  GitAlternate? alternate,
}) {
  var useAlternate = false;
  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final c = ctx.appColors;
        final (icon, tint, btnColor) = switch (type) {
          GitConfirmType.discard ||
          GitConfirmType.delete ||
          GitConfirmType.deleteBranch => (LucideIcons.trash2, c.destructive, c.destructive),
          GitConfirmType.pull => (
            LucideIcons.download,
            const Color(0xFFCA8A04),
            const Color(0xFF16A34A),
          ),
          GitConfirmType.push => (
            LucideIcons.upload,
            const Color(0xFFCA8A04),
            const Color(0xFFEA580C),
          ),
          GitConfirmType.publish => (
            LucideIcons.upload,
            const Color(0xFFCA8A04),
            const Color(0xFF9333EA),
          ),
          GitConfirmType.revert => (
            LucideIcons.rotateCcw,
            const Color(0xFFCA8A04),
            const Color(0xFFCA8A04),
          ),
          GitConfirmType.commit => (LucideIcons.check, const Color(0xFFCA8A04), c.primary),
        };
        final title = switch (type) {
          GitConfirmType.discard => 'Discard Changes',
          GitConfirmType.delete => 'Delete File',
          GitConfirmType.commit => 'Confirm Action',
          GitConfirmType.pull => 'Confirm Pull',
          GitConfirmType.push => 'Confirm Push',
          GitConfirmType.publish => 'Publish Branch',
          GitConfirmType.revert => 'Revert Local Commit',
          GitConfirmType.deleteBranch => 'Delete Branch',
        };
        final actionLabel = switch (type) {
          GitConfirmType.discard => 'Discard',
          GitConfirmType.delete => 'Delete',
          GitConfirmType.commit => 'Confirm',
          GitConfirmType.pull => 'Pull',
          GitConfirmType.push => 'Push',
          GitConfirmType.publish => 'Publish',
          GitConfirmType.revert => 'Revert Commit',
          GitConfirmType.deleteBranch => 'Delete',
        };

        return AppDialog(
          title: title,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: tint.withValues(alpha: 0.15),
                    ),
                    child: Icon(icon, size: 16, color: tint),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  // `whitespace-pre-wrap` parity — commit messages and file
                  // lists keep their blank lines; long paths wrap.
                  Expanded(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 300),
                      child: SingleChildScrollView(
                          child: SelectableText(
                            message,
                            style: Theme.of(ctx).textTheme.bodyMedium
                                ?.copyWith(color: c.mutedForeground),
                          ),
                        ),
                    ),
                  ),
                ],
              ),
              if (alternate != null) ...[
                const SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () => setState(() => useAlternate = !useAlternate),
                  borderRadius: AppRadii.borderMd,
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      border: Border.all(color: c.destructive.withValues(alpha: 0.3)),
                      borderRadius: AppRadii.borderMd,
                      color: c.destructive.withValues(alpha: 0.05),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: Checkbox(
                            value: useAlternate,
                            onChanged: (v) => setState(() => useAlternate = v ?? false),
                            activeColor: c.destructive,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(LucideIcons.triangleAlert, size: 14, color: c.destructive),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      alternate.label,
                                      style: Theme.of(ctx).textTheme.bodyMedium
                                          ?.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                alternate.description,
                                style: Theme.of(ctx).textTheme.bodySmall
                                    ?.copyWith(color: c.mutedForeground),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            AppButton(
              variant: AppButtonVariant.ghost,
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            // Per-action color (pull=green, push=orange, destructive=red…)
            // — AppButton variants don't cover these, so style directly.
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: btnColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.sm,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(borderRadius: AppRadii.borderMd),
              ),
              onPressed: () => Navigator.of(ctx).pop(useAlternate),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14),
                  const SizedBox(width: 6),
                  Text(useAlternate && alternate != null ? alternate.actionLabel : actionLabel),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

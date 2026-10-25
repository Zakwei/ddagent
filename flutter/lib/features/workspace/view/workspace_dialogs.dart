import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/state/workspace_controller.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One tile in the overview grid — title/subtitle/action already resolved
/// through `splitPaneDisplay` by the caller.
class OverviewPaneInfo {
  const OverviewPaneInfo({
    required this.pane,
    required this.title,
    this.subtitle,
    this.action = PaneAction.idle,
    this.finished = false,
  });

  final SplitPane pane;
  final String title;
  final String? subtitle;
  final PaneAction action;

  /// A terminal tab of the pane rang the bell (an agent finished its turn)
  /// since the user last looked — shown unless a question outranks it.
  final bool finished;
}

/// Split panes overview (port of SplitOverviewDialog.tsx): grid of pane
/// cards with kind icon, title, subtitle and action badge; tap activates
/// the pane and closes. [panes] watches its sources so the badges follow the
/// agents live while the dialog stays open.
class SplitOverviewDialog extends ConsumerWidget {
  const SplitOverviewDialog({super.key, required this.panes, required this.onSelectPane});

  final List<OverviewPaneInfo> Function(WidgetRef ref) panes;
  final ValueChanged<String> onSelectPane;

  /// Emerald — the compact pane strip's "finished" tab.
  static const _finishedColor = Color(0xFF10B981);

  static Future<void> show(
    BuildContext context, {
    required List<OverviewPaneInfo> Function(WidgetRef ref) panes,
    required ValueChanged<String> onSelectPane,
  }) => showDialog<void>(
    context: context,
    builder: (_) => SplitOverviewDialog(panes: panes, onSelectPane: onSelectPane),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panes = this.panes(ref);
    final activePaneId = ref.watch(workspaceProvider).activePaneId;
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    final c = context.appColors;
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(i18n.chat.splitOverview.title, style: t.textTheme.titleSmall),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    i18n.chat.splitOverview.count(count: panes.length),
                    style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: i18n.chat.splitOverview.close,
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(AppSpacing.lg),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 240,
                  mainAxisExtent: 140,
                  crossAxisSpacing: AppSpacing.md,
                  mainAxisSpacing: AppSpacing.md,
                ),
                itemCount: panes.length,
                itemBuilder: (context, i) {
                  final info = panes[i];
                  final isActive = info.pane.id == activePaneId;
                  final (border, bg) = switch (info.action) {
                    PaneAction.question => (
                      const Color(0xFFF59E0B),
                      const Color(0xFFF59E0B).withValues(alpha: 0.05),
                    ),
                    PaneAction.idle when info.finished => (
                      _finishedColor,
                      _finishedColor.withValues(alpha: 0.05),
                    ),
                    PaneAction.idle => (c.border, c.card),
                  };
                  return InkWell(
                    borderRadius: AppRadii.borderLg,
                    onTap: () {
                      onSelectPane(info.pane.id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: AppRadii.borderLg,
                        border: Border.all(
                          color: isActive ? c.primary : border,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                paneKindIcon(info.pane.kind),
                                size: 16,
                                color: c.mutedForeground,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Text(
                                paneKindLabel(info.pane.kind).toUpperCase(),
                                style: t.textTheme.labelSmall?.copyWith(
                                  color: c.mutedForeground,
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const Spacer(),
                              if (isActive)
                                Text(
                                  i18n.chat.splitOverview.active.toUpperCase(),
                                  style: t.textTheme.labelSmall?.copyWith(
                                    color: c.primary,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            info.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: t.textTheme.titleMedium,
                          ),
                          if (info.subtitle != null)
                            Text(
                              info.subtitle!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: t.textTheme.labelSmall?.copyWith(color: c.mutedForeground),
                            ),
                          const Spacer(),
                          SizedBox(
                            height: 18,
                            child: switch (info.action) {
                              PaneAction.question => Row(
                                children: [
                                  const Icon(
                                    Icons.warning_amber_rounded,
                                    size: 14,
                                    color: Color(0xFFF59E0B),
                                  ),
                                  const SizedBox(width: 4),
                                  // Phone tiles are ~150px wide.
                                  Flexible(
                                    child: Text(
                                      i18n.chat.splitOverview.question,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.textTheme.labelSmall?.copyWith(
                                        color: const Color(0xFFF59E0B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PaneAction.idle when info.finished => Row(
                                children: [
                                  const Icon(Icons.check_circle, size: 14, color: _finishedColor),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      i18n.chat.sessionPicker.unread,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.textTheme.labelSmall?.copyWith(
                                        color: _finishedColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              PaneAction.idle => const SizedBox.shrink(),
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

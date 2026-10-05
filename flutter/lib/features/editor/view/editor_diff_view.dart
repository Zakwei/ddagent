import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/editor/data/line_diff.dart';
import 'package:ddagent_app/features/editor/state/editor_controller.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Diff/merge view: buffer (right/added) vs git HEAD or — when the project
/// isn't a repo or the fetch fails — the tab's last-saved content (left/
/// removed). Each change hunk can keep the working copy or restore the base
/// line set; [onApply] receives the merged text.
class EditorDiffView extends ConsumerStatefulWidget {
  const EditorDiffView({
    super.key,
    required this.tab,
    this.onApply,
    this.onDiscarded,
    this.onClose,
  });

  final EditorTab tab;

  /// Merged buffer — the screen writes it via `updateContent`.
  final ValueChanged<String>? onApply;

  /// Called after a successful git discard so the screen can reload/close.
  final VoidCallback? onDiscarded;
  final VoidCallback? onClose;

  @override
  ConsumerState<EditorDiffView> createState() => _EditorDiffViewState();
}

class _BaseContent {
  const _BaseContent({
    required this.text,
    required this.fromGit,
    this.isUntracked = false,
    this.isDeleted = false,
  });

  final String text;
  final bool fromGit;
  final bool isUntracked;
  final bool isDeleted;
}

class _EditorDiffViewState extends ConsumerState<EditorDiffView> {
  late Future<_BaseContent> _future = _load();
  final _expandedContexts = <int>{};
  FileDiff? _diff;
  String _diffFor = '';
  bool _busy = false;

  Future<_BaseContent> _load() async {
    try {
      final res = await ref
          .read(gitRepositoryProvider)
          .fileWithDiff(widget.tab.projectId, widget.tab.path);
      return _BaseContent(
        text: (res['oldContent'] ?? '').toString(),
        fromGit: true,
        isUntracked: res['isUntracked'] == true,
        isDeleted: res['isDeleted'] == true,
      );
    } on AppError {
      // Not a git repository / endpoint failure — fall back to the tab's
      // saved baseline so the merge actions still work.
      return _BaseContent(text: widget.tab.savedContent, fromGit: false);
    } on Object {
      return _BaseContent(text: widget.tab.savedContent, fromGit: false);
    }
  }

  FileDiff _diffOf(_BaseContent base) {
    if (_diff == null || _diffFor != widget.tab.content) {
      _diff = computeLineDiff(base.text, widget.tab.content);
      _diffFor = widget.tab.content;
    }
    return _diff!;
  }

  Future<void> _discard(_BaseContent base) async {
    if (!base.fromGit) {
      // No git base — "discard" = revert buffer to last saved.
      widget.onApply?.call(widget.tab.savedContent);
      return;
    }
    final t = Translations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.common.gitPanel.discardChanges),
        content: Text(
          base.isUntracked
              ? 'This untracked file will be deleted.'
              : 'Restore ${widget.tab.name} to its committed state?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.chat.orchestrator.summary.cancelTasks),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: context.appColors.destructive),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(base.isUntracked ? 'Delete' : 'Discard'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(gitRepositoryProvider).discard(widget.tab.projectId, widget.tab.path);
      if (mounted) widget.onDiscarded?.call();
    } on AppError catch (e) {
      if (mounted) AppToast.show(context, e.message, isError: true);
    } on Object catch (e) {
      if (mounted) AppToast.show(context, e.toString(), isError: true);
    }
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return FutureBuilder<_BaseContent>(
      future: _future,
      builder: (context, snap) {
        if (snap.hasError) {
          return _ErrorState(
            message: snap.error.toString(),
            onRetry: () => setState(() => _future = _load()),
          );
        }
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final base = snap.data!;
        final diff = _diffOf(base);
        return Column(
          children: [
            _DiffHeader(base: base, diff: diff, onClose: widget.onClose),
            Expanded(
              child: diff.hasChanges
                  ? ListView(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                      children: [
                        for (var i = 0; i < diff.segments.length; i++) _segment(context, diff, i),
                      ],
                    )
                  : Center(child: Text(t.codeEditor.diff.noChanges)),
            ),
            _DiffFooter(
              busy: _busy,
              hasChanges: diff.hasChanges,
              untracked: base.isUntracked && base.fromGit,
              fallbackMode: !base.fromGit,
              onDiscard: () => _discard(base),
              onApply: diff.hasChanges ? () => widget.onApply?.call(diff.merged()) : null,
            ),
          ],
        );
      },
    );
  }

  Widget _segment(BuildContext context, FileDiff diff, int index) {
    final t = Translations.of(context);
    final seg = diff.segments[index];
    switch (seg) {
      case ContextSegment(:final lines):
        return _ContextRows(
          lines: lines,
          expanded: _expandedContexts.contains(index),
          onExpand: () => setState(() => _expandedContexts.add(index)),
        );
      case ChangeSegment():
        final hunk = diff.changes.indexOf(seg);
        return _ChangeBlock(
          seg: seg,
          label: t.codeEditor.diff.hunk(number: hunk + 1),
          onChoice: (useOld) => setState(() => seg.useOld = useOld),
        );
    }
  }
}

class _DiffHeader extends StatelessWidget {
  const _DiffHeader({required this.base, required this.diff, this.onClose});

  final _BaseContent base;
  final FileDiff diff;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    final label = base.fromGit ? 'HEAD vs working copy' : 'Last saved vs buffer (no git)';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          if (base.isUntracked)
            _Tag(text: 'untracked', color: colors.primary)
          else if (base.isDeleted)
            _Tag(text: t.codeEditor.diff.deletedOnDisk, color: colors.destructive),
          const Spacer(),
          Text(
            '+${diff.addedCount}  −${diff.removedCount}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
          if (onClose != null)
            IconButton(
              tooltip: t.codeEditor.diff.close,
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: AppRadii.borderMd,
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color)),
    );
  }
}

/// Context run — collapsed to 2+2 lines when longer than 8, tap to expand.
class _ContextRows extends StatelessWidget {
  const _ContextRows({required this.lines, required this.expanded, required this.onExpand});

  final List<String> lines;
  final bool expanded;
  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    const keep = 2;
    if (lines.length <= 8 || expanded) {
      return Column(
        children: [for (final l in lines) _DiffLine(kind: _LineKind.context, text: l)],
      );
    }
    return Column(
      children: [
        for (final l in lines.take(keep)) _DiffLine(kind: _LineKind.context, text: l),
        InkWell(
          onTap: onExpand,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 2),
            color: context.appColors.muted.withValues(alpha: 0.3),
            child: Text(
              '⋯ ${lines.length - keep * 2} unchanged lines',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: context.appColors.mutedForeground),
            ),
          ),
        ),
        for (final l in lines.skip(lines.length - keep))
          _DiffLine(kind: _LineKind.context, text: l),
      ],
    );
  }
}

/// One change hunk: pick which side survives, plus the removed/added rows.
class _ChangeBlock extends StatelessWidget {
  const _ChangeBlock({required this.seg, required this.label, required this.onChoice});

  final ChangeSegment seg;
  final String label;
  final ValueChanged<bool> onChoice;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 2),
          color: colors.accent.withValues(alpha: 0.35),
          child: Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.labelSmall),
              const Spacer(),
              _ChoiceChip(
                label: t.codeEditor.diff.base,
                selected: seg.useOld,
                onTap: () => onChoice(true),
              ),
              const SizedBox(width: 4),
              _ChoiceChip(
                label: t.codeEditor.diff.current,
                selected: !seg.useOld,
                onTap: () => onChoice(false),
              ),
            ],
          ),
        ),
        for (final l in seg.removed)
          _DiffLine(kind: _LineKind.removed, text: l, faded: !seg.useOld),
        for (final l in seg.added) _DiffLine(kind: _LineKind.added, text: l, faded: seg.useOld),
      ],
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  const _ChoiceChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.borderMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: selected ? colors.primary : Colors.transparent,
          borderRadius: AppRadii.borderMd,
          border: Border.all(color: selected ? colors.primary : colors.border),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall
              ?.copyWith(color: selected ? colors.primaryForeground : colors.mutedForeground),
        ),
      ),
    );
  }
}

enum _LineKind { context, removed, added }

class _DiffLine extends StatelessWidget {
  const _DiffLine({required this.kind, required this.text, this.faded = false});

  final _LineKind kind;
  final String text;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final (bg, fg, prefix) = switch (kind) {
      _LineKind.context => (Colors.transparent, colors.mutedForeground, ' '),
      _LineKind.removed => (colors.destructive.withValues(alpha: 0.14), colors.destructive, '-'),
      _LineKind.added => (
        const Color(0xFF2EA043).withValues(alpha: 0.14),
        const Color(0xFF2EA043),
        '+',
      ),
    };
    return Container(
      width: double.infinity,
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '$prefix ',
              style: TextStyle(color: fg),
            ),
            TextSpan(text: text),
          ],
        ),
        style: Theme.of(context).textTheme.bodySmall!.copyWith(
          fontFamily: 'monospace',
          fontSize: 12.5,
          color: faded ? colors.mutedForeground : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.clip,
        softWrap: false,
      ),
    );
  }
}

class _DiffFooter extends StatelessWidget {
  const _DiffFooter({
    required this.busy,
    required this.hasChanges,
    required this.untracked,
    required this.fallbackMode,
    this.onDiscard,
    this.onApply,
  });

  final bool busy;
  final bool hasChanges;
  final bool untracked;
  final bool fallbackMode;
  final VoidCallback? onDiscard;
  final VoidCallback? onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final t = Translations.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            variant: AppButtonVariant.destructive,
            size: AppButtonSize.sm,
            loading: busy,
            onPressed: onDiscard,
            child: Text(
              fallbackMode
                  ? 'Revert to saved'
                  : untracked
                  ? 'Delete file'
                  : t.common.gitPanel.discardChanges,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          AppButton(
            size: AppButtonSize.sm,
            onPressed: onApply,
            child: Text(t.codeEditor.diff.applyMerge),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, style: TextStyle(color: context.appColors.destructive)),
          const SizedBox(height: AppSpacing.sm),
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: onRetry,
            child: Text(t.chat.session.messages.retry),
          ),
        ],
      ),
    );
  }
}

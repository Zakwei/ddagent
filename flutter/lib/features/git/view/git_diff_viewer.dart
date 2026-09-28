import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Port of shared/GitDiffViewer.tsx — unified or side-by-side unified-diff
/// rendering with optional per-hunk staging actions. Hunk numbering follows
/// `@@` header order, matching the server's patch builder.
enum GitDiffViewMode { unified, split }

/// Stage/unstage button shown on each `@@` hunk header row.
class GitDiffHunkAction {
  const GitDiffHunkAction({
    required this.isAdd,
    required this.tooltip,
    required this.onAction,
  });

  /// true → "+ Hunk" (stage), false → "− Hunk" (unstage).
  final bool isAdd;
  final String tooltip;
  final ValueChanged<int> onAction;
}

const _charLimit = 200000;
const _lineLimit = 1500;

/// A row of the side-by-side view. Header rows (hunk/file markers) span both
/// columns; content rows carry left (removed/context) and right
/// (added/context) cells — either can be empty for unpaired lines.
sealed class SplitDiffRow {
  const SplitDiffRow();
}

class SplitHeaderRow extends SplitDiffRow {
  const SplitHeaderRow(this.text);
  final String text;
}

class SplitContentRow extends SplitDiffRow {
  const SplitContentRow({this.left, this.right});
  final String? left; // removed or context
  final String? right; // added or context
}

const _splitHeaderPrefixes = [
  'diff ',
  'index ',
  '--- ',
  '+++ ',
  '@@',
  'new file',
  'deleted file',
  'similarity',
  'rename ',
  'Binary files',
];

bool _isDiffHeaderLine(String line) =>
    _splitHeaderPrefixes.any(line.startsWith);

/// Zips consecutive removed/added lines inside each hunk into paired rows;
/// context lines fill both columns (buildSplitDiffRows parity).
List<SplitDiffRow> buildSplitDiffRows(List<String> lines) {
  final rows = <SplitDiffRow>[];
  var removed = <String>[];
  var added = <String>[];

  void flush() {
    final max = removed.length > added.length ? removed.length : added.length;
    for (var i = 0; i < max; i++) {
      rows.add(
        SplitContentRow(
          left: i < removed.length ? removed[i] : null,
          right: i < added.length ? added[i] : null,
        ),
      );
    }
    removed = [];
    added = [];
  }

  for (final line in lines) {
    if (_isDiffHeaderLine(line)) {
      flush();
      rows.add(SplitHeaderRow(line));
    } else if (line.startsWith('-')) {
      removed.add(line);
    } else if (line.startsWith('+')) {
      added.add(line);
    } else {
      flush();
      rows.add(SplitContentRow(left: line, right: line));
    }
  }
  flush();
  return rows;
}

class GitDiffViewer extends StatelessWidget {
  const GitDiffViewer({
    super.key,
    required this.diff,
    this.wrapText = false,
    this.viewMode = GitDiffViewMode.unified,
    this.hunkAction,
  });

  final String? diff;
  final bool wrapText;
  final GitDiffViewMode viewMode;
  final GitDiffHunkAction? hunkAction;

  @override
  Widget build(BuildContext context) {
    final raw = diff;
    if (raw == null || raw.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(child: Text('No diff available')),
      );
    }
    final truncatedChars = raw.length > _charLimit;
    final allLines = (truncatedChars ? raw.substring(0, _charLimit) : raw)
        .split('\n');
    final truncatedLines = allLines.length > _lineLimit;
    final lines = truncatedLines ? allLines.sublist(0, _lineLimit) : allLines;
    final truncated = truncatedChars || truncatedLines;
    final splitRows = viewMode == GitDiffViewMode.split
        ? buildSplitDiffRows(lines)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (truncated)
          Container(
            margin: const EdgeInsets.all(AppSpacing.sm),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              border: Border.all(color: context.appColors.border),
              borderRadius: AppRadii.borderMd,
            ),
            child: Text(
              'Large diff preview: rendering is limited to keep the tab responsive.',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 400),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: splitRows?.length ?? lines.length,
            itemBuilder: splitRows != null
                ? _splitBuilder(splitRows)
                : _unifiedBuilder(lines),
          ),
        ),
      ],
    );
  }

  // ─── Unified ─────────────────────────────────────────────────────────────

  IndexedWidgetBuilder _unifiedBuilder(List<String> lines) {
    var hunkIndex = -1;
    return (context, i) {
      final line = lines[i];
      final isAdd = line.startsWith('+') && !line.startsWith('+++');
      final isDel = line.startsWith('-') && !line.startsWith('---');
      final isHunk = line.startsWith('@@');
      if (isHunk) hunkIndex++;
      final c = context.appColors;
      final (bg, fg) = isAdd
          ? (
              const Color(0xFF2EA043).withValues(alpha: 0.14),
              const Color(0xFF2EA043),
            )
          : isDel
          ? (c.destructive.withValues(alpha: 0.14), c.destructive)
          : isHunk
          ? (c.primary.withValues(alpha: 0.08), c.primary)
          : (Colors.transparent, c.mutedForeground);
      return Container(
        color: bg,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          children: [
            Expanded(child: _mono(line, fg)),
            if (isHunk && hunkAction != null) _hunkButton(context, hunkIndex),
          ],
        ),
      );
    };
  }

  // ─── Split ───────────────────────────────────────────────────────────────

  IndexedWidgetBuilder _splitBuilder(List<SplitDiffRow> rows) {
    var hunkIndex = -1;
    return (context, i) {
      final row = rows[i];
      final c = context.appColors;
      if (row is SplitHeaderRow) {
        final isHunk = row.text.startsWith('@@');
        if (isHunk) hunkIndex++;
        return Container(
          color: isHunk
              ? c.primary.withValues(alpha: 0.08)
              : c.muted.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: _mono(row.text, isHunk ? c.primary : c.mutedForeground),
              ),
              if (isHunk && hunkAction != null) _hunkButton(context, hunkIndex),
            ],
          ),
        );
      }
      final content = row as SplitContentRow;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _splitCell(content.left, removed: true, colors: c)),
          Container(width: 1, color: c.border),
          Expanded(child: _splitCell(content.right, removed: false, colors: c)),
        ],
      );
    };
  }

  Widget _splitCell(
    String? text, {
    required bool removed,
    required AppColors colors,
  }) {
    if (text == null) {
      return Container(color: colors.muted.withValues(alpha: 0.15), height: 17);
    }
    final isContext = !(text.startsWith('-') || text.startsWith('+'));
    final bg = isContext
        ? Colors.transparent
        : removed
        ? colors.destructive.withValues(alpha: 0.14)
        : const Color(0xFF2EA043).withValues(alpha: 0.14);
    final fg = isContext
        ? colors.mutedForeground
        : removed
        ? colors.destructive
        : const Color(0xFF2EA043);
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: _mono(text, fg),
    );
  }

  Widget _mono(String text, Color color) {
    final t = Text(
      text,
      style: TextStyle(fontFamily: 'monospace', fontSize: 11.5, color: color),
      maxLines: wrapText ? null : 1,
      softWrap: wrapText,
      overflow: wrapText ? TextOverflow.visible : TextOverflow.clip,
    );
    if (wrapText) {
      return t;
    }
    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: t);
  }

  Widget _hunkButton(BuildContext context, int index) {
    final action = hunkAction!;
    final c = context.appColors;
    final color = action.isAdd ? const Color(0xFF2EA043) : c.destructive;
    return Tooltip(
      message: action.tooltip,
      child: InkWell(
        onTap: () => action.onAction(index),
        borderRadius: AppRadii.borderMd,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.5)),
            borderRadius: AppRadii.borderMd,
          ),
          child: Text(
            action.isAdd ? '+ Hunk' : '− Hunk',
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

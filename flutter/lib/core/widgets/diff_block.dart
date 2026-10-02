import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:flutter/material.dart';

/// Unified-diff block (tool_result edit output) — add/del/context line
/// coloring (T16.4).
class DiffBlock extends StatelessWidget {
  const DiffBlock({super.key, required this.diff, this.filename});

  final String diff;
  final String? filename;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.appColors;
    final mono = theme.textTheme.bodySmall!.copyWith(fontFamily: 'monospace', fontSize: 12.5);

    return Container(
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.45),
        border: Border.all(color: colors.border),
        borderRadius: AppRadii.borderMd,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: colors.muted.withValues(alpha: 0.6),
              border: Border(bottom: BorderSide(color: colors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    filename ?? 'diff',
                    style: theme.textTheme.labelSmall!.copyWith(
                      fontFamily: 'monospace',
                      color: colors.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  tooltip: 'Copy',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.copy_outlined, size: 15),
                  onPressed: () => unawaited(copyTextWithFeedback(context, diff)),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [for (final line in diff.split('\n')) _line(line, theme, mono)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _line(String line, ThemeData theme, TextStyle mono) {
    final colors = theme.extension<AppColors>()!;
    final (bg, fg) = switch (line) {
      _ when line.startsWith('+++') || line.startsWith('---') => (
        colors.muted.withValues(alpha: 0.5),
        colors.mutedForeground,
      ),
      _ when line.startsWith('@@') => (colors.primary.withValues(alpha: 0.12), colors.primary),
      _ when line.startsWith('+') => (Colors.green.withValues(alpha: 0.12), Colors.green.shade400),
      _ when line.startsWith('-') => (Colors.red.withValues(alpha: 0.12), Colors.red.shade400),
      _ => (null, colors.foreground),
    };
    return Container(
      color: bg,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
      child: Text(line.isEmpty ? ' ' : line, style: mono.copyWith(color: fg), softWrap: false),
    );
  }
}

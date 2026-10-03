import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/features/git/view/git_diff_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Lane assignment for the History view commit graph (VSCode Git Graph
/// style). Port of `commitGraph.ts` — commits must arrive in graph order
/// (children before parents; the backend uses `git log --topo-order`).
class CommitGraphRow {
  const CommitGraphRow({
    required this.nodeLane,
    required this.laneCount,
    required this.hasTopContinuation,
    required this.hasParentContinuation,
    required this.inbound,
    required this.outbound,
    required this.passThrough,
    required this.bottomLanes,
  });

  /// Lane the commit dot sits in.
  final int nodeLane;

  /// Total lanes visible in this row — determines the strip width.
  final int laneCount;

  /// A line arrives at the node from the row above (some child expects it).
  final bool hasTopContinuation;

  /// The node's own lane continues below toward its first parent.
  final bool hasParentContinuation;

  /// Extra top lanes that merge into the node (multiple children joining).
  final List<int> inbound;

  /// Bottom lanes branching out of the node toward extra parents (merges).
  final List<int> outbound;

  /// Lanes whose lines pass straight through this row untouched.
  final List<int> passThrough;

  /// Every lane still active below this row — rails continue through
  /// expanded content.
  final List<int> bottomLanes;
}

// Colors cycle per lane, VSCode Git Graph style. Chosen to stay readable on
// both light and dark backgrounds — literal hex, RefBadge derives alpha.
const _graphColors = [
  Color(0xFF0EA5E9), // sky
  Color(0xFFF97316), // orange
  Color(0xFFA855F7), // purple
  Color(0xFF22C55E), // green
  Color(0xFFEF4444), // red
  Color(0xFFEAB308), // yellow
  Color(0xFF14B8A6), // teal
  Color(0xFFEC4899), // pink
  Color(0xFF6366F1), // indigo
  Color(0xFF84CC16), // lime
];

Color laneColor(int lane) => _graphColors[lane % _graphColors.length];

List<CommitGraphRow> computeCommitGraph(List<GitCommit> commits) {
  // Each slot holds the commit hash that lane is waiting to reach, or null
  // when the lane is free.
  final lanes = <String?>[];
  final rows = <CommitGraphRow>[];

  int takeFirstFreeLane() {
    final free = lanes.indexOf(null);
    if (free != -1) return free;
    lanes.add(null);
    return lanes.length - 1;
  }

  for (final commit in commits) {
    final activeBefore = <int>{
      for (var i = 0; i < lanes.length; i++)
        if (lanes[i] != null) i,
    };
    // Lanes whose next expected commit is this one.
    final waiting = <int>[
      for (var i = 0; i < lanes.length; i++)
        if (lanes[i] == commit.hash) i,
    ];

    final hasTopContinuation = waiting.isNotEmpty;
    final nodeLane = hasTopContinuation ? waiting[0] : takeFirstFreeLane();

    // Additional lanes converging on this commit merge in and free up.
    final inbound = waiting.sublist(waiting.isEmpty ? 0 : 1);
    for (final lane in inbound) {
      lanes[lane] = null;
    }

    final parents = commit.parents;
    lanes[nodeLane] = parents.isNotEmpty ? parents[0] : null;

    // Extra parents (merge commits) either join a lane already heading to
    // that parent or open a new lane for it.
    final outbound = <int>[];
    for (final parent in parents.skip(1)) {
      final existing = lanes.indexWhere((expected) => expected == parent);
      if (existing != -1 && existing != nodeLane) {
        outbound.add(existing);
      } else {
        final lane = takeFirstFreeLane();
        lanes[lane] = parent;
        outbound.add(lane);
      }
    }

    final passThrough =
        activeBefore.where((lane) => lane != nodeLane && !waiting.contains(lane)).toList()..sort();

    final bottomLanes = <int>[
      for (var i = 0; i < lanes.length; i++)
        if (lanes[i] != null) i,
    ];

    final laneCount = lanes.length > nodeLane + 1 ? lanes.length : nodeLane + 1;

    // Keep the lane array tight so later rows don't inherit phantom width.
    while (lanes.isNotEmpty && lanes.last == null) {
      lanes.removeLast();
    }

    rows.add(
      CommitGraphRow(
        nodeLane: nodeLane,
        laneCount: laneCount,
        hasTopContinuation: hasTopContinuation,
        hasParentContinuation: parents.isNotEmpty,
        inbound: inbound,
        outbound: outbound,
        passThrough: passThrough,
        bottomLanes: bottomLanes,
      ),
    );
  }
  return rows;
}

/// The graph strip painted to the left of a commit row (CommitGraphStrip.tsx).
class CommitGraphStrip extends StatelessWidget {
  const CommitGraphStrip({super.key, required this.row});

  final CommitGraphRow row;

  static const double _laneWidth = 14;
  static const double _rowHeight = 56;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(row.laneCount * _laneWidth, _rowHeight),
      painter: _GraphPainter(row),
    );
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter(this.row);

  final CommitGraphRow row;

  static const _r = 4.0;

  double _x(int lane) => lane * CommitGraphStrip._laneWidth + CommitGraphStrip._laneWidth / 2;

  void _line(Canvas canvas, double x1, double y1, double x2, double y2, Color color) {
    canvas.drawLine(
      Offset(x1, y1),
      Offset(x2, y2),
      Paint()
        ..color = color
        ..strokeWidth = 1.5,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final nodeY = h / 2;

    // Lanes passing straight through untouched.
    for (final lane in row.passThrough) {
      _line(canvas, _x(lane), 0, _x(lane), h, laneColor(lane));
    }
    // The node's own lane: top → dot, dot → first parent below.
    if (row.hasTopContinuation) {
      _line(canvas, _x(row.nodeLane), 0, _x(row.nodeLane), nodeY, laneColor(row.nodeLane));
    }
    if (row.hasParentContinuation) {
      _line(canvas, _x(row.nodeLane), nodeY, _x(row.nodeLane), h, laneColor(row.nodeLane));
    }
    // Extra lanes merging into the node (children joining).
    for (final lane in row.inbound) {
      final path = Path()
        ..moveTo(_x(lane), 0)
        ..quadraticBezierTo(_x(lane), nodeY, _x(row.nodeLane), nodeY);
      canvas.drawPath(
        path,
        Paint()
          ..color = laneColor(lane)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
    // Extra parents branching out of the node (merge commits).
    for (final lane in row.outbound) {
      final path = Path()
        ..moveTo(_x(row.nodeLane), nodeY)
        ..quadraticBezierTo(_x(lane), nodeY, _x(lane), h);
      canvas.drawPath(
        path,
        Paint()
          ..color = laneColor(lane)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5,
      );
    }
    // The node dot.
    canvas.drawCircle(
      Offset(_x(row.nodeLane), nodeY),
      _r,
      Paint()..color = laneColor(row.nodeLane),
    );
  }

  @override
  bool shouldRepaint(_GraphPainter old) => old.row != row;
}

/// One "HEAD -> main" / "origin/x" / "tag: v1" decoration pill next to the
/// commit message, tinted with the commit's graph lane color.
class _RefBadge extends StatelessWidget {
  const _RefBadge({required this.refName, required this.color});

  final String refName;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isTag = refName.startsWith('tag: ');
    final isHead = refName.startsWith('HEAD -> ');
    final label = isTag
        ? refName.substring(5)
        : isHead
        ? refName.substring(8)
        : refName;
    return Container(
      constraints: const BoxConstraints(maxWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(999),
        color: isHead ? color.withValues(alpha: 0.13) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(isTag ? LucideIcons.tag : LucideIcons.gitBranch, size: 10, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Parsed per-file summary of a commit diff — port of `parseCommitFiles`.
class CommitFileSummary {
  const CommitFileSummary({
    required this.path,
    required this.directory,
    required this.filename,
    required this.status,
    required this.insertions,
    required this.deletions,
  });

  final String path;
  final String directory;
  final String filename;
  final String status;
  final int insertions;
  final int deletions;
}

List<CommitFileSummary> parseCommitFiles(String diff) {
  final files = <CommitFileSummary>[];
  for (final section in diff.split(RegExp('^diff --git ', multiLine: true)).skip(1)) {
    final lines = section.split('\n');
    final match = RegExp('^a/(.+?) b/(.+)').firstMatch(lines.first);
    if (match == null) continue;
    final pathA = match.group(1)!;
    final pathB = match.group(2)!;

    var status = 'M';
    final joined = lines.take(6).join('\n');
    if (joined.contains('new file mode')) {
      status = 'A';
    } else if (joined.contains('deleted file mode')) {
      status = 'D';
    }
    final filePath = status == 'D' ? pathA : pathB;

    var insertions = 0;
    var deletions = 0;
    for (final line in lines) {
      if (line.startsWith('+++') || line.startsWith('---')) continue;
      if (line.startsWith('+')) {
        insertions++;
      } else if (line.startsWith('-')) {
        deletions++;
      }
    }

    final lastSlash = filePath.lastIndexOf('/');
    files.add(
      CommitFileSummary(
        path: filePath,
        directory: lastSlash >= 0 ? filePath.substring(0, lastSlash + 1) : '',
        filename: lastSlash >= 0 ? filePath.substring(lastSlash + 1) : filePath,
        status: status,
        insertions: insertions,
        deletions: deletions,
      ),
    );
  }
  return files;
}

/// Badge tint per file-status letter — same buckets as the web legend
/// (FILE_STATUS_BADGE_CLASSES) using the theme palette.
Color statusBadgeColor(BuildContext context, String status) {
  final c = context.appColors;
  return switch (status) {
    'M' => const Color(0xFFD29922),
    'A' => const Color(0xFF2EA043),
    'D' => c.destructive,
    _ => c.mutedForeground,
  };
}

/// History view (HistoryView.tsx): full commit list with graph lanes and
/// lazily-fetched expandable diffs.
class GitHistoryView extends ConsumerStatefulWidget {
  const GitHistoryView({super.key, this.viewMode = GitDiffViewMode.unified});

  /// Shared with the header's unified/split toggle in GitScreen.
  final GitDiffViewMode viewMode;

  @override
  ConsumerState<GitHistoryView> createState() => _GitHistoryViewState();
}

class _GitHistoryViewState extends ConsumerState<GitHistoryView> {
  final _expanded = <String>{};

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gitProvider);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final commits = state.commits;

    // Lane layout — rows align 1:1 with commits. Older responses without
    // `parents` degrade to plain rows (no strip).
    final graphRows = commits.any((cm) => cm.parents.isNotEmpty)
        ? computeCommitGraph(commits)
        : null;

    if (state.loading && commits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xl),
          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    if (commits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.history, size: 32, color: c.mutedForeground),
            const SizedBox(height: AppSpacing.sm),
            Text('No commits found', style: t.bodyMedium?.copyWith(color: c.mutedForeground)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
        itemCount: commits.length,
        itemBuilder: (context, i) {
          final cm = commits[i];
          final isOpen = _expanded.contains(cm.hash);
          final diff = state.commitDiffs[cm.hash];
          final graphRow = graphRows?[i];
          final badgeColor = graphRow != null ? laneColor(graphRow.nodeLane) : laneColor(0);

          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (graphRow != null)
                  Column(
                    children: [
                      CommitGraphStrip(row: graphRow),
                      // Rails keep running through the expanded body.
                      if (isOpen)
                        Expanded(
                          child: CustomPaint(
                            painter: _RailsPainter(graphRow.bottomLanes),
                            child: const SizedBox(width: double.nan),
                          ),
                        ),
                    ],
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            if (!_expanded.remove(cm.hash)) {
                              _expanded.add(cm.hash);
                            }
                          });
                          if (_expanded.contains(cm.hash) && diff == null) {
                            unawaited(ref.read(gitProvider.notifier).fetchCommitDiff(cm.hash));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  isOpen ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                  size: 14,
                                  color: c.mutedForeground,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (cm.refs.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 2),
                                        child: Wrap(
                                          spacing: 4,
                                          runSpacing: 4,
                                          children: [
                                            for (final r in cm.refs)
                                              _RefBadge(refName: r, color: badgeColor),
                                          ],
                                        ),
                                      ),
                                    Text(
                                      cm.message,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${cm.author} • ${cm.date ?? ''}',
                                      style: t.bodySmall?.copyWith(color: c.mutedForeground),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                cm.hash.length > 7 ? cm.hash.substring(0, 7) : cm.hash,
                                style: t.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                  color: c.mutedForeground.withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isOpen)
                        Container(
                          color: c.muted.withValues(alpha: 0.4),
                          constraints: const BoxConstraints(maxHeight: 512),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: _CommitDetails(
                              commit: cm,
                              diff: diff,
                              viewMode: widget.viewMode,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
  }
}

/// Continuous rails under an expanded row (bottomLanes of the row above).
class _RailsPainter extends CustomPainter {
  _RailsPainter(this.lanes);

  final List<int> lanes;

  @override
  void paint(Canvas canvas, Size size) {
    for (final lane in lanes) {
      final x = lane * CommitGraphStrip._laneWidth + CommitGraphStrip._laneWidth / 2;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        Paint()
          ..color = laneColor(lane)
          ..strokeWidth = 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(_RailsPainter old) =>
      old.lanes.length != lanes.length || !old.lanes.every(lanes.contains);
}

/// Expanded commit body: full hash, author/date, files+stats card, the
/// diff itself — CommitHistoryItem's expanded section.
class _CommitDetails extends StatelessWidget {
  const _CommitDetails({required this.commit, required this.diff, required this.viewMode});

  final GitCommit commit;
  final String? diff;
  final GitDiffViewMode viewMode;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    if (diff == null) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Center(
          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }
    final files = parseCommitFiles(diff!);
    final totalIns = files.fold<int>(0, (s, f) => s + f.insertions);
    final totalDel = files.fold<int>(0, (s, f) => s + f.deletions);
    final date = DateTime.tryParse(commit.date ?? '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          commit.hash,
          style: t.labelSmall?.copyWith(fontFamily: 'monospace', color: c.mutedForeground),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Text('Author ', style: t.labelSmall?.copyWith(color: c.mutedForeground)),
            Text(commit.author, style: t.labelSmall),
            const SizedBox(width: AppSpacing.md),
            Text('Date ', style: t.labelSmall?.copyWith(color: c.mutedForeground)),
            Text(
              date == null
                  ? (commit.date ?? '')
                  : '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
              style: t.labelSmall,
            ),
          ],
        ),
        if (files.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.7),
              borderRadius: AppRadii.borderMd,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _stat(context, 'Files', '${files.length}'),
                _stat(context, 'Added', '+$totalIns', color: const Color(0xFF2EA043)),
                _stat(context, 'Removed', '-$totalDel', color: c.destructive),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'CHANGED FILES',
            style: t.labelSmall?.copyWith(
              color: c.mutedForeground,
              letterSpacing: 0.6,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderMd,
            ),
            child: Column(
              children: [
                for (var i = 0; i < files.length; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: i < files.length - 1
                          ? Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.4)))
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: statusBadgeColor(
                                context,
                                files[i].status,
                              ).withValues(alpha: 0.5),
                            ),
                            borderRadius: AppRadii.borderSm,
                          ),
                          child: Text(
                            files[i].status,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: statusBadgeColor(context, files[i].status),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                if (files[i].directory.isNotEmpty)
                                  TextSpan(
                                    text: files[i].directory,
                                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                                  ),
                                TextSpan(
                                  text: files[i].filename,
                                  style: t.labelSmall?.copyWith(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          [
                            if (files[i].insertions > 0) '+${files[i].insertions}',
                            if (files[i].deletions > 0) '-${files[i].deletions}',
                          ].join('/'),
                          style: t.labelSmall?.copyWith(
                            fontFamily: 'monospace',
                            color: c.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        GitDiffViewer(diff: diff!, viewMode: viewMode),
      ],
    );
  }

  Widget _stat(BuildContext context, String label, String value, {Color? color}) {
    final t = Theme.of(context).textTheme;
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.lg),
      child: Column(
        children: [
          Text(label, style: t.labelSmall?.copyWith(color: c.mutedForeground)),
          Text(
            value,
            style: t.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

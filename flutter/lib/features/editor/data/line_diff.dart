/// Line-based diff + merge bookkeeping for the editor diff view.
/// Pure Dart — no Flutter imports, unit-testable.
library;

/// A run of identical lines present in both versions.
class ContextSegment extends DiffSegment {
  ContextSegment(this.lines);

  final List<String> lines;
}

/// A changed region: [removed] lines from the base version replaced by
/// [added] lines in the working copy. [useOld] is the merge choice —
/// false keeps the working-copy side (the default).
class ChangeSegment extends DiffSegment {
  ChangeSegment({required this.removed, required this.added});

  final List<String> removed;
  final List<String> added;
  bool useOld = false;
}

sealed class DiffSegment {}

/// Result of [computeLineDiff]: an ordered list of segments covering the
/// whole file, so [merged] can reassemble either side verbatim.
class FileDiff {
  const FileDiff(this.segments);

  final List<DiffSegment> segments;

  List<ChangeSegment> get changes => [
    for (final s in segments)
      if (s is ChangeSegment) s,
  ];

  bool get hasChanges => changes.isNotEmpty;

  int get addedCount => changes.fold(0, (n, c) => n + c.added.length);
  int get removedCount => changes.fold(0, (n, c) => n + c.removed.length);

  /// Reassemble the file honoring each hunk's [ChangeSegment.useOld] choice.
  String merged() {
    final out = <String>[];
    for (final s in segments) {
      switch (s) {
        case ContextSegment(:final lines):
          out.addAll(lines);
        case ChangeSegment(:final removed, :final added, :final useOld):
          out.addAll(useOld ? removed : added);
      }
    }
    return out.join('\n');
  }
}

/// O(m·n) LCS budget — beyond that (huge rewritten files) the middle of the
/// file collapses into one big change segment. ponytail: a Myers diff would
/// stay linear, but prefix/suffix trimming already shrinks real edits.
const _maxMatrixCells = 4000000;

FileDiff computeLineDiff(String oldText, String newText) {
  final a = oldText.split('\n');
  final b = newText.split('\n');

  // Trim shared prefix/suffix — real-world edits are local, so this usually
  // leaves a tiny middle for the quadratic step.
  var pre = 0;
  while (pre < a.length && pre < b.length && a[pre] == b[pre]) {
    pre++;
  }
  var suf = 0;
  while (suf < a.length - pre &&
      suf < b.length - pre &&
      a[a.length - 1 - suf] == b[b.length - 1 - suf]) {
    suf++;
  }

  final aMid = a.sublist(pre, a.length - suf);
  final bMid = b.sublist(pre, b.length - suf);

  final segments = <DiffSegment>[];
  if (pre > 0) segments.add(ContextSegment(a.sublist(0, pre)));

  if (aMid.isNotEmpty || bMid.isNotEmpty) {
    if (aMid.length * bMid.length > _maxMatrixCells) {
      segments.add(ChangeSegment(removed: aMid, added: bMid));
    } else {
      _appendMiddle(segments, aMid, bMid);
    }
  }

  if (suf > 0) segments.add(ContextSegment(a.sublist(a.length - suf)));
  if (segments.isEmpty) segments.add(ContextSegment(const []));
  return FileDiff(segments);
}

/// LCS DP over the differing middle, then fold the op sequence into
/// Context/Change segments. Runs of removed+added lines merge into one
/// ChangeSegment (removed first, then added — matching git diff order).
void _appendMiddle(List<DiffSegment> out, List<String> a, List<String> b) {
  final m = a.length;
  final n = b.length;
  // dp[i][j] = LCS length of a[i:] vs b[j:], row-major flat array.
  final dp = List<int>.filled((m + 1) * (n + 1), 0);
  for (var i = m - 1; i >= 0; i--) {
    final row = i * (n + 1);
    final next = row + n + 1;
    for (var j = n - 1; j >= 0; j--) {
      dp[row + j] = a[i] == b[j]
          ? dp[next + j + 1] + 1
          : (dp[next + j] > dp[row + j + 1] ? dp[next + j] : dp[row + j + 1]);
    }
  }

  var i = 0;
  var j = 0;
  List<String> context = [];
  List<String> removed = [];
  List<String> added = [];

  void flush() {
    // Context first — trailing a/b leftovers below belong to a hunk that
    // comes *after* any pending context run.
    if (context.isNotEmpty) {
      out.add(ContextSegment(context));
      context = [];
    }
    if (removed.isNotEmpty || added.isNotEmpty) {
      out.add(ChangeSegment(removed: removed, added: added));
      removed = [];
      added = [];
    }
  }

  while (i < m && j < n) {
    if (a[i] == b[j]) {
      if (removed.isNotEmpty || added.isNotEmpty) {
        out.add(ChangeSegment(removed: removed, added: added));
        removed = [];
        added = [];
      }
      context.add(a[i]);
      i++;
      j++;
    } else {
      if (context.isNotEmpty) {
        out.add(ContextSegment(context));
        context = [];
      }
      // Descend toward the side with the longer LCS tail.
      if (dp[(i + 1) * (n + 1) + j] >= dp[i * (n + 1) + j + 1]) {
        removed.add(a[i]);
        i++;
      } else {
        added.add(b[j]);
        j++;
      }
    }
  }
  removed.addAll(a.sublist(i));
  added.addAll(b.sublist(j));
  flush();
}

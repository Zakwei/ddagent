import 'package:ddagent_app/features/workspace/state/split_workspace.dart';

// VS Code-style workspace layout: a tree of row/column splits whose leaves
// are pane groups — one or more panes shown as tabs, one of them visible.
// Pure and Flutter-free so it can be synced, merged and tested.
//
// Wire shape (inside the synced workspace state as `layout`):
//   group → {"pane": "<id>"}                       (a single pane)
//           {"panes": ["<id>", ...], "active": "<id>"}  (tabs)
//   split → {"axis": "row" | "column", "children": [...], "weights": [int, ...]}
// Weights are integers normalized to sum to [kLayoutWeightTotal], so a
// resized layout serializes byte-identically on every device (sync compares
// JSON) instead of drifting through float noise.

/// Sum every split's weights are normalized to.
const kLayoutWeightTotal = 1000;

/// Deepest split nesting accepted from storage/the wire (6 panes need ≤ 5).
const _maxDepth = 8;

/// `row` lays children left→right, `column` top→bottom.
enum PaneAxis { row, column }

/// Where a dragged pane lands on a target group: one of its edges (split
/// there) or its centre (join the group as a tab). On the workspace's own
/// outer edges it makes a full-height column / full-width row.
enum PaneDropZone { left, right, top, bottom, center }

sealed class PaneLayout {
  const PaneLayout();

  Map<String, dynamic> toJson();

  /// Tolerant decode: malformed nodes drop out, mismatched weights become
  /// equal, single-child splits collapse. Null when nothing usable is left.
  static PaneLayout? fromJson(Object? value, [int depth = 0]) {
    if (value is! Map || depth > _maxDepth) return null;
    final pane = value['pane'];
    if (pane is String && pane.isNotEmpty) return PaneLeaf(pane);
    final panes = value['panes'];
    if (panes is List) {
      final ids = <String>{
        for (final id in panes)
          if (id is String && id.isNotEmpty) id,
      }.toList();
      if (ids.isEmpty) return null;
      final active = value['active'];
      return PaneLeaf.group(ids, active is String ? active : ids.first);
    }
    final axis = PaneAxis.values.asNameMap()[value['axis']];
    final rawChildren = value['children'];
    if (axis == null || rawChildren is! List) return null;
    final rawWeights = value['weights'];
    final children = <PaneLayout>[];
    final weights = <int>[];
    for (final (i, raw) in rawChildren.indexed) {
      final child = fromJson(raw, depth + 1);
      if (child == null) continue;
      children.add(child);
      final w = rawWeights is List && i < rawWeights.length ? rawWeights[i] : null;
      weights.add(w is num && w > 0 ? w.round() : 0);
    }
    if (children.isEmpty) return null;
    final valid = weights.every((w) => w > 0);
    return simplifyLayout(
      PaneSplit(axis, children, valid ? weights : List.filled(children.length, 1)),
    );
  }
}

/// A leaf of the tree: a group of panes shown as tabs ([paneIds] in tab
/// order), [activeId] the visible one. Most groups hold a single pane.
final class PaneLeaf extends PaneLayout {
  PaneLeaf(String paneId) : paneIds = List.unmodifiable([paneId]), activeId = paneId;

  PaneLeaf.group(List<String> paneIds, String activeId)
    : assert(paneIds.isNotEmpty),
      paneIds = List.unmodifiable(paneIds),
      activeId = paneIds.contains(activeId) ? activeId : paneIds.first;

  final List<String> paneIds;
  final String activeId;

  bool get isSingle => paneIds.length == 1;

  @override
  Map<String, dynamic> toJson() =>
      isSingle ? {'pane': paneIds.single} : {'panes': paneIds, 'active': activeId};
}

final class PaneSplit extends PaneLayout {
  const PaneSplit(this.axis, this.children, this.weights)
    : assert(children.length == weights.length);

  final PaneAxis axis;
  final List<PaneLayout> children;
  final List<int> weights;

  @override
  Map<String, dynamic> toJson() => {
    'axis': axis.name,
    'children': [for (final c in children) c.toJson()],
    'weights': weights,
  };
}

/// Scales [weights] to integers summing to [kLayoutWeightTotal], each ≥ 1.
List<int> normalizeWeights(List<num> weights) {
  if (weights.isEmpty) return const [];
  final positive = [for (final w in weights) w > 0 ? w : 0];
  final sum = positive.fold<num>(0, (a, b) => a + b);
  if (sum <= 0) return normalizeWeights(List.filled(weights.length, 1));
  final out = [
    for (final w in positive) ((w / sum) * kLayoutWeightTotal).round().clamp(1, 1 << 20),
  ];
  // Put the rounding remainder on the largest child so the sum is exact.
  final diff = kLayoutWeightTotal - out.fold<int>(0, (a, b) => a + b);
  if (diff != 0) {
    var largest = 0;
    for (var i = 1; i < out.length; i++) {
      if (out[i] > out[largest]) largest = i;
    }
    out[largest] = (out[largest] + diff).clamp(1, 1 << 20);
  }
  return out;
}

/// Canonical form: no empty or single-child splits, a child split with the
/// same axis as its parent is flattened into it (its weights scaled by its
/// share), and every split's weights are normalized.
PaneLayout? simplifyLayout(PaneLayout? node) {
  if (node is! PaneSplit) return node;
  final children = <PaneLayout>[];
  final weights = <num>[];
  final total = node.weights.fold<int>(0, (a, b) => a + b);
  for (final (i, raw) in node.children.indexed) {
    final child = simplifyLayout(raw);
    if (child == null) continue;
    final share = total <= 0 ? 1 : node.weights[i] / total;
    if (child is PaneSplit && child.axis == node.axis) {
      final childTotal = child.weights.fold<int>(0, (a, b) => a + b);
      for (final (j, grandchild) in child.children.indexed) {
        children.add(grandchild);
        weights.add(share * child.weights[j] / (childTotal <= 0 ? 1 : childTotal));
      }
    } else {
      children.add(child);
      weights.add(share);
    }
  }
  if (children.isEmpty) return null;
  if (children.length == 1) return children.single;
  return PaneSplit(node.axis, children, normalizeWeights(weights));
}

/// Groups in reading order (depth-first, left→right / top→bottom).
List<PaneLeaf> layoutGroups(PaneLayout? node) => switch (node) {
  null => const [],
  PaneLeaf() => [node],
  PaneSplit(:final children) => [for (final c in children) ...layoutGroups(c)],
};

/// Pane ids in reading order: groups in reading order, tabs in tab order.
List<String> layoutLeafOrder(PaneLayout? node) => [
  for (final g in layoutGroups(node)) ...g.paneIds,
];

/// The group holding [paneId], or null.
PaneLeaf? layoutGroupOf(PaneLayout? layout, String paneId) =>
    layoutGroups(layout).where((g) => g.paneIds.contains(paneId)).firstOrNull;

/// The automatic grid the workspace used before layouts became editable
/// (`getSplitLayout`): equal rows, equal cells, a partial last row stretched
/// across the full width. Null for no panes.
PaneLayout? autoPaneLayout(List<String> ids) {
  if (ids.isEmpty) return null;
  if (ids.length == 1) return PaneLeaf(ids.single);
  final grid = getSplitLayout(ids.length);
  PaneLayout row(List<String> cells) => cells.length == 1
      ? PaneLeaf(cells.single)
      : PaneSplit(PaneAxis.row, [
          for (final id in cells) PaneLeaf(id),
        ], normalizeWeights(List.filled(cells.length, 1)));
  if (grid.rows == 1) return row(ids);
  final rows = [
    for (var r = 0; r < grid.rows; r++)
      if (r * grid.columns < ids.length)
        row(ids.sublist(r * grid.columns, ((r + 1) * grid.columns).clamp(0, ids.length))),
  ];
  return PaneSplit(PaneAxis.column, rows, normalizeWeights(List.filled(rows.length, 1)));
}

/// Rebuilds the tree bottom-up: [group] maps each group to its replacement
/// (null drops it); splits losing children drop their weights, then the
/// result is simplified.
PaneLayout? _mapGroups(PaneLayout? layout, PaneLayout? Function(PaneLeaf group) group) {
  PaneLayout? visit(PaneLayout node) => switch (node) {
    PaneLeaf() => group(node),
    PaneSplit() => () {
      final children = <PaneLayout>[];
      final weights = <int>[];
      for (final (i, c) in node.children.indexed) {
        final next = visit(c);
        if (next == null) continue;
        children.add(next);
        weights.add(node.weights[i]);
      }
      return children.isEmpty ? null : PaneSplit(node.axis, children, weights);
    }(),
  };
  return layout == null ? null : simplifyLayout(visit(layout));
}

/// [layout] without [paneId]. A group keeps its other tabs (the neighbour
/// tab becomes visible); an emptied group gives its space to its siblings.
PaneLayout? removePaneFromLayout(PaneLayout? layout, String paneId) => _mapGroups(layout, (g) {
  final at = g.paneIds.indexOf(paneId);
  if (at < 0) return g;
  final rest = [...g.paneIds]..removeAt(at);
  if (rest.isEmpty) return null;
  final active = g.activeId == paneId ? rest[at.clamp(0, rest.length - 1)] : g.activeId;
  return PaneLeaf.group(rest, active);
});

/// Docks [paneId] (not in the layout) at an edge [zone] of the group holding
/// [targetId]: the group's space is halved between the two. A group already
/// inside a split along that axis gets a sibling; otherwise it is wrapped in
/// a new split. [PaneDropZone.center] adds it to the group as the visible
/// tab. An unknown target appends [paneId] to the right of everything.
PaneLayout insertPaneIntoLayout(
  PaneLayout? layout,
  String paneId,
  String targetId,
  PaneDropZone zone,
) {
  final leaf = PaneLeaf(paneId);
  if (layout == null) return leaf;
  if (zone == PaneDropZone.center) {
    var added = false;
    final next = _mapGroups(layout, (g) {
      final at = g.paneIds.indexOf(targetId);
      if (at < 0 || added) return g;
      added = true;
      return PaneLeaf.group([...g.paneIds]..insert(at + 1, paneId), paneId);
    });
    return added ? next! : insertPaneIntoLayout(layout, paneId, '', PaneDropZone.right);
  }
  final axis = zone == PaneDropZone.left || zone == PaneDropZone.right
      ? PaneAxis.row
      : PaneAxis.column;
  final before = zone == PaneDropZone.left || zone == PaneDropZone.top;
  var found = false;

  PaneLayout visit(PaneLayout node) {
    switch (node) {
      case PaneLeaf():
        if (!node.paneIds.contains(targetId) || found) return node;
        found = true;
        return PaneSplit(axis, before ? [leaf, node] : [node, leaf], const [1, 1]);
      case PaneSplit():
        final children = <PaneLayout>[];
        final weights = <int>[];
        for (final (i, c) in node.children.indexed) {
          final w = node.weights[i];
          if (!found && node.axis == axis && c is PaneLeaf && c.paneIds.contains(targetId)) {
            found = true;
            final half = w / 2;
            if (before) {
              children.addAll([leaf, c]);
            } else {
              children.addAll([c, leaf]);
            }
            weights.addAll([half.ceil(), half.floor().clamp(1, w)]);
            continue;
          }
          children.add(visit(c));
          weights.add(w);
        }
        return PaneSplit(node.axis, children, weights);
    }
  }

  final next = visit(layout);
  if (found) return simplifyLayout(next)!;
  return simplifyLayout(PaneSplit(PaneAxis.row, [layout, leaf], const [2, 1]))!;
}

/// Swaps the positions of two panes (tabs included).
PaneLayout? swapPanesInLayout(PaneLayout? layout, String a, String b) {
  String swap(String id) => id == a ? b : (id == b ? a : id);
  return _mapGroups(
    layout,
    (g) => PaneLeaf.group([for (final id in g.paneIds) swap(id)], swap(g.activeId)),
  );
}

/// Drag-and-drop of pane [fromId] onto the group holding [targetId]: the
/// centre adds it to that group as a tab, an edge splits there. Dropping a
/// pane on itself, or on the centre of its own group, changes nothing.
PaneLayout? movePaneInLayout(
  PaneLayout? layout,
  String fromId,
  String targetId,
  PaneDropZone zone,
) {
  if (layout == null || fromId == targetId) return layout;
  if (zone == PaneDropZone.center &&
      layoutGroupOf(layout, targetId)?.paneIds.contains(fromId) == true) {
    return layout;
  }
  return insertPaneIntoLayout(removePaneFromLayout(layout, fromId), fromId, targetId, zone);
}

/// Moves [paneId] to an outer edge of the whole workspace: a full-height
/// column (left/right) or full-width row (top/bottom) taking a third.
PaneLayout? dockPaneAtRoot(PaneLayout? layout, String paneId, PaneDropZone zone) {
  final rest = removePaneFromLayout(layout, paneId);
  final leaf = PaneLeaf(paneId);
  if (rest == null || zone == PaneDropZone.center) return rest ?? leaf;
  final axis = zone == PaneDropZone.left || zone == PaneDropZone.right
      ? PaneAxis.row
      : PaneAxis.column;
  final before = zone == PaneDropZone.left || zone == PaneDropZone.top;
  return simplifyLayout(
    PaneSplit(axis, before ? [leaf, rest] : [rest, leaf], before ? const [1, 2] : const [2, 1]),
  );
}

/// Makes [paneId] the visible tab of its group.
PaneLayout? setActivePaneInLayout(PaneLayout? layout, String paneId) => _mapGroups(
  layout,
  (g) => g.paneIds.contains(paneId) && g.activeId != paneId ? PaneLeaf.group(g.paneIds, paneId) : g,
);

/// Replaces the weights of the split at [path] (child indices from the root).
PaneLayout? setLayoutWeights(PaneLayout? layout, List<int> path, List<num> weights) {
  PaneLayout visit(PaneLayout node, int depth) {
    if (node is! PaneSplit) return node;
    if (depth == path.length) {
      if (weights.length != node.children.length) return node;
      return PaneSplit(node.axis, node.children, normalizeWeights(weights));
    }
    final at = path[depth];
    if (at < 0 || at >= node.children.length) return node;
    return PaneSplit(node.axis, [
      for (final (i, c) in node.children.indexed) i == at ? visit(c, depth + 1) : c,
    ], node.weights);
  }

  return layout == null ? null : visit(layout, 0);
}

/// The split at [path], or null.
PaneSplit? layoutSplitAt(PaneLayout? layout, List<int> path) {
  var node = layout;
  for (final i in path) {
    if (node is! PaneSplit || i < 0 || i >= node.children.length) return null;
    node = node.children[i];
  }
  return node is PaneSplit ? node : null;
}

/// Makes [layout] describe exactly [ids]: unknown or duplicate panes are
/// dropped, missing panes are appended on the right. Null stays null (the
/// automatic grid).
PaneLayout? reconcileLayout(PaneLayout? layout, List<String> ids) {
  if (layout == null) return null;
  final wanted = ids.toSet();
  final seen = <String>{};
  var next = _mapGroups(layout, (g) {
    final kept = [
      for (final id in g.paneIds)
        if (wanted.contains(id) && seen.add(id)) id,
    ];
    return kept.isEmpty ? null : PaneLeaf.group(kept, g.activeId);
  });
  for (final id in ids) {
    if (seen.contains(id)) continue;
    final last = layoutLeafOrder(next).lastOrNull;
    next = last == null ? PaneLeaf(id) : insertPaneIntoLayout(next, id, last, PaneDropZone.right);
  }
  return next;
}

/// [panes] in the reading order of [layout] (unchanged for the auto grid).
List<SplitPane> sortPanesByLayout(List<SplitPane> panes, PaneLayout? layout) {
  if (layout == null) return panes;
  final rank = {for (final (i, id) in layoutLeafOrder(layout).indexed) id: i};
  return [...panes]..sort((a, b) => (rank[a.id] ?? 1 << 20).compareTo(rank[b.id] ?? 1 << 20));
}

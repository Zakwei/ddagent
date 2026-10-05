import 'dart:math' as math;

import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_repository.dart';
import 'package:ddagent_app/features/knowledge/state/knowledge_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Force-directed relation graph for the knowledge base.
///
/// Renders the graph the server returns (`/api/knowledge/graph`): nodes are
/// entities, edges are explicit connections. Layout is a small
/// Fruchterman-Reingold relaxation run once per load (and after a drag), then
/// painted with `CustomPainter` inside an `InteractiveViewer` for pan/zoom.
/// Tapping a node highlights its neighbours and opens a details sheet.
class KnowledgeGraphView extends ConsumerStatefulWidget {
  const KnowledgeGraphView({super.key});

  @override
  ConsumerState<KnowledgeGraphView> createState() => _KnowledgeGraphViewState();
}

class _KnowledgeGraphViewState extends ConsumerState<KnowledgeGraphView> {
  static const _canvas = Size(1100, 900);
  static const _nodeRadius = 14.0;

  final Set<KnowledgeEntityType> _types = {...KnowledgeEntityType.values};
  final Map<String, Offset> _positions = {};
  Map<String, String> _labels = const {};
  KbGraph? _graph;
  String? _selectedId;
  String? _error;
  bool _loading = true;
  String? _dragging;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final projectId = ref.read(knowledgeControllerProvider).projectFilter;
      final graph = await ref
          .read(knowledgeRepositoryProvider)
          .graph(projectId: projectId, entityTypes: _types.map((type) => type.wire).toList());
      if (!mounted) return;
      _labels = {for (final node in graph.nodes) node.id: node.label};
      _computeLayout(graph);
      setState(() {
        _graph = graph;
        _loading = false;
      });
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _error = '$error';
        _loading = false;
      });
    }
  }

  /// Fruchterman-Reingold relaxation on a fixed canvas: repulsion between every
  /// pair, springs along edges, geometric cooling. Cost is O(n²·iterations) and
  /// bounded by the server's node cap.
  void _computeLayout(KbGraph graph) {
    final ids = [for (final node in graph.nodes) node.id];
    final n = ids.length;
    _positions.clear();
    if (n == 0) return;
    final center = Offset(_canvas.width / 2, _canvas.height / 2);
    final radius = math.min(_canvas.width, _canvas.height) * 0.42;
    for (var i = 0; i < n; i++) {
      final angle = (2 * math.pi * i) / n;
      _positions[ids[i]] = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
    }
    final area = _canvas.width * _canvas.height;
    final k = math.sqrt(area / n);
    var temperature = _canvas.width / 8;
    final iterations = n <= 80 ? 220 : 120;
    for (var step = 0; step < iterations; step++) {
      final disp = {for (final id in ids) id: Offset.zero};
      for (var i = 0; i < n; i++) {
        for (var j = i + 1; j < n; j++) {
          final a = _positions[ids[i]]!;
          final b = _positions[ids[j]]!;
          var delta = a - b;
          if (delta.distance < 0.01) {
            delta = Offset(0.01 * (i + 1), 0.01);
          }
          final dist = delta.distance;
          final force = (k * k) / dist;
          final dir = delta / dist;
          disp[ids[i]] = disp[ids[i]]! + dir * force;
          disp[ids[j]] = disp[ids[j]]! - dir * force;
        }
      }
      for (final edge in graph.edges) {
        if (!_positions.containsKey(edge.source) || !_positions.containsKey(edge.target)) continue;
        final a = _positions[edge.source]!;
        final b = _positions[edge.target]!;
        var delta = a - b;
        if (delta.distance < 0.01) delta = const Offset(0.01, 0.01);
        final dist = delta.distance;
        final force = (dist * dist) / k;
        final dir = delta / dist;
        disp[edge.source] = disp[edge.source]! - dir * force;
        disp[edge.target] = disp[edge.target]! + dir * force;
      }
      for (final id in ids) {
        final d = disp[id]!;
        final dist = d.distance;
        final limit = math.min(dist, temperature);
        if (dist > 0.001) _positions[id] = _positions[id]! + (d / dist) * limit;
        _positions[id] = Offset(
          _positions[id]!.dx.clamp(24, _canvas.width - 24),
          _positions[id]!.dy.clamp(24, _canvas.height - 24),
        );
      }
      temperature *= 0.94;
    }
  }

  String? _nodeAt(Offset local) {
    for (final entry in _positions.entries) {
      if ((entry.value - local).distance <= _nodeRadius + 6) return entry.key;
    }
    return null;
  }

  Set<String> get _neighbours {
    final selected = _selectedId;
    if (selected == null || _graph == null) return const {};
    final ids = <String>{selected};
    for (final edge in _graph!.edges) {
      if (edge.source == selected) ids.add(edge.target);
      if (edge.target == selected) ids.add(edge.source);
    }
    return ids;
  }

  void _showDetails(String id) {
    final graph = _graph;
    if (graph == null) return;
    KbGraphNode? node;
    for (final candidate in graph.nodes) {
      if (candidate.id == id) {
        node = candidate;
        break;
      }
    }
    if (node == null) return;
    final selected = node;
    final relations = [
      for (final edge in graph.edges)
        if (edge.source == id || edge.target == id)
          '${edge.relationship}: ${_labels[edge.source == id ? edge.target : edge.source] ?? ''}',
    ];
    showModalBottomSheet<void>(
      context: context,
      builder: (_) => ListTile(
        leading: _EntityIcon(type: selected.nodeType),
        title: Text(selected.label),
        subtitle: Text(
          [selected.nodeType, if (relations.isNotEmpty) relations.join('\n')].join('\n'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    // Reload when the screen's project filter changes.
    ref.listen(
      knowledgeControllerProvider.select((state) => state.projectFilter),
      (_, _) => _load(),
    );
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Wrap(
                spacing: 6,
                children: [
                  for (final type in KnowledgeEntityType.values)
                    FilterChip(
                      label: Text(type.label),
                      selected: _types.contains(type),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _types.add(type);
                          } else {
                            _types.remove(type);
                          }
                        });
                        _load();
                      },
                    ),
                ],
              ),
              const Spacer(),
              if (_graph?.truncated == true)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(t.knowledge.graph.truncated, style: const TextStyle(fontSize: 11)),
                ),
              IconButton(onPressed: _loading ? null : _load, icon: const Icon(Icons.refresh)),
            ],
          ),
        ),
        Expanded(child: _buildCanvas(context)),
      ],
    );
  }

  Widget _buildCanvas(BuildContext context) {
    final t = Translations.of(context);
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    final graph = _graph;
    if (graph == null || graph.nodes.isEmpty) {
      return Center(child: Text(t.knowledge.empty.graph));
    }
    final neighbours = _neighbours;
    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(200),
      minScale: 0.2,
      maxScale: 3,
      child: SizedBox(
        width: _canvas.width,
        height: _canvas.height,
        child: GestureDetector(
          onTapUp: (details) {
            final id = _nodeAt(details.localPosition);
            setState(() => _selectedId = id);
            if (id != null) _showDetails(id);
          },
          onPanStart: (details) => _dragging = _nodeAt(details.localPosition),
          onPanUpdate: (details) {
            final id = _dragging;
            if (id == null) return;
            setState(() {
              _positions[id] = Offset(
                (_positions[id]!.dx + details.delta.dx).clamp(24, _canvas.width - 24),
                (_positions[id]!.dy + details.delta.dy).clamp(24, _canvas.height - 24),
              );
            });
          },
          onPanEnd: (_) => _dragging = null,
          child: CustomPaint(
            size: _canvas,
            painter: _GraphPainter(
              graph: graph,
              positions: _positions,
              labels: _labels,
              selectedId: _selectedId,
              neighbours: neighbours,
              colors: Theme.of(context).colorScheme,
            ),
          ),
        ),
      ),
    );
  }
}

class _EntityIcon extends StatelessWidget {
  const _EntityIcon({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    final icon = switch (type) {
      'rule' => Icons.rule,
      'skill' => Icons.auto_awesome_outlined,
      'personal' => Icons.person_outline,
      'project' => Icons.folder_outlined,
      'tag' => Icons.sell_outlined,
      _ => Icons.psychology_outlined,
    };
    return Icon(icon);
  }
}

class _GraphPainter extends CustomPainter {
  _GraphPainter({
    required this.graph,
    required this.positions,
    required this.labels,
    required this.selectedId,
    required this.neighbours,
    required this.colors,
  });

  final KbGraph graph;
  final Map<String, Offset> positions;
  final Map<String, String> labels;
  final String? selectedId;
  final Set<String> neighbours;
  final ColorScheme colors;

  Color _nodeColor(String type) => switch (type) {
    'rule' => const Color(0xFFEF4444),
    'skill' => const Color(0xFF10B981),
    'personal' => const Color(0xFFF59E0B),
    'project' => const Color(0xFF0EA5E9),
    'tag' => const Color(0xFFA855F7),
    _ => const Color(0xFF6366F1),
  };

  @override
  void paint(Canvas canvas, Size size) {
    final dimmed = selectedId != null;
    final edgePaint = Paint()
      ..color = colors.outlineVariant
      ..strokeWidth = 1.2;
    for (final edge in graph.edges) {
      final a = positions[edge.source];
      final b = positions[edge.target];
      if (a == null || b == null) continue;
      final active =
          !dimmed || (neighbours.contains(edge.source) && neighbours.contains(edge.target));
      edgePaint.color = dimmed && !active
          ? colors.outlineVariant.withValues(alpha: 0.2)
          : colors.outline;
      canvas.drawLine(a, b, edgePaint);
    }
    for (final node in graph.nodes) {
      final position = positions[node.id];
      if (position == null) continue;
      final isSelected = node.id == selectedId;
      final isNeighbour = neighbours.contains(node.id);
      final color = _nodeColor(node.nodeType);
      final paint = Paint()
        ..color = dimmed && !isSelected && !isNeighbour ? color.withValues(alpha: 0.25) : color;
      canvas.drawCircle(position, isSelected ? 16 : 12, paint);
      if (isSelected) {
        canvas.drawCircle(
          position,
          16,
          Paint()
            ..color = colors.primary
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5,
        );
      }
      final label = labels[node.id] ?? '';
      if (label.isEmpty) continue;
      final painter = TextPainter(
        text: TextSpan(
          text: label.length > 24 ? '${label.substring(0, 24)}…' : label,
          style: TextStyle(
            fontSize: 11,
            color: dimmed && !isSelected && !isNeighbour
                ? colors.onSurface.withValues(alpha: 0.4)
                : colors.onSurface,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 140);
      painter.paint(canvas, position + const Offset(-70, 18));
    }
  }

  @override
  bool shouldRepaint(_GraphPainter oldDelegate) => true;
}

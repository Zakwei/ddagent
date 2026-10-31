import 'package:flutter/material.dart';

/// Fades the edges of a horizontal scroll row where more content lies past
/// them — a chip row cut at the screen edge otherwise read as clipped, not
/// as scrollable. Wrap the row's horizontal scrollable directly.
class HorizontalEdgeFade extends StatefulWidget {
  const HorizontalEdgeFade({super.key, required this.child, this.extent = 24});

  final Widget child;

  /// Width of each fade, in logical pixels.
  final double extent;

  @override
  State<HorizontalEdgeFade> createState() => _HorizontalEdgeFadeState();
}

class _HorizontalEdgeFadeState extends State<HorizontalEdgeFade> {
  var _start = false;
  var _end = false;

  bool _onMetrics(ScrollMetrics m) {
    if (m.axis != Axis.horizontal) return false;
    final start = m.pixels > m.minScrollExtent + 0.5;
    final end = m.pixels < m.maxScrollExtent - 0.5;
    if (start != _start || end != _end) {
      setState(() {
        _start = start;
        _end = end;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (n) => n.depth == 0 && _onMetrics(n.metrics),
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) => n.depth == 0 && _onMetrics(n.metrics),
        child: ShaderMask(
          blendMode: BlendMode.dstIn,
          shaderCallback: (bounds) {
            final f = bounds.width <= 0 ? 0.0 : (widget.extent / bounds.width).clamp(0.0, 0.5);
            return LinearGradient(
              colors: [
                _start ? Colors.transparent : Colors.black,
                Colors.black,
                Colors.black,
                _end ? Colors.transparent : Colors.black,
              ],
              stops: [0, f, 1 - f, 1],
            ).createShader(bounds);
          },
          child: widget.child,
        ),
      ),
    );
  }
}

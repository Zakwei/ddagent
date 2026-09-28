import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/features/quota/view/quota_tone.dart';
import 'package:flutter/material.dart';

/// Inline sparkline for account history (port of quota/Sparkline.tsx):
/// one filled polyline in the tone colour; a flat midline when there is not
/// enough history to draw.
class QuotaSparkline extends StatelessWidget {
  const QuotaSparkline({
    super.key,
    required this.points,
    this.tone = QuotaTone.neutral,
    this.height = 24,
  });

  final List<double> points;
  final QuotaTone tone;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(
      painter: _SparklinePainter(
        points,
        quotaToneColor(tone),
        context.appColors.border,
      ),
    ),
  );
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.points, this.color, this.gridColor);

  final List<double> points;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) {
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        Paint()..color = gridColor,
      );
      return;
    }
    final step = size.width / (points.length - 1);
    Offset at(int i) {
      final v = points[i].clamp(0, 100);
      return Offset(i * step, size.height - v / 100 * size.height);
    }

    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < points.length; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_SparklinePainter old) =>
      old.points != points || old.color != color;
}

/// Daily token/cost trend (port of quota/TrendChart.tsx): series toggle,
/// hide toggle, dashed mid/zero guides, tap a point to pin its readout.
class QuotaTrendChart extends StatefulWidget {
  const QuotaTrendChart({super.key, required this.trend});

  final List<UsageTrendPoint> trend;

  @override
  State<QuotaTrendChart> createState() => _QuotaTrendChartState();
}

class _QuotaTrendChartState extends State<QuotaTrendChart> {
  bool _cost = false;
  bool _hidden = false;
  int? _selected;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final values = [
      for (final p in widget.trend)
        _cost ? p.costUsd : p.tokensTotal.toDouble(),
    ];
    final max = values.fold<double>(1, (m, v) => v > m ? v : m);
    final fmt = _cost ? formatCost : formatTokens;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (i, label) in const ['Tokens', 'Cost'].indexed)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: ChoiceChip(
                  label: Text(label),
                  selected: _cost == (i == 1),
                  onSelected: (_) => setState(() => _cost = i == 1),
                  visualDensity: VisualDensity.compact,
                  labelStyle: t.labelSmall,
                ),
              ),
            const Spacer(),
            InkWell(
              onTap: () => setState(() => _hidden = !_hidden),
              child: Text(
                _hidden ? 'Show' : 'Hide',
                style: t.labelSmall?.copyWith(color: c.mutedForeground),
              ),
            ),
          ],
        ),
        if (!_hidden) ...[
          const SizedBox(height: AppSpacing.xs),
          if (widget.trend.length < 2)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Center(
                child: Text(
                  'Not enough data for a trend.',
                  style: t.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const h = 160.0;
                const pad = 8.0;
                const labelW = 52.0;
                final w = constraints.maxWidth - labelW;
                final step = values.length > 1
                    ? (w - pad * 2) / (values.length - 1)
                    : 0.0;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: h,
                      child: Row(
                        children: [
                          SizedBox(
                            width: labelW,
                            child: Stack(
                              children: [
                                for (final (i, v) in [
                                  max,
                                  max / 2,
                                  0.0,
                                ].indexed)
                                  Positioned(
                                    top: [pad, h / 2, h - pad][i] - 6,
                                    right: 4,
                                    child: Text(
                                      fmt(v),
                                      style: t.labelSmall?.copyWith(
                                        fontSize: 9,
                                        color: c.mutedForeground,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTapDown: (e) {
                                if (values.length < 2) return;
                                final i = ((e.localPosition.dx - pad) / step)
                                    .round()
                                    .clamp(0, values.length - 1);
                                setState(() => _selected = i);
                              },
                              child: CustomPaint(
                                painter: _TrendPainter(
                                  values: values,
                                  color: quotaToneColor(QuotaTone.info),
                                  gridColor: c.border,
                                  padding: pad,
                                  selected: _selected,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selected != null)
                      Padding(
                        padding: const EdgeInsets.only(left: labelW, top: 2),
                        child: Text(
                          '${widget.trend[_selected!].date} · '
                          '${formatTokens(widget.trend[_selected!].tokensTotal)} tokens · '
                          '${formatCost(widget.trend[_selected!].costUsd)}',
                          style: t.labelSmall?.copyWith(
                            color: quotaToneColor(QuotaTone.info),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: labelW, top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (final p in _axisLabels(widget.trend))
                            Text(
                              formatDayLabel(p.date),
                              style: t.labelSmall?.copyWith(
                                fontSize: 9,
                                color: c.mutedForeground,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ],
    );
  }

  List<UsageTrendPoint> _axisLabels(List<UsageTrendPoint> trend) {
    if (trend.length <= 12) return trend;
    final every = (trend.length / 10).ceil();
    return [for (var i = 0; i < trend.length; i += every) trend[i]];
  }
}

class _TrendPainter extends CustomPainter {
  _TrendPainter({
    required this.values,
    required this.color,
    required this.gridColor,
    required this.padding,
    this.selected,
  });

  final List<double> values;
  final Color color;
  final Color gridColor;
  final double padding;
  final int? selected;

  @override
  void paint(Canvas canvas, Size size) {
    final max = values.fold<double>(1, (m, v) => v > m ? v : m);
    final step = values.length > 1
        ? (size.width - padding * 2) / (values.length - 1)
        : 0.0;
    Offset at(int i) => Offset(
      padding + i * step,
      size.height - padding - values[i] / max * (size.height - padding * 2),
    );

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final y in [padding, size.height / 2, size.height - padding]) {
      _dashedLine(
        canvas,
        Offset(padding, y),
        Offset(size.width - padding, y),
        grid,
      );
    }
    if (values.length < 2) return;

    final line = Path()..moveTo(at(0).dx, at(0).dy);
    for (var i = 1; i < values.length; i++) {
      line.lineTo(at(i).dx, at(i).dy);
    }
    final fill = Path.from(line)
      ..lineTo(size.width - padding, size.height - padding)
      ..lineTo(padding, size.height - padding)
      ..close();
    canvas.drawPath(fill, Paint()..color = color.withValues(alpha: 0.15));
    canvas.drawPath(
      line,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    for (var i = 0; i < values.length; i++) {
      canvas.drawCircle(at(i), i == selected ? 4.5 : 3, Paint()..color = color);
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 4.0;
    final total = (b - a).distance;
    var d = 0.0;
    while (d < total) {
      final from = Offset.lerp(a, b, d / total)!;
      final to = Offset.lerp(a, b, (d + dash).clamp(0, total) / total)!;
      canvas.drawLine(from, to, paint);
      d += dash * 2;
    }
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.values != values || old.selected != selected;
}

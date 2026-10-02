import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:flutter/widgets.dart';

/// Pane-header sizing. Desktop keeps the web's dense 28px bar; compact
/// (touch/mobile) grows to a 40px hit target so the header icons — export,
/// review, search, history, close — are actually tappable.
({double barHeight, double hit, double icon}) paneHeaderMetrics(
  BuildContext context,
) => context.breakpoint.isCompact
    ? (barHeight: 44, hit: 40, icon: 20)
    : (barHeight: 28, hit: 16, icon: 13);

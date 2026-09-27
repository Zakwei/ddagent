import 'package:flutter/widgets.dart';

/// Responsive breakpoints driving the navigation shell (3.5):
/// compact <600, medium 600–1200, expanded >1200.
enum AppBreakpoint { compact, medium, expanded }

extension AppBreakpointX on AppBreakpoint {
  bool get isCompact => this == AppBreakpoint.compact;
  bool get isMedium => this == AppBreakpoint.medium;
  bool get isExpanded => this == AppBreakpoint.expanded;
}

abstract final class AppBreakpoints {
  static const double compactMax = 600;
  static const double mediumMax = 1200;

  static AppBreakpoint of(BuildContext context) => forWidth(MediaQuery.sizeOf(context).width);

  static AppBreakpoint forWidth(double width) => width < compactMax
      ? AppBreakpoint.compact
      : width <= mediumMax
      ? AppBreakpoint.medium
      : AppBreakpoint.expanded;
}

extension BreakpointContext on BuildContext {
  AppBreakpoint get breakpoint => AppBreakpoints.of(this);
}

import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';

/// A [ScrollBehavior] that removes [PointerDeviceKind.mouse] from the set of
/// drag devices, so that mouse-drag gestures are not consumed by scrollable
/// parents — allowing children like [SelectableText] to handle click-drag for
/// text selection without the scroll view stealing the gesture.
///
/// Desktop users still scroll via mouse wheel / trackpad, which is unaffected.
/// Touch-based drag scrolling is preserved for mobile.
class _NoMouseDragScrollBehavior extends MaterialScrollBehavior {
  const _NoMouseDragScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
    PointerDeviceKind.unknown,
    // PointerDeviceKind.mouse intentionally omitted — mouse-drag
    // should trigger text selection, not scrolling.
    // PointerDeviceKind.trackpad omitted — two-finger scroll is
    // handled by the scroll-signal path, not as a drag.
  };
}

/// Wraps [child] in a [ScrollConfiguration] that disables mouse-drag
/// scrolling, preventing the scrollable parent from stealing text-selection
/// drag gestures from [SelectableText] children.
///
/// Usage: wrap the scrollable widget (e.g. `ListView`, `CustomScrollView`,
/// `ScrollablePositionedList`) that contains `SelectableText` descendants.
///
/// ```dart
/// TextSelectionScrollWrapper(
///   child: ListView.builder(...),
/// )
/// ```
class TextSelectionScrollWrapper extends StatelessWidget {
  const TextSelectionScrollWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(behavior: const _NoMouseDragScrollBehavior(), child: child);
  }
}

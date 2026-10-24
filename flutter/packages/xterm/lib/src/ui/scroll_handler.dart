import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:xterm/core.dart';
import 'package:xterm/src/ui/infinite_scroll_view.dart';

/// Handles scrolling gestures in the alternate screen buffer — and, as in
/// xterm, wherever the application asked for mouse wheel reports (ddagent
/// change: upstream sent them from the alternate buffer only). There the
/// scroll gestures are converted to escape sequences based on the current
/// report mode declared by the application.
///
/// While the application scrolls, the terminal's own scrollable refuses the
/// wheel and finger drags (ddagent change): with scrollback behind a program
/// that reports the mouse — Claude Code whose alt-screen switch was lost in a
/// replay — the inner scrollable used to take the wheel first and the program
/// never saw it. Shift+wheel still moves that scrollback, as in xterm.
class TerminalScrollGestureHandler extends StatefulWidget {
  const TerminalScrollGestureHandler({
    super.key,
    required this.terminal,
    required this.getCellOffset,
    required this.getLineHeight,
    this.simulateScroll = true,
    this.scrollController,
    required this.child,
  });

  final Terminal terminal;

  /// Returns the cell offset for the global pixel offset.
  final CellOffset Function(Offset) getCellOffset;

  /// Returns the pixel height of lines in the terminal.
  final double Function() getLineHeight;

  /// Whether to simulate scroll events in the terminal when the application
  /// doesn't declare it supports mouse wheel events. true by default as it
  /// is the default behavior of most terminals.
  final bool simulateScroll;

  /// The terminal's own scrollable, moved by Shift+wheel while the
  /// application scrolls.
  final ScrollController? scrollController;

  final Widget child;

  @override
  State<TerminalScrollGestureHandler> createState() =>
      _TerminalScrollGestureHandlerState();
}

class _TerminalScrollGestureHandlerState
    extends State<TerminalScrollGestureHandler> {
  /// Whether scroll gestures go to the application: it is in the alternate
  /// screen buffer or reports the mouse wheel. If false, this widget does nothing.
  var isAltBuffer = false;

  bool get _appScrolls =>
      widget.terminal.isUsingAltBuffer || widget.terminal.mouseMode.reportScroll;

  /// The variable that tracks the line offset in last scroll event. Used to
  /// determine how many the scroll events should be sent to the terminal.
  var lastLineOffset = 0;

  /// This variable tracks the last offset where the scroll gesture started.
  /// Used to calculate the cell offset of the terminal mouse event.
  var lastPointerPosition = Offset.zero;

  @override
  void initState() {
    widget.terminal.addListener(_onTerminalUpdated);
    isAltBuffer = _appScrolls;
    super.initState();
  }

  @override
  void dispose() {
    widget.terminal.removeListener(_onTerminalUpdated);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant TerminalScrollGestureHandler oldWidget) {
    if (oldWidget.terminal != widget.terminal) {
      oldWidget.terminal.removeListener(_onTerminalUpdated);
      widget.terminal.addListener(_onTerminalUpdated);
      isAltBuffer = _appScrolls;
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onTerminalUpdated() {
    if (isAltBuffer != _appScrolls) {
      isAltBuffer = _appScrolls;
      setState(() {});
    }
  }

  /// Send a single scroll event to the terminal. If [simulateScroll] is true,
  /// then if the application doesn't recognize mouse wheel events, this method
  /// will simulate scroll events by sending up/down arrow keys.
  void _sendScrollEvent(bool up) {
    final position = widget.getCellOffset(lastPointerPosition);

    final handled = widget.terminal.mouseInput(
      up ? TerminalMouseButton.wheelUp : TerminalMouseButton.wheelDown,
      TerminalMouseButtonState.down,
      position,
    );

    if (!handled && widget.simulateScroll) {
      widget.terminal.keyInput(
        up ? TerminalKey.arrowUp : TerminalKey.arrowDown,
      );
    }
  }

  /// Shift+wheel moves the terminal's own scrollback instead of the program.
  /// A Flutter scrollable reads the wheel's horizontal delta while Shift is
  /// held, so neither scrollable claims the event — this handler does.
  void _onPointerSignal(PointerSignalEvent event) {
    lastPointerPosition = event.position;
    final controller = widget.scrollController;
    if (event is! PointerScrollEvent ||
        !HardwareKeyboard.instance.isShiftPressed ||
        controller == null ||
        !controller.hasClients) {
      return;
    }
    GestureBinding.instance.pointerSignalResolver.register(event, (event) {
      final position = controller.position;
      position.jumpTo(
        (position.pixels + (event as PointerScrollEvent).scrollDelta.dy)
            .clamp(position.minScrollExtent, position.maxScrollExtent),
      );
    });
  }

  void _onScroll(double offset) {
    final currentLineOffset = offset ~/ widget.getLineHeight();

    final delta = currentLineOffset - lastLineOffset;

    for (var i = 0; i < delta.abs(); i++) {
      _sendScrollEvent(delta < 0);
    }

    lastLineOffset = currentLineOffset;
  }

  @override
  Widget build(BuildContext context) {
    if (!isAltBuffer) {
      return widget.child;
    }

    return Listener(
      onPointerSignal: _onPointerSignal,
      onPointerDown: (event) {
        lastPointerPosition = event.position;
      },
      child: InfiniteScrollView(
        onScroll: _onScroll,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const NeverScrollableScrollPhysics(),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

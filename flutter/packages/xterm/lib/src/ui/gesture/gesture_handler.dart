import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:xterm/src/core/buffer/cell_offset.dart';
import 'package:xterm/src/core/mouse/button.dart';
import 'package:xterm/src/core/mouse/button_state.dart';
import 'package:xterm/src/terminal_view.dart';
import 'package:xterm/src/ui/controller.dart';
import 'package:xterm/src/ui/gesture/gesture_detector.dart';
import 'package:xterm/src/ui/pointer_input.dart';
import 'package:xterm/src/ui/render.dart';

class TerminalGestureHandler extends StatefulWidget {
  const TerminalGestureHandler({
    super.key,
    required this.terminalView,
    required this.terminalController,
    this.child,
    this.onTapUp,
    this.onSingleTapUp,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.readOnly = false,
  });

  final TerminalViewState terminalView;

  final TerminalController terminalController;

  final Widget? child;

  final GestureTapUpCallback? onTapUp;

  final GestureTapUpCallback? onSingleTapUp;

  final GestureTapDownCallback? onTapDown;

  final GestureTapDownCallback? onSecondaryTapDown;

  final GestureTapUpCallback? onSecondaryTapUp;

  final GestureTapDownCallback? onTertiaryTapDown;

  final GestureTapUpCallback? onTertiaryTapUp;

  final bool readOnly;

  @override
  State<TerminalGestureHandler> createState() => _TerminalGestureHandlerState();
}

class _TerminalGestureHandlerState extends State<TerminalGestureHandler> {
  TerminalViewState get terminalView => widget.terminalView;

  RenderTerminal get renderTerminal => terminalView.renderTerminal;

  DragStartDetails? _lastDragStartDetails;

  LongPressStartDetails? _lastLongPressStartDetails;

  /// Where the left press in flight was reported to the application, or null
  /// when none was (ddagent change). A mouse drag then reports its motion and
  /// its release too, as xterm does: a program that tracks the mouse (Claude
  /// Code selects transcript text from press / motion / release) otherwise
  /// saw a press that never ended.
  Offset? _reportedPress;

  /// The left press was released by [onDragCancel]; the tap-up that follows
  /// must not release it again.
  bool _pressReleasedByCancel = false;

  /// Last cell a drag was reported at — one report per cell, not per pixel.
  CellOffset? _reportedDragCell;

  @override
  Widget build(BuildContext context) {
    return TerminalGestureDetector(
      child: widget.child,
      onSingleTapUp: onSingleTapUp,
      onTapDown: onTapDown,
      onSecondaryTapDown: onSecondaryTapDown,
      onSecondaryTapUp: onSecondaryTapUp,
      onTertiaryTapDown: onSecondaryTapDown,
      onTertiaryTapUp: onSecondaryTapUp,
      onLongPressStart: onLongPressStart,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      // onLongPressUp: onLongPressUp,
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      onDragCancel: onDragCancel,
      onDoubleTapDown: onDoubleTapDown,
    );
  }

  bool get _shouldSendTapEvent =>
      !widget.readOnly &&
      widget.terminalController.shouldSendPointerInput(PointerInput.tap);

  /// A finger's press is reported together with its release, on the
  /// completed tap: tap-down fires for a finger that rests before a scroll
  /// too, and that press would never get its release.
  static bool _isTouch(PointerDeviceKind? kind) =>
      kind == PointerDeviceKind.touch || kind == PointerDeviceKind.stylus;

  void _tapDown(
    GestureTapDownCallback? callback,
    TapDownDetails details,
    TerminalMouseButton button, {
    bool forceCallback = false,
  }) {
    if (button == TerminalMouseButton.left) _pressReleasedByCancel = false;
    // Check if the terminal should and can handle the tap down event.
    var handled = false;
    if (_shouldSendTapEvent && !_isTouch(details.kind)) {
      handled = renderTerminal.mouseEvent(
        button,
        TerminalMouseButtonState.down,
        details.localPosition,
      );
      if (handled && button == TerminalMouseButton.left) {
        _reportedPress = details.localPosition;
      }
    }
    // If the event was not handled by the terminal, use the supplied callback.
    if (!handled || forceCallback) {
      callback?.call(details);
    }
  }

  void _tapUp(
    GestureTapUpCallback? callback,
    TapUpDetails details,
    TerminalMouseButton button, {
    bool forceCallback = false,
  }) {
    // Check if the terminal should and can handle the tap up event.
    var handled = false;
    if (button == TerminalMouseButton.left && _pressReleasedByCancel) {
      // A slow click's press was released when its drag was cancelled.
      _pressReleasedByCancel = false;
      handled = true;
    } else if (_shouldSendTapEvent) {
      if (_isTouch(details.kind)) {
        renderTerminal.mouseEvent(
          button,
          TerminalMouseButtonState.down,
          details.localPosition,
        );
      }
      handled = renderTerminal.mouseEvent(
        button,
        TerminalMouseButtonState.up,
        details.localPosition,
      );
      if (button == TerminalMouseButton.left) _reportedPress = null;
    }
    // If the event was not handled by the terminal, use the supplied callback.
    if (!handled || forceCallback) {
      callback?.call(details);
    }
  }

  /// Reports the release of the press in flight, if any, at [position].
  void _releaseReportedPress(Offset position) {
    if (_reportedPress == null) return;
    _reportedPress = null;
    _reportedDragCell = null;
    renderTerminal.mouseEvent(
      TerminalMouseButton.left,
      TerminalMouseButtonState.up,
      position,
    );
  }

  void onTapDown(TapDownDetails details) {
    // onTapDown is special, as it will always call the supplied callback.
    // The TerminalView depends on it to bring the terminal into focus.
    _tapDown(
      widget.onTapDown,
      details,
      TerminalMouseButton.left,
      forceCallback: true,
    );
  }

  /// Also runs the view's [onTapUp] (links, the soft keyboard after a finger
  /// tap): it sat in a detector slot nothing calls (ddagent change). A
  /// finger tap always reaches it — the keyboard must open even while the
  /// program tracks the mouse.
  void onSingleTapUp(TapUpDetails details) {
    _tapUp(
      (details) {
        widget.onSingleTapUp?.call(details);
        widget.onTapUp?.call(details);
      },
      details,
      TerminalMouseButton.left,
      forceCallback: _isTouch(details.kind),
    );
  }

  void onSecondaryTapDown(TapDownDetails details) {
    _tapDown(widget.onSecondaryTapDown, details, TerminalMouseButton.right);
  }

  void onSecondaryTapUp(TapUpDetails details) {
    _tapUp(widget.onSecondaryTapUp, details, TerminalMouseButton.right);
  }

  void onTertiaryTapDown(TapDownDetails details) {
    _tapDown(widget.onTertiaryTapDown, details, TerminalMouseButton.middle);
  }

  void onTertiaryTapUp(TapUpDetails details) {
    _tapUp(widget.onTertiaryTapUp, details, TerminalMouseButton.right);
  }

  void onDoubleTapDown(TapDownDetails details) {
    renderTerminal.selectWord(details.localPosition);
  }

  void onLongPressStart(LongPressStartDetails details) {
    _lastLongPressStartDetails = details;
    renderTerminal.selectWord(details.localPosition);
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    renderTerminal.selectWord(
      _lastLongPressStartDetails!.localPosition,
      details.localPosition,
    );
  }

  // void onLongPressUp() {}

  void onDragStart(DragStartDetails details) {
    _lastDragStartDetails = details;

    // A quick drag starts before the tap deadline, so tap-down never ran.
    if (_shouldSendTapEvent &&
        !_isTouch(details.kind) &&
        _reportedPress == null &&
        renderTerminal.mouseEvent(
          TerminalMouseButton.left,
          TerminalMouseButtonState.down,
          details.localPosition,
        )) {
      _reportedPress = details.localPosition;
    }

    details.kind == PointerDeviceKind.mouse
        ? renderTerminal.selectCharacters(details.localPosition)
        : renderTerminal.selectWord(details.localPosition);
  }

  void onDragUpdate(DragUpdateDetails details) {
    if (_reportedPress != null) {
      final cell = renderTerminal.getCellOffset(details.localPosition);
      if (cell != _reportedDragCell) {
        _reportedDragCell = cell;
        renderTerminal.mouseEvent(
          TerminalMouseButton.left,
          TerminalMouseButtonState.move,
          details.localPosition,
        );
      }
    }

    renderTerminal.selectCharacters(
      _lastDragStartDetails!.localPosition,
      details.localPosition,
    );
  }

  void onDragEnd(DragEndDetails details) {
    _lastDragStartDetails = null;
    _releaseReportedPress(details.localPosition);
  }

  /// A press held still past the drag slop cancels the drag, then completes
  /// as a tap: release once, where it was pressed — a previous drag's stale
  /// start sent a second release at another cell (ddagent change).
  void onDragCancel() {
    _lastDragStartDetails = null;
    final pressed = _reportedPress;
    if (pressed == null) return;
    _releaseReportedPress(pressed);
    _pressReleasedByCancel = true;
  }
}

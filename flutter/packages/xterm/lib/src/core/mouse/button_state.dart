enum TerminalMouseButtonState {
  up,

  down,

  /// The pointer moved while the button was held (ddagent change: upstream
  /// has no drag reports). Reported only by the drag / any-motion modes.
  move,
}

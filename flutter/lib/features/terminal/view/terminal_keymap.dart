import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Terminal-level commands bound to keyboard chords. The bindings follow the
/// Windows Terminal defaults (`defaults.json`) so muscle memory carries over;
/// macOS gets the ⌘ equivalents the same way iTerm/Terminal.app bind them.
enum TerminalCommand {
  copy,
  paste,
  selectAll,
  clearSelection,
  find,
  newTab,
  closeTab,
  duplicateTab,
  nextTab,
  previousTab,
  selectTab,
  zoomIn,
  zoomOut,
  zoomReset,
  scrollUpLine,
  scrollDownLine,
  scrollUpPage,
  scrollDownPage,
  scrollToTop,
  scrollToBottom,
  commandMenu,
}

/// A resolved chord — [index] is only set for [TerminalCommand.selectTab].
typedef TerminalKeyBinding = ({TerminalCommand command, int? index});

/// Resolves the chord described by [key] + modifier flags to a terminal
/// command, or `null` when the chord should fall through to xterm (which
/// then forwards it to the PTY).
///
/// [hasSelection] matters for the keys that double as PTY input: Ctrl+C is a
/// copy only while text is selected (otherwise it must stay SIGINT) and Esc
/// only clears a selection instead of reaching the shell.
TerminalKeyBinding? resolveTerminalCommand({
  required LogicalKeyboardKey key,
  required bool control,
  required bool shift,
  required bool alt,
  required bool meta,
  required TargetPlatform platform,
  required bool hasSelection,
  bool isWeb = kIsWeb,
}) {
  TerminalKeyBinding bind(TerminalCommand command, [int? index]) =>
      (command: command, index: index);

  final apple = platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;

  // Escape with a selection drops the selection (WT `clearSelection`); with
  // no selection it is a plain Esc to the application in the terminal.
  if (key == LogicalKeyboardKey.escape && !control && !shift && !alt && !meta) {
    return hasSelection ? bind(TerminalCommand.clearSelection) : null;
  }

  // Shift+Insert / Ctrl+Insert — the classic X11/Windows clipboard keys.
  if (key == LogicalKeyboardKey.insert && !alt && !meta) {
    if (shift && !control) return bind(TerminalCommand.paste);
    if (control && !shift && hasSelection) return bind(TerminalCommand.copy);
  }

  if (apple) {
    if (!meta || control) return null;
    // ⌘ chords (Terminal.app / iTerm2 conventions).
    final digit = _digitOf(key);
    if (digit != null && !shift && !alt) return bind(TerminalCommand.selectTab, digit - 1);
    if (shift && !alt) {
      return switch (key) {
        LogicalKeyboardKey.bracketRight => bind(TerminalCommand.nextTab),
        LogicalKeyboardKey.bracketLeft => bind(TerminalCommand.previousTab),
        LogicalKeyboardKey.keyD => bind(TerminalCommand.duplicateTab),
        LogicalKeyboardKey.keyP => bind(TerminalCommand.commandMenu),
        LogicalKeyboardKey.arrowUp => bind(TerminalCommand.scrollUpLine),
        LogicalKeyboardKey.arrowDown => bind(TerminalCommand.scrollDownLine),
        LogicalKeyboardKey.pageUp => bind(TerminalCommand.scrollUpPage),
        LogicalKeyboardKey.pageDown => bind(TerminalCommand.scrollDownPage),
        LogicalKeyboardKey.home => bind(TerminalCommand.scrollToTop),
        LogicalKeyboardKey.end => bind(TerminalCommand.scrollToBottom),
        _ => null,
      };
    }
    if (alt) return null;
    return switch (key) {
      LogicalKeyboardKey.keyC => hasSelection ? bind(TerminalCommand.copy) : null,
      LogicalKeyboardKey.keyV => bind(TerminalCommand.paste),
      LogicalKeyboardKey.keyA => bind(TerminalCommand.selectAll),
      LogicalKeyboardKey.keyF => bind(TerminalCommand.find),
      LogicalKeyboardKey.keyT => bind(TerminalCommand.newTab),
      LogicalKeyboardKey.keyW => bind(TerminalCommand.closeTab),
      LogicalKeyboardKey.equal ||
      LogicalKeyboardKey.add ||
      LogicalKeyboardKey.numpadAdd => bind(TerminalCommand.zoomIn),
      LogicalKeyboardKey.minus ||
      LogicalKeyboardKey.numpadSubtract => bind(TerminalCommand.zoomOut),
      LogicalKeyboardKey.digit0 || LogicalKeyboardKey.numpad0 => bind(TerminalCommand.zoomReset),
      _ => null,
    };
  }

  if (!control || meta) return null;

  // Ctrl+Alt+1..9 — WT `switchToTab`. Browsers reserve Ctrl+Shift+T/W, so
  // web additionally takes Ctrl+Alt+T / Ctrl+Alt+W for new/close tab.
  if (alt && !shift) {
    final digit = _digitOf(key);
    if (digit != null) return bind(TerminalCommand.selectTab, digit - 1);
    if (isWeb) {
      if (key == LogicalKeyboardKey.keyT) return bind(TerminalCommand.newTab);
      if (key == LogicalKeyboardKey.keyW) return bind(TerminalCommand.closeTab);
    }
    return null;
  }
  if (alt) return null;

  if (shift) {
    return switch (key) {
      LogicalKeyboardKey.keyC => hasSelection ? bind(TerminalCommand.copy) : null,
      LogicalKeyboardKey.keyV => bind(TerminalCommand.paste),
      LogicalKeyboardKey.keyA => bind(TerminalCommand.selectAll),
      LogicalKeyboardKey.keyF => bind(TerminalCommand.find),
      LogicalKeyboardKey.keyT => bind(TerminalCommand.newTab),
      LogicalKeyboardKey.keyW => bind(TerminalCommand.closeTab),
      LogicalKeyboardKey.keyD => bind(TerminalCommand.duplicateTab),
      LogicalKeyboardKey.keyP => bind(TerminalCommand.commandMenu),
      LogicalKeyboardKey.tab => bind(TerminalCommand.previousTab),
      LogicalKeyboardKey.arrowUp => bind(TerminalCommand.scrollUpLine),
      LogicalKeyboardKey.arrowDown => bind(TerminalCommand.scrollDownLine),
      LogicalKeyboardKey.pageUp => bind(TerminalCommand.scrollUpPage),
      LogicalKeyboardKey.pageDown => bind(TerminalCommand.scrollDownPage),
      LogicalKeyboardKey.home => bind(TerminalCommand.scrollToTop),
      LogicalKeyboardKey.end => bind(TerminalCommand.scrollToBottom),
      // Ctrl+Shift+= is "Ctrl++" on US layouts.
      LogicalKeyboardKey.equal || LogicalKeyboardKey.add => bind(TerminalCommand.zoomIn),
      LogicalKeyboardKey.minus => bind(TerminalCommand.zoomOut),
      _ => null,
    };
  }

  return switch (key) {
    // Ctrl+C copies only with a selection — otherwise it is SIGINT.
    LogicalKeyboardKey.keyC => hasSelection ? bind(TerminalCommand.copy) : null,
    LogicalKeyboardKey.keyV => bind(TerminalCommand.paste),
    LogicalKeyboardKey.tab => bind(TerminalCommand.nextTab),
    LogicalKeyboardKey.pageDown => bind(TerminalCommand.nextTab),
    LogicalKeyboardKey.pageUp => bind(TerminalCommand.previousTab),
    LogicalKeyboardKey.equal ||
    LogicalKeyboardKey.add ||
    LogicalKeyboardKey.numpadAdd => bind(TerminalCommand.zoomIn),
    LogicalKeyboardKey.minus || LogicalKeyboardKey.numpadSubtract => bind(TerminalCommand.zoomOut),
    LogicalKeyboardKey.digit0 || LogicalKeyboardKey.numpad0 => bind(TerminalCommand.zoomReset),
    _ => null,
  };
}

int? _digitOf(LogicalKeyboardKey key) {
  const digits = [
    LogicalKeyboardKey.digit1,
    LogicalKeyboardKey.digit2,
    LogicalKeyboardKey.digit3,
    LogicalKeyboardKey.digit4,
    LogicalKeyboardKey.digit5,
    LogicalKeyboardKey.digit6,
    LogicalKeyboardKey.digit7,
    LogicalKeyboardKey.digit8,
    LogicalKeyboardKey.digit9,
  ];
  final index = digits.indexOf(key);
  return index == -1 ? null : index + 1;
}

/// Human-readable chord for menus/tooltips (`Ctrl+Shift+T`, `⌘T`).
String terminalShortcutLabel(TerminalCommand command, TargetPlatform platform) {
  final apple = platform == TargetPlatform.macOS || platform == TargetPlatform.iOS;
  if (apple) {
    return switch (command) {
      TerminalCommand.copy => '⌘C',
      TerminalCommand.paste => '⌘V',
      TerminalCommand.selectAll => '⌘A',
      TerminalCommand.clearSelection => 'Esc',
      TerminalCommand.find => '⌘F',
      TerminalCommand.newTab => '⌘T',
      TerminalCommand.closeTab => '⌘W',
      TerminalCommand.duplicateTab => '⌘⇧D',
      TerminalCommand.nextTab => '⌘⇧]',
      TerminalCommand.previousTab => '⌘⇧[',
      TerminalCommand.selectTab => '⌘1…9',
      TerminalCommand.zoomIn => '⌘+',
      TerminalCommand.zoomOut => '⌘−',
      TerminalCommand.zoomReset => '⌘0',
      TerminalCommand.scrollUpLine => '⌘⇧↑',
      TerminalCommand.scrollDownLine => '⌘⇧↓',
      TerminalCommand.scrollUpPage => '⌘⇧PgUp',
      TerminalCommand.scrollDownPage => '⌘⇧PgDn',
      TerminalCommand.scrollToTop => '⌘⇧Home',
      TerminalCommand.scrollToBottom => '⌘⇧End',
      TerminalCommand.commandMenu => '⌘⇧P',
    };
  }
  return switch (command) {
    TerminalCommand.copy => 'Ctrl+Shift+C',
    TerminalCommand.paste => 'Ctrl+Shift+V',
    TerminalCommand.selectAll => 'Ctrl+Shift+A',
    TerminalCommand.clearSelection => 'Esc',
    TerminalCommand.find => 'Ctrl+Shift+F',
    TerminalCommand.newTab => 'Ctrl+Shift+T',
    TerminalCommand.closeTab => 'Ctrl+Shift+W',
    TerminalCommand.duplicateTab => 'Ctrl+Shift+D',
    TerminalCommand.nextTab => 'Ctrl+Tab',
    TerminalCommand.previousTab => 'Ctrl+Shift+Tab',
    TerminalCommand.selectTab => 'Ctrl+Alt+1…9',
    TerminalCommand.zoomIn => 'Ctrl++',
    TerminalCommand.zoomOut => 'Ctrl+-',
    TerminalCommand.zoomReset => 'Ctrl+0',
    TerminalCommand.scrollUpLine => 'Ctrl+Shift+↑',
    TerminalCommand.scrollDownLine => 'Ctrl+Shift+↓',
    TerminalCommand.scrollUpPage => 'Ctrl+Shift+PgUp',
    TerminalCommand.scrollDownPage => 'Ctrl+Shift+PgDn',
    TerminalCommand.scrollToTop => 'Ctrl+Shift+Home',
    TerminalCommand.scrollToBottom => 'Ctrl+Shift+End',
    TerminalCommand.commandMenu => 'Ctrl+Shift+P',
  };
}

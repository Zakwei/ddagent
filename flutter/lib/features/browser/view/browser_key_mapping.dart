import 'package:flutter/services.dart';

/// One `/browser-view` `key` message derived from a Flutter [KeyEvent].
///
/// Shared by the browser pane and the app-preview pane so both forward
/// keyboard input to the server-side Chromium the same way.
class BrowserKeyPayload {
  const BrowserKeyPayload({
    required this.key,
    required this.modifiers,
    this.code,
    this.keyCode,
    this.text,
  });

  final String key;
  final String? code;
  final int? keyCode;
  final String? text;

  /// CDP modifier bitmask (Alt=1, Ctrl=2, Meta=4, Shift=8).
  final int modifiers;
}

/// Windows virtual-key codes CDP needs for editing/navigation keys —
/// Flutter's `keyId` for these is a plane-prefixed id Chromium ignores.
const browserVirtualKeyCodes = <String, int>{
  'Backspace': 8,
  'Tab': 9,
  'Enter': 13,
  'Escape': 27,
  'PageUp': 33,
  'PageDown': 34,
  'End': 35,
  'Home': 36,
  'ArrowLeft': 37,
  'ArrowUp': 38,
  'ArrowRight': 39,
  'ArrowDown': 40,
  'Insert': 45,
  'Delete': 46,
};

/// Current hardware modifier state as the CDP bitmask.
int browserKeyModifiers() =>
    (HardwareKeyboard.instance.isAltPressed ? 1 : 0) |
    (HardwareKeyboard.instance.isControlPressed ? 2 : 0) |
    (HardwareKeyboard.instance.isMetaPressed ? 4 : 0) |
    (HardwareKeyboard.instance.isShiftPressed ? 8 : 0);

/// Maps a Flutter key event (`phase` = `down` | `up`) onto the fields the
/// server's `dispatchKey` expects.
///
/// `keyLabel` is the key cap ("A", "1"), not the typed character — the real
/// text (case, Shift symbols, AltGr letters like "ą") is `character`. AltGr
/// reports as Ctrl+Alt, so it still counts as text. Enter only submits forms
/// when the keydown carries "\r".
BrowserKeyPayload browserKeyPayload(KeyEvent e, String phase, {int? modifiers}) {
  var mods = modifiers ?? browserKeyModifiers();
  final char = e.character;
  final altGr = (mods & (1 | 2 | 4)) == (1 | 2);
  final printable =
      char != null &&
      char.isNotEmpty &&
      char.codeUnitAt(0) >= 0x20 &&
      char.codeUnitAt(0) != 0x7f &&
      ((mods & (1 | 2 | 4)) == 0 || altGr);
  if (printable && altGr) mods &= ~(1 | 2);
  final id = e.logicalKey.keyId;
  final named = e.logicalKey.keyLabel.replaceAll(' ', ''); // "Arrow Left" → DOM "ArrowLeft"
  final key = printable ? char : (id < 0x80 ? String.fromCharCode(id) : named);
  final keyCode = id >= 0x61 && id <= 0x7a
      ? id -
            0x20 // a-z → VK_A..VK_Z
      : id < 0x80
      ? id
      : browserVirtualKeyCodes[named];
  return BrowserKeyPayload(
    key: key,
    code: id >= 0x61 && id <= 0x7a
        ? 'Key${String.fromCharCode(id - 0x20)}'
        : id >= 0x30 && id <= 0x39
        ? 'Digit${String.fromCharCode(id)}'
        : (browserVirtualKeyCodes.containsKey(named) ? named : null),
    keyCode: keyCode,
    text: phase == 'down' ? (printable ? char : (named == 'Enter' ? '\r' : null)) : null,
    modifiers: mods,
  );
}

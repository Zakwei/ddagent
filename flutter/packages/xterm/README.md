# xterm.dart 4.0.0 (vendored)

Upstream: https://github.com/TerminalStudio/xterm.dart, version 4.0.0 from
pub.dev, MIT (see LICENSE). Used through `dependency_overrides` in
`flutter/pubspec.yaml`.

Changes in `lib/src/ui/custom_text_edit.dart`:

- The IME connection opens with `enableIMEPersonalizedLearning: true`.
  Upstream passes `false`, which Android sends as
  `IME_FLAG_NO_PERSONALIZED_LEARNING`: Gboard then runs in incognito mode,
  where voice typing is unavailable — the microphone was greyed out.
- `updateEditingValue` sends the difference against the text already sent
  instead of resetting the IME field after every commit. An app-side reset
  mid-dictation ends Gboard voice typing (cut off in the first word), and a
  multi-character IME rewrite used to send a single backspace. The field is
  reset only after Enter or once the delete-detection padding is deleted.

Change in `lib/src/ui/scroll_handler.dart`:

- Scroll gestures go to the application whenever it reports the mouse wheel,
  not only in the alternate screen buffer — xterm behaviour. Claude Code in a
  session whose alt-screen switch was lost (adopted after a server restart)
  otherwise never scrolled: a finger moved an empty scrollback instead.

To upgrade, copy the new upstream `lib/` here and re-apply those changes
(`test/terminal_ime_config_test.dart`, `test/terminal_ime_dictation_test.dart` and
`test/terminal_mouse_scroll_test.dart` guard them).

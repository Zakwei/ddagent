# xterm.dart 4.0.0 (vendored)

Upstream: https://github.com/TerminalStudio/xterm.dart, version 4.0.0 from
pub.dev, MIT (see LICENSE). Used through `dependency_overrides` in
`flutter/pubspec.yaml`.

Only change: `lib/src/ui/custom_text_edit.dart` opens its IME connection with
`enableIMEPersonalizedLearning: true`. Upstream passes `false`, which Android
sends as `IME_FLAG_NO_PERSONALIZED_LEARNING`: Gboard then runs in incognito
mode, where voice typing is unavailable — the microphone was greyed out in
the terminal.

To upgrade, copy the new upstream `lib/` here and re-apply that change.

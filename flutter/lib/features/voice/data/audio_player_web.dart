import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Web plays synthesized MP3 through a single reusable `HTMLAudioElement`
/// pointed at a Blob object URL — the same mechanism the old client used for
/// `POST /api/tts` (see `voiceAutoRead.ts`).
const bool audioPlaybackSupported = true;

web.HTMLAudioElement? _current;
String? _currentUrl;
void Function()? _currentOnEnd;

/// Plays [bytes] as audio, revoking the previous Blob URL first. Resolves when
/// playback ends or errors; [onEnd] fires in either case and when [stopAudio]
/// interrupts playback.
Future<void> playAudio(Uint8List bytes, {void Function()? onEnd}) async {
  stopAudio();
  if (bytes.isEmpty) {
    onEnd?.call();
    return;
  }
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: 'audio/mpeg'));
  final url = web.URL.createObjectURL(blob);
  final audio = web.HTMLAudioElement();
  _current = audio;
  _currentUrl = url;
  _currentOnEnd = onEnd;
  final done = Completer<void>();
  void finish() {
    if (_current == audio) {
      _current = null;
      _currentUrl = null;
      _currentOnEnd = null;
    }
    if (!done.isCompleted) done.complete();
    onEnd?.call();
  }

  audio.onended = ((web.Event _) => finish()).toJS;
  audio.onerror = ((web.Event _) => finish()).toJS;
  audio.src = url;
  try {
    await audio.play().toDart;
  } on Object {
    finish();
  }
  await done.future;
}

/// Pauses the current element, revokes its Blob URL and runs its `onEnd`
/// hook so callers' "speaking" state resets.
void stopAudio() {
  final audio = _current;
  final onEnd = _currentOnEnd;
  _current = null;
  final url = _currentUrl;
  _currentUrl = null;
  _currentOnEnd = null;
  audio?.pause();
  if (url != null) web.URL.revokeObjectURL(url);
  onEnd?.call();
}

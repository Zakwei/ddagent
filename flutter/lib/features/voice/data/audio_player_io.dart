import 'dart:typed_data';

/// Whether this platform can play synthesized audio. Native has no bundled
/// audio plugin — read-aloud is web-only for now.
const bool audioPlaybackSupported = false;

/// No-op on native; there is nothing to play audio into.
Future<void> playAudio(Uint8List bytes, {void Function()? onEnd}) async {
  onEnd?.call();
}

/// No-op on native.
void stopAudio() {}

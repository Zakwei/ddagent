// Platform audio playback for synthesized TTS MP3.
// Web: `HTMLAudioElement` + Blob URL. Native: no-op stub (no audio plugin
// is bundled), so read-aloud is web-only for now.
export 'package:ddagent_app/features/voice/data/audio_player_io.dart'
    if (dart.library.js_interop) 'package:ddagent_app/features/voice/data/audio_player_web.dart';

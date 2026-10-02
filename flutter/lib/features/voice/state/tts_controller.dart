import 'dart:async';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/voice/data/audio_player.dart';
import 'package:ddagent_app/features/voice/data/voice_models.dart';
import 'package:ddagent_app/features/voice/data/voice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TtsPlaybackState {
  const TtsPlaybackState({
    this.voices = const [],
    this.preferredVoice = '',
    this.armedSessions = const {},
    this.isPlaying = false,
    this.currentMessageId,
    this.currentText,
    this.audioBytes,
    this.loading = false,
    this.error,
  });

  final List<TtsVoice> voices;
  final String preferredVoice;

  /// Session ids opted into "read replies aloud" (web
  /// `voiceAutoRead.armedSessions`) — persisted so the toggle survives reloads.
  final Set<String> armedSessions;
  final bool isPlaying;
  final String? currentMessageId;
  final String? currentText;
  final Uint8List? audioBytes;
  final bool loading;
  final String? error;

  bool isSpeakingMessage(String messageId) => isPlaying && currentMessageId == messageId;

  bool isArmed(String sessionId) => armedSessions.contains(sessionId);

  TtsPlaybackState copyWith({
    List<TtsVoice>? voices,
    String? preferredVoice,
    Set<String>? armedSessions,
    bool? isPlaying,
    String? Function()? currentMessageId,
    String? Function()? currentText,
    Uint8List? Function()? audioBytes,
    bool? loading,
    String? Function()? error,
  }) => TtsPlaybackState(
    voices: voices ?? this.voices,
    preferredVoice: preferredVoice ?? this.preferredVoice,
    armedSessions: armedSessions ?? this.armedSessions,
    isPlaying: isPlaying ?? this.isPlaying,
    currentMessageId: currentMessageId != null ? currentMessageId() : this.currentMessageId,
    currentText: currentText != null ? currentText() : this.currentText,
    audioBytes: audioBytes != null ? audioBytes() : this.audioBytes,
    loading: loading ?? this.loading,
    error: error != null ? error() : this.error,
  );
}

/// Raw markdown reads badly aloud — drop fenced code blocks, tag-like spans
/// and the characters that break the backend's SSML, flatten whitespace and
/// cap the payload. Port of the web client's `speechText`.
String ttsSpeechText(String raw) {
  const maxChars = 4000;
  final flat = raw
      .replaceAll(RegExp(r'```[\s\S]*?(?:```|$)'), ' ')
      .replaceAll(RegExp(r'<[a-zA-Z/][^>]{0,300}>'), ' ')
      .replaceAll(RegExp(r'[<&]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return flat.length > maxChars ? '${flat.substring(0, maxChars)}…' : flat;
}

class TtsController extends Notifier<TtsPlaybackState> {
  static const voiceStorageKey = 'voiceAutoRead.voiceName';
  static const armedStorageKey = 'voiceAutoRead.armedSessions';

  VoiceRepository get _repo => ref.read(voiceRepositoryProvider);

  /// Highest run `seq` already spoken per session — the same `complete` frame
  /// reaches every mounted pane, so auto-read dedupes by it (web parity).
  final _lastSpokenSeq = <String, int>{};

  @override
  TtsPlaybackState build() {
    String initialVoice = '';
    Set<String> armed = const {};
    try {
      if (Hive.isBoxOpen('settings')) {
        final box = Hive.box<dynamic>('settings');
        initialVoice = box.get(voiceStorageKey)?.toString() ?? '';
        final raw = box.get(armedStorageKey);
        if (raw is List) {
          armed = {
            for (final id in raw)
              if (id is String) id,
          };
        }
      }
    } on Exception {
      // Hive box not initialized in tests
    }

    unawaited(Future.microtask(loadVoices));
    return TtsPlaybackState(preferredVoice: initialVoice, armedSessions: armed);
  }

  Future<void> loadVoices() async {
    state = state.copyWith(loading: true);
    try {
      final voices = await _repo.getVoices();
      if (!ref.mounted) return;
      state = state.copyWith(voices: voices, loading: false);
    } on Exception {
      if (ref.mounted) state = state.copyWith(loading: false);
    }
  }

  void setPreferredVoice(String voiceId) {
    state = state.copyWith(preferredVoice: voiceId);
    _persist(voiceStorageKey, voiceId);
  }

  void setAutoReadArmed(String sessionId, bool armed) {
    final next = {...state.armedSessions};
    if (armed) {
      next.add(sessionId);
    } else {
      next.remove(sessionId);
    }
    state = state.copyWith(armedSessions: next);
    _persist(armedStorageKey, next.toList());
    if (!armed) stop();
  }

  bool toggleAutoRead(String sessionId) {
    final next = !state.isArmed(sessionId);
    setAutoReadArmed(sessionId, next);
    return next;
  }

  /// Called when a run completes: speaks [text] once per run `seq` if the
  /// session is armed (web `maybeSpeakCompletion`).
  void maybeSpeakCompletion(String sessionId, int seq, String text) {
    if (!state.isArmed(sessionId)) return;
    final last = _lastSpokenSeq[sessionId] ?? -1;
    if (last >= seq) return;
    _lastSpokenSeq[sessionId] = seq;
    if (text.isNotEmpty) unawaited(speak('auto-$sessionId-$seq', text));
  }

  Future<void> speak(String messageId, String text, {String? voice}) async {
    // If already playing this message, tapping it again stops playback.
    if (state.isSpeakingMessage(messageId)) {
      stop();
      return;
    }

    final voiceName = voice ?? (state.preferredVoice.isNotEmpty ? state.preferredVoice : null);

    state = state.copyWith(
      isPlaying: true,
      currentMessageId: () => messageId,
      currentText: () => text,
      audioBytes: () => null,
      error: () => null,
    );

    try {
      final bytes = await _repo.synthesizeSpeech(text, voice: voiceName);
      if (!ref.mounted) return;
      state = state.copyWith(audioBytes: () => bytes);
      // The bytes are the whole point — play them. `onEnd` clears the
      // speaking flag whether playback finished or was stopped.
      await ref.read(ttsPlayAudioProvider)(bytes, onEnd: _clearPlayback);
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isPlaying: false,
          currentMessageId: () => null,
          error: () => e.message,
        );
      }
    } on Exception catch (e) {
      if (ref.mounted) {
        state = state.copyWith(
          isPlaying: false,
          currentMessageId: () => null,
          error: () => e.toString(),
        );
      }
    }
  }

  void _clearPlayback() {
    if (!ref.mounted) return;
    state = state.copyWith(
      isPlaying: false,
      currentMessageId: () => null,
      currentText: () => null,
      audioBytes: () => null,
    );
  }

  void stop() {
    ref.read(ttsStopAudioProvider)();
    _clearPlayback();
  }

  void _persist(String key, Object value) {
    try {
      if (Hive.isBoxOpen('settings')) {
        Hive.box<dynamic>('settings').put(key, value);
      }
    } on Exception {
      // Best-effort persistence
    }
  }
}

final ttsControllerProvider = NotifierProvider<TtsController, TtsPlaybackState>(TtsController.new);

/// Playback seam — the audio backend is platform-only (a no-op on native, an
/// HTMLAudioElement on web), so tests override these to observe the speaking
/// flag while playback is "in flight".
typedef TtsPlayFn = Future<void> Function(Uint8List bytes, {void Function()? onEnd});
typedef TtsStopFn = void Function();

final ttsPlayAudioProvider = Provider<TtsPlayFn>((_) => playAudio);
final ttsStopAudioProvider = Provider<TtsStopFn>((_) => stopAudio);

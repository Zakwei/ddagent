import 'dart:async';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/voice/data/voice_models.dart';
import 'package:ddagent_app/features/voice/data/voice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TtsPlaybackState {
  const TtsPlaybackState({
    this.voices = const [],
    this.preferredVoice = '',
    this.isPlaying = false,
    this.currentMessageId,
    this.currentText,
    this.audioBytes,
    this.loading = false,
    this.error,
  });

  final List<TtsVoice> voices;
  final String preferredVoice;
  final bool isPlaying;
  final String? currentMessageId;
  final String? currentText;
  final Uint8List? audioBytes;
  final bool loading;
  final String? error;

  bool isSpeakingMessage(String messageId) =>
      isPlaying && currentMessageId == messageId;

  TtsPlaybackState copyWith({
    List<TtsVoice>? voices,
    String? preferredVoice,
    bool? isPlaying,
    String? Function()? currentMessageId,
    String? Function()? currentText,
    Uint8List? Function()? audioBytes,
    bool? loading,
    String? Function()? error,
  }) =>
      TtsPlaybackState(
        voices: voices ?? this.voices,
        preferredVoice: preferredVoice ?? this.preferredVoice,
        isPlaying: isPlaying ?? this.isPlaying,
        currentMessageId: currentMessageId != null
            ? currentMessageId()
            : this.currentMessageId,
        currentText:
            currentText != null ? currentText() : this.currentText,
        audioBytes:
            audioBytes != null ? audioBytes() : this.audioBytes,
        loading: loading ?? this.loading,
        error: error != null ? error() : this.error,
      );
}

class TtsController extends Notifier<TtsPlaybackState> {
  static const voiceStorageKey = 'voiceAutoRead.voiceName';

  VoiceRepository get _repo => ref.read(voiceRepositoryProvider);

  @override
  TtsPlaybackState build() {
    String initialVoice = '';
    try {
      if (Hive.isBoxOpen('settings')) {
        initialVoice = Hive.box<dynamic>('settings').get(voiceStorageKey)?.toString() ?? '';
      }
    } on Exception {
      // Hive box not initialized in tests
    }

    unawaited(Future.microtask(loadVoices));
    return TtsPlaybackState(preferredVoice: initialVoice);
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
    try {
      if (Hive.isBoxOpen('settings')) {
        Hive.box<dynamic>('settings').put(voiceStorageKey, voiceId);
      }
    } on Exception {
      // Best-effort persistence
    }
  }

  Future<void> speak(
    String messageId,
    String text, {
    String? voice,
  }) async {
    // If already playing this message, tapping it again stops playback.
    if (state.isSpeakingMessage(messageId)) {
      stop();
      return;
    }

    final voiceName = voice ??
        (state.preferredVoice.isNotEmpty ? state.preferredVoice : null);

    state = state.copyWith(
      isPlaying: true,
      currentMessageId: () => messageId,
      currentText: () => text,
      audioBytes: () => null,
      error: () => null,
    );

    try {
      final bytes = await _repo.synthesizeSpeech(
        text,
        voice: voiceName,
      );
      if (!ref.mounted) return;
      state = state.copyWith(
        audioBytes: () => bytes,
      );
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

  void stop() {
    state = state.copyWith(
      isPlaying: false,
      currentMessageId: () => null,
      currentText: () => null,
      audioBytes: () => null,
    );
  }
}

final ttsControllerProvider =
    NotifierProvider<TtsController, TtsPlaybackState>(TtsController.new);

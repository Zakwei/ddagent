import 'dart:async';
import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/voice/data/voice_models.dart';
import 'package:ddagent_app/features/voice/data/voice_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── STT Config Controller ──────────────────────────────────────────────────

class SttConfigController extends Notifier<SttConfig> {
  VoiceRepository get _repo => ref.read(voiceRepositoryProvider);

  @override
  SttConfig build() {
    unawaited(Future.microtask(refresh));
    return const SttConfig();
  }

  Future<void> refresh() async {
    try {
      final config = await _repo.getSttConfig();
      if (!ref.mounted) return;
      state = config;
    } on Exception {
      // Offline / server without STT module keeps default unconfigured state
    }
  }

  Future<bool> save({String? endpointUrl, String? apiKey, String? model}) async {
    try {
      final ok = await _repo.saveSttConfig(endpointUrl: endpointUrl, apiKey: apiKey, model: model);
      if (ok) unawaited(refresh());
      return ok;
    } on Object {
      // Errors too (bad payload casts) — the dialog's saving state waits on this.
      return false;
    }
  }
}

final sttConfigProvider = NotifierProvider<SttConfigController, SttConfig>(SttConfigController.new);

// ─── Voice Input (Recording & Transcription) Controller ────────────────────

enum VoiceInputState { idle, recording, processing }

class VoiceInputSessionState {
  const VoiceInputSessionState({
    this.status = VoiceInputState.idle,
    this.lastTranscript,
    this.error,
  });

  final VoiceInputState status;
  final String? lastTranscript;
  final String? error;

  bool get isRecording => status == VoiceInputState.recording;
  bool get isProcessing => status == VoiceInputState.processing;

  VoiceInputSessionState copyWith({
    VoiceInputState? status,
    String? Function()? lastTranscript,
    String? Function()? error,
  }) => VoiceInputSessionState(
    status: status ?? this.status,
    lastTranscript: lastTranscript != null ? lastTranscript() : this.lastTranscript,
    error: error != null ? error() : this.error,
  );
}

class VoiceInputController extends Notifier<VoiceInputSessionState> {
  static const maxRecordingDuration = Duration(minutes: 5);

  VoiceRepository get _repo => ref.read(voiceRepositoryProvider);
  Timer? _maxRecordingTimer;
  Uint8List? _mockAudioBuffer;

  @override
  VoiceInputSessionState build() {
    ref.onDispose(() => _maxRecordingTimer?.cancel());
    return const VoiceInputSessionState();
  }

  /// Sets audio bytes to be uploaded when stopping recording.
  void setAudioBytes(Uint8List bytes) {
    _mockAudioBuffer = bytes;
  }

  Future<void> startRecording() async {
    _maxRecordingTimer?.cancel();
    state = state.copyWith(status: VoiceInputState.recording, error: () => null);

    // Auto-stop at 5-minute cap
    _maxRecordingTimer = Timer(maxRecordingDuration, () {
      unawaited(stopRecording());
    });
  }

  Future<String?> stopRecording({String? language}) async {
    _maxRecordingTimer?.cancel();
    if (state.status != VoiceInputState.recording) return null;

    state = state.copyWith(status: VoiceInputState.processing);

    try {
      // Use buffered audio or fallback minimum dummy audio bytes for testing
      final audioBytes = _mockAudioBuffer ?? Uint8List.fromList([0, 1, 2, 3]);
      final transcript = await _repo.transcribeAudio(audioBytes, language: language);

      if (!ref.mounted) return transcript.text;
      state = state.copyWith(status: VoiceInputState.idle, lastTranscript: () => transcript.text);
      return transcript.text;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(status: VoiceInputState.idle, error: () => e.message);
      }
      return null;
    } on Exception catch (e) {
      if (ref.mounted) {
        state = state.copyWith(status: VoiceInputState.idle, error: () => e.toString());
      }
      return null;
    }
  }

  Future<String?> toggleRecording({String? language}) async {
    if (state.isRecording) {
      return stopRecording(language: language);
    } else {
      await startRecording();
      return null;
    }
  }

  void clearError() => state = state.copyWith(error: () => null);
}

final voiceInputProvider = NotifierProvider<VoiceInputController, VoiceInputSessionState>(
  VoiceInputController.new,
);

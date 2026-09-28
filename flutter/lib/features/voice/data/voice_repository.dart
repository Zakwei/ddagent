import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/voice/data/voice_models.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VoiceRepository {
  const VoiceRepository(this._dio);

  final Dio _dio;

  // ─── STT ─────────────────────────────────────────────────────────────────

  Future<SttConfig> getSttConfig() => apiCall(
    () => _dio.get<dynamic>('/api/stt/config'),
    (d) => SttConfig.fromJson(d as Map<String, dynamic>),
  );

  Future<bool> saveSttConfig({
    String? endpointUrl,
    String? apiKey,
    String? model,
  }) => apiCall(
    () => _dio.put<dynamic>('/api/stt/config', data: {
      'endpointUrl': ?endpointUrl,
      'apiKey': ?apiKey,
      'model': ?model,
    }),
    (d) => (d as Map<String, dynamic>)['configured'] == true,
  );

  Future<SttTranscript> transcribeAudio(
    Uint8List audioBytes, {
    String? language,
    String mimeType = 'audio/webm',
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        '/api/stt',
        queryParameters: {'language': ?language},
        data: audioBytes,
        options: Options(
          headers: {'Content-Type': mimeType},
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return SttTranscript.fromJson(data);
      }
      return const SttTranscript();
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  // ─── TTS ─────────────────────────────────────────────────────────────────

  Future<List<TtsVoice>> getVoices() => apiCall(
    () => _dio.get<dynamic>('/api/tts/voices'),
    (d) {
      final list = (d as Map<String, dynamic>)['voices'];
      if (list is List) {
        return [
          for (final item in list)
            if (item is Map<String, dynamic>) TtsVoice.fromJson(item),
        ];
      }
      return const <TtsVoice>[];
    },
  );

  Future<Uint8List> synthesizeSpeech(
    String text, {
    String? voice,
  }) async {
    try {
      final response = await _dio.post<List<int>>(
        '/api/tts',
        data: {
          'text': text,
          if (voice != null && voice.isNotEmpty) 'voice': voice,
        },
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data ?? const []);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }
}

final voiceRepositoryProvider = Provider<VoiceRepository>(
  (ref) => VoiceRepository(ref.watch(dioProvider)),
);

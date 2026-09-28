/// Domain models for STT (/api/stt) and TTS (/api/tts).
library;

String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();
bool _bool(Object? v, [bool defaultValue = false]) => v is bool ? v : defaultValue;

/// STT backend configuration from `GET /api/stt/config`.
class SttConfig {
  const SttConfig({
    this.configured = false,
    this.endpointUrl,
    this.model,
    this.hasApiKey = false,
  });

  final bool configured;
  final String? endpointUrl;
  final String? model;
  final bool hasApiKey;

  static SttConfig fromJson(Map<String, dynamic> j) => SttConfig(
        configured: _bool(j['configured']),
        endpointUrl: _strOrNull(j['endpointUrl']),
        model: _strOrNull(j['model']),
        hasApiKey: _bool(j['hasApiKey']),
      );

  Map<String, dynamic> toJson() => {
        'configured': configured,
        'endpointUrl': endpointUrl,
        'model': model,
        'hasApiKey': hasApiKey,
      };
}

/// Transcription response from `POST /api/stt`.
class SttTranscript {
  const SttTranscript({this.text = ''});

  final String text;

  static SttTranscript fromJson(Map<String, dynamic> j) => SttTranscript(
        text: _str(j['text']),
      );
}

/// Voice option from `GET /api/tts/voices`.
class TtsVoice {
  const TtsVoice({
    required this.id,
    required this.name,
    this.locale = '',
    this.gender = '',
  });

  final String id;
  final String name;
  final String locale;
  final String gender;

  static TtsVoice fromJson(Map<String, dynamic> j) => TtsVoice(
        id: _str(j['id']),
        name: _str(j['name']),
        locale: _str(j['locale']),
        gender: _str(j['gender']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'locale': locale,
        'gender': gender,
      };
}

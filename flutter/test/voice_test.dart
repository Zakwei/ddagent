import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/transcript_view.dart';
import 'package:ddagent_app/features/sessions/data/chat_storage.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/voice/data/voice_models.dart';
import 'package:ddagent_app/features/voice/data/voice_repository.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:ddagent_app/features/voice/view/auto_read_voice_picker.dart';
import 'package:ddagent_app/features/voice/view/stt_config_dialog.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

class _FakeVoiceRepo extends VoiceRepository {
  _FakeVoiceRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  SttConfig config = const SttConfig(
    configured: true,
    endpointUrl: 'https://api.openai.com/v1',
    model: 'whisper-1',
    hasApiKey: true,
  );

  List<TtsVoice> voices = const [
    TtsVoice(id: 'pl-PL-ZofiaNeural', name: 'Zofia', locale: 'pl-PL', gender: 'Female'),
    TtsVoice(id: 'en-US-AriaNeural', name: 'Aria', locale: 'en-US', gender: 'Female'),
  ];

  @override
  Future<SttConfig> getSttConfig() async {
    if (opError != null) throw opError!;
    calls.add('getSttConfig');
    return config;
  }

  @override
  Future<bool> saveSttConfig({String? endpointUrl, String? apiKey, String? model}) async {
    if (opError != null) throw opError!;
    calls.add('saveSttConfig:$endpointUrl:$apiKey:$model');
    config = SttConfig(
      configured: endpointUrl != null && endpointUrl.isNotEmpty,
      endpointUrl: endpointUrl,
      model: model,
      hasApiKey: apiKey != null && apiKey.isNotEmpty,
    );
    return true;
  }

  @override
  Future<SttTranscript> transcribeAudio(
    Uint8List audioBytes, {
    String? language,
    String mimeType = 'audio/webm',
  }) async {
    if (opError != null) throw opError!;
    calls.add('transcribeAudio:${audioBytes.length}:$language');
    return const SttTranscript(text: 'Dzień dobry, zróbmy test mowy');
  }

  @override
  Future<List<TtsVoice>> getVoices() async {
    if (opError != null) throw opError!;
    calls.add('getVoices');
    return voices;
  }

  @override
  Future<Uint8List> synthesizeSpeech(String text, {String? voice}) async {
    if (opError != null) throw opError!;
    calls.add('synthesizeSpeech:$text:$voice');
    return Uint8List.fromList([1, 2, 3, 4, 5]);
  }
}

void main() {
  VoidCallback? endPlayback;
  setUpAll(() async {
    Hive.init('/tmp/ddagent_voice_test_hive');
    await ChatStorage.init();
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  setUp(() {
    if (Hive.isBoxOpen('settings')) {
      Hive.box<dynamic>('settings').delete(TtsController.voiceStorageKey);
    }
    ChatStorage.writeDraft(ChatStorage.draftKey(sessionId: 'sess_test_1'), '');
  });

  group('1. Modele STT i TTS', () {
    test('SttConfig.fromJson / toJson', () {
      final json = {
        'configured': true,
        'endpointUrl': 'https://whisper.local',
        'model': 'whisper-base',
        'hasApiKey': true,
      };
      final cfg = SttConfig.fromJson(json);
      expect(cfg.configured, isTrue);
      expect(cfg.endpointUrl, 'https://whisper.local');
      expect(cfg.model, 'whisper-base');
      expect(cfg.hasApiKey, isTrue);
      expect(cfg.toJson()['endpointUrl'], 'https://whisper.local');
    });

    test('SttTranscript.fromJson', () {
      final transcript = SttTranscript.fromJson({'text': 'Hello world'});
      expect(transcript.text, 'Hello world');
    });

    test('TtsVoice.fromJson / toJson', () {
      final voice = TtsVoice.fromJson({
        'id': 'pl-PL-MarekNeural',
        'name': 'Marek',
        'locale': 'pl-PL',
        'gender': 'Male',
      });
      expect(voice.id, 'pl-PL-MarekNeural');
      expect(voice.name, 'Marek');
      expect(voice.locale, 'pl-PL');
      expect(voice.gender, 'Male');
      expect(voice.toJson()['id'], 'pl-PL-MarekNeural');
    });
  });

  group('2. Controller STT i TTS', () {
    late _FakeVoiceRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeVoiceRepo();
      // Playback is platform-only; a fake that stays "in flight" until the
      // test ends it makes the speaking flag observable.
      c = ProviderContainer(
        overrides: [
          voiceRepositoryProvider.overrideWithValue(repo),
          ttsPlayAudioProvider.overrideWithValue((bytes, {onEnd}) async {
            endPlayback = onEnd;
          }),
          ttsStopAudioProvider.overrideWithValue(() => endPlayback?.call()),
        ],
      );
    });

    tearDown(() => c.dispose());

    test('SttConfigController: pobieranie i zapis konfiguracji', () async {
      final ctrl = c.read(sttConfigProvider.notifier);
      await ctrl.refresh();
      expect(c.read(sttConfigProvider).configured, isTrue);
      expect(c.read(sttConfigProvider).model, 'whisper-1');

      final saved = await ctrl.save(
        endpointUrl: 'https://new-stt.local',
        apiKey: 'secret123',
        model: 'large-v3',
      );
      expect(saved, isTrue);
      expect(repo.calls, contains('saveSttConfig:https://new-stt.local:secret123:large-v3'));
      await ctrl.refresh();
      expect(c.read(sttConfigProvider).model, 'large-v3');
    });

    test('VoiceInputController: cykl nagrywania i transkrypcji', () async {
      final ctrl = c.read(voiceInputProvider.notifier);
      ctrl.setAudioBytes(Uint8List.fromList([10, 20, 30]));

      await ctrl.startRecording();
      expect(c.read(voiceInputProvider).isRecording, isTrue);

      final text = await ctrl.stopRecording(language: 'pl');
      expect(text, 'Dzień dobry, zróbmy test mowy');
      expect(repo.calls, contains('transcribeAudio:3:pl'));
      expect(c.read(voiceInputProvider).status, VoiceInputState.idle);
      expect(c.read(voiceInputProvider).lastTranscript, 'Dzień dobry, zróbmy test mowy');
    });

    test('TtsController: lista głosów, preferowany głos i synteza mowy', () async {
      final ctrl = c.read(ttsControllerProvider.notifier);
      await ctrl.loadVoices();

      expect(c.read(ttsControllerProvider).voices.length, 2);
      expect(repo.calls, contains('getVoices'));

      ctrl.setPreferredVoice('pl-PL-ZofiaNeural');
      expect(c.read(ttsControllerProvider).preferredVoice, 'pl-PL-ZofiaNeural');

      await ctrl.speak('msg_1', 'Cześć! W czym mogę pomóc?');
      expect(repo.calls, contains('synthesizeSpeech:Cześć! W czym mogę pomóc?:pl-PL-ZofiaNeural'));
      expect(c.read(ttsControllerProvider).isPlaying, isTrue);
      expect(c.read(ttsControllerProvider).isSpeakingMessage('msg_1'), isTrue);
      expect(c.read(ttsControllerProvider).audioBytes, isNotNull);

      // Ponowne wywołanie speak na tej samej wiadomości zatrzymuje odtwarzanie
      await ctrl.speak('msg_1', 'Cześć! W czym mogę pomóc?');
      expect(c.read(ttsControllerProvider).isPlaying, isFalse);
      expect(c.read(ttsControllerProvider).isSpeakingMessage('msg_1'), isFalse);
    });

    test('błąd transkrypcji ustawia error i resetuje stan', () async {
      final ctrl = c.read(voiceInputProvider.notifier);
      repo.opError = const ServerError('Whisper rate limit', 429);

      await ctrl.startRecording();
      final text = await ctrl.stopRecording();
      expect(text, isNull);
      expect(c.read(voiceInputProvider).isRecording, isFalse);
      expect(c.read(voiceInputProvider).error, 'Whisper rate limit');

      ctrl.clearError();
      expect(c.read(voiceInputProvider).error, isNull);
    });
  });

  group('3. Testy widgetowe STT + TTS (Test strategii: nagrywanie → transcript, play na wiadomości → audio)', () {
    testWidgets('nagrywanie → transcript w composerze', (tester) async {
      final repo = _FakeVoiceRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            voiceRepositoryProvider.overrideWithValue(repo),
            ttsPlayAudioProvider.overrideWithValue((bytes, {onEnd}) async {}),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(body: ChatComposer(sessionId: 'sess_test_1')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Przycisk mikrofonu jest widoczny gdy STT jest skonfigurowane
      final micButton = find.byTooltip('Dictate a message');
      expect(micButton, findsOneWidget);

      // Kliknij mikrofon aby rozpocząć nagrywanie
      await tester.tap(micButton);
      await tester.pump();

      // Ikona mikrofonu zmienia się na aktywną (Stop recording)
      final stopButton = find.byTooltip('Stop dictation');
      expect(stopButton, findsOneWidget);

      // Kliknij ponownie aby zatrzymać i przetranskrybować
      await tester.tap(stopButton);
      await tester.pumpAndSettle();

      expect(repo.calls.where((c) => c.startsWith('transcribeAudio:')).length, 1);
      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.controller?.text, 'Dzień dobry, zróbmy test mowy');
    });

    testWidgets('play na wiadomości → audio (synteza TTS)', (tester) async {
      final repo = _FakeVoiceRepo();

      const testMsg = SessionMessage(
        id: 'msg_assistant_1',
        sessionId: 'sess_1',
        timestamp: '2026-01-01T12:00:00Z',
        provider: 'claude',
        kind: 'text',
        role: 'assistant',
        content: 'Oto odpowiedź asystenta na Twoje pytanie.',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            voiceRepositoryProvider.overrideWithValue(repo),
            ttsPlayAudioProvider.overrideWithValue((bytes, {onEnd}) async {}),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(
                body: MessageActions(
                  message: testMsg,
                  child: Text('Oto odpowiedź asystenta na Twoje pytanie.'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Przycisk odtwarzania mowy jest widoczny przy wiadomości
      final ttsButton = find.byTooltip('Read aloud (TTS)');
      expect(ttsButton, findsOneWidget);

      // Kliknij odtwórz
      await tester.tap(ttsButton);
      await tester.pumpAndSettle();

      expect(
        repo.calls,
        contains('synthesizeSpeech:Oto odpowiedź asystenta na Twoje pytanie.:null'),
      );
      // Ikona zmienia się w przycisk zatrzymania
      expect(find.byTooltip('Stop speaking'), findsOneWidget);

      // Kliknij zatrzymaj
      await tester.tap(find.byTooltip('Stop speaking'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Read aloud (TTS)'), findsOneWidget);
    });

    testWidgets('STT Config Dialog: edycja i zapis endpointu', (tester) async {
      final repo = _FakeVoiceRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            voiceRepositoryProvider.overrideWithValue(repo),
            ttsPlayAudioProvider.overrideWithValue((bytes, {onEnd}) async {}),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(body: SttConfigDialog()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Voice input (STT)'), findsOneWidget);
      expect(find.text('configured'), findsOneWidget);

      // Wprowadź nowy model i endpoint
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), 'https://custom-whisper.ai');
      await tester.enterText(textFields.at(2), 'whisper-large');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('saveSttConfig:https://custom-whisper.ai:null:whisper-large'));
    });

    testWidgets('AutoReadVoicePicker: wybór głosu i odsłuchanie preview', (tester) async {
      final repo = _FakeVoiceRepo();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            voiceRepositoryProvider.overrideWithValue(repo),
            ttsPlayAudioProvider.overrideWithValue((bytes, {onEnd}) async {}),
          ],
          child: TranslationProvider(
            child: MaterialApp(
              theme: AppTheme.light(),
              home: const Scaffold(body: AutoReadVoicePicker()),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Auto voice'), findsOneWidget);

      // Rozwiń dropdown
      await tester.tap(find.text('Auto voice'));
      await tester.pumpAndSettle();

      expect(find.text('Zofia'), findsWidgets);
      expect(find.text('Aria'), findsWidgets);

      // Wybierz Zofia
      await tester.tap(find.text('Zofia').last);
      await tester.pumpAndSettle();

      // Kliknij Preview
      await tester.tap(find.text('Preview'));
      await tester.pumpAndSettle();

      expect(
        repo.calls,
        contains('synthesizeSpeech:This is how replies will sound.:pl-PL-ZofiaNeural'),
      );
    });
  });
}

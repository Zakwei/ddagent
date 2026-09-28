import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/shared_context/data/shared_context_models.dart';
import 'package:ddagent_app/features/shared_context/data/shared_context_repository.dart';
import 'package:ddagent_app/features/shared_context/state/shared_context_controller.dart';
import 'package:ddagent_app/features/shared_context/view/shared_notes_pane.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSharedContextRepo extends SharedContextRepository {
  _FakeSharedContextRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  final Map<String, SharedContextDocument> storage = {
    'p1': const SharedContextDocument(
      content: '# Initial Project Context\nConventions and guidelines.',
      updatedAt: '2026-01-01T12:00:00Z',
    ),
    'p2': const SharedContextDocument(
      content: '# Project 2 Context',
      updatedAt: '2026-01-02T10:00:00Z',
    ),
  };

  @override
  Future<SharedContextDocument> get(String projectId) async {
    if (opError != null) throw opError!;
    calls.add('get:$projectId');
    return storage[projectId] ?? const SharedContextDocument(content: '');
  }

  @override
  Future<SharedContextDocument> put(String projectId, String content) async {
    if (opError != null) throw opError!;
    calls.add('put:$projectId:$content');
    final doc = SharedContextDocument(
      content: content,
      updatedAt: '2026-01-05T15:30:00Z',
    );
    storage[projectId] = doc;
    return doc;
  }
}

class _FakeProjectsRepo extends ProjectsRepository {
  _FakeProjectsRepo() : super(Dio());

  @override
  Future<List<Project>> list({
    bool skipSync = false,
    int? sessionsLimit,
    int? sessionsOffset,
  }) async => [
    const Project(
      projectId: 'p1',
      path: '/path/p1',
      displayName: 'Main Project',
      sessionMeta: SessionMeta(total: 0),
    ),
    const Project(
      projectId: 'p2',
      path: '/path/p2',
      displayName: 'Second Project',
      sessionMeta: SessionMeta(total: 0),
    ),
  ];

  @override
  Future<List<Project>> archived() async => [];
}

Widget _buildApp({
  required _FakeSharedContextRepo repo,
  String? projectId = 'p1',
  bool dark = false,
  bool useScreen = false,
}) {
  return ProviderScope(
    overrides: [
      sharedContextRepositoryProvider.overrideWithValue(repo),
      projectsRepositoryProvider.overrideWithValue(_FakeProjectsRepo()),
    ],
    child: MaterialApp(
      theme: dark ? AppTheme.dark() : AppTheme.light(),
      home: useScreen
          ? SharedNotesScreen(projectId: projectId)
          : Scaffold(body: SharedNotesPane(projectId: projectId)),
    ),
  );
}

void main() {
  group('1. Modele SharedContextDocument i ich deserializacja', () {
    test('SharedContextDocument.fromJson — parsowanie zawartości i daty', () {
      final json = {
        'content': '# Shared rules\nAlways run tests.',
        'updatedAt': '2026-02-01T10:00:00Z',
      };
      final doc = SharedContextDocument.fromJson(json);
      expect(doc.content, '# Shared rules\nAlways run tests.');
      expect(doc.updatedAt, '2026-02-01T10:00:00Z');

      final minimal = SharedContextDocument.fromJson({});
      expect(minimal.content, '');
      expect(minimal.updatedAt, isNull);

      final out = doc.toJson();
      expect(out['content'], '# Shared rules\nAlways run tests.');
      expect(out['updatedAt'], '2026-02-01T10:00:00Z');
    });
  });

  group('2. Controller SharedContextController', () {
    late _FakeSharedContextRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeSharedContextRepo();
      c = ProviderContainer(
        overrides: [
          sharedContextRepositoryProvider.overrideWithValue(repo),
        ],
      );
    });

    tearDown(() => c.dispose());

    test('load ładuje dokument z serwera i resetuje isDirty', () async {
      final ctrl = c.read(sharedContextProvider('p1').notifier);
      await ctrl.load('p1');

      final state = c.read(sharedContextProvider('p1'));
      expect(repo.calls, contains('get:p1'));
      expect(state.content, '# Initial Project Context\nConventions and guidelines.');
      expect(state.savedContent, '# Initial Project Context\nConventions and guidelines.');
      expect(state.isDirty, isFalse);
      expect(state.updatedAt, '2026-01-01T12:00:00Z');
      expect(state.loading, isFalse);
    });

    test('updateContent oznacza stan jako isDirty, a powrót do bazy go czyści', () async {
      final ctrl = c.read(sharedContextProvider('p1').notifier);
      await ctrl.load('p1');

      ctrl.updateContent('New edited content');
      expect(c.read(sharedContextProvider('p1')).isDirty, isTrue);
      expect(c.read(sharedContextProvider('p1')).content, 'New edited content');

      // Powrót do pierwotnej treści
      ctrl.updateContent('# Initial Project Context\nConventions and guidelines.');
      expect(c.read(sharedContextProvider('p1')).isDirty, isFalse);
    });

    test('edit → save → reload → content persists (test strategii)', () async {
      final ctrl = c.read(sharedContextProvider('p1').notifier);
      await ctrl.load('p1');

      // Edit
      ctrl.updateContent('Persisted notes line 1');
      expect(c.read(sharedContextProvider('p1')).isDirty, isTrue);

      // Save
      final ok = await ctrl.save();
      expect(ok, isTrue);
      expect(repo.calls, contains('put:p1:Persisted notes line 1'));
      expect(c.read(sharedContextProvider('p1')).isDirty, isFalse);
      expect(c.read(sharedContextProvider('p1')).updatedAt, '2026-01-05T15:30:00Z');

      // Reload
      await ctrl.load('p1');
      expect(c.read(sharedContextProvider('p1')).content, 'Persisted notes line 1');
      expect(c.read(sharedContextProvider('p1')).savedContent, 'Persisted notes line 1');
    });

    test('błąd serwera ustawia error i resetuje saving', () async {
      final ctrl = c.read(sharedContextProvider('p1').notifier);
      await ctrl.load('p1');

      ctrl.updateContent('Content causing error');
      repo.opError = const ServerError('Cannot save context', 500);

      final ok = await ctrl.save();
      expect(ok, isFalse);
      expect(c.read(sharedContextProvider('p1')).saving, isFalse);
      expect(c.read(sharedContextProvider('p1')).error, 'Cannot save context');

      ctrl.clearError();
      expect(c.read(sharedContextProvider('p1')).error, isNull);
    });
  });

  group('3. Testy widgetowe SharedNotesPane i SharedNotesScreen', () {
    testWidgets('renderowanie nagłówka, pustego stanu i edytora tekstu', (tester) async {
      final repo = _FakeSharedContextRepo();
      await tester.pumpWidget(_buildApp(repo: repo, projectId: null));
      await tester.pumpAndSettle();

      expect(find.text('Shared memory — injected into every session of this project'), findsOneWidget);
      expect(find.text('Select a workspace to edit its shared context'), findsOneWidget);

      // Załaduj z projectId = 'p1'
      await tester.pumpWidget(_buildApp(repo: repo, projectId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Initial Project Context'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('pełny cykl: edit → save → reload → content persists w UI', (tester) async {
      final repo = _FakeSharedContextRepo();
      await tester.pumpWidget(_buildApp(repo: repo, projectId: 'p1'));
      await tester.pumpAndSettle();

      final textField = find.byType(TextField);
      expect(textField, findsOneWidget);

      // Przycisk Save jest domyślnie widoczny
      expect(find.text('Save'), findsOneWidget);

      // Edit: wprowadź nowy tekst
      await tester.enterText(textField, '# Updated shared guidelines\nRule 1: Always check tests.');
      await tester.pumpAndSettle();

      // Kliknij Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('put:p1:# Updated shared guidelines\nRule 1: Always check tests.'));
      expect(repo.storage['p1']?.content, '# Updated shared guidelines\nRule 1: Always check tests.');

      // Reload: odtwórz widget i zweryfikuj czy treść przetrwała
      await tester.pumpWidget(_buildApp(repo: repo, projectId: 'p1'));
      await tester.pumpAndSettle();

      expect(find.text('# Updated shared guidelines\nRule 1: Always check tests.'), findsOneWidget);
    });

    testWidgets('SharedNotesScreen: dropdown wyboru projektu przełącza dokumenty', (tester) async {
      final repo = _FakeSharedContextRepo();
      await tester.pumpWidget(_buildApp(repo: repo, useScreen: true));
      await tester.pumpAndSettle();

      expect(find.text('Shared Notes'), findsOneWidget);
      expect(find.textContaining('Initial Project Context'), findsOneWidget);

      // Przełącz na projekt 'Second Project'
      await tester.tap(find.text('Main Project'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Second Project').last);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('get:p2'));
      expect(find.textContaining('Project 2 Context'), findsOneWidget);
    });

    testWidgets('dark theme i wąski ekran 360px bez overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final repo = _FakeSharedContextRepo();
      await tester.pumpWidget(_buildApp(repo: repo, dark: true, useScreen: true));
      await tester.pumpAndSettle();

      expect(find.text('Shared Notes'), findsOneWidget);
      expect(find.textContaining('Initial Project Context'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

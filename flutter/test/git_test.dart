import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:ddagent_app/features/git/view/checkpoints_dialog.dart';
import 'package:ddagent_app/features/git/view/git_screen.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeProjectsController extends ProjectsController {
  FakeProjectsController([this._projects = const []]);

  final List<Project> _projects;

  @override
  ProjectsState build() => ProjectsState(
    projects: _projects,
    loading: false,
    syncing: false,
  );

  @override
  Future<void> load() async {}
}

class FakeGitRepository extends GitRepository {
  FakeGitRepository() : super(Dio());

  final calls = <String>[];
  Map<String, dynamic>? statusResult;
  Object? statusError;
  Map<String, dynamic> branchesResult = const {
    'branches': ['main', 'dev', 'origin/feature'],
    'localBranches': ['main', 'dev'],
    'remoteBranches': ['origin/feature'],
  };
  Map<String, dynamic> commitsResult = const {
    'commits': [
      {
        'hash': 'abcdef1234567890',
        'message': 'first',
        'author': 'A',
        'refs': ['HEAD -> main'],
        'stats': '2 files changed',
      },
    ],
  };
  Map<String, dynamic> checkpointsResult = const {
    'checkpoints': [
      {'ref': 'refs/ddagent/checkpoints/1', 'commit': 'c1', 'label': 'snap'},
    ],
  };
  Map<String, dynamic> remoteResult = const {
    'hasRemote': true,
    'hasUpstream': true,
    'branch': 'main',
    'remoteName': 'origin',
    'ahead': 2,
    'behind': 1,
    'isUpToDate': false,
  };
  Map<String, dynamic> commitMessageResult = const {'message': 'feat: x'};

  void _call(String name) => calls.add(name);

  @override
  Future<Map<String, dynamic>> status(String project) async {
    _call('status');
    if (statusError != null) throw statusError!;
    return statusResult ??
        const {
          'branch': 'main',
          'hasCommits': true,
          'modified': ['a.dart'],
          'added': <String>[],
          'deleted': ['old.dart'],
          'untracked': ['new.dart'],
          'staged': ['s.dart'],
        };
  }

  @override
  Future<Map<String, dynamic>> branches(String project) async {
    _call('branches');
    return branchesResult;
  }

  @override
  Future<Map<String, dynamic>> commits(String project, {int? limit}) async {
    _call('commits');
    return commitsResult;
  }

  @override
  Future<Map<String, dynamic>> checkpoints(String project) async {
    _call('checkpoints');
    return checkpointsResult;
  }

  @override
  Future<Map<String, dynamic>> remoteStatus(String project) async {
    _call('remoteStatus');
    return remoteResult;
  }

  @override
  Future<Map<String, dynamic>> diff(String project, {String? filePath}) async {
    _call('diff:$filePath');
    return {
      'diff':
          '--- a/$filePath\n+++ b/$filePath\n@@ -1,2 +1,3 @@\n line1\n+line2\n line3\n',
    };
  }

  @override
  Future<Map<String, dynamic>> fileWithDiff(
    String projectId,
    String filePath,
  ) async {
    _call('fileWithDiff:$filePath');
    return const {
      'oldContent': '',
      'currentContent': '',
      'isDeleted': false,
      'isUntracked': false,
    };
  }

  @override
  Future<Map<String, dynamic>> generateCommitMessage(
    String project,
    List<String> files,
  ) async {
    _call('generate:$files');
    return commitMessageResult;
  }

  Object? opError;

  Map<String, dynamic> _ok(String name) {
    if (opError != null) throw opError!;
    _call(name);
    return {'success': true};
  }

  @override
  Future<Map<String, dynamic>> stage(String p, List<String> f) async =>
      _ok('stage:${f.join(',')}');

  @override
  Future<Map<String, dynamic>> unstage(String p, List<String> f) async =>
      _ok('unstage:${f.join(',')}');

  @override
  Future<Map<String, dynamic>> stageHunks(
    String p,
    String f,
    List<int> h,
  ) async => _ok('stageHunks:$f:${h.join(',')}');

  @override
  Future<Map<String, dynamic>> unstageHunks(
    String p,
    String f,
    List<int> h,
  ) async => _ok('unstageHunks:$f:${h.join(',')}');

  @override
  Future<Map<String, dynamic>> commit(
    String p,
    String m,
    List<String> f,
  ) async => _ok('commit:$m:${f.join(',')}');

  @override
  Future<Map<String, dynamic>> initialCommit(String p) async =>
      _ok('initialCommit');

  @override
  Future<Map<String, dynamic>> checkout(String p, String b) async =>
      _ok('checkout:$b');

  @override
  Future<Map<String, dynamic>> createBranch(String p, String b) async =>
      _ok('createBranch:$b');

  @override
  Future<Map<String, dynamic>> deleteBranch(String p, String b) async =>
      _ok('deleteBranch:$b');

  @override
  Future<Map<String, dynamic>> fetch(String p) async => _ok('fetch');

  @override
  Future<Map<String, dynamic>> pull(String p) async => _ok('pull');

  @override
  Future<Map<String, dynamic>> push(String p) async => _ok('push');

  @override
  Future<Map<String, dynamic>> publish(String p) async => _ok('publish');

  @override
  Future<Map<String, dynamic>> discard(String p, String f) async =>
      _ok('discard:$f');

  @override
  Future<Map<String, dynamic>> deleteUntracked(String p, String f) async =>
      _ok('deleteUntracked:$f');

  @override
  Future<Map<String, dynamic>> checkpoint(String p, {String? label}) async =>
      _ok('checkpoint:$label');

  @override
  Future<Map<String, dynamic>> checkpointRestore(String p, String ref) async =>
      _ok('restore:$ref');

  @override
  Future<Map<String, dynamic>> revertLocalCommit(String p, String sha) async =>
      _ok('revert');

  @override
  Future<Map<String, dynamic>> init(String p) async => _ok('init');
}

Widget _app({
  required FakeGitRepository gitRepo,
  String? projectId = 'p1',
}) => ProviderScope(
  overrides: [
    gitRepositoryProvider.overrideWithValue(gitRepo),
    projectsProvider.overrideWith(
      () => FakeProjectsController([
        const Project(
          projectId: 'p1',
          path: '/workspace/p1',
          displayName: 'Project 1',
        ),
      ]),
    ),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(
      body: GitScreen(projectId: projectId),
    ),
  ),
);

void main() {
  late FakeGitRepository repo;
  late ProviderContainer c;

  setUp(() {
    repo = FakeGitRepository();
    c = ProviderContainer(
      overrides: [gitRepositoryProvider.overrideWithValue(repo)],
    );
    // Keep the provider alive between calls (Riverpod disposes unlistened
    // providers) — mirrors a mounted screen watching gitProvider.
    c.listen(gitProvider, (_, _) {});
  });

  tearDown(() => c.dispose());

  group('model decoders', () {
    test('GitStatus parses all file groups', () {
      final s = GitStatus.fromJson(const {
        'branch': 'main',
        'hasCommits': true,
        'modified': ['a'],
        'added': ['b'],
        'deleted': ['c'],
        'untracked': ['d'],
        'staged': ['e'],
      });
      expect(s.branch, 'main');
      expect(s.unstaged, ['a', 'b', 'c']);
      expect(s.totalChanges, 5);
    });

    test('GitRemoteStatus defaults missing fields', () {
      final r = GitRemoteStatus.fromJson(const {'branch': 'main'});
      expect(r.ahead, 0);
      expect(r.hasUpstream, isFalse);
    });

    test('GitCommit tolerates sha/hash variants', () {
      expect(GitCommit.fromJson(const {'sha': 'x'}).hash, 'x');
      expect(GitCommit.fromJson(const {'hash': 'y'}).hash, 'y');
    });
  });

  group('GitController unit tests', () {
    test('poprawny odczyt statusu, branches, commits, checkpoints, remote', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(c.read(gitProvider).status!.branch, 'main');
      expect(c.read(gitProvider).status!.staged, ['s.dart']);
      expect(c.read(gitProvider).status!.unstaged, ['a.dart', 'old.dart']);
      expect(c.read(gitProvider).status!.untracked, ['new.dart']);
      expect(c.read(gitProvider).branches.local, ['main', 'dev']);
      expect(c.read(gitProvider).commits.single.shortHash, 'abcdef12');
      expect(
        c.read(gitProvider).checkpoints.single.ref,
        'refs/ddagent/checkpoints/1',
      );
      expect(c.read(gitProvider).remoteStatus.ahead, 2);
      expect(c.read(gitProvider).remoteStatus.behind, 1);
      expect(c.read(gitProvider).loading, isFalse);
    });

    test('non-git project maps to notGitRepository without an error', () async {
      repo.statusError = const ServerError('Not a git repository', 400);
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(c.read(gitProvider).notGitRepository, isTrue);
      expect(c.read(gitProvider).error, isNull);
    });

    test('operacje stage/unstage pojedynczych plików oraz wszystkich', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      expect(await c.read(gitProvider.notifier).stage(['a.dart']), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(repo.calls, contains('stage:a.dart'));
      expect(repo.calls, contains('status'));

      repo.calls.clear();
      expect(await c.read(gitProvider.notifier).unstage(['s.dart']), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(repo.calls, contains('unstage:s.dart'));

      repo.calls.clear();
      await c.read(gitProvider.notifier).stageAll();
      expect(repo.calls.any((call) => call.startsWith('stage:')), isTrue);

      repo.calls.clear();
      await c.read(gitProvider.notifier).unstageAll();
      expect(repo.calls.any((call) => call.startsWith('unstage:')), isTrue);
    });

    test('operacje stageHunks i unstageHunks przekazują indeksy zerowe', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      const h = [0, 2];
      await c.read(gitProvider.notifier).stageHunks('a.dart', h);
      await c.read(gitProvider.notifier).unstageHunks('a.dart', h);
      expect(
        repo.calls,
        containsAll(['stageHunks:a.dart:0,2', 'unstageHunks:a.dart:0,2']),
      );
    });

    test('commit z wygenerowaną wiadomością przez AI', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      final msg = await c.read(gitProvider.notifier).generateCommitMessage(['a.dart']);
      expect(msg, 'feat: x');
      expect(repo.calls, contains('generate:[a.dart]'));

      expect(
        await c.read(gitProvider.notifier).commit(msg!, ['a.dart']),
        isTrue,
      );
      expect(repo.calls, contains('commit:feat: x:a.dart'));
    });

    test('przełączanie, tworzenie i usuwanie gałęzi', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      await c.read(gitProvider.notifier).checkout('dev');
      await c.read(gitProvider.notifier).createBranch('feature/test');
      await c.read(gitProvider.notifier).deleteBranch('old-branch');
      expect(
        repo.calls,
        containsAll([
          'checkout:dev',
          'createBranch:feature/test',
          'deleteBranch:old-branch',
        ]),
      );
    });

    test('operacje push, pull, fetch, publish', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      await c.read(gitProvider.notifier).fetch();
      await c.read(gitProvider.notifier).pull();
      await c.read(gitProvider.notifier).push();
      await c.read(gitProvider.notifier).publish();
      expect(repo.calls, containsAll(['fetch', 'pull', 'push', 'publish']));
    });

    test('tworzenie i przywracanie checkpointów oraz inicjalizacja git', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      await c.read(gitProvider.notifier).createCheckpoint(label: 'my-snapshot');
      await c.read(gitProvider.notifier).restoreCheckpoint('refs/ddagent/checkpoints/1');
      await c.read(gitProvider.notifier).revertLocalCommit();
      await c.read(gitProvider.notifier).discard('a.dart');
      await c.read(gitProvider.notifier).deleteUntracked('new.dart');
      await c.read(gitProvider.notifier).init();

      expect(
        repo.calls,
        containsAll([
          'checkpoint:my-snapshot',
          'restore:refs/ddagent/checkpoints/1',
          'revert',
          'discard:a.dart',
          'deleteUntracked:new.dart',
          'init',
        ]),
      );
    });

    test('obsługa błędów mutacji i zwalnianie flagi busy', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();

      repo.opError = const ServerError('network timeout', 504);
      expect(await c.read(gitProvider.notifier).stage(['x.dart']), isFalse);
      expect(c.read(gitProvider).error, 'network timeout');
      expect(c.read(gitProvider).busy, isFalse);

      c.read(gitProvider.notifier).clearError();
      expect(c.read(gitProvider).error, isNull);
    });
  });

  group('GitScreen widget tests', () {
    testWidgets('renderowanie sekcji staged/unstaged i wskaźników statusu', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      // Sekcje nagłówków
      expect(find.text('Staged Changes (1)'), findsOneWidget);
      expect(find.text('Changes (3)'), findsOneWidget);
      expect(find.text('Unstage All'), findsOneWidget);
      expect(find.text('Stage All'), findsOneWidget);

      // Pliki i wskaźniki
      expect(find.byKey(const ValueKey('staged:s.dart')), findsOneWidget);
      expect(find.byKey(const ValueKey('change:a.dart')), findsOneWidget);
      expect(find.byKey(const ValueKey('change:old.dart')), findsOneWidget);
      expect(find.byKey(const ValueKey('change:new.dart')), findsOneWidget);

      // Badge statusu
      expect(find.text('S'), findsOneWidget);
      expect(find.text('M'), findsOneWidget);
      expect(find.text('D'), findsOneWidget);
      expect(find.text('U'), findsOneWidget);
    });

    testWidgets('interakcje stage i unstage (pliki, stageAll, unstageAll, hunki)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      repo.calls.clear();

      // Kliknięcie Stage na pojedynczym pliku a.dart
      final stageAButton = find.descendant(
        of: find.byKey(const ValueKey('change:a.dart')),
        matching: find.byTooltip('Stage'),
      );
      expect(stageAButton, findsOneWidget);
      await tester.tap(stageAButton);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('stage:a.dart'));

      // Kliknięcie Unstage na pliku s.dart
      final unstageSButton = find.descendant(
        of: find.byKey(const ValueKey('staged:s.dart')),
        matching: find.byTooltip('Unstage'),
      );
      expect(unstageSButton, findsOneWidget);
      await tester.tap(unstageSButton);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('unstage:s.dart'));

      // Kliknięcie Stage All
      await tester.tap(find.text('Stage All'));
      await tester.pumpAndSettle();
      expect(repo.calls.any((c) => c.startsWith('stage:')), isTrue);

      // Kliknięcie Unstage All
      await tester.tap(find.text('Unstage All'));
      await tester.pumpAndSettle();
      expect(repo.calls.any((c) => c.startsWith('unstage:')), isTrue);

      // Rozwinięcie pliku w celu staged hunka
      final fileRow = find.byKey(const ValueKey('change:a.dart'));
      await tester.tap(fileRow);
      await tester.pumpAndSettle();

      expect(find.text('+ Hunk'), findsOneWidget);
      await tester.tap(find.text('+ Hunk'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('stageHunks:a.dart:0'));
    });

    testWidgets('obsługa formularza commitu: walidacja, AI button, commit', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      // Przycisk Commit jest zablokowany przy pustym polu tekstowym
      final commitBtnFinder = find.widgetWithText(AppButton, 'Commit');
      expect(commitBtnFinder, findsOneWidget);
      var commitBtn = tester.widget<AppButton>(commitBtnFinder);
      expect(commitBtn.onPressed, isNull);

      // Kliknięcie przycisku AI generuje wiadomość
      final aiBtnFinder = find.text('✦ AI');
      expect(aiBtnFinder, findsOneWidget);
      await tester.tap(aiBtnFinder);
      await tester.pumpAndSettle();

      expect(repo.calls.any((c) => c.startsWith('generate:')), isTrue);
      expect(find.text('feat: x'), findsOneWidget);

      // Teraz przycisk Commit jest aktywny
      commitBtn = tester.widget<AppButton>(commitBtnFinder);
      expect(commitBtn.onPressed, isNotNull);

      // Kliknięcie Commit tworzy zatwierdzenie
      await tester.tap(commitBtnFinder);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('commit:feat: x:s.dart'));
      expect(find.text('Commit created'), findsOneWidget);

      // Ręczne wprowadzanie tekstu commitu
      final inputFinder = find.byType(TextField).first;
      await tester.enterText(inputFinder, 'docs: update readme');
      await tester.pumpAndSettle();
      expect(find.text('docs: update readme'), findsOneWidget);
    });

    testWidgets('dialog checkpoints: otwieranie, lista, tworzenie i przywracanie', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      // Otwarcie dialogu checkpoints z headera
      final checkpointsHeaderBtn = find.byTooltip('Checkpoints');
      expect(checkpointsHeaderBtn, findsOneWidget);
      await tester.tap(checkpointsHeaderBtn);
      await tester.pumpAndSettle();

      // Weryfikacja obecności dialogu i istniejącego checkpointa
      expect(find.byType(CheckpointsDialog), findsOneWidget);
      expect(find.text('snap'), findsOneWidget);
      expect(find.text('Restore'), findsOneWidget);

      // Utworzenie nowego checkpointa
      final labelInput = find.widgetWithText(AppInput, 'Checkpoint label (optional)');
      expect(labelInput, findsOneWidget);
      await tester.enterText(labelInput, 'my-checkpoint');
      await tester.pumpAndSettle();

      final newBtn = find.widgetWithText(AppButton, 'New');
      expect(newBtn, findsOneWidget);
      await tester.tap(newBtn);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('checkpoint:my-checkpoint'));

      // Przywrócenie checkpointa
      final restoreBtn = find.widgetWithText(AppButton, 'Restore').first;
      await tester.tap(restoreBtn);
      await tester.pumpAndSettle();

      // Dialog potwierdzenia
      expect(find.text('Restore checkpoint'), findsOneWidget);
      final confirmRestoreBtn = find.widgetWithText(AppButton, 'Restore').last;
      await tester.tap(confirmRestoreBtn);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('restore:refs/ddagent/checkpoints/1'));
      expect(find.text('Checkpoint restored'), findsOneWidget);
    });

    testWidgets('obsługa projektu bez repozytorium git (widok _NotGitView i init)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      repo.statusError = const ServerError('Not a git repository', 400);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      expect(find.text('Not a git repository'), findsOneWidget);
      expect(find.text('Initialize a repository to track changes.'), findsOneWidget);

      final initBtn = find.widgetWithText(AppButton, 'Initialize repository');
      expect(initBtn, findsOneWidget);

      await tester.tap(initBtn);
      await tester.pumpAndSettle();

      expect(repo.calls, contains('init'));
    });

    testWidgets('obsługa przełączania brancha i akcji remote (fetch, pull, push)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(_app(gitRepo: repo));
      await tester.pumpAndSettle();

      repo.calls.clear();

      // Przełącznik gałęzi
      final branchSwitch = find.byTooltip('Switch branch');
      expect(branchSwitch, findsOneWidget);
      await tester.tap(branchSwitch);
      await tester.pumpAndSettle();

      // Wybór gałęzi dev
      expect(find.text('dev'), findsOneWidget);
      await tester.tap(find.text('dev'));
      await tester.pumpAndSettle();
      expect(repo.calls, contains('checkout:dev'));

      // Przyciski remote w nagłówku
      final fetchBtn = find.byTooltip('Fetch');
      expect(fetchBtn, findsOneWidget);
      await tester.tap(fetchBtn);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('fetch'));

      final pullBtn = find.byTooltip('Pull 1');
      expect(pullBtn, findsOneWidget);
      await tester.tap(pullBtn);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('pull'));

      final pushBtn = find.byTooltip('Push 2');
      expect(pushBtn, findsOneWidget);
      await tester.tap(pushBtn);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('push'));
    });
  });
}

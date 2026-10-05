import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_models.dart';
import 'package:ddagent_app/features/worktrees/data/worktrees_repository.dart';
import 'package:ddagent_app/features/worktrees/state/worktrees_controller.dart';
import 'package:ddagent_app/features/worktrees/view/worktrees_screen.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWorktreesRepo extends WorktreesRepository {
  _FakeWorktreesRepo() : super(Dio());

  final calls = <String>[];
  Object? opError;

  WorktreeListData listData = const WorktreeListData(
    repositoryRoot: '/repo',
    baseBranch: 'main',
    worktrees: [
      WorktreeDescriptor(
        path: '/repo',
        branch: 'main',
        headSha: 'abc1234',
        isMain: true,
        isCurrent: true,
        changedFileCount: 0,
      ),
      WorktreeDescriptor(
        path: '/repo/.worktrees/feature-auth',
        branch: 'feature/auth',
        headSha: 'def5678',
        isMain: false,
        isCurrent: false,
        changedFileCount: 2,
        ahead: 1,
        behind: 0,
        lastCommitSubject: 'Add auth module',
        linkedProjectId: 'p_wt_auth',
      ),
    ],
  );

  WorktreeScriptsStatus scriptsStatus = const WorktreeScriptsStatus(
    scripts: WorktreeScriptsConfig(
      setup: 'npm install',
      run: 'npm run dev',
      runPort: 3000,
      hasProjectOverride: true,
    ),
    runtimes: {
      '/repo': WorktreeRuntimeInfo(
        setup: WorktreeSetupRuntime(status: 'done', exitCode: 0),
        run: WorktreeRunRuntime(status: 'idle'),
      ),
      '/repo/.worktrees/feature-auth': WorktreeRuntimeInfo(
        setup: WorktreeSetupRuntime(status: 'idle'),
        run: WorktreeRunRuntime(status: 'idle'),
      ),
    },
  );

  @override
  Future<WorktreeListData> list(String projectId) async {
    if (opError != null) throw opError!;
    calls.add('list:$projectId');
    return listData;
  }

  @override
  Future<WorktreeScriptsStatus> status(String projectId) async {
    if (opError != null) throw opError!;
    calls.add('status:$projectId');
    return scriptsStatus;
  }

  @override
  Future<WorktreeScriptsConfig> saveConfig(
    String projectId, {
    String? setup,
    String? run,
    int? runPort,
  }) async {
    if (opError != null) throw opError!;
    calls.add('saveConfig:$projectId:$setup:$run:$runPort');
    final updated = WorktreeScriptsConfig(
      setup: setup,
      run: run,
      runPort: runPort,
      hasProjectOverride: true,
    );
    scriptsStatus = WorktreeScriptsStatus(scripts: updated, runtimes: scriptsStatus.runtimes);
    return updated;
  }

  @override
  Future<Project> create(String projectId, String branch, {String? baseBranch}) async {
    if (opError != null) throw opError!;
    calls.add('create:$projectId:$branch:${baseBranch ?? 'default'}');
    final newPath = '/repo/.worktrees/$branch';
    final newDescriptor = WorktreeDescriptor(
      path: newPath,
      branch: branch,
      headSha: 'new1234',
      isMain: false,
      isCurrent: false,
      changedFileCount: 0,
      linkedProjectId: 'p_wt_$branch',
    );
    listData = WorktreeListData(
      repositoryRoot: listData.repositoryRoot,
      baseBranch: listData.baseBranch,
      worktrees: [...listData.worktrees, newDescriptor],
    );
    return Project(
      projectId: 'p_wt_$branch',
      path: newPath,
      displayName: branch,
      sessionMeta: const SessionMeta(total: 0),
    );
  }

  @override
  Future<Project> open(String projectId, String worktreePath) async {
    if (opError != null) throw opError!;
    calls.add('open:$projectId:$worktreePath');
    return Project(
      projectId: 'p_open',
      path: worktreePath,
      displayName: 'Opened WT',
      sessionMeta: const SessionMeta(total: 0),
    );
  }

  @override
  Future<MergeWorktreeResult> merge(
    String projectId,
    String worktreePath, {
    bool squash = false,
    String? message,
    bool removeAfterMerge = false,
  }) async {
    if (opError != null) throw opError!;
    calls.add('merge:$projectId:$worktreePath:squash=$squash:msg=$message:clean=$removeAfterMerge');
    if (removeAfterMerge) {
      listData = WorktreeListData(
        repositoryRoot: listData.repositoryRoot,
        baseBranch: listData.baseBranch,
        worktrees: listData.worktrees.where((w) => w.path != worktreePath).toList(),
      );
    }
    return MergeWorktreeResult(
      mergedBranch: 'feature/auth',
      targetBranch: 'main',
      squash: squash,
      removedWorktree: removeAfterMerge
          ? RemoveWorktreeResult(
              worktreePath: worktreePath,
              branch: 'feature/auth',
              branchDeleted: true,
            )
          : null,
    );
  }

  @override
  Future<WorktreeRunRuntime> run(String targetProjectId) async {
    if (opError != null) throw opError!;
    calls.add('run:$targetProjectId');
    const running = WorktreeRunRuntime(status: 'running', port: 3000, url: 'http://localhost:3000');
    scriptsStatus = WorktreeScriptsStatus(
      scripts: scriptsStatus.scripts,
      runtimes: {
        for (final entry in scriptsStatus.runtimes.entries)
          entry.key: WorktreeRuntimeInfo(setup: entry.value.setup, run: running),
      },
    );
    return running;
  }

  @override
  Future<WorktreeRunRuntime> stop(String targetProjectId) async {
    if (opError != null) throw opError!;
    calls.add('stop:$targetProjectId');
    const exited = WorktreeRunRuntime(status: 'exited', exitCode: 0);
    scriptsStatus = WorktreeScriptsStatus(
      scripts: scriptsStatus.scripts,
      runtimes: {
        for (final entry in scriptsStatus.runtimes.entries)
          entry.key: WorktreeRuntimeInfo(setup: entry.value.setup, run: exited),
      },
    );
    return exited;
  }

  @override
  Future<RemoveWorktreeResult> remove(
    String projectId,
    String worktreePath, {
    bool force = false,
    bool deleteBranch = false,
  }) async {
    if (opError != null) throw opError!;
    calls.add('remove:$projectId:$worktreePath:force=$force:delBranch=$deleteBranch');
    listData = WorktreeListData(
      repositoryRoot: listData.repositoryRoot,
      baseBranch: listData.baseBranch,
      worktrees: listData.worktrees.where((w) => w.path != worktreePath).toList(),
    );
    return RemoveWorktreeResult(
      worktreePath: worktreePath,
      branch: 'feature/auth',
      branchDeleted: deleteBranch,
    );
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
      path: '/repo',
      displayName: 'Main Project',
      sessionMeta: SessionMeta(total: 0),
    ),
  ];

  @override
  Future<List<Project>> archived() async => [];
}

Widget _buildApp({required _FakeWorktreesRepo repo, bool dark = false}) {
  return TranslationProvider(
    child: ProviderScope(
      overrides: [
        worktreesRepositoryProvider.overrideWithValue(repo),
        projectsRepositoryProvider.overrideWithValue(_FakeProjectsRepo()),
      ],
      child: MaterialApp(
        theme: dark ? AppTheme.dark() : AppTheme.light(),
        home: const WorktreesScreen(projectId: 'p1'),
      ),
    ),
  );
}

void main() {
  group('1. Modele Worktrees i ich deserializacja', () {
    test('WorktreeDescriptor.fromJson — pełny model, shortPath i toJson', () {
      final json = {
        'path': '/home/dev/repo/.worktrees/feature-x',
        'branch': 'feature-x',
        'headSha': 'sha123456789',
        'isMain': false,
        'isCurrent': true,
        'isLocked': true,
        'isDetached': false,
        'changedFileCount': 5,
        'ahead': 2,
        'behind': 1,
        'lastCommitSubject': 'feat: initial commit',
        'lastCommitDate': '2026-01-01T12:00:00Z',
        'linkedProjectId': 'proj_123',
        'linkedProjectArchived': false,
      };

      final wt = WorktreeDescriptor.fromJson(json);
      expect(wt.path, '/home/dev/repo/.worktrees/feature-x');
      expect(wt.branch, 'feature-x');
      expect(wt.headSha, 'sha123456789');
      expect(wt.isMain, isFalse);
      expect(wt.isCurrent, isTrue);
      expect(wt.isLocked, isTrue);
      expect(wt.isDetached, isFalse);
      expect(wt.changedFileCount, 5);
      expect(wt.ahead, 2);
      expect(wt.behind, 1);
      expect(wt.lastCommitSubject, 'feat: initial commit');
      expect(wt.shortPath, '…/.worktrees/feature-x');
      expect(wt.toJson()['branch'], 'feature-x');
    });

    test('WorktreeListData.fromJson — parsowanie bazy i listy worktrees', () {
      final json = {
        'repositoryRoot': '/repo',
        'baseBranch': 'main',
        'worktrees': [
          {'path': '/repo', 'isMain': true},
        ],
      };
      final data = WorktreeListData.fromJson(json);
      expect(data.repositoryRoot, '/repo');
      expect(data.baseBranch, 'main');
      expect(data.worktrees.length, 1);
      expect(data.worktrees.first.isMain, isTrue);
    });

    test('WorktreeScriptsConfig i status runtime — setup i run status', () {
      final configJson = {
        'setup': 'pnpm i',
        'run': 'pnpm dev',
        'runPort': 5173,
        'hasProjectOverride': true,
        'hasRepoFile': true,
      };
      final cfg = WorktreeScriptsConfig.fromJson(configJson);
      expect(cfg.setup, 'pnpm i');
      expect(cfg.run, 'pnpm dev');
      expect(cfg.runPort, 5173);
      expect(cfg.hasProjectOverride, isTrue);

      final statusJson = {
        'scripts': configJson,
        'runtimes': {
          '/repo': {
            'setup': {
              'status': 'done',
              'exitCode': 0,
              'logTail': ['ok'],
            },
            'run': {'status': 'running', 'port': 5173, 'url': 'http://localhost:5173'},
          },
        },
      };
      final status = WorktreeScriptsStatus.fromJson(statusJson);
      expect(status.scripts.setup, 'pnpm i');
      expect(status.runtimes['/repo']?.setup.status, 'done');
      expect(status.runtimes['/repo']?.run.status, 'running');
      expect(status.runtimes['/repo']?.run.port, 5173);
    });

    test('MergeWorktreeResult i RemoveWorktreeResult', () {
      final mergeJson = {
        'mergedBranch': 'feat',
        'targetBranch': 'main',
        'squash': true,
        'removedWorktree': {
          'worktreePath': '/repo/.worktrees/feat',
          'branch': 'feat',
          'branchDeleted': true,
        },
        'cleanupError': null,
      };
      final merge = MergeWorktreeResult.fromJson(mergeJson);
      expect(merge.mergedBranch, 'feat');
      expect(merge.targetBranch, 'main');
      expect(merge.squash, isTrue);
      expect(merge.removedWorktree?.branchDeleted, isTrue);
    });
  });

  group('2. Controller WorktreesController', () {
    late _FakeWorktreesRepo repo;
    late ProviderContainer c;

    setUp(() {
      repo = _FakeWorktreesRepo();
      c = ProviderContainer(
        overrides: [
          worktreesRepositoryProvider.overrideWithValue(repo),
          projectsRepositoryProvider.overrideWithValue(_FakeProjectsRepo()),
        ],
      );
      c.listen(worktreesProvider, (_, _) {});
    });

    tearDown(() => c.dispose());

    WorktreesController ctrl() => c.read(worktreesProvider.notifier);
    WorktreesState state() => c.read(worktreesProvider);

    test('selectProject i refresh ładują listę i status', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(repo.calls, contains('list:p1'));
      expect(repo.calls, contains('status:p1'));
      expect(state().worktrees.length, 2);
      expect(state().baseBranch, 'main');
      expect(state().scriptsStatus?.scripts.setup, 'npm install');
      expect(state().loading, isFalse);
    });

    test('createWorktree tworzy nowe worktree i odświeża listę', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final project = await ctrl().createWorktree('feature/test', baseBranch: 'main');
      expect(project, isNotNull);
      expect(repo.calls, contains('create:p1:feature/test:main'));

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().worktrees.any((w) => w.branch == 'feature/test'), isTrue);
    });

    test('openWorktree otwiera powiązany projekt worktree', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final proj = await ctrl().openWorktree('/repo/.worktrees/feature-auth');
      expect(proj, isNotNull);
      expect(repo.calls, contains('open:p1:/repo/.worktrees/feature-auth'));
      expect(state().busy, isFalse);
    });

    test('mergeWorktree wykonuje merge i odświeża listę', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final res = await ctrl().mergeWorktree(
        '/repo/.worktrees/feature-auth',
        squash: true,
        message: 'Squash commit',
        removeAfterMerge: true,
      );
      expect(res, isNotNull);
      expect(res?.mergedBranch, 'feature/auth');
      expect(
        repo.calls,
        contains('merge:p1:/repo/.worktrees/feature-auth:squash=true:msg=Squash commit:clean=true'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));
      // Po usunięciu z opcją removeAfterMerge worktree znika z listy
      expect(state().worktrees.any((w) => w.path == '/repo/.worktrees/feature-auth'), isFalse);
    });

    test('removeWorktree usuwa worktree z opcją force i deleteBranch', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final res = await ctrl().removeWorktree(
        '/repo/.worktrees/feature-auth',
        force: true,
        deleteBranch: true,
      );
      expect(res, isNotNull);
      expect(
        repo.calls,
        contains('remove:p1:/repo/.worktrees/feature-auth:force=true:delBranch=true'),
      );

      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().worktrees.any((w) => w.path == '/repo/.worktrees/feature-auth'), isFalse);
    });

    test('saveConfig zapisuje skrypty setup i run', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final ok = await ctrl().saveConfig(setup: 'cargo check', run: 'cargo run', runPort: 8080);
      expect(ok, isTrue);
      expect(repo.calls, contains('saveConfig:p1:cargo check:cargo run:8080'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      expect(state().scriptsStatus?.scripts.run, 'cargo run');
    });

    test('runScript oraz stopScript sterują procesem deweloperskim', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      final runOk = await ctrl().runScript('p_wt_auth');
      expect(runOk, isTrue);
      expect(repo.calls, contains('run:p_wt_auth'));

      final stopOk = await ctrl().stopScript('p_wt_auth');
      expect(stopOk, isTrue);
      expect(repo.calls, contains('stop:p_wt_auth'));
    });

    test('błąd serwera ustawia error i resetuje busy', () async {
      ctrl().selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 20));

      repo.opError = const ServerError('Cannot create worktree', 500);
      final res = await ctrl().createWorktree('broken');
      expect(res, isNull);
      expect(state().busy, isFalse);
      expect(state().error, 'Cannot create worktree');

      ctrl().clearError();
      expect(state().error, isNull);
    });
  });

  group('3. Testy widgetowe WorktreesScreen (End-to-end workflow)', () {
    testWidgets('wyświetlanie listy: main i linked worktrees z badgeami i akcjami', (tester) async {
      final repo = _FakeWorktreesRepo();
      await tester.pumpWidget(_buildApp(repo: repo));
      await tester.pumpAndSettle();

      expect(find.text('Worktrees'), findsOneWidget);
      expect(find.text('main'), findsWidgets);
      expect(find.text('feature/auth'), findsOneWidget);
      expect(find.text('2 change(s)'), findsOneWidget);
      expect(find.text('1↑ 0↓'), findsOneWidget);
      expect(find.text('Add auth module'), findsOneWidget);
      expect(find.text('Open'), findsNWidgets(2));
      expect(find.text('Merge'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('pełny cykl: create → open → run script → merge → remove', (tester) async {
      final repo = _FakeWorktreesRepo();
      await tester.pumpWidget(_buildApp(repo: repo));
      await tester.pumpAndSettle();

      // Krok 1: CREATE worktree
      await tester.tap(find.text('New worktree'));
      await tester.pumpAndSettle();

      expect(find.text('New worktree'), findsWidgets);
      await tester.enterText(find.byType(TextField).first, 'feature/e2e');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('create:p1:feature/e2e:main'));
      expect(find.text('feature/e2e'), findsOneWidget);

      // Krok 2: OPEN worktree
      final openButtons = find.text('Open');
      await tester.tap(openButtons.last);
      await tester.pumpAndSettle();
      expect(repo.calls, contains('open:p1:/repo/.worktrees/feature/e2e'));

      // Krok 3: RUN SCRIPT
      final runButtons = find.text('Run');
      await tester.tap(runButtons.first);
      await tester.pumpAndSettle();
      expect(repo.calls.any((c) => c.startsWith('run:')), isTrue);

      // Krok 4: MERGE worktree
      await tester.tap(find.text('Merge').first);
      await tester.pumpAndSettle();

      expect(find.text('Squash commits'), findsOneWidget);
      await tester.tap(find.text('Squash commits'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Squash & Merge'));
      await tester.pumpAndSettle();
      expect(repo.calls.any((c) => c.startsWith('merge:p1:')), isTrue);

      // Krok 5: REMOVE worktree
      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      // W modalnym potwierdzeniu usuwania: zaznacz force remove
      await tester.tap(find.text('Force remove (discard changes)'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      expect(repo.calls.any((c) => c.startsWith('remove:p1:')), isTrue);
    });

    testWidgets('konfiguracja skryptów w dialogu Scripts', (tester) async {
      final repo = _FakeWorktreesRepo();
      await tester.pumpWidget(_buildApp(repo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scripts'));
      await tester.pumpAndSettle();

      expect(find.text('Worktree scripts'), findsOneWidget);
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(3));

      await tester.enterText(textFields.at(0), 'npm run build');
      await tester.enterText(textFields.at(1), 'npm start');
      await tester.enterText(textFields.at(2), '4000');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(repo.calls, contains('saveConfig:p1:npm run build:npm start:4000'));
    });

    testWidgets('dark theme i wąski ekran 360px bez overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final repo = _FakeWorktreesRepo();
      await tester.pumpWidget(_buildApp(repo: repo, dark: true));
      await tester.pumpAndSettle();

      expect(find.text('feature/auth'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

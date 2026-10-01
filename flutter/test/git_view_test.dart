import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/git/view/git_diff_viewer.dart';
import 'package:ddagent_app/features/git/view/git_screen.dart';
import 'package:ddagent_app/features/projects/data/projects_repository.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'git_test.dart' show FakeGitRepository;

class _ViewGit extends FakeGitRepository {
  String diffText =
      'diff --git a/a.dart b/a.dart\n'
      'index 1..2 100644\n'
      '--- a/a.dart\n'
      '+++ b/a.dart\n'
      '@@ -1,2 +1,3 @@\n'
      ' context\n'
      '-removed\n'
      '+added\n'
      '+added2\n'
      '@@ -10,1 +10,1 @@\n'
      '-old\n'
      '+new\n';

  @override
  Future<Map<String, dynamic>> diff(String p, {String? filePath}) async {
    calls.add('diff:$filePath');
    return {'diff': diffText};
  }
}

class _FakeProjects extends ProjectsRepository {
  _FakeProjects() : super(Dio());

  @override
  Future<List<Project>> list({
    bool skipSync = false,
    int? sessionsLimit,
    int? sessionsOffset,
  }) async => [];

  @override
  Future<List<Project>> archived() async => [];
}

Widget _app(_ViewGit git, {String projectId = 'p1'}) => ProviderScope(
  overrides: [
    gitRepositoryProvider.overrideWithValue(git),
    projectsRepositoryProvider.overrideWithValue(_FakeProjects()),
  ],
  child: MaterialApp(
    theme: AppTheme.light(),
    home: Scaffold(body: GitScreen(projectId: projectId)),
  ),
);

Future<void> _pump(WidgetTester tester, _ViewGit git) async {
  await tester.pumpWidget(_app(git));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    Hive.init('/tmp/ddagent_test_hive_git_view');
    if (!Hive.isBoxOpen('settings')) await Hive.openBox<dynamic>('settings');
  });

  group('buildSplitDiffRows', () {
    test('pairs removed/added runs and keeps headers', () {
      final rows = buildSplitDiffRows(const [
        '@@ -1,3 +1,4 @@',
        ' ctx',
        '-a',
        '-b',
        '+x',
        ' tail',
      ]);
      expect(rows[0], isA<SplitHeaderRow>());
      expect((rows[0] as SplitHeaderRow).text, '@@ -1,3 +1,4 @@');
      final ctx = rows[1] as SplitContentRow;
      expect(ctx.left, ' ctx');
      expect(ctx.right, ' ctx');
      final pair = rows[2] as SplitContentRow;
      expect(pair.left, '-a');
      expect(pair.right, '+x');
      final unpaired = rows[3] as SplitContentRow;
      expect(unpaired.left, '-b');
      expect(unpaired.right, isNull);
      expect((rows[4] as SplitContentRow).left, ' tail');
    });
  });

  group('not a git repository', () {
    testWidgets('shows init CTA and calls POST /init', (tester) async {
      final git = _ViewGit()
        ..statusError = const ServerError('Not a git repository', 400);
      await _pump(tester, git);
      expect(find.text('No git repository'), findsOneWidget);
      await tester.tap(find.text('Run git init'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('init'));
    });
  });

  group('header', () {
    testWidgets('renders branch, remote counts and action buttons', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      expect(find.text('main'), findsWidgets);
      expect(find.text('Fetch'), findsOneWidget);
      expect(find.text('Pull 1'), findsOneWidget);
      expect(find.text('Push 2'), findsOneWidget);
    });

    testWidgets('branch menu lists branches and creates a new one', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.byType(PopupMenuButton<String>).first);
      await tester.pumpAndSettle();
      expect(find.text('dev'), findsOneWidget);
      expect(find.text('origin/feature'), findsOneWidget);
      await tester.tap(find.text('New branch…'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(AppDialog),
          matching: find.byType(TextField),
        ),
        'feature-x',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('createBranch:feature-x'));
      expect(git.calls, contains('checkout:feature-x'));
    });

    testWidgets('fetch/pull/push buttons hit the remote endpoints', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Fetch'));
      await tester.pumpAndSettle();
      // Pull/push are gated by ConfirmActionModal in the web UI.
      await tester.tap(find.text('Pull 1'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Pull'), findsOneWidget);
      await tester.tap(find.text('Pull'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Push 2'));
      await tester.pumpAndSettle();
      expect(find.text('Confirm Push'), findsOneWidget);
      await tester.tap(find.text('Push'));
      await tester.pumpAndSettle();
      expect(git.calls, containsAll(['fetch', 'pull', 'push']));
    });

    testWidgets('cancelling the pull confirm does not hit the endpoint', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Pull 1'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(git.calls, isNot(contains('pull')));
    });
  });

  group('changes lists', () {
    testWidgets('renders staged and unstaged sections with counts', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      expect(find.text('Staged Changes (1)'), findsOneWidget);
      expect(find.text('Changes (3)'), findsOneWidget);
      expect(find.text('s.dart'), findsOneWidget);
      expect(find.text('a.dart'), findsOneWidget);
      expect(find.text('old.dart'), findsOneWidget);
      expect(find.text('new.dart'), findsOneWidget);
    });

    testWidgets('Stage All / Unstage All hit bulk endpoints', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Stage All'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('stage:a.dart,old.dart,new.dart'));
      await tester.tap(find.text('Unstage All'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('unstage:s.dart'));
    });

    testWidgets('per-file checkbox stages the file', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      final row = find.ancestor(
        of: find.text('a.dart'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: row, matching: find.byType(Checkbox)),
      );
      await tester.pumpAndSettle();
      expect(git.calls, contains('stage:a.dart'));
    });

    testWidgets('discard requires confirmation', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      final row = find.ancestor(
        of: find.text('a.dart'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: row, matching: find.byTooltip('Discard changes')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Discard Changes'), findsOneWidget);
      await tester.tap(find.text('Discard'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('discard:a.dart'));
    });

    testWidgets('untracked file deletes with confirmation', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      final row = find.ancestor(
        of: find.text('new.dart'),
        matching: find.byType(Card),
      );
      await tester.tap(
        find.descendant(of: row, matching: find.byTooltip('Delete file')),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('deleteUntracked:new.dart'));
    });
  });

  group('diff & hunks', () {
    testWidgets('expanding a file loads its diff and stages a hunk', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('a.dart'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('diff:a.dart'));
      expect(find.text('+added'), findsOneWidget);
      await tester.tap(find.text('+ Hunk').first);
      await tester.pumpAndSettle();
      expect(git.calls, contains('stageHunks:a.dart:0'));
    });

    testWidgets('staged rows unstage hunks', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('s.dart'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('diff:s.dart'));
      await tester.tap(find.text('− Hunk').first);
      await tester.pumpAndSettle();
      expect(git.calls, contains('unstageHunks:s.dart:0'));
    });

    testWidgets('split mode renders paired columns', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.byTooltip('Split diff'));
      await tester.pump();
      await tester.tap(find.text('a.dart'));
      await tester.pumpAndSettle();
      expect(find.text('-removed'), findsOneWidget);
      expect(find.text('+added'), findsOneWidget);
    });
  });

  group('commit composer', () {
    testWidgets('commits staged files with the typed message', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.enterText(find.byType(TextField).first, 'fix: bug');
      await tester.pump(); // enable the Commit button
      await tester.tap(find.text('Commit'));
      await tester.pumpAndSettle();
      // Web ConfirmActionModal gates the commit.
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('commit:fix: bug:s.dart'));
    });

    testWidgets('AI button fills the message field', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('✦ AI'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('generate:[s.dart]'));
      expect(find.text('feat: x'), findsOneWidget);
    });
  });

  group('checkpoints', () {
    testWidgets('dialog lists, creates and restores checkpoints', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.byTooltip('Checkpoints'));
      await tester.pumpAndSettle();
      expect(find.text('snap'), findsOneWidget);
      await tester.tap(find.text('Restore'));
      await tester.pumpAndSettle();
      // Confirm dialog.
      await tester.tap(find.text('Restore').last);
      await tester.pumpAndSettle();
      expect(git.calls, contains('restore:refs/ddagent/checkpoints/1'));
    });

    testWidgets('new checkpoint with label', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.byTooltip('Checkpoints'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).last, 'wip');
      await tester.tap(find.text('New'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('checkpoint:wip'));
    });
  });

  group('workspace pane', () {
    test('PaneKind.git round-trips through JSON and has title/icon', () {
      const pane = SplitPane(id: 'g1', kind: PaneKind.git, projectId: 'p1');
      final restored = SplitPane.fromJson(pane.toJson())!;
      expect(restored.kind, PaneKind.git);
      expect(paneKindIcon(PaneKind.git), isNotNull);
      final display = splitPaneDisplay(
        pane,
        sessionTitles: const {},
        projectNames: const {},
      );
      expect(display.title, 'Git');
    });
  });

  group('view tabs', () {
    testWidgets('Changes/Commits/Branches/Worktrees tabs switch views', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      // Changes tab shows the file sections; Changes tab has a count badge.
      expect(find.text('Staged Changes (1)'), findsOneWidget);
      await tester.tap(find.text('Commits'));
      await tester.pumpAndSettle();
      // Fake commits payload: one commit 'first' by 'A'.
      expect(find.text('first'), findsOneWidget);
      await tester.tap(find.text('Branches'));
      await tester.pumpAndSettle();
      expect(find.text('2 local, 1 remote'), findsOneWidget);
      expect(find.text('Search branches...'), findsOneWidget);
    });
  });

  group('commits tab (HistoryView)', () {
    testWidgets('expanding a commit lazily fetches its diff', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Commits'));
      await tester.pumpAndSettle();
      expect(find.text('first'), findsOneWidget);
      expect(find.text('HEAD -> main'), findsNothing); // label strips prefix
      expect(find.text('main'), findsWidgets); // ref badge label
      expect(git.calls, isNot(contains('commitDiff:abcdef1234567890')));
      await tester.tap(find.text('first'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('commitDiff:abcdef1234567890'));
      expect(find.text('+new'), findsOneWidget); // GitDiffViewer renders it
      // Collapsing and re-opening uses the cached diff — no second call.
      await tester.tap(find.text('first'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('first'));
      await tester.pumpAndSettle();
      expect(
        git.calls.where((c) => c == 'commitDiff:abcdef1234567890').length,
        1,
      );
    });
  });

  group('branches tab (BranchesView)', () {
    testWidgets('search filters local and remote branches', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Branches'));
      await tester.pumpAndSettle();
      expect(find.text('LOCAL'), findsOneWidget);
      expect(find.text('REMOTE'), findsOneWidget);
      expect(find.text('dev'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'feature');
      await tester.pump();
      expect(find.text('dev'), findsNothing);
      expect(find.text('origin/feature'), findsOneWidget);
      await tester.enterText(find.byType(TextField).first, 'zzz');
      await tester.pump();
      expect(find.text('No branches match your search'), findsOneWidget);
    });

    testWidgets('switch confirms then checks out', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Branches'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Switch'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('checkout:dev'));
    });

    testWidgets('delete branch supports the force-delete alternate', (
      tester,
    ) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Branches'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete dev'));
      await tester.pumpAndSettle();
      expect(find.text('Delete Branch'), findsOneWidget);
      // Normal delete → force=false.
      await tester.tap(find.text('Delete').last);
      await tester.pumpAndSettle();
      expect(git.calls, contains('deleteBranch:dev:false'));
      // Force delete → check the alternate card → force=true.
      await tester.tap(find.byTooltip('Delete dev'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Force delete this unmerged branch'));
      await tester.pump();
      await tester.tap(find.text('Force delete'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('deleteBranch:dev:true'));
    });

    testWidgets('new branch creates and checks out', (tester) async {
      final git = _ViewGit();
      await _pump(tester, git);
      await tester.tap(find.text('Branches'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('New branch'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(AppDialog),
          matching: find.byType(TextField),
        ),
        'topic',
      );
      await tester.tap(find.text('Create'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('createBranch:topic'));
      expect(git.calls, contains('checkout:topic'));
    });
  });

  group('publish & initial commit', () {
    testWidgets('publish button appears when branch has no upstream', (
      tester,
    ) async {
      final git = _ViewGit()
        ..remoteResult = const {
          'hasRemote': true,
          'hasUpstream': false,
          'branch': 'main',
          'remoteName': 'origin',
          'ahead': 2,
          'behind': 0,
          'isUpToDate': false,
        };
      await _pump(tester, git);
      expect(find.text('Publish'), findsOneWidget);
      await tester.tap(find.text('Publish'));
      await tester.pumpAndSettle();
      expect(find.text('Publish Branch'), findsOneWidget);
      await tester.tap(find.text('Publish').last);
      await tester.pumpAndSettle();
      expect(git.calls, contains('publish'));
    });

    testWidgets('repo without commits shows the initial-commit CTA', (
      tester,
    ) async {
      final git = _ViewGit()
        ..statusResult = const {
          'branch': 'main',
          'hasCommits': false,
          'modified': ['a.dart'],
          'added': <String>[],
          'deleted': <String>[],
          'untracked': <String>[],
          'staged': <String>[],
        }
        ..commitsResult = const {'commits': <dynamic>[]};
      await _pump(tester, git);
      expect(find.text('No commits yet'), findsOneWidget);
      await tester.tap(find.text('Create Initial Commit'));
      await tester.pumpAndSettle();
      expect(git.calls, contains('initialCommit'));
    });
  });
}

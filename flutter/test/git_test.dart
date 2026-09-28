import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/git/data/git_models.dart';
import 'package:ddagent_app/features/git/data/git_repository.dart';
import 'package:ddagent_app/features/git/state/git_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

  group('refresh', () {
    test('loads status, branches, commits, checkpoints, remote', () async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(c.read(gitProvider).status!.branch, 'main');
      expect(c.read(gitProvider).branches.local, ['main', 'dev']);
      expect(c.read(gitProvider).commits.single.shortHash, 'abcdef12');
      expect(
        c.read(gitProvider).checkpoints.single.ref,
        'refs/ddagent/checkpoints/1',
      );
      expect(c.read(gitProvider).remoteStatus.ahead, 2);
      expect(c.read(gitProvider).loading, isFalse);
    });

    test('non-git project maps to notGitRepository without an error', () async {
      repo.statusError = const ServerError('Not a git repository', 400);
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(c.read(gitProvider).notGitRepository, isTrue);
      expect(c.read(gitProvider).error, isNull);
    });
  });

  group('mutations', () {
    setUp(() async {
      c.read(gitProvider.notifier).selectProject('p1');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      repo.calls.clear();
    });

    test('stage/unstage/refresh', () async {
      expect(await c.read(gitProvider.notifier).stage(['a.dart']), isTrue);
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(repo.calls, contains('stage:a.dart'));
      expect(repo.calls, contains('status')); // refreshed
      expect(c.read(gitProvider).busy, isFalse);
    });

    test('stageAll sends unstaged + untracked', () async {
      await c.read(gitProvider.notifier).stageAll();
      expect(repo.calls, contains('stage:a.dart,old.dart,new.dart'));
    });

    test('hunk ops send zero-based indices', () async {
      const h = [0, 2];
      await c.read(gitProvider.notifier).stageHunks('a.dart', h);
      await c.read(gitProvider.notifier).unstageHunks('a.dart', h);
      expect(
        repo.calls,
        containsAll(['stageHunks:a.dart:0,2', 'unstageHunks:a.dart:0,2']),
      );
    });

    test(
      'commit sends message + files; generateCommitMessage returns text',
      () async {
        expect(
          await c.read(gitProvider.notifier).commit('msg', ['a.dart']),
          isTrue,
        );
        expect(repo.calls, contains('commit:msg:a.dart'));
        expect(
          await c.read(gitProvider.notifier).generateCommitMessage(['a.dart']),
          'feat: x',
        );
      },
    );

    test('branch ops', () async {
      await c.read(gitProvider.notifier).checkout('dev');
      await c.read(gitProvider.notifier).createBranch('feat');
      await c.read(gitProvider.notifier).deleteBranch('old');
      expect(
        repo.calls,
        containsAll(['checkout:dev', 'createBranch:feat', 'deleteBranch:old']),
      );
    });

    test('remote ops', () async {
      await c.read(gitProvider.notifier).fetch();
      await c.read(gitProvider.notifier).pull();
      await c.read(gitProvider.notifier).push();
      await c.read(gitProvider.notifier).publish();
      expect(repo.calls, containsAll(['fetch', 'pull', 'push', 'publish']));
    });

    test('destructive + checkpoints + init', () async {
      await c.read(gitProvider.notifier).discard('a.dart');
      await c.read(gitProvider.notifier).deleteUntracked('n.dart');
      await c.read(gitProvider.notifier).createCheckpoint(label: 'snap');
      await c.read(gitProvider.notifier).restoreCheckpoint('refs/x');
      await c.read(gitProvider.notifier).revertLocalCommit();
      await c.read(gitProvider.notifier).init();
      expect(
        repo.calls,
        containsAll([
          'discard:a.dart',
          'deleteUntracked:n.dart',
          'checkpoint:snap',
          'restore:refs/x',
          'revert',
          'init',
        ]),
      );
    });

    test('failed mutation surfaces the error and releases busy', () async {
      repo.opError = const ServerError('boom', 500);
      expect(await c.read(gitProvider.notifier).stage(['x']), isFalse);
      expect(c.read(gitProvider).error, 'boom');
      expect(c.read(gitProvider).busy, isFalse);
    });
  });
}

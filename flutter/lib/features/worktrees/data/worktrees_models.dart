/// Domain models for /api/worktrees — mirrors server/shared/types.ts + worktrees.routes.ts.
library;

String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();
int _int(Object? v, [int defaultValue = 0]) => (v as num?)?.toInt() ?? defaultValue;
int? _intOrNull(Object? v) => (v as num?)?.toInt();
bool _bool(Object? v, [bool defaultValue = false]) => v is bool ? v : defaultValue;

/// One worktree entry from `GET /api/worktrees`.
class WorktreeDescriptor {
  const WorktreeDescriptor({
    required this.path,
    this.branch,
    this.headSha,
    this.isMain = false,
    this.isCurrent = false,
    this.isLocked = false,
    this.isDetached = false,
    this.changedFileCount = 0,
    this.ahead = 0,
    this.behind = 0,
    this.lastCommitSubject,
    this.lastCommitDate,
    this.linkedProjectId,
    this.linkedProjectArchived = false,
  });

  final String path;
  final String? branch;
  final String? headSha;
  final bool isMain;
  final bool isCurrent;
  final bool isLocked;
  final bool isDetached;
  final int changedFileCount;
  final int ahead;
  final int behind;
  final String? lastCommitSubject;
  final String? lastCommitDate;
  final String? linkedProjectId;
  final bool linkedProjectArchived;

  String get shortPath {
    final normalized = path.replaceAll(r'\', '/');
    final segments = normalized.split('/').where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return path;
    if (segments.length <= 2) return segments.join('/');
    return '…/${segments[segments.length - 2]}/${segments.last}';
  }

  static WorktreeDescriptor fromJson(Map<String, dynamic> j) => WorktreeDescriptor(
    path: _str(j['path']),
    branch: _strOrNull(j['branch']),
    headSha: _strOrNull(j['headSha']),
    isMain: _bool(j['isMain']),
    isCurrent: _bool(j['isCurrent']),
    isLocked: _bool(j['isLocked']),
    isDetached: _bool(j['isDetached']),
    changedFileCount: _int(j['changedFileCount']),
    ahead: _int(j['ahead']),
    behind: _int(j['behind']),
    lastCommitSubject: _strOrNull(j['lastCommitSubject']),
    lastCommitDate: _strOrNull(j['lastCommitDate']),
    linkedProjectId: _strOrNull(j['linkedProjectId']),
    linkedProjectArchived: _bool(j['linkedProjectArchived']),
  );

  Map<String, dynamic> toJson() => {
    'path': path,
    'branch': branch,
    'headSha': headSha,
    'isMain': isMain,
    'isCurrent': isCurrent,
    'isLocked': isLocked,
    'isDetached': isDetached,
    'changedFileCount': changedFileCount,
    'ahead': ahead,
    'behind': behind,
    'lastCommitSubject': lastCommitSubject,
    'lastCommitDate': lastCommitDate,
    'linkedProjectId': linkedProjectId,
    'linkedProjectArchived': linkedProjectArchived,
  };
}

/// Response payload of `GET /api/worktrees`.
class WorktreeListData {
  const WorktreeListData({
    required this.repositoryRoot,
    this.baseBranch,
    this.worktrees = const [],
  });

  final String repositoryRoot;
  final String? baseBranch;
  final List<WorktreeDescriptor> worktrees;

  static WorktreeListData fromJson(Map<String, dynamic> j) {
    final list = j['worktrees'];
    return WorktreeListData(
      repositoryRoot: _str(j['repositoryRoot']),
      baseBranch: _strOrNull(j['baseBranch']),
      worktrees: list is List
          ? [
              for (final item in list)
                if (item is Map<String, dynamic>) WorktreeDescriptor.fromJson(item),
            ]
          : const [],
    );
  }
}

/// Setup / run script configuration for a repository.
class WorktreeScriptsConfig {
  const WorktreeScriptsConfig({
    this.setup,
    this.run,
    this.runPort,
    this.hasProjectOverride = false,
    this.hasRepoFile = false,
  });

  final String? setup;
  final String? run;
  final int? runPort;
  final bool hasProjectOverride;
  final bool hasRepoFile;

  static WorktreeScriptsConfig fromJson(Map<String, dynamic> j) => WorktreeScriptsConfig(
    setup: _strOrNull(j['setup']),
    run: _strOrNull(j['run']),
    runPort: _intOrNull(j['runPort']),
    hasProjectOverride: _bool(j['hasProjectOverride']),
    hasRepoFile: _bool(j['hasRepoFile']),
  );

  Map<String, dynamic> toJson() => {
    'setup': setup,
    'run': run,
    'runPort': runPort,
    'hasProjectOverride': hasProjectOverride,
    'hasRepoFile': hasRepoFile,
  };
}

/// Runtime status of a one-shot setup script.
class WorktreeSetupRuntime {
  const WorktreeSetupRuntime({
    this.status = 'idle',
    this.exitCode,
    this.startedAt,
    this.finishedAt,
    this.logTail = const [],
  });

  final String status; // 'idle' | 'running' | 'done' | 'failed'
  final int? exitCode;
  final String? startedAt;
  final String? finishedAt;
  final List<String> logTail;

  static WorktreeSetupRuntime fromJson(Map<String, dynamic> j) {
    final logs = j['logTail'];
    return WorktreeSetupRuntime(
      status: _str(j['status']).isEmpty ? 'idle' : _str(j['status']),
      exitCode: _intOrNull(j['exitCode']),
      startedAt: _strOrNull(j['startedAt']),
      finishedAt: _strOrNull(j['finishedAt']),
      logTail: logs is List ? [for (final l in logs) l.toString()] : const [],
    );
  }
}

/// Runtime status of a dev server / run script.
class WorktreeRunRuntime {
  const WorktreeRunRuntime({
    this.status = 'idle',
    this.exitCode,
    this.port,
    this.url,
    this.startedAt,
    this.finishedAt,
    this.logTail = const [],
  });

  final String status; // 'idle' | 'running' | 'exited'
  final int? exitCode;
  final int? port;
  final String? url;
  final String? startedAt;
  final String? finishedAt;
  final List<String> logTail;

  static WorktreeRunRuntime fromJson(Map<String, dynamic> j) {
    final logs = j['logTail'];
    return WorktreeRunRuntime(
      status: _str(j['status']).isEmpty ? 'idle' : _str(j['status']),
      exitCode: _intOrNull(j['exitCode']),
      port: _intOrNull(j['port']),
      url: _strOrNull(j['url']),
      startedAt: _strOrNull(j['startedAt']),
      finishedAt: _strOrNull(j['finishedAt']),
      logTail: logs is List ? [for (final l in logs) l.toString()] : const [],
    );
  }
}

/// Combined setup + run runtime state for a worktree.
class WorktreeRuntimeInfo {
  const WorktreeRuntimeInfo({
    this.setup = const WorktreeSetupRuntime(),
    this.run = const WorktreeRunRuntime(),
  });

  final WorktreeSetupRuntime setup;
  final WorktreeRunRuntime run;

  static WorktreeRuntimeInfo fromJson(Map<String, dynamic> j) => WorktreeRuntimeInfo(
    setup: j['setup'] is Map<String, dynamic>
        ? WorktreeSetupRuntime.fromJson(j['setup'] as Map<String, dynamic>)
        : const WorktreeSetupRuntime(),
    run: j['run'] is Map<String, dynamic>
        ? WorktreeRunRuntime.fromJson(j['run'] as Map<String, dynamic>)
        : const WorktreeRunRuntime(),
  );
}

/// Response payload of `GET /api/worktrees/status`.
class WorktreeScriptsStatus {
  const WorktreeScriptsStatus({
    this.scripts = const WorktreeScriptsConfig(),
    this.runtimes = const {},
  });

  final WorktreeScriptsConfig scripts;
  final Map<String, WorktreeRuntimeInfo> runtimes;

  static WorktreeScriptsStatus fromJson(Map<String, dynamic> j) {
    final rawScripts = j['scripts'];
    final rawRuntimes = j['runtimes'];
    return WorktreeScriptsStatus(
      scripts: rawScripts is Map<String, dynamic>
          ? WorktreeScriptsConfig.fromJson(rawScripts)
          : const WorktreeScriptsConfig(),
      runtimes: rawRuntimes is Map<String, dynamic>
          ? {
              for (final entry in rawRuntimes.entries)
                if (entry.value is Map<String, dynamic>)
                  entry.key: WorktreeRuntimeInfo.fromJson(entry.value as Map<String, dynamic>),
            }
          : const {},
    );
  }
}

/// Result of removing a worktree.
class RemoveWorktreeResult {
  const RemoveWorktreeResult({
    required this.worktreePath,
    this.branch,
    this.branchDeleted = false,
    this.deletedProject = false,
    this.archivedProject = false,
  });

  final String worktreePath;
  final String? branch;
  final bool branchDeleted;
  final bool deletedProject;
  final bool archivedProject;

  static RemoveWorktreeResult fromJson(Map<String, dynamic> j) => RemoveWorktreeResult(
    worktreePath: _str(j['worktreePath']),
    branch: _strOrNull(j['branch']),
    branchDeleted: _bool(j['branchDeleted']),
    deletedProject: _bool(j['deletedProject']),
    archivedProject: _bool(j['archivedProject']),
  );
}

/// Result of merging a worktree into target base branch.
class MergeWorktreeResult {
  const MergeWorktreeResult({
    required this.mergedBranch,
    required this.targetBranch,
    this.squash = false,
    this.removedWorktree,
    this.cleanupError,
  });

  final String mergedBranch;
  final String targetBranch;
  final bool squash;
  final RemoveWorktreeResult? removedWorktree;
  final String? cleanupError;

  static MergeWorktreeResult fromJson(Map<String, dynamic> j) => MergeWorktreeResult(
    mergedBranch: _str(j['mergedBranch']),
    targetBranch: _str(j['targetBranch']),
    squash: _bool(j['squash']),
    removedWorktree: j['removedWorktree'] is Map<String, dynamic>
        ? RemoveWorktreeResult.fromJson(j['removedWorktree'] as Map<String, dynamic>)
        : null,
    cleanupError: _strOrNull(j['cleanupError']),
  );
}

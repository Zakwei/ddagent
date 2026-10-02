/// Domain models for the git panel — defensive decoders over the
/// `/api/git` payload shapes (git.routes.ts).
library;

class GitStatus {
  const GitStatus({
    this.branch,
    this.hasCommits = false,
    this.modified = const [],
    this.added = const [],
    this.deleted = const [],
    this.untracked = const [],
    this.staged = const [],
    this.notGitRepository = false,
  });

  final String? branch;
  final bool hasCommits;
  final List<String> modified;
  final List<String> added;
  final List<String> deleted;
  final List<String> untracked;
  final List<String> staged;

  /// The project isn't a git repository — the UI offers `git init`.
  final bool notGitRepository;

  /// Unstaged-but-tracked changes (modified+deleted+added on the worktree
  /// side) — the panel's "Unstaged" section.
  List<String> get unstaged => [...modified, ...added, ...deleted];

  int get totalChanges =>
      staged.length + modified.length + added.length + deleted.length + untracked.length;

  static List<String> _paths(Object? v) => [for (final e in v as List? ?? const []) e.toString()];

  factory GitStatus.fromJson(Map<String, dynamic> j) => GitStatus(
    branch: j['branch']?.toString(),
    hasCommits: j['hasCommits'] == true,
    modified: _paths(j['modified']),
    added: _paths(j['added']),
    deleted: _paths(j['deleted']),
    untracked: _paths(j['untracked']),
    staged: _paths(j['staged']),
  );
}

class GitBranches {
  const GitBranches({this.all = const [], this.local = const [], this.remote = const []});

  final List<String> all;
  final List<String> local;
  final List<String> remote;

  factory GitBranches.fromJson(Map<String, dynamic> j) => GitBranches(
    all: GitStatus._paths(j['branches']),
    local: GitStatus._paths(j['localBranches']),
    remote: GitStatus._paths(j['remoteBranches']),
  );
}

class GitCommit {
  const GitCommit({
    required this.hash,
    this.message = '',
    this.author = '',
    this.email = '',
    this.date,
    this.refs = const [],
    this.parents = const [],
    this.stats = '',
  });

  final String hash;
  final String message;
  final String author;
  final String email;
  final String? date;
  final List<String> refs;

  /// Parent hashes — drive the History view commit graph.
  final List<String> parents;
  final String stats;

  String get shortHash => hash.length > 8 ? hash.substring(0, 8) : hash;

  factory GitCommit.fromJson(Map<String, dynamic> j) => GitCommit(
    hash: (j['hash'] ?? j['sha'] ?? '').toString(),
    message: (j['message'] ?? '').toString(),
    author: (j['author'] ?? '').toString(),
    email: (j['email'] ?? '').toString(),
    date: j['date']?.toString(),
    refs: GitStatus._paths(j['refs']),
    parents: GitStatus._paths(j['parents']),
    stats: (j['stats'] ?? '').toString(),
  );
}

class GitCheckpoint {
  const GitCheckpoint({required this.ref, this.commit = '', this.createdAt, this.label = ''});

  final String ref;
  final String commit;
  final String? createdAt;
  final String label;

  factory GitCheckpoint.fromJson(Map<String, dynamic> j) => GitCheckpoint(
    ref: (j['ref'] ?? '').toString(),
    commit: (j['commit'] ?? '').toString(),
    createdAt: j['createdAt']?.toString(),
    label: (j['label'] ?? j['subject'] ?? '').toString(),
  );
}

class GitRemoteStatus {
  const GitRemoteStatus({
    this.hasRemote = false,
    this.hasUpstream = false,
    this.branch,
    this.remoteName,
    this.ahead = 0,
    this.behind = 0,
    this.isUpToDate = false,
    this.message,
  });

  final bool hasRemote;
  final bool hasUpstream;
  final String? branch;
  final String? remoteName;
  final int ahead;
  final int behind;
  final bool isUpToDate;
  final String? message;

  factory GitRemoteStatus.fromJson(Map<String, dynamic> j) => GitRemoteStatus(
    hasRemote: j['hasRemote'] == true,
    hasUpstream: j['hasUpstream'] == true,
    branch: j['branch']?.toString(),
    remoteName: j['remoteName']?.toString(),
    ahead: (j['ahead'] as num?)?.toInt() ?? 0,
    behind: (j['behind'] as num?)?.toInt() ?? 0,
    isUpToDate: j['isUpToDate'] == true,
    message: j['message']?.toString(),
  );
}

/// Skills models — port of `src/components/skills/types.ts`. Provider is kept
/// as a plain `String` (the API's LLMProvider ids are open-ended).
library;

import 'dart:typed_data';

/// Where a skill was discovered — `SkillsScope`. Order matters: groups render
/// in declaration order (`SCOPE_ORDER` in ProviderSkills.tsx).
enum SkillScope {
  user('user', 'User'),
  plugin('plugin', 'Plugin'),
  repo('repo', 'Repo'),
  project('project', 'Project'),
  admin('admin', 'Admin'),
  system('system', 'System');

  const SkillScope(this.wire, this.label);

  /// Wire name sent by the API.
  final String wire;

  /// `SCOPE_LABELS` badge text.
  final String label;

  /// `normalizeScope` — unknown/missing scopes become `user`.
  static SkillScope parse(Object? value) => switch (value) {
    'plugin' => SkillScope.plugin,
    'repo' => SkillScope.repo,
    'project' => SkillScope.project,
    'admin' => SkillScope.admin,
    'system' => SkillScope.system,
    _ => SkillScope.user,
  };
}

/// One project as a skills-scope fetch target — `ProjectTarget` in the web
/// hook (`path` = `fullPath || path`, deduped, sorted by path).
class SkillProjectTarget {
  const SkillProjectTarget({
    required this.projectId,
    required this.displayName,
    required this.path,
  });

  /// The DB `projectId`.
  final String projectId;
  final String displayName;

  /// Workspace path sent as `?workspacePath=` in scoped list calls.
  final String path;
}

/// One discovered skill — `ProviderSkill` plus the `normalizeSkill` defaults
/// the web hook applies to API rows.
class ProviderSkill {
  const ProviderSkill({
    required this.provider,
    required this.name,
    required this.description,
    required this.command,
    required this.scope,
    required this.sourcePath,
    this.pluginName,
    this.pluginId,
    this.projectDisplayName,
    this.projectPath,
  });

  final String provider;
  final String name;
  final String description;

  /// Exact invocation text (`/skill-name`, `$skill-name`, `/plugin:skill`).
  final String command;
  final SkillScope scope;

  /// Path to the SKILL.md that produced this record.
  final String sourcePath;
  final String? pluginName;
  final String? pluginId;
  final String? projectDisplayName;
  final String? projectPath;

  /// `getSkillIdentity` — dedupe key for merging global + per-project fetches.
  String get identity => [
    provider,
    scope.wire,
    command,
    sourcePath.isEmpty ? 'no-source-path' : sourcePath,
    projectPath ?? 'global',
  ].join(':');

  /// `normalizeSkill` — `projectDisplayName`/`projectPath` get stamped from
  /// the fetch target when the scope is project/repo.
  factory ProviderSkill.fromApi(
    String provider,
    Map<String, dynamic> json, {
    SkillProjectTarget? project,
  }) {
    final scope = SkillScope.parse(json['scope']);
    final attachProject = scope == SkillScope.project || scope == SkillScope.repo;
    return ProviderSkill(
      provider: provider,
      name: '${json['name'] ?? ''}',
      description: '${json['description'] ?? ''}',
      command: '${json['command'] ?? ''}',
      scope: scope,
      sourcePath: '${json['sourcePath'] ?? ''}',
      pluginName: json['pluginName'] is String ? json['pluginName'] as String : null,
      pluginId: json['pluginId'] is String ? json['pluginId'] as String : null,
      projectDisplayName: attachProject
          ? (project?.displayName ?? json['projectDisplayName'] as String?)
          : json['projectDisplayName'] as String?,
      projectPath: attachProject
          ? (project?.path ?? json['projectPath'] as String?)
          : json['projectPath'] as String?,
    );
  }
}

/// A folder-scan input file — the browser's `File` stand-in
/// (`getBrowserRelativePath` output + bytes for the upload payload).
class SkillSourceFile {
  const SkillSourceFile({
    required this.relativePath,
    required this.bytes,
    this.lastModifiedMillis = 0,
  });

  /// Path relative to the picked folder's parent — i.e. prefixed with the
  /// picked folder name, matching `webkitRelativePath` shape.
  final String relativePath;
  final Uint8List bytes;
  final int lastModifiedMillis;

  int get size => bytes.length;
}

/// One queued install — `QueuedSkillFile`: either a standalone markdown file
/// or a folder rooted at a SKILL.md.
class QueuedSkillFile {
  const QueuedSkillFile({
    required this.id,
    required this.name,
    required this.size,
    required this.kind,
    required this.skillFile,
    required this.files,
  });

  final String id;
  final String name;
  final int size;
  final QueuedSkillKind kind;

  /// The SKILL.md (or standalone .md) source.
  final SkillSourceFile skillFile;

  /// All files belonging to this skill, `relativePath` rebased under the
  /// skill root (SKILL.md sits at `'SKILL.md'`).
  final List<SkillSourceFile> files;
}

enum QueuedSkillKind { markdown, folder }

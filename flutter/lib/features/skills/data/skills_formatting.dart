import 'dart:convert';

import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/features/skills/data/skills_constants.dart';
import 'package:ddagent_app/i18n/strings.g.dart';

/// Skills helpers — port of the pure functions in `ProviderSkills.tsx` +
/// `useProviderSkills.ts` (search/merge/sort/group, managed-dir detection,
/// upload queue building, POST `entries` payload).

/// Thrown when a picked folder can't produce a skill queue entry — the dialog
/// renders [message] inline (web throws `Error` into `submitError`).
class SkillPayloadException implements Exception {
  const SkillPayloadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// `getManagedSkillDirectoryName` — a listed skill is deletable only when its
/// SKILL.md is a direct child of the provider's managed root (the DELETE
/// route takes a plain directory name).
String? managedSkillDirectoryName(ProviderSkill skill) {
  final managedDir = kSkillManagedDirs[skill.provider];
  if (managedDir == null) return null;

  final segments = [
    for (final s in skill.sourcePath.replaceAll('\\', '/').split('/'))
      if (s.isNotEmpty) s,
  ];
  if (segments.length < 3 || segments.last.toLowerCase() != 'skill.md') {
    return null;
  }

  final rootPath = segments.sublist(0, segments.length - 2).join('/');
  final directoryName = segments[segments.length - 2];
  final isManaged = rootPath == managedDir || rootPath.endsWith('/$managedDir');
  return isManaged && directoryName.isNotEmpty ? directoryName : null;
}

/// `sortSkills` — scope order, then project display name, then command.
List<ProviderSkill> sortProviderSkills(List<ProviderSkill> skills) => [...skills]
  ..sort((a, b) {
    final scopeDelta = a.scope.index - b.scope.index;
    if (scopeDelta != 0) return scopeDelta;
    final projectDelta = (a.projectDisplayName ?? '').compareTo(b.projectDisplayName ?? '');
    if (projectDelta != 0) return projectDelta;
    return a.command.compareTo(b.command);
  });

/// `mergeSkills` — dedupe on [ProviderSkill.identity], sorted.
List<ProviderSkill> mergeProviderSkills(
  List<ProviderSkill> existing,
  List<ProviderSkill> incoming,
) {
  final byId = {for (final s in existing) s.identity: s};
  for (final s in incoming) {
    byId[s.identity] = s;
  }
  return sortProviderSkills(byId.values.toList());
}

/// `groupSkillsByScope` — non-empty groups in `SCOPE_ORDER`.
List<({SkillScope scope, List<ProviderSkill> skills})> groupSkillsByScope(
  List<ProviderSkill> skills,
) => [
  for (final scope in kSkillScopeOrder)
    if (skills.any((s) => s.scope == scope))
      (
        scope: scope,
        skills: [
          for (final s in skills)
            if (s.scope == scope) s,
        ],
      ),
];

/// `filteredSkills` — query matches command/name/description/scope/plugin/
/// project/sourcePath.
List<ProviderSkill> filterSkills(List<ProviderSkill> skills, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return skills;
  return [
    for (final s in skills)
      if ([
        s.command,
        s.name,
        s.description,
        s.scope.wire,
        s.pluginName,
        s.projectDisplayName,
        s.sourcePath,
      ].any((v) => v != null && v.toLowerCase().contains(q)))
        s,
  ];
}

/// `formatFileSize` — B / x.x KB / x.x MB.
String formatSkillFileSize(int size) {
  if (size < 1024) return '$size B';
  if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
  return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
}

String _parentPath(String filePath) {
  final sep = filePath.lastIndexOf('/');
  return sep >= 0 ? filePath.substring(0, sep) : '';
}

/// `getBaseName` — last path segment ('skill' fallback).
String skillBaseName(String filePath) {
  final segments = [
    for (final s in filePath.split('/'))
      if (s.isNotEmpty) s,
  ];
  return segments.isEmpty ? 'skill' : segments.last;
}

/// `buildQueuedSkillFolders` — every SKILL.md in the picked tree roots one
/// queued folder skill; each file belongs to the deepest root containing it.
/// Enforces [kSkillFolderMaxFiles]/[kSkillFolderMaxBytes].
List<QueuedSkillFile> buildQueuedSkillFolders(List<SkillSourceFile> files) {
  if (files.length > kSkillFolderMaxFiles) {
    throw SkillPayloadException(t.skills.errors.folderFileLimit(count: kSkillFolderMaxFiles));
  }
  final totalSize = files.fold<int>(0, (sum, f) => sum + f.size);
  if (totalSize > kSkillFolderMaxBytes) {
    throw SkillPayloadException(t.skills.errors.folderSizeLimit);
  }

  final skillRoots = [
    for (final f in files)
      if (skillBaseName(f.relativePath).toLowerCase() == 'skill.md') _parentPath(f.relativePath),
  ]..sort((a, b) => b.length.compareTo(a.length));

  if (skillRoots.isEmpty) {
    throw SkillPayloadException(t.skills.errors.missingSkillFile);
  }

  return [for (final root in skillRoots) _buildFolderEntry(root, files, skillRoots)];
}

QueuedSkillFile _buildFolderEntry(
  String root,
  List<SkillSourceFile> files,
  List<String> skillRoots,
) {
  final owned = [
    for (final f in files)
      if (_owningRoot(f.relativePath, skillRoots) == root) f,
  ];
  final skillSource = owned
      .where((f) => f.relativePath.toLowerCase() == '$root/skill.md'.toLowerCase())
      .firstOrNull;
  if (skillSource == null) {
    throw SkillPayloadException(t.skills.errors.couldNotReadSkillFile(name: skillBaseName(root)));
  }

  return QueuedSkillFile(
    id: 'folder:$root:${[for (final f in owned) f.lastModifiedMillis].join(':')}',
    name: skillBaseName(root),
    size: owned.fold<int>(0, (sum, f) => sum + f.size),
    kind: QueuedSkillKind.folder,
    skillFile: skillSource,
    files: [
      for (final f in owned)
        SkillSourceFile(
          relativePath: root.isEmpty ? f.relativePath : f.relativePath.substring(root.length + 1),
          bytes: f.bytes,
          lastModifiedMillis: f.lastModifiedMillis,
        ),
    ],
  );
}

/// Deepest skill root owning [relativePath] — `skillRoots.find` over the
/// length-desc sorted list.
String? _owningRoot(String relativePath, List<String> skillRoots) {
  for (final root in skillRoots) {
    if (relativePath.toLowerCase() == '$root/skill.md'.toLowerCase() ||
        relativePath.startsWith('$root/')) {
      return root;
    }
  }
  return null;
}

/// Queue one standalone markdown file — the web `handleDrop` `.md` branch
/// (each file pretends to be a one-file SKILL.md bundle).
QueuedSkillFile queueMarkdownFile(SkillSourceFile file) {
  final id = '${file.relativePath}:${file.size}:${file.lastModifiedMillis}';
  return QueuedSkillFile(
    id: id,
    name: file.relativePath,
    size: file.size,
    kind: QueuedSkillKind.markdown,
    skillFile: file,
    files: [
      SkillSourceFile(
        relativePath: 'SKILL.md',
        bytes: file.bytes,
        lastModifiedMillis: file.lastModifiedMillis,
      ),
    ],
  );
}

/// `handleUploadInstall` payload — POST `{entries: [...]}` where each queued
/// entry maps like the web (`fileName`, `directoryName` for folders, markdown
/// `content`, `files` carrying non-SKILL.md assets as base64).
Future<List<Map<String, dynamic>>> buildSkillEntries(List<QueuedSkillFile> queued) async {
  String text(SkillSourceFile f) => utf8.decode(f.bytes, allowMalformed: true);

  return [
    for (final q in queued)
      switch (q.kind) {
        QueuedSkillKind.markdown => {'fileName': q.name, 'content': text(q.skillFile)},
        QueuedSkillKind.folder => {
          'fileName': '${q.name}.md',
          'directoryName': q.name,
          'content': text(q.skillFile),
          'files': [
            for (final f in q.files)
              if (f.relativePath.toLowerCase() != 'skill.md')
                {
                  'relativePath': f.relativePath,
                  'content': base64Encode(f.bytes),
                  'encoding': 'base64',
                },
          ],
        },
      },
  ];
}

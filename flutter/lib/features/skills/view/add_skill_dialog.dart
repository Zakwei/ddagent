import 'dart:io';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/skills/data/skill_models.dart';
import 'package:ddagent_app/features/skills/data/skills_constants.dart';
import 'package:ddagent_app/features/skills/data/skills_formatting.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Submit callback — receives the POST `{entries}` payload list built by
/// [buildSkillEntries]; returns null on success, otherwise the message shown
/// as `submitError`.
typedef SkillSubmit = Future<String?> Function(
  List<Map<String, dynamic>> entries,
);

/// "Add {provider} Skill" dialog — port of the ProviderSkills.tsx upload
/// panel + dialog. Picking folders needs `dart:io` (`getDirectoryPath` +
/// recursive walk), so the folder button is hidden on web builds — the web
/// client's `webkitdirectory` folder input has no file_picker equivalent.
/// Drag-drop is intentionally absent: the repo's only drop listener is the
/// document-global one owned by the chat composer (files only, no folders).
class AddSkillDialog extends StatefulWidget {
  const AddSkillDialog({
    super.key,
    required this.provider,
    required this.onSubmit,
  });

  final String provider;
  final SkillSubmit onSubmit;

  /// Resolves to true when at least one skill was installed — callers toast.
  static Future<bool> show(
    BuildContext context, {
    required String provider,
    required SkillSubmit onSubmit,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AddSkillDialog(provider: provider, onSubmit: onSubmit),
    );
    return result ?? false;
  }

  @override
  State<AddSkillDialog> createState() => _AddSkillDialogState();
}

class _AddSkillDialogState extends State<AddSkillDialog> {
  List<QueuedSkillFile> _queued = const [];
  String? _submitError;
  bool _submitting = false;
  bool _showInstallPath = false;

  /// `nextMap.set` + `.slice(0, 20)` — dedupe by id, capped queue.
  void _enqueue(List<QueuedSkillFile> entries) => setState(() {
    final map = {for (final f in _queued) f.id: f};
    for (final f in entries) {
      map[f.id] = f;
    }
    _queued = map.values.take(kSkillQueueMax).toList();
    _submitError = null;
  });

  /// "Choose Files" — the `handleDrop` loose-files branch: `.md` only,
  /// deduped into the queue.
  Future<void> _pickFiles() async {
    final picked = await FilePicker.pickFiles(
      dialogTitle: 'Choose SKILL.md',
      type: FileType.custom,
      allowedExtensions: ['md'],
    );
    if (picked.isEmpty || !mounted) return;

    final accepted = [
      for (final f in picked)
        if (f.name.toLowerCase().endsWith('.md')) f,
    ];
    if (accepted.isEmpty) {
      setState(
        () => _submitError =
            'Drop one or more markdown files or a folder containing SKILL.md.',
      );
      return;
    }

    final entries = <QueuedSkillFile>[];
    for (final f in accepted) {
      final bytes = await f.readAsBytes();
      int modified = 0;
      try {
        modified = (await f.xFile.lastModified()).millisecondsSinceEpoch;
      } on Object {
        // Some platforms don't expose a timestamp — id just falls back to 0.
      }
      entries.add(
        queueMarkdownFile(
          SkillSourceFile(
            relativePath: f.name,
            bytes: bytes,
            lastModifiedMillis: modified,
          ),
        ),
      );
    }
    if (!mounted) return;
    _enqueue(entries);
  }

  /// "Choose Folder" — `handleFolderSelection`: walk the picked directory
  /// into `SkillSourceFile`s whose relativePath carries the picked folder
  /// name as first segment (`webkitRelativePath` parity), then run
  /// [buildQueuedSkillFolders] (which owns the 500-file/30 MB checks).
  Future<void> _pickFolder() async {
    if (kIsWeb) return;
    final dirPath = await FilePicker.getDirectoryPath(
      dialogTitle: 'Choose a skill folder',
    );
    if (dirPath == null || !mounted) return;

    try {
      final dir = Directory(dirPath);
      final rootPrefix = dir.parent.path;
      final rootName = dirPath
          .replaceAll('\\', '/')
          .split('/')
          .where((s) => s.isNotEmpty)
          .last;

      // Count + size checks run on stats before any bytes are read (web
      // checks `selectedFiles.length`/`.size` up front the same way).
      final entities = await dir
          .list(recursive: true, followLinks: false)
          .toList();
      final picked =
          <({File file, String relativePath, int size, int modified})>[];
      for (final e in entities) {
        if (e is! File) continue;
        final rel = e.path.replaceAll('\\', '/');
        final prefix = '${rootPrefix.replaceAll('\\', '/')}/';
        final relativePath = rel.startsWith(prefix)
            ? rel.substring(prefix.length)
            : '$rootName/$rel';
        final stat = await e.stat();
        picked.add((
          file: e,
          relativePath: relativePath,
          size: stat.size,
          modified: stat.modified.millisecondsSinceEpoch,
        ));
      }
      if (picked.length > kSkillFolderMaxFiles) {
        throw const SkillPayloadException(
          'A skill folder can contain up to $kSkillFolderMaxFiles files.',
        );
      }
      final total = picked.fold<int>(0, (sum, f) => sum + f.size);
      if (total > kSkillFolderMaxBytes) {
        throw const SkillPayloadException(
          'Selected skill folders must be smaller than 30 MB in total.',
        );
      }

      final files = <SkillSourceFile>[];
      for (final f in picked) {
        files.add(
          SkillSourceFile(
            relativePath: f.relativePath,
            bytes: await f.file.readAsBytes(),
            lastModifiedMillis: f.modified,
          ),
        );
      }
      if (!mounted) return;
      _enqueue(buildQueuedSkillFolders(files));
    } on SkillPayloadException catch (e) {
      if (mounted) setState(() => _submitError = e.message);
    } on Object {
      if (mounted) setState(() => _submitError = 'Failed to read skill folder');
    }
  }

  /// `handleUploadInstall` — build entries → submit → close on success.
  Future<void> _install() async {
    if (_queued.isEmpty) {
      setState(() => _submitError = 'Add one or more markdown files first.');
      return;
    }
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    try {
      final error = await widget.onSubmit(await buildSkillEntries(_queued));
      if (!mounted) return;
      if (error == null) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() {
        _submitting = false;
        _submitError = error;
      });
    } on Object {
      if (mounted) {
        setState(() {
          _submitting = false;
          _submitError = 'Failed to import skills';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final providerName = skillProviderName(widget.provider);
    final managedDir = kSkillManagedDirs[widget.provider];

    return AlertDialog(
      title: Text('Add $providerName Skill', style: tt.titleLarge),
      contentPadding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
        0,
      ),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload a SKILL.md file or a complete skill folder.',
                style: tt.bodySmall?.copyWith(color: c.mutedForeground),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Drop-zone panel (picker-only here — no drop target exists
              // outside the chat composer).
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.15),
                  border: Border.all(color: c.border.withValues(alpha: 0.7)),
                  borderRadius: AppRadii.borderLg,
                ),
                child: Column(
                  children: [
                    Icon(
                      LucideIcons.fileUp,
                      size: 28,
                      color: c.mutedForeground,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Pick a skill folder or SKILL.md',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Folders can include scripts, references, and assets.',
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      alignment: WrapAlignment.center,
                      children: [
                        AppButton(
                          variant: AppButtonVariant.outline,
                          size: AppButtonSize.sm,
                          onPressed: _submitting
                              ? null
                              : () => _pickFiles().ignore(),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(LucideIcons.fileUp, size: 14),
                              SizedBox(width: AppSpacing.xs),
                              Text('Choose Files'),
                            ],
                          ),
                        ),
                        if (!kIsWeb)
                          AppButton(
                            variant: AppButtonVariant.outline,
                            size: AppButtonSize.sm,
                            onPressed: _submitting
                                ? null
                                : () => _pickFolder().ignore(),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.folderUp, size: 14),
                                SizedBox(width: AppSpacing.xs),
                                Text('Choose Folder'),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // "Ready to install" queue list.
              if (_queued.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Ready to install',
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSpacing.sm),
                for (final q in _queued)
                  Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: c.card.withValues(alpha: 0.7),
                      border: Border.all(
                        color: c.border.withValues(alpha: 0.7),
                      ),
                      borderRadius: AppRadii.borderLg,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: c.muted.withValues(alpha: 0.6),
                            borderRadius: AppRadii.borderMd,
                          ),
                          child: Icon(
                            q.kind == QueuedSkillKind.folder
                                ? LucideIcons.folderUp
                                : LucideIcons.fileText,
                            size: 16,
                            color: c.mutedForeground,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '${q.kind == QueuedSkillKind.folder ? '${q.files.length} files' : 'Markdown file'} · ${formatSkillFileSize(q.size)}',
                                style: tt.bodySmall?.copyWith(
                                  color: c.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove ${q.name}',
                          onPressed: _submitting
                              ? null
                              : () => setState(
                                  () => _queued = [
                                    for (final f in _queued)
                                      if (f.id != q.id) f,
                                  ],
                                ),
                          icon: Icon(
                            LucideIcons.x,
                            size: 16,
                            color: c.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],

              // "Where will this install?" — `providerPath` toggle.
              if (managedDir != null) ...[
                const SizedBox(height: AppSpacing.sm),
                InkWell(
                  onTap: () =>
                      setState(() => _showInstallPath = !_showInstallPath),
                  child: Text(
                    _showInstallPath
                        ? 'Hide install location'
                        : 'Where will this install?',
                    style: tt.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: c.mutedForeground,
                    ),
                  ),
                ),
                if (_showInstallPath)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: c.muted.withValues(alpha: 0.15),
                      border: Border.all(
                        color: c.border.withValues(alpha: 0.6),
                      ),
                      borderRadius: AppRadii.borderLg,
                    ),
                    child: Text(
                      '~/$managedDir/<skill-name>/SKILL.md',
                      style: tt.bodySmall?.copyWith(
                        fontFamily: 'monospace',
                        color: c.foreground,
                      ),
                    ),
                  ),
              ],

              if (_submitError != null) ...[
                const SizedBox(height: AppSpacing.md),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: c.destructive.withValues(alpha: 0.08),
                    border: Border.all(
                      color: c.destructive.withValues(alpha: 0.4),
                    ),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Text(
                    _submitError!,
                    style: tt.bodySmall?.copyWith(color: c.destructive),
                  ),
                ),
              ] else ...[
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Folder uploads keep the selected folder name; standalone '
                  'files use the `name` in `SKILL.md`.',
                  style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: _submitting
              ? null
              : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        AppButton(
          size: AppButtonSize.sm,
          onPressed: _submitting || _queued.isEmpty
              ? null
              : () => _install().ignore(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _submitting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(LucideIcons.upload, size: 14),
              const SizedBox(width: AppSpacing.xs),
              Text(
                _queued.isEmpty
                    ? 'Install Skill'
                    : 'Install ${_queued.length} '
                          'Skill${_queued.length == 1 ? '' : 's'}',
              ),
            ],
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.all(AppSpacing.lg),
    );
  }
}

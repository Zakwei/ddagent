import 'dart:typed_data';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/editor/data/editor_file_kind.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/file_tree/view/file_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preview pane for non-text editor tabs: markdown renders through the
/// shared [AppMarkdown], images through authenticated [AuthImage] with
/// zoom, media/binary get an info card (+ hex dump for binaries).
class EditorPreview extends StatelessWidget {
  const EditorPreview({
    super.key,
    required this.kind,
    required this.projectId,
    required this.path,
    this.content = '',
  });

  final EditorFileKind kind;
  final String projectId;
  final String path;
  final String content;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case EditorFileKind.markdown:
        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: AppMarkdown(data: content),
          ),
        );
      case EditorFileKind.image:
        return InteractiveViewer(
          maxScale: 8,
          child: Center(child: AuthImage(url: fileContentUrl(projectId, path))),
        );
      case EditorFileKind.media:
        return _BinaryCard(
          projectId: projectId,
          path: path,
          icon: Icons.play_circle_outline,
          title: 'Media file',
          subtitle: 'Audio/video preview is not supported yet',
        );
      case EditorFileKind.binary:
      case EditorFileKind.text:
        return _BinaryCard(
          projectId: projectId,
          path: path,
          icon: Icons.insert_drive_file_outlined,
          title: 'Binary file',
          subtitle: 'Cannot display as text',
        );
    }
  }
}

/// Binary file card: icon + size + a hex dump of the first bytes.
class _BinaryCard extends ConsumerWidget {
  const _BinaryCard({
    required this.projectId,
    required this.path,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String projectId;
  final String path;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    // ponytail: the content endpoint has no range support, so the hex dump
    // fetches the whole blob — fine for typical assets; range requests are
    // the upgrade path for huge binaries.
    final future = ref
        .watch(fileTreeRepositoryProvider)
        .readFileBlob(projectId, path);
    return Center(
      child: FutureBuilder<Uint8List>(
        future: future,
        builder: (context, snap) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: colors.mutedForeground),
              const SizedBox(height: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              Text(
                path.split('/').last +
                    (snap.hasData
                        ? ' · ${formatFileSize(snap.data!.length)}'
                        : ''),
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.mutedForeground),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: colors.mutedForeground),
              ),
              if (snap.hasData) ...[
                const SizedBox(height: AppSpacing.md),
                _HexDump(bytes: snap.data!),
              ] else if (snap.hasError) ...[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Failed to load file',
                  style: TextStyle(color: colors.destructive),
                ),
              ] else
                const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.md),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

/// First-256-bytes hex dump, 16 bytes per row.
class _HexDump extends StatelessWidget {
  const _HexDump({required this.bytes});

  final Uint8List bytes;

  static const _cols = 16;
  static const _maxBytes = 256;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final style = Theme.of(context).textTheme.bodySmall!
        .copyWith(fontFamily: 'monospace', fontSize: 11);
    final dim = style.copyWith(color: colors.mutedForeground);
    final count = bytes.length < _maxBytes ? bytes.length : _maxBytes;
    final rows = <Widget>[
      for (var off = 0; off < count; off += _cols)
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${off.toRadixString(16).padLeft(6, '0')}  ',
                style: dim,
              ),
              TextSpan(
                text: [
                  for (var i = 0; i < _cols; i++)
                    off + i < count
                        ? bytes[off + i].toRadixString(16).padLeft(2, '0')
                        : '  ',
                ].join(' '),
                style: style,
              ),
              TextSpan(
                text:
                    '  ${[for (var i = off; i < off + _cols && i < count; i++) _ascii(bytes[i])].join()}',
                style: dim,
              ),
            ],
          ),
        ),
    ];
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: colors.muted.withValues(alpha: 0.4),
        border: Border.all(color: colors.border),
        borderRadius: AppRadii.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...rows,
          if (bytes.length > _maxBytes)
            Text(
              '… ${formatFileSize(bytes.length - _maxBytes)} more',
              style: dim,
            ),
        ],
      ),
    );
  }

  static String _ascii(int b) =>
      b >= 0x20 && b <= 0x7E ? String.fromCharCode(b) : '.';
}

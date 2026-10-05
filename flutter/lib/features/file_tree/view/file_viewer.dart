import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/file_tree/data/file_saver.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Raw-content URL for a project file (image viewer + downloads).
String fileContentUrl(String projectId, String path) =>
    '/api/file-tree/projects/$projectId/files/content'
    '?path=${Uri.encodeQueryComponent(path)}';

/// Opens [node] — images get the zoomable AuthImage dialog, everything else
/// the text viewer/edit pane route decided by the caller.
void openFileNode(
  BuildContext context, {
  required String projectId,
  required FileTreeNode node,
  required bool asDialog,
}) {
  if (isImageFile(node.name)) {
    showDialog<void>(
      context: context,
      builder: (_) => ImageViewerDialog(projectId: projectId, node: node),
    );
    return;
  }
  if (asDialog) {
    showDialog<void>(
      context: context,
      builder: (_) => AppDialog(
        title: node.name,
        content: SizedBox(
          width: 640,
          height: 480,
          child: FileViewerPane(projectId: projectId, node: node),
        ),
      ),
    );
    return;
  }
}

/// Image viewer — AuthImage + InteractiveViewer pinch/scroll zoom
/// (ImageViewer.tsx parity).
class ImageViewerDialog extends StatelessWidget {
  const ImageViewerDialog({super.key, required this.projectId, required this.node});

  final String projectId;
  final FileTreeNode node;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return AppDialog(
      title: node.name,
      content: SizedBox(
        width: 720,
        height: 540,
        child: InteractiveViewer(
          maxScale: 8,
          child: Center(child: AuthImage(url: fileContentUrl(projectId, node.path))),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () {
            Clipboard.setData(ClipboardData(text: node.path));
            AppToast.show(context, t.common.fileTree.toast.pathCopied);
          },
          child: Text(t.common.fileOperations.copyPath),
        ),
        AppButton(onPressed: () => Navigator.of(context).pop(), child: Text(t.chat.common.close)),
      ],
    );
  }
}

/// Text viewer + minimal editor — monospace, editable, Save when dirty.
/// ponytail: full code-editor parity (syntax highlighting, tabs, undo stack)
/// is T21; this is the T20 viewer with a basic TextField save path.
class FileViewerPane extends ConsumerStatefulWidget {
  const FileViewerPane({super.key, required this.projectId, required this.node});

  final String projectId;
  final FileTreeNode node;

  @override
  ConsumerState<FileViewerPane> createState() => _FileViewerPaneState();
}

class _FileViewerPaneState extends ConsumerState<FileViewerPane> {
  final _content = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _dirty = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _content.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final text = await ref
          .read(fileTreeRepositoryProvider)
          .readFile(widget.projectId, widget.node.path);
      if (!mounted) {
        return;
      }
      _content.text = text;
      setState(() => _loading = false);
    } on AppError catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref
          .read(fileTreeRepositoryProvider)
          .saveFile(widget.projectId, widget.node.path, _content.text);
      if (!mounted) {
        return;
      }
      setState(() {
        _saving = false;
        _dirty = false;
      });
      AppToast.show(context, 'Saved');
    } on AppError catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        AppToast.show(context, e.message, isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(_error!, style: TextStyle(color: context.appColors.destructive)),
      );
    }
    final t = Translations.of(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.node.path,
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: t.fileTree.copyContents,
              icon: const Icon(Icons.copy_outlined, size: 18),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _content.text));
                AppToast.show(context, 'Copied');
              },
            ),
            IconButton(
              tooltip: t.common.fileOperations.openInEditor,
              icon: const Icon(Icons.edit_note, size: 18),
              onPressed: () => context.go(
                '/editor?projectId=${widget.projectId}'
                '&file=${Uri.encodeQueryComponent(widget.node.path)}',
              ),
            ),
            AppButton(
              size: AppButtonSize.sm,
              loading: _saving,
              onPressed: _dirty ? _save : null,
              child: Text(t.codeEditor.actions.save),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: _content,
            maxLines: null,
            expands: true,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
            decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
            onChanged: (_) {
              if (!_dirty) {
                setState(() => _dirty = true);
              }
            },
          ),
        ),
      ],
    );
  }
}

/// Save-dialog + `readFileBlob` byte write. Web has no writable filesystem —
/// the blob endpoint needs auth headers `<a download>` can't send, so web
/// falls back to a toast (useFileTreeOperations download parity is
/// desktop-only here).
Future<void> downloadFile(
  BuildContext context,
  WidgetRef ref, {
  required String projectId,
  required FileTreeNode node,
}) async {
  final t = Translations.of(context);
  if (kIsWeb) {
    AppToast.show(context, t.fileTree.downloadUnsupportedOnWeb, isError: true);
    return;
  }
  final nameController = TextEditingController(text: node.path);
  final target = await AppDialog.show<String>(
    context,
    title: t.fileTree.titles.download(name: node.name),
    content: AppInput(controller: nameController, hint: t.fileTree.saveToPath, autofocus: true),
    actions: [
      AppButton(
        variant: AppButtonVariant.ghost,
        onPressed: () => AppDialog.pop(context),
        child: Text(t.chat.orchestrator.summary.cancelTasks),
      ),
      AppButton(
        onPressed: () => AppDialog.pop(context, nameController.text.trim()),
        child: Text(t.codeEditor.actions.save),
      ),
    ],
  );
  if (target == null || target.isEmpty || !context.mounted) {
    return;
  }
  try {
    final bytes = await ref.read(fileTreeRepositoryProvider).readFileBlob(projectId, node.path);
    await saveBytesToPath(target, bytes);
    if (context.mounted) {
      AppToast.show(context, t.fileTree.savedTo(path: target));
    }
  } on AppError catch (e) {
    if (context.mounted) {
      AppToast.show(context, e.message, isError: true);
    }
  } on Object catch (e) {
    if (context.mounted) {
      AppToast.show(context, e.toString(), isError: true);
    }
  }
}

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Server filesystem folder picker (browse-filesystem, depth=1).
/// Pops with the selected absolute path.
class FolderBrowserDialog extends ConsumerStatefulWidget {
  const FolderBrowserDialog({super.key, this.initialPath});

  final String? initialPath;

  static Future<String?> pick(BuildContext context, {String? initialPath}) => showDialog<String>(
    context: context,
    builder: (_) => FolderBrowserDialog(initialPath: initialPath),
  );

  @override
  ConsumerState<FolderBrowserDialog> createState() => _FolderBrowserDialogState();
}

class _FolderBrowserDialogState extends ConsumerState<FolderBrowserDialog> {
  List<Map<String, dynamic>> _dirs = const [];
  String? _path;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load(widget.initialPath);
  }

  Future<void> _load(String? path) async {
    setState(() => _loading = true);
    try {
      final res = await ref.read(fileTreeRepositoryProvider).browseFilesystem(path: path);
      if (!mounted) {
        return;
      }
      setState(() {
        _path = res['path'] as String?;
        _dirs = [
          for (final e in (res['suggestions'] as List? ?? const []))
            Map<String, dynamic>.from(e as Map),
        ];
        _loading = false;
        _error = null;
      });
    } on AppError catch (e) {
      setState(() {
        _loading = false;
        _error = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return AppDialog(
      title: t.fileTree.chooseFolder,
      content: SizedBox(
        width: 420,
        height: 320,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Text(_error!, style: TextStyle(color: context.appColors.destructive)),
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(_path ?? '', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final d in _dirs)
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.folder_outlined, size: 18),
                            title: Text(d['name'] as String? ?? ''),
                            onTap: () => _load(d['path'] as String?),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.chat.orchestrator.summary.cancelTasks),
        ),
        AppButton(
          onPressed: () => Navigator.of(context).pop(_path),
          child: Text(t.common.common.select),
        ),
      ],
    );
  }
}

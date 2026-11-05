import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/file_tree/data/explorer_rows.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:ddagent_app/features/file_tree/state/file_tree_controller.dart';
import 'package:ddagent_app/features/file_tree/view/file_icons.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// One file offered by quick open: its server [path] (what the editor opens),
/// file [name] and project-relative [relative] path shown under it.
typedef QuickOpenFile = ({String path, String name, String relative});

/// Every file in the loaded tree, in tree order (directories are skipped).
List<QuickOpenFile> quickOpenFiles(List<FileTreeNode> roots) {
  final root = explorerProjectRoot(roots);
  final out = <QuickOpenFile>[];
  void walk(List<FileTreeNode> nodes) {
    for (final node in nodes) {
      if (node.isDirectory) {
        walk(node.children);
      } else {
        final relative = root == null ? null : explorerRelativePath(node.path, root);
        out.add((path: node.path, name: node.name, relative: relative ?? node.path));
      }
    }
  }

  walk(roots);
  return out;
}

/// Whether the characters of [query] appear in [text] in order (VS Code's
/// Ctrl+P matching: `mdart` finds `main.dart`). Both are lower-case.
bool _isSubsequence(String query, String text) {
  var i = 0;
  for (var j = 0; j < text.length && i < query.length; j++) {
    if (text.codeUnitAt(j) == query.codeUnitAt(i)) i++;
  }
  return i == query.length;
}

/// [files] matching [query], best first: a name containing the query, then
/// a name matching it as a subsequence, then a relative path matching it;
/// shorter paths win ties. Spaces in the query are ignored. An empty query
/// lists the first [limit] files.
List<QuickOpenFile> quickOpenMatches(List<QuickOpenFile> files, String query, {int limit = 50}) {
  final q = query.toLowerCase().replaceAll(' ', '');
  if (q.isEmpty) return files.take(limit).toList();
  final ranked = <(int, QuickOpenFile)>[];
  for (final file in files) {
    final name = file.name.toLowerCase();
    final rank = name.contains(q)
        ? 0
        : _isSubsequence(q, name)
        ? 1
        : _isSubsequence(q, file.relative.toLowerCase())
        ? 2
        : -1;
    if (rank >= 0) ranked.add((rank, file));
  }
  ranked.sort((a, b) {
    final byRank = a.$1.compareTo(b.$1);
    return byRank != 0 ? byRank : a.$2.relative.length.compareTo(b.$2.relative.length);
  });
  return [for (final (_, file) in ranked.take(limit)) file];
}

/// Opens quick open (VS Code Ctrl+P) for [projectId] and returns the picked
/// file's server path, or null when dismissed. A bottom sheet on a phone, a
/// dialog near the top elsewhere.
Future<String?> showQuickOpen(BuildContext context, {required String projectId}) {
  if (context.breakpoint.isCompact) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) =>
          FractionallySizedBox(heightFactor: 0.85, child: QuickOpenPanel(projectId: projectId)),
    );
  }
  return showDialog<String>(
    context: context,
    builder: (context) => Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(top: 64, left: 24, right: 24, bottom: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 480),
        child: QuickOpenPanel(projectId: projectId),
      ),
    ),
  );
}

/// Search field over the project's files; pops the route with the picked
/// file's server path.
class QuickOpenPanel extends ConsumerStatefulWidget {
  const QuickOpenPanel({required this.projectId, super.key});

  final String projectId;

  @override
  ConsumerState<QuickOpenPanel> createState() => _QuickOpenPanelState();
}

class _QuickOpenPanelState extends ConsumerState<QuickOpenPanel> {
  final _query = TextEditingController();

  @override
  void initState() {
    super.initState();
    // The editor's explorer may be closed (phone), so nothing else has loaded
    // this project's tree yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(fileTreeProvider.notifier).selectProject(widget.projectId);
    });
    _query.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    final theme = Theme.of(context);
    final tree = ref.watch(fileTreeProvider);
    final sameProject = tree.projectId == widget.projectId;
    final matches = sameProject
        ? quickOpenMatches(quickOpenFiles(tree.roots), _query.text)
        : const <QuickOpenFile>[];

    final Widget results;
    if (!sameProject || (tree.loading && tree.roots.isEmpty)) {
      results = const Center(child: CircularProgressIndicator());
    } else if (matches.isEmpty) {
      results = Center(
        child: Text(
          t.codeEditor.quickOpen.empty,
          style: theme.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
        ),
      );
    } else {
      results = ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, i) {
          final file = matches[i];
          final icon = fileIcon(file.name);
          final dir = file.relative.contains('/')
              ? file.relative.substring(0, file.relative.lastIndexOf('/'))
              : '';
          return ListTile(
            dense: true,
            leading: Icon(icon.icon, size: 18, color: icon.color),
            title: Text(file.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: dir.isEmpty
                ? null
                : Text(
                    dir,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                  ),
            onTap: () => Navigator.of(context).pop(file.path),
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: TextField(
            controller: _query,
            autofocus: true,
            textInputAction: TextInputAction.go,
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: const Icon(LucideIcons.search, size: 18),
              hintText: t.codeEditor.quickOpen.hint,
            ),
            // Enter opens the best match, as in VS Code.
            onSubmitted: (_) {
              if (matches.isNotEmpty) Navigator.of(context).pop(matches.first.path);
            },
            inputFormatters: [FilteringTextInputFormatter.deny('\n')],
          ),
        ),
        const Divider(height: 1),
        Expanded(child: results),
      ],
    );
  }
}

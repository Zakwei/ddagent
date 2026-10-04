import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Lists the stored versions of one knowledge entity and lets the user restore
/// a previous snapshot (pops the chosen entry; the caller maps it back to the
/// entity's save payload).
class KnowledgeHistoryDialog extends ConsumerStatefulWidget {
  const KnowledgeHistoryDialog({super.key, required this.entityType, required this.entityId});

  final KnowledgeEntityType entityType;
  final String entityId;

  static Future<KbHistoryEntry?> show(
    BuildContext context, {
    required KnowledgeEntityType entityType,
    required String entityId,
  }) => showDialog<KbHistoryEntry>(
    context: context,
    builder: (_) => KnowledgeHistoryDialog(entityType: entityType, entityId: entityId),
  );

  @override
  ConsumerState<KnowledgeHistoryDialog> createState() => _KnowledgeHistoryDialogState();
}

class _KnowledgeHistoryDialogState extends ConsumerState<KnowledgeHistoryDialog> {
  late Future<List<KbHistoryEntry>> _history;

  @override
  void initState() {
    super.initState();
    _history = ref
        .read(knowledgeRepositoryProvider)
        .history(entityType: widget.entityType.wire, entityId: widget.entityId);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${widget.entityType.label} history'),
      content: SizedBox(
        width: 520,
        height: 400,
        child: FutureBuilder<List<KbHistoryEntry>>(
          future: _history,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            final entries = snapshot.data ?? const [];
            if (entries.isEmpty) {
              return const Center(child: Text('No history yet.'));
            }
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return ListTile(
                  title: Text(entry.title.isEmpty ? '(untitled)' : entry.title),
                  subtitle: Text(entry.content, maxLines: 3, overflow: TextOverflow.ellipsis),
                  trailing: TextButton(
                    onPressed: () => Navigator.of(context).pop(entry),
                    child: const Text('Restore'),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
      ],
    );
  }
}

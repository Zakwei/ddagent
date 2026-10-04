import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:flutter/material.dart';

/// One selectable project in the memory/rule scope dropdown.
class KnowledgeProjectOption {
  const KnowledgeProjectOption({required this.id, required this.name});

  final String id;
  final String name;
}

/// Create/edit form for a knowledge entity. Pops the request body map (the
/// controller decides create vs update from the presence of [entityId]).
class KnowledgeFormDialog extends StatefulWidget {
  const KnowledgeFormDialog({
    super.key,
    required this.kind,
    this.entityId,
    this.initial,
    this.projects = const [],
  });

  final KnowledgeEntityType kind;

  /// Non-null when editing an existing entity.
  final String? entityId;

  /// Current values when editing.
  final Map<String, dynamic>? initial;
  final List<KnowledgeProjectOption> projects;

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required KnowledgeEntityType kind,
    String? entityId,
    Map<String, dynamic>? initial,
    List<KnowledgeProjectOption> projects = const [],
  }) => showDialog<Map<String, dynamic>>(
    context: context,
    builder: (_) =>
        KnowledgeFormDialog(kind: kind, entityId: entityId, initial: initial, projects: projects),
  );

  @override
  State<KnowledgeFormDialog> createState() => _KnowledgeFormDialogState();
}

class _KnowledgeFormDialogState extends State<KnowledgeFormDialog> {
  late final TextEditingController _title;
  late final TextEditingController _content;
  late final TextEditingController _description;
  late final TextEditingController _key;
  late final TextEditingController _category;
  late final TextEditingController _tags;
  late String _priority;
  late String _memoryType;
  late bool _enabled;
  String? _projectId;

  bool get _isEditing => widget.entityId != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial ?? const {};
    _title = TextEditingController(text: '${initial['title'] ?? initial['name'] ?? ''}');
    _content = TextEditingController(text: '${initial['content'] ?? ''}');
    _description = TextEditingController(text: '${initial['description'] ?? ''}');
    _key = TextEditingController(text: '${initial['key'] ?? ''}');
    _category = TextEditingController(text: '${initial['category'] ?? 'general'}');
    final tagList = initial['tags'];
    _tags = TextEditingController(text: tagList is List ? tagList.join(', ') : '');
    _priority = '${initial['priority'] ?? 'normal'}';
    _memoryType = '${initial['memoryType'] ?? 'fact'}';
    _enabled = initial['enabled'] != false;
    _projectId = initial['projectId'] as String?;
  }

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    _description.dispose();
    _key.dispose();
    _category.dispose();
    _tags.dispose();
    super.dispose();
  }

  String get _titleLabel => switch (widget.kind) {
    KnowledgeEntityType.skill => 'Name',
    KnowledgeEntityType.personal => 'Title',
    _ => 'Title',
  };

  Map<String, dynamic> _buildPayload() => switch (widget.kind) {
    KnowledgeEntityType.memory => {
      'title': _title.text.trim(),
      'content': _content.text,
      'priority': _priority,
      'memoryType': _memoryType,
      'tags': [
        for (final tag in _tags.text.split(','))
          if (tag.trim().isNotEmpty) tag.trim(),
      ],
      'projectId': _projectId,
    },
    KnowledgeEntityType.rule => {
      'title': _title.text.trim(),
      'content': _content.text,
      'priority': _priority,
      'enabled': _enabled,
      'projectId': _projectId,
    },
    KnowledgeEntityType.skill => {
      'name': _title.text.trim(),
      'description': _description.text.trim(),
      'content': _content.text,
      'category': _category.text.trim().isEmpty ? 'general' : _category.text.trim(),
    },
    KnowledgeEntityType.personal => {
      'key': _key.text.trim(),
      'title': _title.text.trim(),
      'content': _content.text,
    },
  };

  bool get _valid {
    if (_title.text.trim().isEmpty) return false;
    if (widget.kind == KnowledgeEntityType.personal && _key.text.trim().isEmpty) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final kind = widget.kind;
    const divider = SizedBox(height: 12);

    return AlertDialog(
      title: Text(
        _isEditing ? 'Edit ${kind.label.toLowerCase()}' : 'New ${kind.label.toLowerCase()}',
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (kind == KnowledgeEntityType.personal) ...[
                TextField(
                  controller: _key,
                  decoration: const InputDecoration(labelText: 'Key'),
                  onChanged: (_) => setState(() {}),
                ),
                divider,
              ],
              TextField(
                controller: _title,
                decoration: InputDecoration(labelText: _titleLabel),
                onChanged: (_) => setState(() {}),
              ),
              divider,
              if (kind == KnowledgeEntityType.skill) ...[
                TextField(
                  controller: _description,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                divider,
                TextField(
                  controller: _category,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                divider,
              ],
              TextField(
                controller: _content,
                maxLines: 6,
                minLines: 3,
                decoration: const InputDecoration(labelText: 'Content', alignLabelWithHint: true),
              ),
              if (kind == KnowledgeEntityType.memory) ...[
                divider,
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      for (final priority in KnowledgePriority.values)
                        DropdownMenuItem(value: priority.wire, child: Text(priority.label)),
                    ],
                    onChanged: (value) => setState(() => _priority = value ?? _priority),
                  ),
                ),
                divider,
                TextField(
                  controller: _tags,
                  decoration: const InputDecoration(
                    labelText: 'Tags',
                    hintText: 'comma, separated',
                  ),
                ),
              ],
              if (kind == KnowledgeEntityType.rule) ...[
                divider,
                SizedBox(
                  width: double.infinity,
                  child: DropdownButtonFormField<String>(
                    initialValue: _priority,
                    decoration: const InputDecoration(labelText: 'Priority'),
                    items: [
                      for (final priority in KnowledgePriority.values)
                        DropdownMenuItem(value: priority.wire, child: Text(priority.label)),
                    ],
                    onChanged: (value) => setState(() => _priority = value ?? _priority),
                  ),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Enabled'),
                  value: _enabled,
                  onChanged: (value) => setState(() => _enabled = value),
                ),
              ],
              if (kind == KnowledgeEntityType.memory || kind == KnowledgeEntityType.rule) ...[
                divider,
                DropdownButtonFormField<String?>(
                  initialValue: _projectId,
                  decoration: const InputDecoration(labelText: 'Project scope'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('Global')),
                    for (final project in widget.projects)
                      DropdownMenuItem<String?>(value: project.id, child: Text(project.name)),
                  ],
                  onChanged: (value) => setState(() => _projectId = value),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          onPressed: _valid ? () => Navigator.of(context).pop(_buildPayload()) : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

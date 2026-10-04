import 'dart:convert';

import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_repository.dart';
import 'package:ddagent_app/features/knowledge/state/knowledge_controller.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_form_dialog.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_graph_view.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_history_dialog.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Knowledge base screen — dashboard plus one tab per entity kind, with a
/// project scope filter and a button to (re)scan the project's AI-context files.
class KnowledgeScreen extends ConsumerStatefulWidget {
  const KnowledgeScreen({super.key});

  @override
  ConsumerState<KnowledgeScreen> createState() => _KnowledgeScreenState();
}

class _KnowledgeScreenState extends ConsumerState<KnowledgeScreen> {
  Future<void> _exportKnowledge() async {
    final t = Translations.of(context);
    try {
      final payload = await ref.read(knowledgeRepositoryProvider).exportAll();
      if (!mounted) return;
      await AppDialog.show<void>(
        context,
        title: t.knowledge.dialog.exportTitle,
        content: SizedBox(
          width: 520,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              const JsonEncoder.withIndent('  ').convert(payload),
              style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
            ),
          ),
        ),
      );
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  Future<void> _importKnowledge() async {
    final t = Translations.of(context);
    final field = TextEditingController();
    final payload = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.knowledge.dialog.importTitle),
        content: SizedBox(
          width: 520,
          child: TextField(
            controller: field,
            maxLines: 10,
            decoration: InputDecoration(hintText: t.knowledge.dialog.importHint),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.knowledge.common.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(field.text),
            child: Text(t.knowledge.dialog.import),
          ),
        ],
      ),
    );
    if (payload == null || payload.trim().isEmpty) return;
    try {
      final decoded = jsonDecode(payload) as Map<String, dynamic>;
      await ref.read(knowledgeRepositoryProvider).importAll(decoded);
      await ref.read(knowledgeControllerProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.knowledge.actions.importComplete)));
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${t.knowledge.actions.importFailed}: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final state = ref.watch(knowledgeControllerProvider);
    final controller = ref.read(knowledgeControllerProvider.notifier);

    ref.watch(projectsProvider);
    final projects = [
      for (final project in ref.read(projectsProvider).projects)
        KnowledgeProjectOption(
          id: project.projectId,
          name: project.displayName.isNotEmpty ? project.displayName : project.projectId,
        ),
    ];

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(t.knowledge.title),
          actions: [
            DropdownButton<String?>(
              value: state.projectFilter,
              underline: const SizedBox.shrink(),
              hint: Text(t.knowledge.common.allProjects),
              items: [
                DropdownMenuItem<String?>(value: null, child: Text(t.knowledge.common.allProjects)),
                for (final project in projects)
                  DropdownMenuItem<String?>(value: project.id, child: Text(project.name)),
              ],
              onChanged: (value) => controller.setProjectFilter(value),
            ),
            const SizedBox(width: 8),
            if (state.projectFilter != null)
              IconButton(
                tooltip: t.knowledge.actions.scan,
                icon: const Icon(Icons.refresh),
                onPressed: state.busy
                    ? null
                    : () async {
                        final error = await controller.scanProject(state.projectFilter!);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error ?? t.knowledge.actions.scanComplete)),
                        );
                      },
              ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'export') _exportKnowledge();
                if (value == 'import') _importKnowledge();
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'export', child: Text(t.knowledge.actions.export)),
                PopupMenuItem(value: 'import', child: Text(t.knowledge.actions.import)),
              ],
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: t.knowledge.tabs.dashboard),
              Tab(text: t.knowledge.tabs.memories),
              Tab(text: t.knowledge.tabs.rules),
              Tab(text: t.knowledge.tabs.skills),
              Tab(text: t.knowledge.tabs.personal),
              Tab(text: t.knowledge.tabs.graph),
            ],
          ),
        ),
        body: state.loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _DashboardTab(state: state, projects: projects, controller: controller),
                  _MemoriesTab(state: state, projects: projects, controller: controller),
                  _RulesTab(state: state, projects: projects, controller: controller),
                  _SkillsTab(state: state, controller: controller),
                  _PersonalTab(state: state, controller: controller),
                  const KnowledgeGraphView(),
                ],
              ),
      ),
    );
  }
}

/// Opens the version history for one entity and restores the chosen snapshot.
Widget _historyButton(
  BuildContext context, {
  required KnowledgeEntityType type,
  required String entityId,
  required Map<String, dynamic> Function(KbHistoryEntry entry) body,
  required Future<String?> Function(Map<String, dynamic> body) save,
}) => IconButton(
  icon: const Icon(Icons.history),
  onPressed: () async {
    final entry = await KnowledgeHistoryDialog.show(context, entityType: type, entityId: entityId);
    if (entry == null) return;
    final error = await save(body(entry));
    if (error != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    }
  },
);

Future<void> _confirmDelete(BuildContext context, Future<String?> Function() remove) async {
  final t = Translations.of(context);
  final confirmed = await AppDialog.confirm(
    context,
    title: t.knowledge.common.delete,
    message: t.knowledge.dialog.deleteMessage,
    confirmLabel: t.knowledge.common.delete,
  );
  if (!confirmed || !context.mounted) return;
  final error = await remove();
  if (error != null && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
  }
}

Widget _empty(String message) => Center(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Text(message, textAlign: TextAlign.center),
  ),
);

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({required this.state, required this.projects, required this.controller});

  final KnowledgeState state;
  final List<KnowledgeProjectOption> projects;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final recent = state.memories.take(5).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(label: t.knowledge.dashboard.memories, value: state.stats.memories),
            _StatCard(label: t.knowledge.dashboard.rules, value: state.stats.rules),
            _StatCard(label: t.knowledge.dashboard.skills, value: state.stats.skills),
            _StatCard(label: t.knowledge.dashboard.personal, value: state.stats.personal),
            _StatCard(label: t.knowledge.dashboard.connections, value: state.stats.connections),
          ],
        ),
        const SizedBox(height: 24),
        Text(t.knowledge.dashboard.recent, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          Text(t.knowledge.dashboard.noMemories)
        else
          for (final memory in recent)
            ListTile(
              dense: true,
              leading: _PriorityDot(priority: memory.priority),
              title: Text(memory.title),
              subtitle: memory.tags.isEmpty ? null : Text(memory.tags.join(', ')),
            ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    ),
  );
}

class _PriorityDot extends StatelessWidget {
  const _PriorityDot({required this.priority});

  final KnowledgePriority priority;

  @override
  Widget build(BuildContext context) {
    final color = switch (priority) {
      KnowledgePriority.critical => Colors.red,
      KnowledgePriority.high => Colors.orange,
      KnowledgePriority.low => Colors.grey,
      KnowledgePriority.normal => Colors.blueGrey,
    };
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _MemoriesTab extends StatelessWidget {
  const _MemoriesTab({required this.state, required this.projects, required this.controller});

  final KnowledgeState state;
  final List<KnowledgeProjectOption> projects;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(
            context,
            kind: KnowledgeEntityType.memory,
            projects: projects,
          );
          if (body != null) await controller.saveMemory(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.memories.isEmpty
          ? _empty(t.knowledge.empty.memories)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.memories.length,
              itemBuilder: (context, index) {
                final memory = state.memories[index];
                return ListTile(
                  leading: _PriorityDot(priority: memory.priority),
                  title: Text(memory.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (memory.content.isNotEmpty)
                        Text(memory.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text(
                        [
                          memory.memoryType,
                          memory.priority.wire,
                          if (memory.tags.isNotEmpty) memory.tags.join(', '),
                        ].join(' · '),
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  isThreeLine: memory.content.isNotEmpty,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _historyButton(
                        context,
                        type: KnowledgeEntityType.memory,
                        entityId: memory.id,
                        body: (entry) => {'title': entry.title, 'content': entry.content},
                        save: (body) => controller.saveMemory(id: memory.id, body: body),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final body = await KnowledgeFormDialog.show(
                            context,
                            kind: KnowledgeEntityType.memory,
                            entityId: memory.id,
                            projects: projects,
                            initial: {
                              'title': memory.title,
                              'content': memory.content,
                              'priority': memory.priority.wire,
                              'memoryType': memory.memoryType,
                              'tags': memory.tags,
                              'projectId': memory.projectId,
                            },
                          );
                          if (body != null) await controller.saveMemory(id: memory.id, body: body);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _confirmDelete(context, () => controller.deleteMemory(memory.id)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _RulesTab extends StatelessWidget {
  const _RulesTab({required this.state, required this.projects, required this.controller});

  final KnowledgeState state;
  final List<KnowledgeProjectOption> projects;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(
            context,
            kind: KnowledgeEntityType.rule,
            projects: projects,
          );
          if (body != null) await controller.saveRule(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.rules.isEmpty
          ? _empty(t.knowledge.empty.rules)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.rules.length,
              itemBuilder: (context, index) {
                final rule = state.rules[index];
                return ListTile(
                  leading: _PriorityDot(priority: rule.priority),
                  title: Text(rule.title),
                  subtitle: Text(rule.content, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        value: rule.enabled,
                        onChanged: (value) =>
                            controller.saveRule(id: rule.id, body: {'enabled': value}),
                      ),
                      _historyButton(
                        context,
                        type: KnowledgeEntityType.rule,
                        entityId: rule.id,
                        body: (entry) => {'title': entry.title, 'content': entry.content},
                        save: (body) => controller.saveRule(id: rule.id, body: body),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final body = await KnowledgeFormDialog.show(
                            context,
                            kind: KnowledgeEntityType.rule,
                            entityId: rule.id,
                            projects: projects,
                            initial: {
                              'title': rule.title,
                              'content': rule.content,
                              'priority': rule.priority.wire,
                              'enabled': rule.enabled,
                              'projectId': rule.projectId,
                            },
                          );
                          if (body != null) await controller.saveRule(id: rule.id, body: body);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _confirmDelete(context, () => controller.deleteRule(rule.id)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _SkillsTab extends StatelessWidget {
  const _SkillsTab({required this.state, required this.controller});

  final KnowledgeState state;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(context, kind: KnowledgeEntityType.skill);
          if (body != null) await controller.saveSkill(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.skills.isEmpty
          ? _empty(t.knowledge.empty.skills)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.skills.length,
              itemBuilder: (context, index) {
                final skill = state.skills[index];
                return ListTile(
                  leading: skill.icon.isEmpty
                      ? const Icon(Icons.auto_awesome_outlined)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.memory(
                            base64Decode(skill.icon.split(',').last),
                            width: 32,
                            height: 32,
                            fit: BoxFit.cover,
                          ),
                        ),
                  title: Text(skill.name),
                  subtitle: Text(
                    skill.category + (skill.description.isEmpty ? '' : ' · ${skill.description}'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _historyButton(
                        context,
                        type: KnowledgeEntityType.skill,
                        entityId: skill.id,
                        body: (entry) => {'name': entry.title, 'content': entry.content},
                        save: (body) => controller.saveSkill(id: skill.id, body: body),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final body = await KnowledgeFormDialog.show(
                            context,
                            kind: KnowledgeEntityType.skill,
                            entityId: skill.id,
                            initial: {
                              'name': skill.name,
                              'description': skill.description,
                              'content': skill.content,
                              'category': skill.category,
                              'icon': skill.icon,
                            },
                          );
                          if (body != null) await controller.saveSkill(id: skill.id, body: body);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _confirmDelete(context, () => controller.deleteSkill(skill.id)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class _PersonalTab extends StatelessWidget {
  const _PersonalTab({required this.state, required this.controller});

  final KnowledgeState state;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(context, kind: KnowledgeEntityType.personal);
          if (body != null) await controller.savePersonal(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.personal.isEmpty
          ? _empty(t.knowledge.empty.personal)
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.personal.length,
              itemBuilder: (context, index) {
                final info = state.personal[index];
                return ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(info.title),
                  subtitle: Text(info.key),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _historyButton(
                        context,
                        type: KnowledgeEntityType.personal,
                        entityId: info.id,
                        body: (entry) => {'title': entry.title, 'content': entry.content},
                        save: (body) => controller.savePersonal(id: info.id, body: body),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () async {
                          final body = await KnowledgeFormDialog.show(
                            context,
                            kind: KnowledgeEntityType.personal,
                            entityId: info.id,
                            initial: {
                              'key': info.key,
                              'title': info.title,
                              'content': info.content,
                            },
                          );
                          if (body != null) await controller.savePersonal(id: info.id, body: body);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _confirmDelete(context, () => controller.deletePersonal(info.id)),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

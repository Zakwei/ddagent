import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/features/knowledge/data/knowledge_models.dart';
import 'package:ddagent_app/features/knowledge/state/knowledge_controller.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_form_dialog.dart';
import 'package:ddagent_app/features/knowledge/view/knowledge_graph_view.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
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
  @override
  Widget build(BuildContext context) {
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
          title: const Text('Knowledge'),
          actions: [
            DropdownButton<String?>(
              value: state.projectFilter,
              underline: const SizedBox.shrink(),
              hint: const Text('All projects'),
              items: [
                const DropdownMenuItem<String?>(value: null, child: Text('All projects')),
                for (final project in projects)
                  DropdownMenuItem<String?>(value: project.id, child: Text(project.name)),
              ],
              onChanged: (value) => controller.setProjectFilter(value),
            ),
            const SizedBox(width: 8),
            if (state.projectFilter != null)
              IconButton(
                tooltip: 'Scan project files',
                icon: const Icon(Icons.refresh),
                onPressed: state.busy
                    ? null
                    : () async {
                        final error = await controller.scanProject(state.projectFilter!);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error ?? 'Project scan complete')));
                      },
              ),
            const SizedBox(width: 8),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Dashboard'),
              Tab(text: 'Memories'),
              Tab(text: 'Rules'),
              Tab(text: 'Skills'),
              Tab(text: 'Personal'),
              Tab(text: 'Graph'),
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

Future<void> _confirmDelete(BuildContext context, Future<String?> Function() remove) async {
  final confirmed = await AppDialog.confirm(
    context,
    title: 'Delete',
    message: 'Delete this entry? This cannot be undone (history is kept).',
    confirmLabel: 'Delete',
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
    final recent = state.memories.take(5).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _StatCard(label: 'Memories', value: state.stats.memories),
            _StatCard(label: 'Rules', value: state.stats.rules),
            _StatCard(label: 'Skills', value: state.stats.skills),
            _StatCard(label: 'Personal', value: state.stats.personal),
            _StatCard(label: 'Connections', value: state.stats.connections),
          ],
        ),
        const SizedBox(height: 24),
        Text('Recent memories', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        if (recent.isEmpty)
          const Text('No memories yet. Add one from the Memories tab.')
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
          ? _empty('No memories yet.')
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
          ? _empty('No rules yet.')
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(context, kind: KnowledgeEntityType.skill);
          if (body != null) await controller.saveSkill(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.skills.isEmpty
          ? _empty('No skills yet.')
          : ListView.builder(
              padding: const EdgeInsets.only(bottom: 88),
              itemCount: state.skills.length,
              itemBuilder: (context, index) {
                final skill = state.skills[index];
                return ListTile(
                  leading: const Icon(Icons.auto_awesome_outlined),
                  title: Text(skill.name),
                  subtitle: Text(
                    skill.category + (skill.description.isEmpty ? '' : ' · ${skill.description}'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final body = await KnowledgeFormDialog.show(context, kind: KnowledgeEntityType.personal);
          if (body != null) await controller.savePersonal(body: body);
        },
        child: const Icon(Icons.add),
      ),
      body: state.personal.isEmpty
          ? _empty('No personal information yet.')
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

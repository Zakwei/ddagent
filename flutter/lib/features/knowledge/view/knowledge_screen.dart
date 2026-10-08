import 'dart:convert';

import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_nav_menu.dart';
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
  /// True while the "import everything" flow is running — the dashboard card
  /// shows a spinner so a slow request never looks like "nothing happened".
  bool _importing = false;

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

  /// One global action: import everything (project migration + agent skills).
  /// Reads the agents' files, writes only ddagent's database.
  Future<void> _openImportAll() async {
    if (_importing) return;
    final t = Translations.of(context);
    final repo = ref.read(knowledgeRepositoryProvider);
    setState(() => _importing = true);
    Map<String, dynamic> report;
    try {
      report = await repo.importEverything(dryRun: true);
    } on Object catch (error) {
      if (mounted) {
        setState(() => _importing = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.knowledge.errors.importFailed(error: error))));
      }
      return;
    }
    if (!mounted) return;
    setState(() => _importing = false);
    var mergeDuplicates = true;
    var promoteRules = false;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final dryRun = report['dryRun'] != false;
          final migration = report['migration'] as Map<String, dynamic>? ?? const {};
          final skills = report['skills'] as Map<String, dynamic>? ?? const {};
          final scanned = (migration['scanned'] as List? ?? const []).length;
          final duplicates = (migration['duplicates'] as List? ?? const []).length;
          final rules = migration['rules'] as Map<String, dynamic>? ?? const {};
          final found = skills['found'] ?? 0;
          final newSkills = skills['imported'] ?? 0;
          return AlertDialog(
            title: Text(t.knowledge.importAll.title),
            content: SizedBox(
              width: 520,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.knowledge.importAll.projectsScanned(count: scanned)),
                  Text(
                    t.knowledge.importAll.skillsFound(
                      found: found as Object,
                      newSkills: newSkills as Object,
                    ),
                  ),
                  Text(
                    t.knowledge.importAll.rulesSummary(
                      total: (rules['total'] ?? 0) as Object,
                      duplicates: duplicates,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Read-only on your agents: this imports into ddagent's own database and does "
                      'NOT modify or delete any CLI file or config. The options below only change '
                      'ddagent data.',
                    ),
                  ),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: mergeDuplicates,
                    onChanged: dryRun
                        ? (value) => setState(() => mergeDuplicates = value ?? false)
                        : null,
                    title: Text(t.knowledge.importAll.mergeDuplicates),
                    subtitle: Text(t.knowledge.importAll.mergeDuplicatesHint),
                  ),
                  CheckboxListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    value: promoteRules,
                    onChanged: dryRun
                        ? (value) => setState(() => promoteRules = value ?? false)
                        : null,
                    title: Text(t.knowledge.critical.makeAll),
                    subtitle: Text(t.knowledge.critical.makeAllHint),
                  ),
                  Text(
                    dryRun ? 'Dry run — nothing written yet.' : 'Imported.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(t.knowledge.common.cancel),
              ),
              FilledButton(
                onPressed: !dryRun
                    ? null
                    : () async {
                        this.setState(() => _importing = true);
                        try {
                          final result = await repo.importEverything(
                            dryRun: false,
                            dedupe: mergeDuplicates,
                            promoteRules: promoteRules,
                          );
                          await ref.read(knowledgeControllerProvider.notifier).refresh();
                          if (ctx.mounted) setState(() => report = result);
                          final migration =
                              result['migration'] as Map<String, dynamic>? ?? const {};
                          final skills = result['skills'] as Map<String, dynamic>? ?? const {};
                          final rules = migration['rules'] as Map<String, dynamic>? ?? const {};
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Imported — rules: ${rules['total'] ?? 0}, '
                                  'new skills: ${skills['imported'] ?? 0}, '
                                  'removed: ${migration['removed'] ?? 0}, '
                                  'promoted: ${migration['promoted'] ?? 0}',
                                ),
                              ),
                            );
                          }
                        } finally {
                          if (mounted) this.setState(() => _importing = false);
                        }
                      },
                child: Text(t.knowledge.importAll.action),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Dry-run migration report with actions to merge duplicates / promote rules.
  Future<void> _openMigrate() async {
    final t = Translations.of(context);
    final repo = ref.read(knowledgeRepositoryProvider);
    Map<String, dynamic> report;
    try {
      report = await repo.migrate(dryRun: true);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(t.knowledge.errors.migrationFailed(error: error))));
      }
      return;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final dryRun = report['dryRun'] != false;
          final scannedProjects = (report['scanned'] as List? ?? const []).length;
          final duplicates = (report['duplicates'] as List? ?? const []).length;
          final rules = report['rules'] as Map<String, dynamic>? ?? const {};
          return AlertDialog(
            title: Text(t.knowledge.migrate.title),
            content: SizedBox(
              width: 480,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.knowledge.migrate.scanned(count: scannedProjects)),
                  const SizedBox(height: 4),
                  Text(
                    t.knowledge.migrate.rulesSummary(
                      total: (rules['total'] ?? 0) as Object,
                      critical: (rules['critical'] ?? 0) as Object,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(t.knowledge.migrate.duplicates(count: duplicates)),
                  const SizedBox(height: 4),
                  Text(
                    t.knowledge.migrate.removedPromoted(
                      removed: (report['removed'] ?? 0) as Object,
                      promoted: (report['promoted'] ?? 0) as Object,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dryRun ? 'Dry run — nothing has been changed yet.' : 'Applied.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(t.knowledge.common.close),
              ),
              TextButton(
                onPressed: duplicates == 0 || !dryRun
                    ? null
                    : () async {
                        final result = await repo.migrate(dryRun: false, dedupe: true);
                        await ref.read(knowledgeControllerProvider.notifier).refresh();
                        setState(() => report = result);
                      },
                child: Text(t.knowledge.migrate.mergeDuplicates),
              ),
              FilledButton(
                onPressed: !dryRun
                    ? null
                    : () async {
                        final result = await repo.migrate(dryRun: false, promoteRules: true);
                        await ref.read(knowledgeControllerProvider.notifier).refresh();
                        setState(() => report = result);
                      },
                child: Text(t.knowledge.critical.makeAll),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Dry-run report of the agent (global/default) skills that can be imported.
  Future<void> _openImportSkills() async {
    final t = Translations.of(context);
    final repo = ref.read(knowledgeRepositoryProvider);
    Map<String, dynamic> report;
    try {
      report = await repo.importAgentSkills(dryRun: true);
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.knowledge.errors.importFailed(error: error))));
      }
      return;
    }
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          final dryRun = report['dryRun'] != false;
          final found = report['found'] ?? 0;
          final imported = report['imported'] ?? 0;
          final skipped = report['skipped'] ?? 0;
          return AlertDialog(
            title: Text(t.knowledge.importSkills.title),
            content: SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.knowledge.importSkills.found(count: found as Object)),
                  const SizedBox(height: 4),
                  Text(
                    t.knowledge.importSkills.summary(
                      imported: imported as Object,
                      skipped: skipped as Object,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    dryRun
                        ? 'Imports the global/default skills your agents ship (user, system, plugin) '
                              'as knowledge skills. Dry run — nothing imported yet.'
                        : 'Imported into the knowledge base.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(t.knowledge.common.close),
              ),
              FilledButton(
                onPressed: !dryRun
                    ? null
                    : () async {
                        final result = await repo.importAgentSkills(dryRun: false);
                        await ref.read(knowledgeControllerProvider.notifier).refresh();
                        setState(() => report = result);
                      },
                child: Text(t.knowledge.dialog.import),
              ),
            ],
          );
        },
      ),
    );
  }

  int _tabIndexFor(KnowledgeEntityType type) => switch (type) {
    KnowledgeEntityType.memory => 1,
    KnowledgeEntityType.rule => 2,
    KnowledgeEntityType.skill => 3,
    KnowledgeEntityType.personal => 4,
  };

  Future<void> _openSearch() async {
    final t = Translations.of(context);
    final tabs = DefaultTabController.of(context);
    final controller = ref.read(knowledgeControllerProvider.notifier);
    final query = TextEditingController();
    var results = <KbSearchResult>[];
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(t.knowledge.search.title),
          content: SizedBox(
            width: 560,
            height: 420,
            child: Column(
              children: [
                TextField(
                  controller: query,
                  autofocus: true,
                  decoration: InputDecoration(hintText: t.knowledge.search.hint),
                  onChanged: (value) async {
                    final found = value.trim().isEmpty
                        ? <KbSearchResult>[]
                        : await controller.search(value.trim());
                    setState(() => results = found);
                  },
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: results.isEmpty
                      ? Center(child: Text(t.knowledge.search.noResults))
                      : ListView.builder(
                          itemCount: results.length,
                          itemBuilder: (ctx, index) {
                            final result = results[index];
                            return ListTile(
                              dense: true,
                              title: Text(result.title),
                              subtitle: Text(
                                result.snippet,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                Navigator.of(ctx).pop();
                                tabs.animateTo(_tabIndexFor(result.entityType));
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.knowledge.common.close),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openLink() async {
    final t = Translations.of(context);
    final data = ref.read(knowledgeControllerProvider);
    final options = <({String key, String label, KnowledgeEntityType type, String id})>[
      for (final memory in data.memories)
        (
          key: 'memory:${memory.id}',
          label: t.knowledge.linkOptions.memory(title: memory.title),
          type: KnowledgeEntityType.memory,
          id: memory.id,
        ),
      for (final rule in data.rules)
        (
          key: 'rule:${rule.id}',
          label: t.knowledge.linkOptions.rule(title: rule.title),
          type: KnowledgeEntityType.rule,
          id: rule.id,
        ),
      for (final skill in data.skills)
        (
          key: 'skill:${skill.id}',
          label: t.knowledge.linkOptions.skill(name: skill.name),
          type: KnowledgeEntityType.skill,
          id: skill.id,
        ),
      for (final info in data.personal)
        (
          key: 'personal:${info.id}',
          label: t.knowledge.linkOptions.personal(title: info.title),
          type: KnowledgeEntityType.personal,
          id: info.id,
        ),
    ];
    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.knowledge.links.title)));
      return;
    }
    String? sourceKey = options[0].key;
    String? targetKey = options[1].key;
    final relationship = TextEditingController(text: 'related');
    final controller = ref.read(knowledgeControllerProvider.notifier);
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(t.knowledge.links.title),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: sourceKey,
                  decoration: InputDecoration(labelText: t.knowledge.links.source),
                  items: [
                    for (final option in options)
                      DropdownMenuItem(
                        value: option.key,
                        child: Text(option.label, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (value) => setState(() => sourceKey = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: targetKey,
                  decoration: InputDecoration(labelText: t.knowledge.links.target),
                  items: [
                    for (final option in options)
                      DropdownMenuItem(
                        value: option.key,
                        child: Text(option.label, overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: (value) => setState(() => targetKey = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: relationship,
                  decoration: InputDecoration(labelText: t.knowledge.links.relationship),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(t.knowledge.common.cancel),
            ),
            TextButton(
              onPressed: () async {
                if (sourceKey == null || targetKey == null) return;
                final source = options.firstWhere((option) => option.key == sourceKey);
                final target = options.firstWhere((option) => option.key == targetKey);
                final error = await controller.linkEntities(
                  sourceId: source.id,
                  sourceType: source.type.wire,
                  targetId: target.id,
                  targetType: target.type.wire,
                  relationship: relationship.text.trim().isEmpty
                      ? 'related'
                      : relationship.text.trim(),
                );
                if (ctx.mounted) Navigator.of(ctx).pop();
                if (error != null && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                }
              },
              child: Text(t.knowledge.links.add),
            ),
          ],
        ),
      ),
    );
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
          // Own Scaffold without a drawer, so the AppBar can't find the shell's
          // hamburger by itself — on compact this was a dead end.
          leading: context.breakpoint.isCompact ? const AppNavMenuButton() : null,
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
            IconButton(
              tooltip: t.knowledge.search.title,
              icon: const Icon(Icons.search),
              onPressed: _openSearch,
            ),
            IconButton(
              tooltip: t.knowledge.links.title,
              icon: const Icon(Icons.link),
              onPressed: _openLink,
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'export') _exportKnowledge();
                if (value == 'import') _importKnowledge();
                if (value == 'migrate') _openMigrate();
                if (value == 'skills') _openImportSkills();
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'export', child: Text(t.knowledge.actions.export)),
                PopupMenuItem(value: 'import', child: Text(t.knowledge.actions.import)),
                PopupMenuItem(value: 'migrate', child: Text(t.knowledge.migrate.title)),
                PopupMenuItem(value: 'skills', child: Text(t.knowledge.importSkills.title)),
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
                  _DashboardTab(
                    state: state,
                    projects: projects,
                    controller: controller,
                    onImportAll: _openImportAll,
                    importing: _importing,
                  ),
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

/// Promotes one entity to `critical` so it enters the injected context.
Widget _makeCriticalButton(
  BuildContext context, {
  required bool isCritical,
  required Future<String?> Function() promote,
}) {
  final t = Translations.of(context);
  return IconButton(
    tooltip: t.knowledge.critical.make,
    icon: Icon(isCritical ? Icons.star : Icons.star_border),
    onPressed: isCritical
        ? null
        : () async {
            final error = await promote();
            if (error != null && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
            }
          },
  );
}

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

/// Shows how much of the first-turn `<knowledge>` budget the selected project
/// consumes, so critical entries can be curated.
class _ContextBudgetCard extends StatelessWidget {
  const _ContextBudgetCard({required this.tokens, required this.budget, required this.hasProject});

  final int tokens;
  final int budget;
  final bool hasProject;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final ratio = budget <= 0 ? 0.0 : (tokens / budget).clamp(0.0, 1.0);
    final color = ratio >= 0.9
        ? Colors.red
        : ratio >= 0.7
        ? Colors.orange
        : Theme.of(context).colorScheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.memory, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Rules context (always served)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const Spacer(),
                Text(t.knowledge.contextBudget.tokens(tokens: tokens, budget: budget)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: ratio, color: color),
            if (!hasProject) ...[
              const SizedBox(height: 6),
              Text(
                'Select a project to see its critical-context size.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Prominent one-click "import everything into ddagent" entry point.
class _ImportAllCard extends StatelessWidget {
  const _ImportAllCard({required this.onPressed, required this.busy});

  final VoidCallback onPressed;

  /// Shows a spinner while the import request is in flight.
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final i18n = Translations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.download),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(i18n.knowledge.importAll.title, style: t.textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    "Scan every project and import your agents' skills into the knowledge base. "
                    'Read-only on your agents — nothing in the CLIs is changed.',
                    style: t.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: busy ? null : onPressed,
              child: busy
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(i18n.knowledge.importAll.action),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardTab extends StatelessWidget {
  const _DashboardTab({
    required this.state,
    required this.projects,
    required this.controller,
    required this.onImportAll,
    required this.importing,
  });

  final KnowledgeState state;
  final List<KnowledgeProjectOption> projects;
  final KnowledgeController controller;
  final VoidCallback onImportAll;
  final bool importing;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final recent = state.memories.take(5).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ImportAllCard(onPressed: onImportAll, busy: importing),
        const SizedBox(height: 24),
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
        _ContextBudgetCard(
          tokens: state.contextTokens,
          budget: state.contextBudget,
          hasProject: state.projectFilter != null,
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

/// Horizontal tag filter for the Memories tab plus a manage-tags entry point.
class _TagFilterBar extends StatelessWidget {
  const _TagFilterBar({required this.state, required this.controller});

  final KnowledgeState state;
  final KnowledgeController controller;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(t.knowledge.tags.all),
                    selected: state.tagFilter == null,
                    onSelected: (_) => controller.setTagFilter(null),
                  ),
                ),
                for (final tag in state.tags)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      label: Text('${tag.name} (${tag.count})'),
                      selected: state.tagFilter == tag.name,
                      onSelected: (_) =>
                          controller.setTagFilter(state.tagFilter == tag.name ? null : tag.name),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            tooltip: t.knowledge.tags.manage,
            icon: const Icon(Icons.sell_outlined),
            onPressed: () => _manageTags(context, state, controller),
          ),
        ],
      ),
    );
  }
}

Future<void> _manageTags(
  BuildContext context,
  KnowledgeState state,
  KnowledgeController controller,
) async {
  final t = Translations.of(context);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(t.knowledge.tags.manage),
      content: SizedBox(
        width: 420,
        height: 320,
        child: state.tags.isEmpty
            ? Center(child: Text(t.knowledge.tags.none))
            : ListView.builder(
                itemCount: state.tags.length,
                itemBuilder: (ctx, index) {
                  final tag = state.tags[index];
                  return ListTile(
                    dense: true,
                    title: Text(tag.name),
                    subtitle: Text('${tag.count}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final removed = await AppDialog.confirm(
                          ctx,
                          title: t.knowledge.common.delete,
                          message: t.knowledge.dialog.deleteMessage,
                          confirmLabel: t.knowledge.common.delete,
                        );
                        if (!removed) return;
                        await controller.deleteTag(tag.id);
                        if (ctx.mounted) Navigator.of(ctx).pop();
                      },
                    ),
                  );
                },
              ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(t.knowledge.common.close)),
      ],
    ),
  );
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
      body: Column(
        children: [
          if (state.tags.isNotEmpty) _TagFilterBar(state: state, controller: controller),
          Expanded(
            child: state.memories.isEmpty
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
                            _makeCriticalButton(
                              context,
                              isCritical: memory.priority == KnowledgePriority.critical,
                              promote: () => controller.saveMemory(
                                id: memory.id,
                                body: {'priority': 'critical'},
                              ),
                            ),
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
                                if (body != null) {
                                  await controller.saveMemory(id: memory.id, body: body);
                                }
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
          ),
        ],
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
                      _makeCriticalButton(
                        context,
                        isCritical: rule.priority == KnowledgePriority.critical,
                        promote: () =>
                            controller.saveRule(id: rule.id, body: {'priority': 'critical'}),
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

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/features/shared_context/state/shared_context_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Editor pane for a project's shared context document (.ddagent/shared-context.md).
/// Can be mounted standalone in a screen or embedded as a workspace pane (PaneKind.notes).
class SharedNotesPane extends ConsumerStatefulWidget {
  const SharedNotesPane({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<SharedNotesPane> createState() => _SharedNotesPaneState();
}

class _SharedNotesPaneState extends ConsumerState<SharedNotesPane> {
  late final TextEditingController _textCtrl;
  String? _lastLoadedContent;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _syncTextFromState(SharedContextState state) {
    if (state.savedContent != _lastLoadedContent) {
      _lastLoadedContent = state.savedContent;
      if (_textCtrl.text != state.savedContent) {
        _textCtrl.text = state.savedContent;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sharedContextProvider(widget.projectId));
    final ctrl = ref.read(sharedContextProvider(widget.projectId).notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    _syncTextFromState(state);

    final updatedDate = state.updatedAt != null
        ? DateTime.tryParse(state.updatedAt!)?.toLocal()
        : null;

    return Container(
      color: c.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.3),
              border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
            ),
            child: Row(
              children: [
                Icon(Icons.description_outlined, size: 16, color: c.mutedForeground),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    'Shared memory — injected into every session of this project',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.labelSmall?.copyWith(color: c.mutedForeground),
                  ),
                ),
                if (updatedDate != null) ...[
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${updatedDate.hour.toString().padLeft(2, '0')}:${updatedDate.minute.toString().padLeft(2, '0')}',
                    style: t.labelSmall?.copyWith(
                      fontSize: 10,
                      color: c.mutedForeground.withValues(alpha: 0.7),
                    ),
                  ),
                ],
                const SizedBox(width: AppSpacing.xs),
                AppButton(
                  variant: AppButtonVariant.ghost,
                  size: AppButtonSize.sm,
                  onPressed: widget.projectId == null || state.saving || !state.isDirty
                      ? null
                      : () => ctrl.save(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, size: 14),
                      const SizedBox(width: 4),
                      Text(state.saving ? 'Saving…' : 'Save'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Error banner
          if (state.error != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
              color: c.destructive.withValues(alpha: 0.1),
              child: Row(
                children: [
                  Expanded(
                    child: Text(state.error!, style: t.bodySmall?.copyWith(color: c.destructive)),
                  ),
                  InkWell(
                    onTap: ctrl.clearError,
                    child: Icon(Icons.close, size: 14, color: c.destructive),
                  ),
                ],
              ),
            ),

          // Editor / Empty State
          Expanded(
            child: widget.projectId == null
                ? Center(
                    child: Text(
                      'Select a workspace to edit its shared context',
                      style: t.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  )
                : state.loading && state.document == null
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: TextField(
                      controller: _textCtrl,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      onChanged: ctrl.updateContent,
                      style: t.bodySmall?.copyWith(fontFamily: 'monospace', height: 1.5),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '# Shared context\nConventions, decisions and pointers every agent should know…',
                        hintStyle: t.bodySmall?.copyWith(
                          fontFamily: 'monospace',
                          color: c.mutedForeground.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

/// Standalone screen for Shared Context & Notes at /shared-notes route.
class SharedNotesScreen extends ConsumerStatefulWidget {
  const SharedNotesScreen({super.key, this.projectId});

  final String? projectId;

  @override
  ConsumerState<SharedNotesScreen> createState() => _SharedNotesScreenState();
}

class _SharedNotesScreenState extends ConsumerState<SharedNotesScreen> {
  String? _selectedProjectId;

  @override
  void initState() {
    super.initState();
    _selectedProjectId = widget.projectId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(projectsProvider.notifier).load();
      final projects = ref.read(projectsProvider).projects;
      if (_selectedProjectId == null && projects.isNotEmpty) {
        setState(() => _selectedProjectId = projects.first.projectId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider).projects;
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    final activeId = _selectedProjectId ?? projects.firstOrNull?.projectId;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with Project selector
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Icon(Icons.notes, size: 20, color: c.mutedForeground),
                    const SizedBox(width: AppSpacing.xs),
                    Text('Shared Notes', style: t.titleSmall),
                    const SizedBox(width: AppSpacing.md),
                    if (projects.isNotEmpty)
                      DropdownButton<String>(
                        value: activeId,
                        underline: const SizedBox.shrink(),
                        items: [
                          for (final p in projects)
                            DropdownMenuItem(
                              value: p.projectId,
                              child: Text(
                                p.displayName.isNotEmpty ? p.displayName : p.projectId,
                                style: t.bodySmall,
                              ),
                            ),
                        ],
                        onChanged: (newId) {
                          if (newId != null) {
                            setState(() => _selectedProjectId = newId);
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
            Expanded(child: SharedNotesPane(projectId: activeId)),
          ],
        ),
      ),
    );
  }
}

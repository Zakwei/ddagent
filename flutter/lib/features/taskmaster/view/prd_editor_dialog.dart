import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/taskmaster/state/taskmaster_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// PRD editor (port of prd-editor/PRDEditor): file name, template picker,
/// markdown content with a preview toggle, Save and "Parse PRD" (generates
/// tasks from the document).
class PrdEditorDialog extends ConsumerStatefulWidget {
  const PrdEditorDialog({super.key, this.fileName});

  /// Existing `.taskmaster/docs` file to open; null → new document.
  final String? fileName;

  static Future<void> show(BuildContext context, {String? fileName}) =>
      showDialog<void>(
        context: context,
        builder: (_) => PrdEditorDialog(fileName: fileName),
      );

  @override
  ConsumerState<PrdEditorDialog> createState() => _PrdEditorDialogState();
}

class _PrdEditorDialogState extends ConsumerState<PrdEditorDialog> {
  late final TextEditingController _name;
  final _content = TextEditingController();
  bool _preview = false;
  bool _opened = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.fileName ?? 'prd.txt');
    if (widget.fileName != null) {
      _opened = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(
          ref.read(taskmasterProvider.notifier).openPrd(widget.fileName!),
        );
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _content.dispose();
    super.dispose();
  }

  /// Validates the buffer, confirms overwriting an existing file name, then
  /// saves. Returns false (dialog stays open) on validation or cancel.
  Future<bool> _save() async {
    final name = _name.text.trim();
    final invalid = name.isEmpty
        ? 'Please provide a filename for the PRD.'
        : _content.text.trim().isEmpty
        ? 'Please add content before saving.'
        : null;
    if (invalid != null) {
      setState(() => _error = invalid);
      return false;
    }
    setState(() => _error = '');
    final state = ref.read(taskmasterProvider);
    final conflict =
        widget.fileName == null &&
        state.prdFiles.any((p) => p.fileName == name);
    if (conflict) {
      final ok = await AppDialog.confirm(
        context,
        title: 'File already exists',
        message:
            'A PRD named "$name" already exists. Do you want to overwrite it?',
        confirmLabel: 'Overwrite',
      );
      if (!ok || !mounted) return false;
    }
    ref.read(taskmasterProvider.notifier).setPrdContent(_content.text);
    return ref.read(taskmasterProvider.notifier).savePrd(name);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(taskmasterProvider);
    final ctrl = ref.read(taskmasterProvider.notifier);
    final c = context.appColors;
    final busy = state.busy;

    // The controller's PRD buffer feeds the field once it arrives — local
    // edits keep _content as the source of truth afterwards.
    if (_opened && _content.text != state.prdContent) {
      _content.text = state.prdContent;
      _content.selection = TextSelection.collapsed(
        offset: _content.text.length,
      );
    }

    return AppDialog(
      title: 'PRD — ${_name.text.isEmpty ? 'new file' : _name.text}',
      content: SizedBox(
        width: 640,
        height: 480,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: AppInput(
                    controller: _name,
                    hint: 'file name (e.g. prd.txt)',
                    enabled: !busy,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (state.prdTemplates.isNotEmpty)
                  DropdownButton<String>(
                    hint: Text(
                      'Template',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    underline: const SizedBox.shrink(),
                    items: [
                      for (final tp in state.prdTemplates)
                        DropdownMenuItem(
                          value: tp.id,
                          child: Text(
                            tp.name.isEmpty ? tp.id : tp.name,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                    ],
                    onChanged: busy
                        ? null
                        : (id) {
                            if (id == null) return;
                            final t = [
                              for (final tp in state.prdTemplates)
                                if (tp.id == id) tp,
                            ].first;
                            _content.text = t.content;
                            _opened = false;
                          },
                  ),
                const SizedBox(width: AppSpacing.xs),
                IconButton(
                  tooltip: _preview ? 'Edit' : 'Preview markdown',
                  onPressed: () => setState(() => _preview = !_preview),
                  icon: Icon(
                    _preview ? Icons.edit_note : Icons.preview_outlined,
                    size: 18,
                    color: _preview ? c.primary : c.mutedForeground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_error.isNotEmpty) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _error,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: c.destructive),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
            ],
            Expanded(
              child: _preview
                  ? Container(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      decoration: BoxDecoration(
                        border: Border.all(color: c.border),
                        borderRadius: AppRadii.borderMd,
                      ),
                      child: SingleChildScrollView(
                        child: AppMarkdown(data: _content.text),
                      ),
                    )
                  : TextField(
                      controller: _content,
                      expands: true,
                      maxLines: null,
                      enabled: !busy,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                      ),
                      decoration: const InputDecoration(
                        hintText: '# Product Requirements Document…',
                      ),
                      onChanged: ctrl.setPrdContent,
                    ),
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        AppButton(
          variant: AppButtonVariant.secondary,
          loading: busy,
          onPressed: () async {
            final ok = await _save();
            if (!context.mounted) return;
            if (ok) AppToast.show(context, 'PRD saved');
          },
          child: const Text('Save'),
        ),
        AppButton(
          loading: busy,
          onPressed: _name.text.trim().isEmpty
              ? null
              : () async {
                  if (!await _save() || !context.mounted) return;
                  final ok = await ctrl.parsePrd(fileName: _name.text.trim());
                  if (!context.mounted) return;
                  if (ok) {
                    Navigator.of(context).pop();
                    AppToast.show(context, 'Tasks generated from PRD');
                  }
                },
          child: const Text('Parse PRD'),
        ),
      ],
    );
  }
}

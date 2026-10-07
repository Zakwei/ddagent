import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/orchestrator/data/orchestrator_config.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Model picker — a lazy, searchable dialog instead of a `DropdownButton`.
///
/// Provider catalogs are large (Devin ships 700+ models), and `DropdownButton`
/// materializes *every* item in an offstage `IndexedStack` on each build —
/// with a full pool that is thousands of hidden rows rebuilt on every
/// keystroke, which made the whole section janky and the scrollbar jump. Only
/// the rows in view are built here, with a search field for the long tail.
///
/// Shared by the orchestrator and mini-orchestrator settings so a model is
/// always chosen from the provider catalog rather than typed by hand.
class ModelSelect extends StatelessWidget {
  const ModelSelect({
    required this.value,
    required this.options,
    required this.hint,
    required this.onChanged,
    super.key,
  });

  final String value;
  final List<OrchModelOption> options;
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final selected = options.where((o) => o.value == value).firstOrNull;
    final label = value.isEmpty ? hint : (selected?.label ?? value);
    return InkWell(
      borderRadius: AppRadii.borderLg,
      onTap: () async {
        final picked = await showDialog<String>(
          context: context,
          builder: (_) => _ModelPickerDialog(value: value, options: options, hint: hint),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: c.card,
          border: Border.all(color: c.input),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: value.isEmpty ? c.mutedForeground : c.foreground),
              ),
            ),
            Icon(LucideIcons.chevronsUpDown, size: 14, color: c.mutedForeground),
          ],
        ),
      ),
    );
  }
}

/// Searchable list of one provider's models — `ListView.builder` so only the
/// rows in view are inflated.
class _ModelPickerDialog extends StatefulWidget {
  const _ModelPickerDialog({required this.value, required this.options, required this.hint});

  final String value;
  final List<OrchModelOption> options;
  final String hint;

  @override
  State<_ModelPickerDialog> createState() => _ModelPickerDialogState();
}

class _ModelPickerDialogState extends State<_ModelPickerDialog> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<({String value, String label})> _entries() {
    final list = <({String value, String label})>[
      (value: '', label: widget.hint),
      // A stored model missing from the catalog keeps a raw-value entry
      // instead of silently snapping to the first option.
      if (widget.value.isNotEmpty && !widget.options.any((o) => o.value == widget.value))
        (value: widget.value, label: widget.value),
      for (final o in widget.options) (value: o.value, label: o.label),
    ];
    final query = _search.text.trim().toLowerCase();
    if (query.isEmpty) return list;
    return [
      for (final e in list)
        if (e.value.toLowerCase().contains(query) || e.label.toLowerCase().contains(query)) e,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final entries = _entries();
    return Dialog(
      backgroundColor: c.popover,
      insetPadding: const EdgeInsets.all(AppSpacing.lg),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadii.borderLg,
        side: BorderSide(color: c.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(t.settings.orchestration.pool.fields.model, style: tt.titleSmall),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 32,
                child: TextField(
                  controller: _search,
                  autofocus: true,
                  onChanged: (_) => setState(() {}),
                  style: tt.bodySmall,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    hintText: t.chat.providerSelection.searchModels,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              SizedBox(
                height: 320,
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          t.common.fileTree.noSearchResults,
                          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      )
                    : ListView.builder(
                        itemCount: entries.length,
                        itemExtent: 36,
                        itemBuilder: (context, i) {
                          final entry = entries[i];
                          final selected = entry.value == widget.value;
                          return InkWell(
                            onTap: () => Navigator.of(context).pop(entry.value),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: tt.bodySmall?.copyWith(
                                        color: entry.value.isEmpty
                                            ? c.mutedForeground
                                            : c.foreground,
                                        fontWeight: selected ? FontWeight.w600 : null,
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Icon(LucideIcons.check, size: 14, color: c.foreground),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

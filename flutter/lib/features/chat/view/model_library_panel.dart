import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Port of `ModelLibraryPanel.tsx` — custom-model CRUD per provider plus the
/// shared default-model pick (`${provider}-model` in the `settings` Hive box,
/// the same key the composer reads). Hosted at Settings → Models; chat
/// pickers keep selection only (web parity after the move out of `/models`
/// and the provider picker).
///
/// Mutations answer `{provider, model, models}` — `models` is the merged
/// `{OPTIONS, DEFAULT}` catalog, applied straight to the local per-provider
/// cache instead of refetching (web `applyProviderCatalog` parity).
class ModelLibraryPanel extends ConsumerStatefulWidget {
  const ModelLibraryPanel({this.initialProvider, super.key});

  final String? initialProvider;

  @override
  ConsumerState<ModelLibraryPanel> createState() => _ModelLibraryPanelState();
}

class _ModelLibraryPanelState extends ConsumerState<ModelLibraryPanel> {
  /// Web `PROVIDERS` — the catalog-managed set (no `orchestrator`).
  static const _providers = ['claude', 'codex', 'cursor', 'opencode', 'devin'];

  late String _provider = _providers.contains(widget.initialProvider)
      ? widget.initialProvider!
      : _providers.first;

  /// Per-provider catalog cache — `{OPTIONS}` rows plus the DEFAULT.
  final Map<String, List<Map<String, dynamic>>> _options = {};

  /// Per-provider catalog DEFAULT — the effective default when nothing is
  /// stored under `${provider}-model`.
  final Map<String, String?> _defaults = {};
  final Set<String> _loading = {};
  final Set<String> _failed = {};

  final _name = TextEditingController();
  final _id = TextEditingController();
  Map<String, dynamic>? _editing;
  bool _saving = false;
  int? _confirmDeleteId;
  int? _deletingId;
  String? _error;
  String? _notice;

  static int? _recordId(Map<String, dynamic> option) {
    final v = option['recordId'];
    return v is num ? v.toInt() : int.tryParse('$v');
  }

  String _idOf(Map<String, dynamic> m) => '${m['id'] ?? m['value']}';
  String _labelOf(Map<String, dynamic> m) =>
      '${m['label'] ?? m['name'] ?? _idOf(m)}';

  String _errorText(Object e) => e is AppError ? e.message : '$e';

  /// Shared picker storage — same Hive box + key the composer reads
  /// (`composer_controller` `_prefs`).
  static Box<dynamic> get _prefs => Hive.box<dynamic>('settings');
  String? _storedDefault(String provider) =>
      _prefs.get('$provider-model')?.toString();

  void _pickDefault(Map<String, dynamic> option) {
    unawaited(_prefs.put('$_provider-model', _idOf(option)));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    unawaited(_load(_provider));
  }

  @override
  void dispose() {
    _name.dispose();
    _id.dispose();
    super.dispose();
  }

  Future<void> _load(String provider) async {
    if (_options.containsKey(provider) ||
        _loading.contains(provider) ||
        _failed.contains(provider)) {
      return;
    }
    setState(() => _loading.add(provider));
    try {
      final catalog = await ref
          .read(sessionsRepositoryProvider)
          .models(provider);
      if (!mounted) return;
      setState(() {
        _options[provider] = catalog.options;
        _defaults[provider] = catalog.defaultModel;
        _loading.remove(provider);
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loading.remove(provider);
        _failed.add(provider);
        _error = _errorText(e);
      });
    }
  }

  /// `applyProviderCatalog` — merge the mutation's returned catalog.
  void _applyCatalog(String provider, dynamic models) {
    if (models is! Map) return;
    _options[provider] = [
      for (final m in models['OPTIONS'] as List? ?? const [])
        if (m is Map) Map<String, dynamic>.from(m),
    ];
    _defaults[provider] = models['DEFAULT']?.toString();
  }

  void _selectProvider(String provider) {
    setState(() {
      _provider = provider;
      _confirmDeleteId = null;
      _notice = null;
      _error = null;
      _editing = null;
      _name.clear();
      _id.clear();
    });
    unawaited(_load(provider));
  }

  void _startEditing(Map<String, dynamic> option) {
    setState(() {
      _editing = option;
      _name.text = _labelOf(option);
      _id.text = _idOf(option);
      _confirmDeleteId = null;
      _notice = null;
      _error = null;
    });
  }

  void _resetForm() {
    _editing = null;
    _name.clear();
    _id.clear();
    _error = null;
  }

  Future<void> _submit() async {
    final name = _name.text.trim();
    final id = _id.text.trim();
    if (name.isEmpty || id.isEmpty) {
      setState(() => _error = 'Enter both a model name and model ID.');
      return;
    }
    if (RegExp(r'\s').hasMatch(id)) {
      setState(() => _error = 'Model IDs cannot contain spaces.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
      _notice = null;
    });
    try {
      final repo = ref.read(sessionsRepositoryProvider);
      final editing = _editing;
      final res = editing != null
          ? await repo.updateModel(_provider, '${_recordId(editing)}', {
              'model': name,
              'id': id,
            })
          : await repo.addModel(_provider, {'model': name, 'id': id});
      if (!mounted) return;
      setState(() {
        _applyCatalog(_provider, res['models']);
        _notice = editing != null ? '$name was updated.' : '$name was added.';
        _resetForm();
      });
      // A renamed model keeps its default-model pick (web
      // `useProviderModelLibrary` rebind parity).
      if (editing != null && _storedDefault(_provider) == _idOf(editing)) {
        unawaited(_prefs.put('$_provider-model', id));
      }
    } on Object catch (e) {
      if (mounted) setState(() => _error = _errorText(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete(Map<String, dynamic> option) async {
    final recordId = _recordId(option);
    if (recordId == null) return;
    setState(() {
      _deletingId = recordId;
      _error = null;
      _notice = null;
    });
    try {
      final res = await ref
          .read(sessionsRepositoryProvider)
          .deleteModel(_provider, '$recordId');
      if (!mounted) return;
      setState(() {
        _applyCatalog(_provider, res['models']);
        if (_recordId(_editing ?? const {}) == recordId) _resetForm();
        _confirmDeleteId = null;
        _notice = '${_labelOf(option)} was deleted.';
      });
      // A deleted model can't stay the shared default — falls back to the
      // catalog DEFAULT on the next composer read.
      if (_storedDefault(_provider) == _idOf(option)) {
        unawaited(_prefs.delete('$_provider-model'));
      }
    } on Object catch (e) {
      if (mounted) setState(() => _error = _errorText(e));
    } finally {
      if (mounted) setState(() => _deletingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final options = _options[_provider] ?? const <Map<String, dynamic>>[];
    final customModels = [
      for (final m in options)
        if (m['isCustom'] == true) m,
    ];
    final predefined = [
      for (final m in options)
        if (m['isCustom'] != true) m,
    ];
    final loading = _loading.contains(_provider);
    // Effective default — stored `${provider}-model` pick, else the catalog
    // DEFAULT (web `selectedModel ?? catalog.defaultModel` parity).
    final effectiveDefault = _storedDefault(_provider) ?? _defaults[_provider];

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — web's `Plus` tile + title (the section nav replaces the
          // old dialog's close button).
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: c.primary.withValues(alpha: 0.1),
                    border: Border.all(
                      color: c.primary.withValues(alpha: 0.25),
                    ),
                    borderRadius: AppRadii.borderLg,
                  ),
                  child: Icon(LucideIcons.plus, size: 16, color: c.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Model library',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 24 / 16,
                          color: c.foreground,
                        ),
                      ),
                      Text(
                        'Add model IDs supported by your provider. Built-in models stay locked. '
                        'The circle marks the default model.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 16 / 12,
                          color: c.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Provider tabs — scrollable like the web's overflow-x-auto row.
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: c.muted.withValues(alpha: 0.25),
                border: Border.all(color: c.border.withValues(alpha: 0.7)),
                borderRadius: AppRadii.borderLg,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  spacing: 2,
                  children: [
                    for (final p in _providers)
                      _providerTab(c, p, p == _provider),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      _form(c),
                      const SizedBox(height: 16),
                      _sectionHeader(
                        c,
                        'Your models',
                        'Editable and stored in auth.db',
                        customModels.length,
                      ),
                      const SizedBox(height: 6),
                      if (customModels.isEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: c.border.withValues(alpha: 0.7),
                            ),
                            borderRadius: AppRadii.borderLg,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.package,
                                size: 18,
                                color: c.mutedForeground,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'No custom models yet',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: c.foreground,
                                ),
                              ),
                              Text(
                                'Add one with the form and it will appear in every model picker.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: c.mutedForeground,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        for (final m in customModels)
                          _customRow(c, m, effectiveDefault),
                      const SizedBox(height: 16),
                      _sectionHeader(
                        c,
                        'Built-in models',
                        'Maintained by ddagent and read-only',
                        predefined.length,
                      ),
                      const SizedBox(height: 6),
                      Container(
                        decoration: BoxDecoration(
                          color: c.background.withValues(alpha: 0.6),
                          border: Border.all(
                            color: c.border.withValues(alpha: 0.7),
                          ),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var i = 0; i < predefined.length; i++)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: i < predefined.length - 1
                                      ? Border(
                                          bottom: BorderSide(
                                            color: c.border.withValues(
                                              alpha: 0.6,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    _defaultRadio(
                                      c,
                                      predefined[i],
                                      effectiveDefault,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _labelOf(predefined[i]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: c.foreground,
                                            ),
                                          ),
                                          Text(
                                            _idOf(predefined[i]),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontFamily: 'monospace',
                                              fontSize: 10,
                                              color: c.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      LucideIcons.lockKeyhole,
                                      size: 12,
                                      color: c.mutedForeground.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _providerTab(AppColors c, String provider, bool selected) {
    return GestureDetector(
      onTap: () => _selectProvider(provider),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? c.background : Colors.transparent,
          borderRadius: AppRadii.borderMd,
          border: selected
              ? Border.all(color: c.border.withValues(alpha: 0.7))
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            ProviderLogo(provider: provider, size: 14),
            Text(
              providerLabel(provider),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected ? c.foreground : c.mutedForeground,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(AppColors c, String title, String subtitle, int count) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.1,
                  color: c.foreground,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(fontSize: 11, color: c.mutedForeground),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: c.muted,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: TextStyle(fontSize: 10, color: c.mutedForeground),
          ),
        ),
      ],
    );
  }

  Widget _form(AppColors c) {
    final editing = _editing != null;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.2),
        border: Border.all(color: c.border.withValues(alpha: 0.7)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      editing ? 'Edit custom model' : 'Add a custom model',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: c.foreground,
                      ),
                    ),
                    Text(
                      'The ID is sent to ${providerLabel(_provider)} exactly as written.',
                      style: TextStyle(fontSize: 11, color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
              if (editing)
                IconButton(
                  tooltip: 'Cancel editing',
                  onPressed: () => setState(_resetForm),
                  icon: Icon(LucideIcons.x, size: 14, color: c.mutedForeground),
                  visualDensity: VisualDensity.compact,
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Model name',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.foreground,
            ),
          ),
          const SizedBox(height: 4),
          AppInput(
            controller: _name,
            hint: 'e.g. GPT-5.5 Pro',
            onSubmitted: (_) => unawaited(_submit()),
          ),
          const SizedBox(height: 8),
          Text(
            'Model ID',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.foreground,
            ),
          ),
          const SizedBox(height: 4),
          AppInput(
            controller: _id,
            hint: 'e.g. gpt-5.5-pro',
            onSubmitted: (_) => unawaited(_submit()),
          ),
          const SizedBox(height: 4),
          Text(
            'Use the exact identifier accepted by the provider CLI. IDs cannot contain spaces.',
            style: TextStyle(
              fontSize: 10,
              height: 14 / 10,
              color: c.mutedForeground,
            ),
          ),
          if (_error != null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: c.destructive.withValues(alpha: 0.1),
                border: Border.all(color: c.destructive.withValues(alpha: 0.3)),
                borderRadius: AppRadii.borderLg,
              ),
              child: Text(
                _error!,
                style: TextStyle(fontSize: 11, color: c.destructive),
              ),
            ),
          if (_notice != null && _error == null)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                ),
                borderRadius: AppRadii.borderLg,
              ),
              child: Row(
                spacing: 6,
                children: [
                  const Icon(
                    LucideIcons.check,
                    size: 12,
                    color: Color(0xFF10B981),
                  ),
                  Expanded(
                    child: Text(
                      _notice!,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: _saving ? null : () => unawaited(_submit()),
              loading: _saving,
              child: Text(
                _saving
                    ? 'Saving…'
                    : editing
                    ? 'Save changes'
                    : 'Add model',
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Leading default-model picker — writes `${provider}-model`, the key the
  /// composer resolves before the catalog DEFAULT.
  Widget _defaultRadio(
    AppColors c,
    Map<String, dynamic> option,
    String? effectiveDefault,
  ) {
    final selected = _idOf(option) == effectiveDefault;
    return Tooltip(
      message: selected ? 'Default model' : 'Set as default',
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => _pickDefault(option),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            selected ? LucideIcons.circleDot : LucideIcons.circle,
            size: 14,
            color: selected
                ? c.primary
                : c.mutedForeground.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  Widget _customRow(
    AppColors c,
    Map<String, dynamic> option,
    String? effectiveDefault,
  ) {
    final recordId = _recordId(option);
    final confirming = recordId != null && _confirmDeleteId == recordId;
    final deleting = recordId != null && _deletingId == recordId;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: c.primary.withValues(alpha: 0.04),
        border: Border.all(color: c.primary.withValues(alpha: 0.2)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _defaultRadio(c, option, effectiveDefault),
              const SizedBox(width: 2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _labelOf(option),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: c.foreground,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _customBadge(c),
                      ],
                    ),
                    Text(
                      _idOf(option),
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11,
                        color: c.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              if (!confirming) ...[
                IconButton(
                  tooltip: 'Edit ${_labelOf(option)}',
                  onPressed: () => _startEditing(option),
                  icon: Icon(
                    LucideIcons.pencil,
                    size: 13,
                    color: c.mutedForeground,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
                IconButton(
                  tooltip: 'Delete ${_labelOf(option)}',
                  onPressed: recordId == null
                      ? null
                      : () => setState(() => _confirmDeleteId = recordId),
                  icon: Icon(
                    LucideIcons.trash2,
                    size: 13,
                    color: c.mutedForeground,
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ],
          ),
          if (confirming)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: c.border.withValues(alpha: 0.6)),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Delete this model from all pickers?',
                      style: TextStyle(fontSize: 12, color: c.mutedForeground),
                    ),
                  ),
                  AppButton(
                    variant: AppButtonVariant.ghost,
                    size: AppButtonSize.sm,
                    onPressed: () => setState(() => _confirmDeleteId = null),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 6),
                  AppButton(
                    variant: AppButtonVariant.destructive,
                    size: AppButtonSize.sm,
                    loading: deleting,
                    onPressed: () => unawaited(_delete(option)),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _customBadge(AppColors c) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: c.muted,
      border: Border.all(color: c.border),
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      'Custom',
      style: TextStyle(
        fontSize: 9,
        height: 1,
        fontWeight: FontWeight.w500,
        color: c.mutedForeground,
      ),
    ),
  );
}

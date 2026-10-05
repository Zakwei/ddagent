import 'dart:convert';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/features/mcp/data/mcp_constants.dart';
import 'package:ddagent_app/features/mcp/data/mcp_formatting.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/projects/state/projects_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Submit callback — receives the POST body built by [buildMcpPayload];
/// returns null on success, otherwise the message shown as `submitError`.
typedef McpSubmit = Future<String?> Function(Map<String, dynamic> payload);

/// Add/edit MCP server dialog — port of `McpServerFormModal.tsx` +
/// `useMcpServerForm.ts`. `global: true` is the "add to every provider"
/// variant (limited scopes/transports, no editing).
class McpServerFormDialog extends ConsumerStatefulWidget {
  const McpServerFormDialog({
    super.key,
    required this.provider,
    required this.onSubmit,
    this.editing,
    this.global = false,
    this.title,
    this.description,
    this.submitLabel,
    this.supportedScopes,
    this.supportedTransports,
  });

  final String provider;
  final McpSubmit onSubmit;

  /// Non-null → edit mode (scope is read-only, no import-mode toggle).
  final McpServer? editing;
  final bool global;
  final String? title;
  final String? description;
  final String? submitLabel;
  final List<McpScope>? supportedScopes;
  final List<McpTransport>? supportedTransports;

  /// Resolves to true when a server was saved — callers toast on true.
  static Future<bool> show(
    BuildContext context, {
    required String provider,
    required McpSubmit onSubmit,
    McpServer? editing,
    bool global = false,
    String? title,
    String? description,
    String? submitLabel,
    List<McpScope>? supportedScopes,
    List<McpTransport>? supportedTransports,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => McpServerFormDialog(
        provider: provider,
        onSubmit: onSubmit,
        editing: editing,
        global: global,
        title: title,
        description: description,
        submitLabel: submitLabel,
        supportedScopes: supportedScopes,
        supportedTransports: supportedTransports,
      ),
    );
    return result ?? false;
  }

  @override
  ConsumerState<McpServerFormDialog> createState() => _McpServerFormDialogState();
}

class _McpServerFormDialogState extends ConsumerState<McpServerFormDialog> {
  late final TextEditingController _name;
  late final TextEditingController _command;
  late final TextEditingController _args;
  late final TextEditingController _env;
  late final TextEditingController _cwd;
  late final TextEditingController _url;
  late final TextEditingController _headers;
  late final TextEditingController _envVars;
  late final TextEditingController _bearerTokenEnvVar;
  late final TextEditingController _jsonInput;

  late McpScope _scope;
  late McpTransport _transport;
  String _workspacePath = '';
  McpImportMode _importMode = McpImportMode.form;
  String _jsonError = '';
  String? _submitError;
  bool _submitting = false;

  List<McpScope> get _scopes => widget.supportedScopes ?? mcpSupportedScopes(widget.provider);

  List<McpTransport> get _transports =>
      widget.supportedTransports ?? mcpSupportedTransports(widget.provider);

  bool get _isEditing => widget.editing != null;

  /// `!isGlobalMode && MCP_SUPPORTS_WORKING_DIRECTORY[provider]`.
  bool get _supportsWorkingDirectory =>
      !widget.global && (kMcpSupportsWorkingDirectory[widget.provider] ?? false);

  bool get _showCodexFields => widget.provider == 'codex' && !widget.global;

  bool get _supportsHttpHeaders => _transport != McpTransport.stdio;

  @override
  void initState() {
    super.initState();
    final server = widget.editing;
    _name = TextEditingController(text: server?.name ?? '');
    _command = TextEditingController(text: server?.command ?? '');
    _args = TextEditingController(text: (server?.args ?? const []).join('\n'));
    _env = TextEditingController(text: formatKeyValueLines(server?.env ?? const {}));
    _cwd = TextEditingController(text: server?.cwd ?? '');
    _url = TextEditingController(text: server?.url ?? '');
    _headers = TextEditingController(text: formatKeyValueLines(server?.headers ?? const {}));
    _envVars = TextEditingController(text: (server?.envVars ?? const []).join('\n'));
    _bearerTokenEnvVar = TextEditingController(text: server?.bearerTokenEnvVar ?? '');
    _jsonInput = TextEditingController();
    _scope = _clampScope(server?.scope ?? _scopes.first);
    _transport = _clampTransport(server?.transport ?? _transports.first);
    _workspacePath = server?.workspacePath ?? '';
    // Rebuild so `canSubmit` tracks every keystroke.
    for (final c in [
      _name,
      _command,
      _args,
      _env,
      _cwd,
      _url,
      _headers,
      _envVars,
      _bearerTokenEnvVar,
      _jsonInput,
    ]) {
      c.addListener(_onFieldChanged);
    }
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _command,
      _args,
      _env,
      _cwd,
      _url,
      _headers,
      _envVars,
      _bearerTokenEnvVar,
      _jsonInput,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _onFieldChanged() {
    if (_importMode == McpImportMode.json) _validateJson(_jsonInput.text);
    setState(() {});
  }

  McpScope _clampScope(McpScope scope) => _scopes.contains(scope) ? scope : _scopes.first;

  McpTransport _clampTransport(McpTransport transport) =>
      _transports.contains(transport) ? transport : _transports.first;

  String _scopeLabel(McpScope scope) {
    final t = Translations.of(context);
    return switch (scope) {
      McpScope.user =>
        widget.global ? t.mcp.form.scope.userAllProviders : t.settings.mcpForm.scope.userGlobal,
      McpScope.local => t.mcp.form.scope.claudeLocal,
      McpScope.project =>
        widget.global
            ? t.mcp.form.scope.projectAllProviders
            : t.settings.mcpForm.scope.projectLocal,
    };
  }

  /// `getScopeDescription` — these are literals in the web modal too.
  String get _scopeDescription {
    final t = Translations.of(context);
    return switch (_scope) {
      McpScope.user =>
        widget.global ? t.mcp.form.scope.description.userGlobal : t.mcp.form.scope.description.user,
      McpScope.local => t.mcp.form.scope.description.local,
      McpScope.project =>
        widget.global
            ? t.mcp.form.scope.description.projectGlobal
            : t.mcp.form.scope.description.project,
    };
  }

  /// `validateJsonInput` — live JSON-mode validation with localized messages.
  void _validateJson(String value) {
    final t = Translations.of(context);
    String? error;
    if (value.trim().isNotEmpty) {
      try {
        final parsed = jsonDecode(value);
        final map = parsed is Map ? parsed : null;
        final transport = McpTransport.parse(map?['transport'] ?? map?['type']);
        final command = map?['command'];
        final url = map?['url'];
        if (transport == null) {
          error = t.settings.mcpForm.validation.missingType;
        } else if (!_transports.contains(transport)) {
          error = widget.global
              ? t.mcp.form.validation.unsupportedGlobal(type: transport.wire)
              : t.mcp.form.validation.unsupportedProvider(
                  provider: widget.provider,
                  type: transport.wire,
                );
        } else if (transport == McpTransport.stdio && (command is! String || command.isEmpty)) {
          error = t.settings.mcpForm.validation.stdioRequiresCommand;
        } else if (transport != McpTransport.stdio && (url is! String || url.isEmpty)) {
          error = t.settings.mcpForm.validation.httpRequiresUrl(type: transport.wire);
        }
      } on FormatException {
        error = t.settings.mcpForm.validation.invalidJson;
      }
    }
    if (error != _jsonError) setState(() => _jsonError = error ?? '');
  }

  /// `canSubmit` parity.
  bool get _canSubmit {
    if (_name.text.trim().isEmpty) return false;
    if (_scope != McpScope.user && _workspacePath.trim().isEmpty) return false;
    if (_importMode == McpImportMode.json) {
      return _jsonInput.text.trim().isNotEmpty && _jsonError.isEmpty;
    }
    return _transport == McpTransport.stdio
        ? _command.text.trim().isNotEmpty
        : _url.text.trim().isNotEmpty;
  }

  Future<void> _submit() async {
    final i18n = Translations.of(context);
    setState(() {
      _submitting = true;
      _submitError = null;
    });
    try {
      final payload = buildMcpPayload(
        provider: widget.provider,
        name: _name.text,
        scope: _scope,
        workspacePath: _workspacePath,
        transport: _transport,
        command: _command.text,
        args: parseListLines(_args.text),
        env: parseKeyValueLines(_env.text),
        cwd: _cwd.text,
        url: _url.text,
        headers: parseKeyValueLines(_headers.text),
        envVars: parseListLines(_envVars.text),
        bearerTokenEnvVar: _bearerTokenEnvVar.text,
        // No form field edits these — an edited server keeps its values.
        envHttpHeaders: widget.editing?.envHttpHeaders ?? const {},
        importMode: _importMode,
        jsonInput: _jsonInput.text,
        supportedTransports: widget.supportedTransports,
        supportsWorkingDirectory: widget.global ? false : null,
        includeProviderSpecificFields: widget.global ? false : null,
        unsupportedTransportMessage: widget.global
            ? (type) => i18n.mcp.form.validation.unsupportedGlobal(type: type.wire)
            : null,
      );
      final error = await widget.onSubmit(payload);
      if (!mounted) return;
      if (error == null) {
        Navigator.of(context).pop(true);
        return;
      }
      setState(() => _submitError = error);
    } on McpPayloadException catch (e) {
      setState(() => _submitError = e.message);
    } on FormatException catch (e) {
      setState(() => _submitError = e.message);
    } on Object catch (e) {
      // Web `getErrorMessage` parity — any submit failure lands in the form.
      setState(() => _submitError = '$e');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final formT = t.settings.mcpForm;
    final providerName = mcpProviderName(widget.provider);
    final modalTitle = widget.title ?? (_isEditing ? formT.title.edit : formT.title.add);
    final submitLabel = widget.submitLabel ?? t.mcp.form.submitTo(provider: providerName);

    return Dialog(
      backgroundColor: c.background,
      shape: RoundedRectangleBorder(borderRadius: AppRadii.borderLg),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: MediaQuery.sizeOf(context).height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header — title + close (DialogTitle + X button parity).
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: c.border)),
              ),
              child: Row(
                children: [
                  Expanded(child: Text(modalTitle, style: tt.titleLarge)),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(LucideIcons.x, size: 16),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.description != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.sm,
                        ),
                        decoration: BoxDecoration(
                          color: c.muted.withValues(alpha: 0.4),
                          border: Border.all(color: c.border),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Text(
                          widget.description!,
                          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Import-mode toggle — hidden when editing (`!isEditing`).
                    if (!_isEditing) ...[
                      SegmentedButton<McpImportMode>(
                        segments: [
                          ButtonSegment(
                            value: McpImportMode.form,
                            label: Text(formT.importMode.form),
                          ),
                          ButtonSegment(
                            value: McpImportMode.json,
                            label: Text(formT.importMode.json),
                          ),
                        ],
                        selected: {_importMode},
                        onSelectionChanged: (s) => setState(() => _importMode = s.first),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // Scope — read-only summary when editing, picker when
                    // adding (grid of scope buttons in the web).
                    if (_isEditing) ...[
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: c.muted.withValues(alpha: 0.3),
                          border: Border.all(color: c.border),
                          borderRadius: AppRadii.borderLg,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formT.scope.label,
                              style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              children: [
                                Icon(
                                  _scope == McpScope.user
                                      ? LucideIcons.globe
                                      : LucideIcons.folderOpen,
                                  size: 16,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Flexible(child: Text(_scopeLabel(_scope), style: tt.bodyMedium)),
                                if (_workspacePath.isNotEmpty)
                                  Flexible(
                                    child: Text(
                                      ' - $_workspacePath',
                                      overflow: TextOverflow.ellipsis,
                                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              formT.scope.cannotChange,
                              style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ] else ...[
                      _FieldLabel('${formT.scope.label} *'),
                      SegmentedButton<McpScope>(
                        segments: [
                          for (final scope in _scopes)
                            ButtonSegment(
                              value: scope,
                              icon: Icon(
                                scope == McpScope.user ? LucideIcons.globe : LucideIcons.folderOpen,
                                size: 16,
                              ),
                              label: Text(_scopeLabel(scope)),
                            ),
                        ],
                        selected: {_scope},
                        onSelectionChanged: (s) => setState(() {
                          _scope = s.first;
                          if (_scope == McpScope.user) _workspacePath = '';
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          _scopeDescription,
                          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Project selector — required for project/local scopes.
                      if (_scope != McpScope.user) ...[
                        _FieldLabel('${formT.fields.selectProject} *'),
                        _projectDropdown(),
                        if (_workspacePath.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              formT.projectPath(path: _workspacePath),
                              overflow: TextOverflow.ellipsis,
                              style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                            ),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ],

                    // Name + transport.
                    _FieldLabel('${formT.fields.serverName} *'),
                    AppInput(controller: _name, hint: formT.placeholders.serverName),
                    const SizedBox(height: AppSpacing.lg),
                    if (_importMode == McpImportMode.form) ...[
                      _FieldLabel('${formT.fields.transportType} *'),
                      DropdownButtonFormField<McpTransport>(
                        initialValue: _transport,
                        decoration: const InputDecoration(),
                        items: [
                          for (final tr in _transports)
                            DropdownMenuItem(value: tr, child: Text(tr.label)),
                        ],
                        onChanged: (v) => setState(() => _transport = v ?? _transports.first),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    // JSON import field.
                    if (_importMode == McpImportMode.json) ...[
                      _FieldLabel('${formT.fields.jsonConfig} *'),
                      TextField(
                        controller: _jsonInput,
                        maxLines: 8,
                        style: const TextStyle(fontFamily: 'monospace', fontSize: 13),
                        decoration: InputDecoration(
                          hintText:
                              '{\n  "type": "stdio",\n  "command": "npx",\n'
                              '  "args": ["@upstash/context7-mcp"]\n}',
                          errorText: _jsonError.isEmpty ? null : _jsonError,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Text(
                          '${formT.validation.jsonHelp}\n'
                          '${formT.validation.jsonExampleStdio}\n'
                          '${formT.validation.jsonExampleHttp}',
                          style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                    ],

                    // stdio fields.
                    if (_importMode == McpImportMode.form && _transport == McpTransport.stdio) ...[
                      _FieldLabel('${formT.fields.command} *'),
                      AppInput(controller: _command, hint: 'npx @my-org/mcp-server'),
                      const SizedBox(height: AppSpacing.lg),
                      _FieldLabel(formT.fields.arguments),
                      AppInput(controller: _args, maxLines: 3, hint: '--port\n3000'),
                      if (_supportsWorkingDirectory) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _FieldLabel(t.mcp.form.fields.workingDirectory),
                        AppInput(controller: _cwd, hint: '.'),
                      ],
                    ],

                    // http/sse fields.
                    if (_importMode == McpImportMode.form && _transport != McpTransport.stdio) ...[
                      _FieldLabel('${formT.fields.url} *'),
                      AppInput(
                        controller: _url,
                        hint: 'https://api.example.com/mcp',
                        keyboardType: TextInputType.url,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                    ],

                    if (_importMode == McpImportMode.form) ...[
                      _FieldLabel(formT.fields.envVars),
                      AppInput(controller: _env, maxLines: 3, hint: 'API_KEY=your-key\nDEBUG=true'),
                      if (_supportsHttpHeaders) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _FieldLabel(formT.fields.headers),
                        AppInput(
                          controller: _headers,
                          maxLines: 3,
                          hint:
                              'Authorization=Bearer token\n'
                              'X-API-Key=your-key',
                        ),
                      ],
                    ],

                    // Codex-only fields (`showCodexOnlyFields`).
                    if (_showCodexFields &&
                        _importMode == McpImportMode.form &&
                        _transport == McpTransport.stdio) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _FieldLabel(t.mcp.form.fields.envVarNames),
                      AppInput(controller: _envVars, maxLines: 3, hint: 'GITHUB_TOKEN\nAPI_KEY'),
                    ],
                    if (_showCodexFields &&
                        _importMode == McpImportMode.form &&
                        _transport == McpTransport.http) ...[
                      const SizedBox(height: AppSpacing.lg),
                      _FieldLabel(t.mcp.form.fields.bearerTokenEnvVar),
                      AppInput(controller: _bearerTokenEnvVar, hint: 'MCP_TOKEN'),
                    ],

                    if (_submitError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.lg),
                        child: Text(
                          _submitError!,
                          style: tt.bodySmall?.copyWith(color: c.destructive),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Footer — cancel + submit.
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    variant: AppButtonVariant.outline,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text(formT.actions.cancel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    onPressed: _canSubmit && !_submitting ? () => _submit() : null,
                    loading: _submitting,
                    child: Text(
                      _submitting
                          ? formT.actions.saving
                          : _isEditing
                          ? formT.actions.updateServer
                          : submitLabel,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Project dropdown — values are workspace paths (`fullPath || path`),
  /// labels fall back to projectId like the web `projectOptions`.
  Widget _projectDropdown() {
    final t = Translations.of(context);
    final projects = ref.watch(projectsProvider).projects;
    final options = <({String value, String label})>[];
    final seen = <String>{};
    for (final p in projects) {
      final path = (p.fullPath?.isNotEmpty ?? false) ? p.fullPath! : p.path;
      if (path.isEmpty || !seen.add(path)) continue;
      options.add((value: path, label: p.displayName.isNotEmpty ? p.displayName : p.projectId));
    }
    return DropdownButtonFormField<String>(
      initialValue: _workspacePath.isEmpty ? '' : _workspacePath,
      decoration: const InputDecoration(),
      items: [
        DropdownMenuItem(value: '', child: Text(t.settings.mcpForm.fields.selectProject)),
        for (final o in options)
          DropdownMenuItem(
            value: o.value,
            child: Text(o.label, overflow: TextOverflow.ellipsis),
          ),
        // Editing a server whose project no longer exists must still render.
        if (_workspacePath.isNotEmpty && !options.any((o) => o.value == _workspacePath))
          DropdownMenuItem(
            value: _workspacePath,
            child: Text(_workspacePath, overflow: TextOverflow.ellipsis),
          ),
      ],
      onChanged: (v) => setState(() => _workspacePath = v ?? ''),
    );
  }
}

/// Field label — `mb-2 text-sm font-medium` in the web modal.
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }
}

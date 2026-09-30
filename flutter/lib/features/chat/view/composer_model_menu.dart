import 'dart:async';
import 'dart:math' as math;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/chat/state/composer_controller.dart';
import 'package:ddagent_app/features/chat/view/model_library_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

const _defaultEffort = 'default';
const _emerald = Color(0xFF10B981);
const _amber = Color(0xFFFBBF24);

/// `getModelTier` — antigravity and explicit `paid` are paid, `free` tier
/// or a `\bfree\b` description is free, everything else paid. Shared with
/// the `/models` command-result dialog.
String modelTierOf(Map<String, dynamic> m) {
  final id = '${m['id'] ?? m['value']}';
  final label = '${m['label'] ?? m['name'] ?? id}';
  final hay = '$id $label ${m['description'] ?? ''}'.toLowerCase();
  if (hay.contains('antigravity')) return 'paid';
  final tier = '${m['tier'] ?? ''}';
  if (tier == 'paid') return 'paid';
  if (tier == 'free') return 'free';
  return RegExp(r'\bfree\b', caseSensitive: false).hasMatch('${m['description'] ?? ''}')
      ? 'free'
      : 'paid';
}

/// Port of `ComposerModelMenu.tsx`: a model/reasoning chip that opens a
/// custom popover anchored above the composer — Reasoning rows first, a
/// Favorites block, then a collapsible Model section with the
/// All/Free/Paid pills and a search field. The web menu lives in a portal,
/// so interactions inside (star toggles, filter pills, the search box) never
/// dismiss it; the Flutter `PopupMenuButton` it replaces closed on any tap.
class ComposerModelMenu extends ConsumerStatefulWidget {
  const ComposerModelMenu({
    required this.arg,
    required this.state,
    required this.promptBoxKey,
    this.compact = false,
    super.key,
  });

  final ComposerArg arg;
  final ComposerState state;

  /// Key on the `data-slot="prompt-input"` container — the web anchors the
  /// menu's bottom edge 8px above the composer box, not the trigger.
  final GlobalKey promptBoxKey;

  /// Coarse-pointer layout: taller trigger + 44px menu rows.
  final bool compact;

  @override
  ConsumerState<ComposerModelMenu> createState() => _ComposerModelMenuState();
}

class _ComposerModelMenuState extends ConsumerState<ComposerModelMenu> {
  OverlayEntry? _entry;
  final _search = TextEditingController();
  final _searchFocus = FocusNode();
  // Menu-internal rebuilds go through this notifier — bumping it re-runs the
  // overlay's ListenableBuilder without reopening the entry.
  final _menuTick = ValueNotifier<int>(0);
  bool _modelSectionOpen = false;
  String _tier = 'all';
  bool _catalogRefreshed = false;

  ComposerState get _state => widget.state;

  /* ── option plumbing (mirrors useFavoriteModels/getModelTier) ── */

  String _id(Map<String, dynamic> m) => '${m['id'] ?? m['value']}';

  String _label(Map<String, dynamic> m) => '${m['label'] ?? m['name'] ?? _id(m)}';

  /// `getModelTier` — see the top-level [modelTierOf].
  String _tierOf(Map<String, dynamic> m) => modelTierOf(m);

  /// Catalog merged with favorites that no longer ship in it (web
  /// `mergedOptions` — favorites persist richer records, Flutter only keeps
  /// ids, so a missing favorite falls back to label = id).
  List<Map<String, dynamic>> _mergedOptions(ComposerState s) {
    final map = <String, Map<String, dynamic>>{for (final m in s.models) _id(m): m};
    for (final id in s.favorites) {
      map.putIfAbsent(id, () => {'value': id, 'label': id});
    }
    return map.values.toList();
  }

  Map<String, dynamic>? _activeOption(ComposerState s) {
    for (final m in _mergedOptions(s)) {
      if (_id(m) == s.activeModel) return m;
    }
    return null;
  }

  String _effortLabel() {
    final effort = _state.effort ?? _defaultEffort;
    return effort == _defaultEffort ? 'Default' : _cap(effort);
  }

  static String _cap(String s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

  /// `formatContextWindow` — 1.1M / 262k / raw below 1k.
  static String? _contextText(Map<String, dynamic> m) {
    final ctx = m['context'];
    if (ctx is! num || ctx <= 0) return null;
    if (ctx >= 1000000) {
      final millions = (ctx / 100000).round() / 10;
      return '${millions % 1 == 0 ? millions.round() : millions}M';
    }
    if (ctx >= 1000) return '${(ctx / 1000).round()}k';
    return '${ctx.round()}';
  }

  /// `matchesModelSearch` — every whitespace token must appear in the
  /// lowercased `label value description` haystack.
  bool _matchesSearch(Map<String, dynamic> m, String query) {
    final hay = '${_label(m)} ${_id(m)} ${m['description'] ?? ''}'.toLowerCase();
    return query.toLowerCase().split(RegExp(r'\s+')).where((t) => t.isNotEmpty).every(hay.contains);
  }

  /// `visibleOptions` — the tier filter only. `hasModelSection` derives from
  /// it, so search matches never collapse the section itself.
  List<Map<String, dynamic>> _visibleOptions(ComposerState s) => [
    for (final m in _mergedOptions(s))
      if (_tier == 'all' || _tierOf(m) == _tier) m,
  ];

  /// `filteredOptions` — `visibleOptions` narrowed by the search tokens.
  List<Map<String, dynamic>> _filteredOptions(ComposerState s, List<Map<String, dynamic>> visible) {
    final query = _search.text.trim();
    return [
      for (final m in visible)
        if (query.isEmpty || _matchesSearch(m, query)) m,
    ];
  }

  /* ── overlay lifecycle ── */

  bool get _isOpen => _entry != null;

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    if (_isOpen) return;
    // The web collapses the model section and clears the search every open.
    _modelSectionOpen = false;
    _catalogRefreshed = false;
    _tier = 'all';
    _search.clear();
    _entry = composerMenuEntry(
      triggerContext: context,
      promptBoxKey: widget.promptBoxKey,
      onDismiss: _close,
      rebuildable: _menuTick,
      builder: (ctx) => Consumer(
        // A fresh Consumer inside the overlay keeps favorites and the
        // active model live without re-opening the menu.
        builder: (ctx, ref, _) {
          final state = ref.watch(composerProvider(widget.arg));
          final c = ctx.appColors;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _items(ctx, ref, state, c),
          );
        },
      ),
    );
    Overlay.of(context).insert(_entry!);
    HardwareKeyboard.instance.addHandler(_onKey);
    setState(() {});
  }

  void _close() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  bool _onKey(KeyEvent event) {
    if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
      _close();
      return true;
    }
    return false;
  }

  void _refreshMenu() => _menuTick.value++;

  @override
  void didUpdateWidget(covariant ComposerModelMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Bumping during didUpdateWidget would mark the overlay's
    // ListenableBuilder dirty mid-build (it isn't a descendant) — defer.
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _refreshMenu());
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _entry?.remove();
    _search.dispose();
    _searchFocus.dispose();
    _menuTick.dispose();
    super.dispose();
  }

  /* ── trigger chip (`.oc-model-trigger`) ── */

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final hasEffort = _state.effortValues(widget.arg.provider).isNotEmpty;
    final hasModel = _mergedOptions(_state).isNotEmpty;
    if (!hasEffort && !hasModel) return const SizedBox.shrink();

    final active = _activeOption(_state);
    final label = hasModel
        ? (active != null ? _label(active) : (_state.activeModel ?? 'Model'))
        : _effortLabel();
    final selectedFree = active != null && _tierOf(active) == 'free';
    final showEffort = hasModel && hasEffort && (_state.effort ?? _defaultEffort) != _defaultEffort;

    return Tooltip(
      // Web aria-label/title on `.oc-model-trigger`.
      message: 'Select model and reasoning effort',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          borderRadius: AppRadii.borderLg,
          hoverColor: c.muted,
          child: Container(
            height: widget.compact ? 44 : 32,
            constraints: BoxConstraints(maxWidth: widget.compact ? 144 : 224),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: c.muted.withValues(alpha: 0.4),
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      fontWeight: FontWeight.w500,
                      color: c.foreground,
                    ),
                  ),
                ),
                if (selectedFree) const _FreeBadge(),
                if (showEffort && !widget.compact)
                  Text(
                    '· ${_effortLabel()}',
                    maxLines: 1,
                    style: TextStyle(fontSize: 12, height: 16 / 12, color: c.mutedForeground),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /* ── popover (`ComposerMenuSurface`) ── */

  /* ── menu content ── */

  List<Widget> _items(BuildContext ctx, WidgetRef ref, ComposerState state, AppColors c) {
    final notifier = ref.read(composerProvider(widget.arg).notifier);
    final rawEfforts = state.effortOptions(widget.arg.provider);
    // `resolvedEffortOptions` — the web prepends a synthetic Default row.
    final efforts = rawEfforts.isEmpty
        ? rawEfforts
        : [(value: _defaultEffort, description: null), ...rawEfforts];
    final visible = _visibleOptions(state);
    final options = _filteredOptions(state, visible);
    final hasEffort = efforts.isNotEmpty;
    // `hasModelSection` — the search never hides the section; the web also
    // shows it while the catalog is loading (no modelsLoading flag here).
    final hasModel = visible.isNotEmpty;
    final favoriteOptions = [
      for (final m in options)
        if (state.favorites.contains(_id(m))) m,
    ];
    final otherOptions = [
      for (final m in options)
        if (!state.favorites.contains(_id(m))) m,
    ];
    final effort = state.effort ?? _defaultEffort;

    return [
      if (hasEffort) ...[
        _heading(c, 'Reasoning'),
        for (final e in efforts)
          _item(
            c,
            label: e.value == _defaultEffort ? 'Default' : _cap(e.value),
            description: e.description,
            selected: effort == e.value,
            onTap: () {
              _close();
              notifier.selectEffort(e.value);
            },
          ),
      ],
      if (hasModel) ...[
        if (hasEffort) _separator(c),
        if (favoriteOptions.isNotEmpty) ...[
          _heading(c, 'Favorites'),
          for (final m in favoriteOptions) _modelRow(ctx, ref, state, c, m),
        ],
        // The collapsible row shows the active model's label, muted.
        _item(
          c,
          label: _activeOption(state) != null
              ? _label(_activeOption(state)!)
              : (state.activeModel ?? 'Model'),
          muted: true,
          trailing: Icon(
            _modelSectionOpen ? LucideIcons.chevronDown : LucideIcons.chevronRight,
            size: 14,
            color: c.mutedForeground,
          ),
          onTap: () {
            _modelSectionOpen = !_modelSectionOpen;
            _refreshMenu();
            // The web refreshes the provider catalog on the first expand.
            if (_modelSectionOpen && !_catalogRefreshed) {
              _catalogRefreshed = true;
              notifier.refreshModels();
            }
          },
        ),
        if (_modelSectionOpen) ...[
          Padding(padding: const EdgeInsets.fromLTRB(10, 4, 10, 6), child: _pillBar(c)),
          Padding(padding: const EdgeInsets.fromLTRB(10, 0, 10, 6), child: _searchField(c)),
          _heading(c, 'Model'),
          if (options.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Text(
                'No models found.',
                style: TextStyle(fontSize: 14, height: 20 / 14, color: c.mutedForeground),
              ),
            ),
          for (final m in otherOptions) _modelRow(ctx, ref, state, c, m),
          // `ModelLibraryPanel` entry — custom-model CRUD per provider (the
          // web exposes it via the /models modal's "Manage models" button).
          _separator(c),
          _item(
            c,
            label: 'Manage models',
            muted: true,
            trailing: Icon(LucideIcons.settings2, size: 14, color: c.mutedForeground),
            onTap: () {
              _close();
              unawaited(
                showModelLibraryDialog(
                  ctx,
                  initialProvider: widget.arg.provider,
                  onChanged: () => ref.read(composerProvider(widget.arg).notifier).refreshModels(),
                ),
              );
            },
          ),
        ],
      ],
    ];
  }

  Widget _modelRow(
    BuildContext ctx,
    WidgetRef ref,
    ComposerState state,
    AppColors c,
    Map<String, dynamic> m,
  ) {
    final id = _id(m);
    final favorited = state.favorites.contains(id);
    final selected = id == state.activeModel;
    final free = _tierOf(m) == 'free';
    final contextText = _contextText(m);
    final description = free
        ? (contextText != null ? '$contextText context' : null)
        : [
            m['description']?.toString(),
            if (contextText != null) '$contextText context',
          ].whereType<String>().where((s) => s.isNotEmpty).join(' · ');
    return _item(
      c,
      label: _label(m),
      description: description?.isEmpty ?? true ? null : description,
      selected: selected,
      onTap: () {
        _close();
        ref.read(composerProvider(widget.arg).notifier).selectModel(id);
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => ref.read(composerProvider(widget.arg).notifier).toggleFavorite(id),
            child: SizedBox(
              width: widget.compact ? 44 : 18,
              height: widget.compact ? 44 : 18,
              child: Center(
                // Lucide's outline star can't fill; the Material star matches
                // the web's `fill-amber-400` Lucide glyph closely enough.
                child: Icon(
                  favorited ? Icons.star : LucideIcons.star,
                  size: 14,
                  color: favorited ? _amber : c.mutedForeground,
                ),
              ),
            ),
          ),
          if (free) const _FreeBadge(),
          if (selected) Icon(Icons.check, size: 14, color: c.foreground),
        ],
      ),
    );
  }

  /* ── shared primitives (`ComposerMenuPrimitives`) ── */

  Widget _heading(AppColors c, String text) => ComposerMenuHeading(colors: c, child: Text(text));

  Widget _separator(AppColors c) => const ComposerMenuSeparator();

  Widget _item(
    AppColors c, {
    required String label,
    String? description,
    bool selected = false,
    bool muted = false,
    Widget? trailing,
    VoidCallback? onTap,
  }) => ComposerMenuItem(
    colors: c,
    label: label,
    description: description,
    selected: selected,
    muted: muted,
    compact: widget.compact,
    trailing: trailing,
    onTap: onTap,
  );

  /// `PillBar`/`Pill` — All/Free/Paid segmented filter.
  Widget _pillBar(AppColors c) {
    Widget pill(String tier, String label) {
      final active = _tier == tier;
      return GestureDetector(
        onTap: () {
          _tier = tier;
          _refreshMenu();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: active ? c.background : Colors.transparent,
            borderRadius: AppRadii.borderMd,
            border: active ? Border.all(color: c.border.withValues(alpha: 0.5)) : null,
            boxShadow: active
                ? const [BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1))]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w500,
              color: active ? c.foreground : c.mutedForeground,
            ),
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: c.muted.withValues(alpha: 0.6),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [pill('all', 'All'), pill('free', 'Free'), pill('paid', 'Paid')],
        ),
      ),
    );
  }

  /// `Search models...` field — h-8, border/60, muted/40, focus ring.
  Widget _searchField(AppColors c) {
    final focused = _searchFocus.hasFocus;
    return Container(
      height: 32,
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(color: focused ? c.ring : Colors.transparent),
        borderRadius: const BorderRadius.all(Radius.circular(9)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: c.muted.withValues(alpha: 0.4),
          border: Border.all(color: c.border.withValues(alpha: 0.6)),
          borderRadius: AppRadii.borderLg,
        ),
        child: Row(
          spacing: 6,
          children: [
            Icon(LucideIcons.search, size: 14, color: c.mutedForeground),
            Expanded(
              child: TextField(
                controller: _search,
                focusNode: _searchFocus,
                style: TextStyle(fontSize: 12, height: 16 / 12, color: c.foreground),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: 'Search models...',
                  hintStyle: TextStyle(color: c.mutedForeground),
                ),
                onChanged: (_) => _refreshMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ── shared composer-menu primitives (port of `ComposerMenuPrimitives.tsx`)
   ── used by the model menu and the permission menu ── */

/// `useComposerMenuAnchor` — fixed `right`/`bottom` from the trigger and the
/// `[data-slot="prompt-input"]` composer box, so the popover grows upward
/// without measuring first.
(double right, double bottom, double maxHeight, double maxWidth) composerMenuAnchor(
  BuildContext triggerContext,
  GlobalKey promptBoxKey,
  Size screen, {
  double preferredWidth = 320,
}) {
  const margin = 8.0;
  const gap = 8.0;
  final box = triggerContext.findRenderObject()! as RenderBox;
  final rect = box.localToGlobal(Offset.zero) & box.size;
  final composer = promptBoxKey.currentContext?.findRenderObject() as RenderBox?;
  final composerOffset = composer?.localToGlobal(Offset.zero) ?? Offset.zero;
  final right = math.max(margin, screen.width - rect.right);
  final bottom = screen.height - composerOffset.dy + gap;
  final maxHeight = math.max(160.0, composerOffset.dy - gap - margin);
  final maxWidth = math.max(
    200.0,
    math.min(
      preferredWidth,
      math.min(screen.width - right - margin, rect.right - composerOffset.dx - margin),
    ),
  );
  return (right, bottom, maxHeight, maxWidth);
}

/// Builds a composer popover `OverlayEntry`: full-screen dismiss barrier
/// plus the anchored `ComposerMenuSurface`. Pass `rebuildable` (e.g. a
/// `ValueNotifier`) when the menu has internal state that must repaint
/// without re-opening — the model menu's search field and pills use it.
OverlayEntry composerMenuEntry({
  required BuildContext triggerContext,
  required GlobalKey promptBoxKey,
  required VoidCallback onDismiss,
  required WidgetBuilder builder,
  Listenable? rebuildable,
  double preferredWidth = 320,
}) {
  Widget build(BuildContext ctx) {
    final screen = MediaQuery.sizeOf(ctx);
    final (right, bottom, maxHeight, maxWidth) = composerMenuAnchor(
      triggerContext,
      promptBoxKey,
      screen,
      preferredWidth: preferredWidth,
    );
    return Stack(
      children: [
        // Tap-outside barrier — the web closes on pointerdown outside the
        // trigger/menu but lets the click reach what it hit (translucent
        // passes it through; the trigger's own toggle then closes too).
        Positioned.fill(
          child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: onDismiss),
        ),
        Positioned(
          right: right,
          bottom: bottom,
          child: ComposerMenuSurface(maxHeight: maxHeight, maxWidth: maxWidth, child: builder(ctx)),
        ),
      ],
    );
  }

  return OverlayEntry(
    builder: (ctx) => rebuildable == null
        ? build(ctx)
        : ListenableBuilder(listenable: rebuildable, builder: (c, _) => build(c)),
  );
}

/// `ComposerMenuSurface` — rounded-xl popover card: border, popover fill,
/// shadow-xl, scrollable, shrink-wraps its widest row (min-w-48).
class ComposerMenuSurface extends StatelessWidget {
  const ComposerMenuSurface({
    required this.maxHeight,
    required this.maxWidth,
    required this.child,
    super.key,
  });

  final double maxHeight;
  final double maxWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 192, maxWidth: maxWidth, maxHeight: maxHeight),
        child: Container(
          decoration: BoxDecoration(
            color: c.popover,
            border: Border.all(color: c.border),
            // rounded-xl
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            boxShadow: const [
              BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            // The web popover has no width — it shrink-wraps its widest row
            // (min-w-48, clamped by the anchor's maxWidth). IntrinsicWidth
            // wraps the scroll view so the menu sizes to its content.
            child: IntrinsicWidth(
              child: SingleChildScrollView(padding: const EdgeInsets.all(4), child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// `ComposerMenuHeading` — 11px muted label over a group of rows.
class ComposerMenuHeading extends StatelessWidget {
  const ComposerMenuHeading({required this.colors, required this.child, super.key});

  final AppColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
    child: DefaultTextStyle(
      style: TextStyle(
        fontSize: 11,
        height: 16 / 11,
        fontWeight: FontWeight.w500,
        color: colors.mutedForeground,
      ),
      child: child,
    ),
  );
}

/// `ComposerMenuSeparator` — my-1 h-px bg-border.
class ComposerMenuSeparator extends StatelessWidget {
  const ComposerMenuSeparator({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(vertical: 4),
    height: 1,
    color: context.appColors.border,
  );
}

/// `ComposerMenuItem` — rounded-lg row: optional leading icon, label +
/// optional 12px description column, trailing check/custom widget. 44px
/// minimum height on coarse pointers.
class ComposerMenuItem extends StatelessWidget {
  const ComposerMenuItem({
    required this.colors,
    required this.label,
    this.description,
    this.icon,
    this.labelColor,
    this.selected = false,
    this.muted = false,
    this.compact = false,
    this.trailing,
    this.onTap,
    super.key,
  });

  final AppColors colors;
  final String label;
  final String? description;

  /// Leading 16px icon slot (`icon` in `ComposerMenuItem`).
  final Widget? icon;

  /// Per-row label tint — the web colors permission-mode labels.
  final Color? labelColor;
  final bool selected;
  final bool muted;
  final bool compact;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadii.borderLg,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.borderLg,
        hoverColor: c.accent,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: compact ? 44 : 0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: SizedBox(width: 16, height: 16, child: icon),
                  ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 20 / 14,
                          color: muted
                              ? c.mutedForeground
                              : labelColor ??
                                    (selected
                                        ? c.popoverForeground
                                        : c.popoverForeground.withValues(alpha: 0.9)),
                        ),
                      ),
                      if (description != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          // The web description has no line clamp — it wraps
                          // to the popover width (which is also what sizes
                          // the shrink-wrap).
                          child: Text(
                            description!,
                            style: TextStyle(
                              fontSize: 12,
                              height: 16 / 12,
                              color: c.mutedForeground,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child:
                      trailing ??
                      (selected
                          ? Icon(Icons.check, size: 14, color: c.popoverForeground)
                          : const SizedBox(width: 4, height: 4)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `FreeBadge` — emerald pill used by the trigger and free model rows.
class _FreeBadge extends StatelessWidget {
  const _FreeBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _emerald.withValues(alpha: 0.15),
        border: Border.all(color: _emerald.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: const Text(
        'Free',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Color(0xFF047857), // emerald-700, theme-independent
        ),
      ),
    );
  }
}

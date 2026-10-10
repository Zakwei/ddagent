import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/chat/view/composer_model_menu.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Port of `ComposerPermissionMenu.tsx`: a 32×32 trigger carrying the active
/// mode's icon/tone that opens the same anchored popover as the model menu —
/// heading + mode rows with leading icon, colored label and description.
/// The web menu lives in a portal so it stays open on phones too; the
/// `PopupMenuButton` it replaces rendered a flat, description-less list.
class ComposerPermissionMenu extends StatefulWidget {
  const ComposerPermissionMenu({
    required this.mode,
    required this.modes,
    required this.providerLabel,
    required this.onSelect,
    this.autoContinue = false,
    this.onToggleAutoContinue,
    required this.promptBoxKey,
    this.compact = false,
    super.key,
  });

  final String mode;
  final List<String> modes;
  final String providerLabel;
  final ValueChanged<String> onSelect;

  /// Optional "Auto-continue" row below the mode list (web
  /// `onToggleAutoContinueTasks`) — rendered only when supplied.
  final bool autoContinue;
  final VoidCallback? onToggleAutoContinue;

  /// Key on the `data-slot="prompt-input"` container — shared anchor.
  final GlobalKey promptBoxKey;
  final bool compact;

  @override
  State<ComposerPermissionMenu> createState() => _ComposerPermissionMenuState();
}

class _ComposerPermissionMenuState extends State<ComposerPermissionMenu> {
  OverlayEntry? _entry;
  // Rebuilds the open entry when autoContinue flips (the web keeps the menu
  // open while toggling — the check appears in place).
  final _menuTick = ValueNotifier<int>(0);

  /// Known permission modes — the trigger stays neutral for anything else.
  static const _knownModes = {'default', 'auto', 'acceptEdits', 'bypassPermissions', 'plan'};

  // `permissionModes.modes.*` — localized via the `chat.codex` keys.
  static String? _label(Translations t, String mode) => switch (mode) {
    'default' => t.chat.codex.modes.kDefault,
    'auto' => t.chat.codex.modes.auto,
    'acceptEdits' => t.chat.codex.modes.acceptEdits,
    'bypassPermissions' => t.chat.codex.modes.bypassPermissions,
    'plan' => t.chat.codex.modes.plan,
    _ => null,
  };

  static String? _description(Translations t, String mode) => switch (mode) {
    'default' => t.chat.codex.descriptions.kDefault,
    'auto' => t.chat.codex.descriptions.auto,
    'acceptEdits' => t.chat.codex.descriptions.acceptEdits,
    'bypassPermissions' => t.chat.codex.descriptions.bypassPermissions,
    'plan' => t.chat.codex.descriptions.plan,
    _ => null,
  };

  /// MODE_APPEARANCE from ComposerPermissionMenu.tsx (icon + item text tone).
  /// The web pairs tones per brightness (`text-blue-700 dark:text-blue-300`),
  /// so [isDark] picks the matching stop instead of one mid constant.
  static (IconData, Color) _appearance(String mode, AppColors c, bool isDark) => switch (mode) {
    'auto' => (LucideIcons.bot, isDark ? const Color(0xFF93C5FD) : const Color(0xFF1D4ED8)),
    'acceptEdits' => (
      LucideIcons.smile,
      isDark ? const Color(0xFF86EFAC) : const Color(0xFF15803D),
    ),
    'bypassPermissions' => (
      LucideIcons.triangleAlert,
      isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
    ),
    'plan' => (LucideIcons.clipboardList, c.primary),
    'default' => (LucideIcons.hand, c.mutedForeground),
    _ => (LucideIcons.shieldQuestion, c.mutedForeground),
  };

  /* ── overlay lifecycle ── */

  bool get _isOpen => _entry != null;

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    if (_isOpen) return;
    _entry = composerMenuEntry(
      triggerContext: context,
      promptBoxKey: widget.promptBoxKey,
      onDismiss: _close,
      // 22rem, matching useComposerMenuAnchor(isOpen, close, 22 * 16).
      preferredWidth: 352,
      rebuildable: _menuTick,
      builder: _menuItems,
    );
    Overlay.of(context, rootOverlay: true).insert(_entry!);
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

  @override
  void didUpdateWidget(covariant ComposerPermissionMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _menuTick.value++);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    _entry?.remove();
    _menuTick.dispose();
    super.dispose();
  }

  /* ── menu content ── */

  Widget _menuItems(BuildContext ctx) {
    final c = ctx.appColors;
    final t = Translations.of(ctx);
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ComposerMenuHeading(
          colors: c,
          child: Text(t.chat.composer.permissionHeading(provider: widget.providerLabel)),
        ),
        for (final m in widget.modes)
          ComposerMenuItem(
            colors: c,
            label: _label(t, m) ?? m,
            description: _description(t, m),
            labelColor: _appearance(m, c, isDark).$2,
            icon: Icon(_appearance(m, c, isDark).$1, size: 14, color: _appearance(m, c, isDark).$2),
            selected: m == widget.mode,
            compact: widget.compact,
            onTap: () {
              _close();
              widget.onSelect(m);
            },
          ),
        if (widget.onToggleAutoContinue != null) ...[
          const ComposerMenuSeparator(),
          ComposerMenuItem(
            colors: c,
            label: t.chat.input.autoContinueTasks,
            description: t.chat.input.autoContinueTasksTooltip,
            icon: Icon(LucideIcons.listChecks, size: 14, color: c.popoverForeground),
            selected: widget.autoContinue,
            compact: widget.compact,
            // The web toggles in place — the menu stays open.
            onTap: widget.onToggleAutoContinue,
          ),
        ],
      ],
    );
  }

  /* ── trigger (`.oc-permission-trigger`) ── */

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (icon, tone) = _appearance(widget.mode, c, isDark);
    // The default mode's trigger is neutral (border-border/60 bg-muted/50);
    // colored modes tint border+fill with their tone instead.
    final neutral = widget.mode == 'default' || !_knownModes.contains(widget.mode);
    final size = widget.compact ? 44.0 : 32.0;
    return Tooltip(
      // Web title parity — localized; the Tab shortcut is web-only so the
      // Flutter string only mentions the click.
      message: Translations.of(context).chat.input.clickToChangeMode,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggle,
          borderRadius: AppRadii.borderLg,
          hoverColor: c.muted,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: neutral ? c.muted.withValues(alpha: 0.5) : tone.withValues(alpha: 0.08),
              border: Border.all(
                color: neutral ? c.border.withValues(alpha: 0.6) : tone.withValues(alpha: 0.4),
              ),
              borderRadius: AppRadii.borderLg,
            ),
            child: Icon(icon, size: 16, color: neutral ? c.mutedForeground : tone),
          ),
        ),
      ),
    );
  }
}

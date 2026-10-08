import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Port of `CommandMenu.tsx` — the `/` slash-command popover. The web renders
/// through a document portal anchored above the `[data-slot="prompt-input"]`
/// box (left edge aligned, width `min(440, tile)`, bottom 8px over the box,
/// mobile = full width minus 16px margins). Commands group by namespace with
/// labeled headers, per-namespace accent icon tiles, a selected-row primary
/// bar and an Enter-hint chip.
const _kMenuMaxHeight = 360.0;
const _kMenuMinHeight = 160.0;
const _kMenuEdgeGap = 16.0;

/// `(bottom, left, width, maxHeight)` for a popover that opens above the
/// composer box. `width` is null on compact screens (left/right insets used).
/// [widthCap]/[heightCap] bound the panel (440/360 for commands, the box
/// width/192 for mentions).
(double bottom, double? left, double? width, double maxHeight) commandMenuAnchor(
  GlobalKey promptBoxKey,
  Size screen, {
  double widthCap = 440,
  double heightCap = _kMenuMaxHeight,
  // Web mention dropdown keeps the composer's own width on mobile too —
  // only the command menu gets the 16px edge margins.
  bool compactMargins = true,
}) {
  final composer = promptBoxKey.currentContext?.findRenderObject() as RenderBox?;
  final rect = composer == null ? Rect.zero : composer.localToGlobal(Offset.zero) & composer.size;
  final bottom = screen.height - rect.top + 8;
  final available = rect.top - 8 - _kMenuEdgeGap;
  // Web floor: commands never dip below 160 even past the fold (`max(160,
  // available)`); the mention dropdown uses no floor beyond visibility.
  final maxHeight = math.min(
    heightCap,
    math.max(heightCap > 200 ? _kMenuMinHeight : 120.0, available),
  );
  if (screen.width < 640 && compactMargins) {
    return (bottom, _kMenuEdgeGap, null, maxHeight);
  }
  final width = math.min(widthCap, math.max(0.0, rect.width));
  final left = math.max(_kMenuEdgeGap, math.min(rect.left, screen.width - _kMenuEdgeGap - width));
  return (bottom, left, width, maxHeight);
}

/// Shared chrome of both composer popovers (`border bg-*-95` + blur + shadow
/// + rounded corners); the command menu is `rounded-lg`/popover, the mention
/// dropdown `rounded-xl`/card with hairline borders.
Widget _menuSurface({
  required BuildContext context,
  required double maxHeight,
  double? width,
  EdgeInsets padding = const EdgeInsets.all(6),
  double radius = 8,
  Color? color,
  double borderAlpha = 1,
  List<BoxShadow> shadow = const [
    BoxShadow(
      color: Color(0x61020617), // rgba(2,6,23,0.38)
      blurRadius: 60,
      offset: Offset(0, 24),
    ),
    BoxShadow(color: Color(0x1F94A3B8)), // rgba(148,163,184,0.12) ring
  ],
  required Widget child,
}) {
  final c = context.appColors;
  return Material(
    color: Colors.transparent,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          constraints: BoxConstraints(maxHeight: maxHeight),
          padding: padding,
          decoration: BoxDecoration(
            color: (color ?? c.popover).withValues(alpha: 0.95),
            border: Border.all(color: c.border.withValues(alpha: borderAlpha)),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: shadow,
          ),
          child: SingleChildScrollView(child: child),
        ),
      ),
    ),
  );
}

/// Overlay entry for a composer popover: dismiss barrier + `_menuSurface`
/// positioned by [commandMenuAnchor]. `mention` switches to the mention
/// dropdown chrome (`rounded-xl bg-card/95 border-border/50`, box width,
/// `max-h-48`).
OverlayEntry composerPopoverEntry({
  required BuildContext triggerContext,
  required GlobalKey promptBoxKey,
  required VoidCallback onDismiss,
  required Listenable rebuildable,
  required WidgetBuilder builder,
  bool mention = false,
}) => OverlayEntry(
  builder: (ctx) => ListenableBuilder(
    listenable: rebuildable,
    builder: (c, _) {
      final screen = MediaQuery.sizeOf(c);
      final (bottom, left, width, maxHeight) = commandMenuAnchor(
        promptBoxKey,
        screen,
        widthCap: mention ? double.infinity : 440,
        heightCap: mention ? 192 : _kMenuMaxHeight,
        compactMargins: !mention,
      );
      // The web portals keep the `.oc-chat` scope (`command-menu oc-chat`,
      // the mention dropdown sits inside the composer) — without re-parenting
      // the chat-pane theme the overlay would resolve the app's light tokens.
      return Theme(
        data: Theme.of(triggerContext),
        child: Stack(
          children: [
            Positioned.fill(
              // translucent, not opaque — the web closes on mousedown outside
              // but lets the click reach what it hit (e.g. refocus the input).
              child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: onDismiss),
            ),
            Positioned(
              left: left,
              right: width == null ? _kMenuEdgeGap : null,
              bottom: bottom,
              child: Builder(
                builder: (themed) => _menuSurface(
                  context: themed,
                  maxHeight: maxHeight,
                  width: width,
                  padding: mention ? EdgeInsets.zero : const EdgeInsets.all(6),
                  radius: mention ? 12 : 8,
                  color: mention ? themed.appColors.card : null,
                  borderAlpha: mention ? 0.5 : 1,
                  shadow: mention
                      ? const [
                          BoxShadow(
                            color: Color(0x1A000000), // shadow-lg
                            blurRadius: 15,
                            offset: Offset(0, 10),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Color(0x61020617),
                            blurRadius: 60,
                            offset: Offset(0, 24),
                          ),
                          BoxShadow(color: Color(0x1F94A3B8)),
                        ],
                  child: builder(themed),
                ),
              ),
            ),
          ],
        ),
      );
    },
  ),
);

/* ── namespaces ── */

String slashNamespace(Map<String, dynamic> c) => '${c['namespace'] ?? c['type'] ?? 'other'}';

String slashCommandKey(Map<String, dynamic> c) =>
    '${c['name']}::${slashNamespace(c)}::${c['path'] ?? ''}';

bool isSkillCommand(Map<String, dynamic> c) =>
    c['type'] == 'skill' || (c['metadata'] as Map?)?['type'] == 'skill';

String? _namespaceLabel(Translations t, String ns) => switch (ns) {
  'frequent' => t.chat.commandMenu.namespaces.frequent,
  'builtin' => t.chat.commandMenu.namespaces.builtin,
  'skill' => t.chat.commandMenu.namespaces.skill,
  'project' => t.chat.commandMenu.namespaces.project,
  'user' => t.chat.commandMenu.namespaces.user,
  'other' => t.chat.commandMenu.namespaces.other,
  _ => null,
};

IconData _namespaceIcon(String ns) => switch (ns) {
  'frequent' => LucideIcons.star,
  'builtin' => LucideIcons.terminal,
  'skill' => LucideIcons.sparkles,
  'project' => LucideIcons.folder,
  'user' => LucideIcons.user,
  _ => LucideIcons.messageSquare,
};

/// Tailwind accent triples (`border-200 bg-50 text-700` light /
/// `border-400/20 bg-400/10 text-200` dark) keyed by namespace.
(Color border, Color bg, Color text) _namespaceAccent(String ns, bool dark) => switch (ns) {
  'frequent' =>
    dark
        ? (
            const Color(0xFFFBBF24).withValues(alpha: 0.2),
            const Color(0xFFFBBF24).withValues(alpha: 0.1),
            const Color(0xFFFDE68A),
          )
        : (const Color(0xFFFDE68A), const Color(0xFFFFFBEB), const Color(0xFFB45309)),
  'builtin' =>
    dark
        ? (
            const Color(0xFF38BDF8).withValues(alpha: 0.2),
            const Color(0xFF38BDF8).withValues(alpha: 0.1),
            const Color(0xFFBAE6FD),
          )
        : (const Color(0xFFBAE6FD), const Color(0xFFF0F9FF), const Color(0xFF0369A1)),
  'skill' =>
    dark
        ? (
            const Color(0xFF34D399).withValues(alpha: 0.2),
            const Color(0xFF34D399).withValues(alpha: 0.1),
            const Color(0xFFA7F3D0),
          )
        : (const Color(0xFFA7F3D0), const Color(0xFFECFDF5), const Color(0xFF047857)),
  'project' =>
    dark
        ? (
            const Color(0xFF818CF8).withValues(alpha: 0.2),
            const Color(0xFF818CF8).withValues(alpha: 0.1),
            const Color(0xFFC7D2FE),
          )
        : (const Color(0xFFC7D2FE), const Color(0xFFEEF2FF), const Color(0xFF4338CA)),
  'user' =>
    dark
        ? (
            const Color(0xFFFB7185).withValues(alpha: 0.2),
            const Color(0xFFFB7185).withValues(alpha: 0.1),
            const Color(0xFFFECDD3),
          )
        : (const Color(0xFFFECDD3), const Color(0xFFFFF1F2), const Color(0xFFBE123C)),
  _ =>
    dark
        ? (
            const Color(0xFF6B7280).withValues(alpha: 0.2),
            const Color(0xFF6B7280).withValues(alpha: 0.1),
            const Color(0xFFE5E7EB),
          )
        : (const Color(0xFFE5E7EB), const Color(0xFFF9FAFB), const Color(0xFF4B5563)),
};

/* ── the list ── */

/// Grouped command rows — `commands` is the filtered list (indices refer to
/// it), `frequent` renders first and is deduplicated out of the other groups.
class SlashCommandList extends StatelessWidget {
  const SlashCommandList({
    required this.commands,
    required this.frequent,
    required this.selectedIndex,
    required this.selectedRowKey,
    this.onHover,
    this.onSelect,
    super.key,
  });

  final List<Map<String, dynamic>> commands;
  final List<Map<String, dynamic>> frequent;
  final int selectedIndex;

  /// Attached to the selected row so the owner can scroll it into view.
  final GlobalKey selectedRowKey;
  final ValueChanged<int>? onHover;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Translations.of(context);
    if (commands.isEmpty) {
      // `.command-menu-empty` — centered muted label, padding 20.
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            t.chat.commandMenu.empty,
            style: TextStyle(fontSize: 14, color: c.mutedForeground),
          ),
        ),
      );
    }

    // Frequent commands keep their index inside `commands` so selection and
    // keyboard navigation stay consistent with the web.
    final indexByKey = <String, int>{
      for (var i = 0; i < commands.length; i++) slashCommandKey(commands[i]): i,
    };
    final frequentKeys = frequent.map(slashCommandKey).toSet();
    final groups = <String, List<int>>{};
    void add(String ns, int i) => (groups[ns] ??= []).add(i);
    if (frequent.isNotEmpty) {
      for (final f in frequent) {
        final i = indexByKey[slashCommandKey(f)];
        if (i != null) add('frequent', i);
      }
    }
    for (var i = 0; i < commands.length; i++) {
      if (frequent.isNotEmpty && frequentKeys.contains(slashCommandKey(commands[i]))) {
        continue;
      }
      add(slashNamespace(commands[i]), i);
    }
    final order = [
      if (frequent.isNotEmpty) 'frequent',
      'builtin',
      'skill',
      'project',
      'user',
      'other',
      ...groups.keys.where(
        (ns) => !{'frequent', 'builtin', 'skill', 'project', 'user', 'other'}.contains(ns),
      ),
    ];
    final ordered = [
      for (final ns in order)
        if (groups[ns] != null) ns,
    ];
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final ns in ordered) ...[
          if (ordered.length > 1)
            Padding(
              // px-2 pb-1.5 pt-2, 10px semibold uppercase tracking-wide.
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      (_namespaceLabel(t, ns) ?? ns).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: c.mutedForeground,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: c.muted,
                      border: Border.all(color: c.border),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${groups[ns]!.length}',
                      style: TextStyle(fontSize: 10, height: 1, color: c.mutedForeground),
                    ),
                  ),
                ],
              ),
            ),
          for (final i in groups[ns]!)
            _SlashRow(
              key: i == selectedIndex ? selectedRowKey : null,
              command: commands[i],
              namespace: ns,
              accent: _namespaceAccent(ns, dark),
              selected: i == selectedIndex,
              onHover: onHover == null ? null : () => onHover!(i),
              onTap: onSelect == null ? null : () => onSelect!(i),
            ),
        ],
      ],
    );
  }
}

class _SlashRow extends StatelessWidget {
  const _SlashRow({
    required this.command,
    required this.namespace,
    required this.accent,
    required this.selected,
    this.onHover,
    this.onTap,
    super.key,
  });

  final Map<String, dynamic> command;
  final String namespace;
  final (Color, Color, Color) accent;
  final bool selected;
  final VoidCallback? onHover;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final (accentBorder, accentBg, accentText) = accent;
    final description = '${command['description'] ?? ''}';
    final badgeType = (command['metadata'] as Map?)?['type'];
    return Padding(
      // mb-1 between rows.
      padding: const EdgeInsets.only(bottom: 4),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              onTap: onTap,
              onHover: onHover == null
                  ? null
                  : (h) {
                      if (h) onHover!();
                    },
              borderRadius: BorderRadius.circular(6),
              hoverColor: selected ? null : c.accent,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? c.primary.withValues(alpha: 0.1) : null,
                  border: Border.all(
                    color: selected ? c.primary.withValues(alpha: 0.3) : Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: accentBg,
                        border: Border.all(color: accentBorder),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(_namespaceIcon(namespace), size: 14, color: accentText),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '${command['name']}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: c.foreground,
                                  ),
                                ),
                              ),
                              if (badgeType != null && '$badgeType'.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.muted,
                                    border: Border.all(color: c.border),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '$badgeType',
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 1,
                                      fontWeight: FontWeight.w500,
                                      color: c.mutedForeground,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                    if (selected)
                      Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: c.card,
                          border: Border.all(color: c.primary.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(LucideIcons.cornerDownLeft, size: 13, color: c.primary),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // The web draws a 2px primary bar 6px inside the selected row's
          // padding box (`left-1.5 top-1.5 bottom-1.5` — +1 for the border).
          if (selected)
            Positioned(
              left: 7,
              top: 7,
              bottom: 7,
              child: Container(
                width: 2,
                decoration: BoxDecoration(
                  color: c.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/* ── @-mentions (the dropdown inside ChatComposer) ── */

/// Port of the web mention rows: 28px icon tile, title, mono subtitle, the
/// uppercase type badge, 44px rows separated by hairline dividers.
class MentionMenuList extends StatelessWidget {
  const MentionMenuList({
    required this.items,
    required this.selectedIndex,
    required this.selectedRowKey,
    this.onHover,
    this.onSelect,
    super.key,
  });

  final List<Map<String, String>> items;
  final int selectedIndex;
  final GlobalKey selectedRowKey;
  final ValueChanged<int>? onHover;
  final ValueChanged<int>? onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Container(height: 1, color: c.border.withValues(alpha: 0.3)),
          _MentionRow(
            key: i == selectedIndex ? selectedRowKey : null,
            item: items[i],
            selected: i == selectedIndex,
            onHover: onHover == null ? null : () => onHover!(i),
            onTap: onSelect == null ? null : () => onSelect!(i),
          ),
        ],
      ],
    );
  }
}

class _MentionRow extends StatelessWidget {
  const _MentionRow({
    required this.item,
    required this.selected,
    this.onHover,
    this.onTap,
    super.key,
  });

  final Map<String, String> item;
  final bool selected;
  final VoidCallback? onHover;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final kind = item['kind'] ?? item['type'] ?? 'file';
    final (icon, iconColor) = switch (kind) {
      'session' => (LucideIcons.messageSquare, c.primary),
      'task' => (LucideIcons.listTodo, const Color(0xFFF59E0B)),
      _ => (LucideIcons.fileText, c.mutedForeground),
    };
    final subtitle = item['subtitle'] ?? '';
    final mention = Translations.of(context).chat.mentionMenu.kinds;
    final kindLabel = switch (kind) {
      'file' => mention.file,
      'session' => mention.session,
      'task' => mention.task,
      _ => kind,
    };
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onHover: onHover == null
            ? null
            : (h) {
                if (h) onHover!();
              },
        hoverColor: c.accent.withValues(alpha: 0.5),
        child: Container(
          constraints: const BoxConstraints(minHeight: 44),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: selected ? c.primary.withValues(alpha: 0.08) : null,
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.4),
                  border: Border.all(color: c.border.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['title'] ?? item['label'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 18 / 14,
                        color: selected ? c.primary : c.foreground,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: c.mutedForeground,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: c.muted.withValues(alpha: 0.5),
                  border: Border.all(color: c.border.withValues(alpha: 0.4)),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  kindLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    height: 1,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: c.mutedForeground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/view/provider_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shared dense-list widgets for the session picker and the /sessions page —
/// the Flutter port of the web SessionPicker.tsx row language (flat rows,
/// 28×28 provider badge, 12px titles, hover-revealed ⋯ menu).

/// Port of `formatPickerAge` (src/components/main-content/utils/sessionPicker.ts):
/// "<1m", "42m", "3hr", "2d".
String formatSessionAge(String? dateString, DateTime now) {
  if (dateString == null) return '';
  final date = DateTime.tryParse(dateString);
  if (date == null) return '';
  final minutes = now.difference(date).inMinutes;
  if (minutes < 1) return '<1m';
  if (minutes < 60) return '${minutes}m';
  final hours = minutes ~/ 60;
  return hours < 24 ? '${hours}hr' : '${hours ~/ 24}d';
}

/// "projectName or provider" — the row's second line
/// (React: `session.projectName` from the candidate list).
String sessionRowSubtitle(Session s) {
  final rawName = s.raw['projectDisplayName'] ?? s.raw['projectName'];
  if (rawName is String && rawName.isNotEmpty) return rawName;
  final path = s.projectPath;
  if (path != null && path.isNotEmpty) {
    final segs = path.split(RegExp(r'[\\/]'))..removeWhere((e) => e.isEmpty);
    if (segs.isNotEmpty) return segs.last;
  }
  return s.provider ?? '';
}

/// 28×28 rounded-md muted badge with the 16px provider logo (React
/// ProviderBadge — h-7 w-7 bg-muted/50, LLMProviderLogo h-4 w-4).
class SessionProviderBadge extends StatelessWidget {
  const SessionProviderBadge({super.key, this.provider});

  final String? provider;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.5),
        borderRadius: AppRadii.borderMd,
      ),
      alignment: Alignment.center,
      child: ProviderLogo(provider: provider, size: 16),
    );
  }
}

/// 'RECENT SESSIONS'-style heading: px-2 pt-1 pb-0.5, 10px w600 uppercase
/// muted-foreground/70 with tracking-wide.
class SessionListGroupHeading extends StatelessWidget {
  const SessionListGroupHeading(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.sm,
        top: AppSpacing.xs,
        bottom: 2,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: c.mutedForeground.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

/// The picker's h-8 search field: leading search icon (14px at left-8px),
/// transparent bg, `input` border, 12px text, clear-X on the right, Escape
/// clears the query first then falls through to [onEscape].
class SessionSearchField extends StatefulWidget {
  const SessionSearchField({
    super.key,
    this.autofocus = false,
    this.hint = 'Search sessions…',
    this.showSpinner = false,
    this.onChanged,
    this.onEscape,
  });

  final bool autofocus;
  final String hint;

  /// Shows a small spinner ahead of the clear button (full-text search busy).
  final bool showSpinner;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEscape;

  @override
  State<SessionSearchField> createState() => _SessionSearchFieldState();
}

class _SessionSearchFieldState extends State<SessionSearchField> {
  final _controller = TextEditingController();

  bool get _hasText => _controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_rebuild);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_rebuild)
      ..dispose();
    super.dispose();
  }

  void _rebuild() => setState(() {});

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape) {
      if (_hasText) {
        _clear();
      } else {
        widget.onEscape?.call();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return SizedBox(
      height: 32,
      child: Focus(
        onKeyEvent: _onKey,
        child: TextField(
          controller: _controller,
          autofocus: widget.autofocus,
          onChanged: widget.onChanged,
          style: TextStyle(fontSize: 12, color: c.foreground),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(fontSize: 12, color: c.mutedForeground),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 6),
              child: Icon(
                LucideIcons.search,
                size: 14,
                color: c.mutedForeground,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 28,
              maxHeight: 32,
            ),
            suffixIcon: _suffix(c),
            suffixIconConstraints: const BoxConstraints(maxHeight: 32),
          ),
        ),
      ),
    );
  }

  Widget? _suffix(AppColors c) {
    if (!widget.showSpinner && !_hasText) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSpinner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: SizedBox.square(
              dimension: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: c.mutedForeground,
              ),
            ),
          ),
        if (_hasText)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Tooltip(
              message: 'Clear search',
              child: InkWell(
                borderRadius: AppRadii.borderSm,
                hoverColor: c.muted,
                onTap: _clear,
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Icon(
                    LucideIcons.x,
                    size: 14,
                    color: c.mutedForeground,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// h-8 toolbar button in the picker's language: rounded-md border/60,
/// 14px icon + 11px label; [active] paints bg-primary/10 + primary text.
class SessionListToolbarButton extends StatefulWidget {
  const SessionListToolbarButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
    this.showLabel = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool active;
  final bool showLabel;

  @override
  State<SessionListToolbarButton> createState() =>
      _SessionListToolbarButtonState();
}

class _SessionListToolbarButtonState extends State<SessionListToolbarButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final fg = widget.active
        ? c.primary
        : (_hover ? c.foreground : c.mutedForeground);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadii.borderMd,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: AppRadii.borderMd,
          hoverColor: c.muted,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            decoration: BoxDecoration(
              color: widget.active
                  ? c.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: AppRadii.borderMd,
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(widget.icon, size: 14, color: fg),
                if (widget.showLabel) Text(widget.label, style: _style(fg)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _style(Color fg) =>
      TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: fg);
}

/// One flat session row (React `rowClass`): px-2 py-1.5 rounded-md,
/// hover:bg-accent — badge, title/subtitle, status dots, age, then a ⋯ menu
/// revealed on hover (React `sm:opacity-0 sm:group-hover:opacity-100`).
class SessionListRow extends StatefulWidget {
  const SessionListRow({
    super.key,
    required this.session,
    this.onTap,
    this.running = false,
    this.unread = false,
    this.subtitle,
    this.title,
    this.trailing = const [],
    this.menu,
    this.actions = const [],
  });

  final Session session;
  final VoidCallback? onTap;
  final bool running;
  final bool unread;

  /// Overrides the default "projectName or provider" line.
  final String? subtitle;

  /// Overrides `session.displayTitle` (archived rows carry `sessionTitle`).
  final String? title;

  /// Extra widgets after the age (e.g. a pin marker).
  final List<Widget> trailing;

  /// The ⋯ menu — hidden until hover, still tappable when invisible. Only
  /// rendered below the sm viewport width (React `sm:hidden`); wider panes
  /// get [actions] instead.
  final Widget? menu;

  /// Inline icon buttons revealed on hover at sm+ widths (React
  /// `hidden sm:flex sm:opacity-0 sm:group-hover:opacity-100`) — e.g. the
  /// picker's archive/delete pair.
  final List<Widget> actions;

  @override
  State<SessionListRow> createState() => _SessionListRowState();
}

class _SessionListRowState extends State<SessionListRow> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final s = widget.session;
    final subtitle = widget.subtitle ?? sessionRowSubtitle(s);
    final age = formatSessionAge(s.updatedAt, DateTime.now());
    final unread = widget.unread && !widget.running;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Row(
        spacing: 4,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                borderRadius: AppRadii.borderMd,
                hoverColor: c.accent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 6,
                  ),
                  child: Row(
                    spacing: AppSpacing.sm,
                    children: [
                      // React: `session.__provider ?? session.provider`.
                      SessionProviderBadge(
                        provider:
                            (s.raw['__provider'] as String?) ?? s.provider,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title ?? s.displayTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: c.foreground,
                              ),
                            ),
                            if (subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: c.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (widget.running) const _StatusDot(0xFF10B981),
                      if (unread) const _StatusDot(0xFF0EA5E9),
                      if (age.isNotEmpty)
                        Text(
                          age,
                          style: TextStyle(
                            fontSize: 10,
                            color: c.mutedForeground,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ...widget.trailing,
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (widget.menu != null || widget.actions.isNotEmpty)
            AnimatedOpacity(
              duration: AppMotion.base,
              opacity: _hover ? 1 : 0,
              // Tailwind sm: — narrow panes keep the ⋯ menu (touch target),
              // wider ones get the hover-revealed inline buttons.
              child: MediaQuery.sizeOf(context).width < 640
                  ? (widget.menu ?? const SizedBox.shrink())
                  : widget.actions.isNotEmpty
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 2,
                      children: widget.actions,
                    )
                  : (widget.menu ?? const SizedBox.shrink()),
            ),
        ],
      ),
    );
  }
}

/// 28×28 icon button for row actions (React rowActionButtonClass — muted,
/// hover bg-muted / hover red for destructive). Used as a hover-revealed
/// inline action at sm+ widths.
class SessionRowIconButton extends StatefulWidget {
  const SessionRowIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool danger;

  @override
  State<SessionRowIconButton> createState() => _SessionRowIconButtonState();
}

class _SessionRowIconButtonState extends State<SessionRowIconButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    const red = Color(0xFFDC2626); // red-600
    final fg = _hover
        ? (widget.danger ? red : c.foreground)
        : c.mutedForeground;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: widget.tooltip,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppRadii.borderMd,
            hoverColor: widget.danger
                ? const Color(0xFFEF4444).withValues(alpha: 0.1)
                : c.muted,
            child: SizedBox(
              width: 28,
              height: 28,
              child: Icon(widget.icon, size: 14, color: fg),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot(this.rgb);

  final int rgb;

  @override
  Widget build(BuildContext context) => Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(color: Color(rgb), shape: BoxShape.circle),
  );
}

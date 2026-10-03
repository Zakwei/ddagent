import 'dart:async';

import 'package:ddagent_app/core/realtime/realtime_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/sessions/state/session_activity.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// opencode TUI spinner frames, advanced every 80 ms (web `ActivityIndicator`).
const _spinnerFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
const _frameInterval = Duration(milliseconds: 80);

/// In-progress pill above the composer, in the spirit of the inline status lines
/// in Claude Code / Codex / OpenCode: a shimmering label, elapsed time and a
/// stop affordance. Port of `ActivityIndicator.tsx`; rendered only while the
/// viewed session is in the processing map, and only when no permission prompt
/// is waiting (a blocking question takes precedence).
class ActivityIndicator extends ConsumerStatefulWidget {
  const ActivityIndicator({required this.sessionId, super.key});

  final String sessionId;

  @override
  ConsumerState<ActivityIndicator> createState() => _ActivityIndicatorState();
}

class _ActivityIndicatorState extends ConsumerState<ActivityIndicator> {
  Timer? _frameTimer;
  Timer? _elapsedTimer;
  Timer? _exitTimer;
  var _frame = 0;
  var _elapsed = 0;

  /// Kept one exit-animation longer than the provider so the pill can fade out
  /// (web `EXIT_ANIMATION_MS = 220`).
  SessionActivity? _rendered;
  bool _hasPendingPermissions = false;

  @override
  void initState() {
    super.initState();
    // Tick only while the pill is on screen — an idle ActivityIndicator must
    // not repaint (or `pumpAndSettle` never settles in tests).
    _frameTimer = Timer.periodic(_frameInterval, (_) {
      if (mounted && _visible) {
        setState(() => _frame = (_frame + 1) % _spinnerFrames.length);
      }
    });
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _visible) _tickElapsed();
    });
  }

  bool get _visible => _rendered != null && !_hasPendingPermissions;

  void _tickElapsed() {
    final startedAt = _rendered?.startedAt;
    if (startedAt == null) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsed = (now - startedAt) ~/ 1000;
    setState(() => _elapsed = elapsed.clamp(0, 1 << 31));
  }

  @override
  void dispose() {
    _frameTimer?.cancel();
    _elapsedTimer?.cancel();
    _exitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activity = ref.watch(sessionActivityProvider.select((m) => m[widget.sessionId]));
    // A blocking permission question replaces the pill (web gates on
    // `!hasPendingPermissions`).
    _hasPendingPermissions = ref.watch(
      sessionPendingPermissionsProvider(widget.sessionId).select((list) => list.isNotEmpty),
    );

    if (activity != null && activity != _rendered) {
      _rendered = activity;
      _exitTimer?.cancel();
      _exitTimer = null;
      _tickElapsed();
    } else if (activity == null && _rendered != null && _exitTimer == null) {
      _exitTimer = Timer(const Duration(milliseconds: 220), () {
        if (mounted) setState(() => _rendered = null);
        _exitTimer = null;
      });
    }

    final shown = _rendered;
    if (shown == null || _hasPendingPermissions) return const SizedBox.shrink();

    final t = Translations.of(context);
    final cs = t.chat.claudeStatus;
    final actionWords = [
      cs.actions.thinking,
      cs.actions.processing,
      cs.actions.analyzing,
      cs.actions.working,
      cs.actions.computing,
      cs.actions.reasoning,
    ];
    // Label rotates every 4 s unless the server supplied a status line.
    final label = (shown.statusText ?? actionWords[(_elapsed ~/ 4) % actionWords.length])
        .replaceAll(RegExp(r'\.+$'), '');
    final minutes = _elapsed ~/ 60;
    final seconds = _elapsed % 60;
    final elapsedLabel = minutes < 1
        ? cs.elapsed.seconds(count: seconds)
        : cs.elapsed.minutesSeconds(minutes: minutes, seconds: seconds);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: _Pill(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _spinnerFrames[_frame],
                      style: TextStyle(color: context.appColors.mutedForeground, height: 1),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: _Shimmer(
                        child: Text(
                          '$label…',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      elapsedLabel,
                      style: TextStyle(
                        fontFeatures: const [FontFeature.tabularFigures()],
                        color: context.appColors.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (shown.canInterrupt)
              _Pill(
                onTap: () => ref.read(chatChannelProvider).abort(widget.sessionId),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stop, size: 10),
                    const SizedBox(width: 6),
                    Text(t.chat.claudeStatus.stop),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// `.chat-activity-tab` — rounded-top card tab, 8px h-8, subtle border.
class _Pill extends StatelessWidget {
  const _Pill({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return Material(
      color: c.card,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.border.withValues(alpha: 0.5)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: DefaultTextStyle.merge(
            style: TextStyle(fontSize: 12, color: c.foreground),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Shimmering activity label — a moving highlight over the text.
class _Shimmer extends StatefulWidget {
  const _Shimmer({required this.child});

  final Widget child;

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = context.appColors.foreground;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final v = _controller.value * 2 - 1; // -1..1 sweep
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment(v - 1, 0),
            end: Alignment(v + 1, 0),
            colors: [base.withValues(alpha: 0.55), base, base.withValues(alpha: 0.55)],
            stops: const [0.0, 0.5, 1.0],
          ).createShader(bounds),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

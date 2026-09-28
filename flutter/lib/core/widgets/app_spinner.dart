import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Spinner matching the CSS `spin` animation + shimmering skeleton block.
class AppSpinner extends StatelessWidget {
  const AppSpinner({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: context.appColors.primary,
      ),
    );
  }
}

/// Skeleton placeholder — shimmer uses a subtle muted sweep.
class AppSkeleton extends StatefulWidget {
  const AppSkeleton({super.key, this.width, this.height = 14});

  final double? width;
  final double height;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: AppRadii.borderSm,
            gradient: LinearGradient(
              begin: Alignment(-1 + _ctrl.value * 2, 0),
              end: Alignment(1 + _ctrl.value * 2, 0),
              colors: [c.muted, c.muted.withValues(alpha: 0.4), c.muted],
            ),
          ),
        );
      },
    );
  }
}

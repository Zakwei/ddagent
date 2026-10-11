import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:flutter/material.dart';

/// Startup screen: app name, a progress bar ([progress] null = indeterminate)
/// and what is happening right now — shown instead of a black window while
/// storage opens and the first route (possibly the local server) gets ready.
class BootScreen extends StatelessWidget {
  const BootScreen({super.key, this.message, this.progress});

  final String? message;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final c = context.appColors;
    return ColoredBox(
      color: t.scaffoldBackgroundColor,
      child: Center(
        child: SizedBox(
          width: 320,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DDAgent', style: t.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.lg),
              LinearProgressIndicator(value: progress, color: c.primary),
              const SizedBox(height: AppSpacing.md),
              Text(
                message ?? '',
                style: t.textTheme.bodySmall?.copyWith(color: c.mutedForeground),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// [BootScreen] as a standalone app — painted before storage and the real
/// app exist, so the window never shows black while they initialize.
class BootSplashApp extends StatelessWidget {
  const BootSplashApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    home: const Scaffold(body: BootScreen()),
  );
}

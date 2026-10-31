import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Shown for a location no route matches — go_router's default page is an
/// unstyled red `GoException` dump.
class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key, required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = context.appColors;
    final t = Translations.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.mapPinOff, size: 40, color: c.mutedForeground),
                const SizedBox(height: AppSpacing.md),
                Text(t.common.errors.notFoundTitle, style: theme.textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  t.common.errors.notFoundBody(path: path),
                  style: theme.textTheme.bodyMedium?.copyWith(color: c.mutedForeground),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  onPressed: () => context.go('/projects'),
                  child: Text(t.common.errors.goToProjects),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

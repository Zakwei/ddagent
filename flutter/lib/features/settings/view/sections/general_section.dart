import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_badge.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/features/auth/state/auth_controller.dart';
import 'package:ddagent_app/features/auth/view/auth_screens.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// General section — the web settings UI has no 'general' tab; this covers
/// the account/profile prefs surfaced by the `settings.account.*` strings:
/// signed-in user, role, connected server, sign-out.
class GeneralSection extends ConsumerWidget {
  const GeneralSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(authControllerProvider).user;
    final baseUrl = ref.watch(serverBaseUrlProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: t.settings.account.title,
          icon: LucideIcons.userRound,
          children: [
            AppCard(
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: c.muted,
                        child: Icon(
                          LucideIcons.userRound,
                          size: 18,
                          color: c.mutedForeground,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.username ?? '—',
                              style: tt.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if ((user?.role ?? '').isNotEmpty)
                              Text(
                                user!.role!,
                                style: tt.bodySmall?.copyWith(
                                  color: c.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if ((user?.role ?? '').isNotEmpty)
                        AppBadge(label: user!.role!),
                    ],
                  ),
                  Divider(height: AppSpacing.xl, color: c.border),
                  SettingsRow(
                    label: t.settings.account.username,
                    child: Text(user?.username ?? '—', style: tt.bodySmall),
                  ),
                  SettingsRow(
                    label: t.settings.server.title,
                    child: Text(
                      baseUrl.isEmpty ? '—' : baseUrl,
                      style: tt.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        SettingsSectionBlock(
          title: t.auth.logout.title,
          children: [
            AppCard(
              child: SettingsRow(
                label: t.auth.logout.button,
                child: const LogoutButton(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

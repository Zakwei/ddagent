import 'dart:async';

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_card.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/notifications/data/notifications_repository.dart';
import 'package:ddagent_app/features/notifications/state/device_notifications_controller.dart';
import 'package:ddagent_app/features/notifications/state/notification_preferences_controller.dart';
import 'package:ddagent_app/features/settings/data/settings_repository.dart';
import 'package:ddagent_app/features/settings/view/sections/settings_section_layout.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Notifications section — port of `NotificationsSettingsTab.tsx` +
/// `notifications/MessengerChannelsSection.tsx`: device push (native port of
/// the web-push card), sound toggle + test, Telegram/Discord messenger
/// channels, event-type checkboxes.
class NotificationsSection extends ConsumerWidget {
  const NotificationsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final notifications = t.settings.notifications;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        SettingsSectionBlock(
          title: notifications.title,
          icon: LucideIcons.bell,
          description: notifications.description,
          children: const [_DevicePushCard()],
        ),
        const SizedBox(height: AppSpacing.xl),
        const _SoundCard(),
        const SizedBox(height: AppSpacing.xl),
        const _MessengerChannelsCard(),
        const SizedBox(height: AppSpacing.xl),
        const _EventsCard(),
      ],
    );
  }
}

/// "Notify this device" card — the native stand-in for the web-push card:
/// browsers subscribe via the Push API; this app registers itself as a
/// `desktop` endpoint on the `/desktop-notifications` WS channel.
/// The "Send test notification" button hits `/api/settings/push/test` and
/// reproduces the web test-summary copy (no subscriptions / sent / failed).
class _DevicePushCard extends ConsumerStatefulWidget {
  const _DevicePushCard();

  @override
  ConsumerState<_DevicePushCard> createState() => _DevicePushCardState();
}

class _DevicePushCardState extends ConsumerState<_DevicePushCard> {
  bool _testing = false;
  String? _testResult;
  bool? _testOk;

  Future<void> _toggle(bool enabled) async {
    final ctrl = ref.read(deviceNotificationsProvider.notifier);
    final error = enabled ? await ctrl.disable() : await ctrl.enable();
    if (error != null && mounted) AppToast.error(context, error);
  }

  Future<void> _testPush() async {
    setState(() {
      _testing = true;
      _testResult = null;
    });
    try {
      final res = await ref.read(settingsRepositoryProvider).pushTest();
      if (!mounted) return;
      final t = Translations.of(context).settings.notifications.webPush;
      final count = (res['subscriptionCount'] as num?)?.toInt() ?? 0;
      final results = res['results'] as List? ?? const [];
      if (count == 0) {
        setState(() {
          _testOk = false;
          _testResult = t.testNoSubscription;
          _testing = false;
        });
        return;
      }
      final failed = [
        for (final r in results)
          if (r is Map && r['ok'] != true) r,
      ];
      setState(() {
        _testing = false;
        if (failed.isEmpty) {
          _testOk = true;
          _testResult = t.testSuccess(count: results.length);
        } else {
          _testOk = false;
          _testResult = failed
              .map((r) => '${r['endpointHost']}: ${r['statusCode'] ?? r['error'] ?? 'failed'}')
              .join(' · ');
        }
      });
    } on Object catch (e) {
      if (mounted) {
        setState(() {
          _testing = false;
          _testOk = false;
          _testResult = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.notifications;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final state = ref.watch(deviceNotificationsProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // Native build — "device" replaces the web "browser" wording.
            'Notify this device',
            style: tt.titleSmall,
          ),
          const SizedBox(height: AppSpacing.md),
          if (state.loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else ...[
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  variant: state.enabled ? AppButtonVariant.destructive : AppButtonVariant.primary,
                  size: AppButtonSize.sm,
                  loading: state.busy,
                  onPressed: () => unawaited(_toggle(state.enabled)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [
                      Icon(state.enabled ? LucideIcons.bellOff : LucideIcons.bellRing, size: 14),
                      Text(
                        state.busy
                            ? t.webPush.loading
                            : state.enabled
                            ? t.webPush.disable
                            : t.webPush.enable,
                      ),
                    ],
                  ),
                ),
                if (state.enabled)
                  Text(t.desktop.enabled, style: tt.bodySmall?.copyWith(color: Colors.green)),
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  loading: _testing,
                  onPressed: () => unawaited(_testPush()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [const Icon(LucideIcons.send, size: 14), Text(t.webPush.test)],
                  ),
                ),
              ],
            ),
            if (state.error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(state.error!, style: tt.bodySmall?.copyWith(color: c.destructive)),
            ],
            if (_testResult != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                _testResult!,
                style: tt.bodySmall?.copyWith(
                  color: _testOk == true ? Colors.green : c.destructive,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(t.webPush.iosHint, style: tt.labelSmall?.copyWith(color: c.mutedForeground)),
          ],
        ],
      ),
    );
  }
}

/// Sound card — `channels.sound` toggle + a test button. The web plays a
/// WebAudio tone; the platform alert sound is the native equivalent.
class _SoundCard extends ConsumerWidget {
  const _SoundCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).settings.notifications;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final prefs = ref.watch(notificationPreferencesProvider).prefs;

    Future<void> toggle(bool value) async {
      final error = await ref
          .read(notificationPreferencesProvider.notifier)
          .setChannel('sound', value);
      if (error != null && context.mounted) AppToast.error(context, error);
    }

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      spacing: AppSpacing.xs,
                      children: [
                        Icon(LucideIcons.volume2, size: 16, color: c.primary),
                        Text(t.sound.title, style: tt.titleSmall),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      t.sound.description,
                      style: tt.bodySmall?.copyWith(color: c.mutedForeground),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: AppSpacing.xs,
                children: [
                  Switch(value: prefs.sound, onChanged: (v) => unawaited(toggle(v))),
                  Text(t.sound.enabled, style: tt.bodyMedium),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            variant: AppButtonVariant.outline,
            size: AppButtonSize.sm,
            onPressed: () => unawaited(SystemSound.play(SystemSoundType.alert)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.xs,
              children: [const Icon(LucideIcons.play, size: 14), Text(t.sound.test)],
            ),
          ),
        ],
      ),
    );
  }
}

/// Telegram approvals + Discord notifications — port of
/// `MessengerChannelsSection.tsx`: bot-token/webhook save, test, chat
/// pair/unpair, per-channel enabled flags written into the shared prefs.
class _MessengerChannelsCard extends ConsumerStatefulWidget {
  const _MessengerChannelsCard();

  @override
  ConsumerState<_MessengerChannelsCard> createState() => _MessengerChannelsCardState();
}

class _MessengerChannelsCardState extends ConsumerState<_MessengerChannelsCard> {
  final _botToken = TextEditingController();
  final _webhookUrl = TextEditingController();
  Map<String, dynamic>? _config;
  List<Map<String, dynamic>> _detected = const [];
  List<Map<String, dynamic>> _paired = const [];
  String? _busy;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_refresh());
  }

  @override
  void dispose() {
    _botToken.dispose();
    _webhookUrl.dispose();
    super.dispose();
  }

  NotificationsRepository get _repo => ref.read(notificationsRepositoryProvider);

  bool _configured(String channel) => (_config?[channel] as Map?)?['configured'] == true;

  Future<void> _refresh() async {
    try {
      final results = await Future.wait<Object?>([_repo.channelsConfig(), _repo.telegramChats()]);
      if (!mounted) return;
      setState(() {
        _config = results[0] is Map<String, dynamic>
            ? (results[0] as Map<String, dynamic>)['config'] as Map<String, dynamic>?
            : null;
        final chats = results[1] as TelegramChats;
        _detected = chats.detected;
        _paired = chats.paired;
      });
    } on Object catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _run(String key, Future<dynamic> Function() call) async {
    setState(() {
      _busy = key;
      _error = null;
    });
    try {
      final res = await call();
      if (!mounted) return;
      final error = res is Map ? res['error'] : null;
      if (error != null) setState(() => _error = error.toString());
      await _refresh();
    } on Object catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _saveTelegram() =>
      _run('tg-save', () => _repo.saveChannelConfig('telegram', {'botToken': _botToken.text}));

  Future<void> _saveDiscord() =>
      _run('dc-save', () => _repo.saveChannelConfig('discord', {'webhookUrl': _webhookUrl.text}));

  Future<void> _pairChat(Map<String, dynamic> chat) => _run(
    'pair-${chat['chatId']}',
    () => _repo.addCurrentEndpoint({
      'channel': 'telegram',
      'endpointId': chat['chatId'],
      'label': chat['title'],
    }),
  );

  Future<void> _unpair(String endpointId) =>
      _run('unpair-$endpointId', () => _repo.deleteEndpoint('telegram', endpointId));

  Future<void> _toggleChannel(String channel, bool enabled) async {
    final error = await ref
        .read(notificationPreferencesProvider.notifier)
        .setChannel(channel, enabled);
    if (error != null && mounted) AppToast.error(context, error);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = Translations.of(context);
    final t = i18n.settings.notifications;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final prefs = ref.watch(notificationPreferencesProvider).prefs;
    final messaging = t.messaging;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: AppSpacing.xs,
            children: [
              Icon(LucideIcons.messageSquare, size: 16, color: c.primary),
              Text(messaging.title, style: tt.titleSmall),
            ],
          ),
          const SizedBox(height: 2),
          Text(messaging.description, style: tt.bodySmall?.copyWith(color: c.mutedForeground)),
          if (_error != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(_error!, style: tt.bodySmall?.copyWith(color: c.destructive)),
          ],
          const SizedBox(height: AppSpacing.md),
          // Telegram
          _ChannelBox(
            title: t.channels.telegram,
            configured: _configured('telegram'),
            enabled: prefs.telegram,
            onToggle: (v) => unawaited(_toggleChannel('telegram', v)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: AppSpacing.sm,
                  children: [
                    Expanded(
                      child: AppInput(
                        controller: _botToken,
                        hint: messaging.telegramToken,
                        obscureText: true,
                      ),
                    ),
                    AppButton(
                      variant: AppButtonVariant.outline,
                      size: AppButtonSize.sm,
                      loading: _busy == 'tg-save',
                      onPressed: _botToken.text.trim().isEmpty
                          ? null
                          : () => unawaited(_saveTelegram()),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: AppSpacing.xs,
                        children: [const Icon(LucideIcons.check, size: 14), Text(messaging.save)],
                      ),
                    ),
                  ],
                ),
                if (_configured('telegram')) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          messaging.telegramHint,
                          style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                        ),
                      ),
                      IconButton(
                        tooltip: i18n.common.buttons.refresh,
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(LucideIcons.refreshCw, size: 14),
                        onPressed: () => unawaited(_refresh()),
                      ),
                      AppButton(
                        variant: AppButtonVariant.outline,
                        size: AppButtonSize.sm,
                        loading: _busy == 'test-telegram',
                        onPressed: _paired.isEmpty
                            ? null
                            : () => unawaited(
                                _run('test-telegram', () => _repo.testChannel('telegram')),
                              ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          spacing: AppSpacing.xs,
                          children: [const Icon(LucideIcons.send, size: 14), Text(messaging.test)],
                        ),
                      ),
                    ],
                  ),
                  for (final chat in _paired)
                    _ChatRow(
                      key: ValueKey('paired-${chat['endpointId']}'),
                      title: (chat['label'] ?? chat['endpointId']).toString(),
                      subtitle: chat['endpointId'].toString(),
                      busy: _busy == 'unpair-${chat['endpointId']}',
                      paired: true,
                      onAction: () => _unpair(chat['endpointId'].toString()),
                    ),
                  for (final chat in _detected)
                    if (!_paired.any((p) => p['endpointId'] == chat['chatId']))
                      _ChatRow(
                        key: ValueKey('detected-${chat['chatId']}'),
                        title: (chat['title'] ?? '').toString(),
                        subtitle: chat['chatId'].toString(),
                        busy: _busy == 'pair-${chat['chatId']}',
                        paired: false,
                        pairLabel: messaging.pair,
                        onAction: () => unawaited(_pairChat(chat)),
                      ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Discord
          _ChannelBox(
            title: t.channels.discord,
            configured: _configured('discord'),
            enabled: prefs.discord,
            onToggle: (v) => unawaited(_toggleChannel('discord', v)),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Expanded(
                  child: AppInput(
                    controller: _webhookUrl,
                    hint: messaging.discordWebhook,
                    obscureText: true,
                  ),
                ),
                AppButton(
                  variant: AppButtonVariant.outline,
                  size: AppButtonSize.sm,
                  loading: _busy == 'dc-save',
                  onPressed: _webhookUrl.text.trim().isEmpty
                      ? null
                      : () => unawaited(_saveDiscord()),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSpacing.xs,
                    children: [const Icon(LucideIcons.check, size: 14), Text(messaging.save)],
                  ),
                ),
                if (_configured('discord'))
                  AppButton(
                    variant: AppButtonVariant.outline,
                    size: AppButtonSize.sm,
                    loading: _busy == 'test-discord',
                    onPressed: () =>
                        unawaited(_run('test-discord', () => _repo.testChannel('discord'))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [const Icon(LucideIcons.send, size: 14), Text(messaging.test)],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One messenger-channel sub-card (Telegram / Discord) — title + configured
/// check + enabled switch header, channel-specific body below.
class _ChannelBox extends StatelessWidget {
  const _ChannelBox({
    required this.title,
    required this.configured,
    required this.enabled,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final bool configured;
  final bool enabled;
  final ValueChanged<bool> onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.notifications;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        border: Border.all(color: c.border.withValues(alpha: 0.6)),
        borderRadius: AppRadii.borderMd,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  configured ? '$title ✓' : title,
                  style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Switch(value: enabled, onChanged: onToggle),
              Text(t.messaging.enabled, style: tt.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

/// Paired/detected chat row — paired rows get a delete (unpair) button,
/// detected-but-unpaired rows get a dashed border + "Pair" button.
class _ChatRow extends StatelessWidget {
  const _ChatRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.busy,
    required this.paired,
    required this.onAction,
    this.pairLabel,
  });

  final String title;
  final String subtitle;
  final bool busy;
  final bool paired;
  final VoidCallback onAction;
  final String? pairLabel;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context).settings.notifications;
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xs),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          border: Border.all(color: c.border.withValues(alpha: paired ? 0.6 : 1)),
          borderRadius: AppRadii.borderSm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: title,
                  style: tt.bodySmall?.copyWith(color: paired ? c.foreground : c.mutedForeground),
                  children: [
                    TextSpan(
                      text: '  $subtitle',
                      style: tt.labelSmall?.copyWith(color: c.mutedForeground),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (paired)
              IconButton(
                tooltip: t.unpair,
                visualDensity: VisualDensity.compact,
                icon: const Icon(LucideIcons.trash2, size: 14),
                onPressed: busy ? null : onAction,
              )
            else
              AppButton(
                variant: AppButtonVariant.outline,
                size: AppButtonSize.sm,
                loading: busy,
                onPressed: onAction,
                child: Text(pairLabel ?? 'Pair'),
              ),
          ],
        ),
      ),
    );
  }
}

/// Event-type checkboxes — `events.{actionRequired,stop,error}`.
class _EventsCard extends ConsumerWidget {
  const _EventsCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context).settings.notifications;
    final prefs = ref.watch(notificationPreferencesProvider).prefs;

    Future<void> toggle(String event, bool value) async {
      final error = await ref.read(notificationPreferencesProvider.notifier).setEvent(event, value);
      if (error != null && context.mounted) AppToast.error(context, error);
    }

    Widget row(String label, bool value, String event) => InkWell(
      borderRadius: AppRadii.borderSm,
      onTap: () => unawaited(toggle(event, !value)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(value: value, onChanged: (v) => unawaited(toggle(event, v ?? false))),
            ),
            Text(label),
          ],
        ),
      ),
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.events.title, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
          row(t.events.actionRequired, prefs.actionRequired, 'actionRequired'),
          row(t.events.stop, prefs.stop, 'stop'),
          row(t.events.error, prefs.error, 'error'),
        ],
      ),
    );
  }
}

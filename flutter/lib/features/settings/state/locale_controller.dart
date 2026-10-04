import 'dart:async';
import 'dart:ui';

import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Active locale — persisted in the shared `settings` Hive box
/// (`key: locale`, e.g. `en`, `zh-CN`). Default = device locale, en fallback.
class LocaleController extends Notifier<AppLocale> {
  static const _boxName = 'settings';
  static const _key = 'locale';

  @override
  AppLocale build() {
    final stored = Hive.isBoxOpen(_boxName)
        ? Hive.box<dynamic>(_boxName).get(_key) as String?
        : null;
    final initial = stored != null
        ? AppLocaleUtils.parse(stored)
        : AppLocaleUtils.parseLocaleParts(
            // PlatformDispatcher (not WidgetsBinding) so this provider works in
            // headless contexts — unit tests, server-side sends — where no
            // Flutter binding is initialized.
            languageCode: PlatformDispatcher.instance.locale.languageCode,
            countryCode: PlatformDispatcher.instance.locale.countryCode,
          );
    unawaited(LocaleSettings.setLocale(initial));
    return initial;
  }

  Future<void> set(AppLocale locale) async {
    state = locale;
    unawaited(LocaleSettings.setLocale(locale));
    await Hive.box<dynamic>(_boxName).put(_key, locale.languageTag);
  }
}

final localeProvider = NotifierProvider<LocaleController, AppLocale>(LocaleController.new);

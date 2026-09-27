import 'package:ddagent_app/features/settings/state/locale_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Language names — ported from src/i18n/languages.js.
const _languageNames = {
  'en': 'English',
  'pl': 'Polski',
  'fr': 'Français',
  'es': 'Español',
  'de': 'Deutsch',
  'it': 'Italiano',
  'ja': '日本語',
  'ko': '한국어',
  'ru': 'Русский',
  'tr': 'Türkçe',
  'zh-CN': '简体中文',
  'zh-TW': '繁體中文',
};

/// Settings row: language dropdown, live-switches the app locale.
class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(localeProvider);
    return DropdownButton<AppLocale>(
      value: current,
      underline: const SizedBox.shrink(),
      items: [
        for (final locale in AppLocale.values)
          DropdownMenuItem(
            value: locale,
            child: Text(_languageNames[locale.languageTag] ?? locale.languageTag),
          ),
      ],
      onChanged: (locale) {
        if (locale != null) ref.read(localeProvider.notifier).set(locale);
      },
    );
  }
}

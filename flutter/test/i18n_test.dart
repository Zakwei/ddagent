import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('all 12 locales registered', () {
    expect(AppLocale.values.length, 12);
    expect(AppLocaleUtils.supportedLocales.length, 12);
  });

  test('plural resolution sanity — pl/ru/ja/zh', () async {
    // Polish: one / few / many split
    await LocaleSettings.setLocale(AppLocale.pl);
    expect(t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 1), contains('sesję'));
    expect(t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 3), contains('3 sesje'));
    expect(t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 5), contains('5 sesji'));

    // Russian: one / few / many
    await LocaleSettings.setLocale(AppLocale.ru);
    final ru = t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 5);
    expect(ru, isNotEmpty);

    // CJK: only "other" form exists — must still resolve
    await LocaleSettings.setLocale(AppLocale.ja);
    expect(t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 3), isNotEmpty);
    await LocaleSettings.setLocale(AppLocale.zhCn);
    expect(t.sidebar.deleteConfirmation.archiveSelectedSessions(count: 3), isNotEmpty);
  });

  test('no missing keys in en/pl for base namespaces', () async {
    for (final locale in [AppLocale.en, AppLocale.pl]) {
      await LocaleSettings.setLocale(locale);
      expect(t.common.buttons.save, isNotEmpty);
      expect(t.common.buttons.cancel, isNotEmpty);
      expect(t.common.status.loading, isNotEmpty);
      expect(t.settings.title, isNotEmpty);
    }
  });

  test('device locale fallback resolves to a supported locale', () {
    final parsed = AppLocaleUtils.parseLocaleParts(languageCode: 'xx');
    expect(parsed, AppLocale.en);
  });
}

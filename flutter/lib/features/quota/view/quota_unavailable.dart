import 'package:ddagent_app/features/quota/data/quota_models.dart';
import 'package:ddagent_app/i18n/strings.g.dart';

/// Neutral label + hint for an account without a reading because its agent
/// is not installed, not signed in, or has no subscription — shown instead of
/// a red sync error. Null when the account works or really failed.
({String label, String hint})? quotaUnavailableText(Translations i18n, QuotaAccount account) {
  final q = i18n.common.quota;
  final place = '${i18n.settings.title} → ${i18n.settings.mainTabs.agents}';
  return switch (quotaUnavailableReason(account)) {
    'not_installed' => (label: q.notInstalled, hint: q.notInstalledHint(place: place)),
    'not_logged_in' => (label: q.notLoggedIn, hint: q.notLoggedInHint(place: place)),
    'no_subscription' => (label: q.noSubscription, hint: q.noSubscriptionHint),
    _ => null,
  };
}

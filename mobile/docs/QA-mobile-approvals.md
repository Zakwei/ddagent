# Mobile approvals — manual QA checklist

Requires a dev/production build (not Expo Go — remote push needs Firebase).
Server needs `FCM_SERVICE_ACCOUNT` or `GOOGLE_APPLICATION_CREDENTIALS` set.

## Push registration

- [ ] Fresh install → sign in → grant notification permission → FCM token appears under Settings → Notifications as an `fcm` endpoint.
- [ ] Android: `default` channel exists with HIGH importance; `ddagent-approval-push` task registered (logcat shows no task-manager error).

## Actionable approval push

- [ ] Run a session in `default` permission mode that triggers a tool prompt (e.g. `Bash`).
- [ ] With the app **backgrounded**, Android shows a local notification with Approve / Deny / Always allow buttons (posted by the background task from the data-only FCM).
- [ ] iOS shows the push with the same buttons via the `TOOL_APPROVAL` category.
- [ ] Tapping **Approve** resolves the request without opening the app — the session continues (verify on web/desktop).
- [ ] Tapping **Deny** denies it; **Always allow** maps to the provider's always-allow decision.
- [ ] Tapping the notification body opens `ddagent://chat/<sessionId>` at the right session.

## Edge cases

- [ ] Resolve the same request from web first, then tap the push action → app shows "This request was already resolved." (HTTP 409 path).
- [ ] Offline: action tap fails silently (warn logged) — no stuck UI.
- [ ] `permission_cancelled` while a banner is visible removes the banner.
- [ ] Two pending requests in one session show as two banners; resolving one leaves the other.

## In-app

- [ ] Foreground `permission_request` banner still works (existing flow) — push actions and banner are not mutually exclusive.

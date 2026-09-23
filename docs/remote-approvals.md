# Remote approvals — Telegram & Discord

Approve or deny pending tool permission requests without opening the UI.

## Telegram

1. Create a bot via [@BotFather](https://t.me/BotFather), copy the token.
2. Settings → Notifications → Messengers → paste the token into **Telegram bot token**, enable the channel.
3. Send any message to your bot, then click **Pair** on the detected chat — the chat id is whitelisted and approval cards start arriving.
4. Approve / Deny / Always via the inline buttons. Taps resolve the pending request instantly; already-resolved requests answer with a notice.

## Discord

Paste a channel webhook URL into **Discord webhook** and enable the channel — ddagent posts approval notifications there (read-only; Discord webhooks cannot post button callbacks).

## Notes

- Approval context expires with the pending request — replayed callbacks are rejected (`409`).
- `POST /api/notifications/approvals/:requestId` `{decision: 'allow'|'deny'|'always'}` is the REST resolve used by the mobile app and any other client.
- The Telegram poller (getUpdates long-poll) starts with the server and stays inert until a token is configured.

# Remote approvals — Telegram & Discord

Approve or deny pending tool permission requests without opening the client.
Both channels are configured in **Settings → Notifications → Messenger
approvals**.

## Telegram

1. Create a bot with [@BotFather](https://t.me/BotFather) and copy its token.
2. Paste the token into the Telegram card, **Save** it, and enable the channel.
3. Send any message to your bot, then click **Pair** on the detected chat. The
   chat id is whitelisted and approval cards start arriving there.
4. Answer with the inline **Allow** / **Deny** / **Always** buttons. A tap
   resolves the pending request immediately and removes the buttons; taps on an
   expired or already resolved request get a notice instead. Callbacks from
   chats that are not paired are rejected.

## Discord

Paste a channel webhook URL (`https://discord.com/api/webhooks/…`) into the
Discord card, save it and enable the channel. ddagent posts notifications there
(approval requests and the other enabled event types). Discord is
notification-only: a webhook cannot receive button callbacks, so approvals still
have to be answered in Telegram or the client.

## Notes

- Approval context expires with the pending request — replayed callbacks are
  rejected.
- `POST /api/notifications/approvals/:requestId` with
  `{ "decision": "allow" | "deny" | "always" }` (optional `updatedInput`,
  `message`, `rememberEntry`) is the REST resolve used by the Flutter client when
  its chat WebSocket is down, and by any other client. It requires the `member`
  role (see [Team collaboration](teams.md)) and returns `409` when the request is
  no longer pending.
- The Telegram poller (`getUpdates` long-poll) starts with the server and stays
  inert until a bot token is configured. Only one server instance can poll a
  given bot token at a time.

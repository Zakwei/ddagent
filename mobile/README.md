# ddagent mobile

Native Expo/React Native companion app for ddagent — chat, sessions, terminal,
files, and the full PWA surfaces via token-authenticated WebViews.

## Dev

```sh
npm install          # inside mobile/
npm run mobile:dev   # repo root — expo start (same-LAN)
npm run mobile:tunnel # repo root — expo start --tunnel (any network)
```

Open the `exp://` URL in Expo Go, then point the app's server field at your
ddagent instance (e.g. `https://<host>:8443` or `http://<lan-ip>:10087`).

## Checks

```sh
npm run mobile:typecheck   # tsc
npm run mobile:test        # chat parser self-check
```

## Build

Requires an Expo account (`npx eas-cli login`, `npx eas-cli init --id` once).

```sh
npm run mobile:build-apk   # preview profile → installable .apk
npm run mobile:build-aab   # production profile → Play-ready .aab
npm run mobile:update      # OTA update to the matching channel
```

Push notifications (FCM) need `google-services.json` in this directory and
`FCM_SERVICE_ACCOUNT` set on the ddagent server.

## Architecture

- `src/screens/` — native screens (chat, sessions, projects, files, settings)
- `src/screens/WebScreen.tsx` — generic WebView loader for any web route
  (`/board`, `/tasks`, `/usage`, `/source-control`, `/mcp`, `/skills`, `/prd`,
  `/browser`, `?settings=<tab>`) — auth via `?token=` planted by the web app
- `src/lib/chat-messages.ts` — normalizes the server's `kind`-based message
  items (text/thinking/tool_use/tool_result/status/stream_end)
- WebSocket is the primary send path (`chat.send` binds the run writer so
  `stream_delta`s arrive live); the REST queue is the offline fallback.

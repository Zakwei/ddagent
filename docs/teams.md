# Team collaboration

A multi-user layer on top of the shared board: roles, invite links, card
assignees, comments, live presence, and a per-project activity feed.

## Roles

| Role | Can do |
|---|---|
| `owner` | Everything, including minting invites (`POST /api/invites`) |
| `member` | Boards, cards, comments, approvals (`chat.permission-response`, `POST /api/notifications/approvals/:requestId`) and changing a session's permission mode (`chat.set-permission-mode`) |
| `viewer` | Read/watch only — approval and permission-mode requests are rejected (`403` over REST, `FORBIDDEN_ROLE` over the websocket) |

Enforcement lives in `server/modules/collab/require-role.ts`
(`requireRole` for REST, `roleAtLeast` for the websocket path). Unknown or
missing roles fail closed.

The first registered user is always `owner` (column default on `users.role`,
backfilled by the `addUserRoleColumn` migration).

## Inviting users

`POST /api/invites` (owner only) mints a single-use invite:

```json
{ "role": "member", "ttlHours": 72 }
```

`role` is `member` (default) or `viewer`; `ttlHours` defaults to 72 and is capped
at 720 (30 days). The response (`data.invite`) carries the plaintext `token`
once. In the Flutter client, owners mint invites from the board's team panel
(**Invite teammate**) and copy the token from there.

The invitee registers with the token — the register screen reads it from an
`?invite=<token>` query parameter — or directly over REST:

```
POST /api/auth/register
{ "username": "bob", "password": "…", "inviteToken": "<token>" }
```

A valid invite bypasses the single-user register guard and stamps the invite's
role onto the new user. The token is burned on use (`collab_invites.used_by`)
and expires after `ttlHours`.

## Board features

- **Assignees** — `kanban_cards.assignee_user_id`; PATCH a card with
  `assigneeUserId` (`null` unassigns). The board toolbar filters by assignee
  (all / unassigned / a specific user). `GET /api/users` lists the active users
  for the pickers.
- **Comments** — `GET/POST /api/kanban/cards/:cardId/comments`; new comments
  are broadcast as `kanban-comment-added` over the board websocket.
- **Presence** — clients announce `{type:'presence', viewing:{kind,id}}`
  on the chat websocket (`/ws`); the server broadcasts a throttled (1 s)
  `presence-roster` frame that collapses a user's tabs into one entry.
- **Activity feed** — `GET /api/activity?projectId=` (optional `limit`) lists the
  `card_created`, `card_moved`, `card_assigned` and `card_commented` events
  recorded by the kanban service.

## Schema

`applyCollabSchema` (called from `initializeDatabase`) adds
`users.role`, `kanban_cards.assignee_user_id`, `card_comments`,
`activity_events` and `collab_invites`. All steps are idempotent.

## Known limits

- Assignee ids are validated by the pickers at read time; the column has no
  foreign key (SQLite cannot add one via `ALTER TABLE`).
- Session-to-user attribution relies on the existing `sessions.user_id`;
  there is no per-user session ACL yet — every authenticated user sees every
  session.

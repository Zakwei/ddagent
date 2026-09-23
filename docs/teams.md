# Team collaboration

Multi-user layer on top of the shared board: roles, invite links, card
assignees, comments, live presence, and a per-project activity feed.

## Roles

| Role | Can do |
|---|---|
| `owner` | Everything, incl. minting invite links (`POST /api/invites`) |
| `member` | Boards, cards, comments, approvals (`chat.permission-response`, `POST /api/notifications/approvals/:requestId`) |
| `viewer` | Read/watch only — cannot resolve approvals (403 / `FORBIDDEN_ROLE`) |

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

Response carries the plaintext `token` once. The invitee registers with it:

```
POST /api/auth/register
{ "username": "bob", "password": "…", "inviteToken": "<token>" }
```

A valid invite bypasses the single-user register guard and stamps the
invite's role onto the new user; the token is burned on use
(`collab_invites.used_by`) and expires after `ttlHours` (max 30 days).

## Board features

- **Assignees** — `kanban_cards.assignee_user_id`; PATCH a card with
  `assigneeUserId` (`null` unassigns). The board toolbar filters by assignee
  (all / unassigned / a specific user).
- **Comments** — `GET/POST /api/kanban/cards/:cardId/comments`; new comments
  broadcast as `kanban-comment-added` over the board websocket.
- **Presence** — clients announce `{type:'presence', viewing:{kind,id}}`
  on the chat websocket; the server broadcasts a throttled (1 s)
  `presence-roster` frame that collapses a user's tabs into one entry.
- **Activity feed** — `GET /api/activity?projectId=` lists `card_created`,
  `card_moved`, `card_assigned`, `card_commented` events recorded by the
  kanban service.

## Schema

`applyCollabSchema` (called from `initializeDatabase`) adds:
`users.role`, `kanban_cards.assignee_user_id`, `card_comments`,
`activity_events`, `collab_invites`. All idempotent.

## Known ceiling

- Assignee ids are validated by the pickers at read time; the column has no
  FK (SQLite can't add one via ALTER TABLE).
- Session-to-user attribution relies on the existing `sessions.user_id`;
  there is no per-user session ACL yet — every authenticated user sees every
  session.

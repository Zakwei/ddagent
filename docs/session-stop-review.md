# Review: Stop → next message (2026-10-02)

A static review of the seven provider runtimes, the WebSocket gateway and the
Flutter client. Tests use fakes; no real sessions or services were stopped.

## Fixed shared handling

`chat-websocket.service.ts`: the result of an asynchronous abort was applied to
the session instead of to the specific run (turn). The previous run can finish
while the abort is still pending, and the next one can start from the queue or
from the user. A successful abort then completed the next run, and a refused
abort reset that run's abort flag. The result is now applied only to the run
captured before the abort. The same completion guard was added for the
orchestrator parent run.

Added 14 regression cases: a delayed abort that succeeds and one that is refused,
for each provider. The tests check that the new run keeps running and does not
receive a stray `complete` or `protocol_error`.

## Risks identified before the fix

| Agent | Resume mechanism | Findings that needed further fixes |
| --- | --- | --- |
| Claude | SDK `resume` with the provider session id | The normal loop cleanup checks instance ownership, but `abortClaudeSDKSession` deletes the entry by id after `await interrupt()` without that check. If a run finishes and is resumed inside that window, it can delete the new instance. |
| Codex | SDK `resumeThread` | The `finally` block in `queryCodex` updates the status of the entry looked up by session id. An older, stopped run can mark a newer one as completed; abort-status reads are also keyed by id instead of the owning instance. |
| Cursor | CLI `--resume` | The close/error callbacks unconditionally delete the entry by id. A delayed exit of the stopped process can delete the new process's handle, so the next Stop does nothing. The workspace-trust retry is checked before the aborted flag. |
| Antigravity | CLI `--conversation` | The close/error callbacks unconditionally delete the entry by id; same risk of losing the new process's handle as Cursor. |
| OpenCode | Existing HTTP session | Abort sets `aborted`, ignores the HTTP error and returns `true`, so the UI can show the run as stopped while the server keeps generating. Cleanup protects `activeRuns` but removes the mapping, mode and permissions by session id without full ownership checks. |
| Devin | ACP `session/load` | A failed load falls back to `session/new`, which can lose the provider context even though the app still shows the history. Abort still returns `true` after a failed cancel send; the `catch` block can skip cleanup. |
| Command Code | ACP `session/load` | Same load → new fallback and ignored abort exception as Devin. |

The Flutter client sent `chat.abort` without a `runId`. The gateway correlated
completion with the captured run, but a delayed Stop request itself could still
hit a newer run. A separate protocol safeguard needed the `runId` to be sent and
validated.

Conclusion at that point: the shared Stop-result race was fixed, but there was
no basis to treat every runtime as safe for an immediate resume. The risks above
come from reading the code and needed dedicated runtime lifecycle tests.

## Fixing the remaining risks (2026-10-02)

All findings above have been addressed:

- Claude and Codex tie abort, status and cleanup to the specific run instance.
- Cursor and Antigravity delete handles only while they still belong to the
  exiting process. A stopped Cursor run no longer retries workspace trust.
- OpenCode protects the mapping, mode and permissions from an old run's cleanup;
  an HTTP error or a `false` abort response keeps the run active and reports a
  refusal.
- Devin and Command Code report a resume error instead of starting a new
  conversation. A failed cancel reports a refusal and keeps the handle so Stop
  can be retried; a process-kill error no longer skips cleanup after an accepted
  cancel.
- Flutter sends `runId` with Stop, and the gateway rejects a missing
  (`RUN_ID_REQUIRED`) or stale (`STALE_RUN`) id before calling the runtime. The
  orchestrator abort also guards run ownership and handles a refused cancel.

The runtime and gateway lifecycle tests use fake transports and processes. They
are not an integration check of the real SDKs or ACP services. No services were
restarted and no real sessions were stopped.

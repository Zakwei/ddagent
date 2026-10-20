// connectPtyHost / resolvePtyHostSocketPath: used by the WebSocket shell service to keep
// terminals in the PTY host daemon, so they survive server restarts.
export { connectPtyHost, resolvePtyHostSocketPath } from './services/pty-host.service.js';
// HostedPty / PtyHostClient / PtyHostSnapshot: used by the WebSocket shell service to drive
// and adopt PTYs held by the daemon.
export type { HostedPty, PtyHostClient, PtyHostSnapshot } from './services/pty-host.service.js';
// runPtyHostDaemon: used by the daemon entrypoint and by the WebSocket shell tests, which run a
// daemon in-process to check that terminals are adopted after a server restart.
export { runPtyHostDaemon } from './services/pty-host.service.js';

#!/usr/bin/env node
/**
 * PTY host daemon entrypoint: `node dist-server/server/modules/pty-host/pty-host-daemon.js`.
 *
 * Runs as its own service (e.g. `ddagent-pty-host.service`) so terminals
 * outlive restarts of the ddagent server — a unit of its own puts it outside
 * the server's cgroup, which `KillMode=control-group` empties on every stop.
 * Everything is loaded at startup: a later server build swaps `dist-server/`
 * underneath this long-running process.
 */
import { resolvePtyHostSocketPath, runPtyHostDaemon } from './index.js';

const socketPath = resolvePtyHostSocketPath();
runPtyHostDaemon(socketPath);
console.log(`[PTY host] listening on ${socketPath}`);

// Keep the PTYs when the terminal that started the daemon hangs up.
process.on('SIGHUP', () => {});

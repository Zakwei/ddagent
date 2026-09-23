#!/usr/bin/env node
// Load environment variables before other imports execute.
import './load-env.js';
import fs, { promises as fsPromises } from 'fs';
import path from 'path';
import os from 'os';
import http from 'http';

import { getErrorCode, getErrorMessage, terminalTextStyles } from '@/shared/utils.js';
import { createWebSocketServer } from '@/modules/websocket/index.js';
import { attachPreviewUpgrade } from '@/modules/preview/index.js';

import { getConnectableHost } from '../shared/networkHosts.js';

import { createServices } from './services.js';

console.log('SERVER_PORT from env:', process.env.SERVER_PORT);

const SERVER_PORT = Number.parseInt(process.env.SERVER_PORT || '3001', 10);
const HOST = process.env.HOST || '0.0.0.0';
const DISPLAY_HOST = getConnectableHost(HOST);
const VITE_PORT = process.env.VITE_PORT || 5173;
const LOCAL_SERVER_MARKER_PATH = path.join(os.homedir(), '.ddagent', 'local-server.json');

async function writeLocalServerMarker(installMode: 'git' | 'npm', appRoot: string) {
    const marker = {
        pid: process.pid,
        host: HOST,
        port: Number.parseInt(String(SERVER_PORT), 10),
        url: `http://${DISPLAY_HOST}:${SERVER_PORT}`,
        installMode,
        appRoot,
        updatedAt: new Date().toISOString(),
    };

    await fsPromises.mkdir(path.dirname(LOCAL_SERVER_MARKER_PATH), { recursive: true });
    await fsPromises.writeFile(LOCAL_SERVER_MARKER_PATH, JSON.stringify(marker, null, 2), 'utf8');
}

async function removeLocalServerMarker() {
    try {
        const raw = await fsPromises.readFile(LOCAL_SERVER_MARKER_PATH, 'utf8');
        const marker = JSON.parse(raw);
        if (marker.pid && marker.pid !== process.pid) return;
    } catch (error) {
        if (getErrorCode(error) === 'ENOENT') return;
    }

    try {
        await fsPromises.unlink(LOCAL_SERVER_MARKER_PATH);
    } catch (error) {
        if (getErrorCode(error) !== 'ENOENT') {
            console.warn('[WARN] Could not remove local server marker:', getErrorMessage(error));
        }
    }
}

// Initialize the composed services, then bind the HTTP/WebSocket transport.
async function startServer() {
    try {
        const { app, wsDeps, appRoot, installMode, services, shutdown } = await createServices();

        const server = http.createServer(app);

        // Single WebSocket server that handles chat and shell paths.
        const wss = createWebSocketServer(server, wsDeps);

        // Dev-server preview WS tunnel (HMR) — re-dispatches upgrades before
        // the gateway's catch-all can reject them.
        attachPreviewUpgrade(server, wss);

        // Make WebSocket server available to routes
        app.locals.wss = wss;

        // Check if running in production mode (dist folder exists)
        const distIndexPath = path.join(appRoot, 'dist', 'index.html');
        const isProduction = fs.existsSync(distIndexPath);

        // Log Claude implementation mode
        console.log(`${terminalTextStyles.info('[INFO]')} Using Claude Agents SDK for Claude integration`);
        console.log('');

        if (isProduction) {
            console.log(`${terminalTextStyles.info('[INFO]')} To run in production mode, go to http://${DISPLAY_HOST}:${SERVER_PORT}`);
        }

        console.log(`${terminalTextStyles.info('[INFO]')} To run in development mode with hot-module replacement, go to http://${DISPLAY_HOST}:${VITE_PORT}`);

        server.listen(SERVER_PORT, HOST, async () => {
            const appInstallPath = appRoot;
            await writeLocalServerMarker(installMode, appRoot).catch((error) => {
                console.warn('[WARN] Could not write local server marker:', error.message);
            });

            console.log('');
            console.log(terminalTextStyles.dim('═'.repeat(63)));
            console.log(`  ${terminalTextStyles.bright('ddagent Server - Ready')}`);
            console.log(terminalTextStyles.dim('═'.repeat(63)));
            console.log('');
            console.log(`${terminalTextStyles.info('[INFO]')} Server URL:  ${terminalTextStyles.bright('http://' + DISPLAY_HOST + ':' + SERVER_PORT)}`);
            console.log(`${terminalTextStyles.info('[INFO]')} Installed at: ${terminalTextStyles.dim(appInstallPath)}`);
            console.log(`${terminalTextStyles.tip('[TIP]')}  Run "ddagent status" for full configuration details`);
            console.log('');

            // Start watching the projects folder for changes
            await services.initializeSessionsWatcher();
        });

        // Pre-existing quirk, preserved: this runs right after listen() is
        // requested — before the listen callback starts the watcher — so it is
        // effectively a no-op today.
        await services.closeSessionsWatcher();

        const shutdownRuntimeServices = async () => {
            await shutdown();
            try {
                await removeLocalServerMarker();
            } catch (err) {
                console.error('[Local Server] Error removing server marker during shutdown:', getErrorMessage(err));
            }
            process.exit(0);
        };
        process.on('SIGTERM', () => void shutdownRuntimeServices());
        process.on('SIGINT', () => void shutdownRuntimeServices());
    } catch (error) {
        console.error('[ERROR] Failed to start server:', error);
        process.exit(1);
    }
}

startServer();

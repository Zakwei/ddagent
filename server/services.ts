// Load environment variables before other imports execute: several feature
// modules open the database or capture env flags during evaluation.
import './load-env.js';
import fs from 'fs';
import path from 'path';

import express, { type Express, type NextFunction, type Request, type Response } from 'express';
import cors from 'cors';

import { AppError, findApplicationRoot, getErrorMessage, getModuleDirectory, IS_PLATFORM } from '@/shared/utils.js';
import {
    closeSessionsWatcher,
    initializeSessionsWatcher,
    providerRuntimeService,
} from '@/modules/providers/index.js';
import type { WebSocketServerDependencies } from '@/modules/websocket/index.js';

import { getConnectableHost } from '../shared/networkHosts.js';

import { createGitModule } from './modules/git/index.js';
import {
    authenticateToken,
    authenticateWebSocket,
    authRoutes,
    validateApiKey,
} from './modules/auth/index.js';
import { taskmasterRoutes } from './modules/taskmaster/index.js';
import { queuedMessagesRoutes, queuedMessagesService } from './modules/queued-messages/index.js';
import { kanbanRoutes, kanbanReportRoutes } from './modules/kanban/index.js';
import { quotaRoutes } from './modules/quota/index.js';
import { commandsRoutes } from './modules/commands/index.js';
import { settingsRoutes } from './modules/settings/index.js';
import { createSystemModule } from './modules/system/index.js';
import { createAgentModule } from './modules/agent/index.js';
import projectModuleRoutes from './modules/projects/projects.routes.js';
import notificationRoutes from './modules/notifications/notifications.routes.js';
import { userRoutes } from './modules/user/index.js';
import providerRoutes from './modules/providers/provider.routes.js';
import browserUseRoutes from './modules/browser-use/browser-use.routes.js';
import { assetsRoutes } from './modules/assets/index.js';
import { fileTreeRoutes } from './modules/file-tree/index.js';
import { worktreesRoutes } from './modules/worktrees/index.js';
import browserUseMcpRoutes from './modules/browser-use/browser-use-mcp.routes.js';
import { browserUseService } from './modules/browser-use/browser-use.service.js';
import { ttsRoutes } from './modules/tts/index.js';
import { closeAllBrowserViewSessions } from './modules/browser-view/index.js';
import { initializeDatabase, sessionsDb } from './modules/database/index.js';
import { configureWebPush } from './modules/notifications/index.js';

// Dev-server port used only by the catch-all redirect when no production
// bundle exists — the standalone entrypoint reads the same value for its
// startup banner.
const VITE_PORT = process.env.VITE_PORT || 5173;

/**
 * Overrides accepted by the services composition root.
 *
 * Only covers what is resolved inside createServices: several feature modules
 * open the database or capture env flags at import time (DATABASE_PATH,
 * JWT_SECRET, VITE_IS_PLATFORM), so a consumer that needs those changed must
 * set them in the environment BEFORE importing this module.
 *
 * Consumed by the standalone entrypoint (server/index.ts) and by embedded
 * consumers (desktop shell) that attach their own transport.
 */
export type CreateServicesOptions = {
    /**
     * Application root used for package.json, public/, dist/, and update
     * lookups. Defaults to the repo root resolved from this file's location —
     * what the standalone server has always used.
     */
    appRoot?: string;
    /**
     * Install flavor reported by /health and used by the system module's
     * update paths. Defaults to 'git' when `<appRoot>/.git` exists, else 'npm'.
     */
    installMode?: 'git' | 'npm';
    /**
     * Hosted-platform flag forwarded to the websocket verifier and the system
     * module. Defaults to the env-derived IS_PLATFORM. Feature modules that
     * read IS_PLATFORM at import time still follow VITE_IS_PLATFORM, so an
     * override here must be paired with the env var set before import to keep
     * every module aligned.
     */
    isPlatform?: boolean;
    /**
     * Extra environment overrides applied before composition runs. Only
     * affects configuration read lazily (SERVER_PORT, HOST,
     * KANBAN_REPORT_BASE_URL); values captured at module import
     * (DATABASE_PATH, JWT_SECRET, VITE_IS_PLATFORM) must be set before this
     * module is imported instead.
     */
    env?: Record<string, string>;
};

/**
 * Result of composing the backend service surface. The caller owns the
 * transport: the standalone entrypoint attaches `wsDeps` to an HTTP server,
 * embedded consumers wire it to an in-process transport.
 */
export type CreateServicesResult = {
    /** Express app with every route and middleware mounted. */
    app: Express;
    /**
     * The exact dependencies object accepted by createWebSocketServer(),
     * exposed separately so embedded consumers can attach the same chat,
     * shell, notification, and browser-view handlers to a non-HTTP transport.
     */
    wsDeps: WebSocketServerDependencies;
    /** Resolved composition settings, defaults applied. */
    appRoot: string;
    installMode: 'git' | 'npm';
    isPlatform: boolean;
    /**
     * Version of the running code captured at composition time. Intentionally
     * not re-read per request: after an update replaces files on disk, a
     * mismatch with the rebuilt frontend bundle means this process still runs
     * the OLD code and needs a restart.
     */
    runningVersion: string | null;
    /**
     * Service singletons wired into the app, re-exposed so embedded consumers
     * do not need to re-import feature modules for lifecycle or shell access.
     */
    services: {
        providerRuntimeService: typeof providerRuntimeService;
        queuedMessagesService: typeof queuedMessagesService;
        browserUseService: typeof browserUseService;
        sessionsDb: typeof sessionsDb;
        initializeSessionsWatcher: typeof initializeSessionsWatcher;
        closeSessionsWatcher: typeof closeSessionsWatcher;
    };
    /**
     * Stops browser-use sessions and browser views. Deliberately does NOT
     * call process.exit or register signal handlers — each consumer owns its
     * shutdown policy (the standalone entrypoint removes its marker file and
     * exits; desktop hooks its own app lifecycle).
     */
    shutdown(): Promise<void>;
};

/**
 * Composes the ddagent backend: builds the Express application, mounts every
 * module and route, initializes the database schema and web push, and returns
 * the websocket dependency object. Never binds a port, registers signal
 * handlers, or exits the process — that stays with the caller.
 *
 * Embedder contract: importing this module is safe against a brand-new empty
 * DATABASE_PATH — module-level code opens the connection (creating the file
 * and the app_config table) but no module-level query requires the full
 * schema. initializeDatabase() runs inside createServices(), so a plain
 * `await import('services.js')` followed by `createServices()` bootstraps a
 * fresh install end to end. Env-derived config (DATABASE_PATH, JWT_SECRET,
 * VITE_IS_PLATFORM) is captured at import time and must be set beforehand.
 *
 * Used by the standalone entrypoint (server/index.ts), which attaches an HTTP
 * server and listens, and by embedded consumers (desktop shell) that attach
 * `wsDeps` to an in-process transport and assign `app.locals.wss` themselves.
 */
export async function createServices(options: CreateServicesOptions = {}): Promise<CreateServicesResult> {
    if (options.env) {
        Object.assign(process.env, options.env);
    }

    const appRoot = options.appRoot ?? findApplicationRoot(getModuleDirectory(import.meta.url));
    const installMode = options.installMode ?? (fs.existsSync(path.join(appRoot, '.git')) ? 'git' : 'npm');
    const isPlatform = options.isPlatform ?? IS_PLATFORM;
    // Version of the code that is actually running, captured once at process
    // startup. This intentionally does NOT re-read package.json per request: after
    // an update replaces the files on disk, package.json reflects the NEW version
    // while this long-lived process still runs the OLD code. The frontend bundle is
    // rebuilt on update, so a mismatch between this value and the frontend's
    // build-time version means the server was updated but not restarted.
    const runningVersion = (() => {
        try {
            return JSON.parse(fs.readFileSync(path.join(appRoot, 'package.json'), 'utf8')).version || null;
        } catch {
            return null;
        }
    })();
    const systemRoutes = createSystemModule({
        appRoot,
        installMode,
        isPlatform,
    });

    const app = express();
    const queryClaude = providerRuntimeService.getRunner('claude');
    const queryCursor = providerRuntimeService.getRunner('cursor');
    const queryCodex = providerRuntimeService.getRunner('codex');
    const queryOpenCode = providerRuntimeService.getRunner('opencode');
    const gitRoutes = createGitModule({
        queryClaude,
        queryCursor,
    });
    const agentRoutes = createAgentModule({
        queryClaude,
        queryCursor,
        queryCodex,
        queryOpenCode,
    });

    // Dependencies for the single WebSocket server that handles chat and shell
    // paths. Returned to the caller so the gateway can be attached to any
    // transport — an HTTP server in the standalone entrypoint, an in-process
    // transport for embedded consumers.
    const wsDeps: WebSocketServerDependencies = {
        verifyClient: {
            isPlatform,
            authenticateWebSocket,
        },
        chat: {
            runtime: providerRuntimeService,
            enqueueMessage: (input) => {
                queuedMessagesService.enqueue(input);
            },
        },
        shell: {
            resolveProviderSessionId: (sessionId, provider) => {
                const dbSession = sessionsDb.getSessionById(sessionId);
                if (dbSession) {
                    return dbSession.provider_session_id ?? null;
                }

                return null;
            },
        },
    };

    app.use(cors({ exposedHeaders: ['X-Refreshed-Token', 'X-Auth-Error'] }));
    app.use(express.json({
        limit: '50mb',
        type: (req) => {
            // Skip multipart/form-data requests (for file uploads like images)
            const contentType = req.headers['content-type'] || '';
            if (contentType.includes('multipart/form-data')) {
                return false;
            }
            return contentType.includes('json');
        }
    }));
    app.use(express.urlencoded({ limit: '50mb', extended: true }));

    // Public health check endpoint (no authentication required)
    app.get('/health', (req, res) => {
        res.json({
            status: 'ok',
            timestamp: new Date().toISOString(),
            installMode,
            version: runningVersion
        });
    });

    // Kanban agent callback (token-guarded, no JWT and no API key: the agent's
    // `curl` report carries only the per-card token, so it must be mounted before
    // the optional API-key gate or every report fails with 401).
    app.use('/api/kanban', kanbanReportRoutes);

    // Browser MCP bridge API (local token protected; MCP clients do not send an
    // x-api-key header, so it too must precede the optional API-key gate).
    app.use('/api/browser-use-mcp', browserUseMcpRoutes);

    // Optional API key validation (if configured)
    app.use('/api', validateApiKey);

    // Authentication routes (public)
    app.use('/api/auth', authRoutes);

    // File Tree API Routes (protected)
    app.use('/api/file-tree', authenticateToken, fileTreeRoutes);

    // Projects API Routes (protected)
    app.use('/api/projects', authenticateToken, projectModuleRoutes);

    // Chat attachment upload/serving (global ~/.ddagent/assets store, protected)
    app.use('/api/assets', authenticateToken, assetsRoutes);

    // Git API Routes (protected)
    app.use('/api/git', authenticateToken, gitRoutes);

    // Git worktree management (protected)
    app.use('/api/worktrees', authenticateToken, worktreesRoutes);

    // TaskMaster API Routes (protected)
    app.use('/api/taskmaster', authenticateToken, taskmasterRoutes);

    // Server-side outbound message queue (protected): queued sends survive
    // refreshes and device switches, and "send now" dispatches immediately.
    app.use('/api/queue', authenticateToken, queuedMessagesRoutes);

    // Kanban API Routes (protected)
    app.use('/api/kanban', authenticateToken, kanbanRoutes);

    // Commands API Routes (protected)
    app.use('/api/commands', authenticateToken, commandsRoutes);

    // Settings API Routes (protected)
    app.use('/api/settings', authenticateToken, settingsRoutes);

    // Quota API Routes (protected)
    app.use('/api/quota', authenticateToken, quotaRoutes);

    app.use('/api/system', authenticateToken, systemRoutes);

    app.use('/api/notifications', authenticateToken, notificationRoutes);

    // User API Routes (protected)
    app.use('/api/user', authenticateToken, userRoutes);

    // Browser API Routes (protected)
    app.use('/api/browser-use', authenticateToken, browserUseRoutes);

    // Unified provider MCP routes (protected)
    app.use('/api/providers', authenticateToken, providerRoutes);

    // Text-to-speech routes (protected) — Edge neural voices for read-aloud
    app.use('/api/tts', authenticateToken, ttsRoutes);

    // Agent API Routes (uses API key authentication)
    app.use('/api/agent', agentRoutes);

    // Serve public files (like api-docs.html)
    app.use(express.static(path.join(appRoot, 'public')));

    // Static files served after API routes
    // Add cache control: HTML files should not be cached, but assets can be cached
    app.use(express.static(path.join(appRoot, 'dist'), {
        setHeaders: (res, filePath) => {
            if (filePath.endsWith('.html')) {
                // Prevent HTML caching to avoid service worker issues after builds
                res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
                res.setHeader('Pragma', 'no-cache');
                res.setHeader('Expires', '0');
            } else if (filePath.match(/\.(js|css|woff2?|ttf|eot|svg|png|jpg|jpeg|gif|ico)$/)) {
                // Cache static assets for 1 year (they have hashed names)
                res.setHeader('Cache-Control', 'public, max-age=31536000, immutable');
            }
        }
    }));

    // API Routes (protected)
    // /api/config endpoint removed - no longer needed
    // Frontend now uses window.location for WebSocket URLs

    // Chat uploads live under /api/assets (server/modules/assets), which stores
    // images and general files in the global ~/.ddagent/assets folder.

    // Serve React app for all other routes (excluding static files)
    app.get('*', (req, res) => {
        // Skip requests for static assets (files with extensions)
        if (path.extname(req.path)) {
            return res.status(404).send('Not found');
        }

        // Only serve index.html for HTML routes, not for static assets
        // Static assets should already be handled by express.static middleware above
        const indexPath = path.join(appRoot, 'dist', 'index.html');

        // Check if dist/index.html exists (production build available)
        if (fs.existsSync(indexPath)) {
            // Set no-cache headers for HTML to prevent service worker issues
            res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
            res.setHeader('Pragma', 'no-cache');
            res.setHeader('Expires', '0');
            res.sendFile(indexPath);
        } else {
            // In development, redirect to Vite dev server only if dist doesn't exist
            const redirectHost = getConnectableHost(req.hostname);
            res.redirect(`${req.protocol}://${redirectHost}:${VITE_PORT}`);
        }
    });

    // global error middleware must be last
    app.use((err: unknown, req: Request, res: Response, next: NextFunction) => {
        if (err instanceof AppError) {
            return res.status(err.statusCode).json({
                success: false,
                error: {
                    code: err.code,
                    message: err.message,
                    details: err.details,
                },
            });
        }

        console.error(err);

        return res.status(500).json({
            success: false,
            error: {
                code: 'INTERNAL_ERROR',
                message: 'Internal server error',
            },
        });
    });

    // Initialize authentication database (schema + migrations)
    await initializeDatabase();

    // Configure Web Push (VAPID keys)
    configureWebPush();

    // Service-level cleanup shared by every transport. Process exit, signal
    // handlers, and the local-server marker stay with the caller.
    const shutdown = async () => {
        try {
            await browserUseService.stopAllSessions();
        } catch (err) {
            console.error('[Browser] Error stopping sessions during shutdown:', getErrorMessage(err));
        }
        try {
            await closeAllBrowserViewSessions();
        } catch (err) {
            console.error('[Browser] Error stopping browser views during shutdown:', getErrorMessage(err));
        }
    };

    return {
        app,
        wsDeps,
        appRoot,
        installMode,
        isPlatform,
        runningVersion,
        services: {
            providerRuntimeService,
            queuedMessagesService,
            browserUseService,
            sessionsDb,
            initializeSessionsWatcher,
            closeSessionsWatcher,
        },
        shutdown,
    };
}

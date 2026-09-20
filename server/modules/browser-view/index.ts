// handleBrowserViewConnection: consumed by the server websocket gateway, which
// routes `/browser-view` upgrades to the live Chromium view bridge.
export { handleBrowserViewConnection } from './browser-view-websocket.service.js';

// closeAllBrowserViewSessions: consumed by server shutdown to release Chromium.
export { closeAllBrowserViewSessions } from './browser-view.service.js';

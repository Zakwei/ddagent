// createPreviewModule: used by the server entrypoint to mount protected
// preview routes at /api/preview (behind authenticateToken).
export { createPreviewModule } from './preview.module.js';
// attachPreviewUpgrade: used by the server entrypoint to tunnel dev-server
// WebSocket upgrades (HMR) that bypass the Express pipeline.
export { attachPreviewUpgrade } from './preview.module.js';

// appPreviewRoutes: used by the server entrypoint to mount the preview-pane REST API at `/api/app-preview`.
export { appPreviewRoutes } from './app-preview.routes.js';

// Registry operations: used by the mcp-server module to expose the `preview_*` tools to agents.
export {
  getDefaultAppPreviewDevice,
  listAppPreviewDevices,
  listAppPreviews,
  registerAppPreview,
  reloadAppPreview,
  removeAppPreview,
  updateAppPreview,
} from './app-preview.service.js';

// getAppPreviewDevice: used by the browser-view module to apply a preset's mobile emulation.
export { getAppPreviewDevice } from './app-preview.service.js';

// clearAppPreviews: used by mcp-server tests to isolate preview tool cases.
export { clearAppPreviews } from './app-preview.service.js';

// Public API of the mini-orchestrator module.
//
// - miniOrchestratorRoutes: mounted by the server entrypoint at
//   `/api/mini-orchestrator`.
// - miniOrchestratorRuntime: dispatch entry for `provider='mini-orchestrator'`
//   sessions (chat dispatch + chat.abort).
export { miniOrchestratorRoutes, miniOrchestratorRuntime } from './mini-orchestrator.module.js';

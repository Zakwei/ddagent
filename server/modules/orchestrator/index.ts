// Public API of the orchestrator module.
//
// - orchestratorRoutes: mounted by the server entrypoint at `/api/orchestrator`.
// - orchestratorRuntime: dispatch entry for `provider='orchestrator'` sessions.
// - createOrchestratorDelegationService: reused by the mini-orchestrator module
//   to run delegated child sessions and mirror their streams into the parent
//   transcript, so both engines stream identically.
export { orchestratorRoutes, orchestratorRuntime } from './orchestrator.module.js';
export { createOrchestratorDelegationService } from './services/orchestrator-delegation.service.js';
export type {
  DelegatedRunHandle,
  DelegatedRunInput,
  OrchestratorDelegationService,
} from './services/orchestrator-delegation.service.js';

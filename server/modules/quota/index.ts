// quotaRoutes: used by the server entrypoint to mount the Quota HTTP API at `/api/quota`.
// quotaService: used by the orchestrator module to filter routing candidates by live subscription headroom,
// and by provider-accounts' limit auto-switch to spot exhausted accounts before a turn.
export { quotaRoutes, quotaService } from './quota.module.js';

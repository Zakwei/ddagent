// createKnowledgeRouter: mounted at /api/knowledge by services.ts.
export { createKnowledgeRouter } from './knowledge.routes.js';
export { knowledgeService } from './knowledge.service.js';
export { knowledgeScanService } from './services/knowledge-scan.service.js';
export type { KnowledgeScanResult } from './services/knowledge-scan.service.js';
// applyKnowledgePrefix: used by chat-dispatch to prepend critical knowledge to a
// session's first outbound message.
export { applyKnowledgePrefix, buildKnowledgePrefix } from './services/knowledge-context.service.js';

// createKnowledgeRouter: mounted at /api/knowledge by services.ts.
export { createKnowledgeRouter } from './knowledge.routes.js';
export { knowledgeService } from './knowledge.service.js';
export { knowledgeScanService } from './services/knowledge-scan.service.js';
export type { KnowledgeScanResult } from './services/knowledge-scan.service.js';
export { knowledgeMigrationService } from './services/knowledge-migration.service.js';
export type {
  KnowledgeDuplicateGroup,
  KnowledgeMigrationReport,
} from './services/knowledge-migration.service.js';
export { knowledgeSkillImportService } from './services/knowledge-skill-import.service.js';
export type { KnowledgeSkillImportReport } from './services/knowledge-skill-import.service.js';
// applyKnowledgePrefix: used by chat-dispatch to prepend critical knowledge to a
// session's first outbound message.
export { applyKnowledgePrefix, buildKnowledgePrefix } from './services/knowledge-context.service.js';
// buildKnowledgeContextPreview: used by the knowledge routes to show the
// injected-context size in the client.
export { buildKnowledgeContextPreview } from './services/knowledge-context.service.js';
export type { KnowledgeContextPreview } from './services/knowledge-context.service.js';

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
export { knowledgeImportService } from './services/knowledge-import.service.js';
export type { KnowledgeImportAllReport } from './services/knowledge-import.service.js';
// buildProjectContext: used by the MCP tool `knowledge_get_context` to build
// the Contexta-style, query-driven context for a project.
export { buildProjectContext } from './services/knowledge-context.service.js';
export type { KnowledgeContextResult } from './services/knowledge-context.service.js';
// buildKnowledgeContextPreview: used by the knowledge routes to show the
// always-included critical-context size in the client.
export { buildKnowledgeContextPreview } from './services/knowledge-context.service.js';
export type { KnowledgeContextPreview } from './services/knowledge-context.service.js';

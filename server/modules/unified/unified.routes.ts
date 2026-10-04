import express, { type Request, type Response } from 'express';

import type {
  ProviderSkillCreateFile,
  ProviderSkillCreateInput,
  ProviderSkillMoveInput,
} from '@/shared/types.js';
import { AppError, asyncHandler, createApiSuccessResponse } from '@/shared/utils.js';
import {
  addUnifiedSkills,
  applyUnifiedPrefix,
  getContextCoverage,
  installClaudeHook,
  listUnifiedSkills,
  moveUnifiedSkill,
  readUnifiedRules,
  removeUnifiedSkill,
  resyncUnifiedSkills,
  uninstallClaudeHook,
} from '@/modules/unified/services/unified-hub.service.js';

const router = express.Router();

const readOptionalString = (value: unknown): string | undefined => {
  if (typeof value !== 'string') {
    return undefined;
  }
  const normalized = value.trim();
  return normalized.length > 0 ? normalized : undefined;
};

const parseSkillCreatePayload = (payload: unknown): ProviderSkillCreateInput => {
  if (!payload || typeof payload !== 'object') {
    throw new AppError('Request body must be an object.', {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }

  const body = payload as Record<string, unknown>;
  const rawEntries = Array.isArray(body.entries)
    ? body.entries
    : typeof body.content === 'string'
      ? [{ content: body.content, directoryName: body.directoryName, fileName: body.fileName, files: body.files }]
      : null;

  if (!rawEntries || rawEntries.length === 0) {
    throw new AppError('At least one skill entry is required.', {
      code: 'UNIFIED_SKILLS_REQUIRED',
      statusCode: 400,
    });
  }

  const entries = rawEntries.map((entry, index) => {
    if (!entry || typeof entry !== 'object') {
      throw new AppError(`Skill entry ${index + 1} must be an object.`, {
        code: 'INVALID_REQUEST_BODY',
        statusCode: 400,
      });
    }
    const record = entry as Record<string, unknown>;
    const rawFiles = record.files;
    if (rawFiles !== undefined && !Array.isArray(rawFiles)) {
      throw new AppError(`Skill entry ${index + 1} files must be an array.`, {
        code: 'INVALID_REQUEST_BODY',
        statusCode: 400,
      });
    }
    const files: ProviderSkillCreateFile[] | undefined = rawFiles?.map((file, fileIndex) => {
      if (!file || typeof file !== 'object') {
        throw new AppError(`Skill entry ${index + 1} file ${fileIndex + 1} must be an object.`, {
          code: 'INVALID_REQUEST_BODY',
          statusCode: 400,
        });
      }
      const fileRecord = file as Record<string, unknown>;
      const relativePath = readOptionalString(fileRecord.relativePath);
      const fileContent = typeof fileRecord.content === 'string' ? fileRecord.content : null;
      const encoding = fileRecord.encoding === 'utf8' || fileRecord.encoding === 'base64' ? fileRecord.encoding : null;
      if (!relativePath || fileContent === null || !encoding) {
        throw new AppError(`Skill entry ${index + 1} file ${fileIndex + 1} requires relativePath, content, and encoding.`, {
          code: 'INVALID_REQUEST_BODY',
          statusCode: 400,
        });
      }
      return { relativePath, content: fileContent, encoding };
    });
    return {
      content: typeof record.content === 'string' ? record.content : '',
      directoryName: readOptionalString(record.directoryName),
      fileName: readOptionalString(record.fileName),
      files,
    };
  });

  return { entries };
};

const parseSkillMovePayload = (payload: unknown): ProviderSkillMoveInput => {
  if (!payload || typeof payload !== 'object') {
    throw new AppError('Request body must be an object.', {
      code: 'INVALID_REQUEST_BODY',
      statusCode: 400,
    });
  }

  const body = payload as Record<string, unknown>;
  const sourcePath = readOptionalString(body.sourcePath);
  if (!sourcePath) {
    throw new AppError('sourcePath is required.', {
      code: 'PROVIDER_SKILL_SOURCE_REQUIRED',
      statusCode: 400,
    });
  }

  const targetScope = readOptionalString(body.targetScope);
  if (targetScope !== 'global' && targetScope !== 'project') {
    throw new AppError('targetScope must be "global" or "project".', {
      code: 'PROVIDER_SKILL_TARGET_SCOPE_INVALID',
      statusCode: 400,
    });
  }

  const targetWorkspacePath = readOptionalString(body.targetWorkspacePath);
  if (targetScope === 'project' && !targetWorkspacePath) {
    throw new AppError('targetWorkspacePath is required when moving a skill into a project.', {
      code: 'PROVIDER_SKILL_TARGET_WORKSPACE_REQUIRED',
      statusCode: 400,
    });
  }

  return {
    sourcePath,
    targetScope,
    targetWorkspacePath,
    sourceWorkspacePath: readOptionalString(body.sourceWorkspacePath),
  };
};

// ----------------- Unified skills -----------------
router.get(
  '/skills',
  asyncHandler(async (req: Request, res: Response) => {
    const skills = await listUnifiedSkills({ workspacePath: readOptionalString(req.query.workspacePath) });
    res.json(createApiSuccessResponse({ skills }));
  }),
);

router.post(
  '/skills',
  asyncHandler(async (req: Request, res: Response) => {
    const skills = await addUnifiedSkills(parseSkillCreatePayload(req.body));
    res.json(createApiSuccessResponse({ skills }));
  }),
);

router.post(
  '/skills/move',
  asyncHandler(async (req: Request, res: Response) => {
    const result = await moveUnifiedSkill(parseSkillMovePayload(req.body));
    res.json(createApiSuccessResponse(result));
  }),
);

router.delete(
  '/skills/:directoryName',
  asyncHandler(async (req: Request, res: Response) => {
    const directoryName = req.params.directoryName;
    if (typeof directoryName !== 'string') {
      throw new AppError('directoryName path parameter is invalid.', {
        code: 'INVALID_PATH_PARAMETER',
        statusCode: 400,
      });
    }
    res.json(createApiSuccessResponse(await removeUnifiedSkill(directoryName)));
  }),
);

router.post(
  '/skills/resync',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse(await resyncUnifiedSkills()));
  }),
);

// ----------------- Unified rules -----------------
router.get(
  '/rules',
  asyncHandler(async (req: Request, res: Response) => {
    const workspacePath = readOptionalString(req.query.workspacePath);
    const { sources, text } = await readUnifiedRules(workspacePath);
    const preview = await applyUnifiedPrefix('(preview)', workspacePath);
    res.json(createApiSuccessResponse({ sources, text, preview }));
  }),
);

// ----------------- Unified context (DCP-class) coverage -----------------
router.get(
  '/context',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse({ coverage: await getContextCoverage() }));
  }),
);

router.post(
  '/context/install-claude-hook',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse(await installClaudeHook()));
  }),
);

router.post(
  '/context/uninstall-claude-hook',
  asyncHandler(async (_req: Request, res: Response) => {
    res.json(createApiSuccessResponse(await uninstallClaudeHook()));
  }),
);

export default router;

import React, { memo, useMemo, useCallback } from 'react';

import type { Project } from '../../../types/app';
import type { SubagentChildTool } from '../types/types';

import { attachToolTitlePath, getToolConfig } from './configs/toolConfigs';
import { OneLineDisplay, BashCommandDisplay, CollapsibleDisplay, ToolDiffViewer, MarkdownContent, FileListContent, TodoListContent, TaskListContent, TextContent, QuestionAnswerContent, SubagentContainer } from './components';
import { PlanDisplay } from './components/PlanDisplay';
import { ToolStatusBadge } from './components/ToolStatusBadge';
import type { ToolStatus } from './components/ToolStatusBadge';

type DiffLine = {
  type: string;
  content: string;
  lineNum: number;
};

interface ToolRendererProps {
  toolName: string;
  toolInput: any;
  toolResult?: any;
  toolId?: string;
  mode: 'input' | 'result';
  onFileOpen?: (filePath: string, diffInfo?: any, line?: number) => void;
  createDiff?: (oldStr: string, newStr: string) => DiffLine[];
  selectedProject?: Project | null;
  showRawParameters?: boolean;
  rawToolInput?: string;
  isSubagentContainer?: boolean;
  subagentState?: {
    childTools: SubagentChildTool[];
    currentToolIndex: number;
    isComplete: boolean;
  };
}

// Exact denial messages from the Claude runtime adapter — other providers can't reliably signal denial
const CLAUDE_DENIAL_MESSAGES = [
  'user denied tool use',
  'tool disallowed by settings',
  'permission request timed out',
  'permission request cancelled',
];

function deriveToolStatus(toolResult: any): ToolStatus {
  if (!toolResult) return 'running';
  if (toolResult.isError) {
    const content = String(toolResult.content || '').toLowerCase().trim();
    if (CLAUDE_DENIAL_MESSAGES.some((msg) => content.includes(msg))) {
      return 'denied';
    }
    return 'error';
  }
  return 'completed';
}

/**
 * Main tool renderer router
 * Routes to OneLineDisplay or CollapsibleDisplay based on tool config
 */
export const ToolRenderer: React.FC<ToolRendererProps> = memo(({
  toolName,
  toolInput,
  toolResult,
  toolId,
  mode,
  onFileOpen,
  createDiff,
  selectedProject,
  showRawParameters = false,
  rawToolInput,
  isSubagentContainer,
  subagentState
}) => {
  const config = getToolConfig(toolName, toolId);
  const displayConfig: any = mode === 'input' ? config.input : config.result;

  const parsedData = useMemo(() => {
    const raw = mode === 'input' ? toolInput : toolResult;
    let data = raw;
    try {
      data = typeof raw === 'string' ? JSON.parse(raw) : raw;
    } catch {
      // Non-JSON payloads (raw provider strings) stay as they are.
    }
    // Devin titles carry the edited path ("Wrote ./src/a.ts") while the payload
    // holds only the content; fold it in so the file configs can open the diff.
    return mode === 'input' ? attachToolTitlePath(data, toolName) : data;
  }, [mode, toolInput, toolResult, toolName]);

  // Only derive and show status badge on input renders
  const toolStatus = useMemo(
    () => mode === 'input' ? deriveToolStatus(toolResult) : undefined,
    [mode, toolResult],
  );

  const handleAction = useCallback(() => {
    if (displayConfig?.action === 'open-file' && onFileOpen) {
      const value = displayConfig.getValue?.(parsedData) || '';
      onFileOpen(value);
    }
  }, [displayConfig, parsedData, onFileOpen]);

  // Route subagent containers to dedicated component (after hooks to satisfy Rules of Hooks)
  if (isSubagentContainer && subagentState) {
    if (mode === 'result') return null;
    return (
      <SubagentContainer
        toolInput={toolInput}
        toolResult={toolResult}
        subagentState={subagentState}
      />
    );
  }

  if (!displayConfig) return null;

  // Bash renders as a Codex-style command row: the command on a single line with
  // a chevron that expands to show the output inline. The combined view lives on
  // the input render; the separate result section is suppressed in MessageComponent.
  if (toolName === 'Bash' && mode === 'input') {
    const command = typeof parsedData === 'object' && parsedData !== null && 'command' in parsedData
      ? String(parsedData.command || '')
      : typeof toolInput === 'string'
        ? toolInput
        : typeof rawToolInput === 'string'
          ? rawToolInput
          : '';
    const description = typeof parsedData === 'object' && parsedData !== null && 'description' in parsedData
      ? String(parsedData.description || '')
      : undefined;
    const output = typeof toolResult?.content === 'string'
      ? toolResult.content
      : toolResult?.content != null
        ? String(toolResult.content)
        : '';
    return (
      <BashCommandDisplay
        command={command}
        description={description}
        output={output}
        isError={Boolean(toolResult?.isError)}
        status={toolStatus !== 'completed' ? toolStatus : undefined}
        toolId={toolId}
        // Commands stay collapsed by default — including failures; the status
        // badge marks errors and the output expands via the chevron.
        defaultOpen={false}
      />
    );
  }

  if (displayConfig.type === 'one-line') {
    const value = displayConfig.getValue?.(parsedData) || '';
    const secondary = displayConfig.getSecondary?.(parsedData);

    let resultContent: React.ReactNode | undefined;
    let inlineResultOpen = false;

    if (mode === 'input' && toolResult && config.result?.inline) {
      inlineResultOpen = config.result.defaultOpen ?? false;

      // No output means nothing to reveal: `OneLineDisplay` grows a chevron and
      // an expandable panel for any non-null result content, so an empty result
      // must stay undefined or the row expands into a blank box.
      if (toolResult.isError) {
        const errorContent = String(toolResult.content || '');
        resultContent = errorContent.trim() ? (
          <TextContent
            content={errorContent}
            format="code"
            className="border-red-500/30 bg-red-50/50 text-red-700 dark:bg-red-950/10 dark:text-red-300"
          />
        ) : undefined;
      } else if (config.result.getContentProps) {
        let parsedResult: any = toolResult;
        if (typeof toolResult === 'string') {
          try {
            parsedResult = JSON.parse(toolResult);
          } catch {
            // keep as string
          }
        }
        const contentProps = config.result.getContentProps(parsedResult) || {};
        const textContent = String(contentProps.content || '');

        if ((config.result.contentType === 'text' || !config.result.contentType) && textContent.trim()) {
          resultContent = (
            <TextContent
              content={textContent}
              format="plain"
            />
          );
        }
      }
    }

    return (
      <OneLineDisplay
        toolName={toolName}
        toolResult={toolResult}
        toolId={toolId}
        icon={displayConfig.icon}
        label={displayConfig.label}
        value={value}
        secondary={secondary}
        action={displayConfig.action}
        onAction={handleAction}
        wrapText={displayConfig.wrapText}
        colorScheme={displayConfig.colorScheme}
        resultId={mode === 'input' ? `tool-result-${toolId}` : undefined}
        status={toolStatus !== 'completed' ? toolStatus : undefined}
        showRawParameters={mode === 'input' ? showRawParameters : false}
        rawContent={mode === 'input' ? rawToolInput : undefined}
        resultContent={resultContent}
        resultOpen={inlineResultOpen}
      />
    );
  }

  if (displayConfig.type === 'plan') {
    const title = typeof displayConfig.title === 'function'
      ? displayConfig.title(parsedData)
      : displayConfig.title || 'Plan';

    const contentProps = displayConfig.getContentProps?.(parsedData, {
      selectedProject,
      createDiff,
      onFileOpen
    }) || {};

    const isStreaming = mode === 'input' && !toolResult;

    return (
      <PlanDisplay
        title={title}
        content={contentProps.content || ''}
        defaultOpen={displayConfig.defaultOpen ?? false}
        isStreaming={isStreaming}
        showRawParameters={mode === 'input' && showRawParameters}
        rawContent={rawToolInput}
        toolName={toolName}
        toolId={toolId}
      />
    );
  }

  if (displayConfig.type === 'collapsible') {
    const title = typeof displayConfig.title === 'function'
      ? displayConfig.title(parsedData)
      : displayConfig.title || 'Details';

    const defaultOpen = displayConfig.defaultOpen !== undefined
      ? displayConfig.defaultOpen
      : false;

    const contentProps = displayConfig.getContentProps?.(parsedData, {
      selectedProject,
      createDiff,
      onFileOpen
    }) || {};

    let contentComponent: React.ReactNode = null;

    switch (displayConfig.contentType) {
      case 'diff':
        if (createDiff) {
          contentComponent = (
            <ToolDiffViewer
              {...contentProps}
              createDiff={createDiff}
              onFileClick={(line) => onFileOpen?.(contentProps.filePath, undefined, line)}
              onOpenTestFile={onFileOpen ? (testPath) => onFileOpen(testPath, undefined, 1) : undefined}
              projectId={selectedProject?.projectId}
              projectRoot={selectedProject?.fullPath || selectedProject?.path}
            />
          );
        }
        break;

      case 'markdown':
        contentComponent = <MarkdownContent content={contentProps.content || ''} />;
        break;

      case 'file-list':
        contentComponent = (
          <FileListContent
            files={contentProps.files || []}
            onFileClick={onFileOpen}
            title={contentProps.title}
          />
        );
        break;

      case 'todo-list':
        if (contentProps.todos?.length > 0) {
          contentComponent = (
            <TodoListContent
              todos={contentProps.todos}
              isResult={contentProps.isResult}
            />
          );
        }
        break;

      case 'task':
        contentComponent = <TaskListContent content={contentProps.content || ''} />;
        break;

      case 'question-answer':
        contentComponent = (
          <QuestionAnswerContent
            questions={contentProps.questions || []}
            answers={contentProps.answers || {}}
          />
        );
        break;

      case 'text':
        contentComponent = (
          <TextContent
            content={contentProps.content || ''}
            format={contentProps.format || 'plain'}
          />
        );
        break;

      case 'success-message': {
        const msg = displayConfig.getMessage?.(parsedData) || 'Success';
        contentComponent = (
          <div className="flex items-center gap-1.5 text-xs text-green-600 dark:text-green-400">
            <svg className="h-3 w-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M5 13l4 4L19 7" />
            </svg>
            {msg}
          </div>
        );
        break;
      }
    }

    const handleTitleClick = (toolName === 'Edit' || toolName === 'Write' || toolName === 'ApplyPatch') && contentProps.filePath && onFileOpen
      ? () => onFileOpen(contentProps.filePath, {
          old_string: contentProps.oldContent,
          new_string: contentProps.newContent
        })
      : undefined;

    const badgeElement = toolStatus && toolStatus !== 'completed' ? <ToolStatusBadge status={toolStatus} /> : undefined;

    return (
      <CollapsibleDisplay
        toolName={toolName}
        toolId={toolId}
        title={title}
        defaultOpen={defaultOpen}
        onTitleClick={handleTitleClick}
        badge={badgeElement}
        showRawParameters={mode === 'input' && showRawParameters}
        rawContent={rawToolInput}
      >
        {contentComponent}
      </CollapsibleDisplay>
    );
  }

  return null;
});

ToolRenderer.displayName = 'ToolRenderer';

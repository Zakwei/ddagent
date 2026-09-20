/**
 * Centralized tool configuration registry
 * Defines display behavior for all tool types 
 */

export interface ToolDisplayConfig {
  input: {
    type: 'one-line' | 'collapsible' | 'plan' | 'hidden';
    // One-line config
    icon?: string;
    label?: string;
    getValue?: (input: any) => string;
    getSecondary?: (input: any) => string | undefined;
    action?: 'copy' | 'open-file' | 'jump-to-results' | 'none';
    wrapText?: boolean;
    colorScheme?: {
      primary?: string;
      secondary?: string;
      background?: string;
      border?: string;
      icon?: string;
    };
    // Collapsible config
    title?: string | ((input: any) => string);
    defaultOpen?: boolean;
    contentType?: 'diff' | 'markdown' | 'file-list' | 'todo-list' | 'text' | 'task' | 'question-answer';
    getContentProps?: (input: any, helpers?: any) => any;
    actionButton?: 'file-button' | 'none';
  };
  result?: {
    hidden?: boolean;
    hideOnSuccess?: boolean;
    inline?: boolean;
    type?: 'one-line' | 'collapsible' | 'plan' | 'special';
    title?: string | ((result: any) => string);
    defaultOpen?: boolean;
    // Special result handlers
    contentType?: 'markdown' | 'file-list' | 'todo-list' | 'text' | 'success-message' | 'task' | 'question-answer';
    getMessage?: (result: any) => string;
    getContentProps?: (result: any) => any;
  };
}

// Helpers for tool inputs that arrive from different provider runtimes.
// OpenCode uses camelCase (`filePath`, `oldString`, `newString`) while
// Devin/Claude historically use snake_case (`file_path`, `old_string`,
// `new_string`). We accept both without adding new surface.
const getFilePath = (input: any) => input?.file_path || input?.filePath || '';
const getOldString = (input: any) => input?.old_string || input?.oldString || '';
const getNewString = (input: any) => input?.new_string || input?.newString || '';
const getReadOffset = (input: any) => input?.offset ?? input?.startLine ?? '';

/**
 * Devin's ACP tool titles prefix the verb and sometimes the target path
 * ("Wrote ./src/a.ts", "Edited src/a.ts") while the payload may hold only the
 * file content. Resolving the leading verb lets those rows reuse the Edit /
 * Write / ApplyPatch configs.
 */
const TOOL_TITLE_VERB_ALIASES: Record<string, string> = {
  wrote: 'Write',
  write: 'Write',
  created: 'Write',
  edited: 'Edit',
  edit: 'Edit',
  patched: 'ApplyPatch',
};

/**
 * Folds the path carried by an ACP tool title into the tool input, so the file
 * configs can title the row and open the file diff from it.
 */
export function attachToolTitlePath(input: unknown, toolName: string): unknown {
  if (!input || typeof input !== 'object' || Array.isArray(input)) return input;

  const record = input as Record<string, unknown>;
  if (record.file_path || record.filePath) return input;

  const match = /^(?:wrote|write|created|edited|patched)\s+(\S+)$/i.exec(toolName.trim());
  if (!match || !/[/.]/.test(match[1])) return input;

  return { ...record, file_path: match[1] };
}

export const TOOL_CONFIGS: Record<string, ToolDisplayConfig> = {
  // ============================================================================
  // COMMAND TOOLS
  // ============================================================================

  Bash: {
    input: {
      type: 'one-line',
      icon: 'terminal',
      getValue: (input) => input.command,
      getSecondary: (input) => input.description,
      action: 'copy',
      wrapText: true,
      colorScheme: {
        primary: 'text-green-400 font-mono',
        secondary: 'text-gray-400',
        background: '',
        border: 'border-green-500 dark:border-green-400',
        icon: 'text-green-500 dark:text-green-400'
      }
    },
    result: {
      hideOnSuccess: true,
      type: 'special'
    }
  },

  // ============================================================================
  // FILE OPERATION TOOLS
  // ============================================================================

  Read: {
    input: {
      type: 'one-line',
      label: 'Read',
      getValue: (input) => getFilePath(input),
      getSecondary: (input) => {
        const offset = getReadOffset(input);
        return offset ? `at ${offset}` : undefined;
      },
      action: 'open-file',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        background: '',
        border: 'border-gray-300 dark:border-gray-600',
        icon: 'text-gray-500 dark:text-gray-400'
      }
    },
    result: {
      hidden: true
    }
  },

  Edit: {
    input: {
      type: 'collapsible',
      title: (input) => {
        const path = getFilePath(input);
        const filename = path?.split('/').pop() || path || 'file';
        return `${filename}`;
      },
      defaultOpen: false,
      contentType: 'diff',
      actionButton: 'none',
      getContentProps: (input) => ({
        oldContent: getOldString(input),
        newContent: getNewString(input),
        filePath: getFilePath(input),
        badge: 'Edit',
        badgeColor: 'gray'
      })
    },
    result: {
      hideOnSuccess: true
    }
  },

  Write: {
    input: {
      type: 'collapsible',
      title: (input) => {
        const path = getFilePath(input);
        const filename = path?.split('/').pop() || path || 'file';
        return `${filename}`;
      },
      defaultOpen: false,
      contentType: 'diff',
      actionButton: 'none',
      getContentProps: (input) => ({
        oldContent: '',
        newContent: input?.content || input?.contentText || '',
        filePath: getFilePath(input),
        badge: 'New',
        badgeColor: 'green'
      })
    },
    result: {
      hideOnSuccess: true
    }
  },

  ApplyPatch: {
    input: {
      type: 'collapsible',
      title: (input) => {
        const path = getFilePath(input);
        const filename = path?.split('/').pop() || path || 'file';
        return `${filename}`;
      },
      defaultOpen: false,
      contentType: 'diff',
      actionButton: 'none',
      getContentProps: (input) => ({
        oldContent: getOldString(input),
        newContent: getNewString(input),
        filePath: getFilePath(input),
        badge: 'Patch',
        badgeColor: 'gray'
      })
    },
    result: {
      hideOnSuccess: true
    }
  },

  // OpenCode / newer runtimes sometimes emit an explicit "ready" or "Ready"
  // status tool with no visible payload. Show at least the tool status so
  // the row is not empty.
  Ready: {
    input: {
      type: 'one-line',
      label: 'Ready',
      getValue: (input) => input?.message || input?.status || input?.text || 'Ready',
      colorScheme: {
        primary: 'text-gray-500 dark:text-gray-400',
        background: '',
        border: 'border-gray-300 dark:border-gray-600',
        icon: 'text-gray-500 dark:text-gray-400'
      }
    },
    result: {
      hidden: true
    }
  },

  // ============================================================================
  // SEARCH TOOLS
  // ============================================================================

  Grep: {
    input: {
      type: 'one-line',
      label: 'Grep',
      getValue: (input) => input.pattern || input.query,
      getSecondary: (input) => input.path ? `in ${input.path}` : undefined,
      action: 'jump-to-results',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        secondary: 'text-gray-500 dark:text-gray-400',
        background: '',
        border: 'border-gray-400 dark:border-gray-500',
        icon: 'text-gray-500 dark:text-gray-400'
      }
    },
    result: {
      type: 'collapsible',
      defaultOpen: false,
      title: (result) => {
        const toolData = result.toolUseResult || {};
        const count = toolData.numFiles || toolData.filenames?.length || 0;
        return `Found ${count} ${count === 1 ? 'file' : 'files'}`;
      },
      contentType: 'file-list',
      getContentProps: (result) => {
        const toolData = result.toolUseResult || {};
        return {
          files: toolData.filenames || []
        };
      }
    }
  },

  Glob: {
    input: {
      type: 'one-line',
      label: 'Glob',
      getValue: (input) => input.pattern,
      getSecondary: (input) => input.path ? `in ${input.path}` : undefined,
      action: 'jump-to-results',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        secondary: 'text-gray-500 dark:text-gray-400',
        background: '',
        border: 'border-gray-400 dark:border-gray-500',
        icon: 'text-gray-500 dark:text-gray-400'
      }
    },
    result: {
      type: 'collapsible',
      defaultOpen: false,
      title: (result) => {
        const toolData = result.toolUseResult || {};
        const count = toolData.numFiles || toolData.filenames?.length || 0;
        return `Found ${count} ${count === 1 ? 'file' : 'files'}`;
      },
      contentType: 'file-list',
      getContentProps: (result) => {
        const toolData = result.toolUseResult || {};
        return {
          files: toolData.filenames || []
        };
      }
    }
  },

  // ============================================================================
  // TODO TOOLS
  // ============================================================================

  TodoWrite: {
    input: {
      type: 'collapsible',
      title: 'Updating todo list',
      defaultOpen: false,
      contentType: 'todo-list',
      getContentProps: (input) => ({
        todos: input.todos
      })
    },
    result: {
      type: 'collapsible',
      contentType: 'success-message',
      getMessage: () => 'Todo list updated'
    }
  },

  TodoRead: {
    input: {
      type: 'one-line',
      label: 'TodoRead',
      getValue: () => 'reading list',
      action: 'none',
      colorScheme: {
        primary: 'text-gray-500 dark:text-gray-400',
        border: 'border-violet-400 dark:border-violet-500'
      }
    },
    result: {
      type: 'collapsible',
      contentType: 'todo-list',
      getContentProps: (result) => {
        try {
          const content = String(result.content || '');
          let todos = null;
          if (content.startsWith('[')) {
            todos = JSON.parse(content);
          }
          return { todos, isResult: true };
        } catch (e) {
          console.warn('Failed to parse todo list content:', e);
          return { todos: [], isResult: true };
        }
      }
    }
  },

  // ============================================================================
  // TASK TOOLS (TaskCreate, TaskUpdate, TaskList, TaskGet)
  // ============================================================================

  TaskCreate: {
    input: {
      type: 'one-line',
      label: 'Task',
      getValue: (input) => input.subject || 'Creating task',
      getSecondary: (input) => input.status || undefined,
      action: 'none',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        border: 'border-violet-400 dark:border-violet-500',
        icon: 'text-violet-500 dark:text-violet-400'
      }
    },
    result: {
      hideOnSuccess: true
    }
  },

  TaskUpdate: {
    input: {
      type: 'one-line',
      label: 'Task',
      getValue: (input) => {
        const parts = [];
        if (input.taskId) parts.push(`#${input.taskId}`);
        if (input.status) parts.push(input.status);
        if (input.subject) parts.push(`"${input.subject}"`);
        return parts.join(' → ') || 'updating';
      },
      action: 'none',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        border: 'border-violet-400 dark:border-violet-500',
        icon: 'text-violet-500 dark:text-violet-400'
      }
    },
    result: {
      hideOnSuccess: true
    }
  },

  TaskList: {
    input: {
      type: 'one-line',
      label: 'Tasks',
      getValue: () => 'listing tasks',
      action: 'none',
      colorScheme: {
        primary: 'text-gray-500 dark:text-gray-400',
        border: 'border-violet-400 dark:border-violet-500',
        icon: 'text-violet-500 dark:text-violet-400'
      }
    },
    result: {
      type: 'collapsible',
      defaultOpen: true,
      title: 'Task list',
      contentType: 'task',
      getContentProps: (result) => ({
        content: String(result?.content || '')
      })
    }
  },

  TaskGet: {
    input: {
      type: 'one-line',
      label: 'Task',
      getValue: (input) => input.taskId ? `#${input.taskId}` : 'fetching',
      action: 'none',
      colorScheme: {
        primary: 'text-gray-700 dark:text-gray-300',
        border: 'border-violet-400 dark:border-violet-500',
        icon: 'text-violet-500 dark:text-violet-400'
      }
    },
    result: {
      type: 'collapsible',
      defaultOpen: true,
      title: 'Task details',
      contentType: 'task',
      getContentProps: (result) => ({
        content: String(result?.content || '')
      })
    }
  },

  // ============================================================================
  // SUBAGENT TASK TOOL
  // ============================================================================

  Task: {
    input: {
      type: 'collapsible',
      title: (input) => {
        const subagentType = input.subagent_type || 'Agent';
        const description = input.description || 'Running task';
        return `Subagent / ${subagentType}: ${description}`;
      },
      defaultOpen: false,
      contentType: 'markdown',
      getContentProps: (input) => {
        // If only prompt exists (and required fields), show just the prompt
        // Otherwise show all available fields
        const hasOnlyPrompt = input.prompt &&
          !input.model &&
          !input.resume;

        if (hasOnlyPrompt) {
          return {
            content: input.prompt || ''
          };
        }

        // Format multiple fields
        const parts = [];

        if (input.model) {
          parts.push(`**Model:** ${input.model}`);
        }

        if (input.prompt) {
          parts.push(`**Prompt:**\n${input.prompt}`);
        }

        if (input.resume) {
          parts.push(`**Resuming from:** ${input.resume}`);
        }

        return {
          content: parts.join('\n\n')
        };
      },
      colorScheme: {
        border: 'border-purple-500 dark:border-purple-400',
        icon: 'text-purple-500 dark:text-purple-400'
      }
    },
    result: {
      type: 'collapsible',
      title: 'Subagent result',
      defaultOpen: false,
      contentType: 'markdown',
      getContentProps: (result) => {
        // Handle agent results which may have complex structure
        if (result && result.content) {
          let content = result.content;
          // If content is a JSON string, try to parse it (agent results may arrive serialized)
          if (typeof content === 'string') {
            try {
              const parsed = JSON.parse(content);
              if (Array.isArray(parsed)) {
                content = parsed;
              }
            } catch {
              // Not JSON — use as-is
              return { content };
            }
          }
          // If content is an array (typical for agent responses with multiple text blocks)
          if (Array.isArray(content)) {
            const textContent = content
              .filter((item: any) => item.type === 'text')
              .map((item: any) => item.text)
              .join('\n\n');
            return { content: textContent || 'No response text' };
          }
          return { content: String(content) };
        }
        // Fallback to string representation
        return { content: String(result || 'No response') };
      }
    }
  },

  // ============================================================================
  // INTERACTIVE TOOLS
  // ============================================================================

  AskUserQuestion: {
    input: {
      type: 'collapsible',
      title: (input: any) => {
        const count = input.questions?.length || 0;
        const hasAnswers = input.answers && Object.keys(input.answers).length > 0;
        if (count === 1) {
          const header = input.questions[0]?.header || 'Question';
          return hasAnswers ? `${header} — answered` : header;
        }
        return hasAnswers ? `${count} questions — answered` : `${count} questions`;
      },
      defaultOpen: true,
      contentType: 'question-answer',
      getContentProps: (input: any) => ({
        questions: input.questions || [],
        answers: input.answers || {}
      }),
    },
    result: {
      hideOnSuccess: true
    }
  },

  // ============================================================================
  // PLAN TOOLS
  // ============================================================================

  exit_plan_mode: {
    input: {
      type: 'plan',
      title: 'Implementation plan',
      defaultOpen: true,
      contentType: 'markdown',
      getContentProps: (input) => ({
        content: input.plan?.replace(/\\n/g, '\n') || input.plan
      })
    },
    result: {
      hidden: true
    }
  },

  // Also register as ExitPlanMode (the actual tool name used by Claude)
  ExitPlanMode: {
    input: {
      type: 'plan',
      title: 'Implementation plan',
      defaultOpen: true,
      contentType: 'markdown',
      getContentProps: (input) => ({
        content: input.plan?.replace(/\\n/g, '\n') || input.plan
      })
    },
    result: {
      hidden: true
    }
  },

  // ============================================================================
  // DEFAULT FALLBACK
  // ============================================================================

  Default: {
    input: {
      type: 'one-line',
      wrapText: true,
      getValue: (input) => {
        if (input == null) return '';

        if (typeof input === 'string') {
          return input.length > 120 ? `${input.slice(0, 120)}…` : input;
        }

        if (Array.isArray(input)) {
          const text = input
            .map((item) => (typeof item === 'string' ? item : JSON.stringify(item)))
            .join(', ');
          return text.length > 120 ? `${text.slice(0, 120)}…` : text;
        }

        if (typeof input === 'object') {
          const keys = Object.keys(input);

          for (const key of keys) {
            const value = (input as Record<string, unknown>)[key];

            if (typeof value === 'string' && value.trim()) {
              return value.length > 120 ? `${value.slice(0, 120)}…` : value;
            }

            if (typeof value === 'number' || typeof value === 'boolean') {
              return `${key}=${value}`;
            }
          }

          const json = JSON.stringify(input);
          return json.length > 120 ? `${json.slice(0, 120)}…` : json;
        }

        return String(input).slice(0, 120);
      },
      getSecondary: (input) => {
        if (input && typeof input === 'object' && !Array.isArray(input)) {
          const count = Object.keys(input).length;
          return count > 0 ? `${count} param${count === 1 ? '' : 's'}` : undefined;
        }
        return undefined;
      },
      colorScheme: {
        border: 'border-border',
        icon: 'text-muted-foreground',
        primary: 'text-foreground',
        secondary: 'text-muted-foreground'
      }
    },
    result: {
      type: 'collapsible',
      title: 'Result',
      defaultOpen: false,
      inline: true,
      contentType: 'text',
      getContentProps: (result) => {
        let content = result?.content || '';

        // Handle MCP format: array of objects with type and text fields
        if (typeof content === 'string') {
          try {
            const parsed = JSON.parse(content);
            if (Array.isArray(parsed)) {
              const textParts = parsed
                .filter((p: any) => p.type === 'text' && p.text)
                .map((p: any) => p.text);
              if (textParts.length > 0) {
                content = textParts.join('\n');
              }
            }
          } catch {
            // Not JSON or not MCP format, use as-is
          }
        } else if (Array.isArray(content)) {
          const textParts = content
            .filter((p: any) => p.type === 'text' && p.text)
            .map((p: any) => p.text);
          if (textParts.length > 0) {
            content = textParts.join('\n');
          } else {
            content = JSON.stringify(content, null, 2);
          }
        } else if (typeof content === 'object' && content !== null) {
          content = JSON.stringify(content, null, 2);
        }

        return {
          content: String(content),
          format: 'plain'
        };
      }
    }
  },
};

const TOOL_NAME_ALIASES: Record<string, string> = {
  edit: 'Edit',
  edits: 'Edit',
  write: 'Write',
  apply_patch: 'ApplyPatch',
  'apply-patch': 'ApplyPatch',
  applypatch: 'ApplyPatch',
  patch: 'ApplyPatch',
  read: 'Read',
  ready: 'Ready',
  bash: 'Bash',
  exec: 'Bash',
  shell: 'Bash',
  sh: 'Bash',
  grep: 'Grep',
  glob: 'Glob',
  todo_write: 'TodoWrite',
  todowrite: 'TodoWrite',
  todo_read: 'TodoRead',
  todoread: 'TodoRead',
  task_create: 'TaskCreate',
  taskcreate: 'TaskCreate',
  task_update: 'TaskUpdate',
  taskupdate: 'TaskUpdate',
  task_list: 'TaskList',
  tasklist: 'TaskList',
  task_get: 'TaskGet',
  taskget: 'TaskGet',
  agent: 'Task',
  plan: 'Plan',
  exit_plan_mode: 'ExitPlanMode',
  exitplanmode: 'ExitPlanMode',
  ask_user_question: 'AskUserQuestion',
  askuserquestion: 'AskUserQuestion',
};

function parseToolId(toolId?: string): string | undefined {
  if (!toolId) return undefined;
  const withoutSuffix = toolId.replace(/:\d+$/, '');
  const withoutFunctions = withoutSuffix.replace(/^functions\./, '');
  return withoutFunctions || undefined;
}

export function resolveToolName(toolName: string, toolId?: string): string {
  const name = toolName.trim();
  if (TOOL_CONFIGS[name]) return name;

  const lower = name.toLowerCase();
  const compact = lower.replace(/[\s_-]+/g, '');
  const snake = lower.replace(/[\s-]+/g, '_');
  const alias = TOOL_NAME_ALIASES[lower] || TOOL_NAME_ALIASES[compact] || TOOL_NAME_ALIASES[snake];
  if (alias && TOOL_CONFIGS[alias]) return alias;

  // "Wrote ./src/a.ts", "Edit file" — the leading verb names the file action.
  const verbAlias = TOOL_TITLE_VERB_ALIASES[lower.split(/\s+/)[0]];
  if (verbAlias && TOOL_CONFIGS[verbAlias]) return verbAlias;

  const fromId = parseToolId(toolId);
  if (fromId) {
    if (TOOL_CONFIGS[fromId]) return fromId;
    const idLower = fromId.toLowerCase();
    const idCompact = idLower.replace(/_/g, '');
    const idSnake = idLower.replace(/-/g, '_');
    const idAlias = TOOL_NAME_ALIASES[idLower] || TOOL_NAME_ALIASES[idCompact] || TOOL_NAME_ALIASES[idSnake];
    if (idAlias && TOOL_CONFIGS[idAlias]) return idAlias;
  }

  return name;
}

/**
 * Get configuration for a tool, with fallback to default
 */
export function getToolConfig(toolName: string, toolId?: string): ToolDisplayConfig {
  const name = resolveToolName(toolName, toolId);
  return TOOL_CONFIGS[name] || TOOL_CONFIGS.Default;
}

/**
 * Check if a tool result should be hidden
 */
export function shouldHideToolResult(toolName: string, toolResult: any, toolId?: string): boolean {
  const config = getToolConfig(toolName, toolId);

  if (!config.result) return false;

  // Hidden/success-only configs suppress noisy successful output, but errors
  // still need to be visible so failed tool calls are diagnosable.
  if (toolResult?.isError) return false;

  // Always hidden
  if (config.result.hidden) return true;

  // Hide on success only
  if (config.result.hideOnSuccess && toolResult) {
    return true;
  }

  return false;
}

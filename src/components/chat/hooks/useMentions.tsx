import { useCallback, useEffect, useMemo, useState } from 'react';
import type { Dispatch, KeyboardEvent, RefObject, SetStateAction } from 'react';

import { api, authenticatedFetch } from '../../../utils/api';
import { escapeRegExp } from '../utils/chatFormatting';
import type { Project } from '../../../types/app';

export type MentionType = 'file' | 'session' | 'task';

export interface MentionableItem {
  id: string;
  title: string;
  type: MentionType;
  value: string;
  subtitle?: string;
}

interface ProjectFileNode {
  name: string;
  type: 'file' | 'directory';
  path?: string;
  children?: ProjectFileNode[];
}

interface RecentConversationApiItem {
  sessionId?: string;
  sessionTitle?: string | null;
  title?: string | null;
  summary?: string | null;
  name?: string | null;
  [key: string]: unknown;
}

interface TaskMasterMentionTask {
  id: string | number;
  title?: string | null;
  status?: string | null;
  [key: string]: unknown;
}

interface UseMentionsOptions {
  selectedProject: Project | null;
  input: string;
  setInput: Dispatch<SetStateAction<string>>;
  textareaRef: RefObject<HTMLTextAreaElement>;
}

const flattenFileTree = (files: ProjectFileNode[], basePath = ''): MentionableItem[] => {
  let flattened: MentionableItem[] = [];

  files.forEach((file) => {
    const fullPath = basePath ? `${basePath}/${file.name}` : file.name;
    if (file.type === 'directory' && file.children) {
      flattened = flattened.concat(flattenFileTree(file.children, fullPath));
      return;
    }

    if (file.type === 'file') {
      flattened.push({
        id: fullPath,
        title: file.name,
        type: 'file',
        value: fullPath,
        subtitle: file.path ?? fullPath,
      });
    }
  });

  return flattened;
};

const isOpenTask = (status?: string | null) => {
  if (!status) return true;
  const closedStatuses = ['done', 'cancelled'];
  return !closedStatuses.includes(status);
};

export function useMentions({ selectedProject, input, setInput, textareaRef }: UseMentionsOptions) {
  const [fileList, setFileList] = useState<MentionableItem[]>([]);
  const [sessionList, setSessionList] = useState<MentionableItem[]>([]);
  const [taskList, setTaskList] = useState<MentionableItem[]>([]);
  const [mentionTokens, setMentionTokens] = useState<string[]>([]);
  const [filteredMentions, setFilteredMentions] = useState<MentionableItem[]>([]);
  const [showMentionDropdown, setShowMentionDropdown] = useState(false);
  const [selectedMentionIndex, setSelectedMentionIndex] = useState(-1);
  const [cursorPosition, setCursorPosition] = useState(0);
  const [atSymbolPosition, setAtSymbolPosition] = useState(-1);

  const mentionableItems = useMemo(
    () => [...sessionList, ...taskList, ...fileList],
    [fileList, sessionList, taskList],
  );

  // Fetch mentionable files for the selected project.
  useEffect(() => {
    const abortController = new AbortController();

    const fetchProjectFiles = async () => {
      const projectId = selectedProject?.projectId;
      setFileList([]);
      if (!projectId) {
        return;
      }

      try {
        const response = await api.getMentionableFiles(projectId, {
          signal: abortController.signal,
        });
        if (!response.ok) {
          return;
        }

        const files = (await response.json()) as ProjectFileNode[];
        setFileList(flattenFileTree(files));
      } catch (error) {
        if ((error as { name?: string })?.name === 'AbortError') {
          return;
        }
        console.error('Error fetching mentionable files:', error);
      }
    };

    fetchProjectFiles();
    return () => {
      abortController.abort();
    };
  }, [selectedProject?.projectId]);

  // Fetch recent sessions globally.
  useEffect(() => {
    let isCancelled = false;

    const fetchRecentSessions = async () => {
      try {
        const response = await api.recentConversations({ limit: 40 });
        if (!response.ok || isCancelled) {
          return;
        }

        const payload = (await response.json()) as
          | { data?: { conversations?: RecentConversationApiItem[] } }
          | { conversations?: RecentConversationApiItem[] }
          | RecentConversationApiItem[];

        const conversations = Array.isArray(payload)
          ? payload
          : (payload as { data?: { conversations?: RecentConversationApiItem[] } }).data
              ?.conversations ??
            (payload as { conversations?: RecentConversationApiItem[] }).conversations ??
            [];

        const mapped: MentionableItem[] = conversations
          .filter((conversation) => Boolean(conversation.sessionId))
          .map((conversation) => {
            const title =
              conversation.sessionTitle ||
              conversation.title ||
              conversation.summary ||
              conversation.name ||
              `Session ${conversation.sessionId}`;

            return {
              id: conversation.sessionId as string,
              title: title || `Session ${conversation.sessionId}`,
              type: 'session',
              value: title || `Session ${conversation.sessionId}`,
            };
          });

        if (!isCancelled) {
          setSessionList(mapped);
        }
      } catch (error) {
        if ((error as { name?: string })?.name === 'AbortError') {
          return;
        }
        console.error('Error fetching recent sessions:', error);
      }
    };

    fetchRecentSessions();
    return () => {
      isCancelled = true;
    };
  }, []);

  // Fetch open TaskMaster tasks for the selected project.
  useEffect(() => {
    const abortController = new AbortController();

    const fetchOpenTasks = async () => {
      const projectId = selectedProject?.projectId;
      setTaskList([]);
      if (!projectId) {
        return;
      }

      try {
        const response = await authenticatedFetch(
          `/api/taskmaster/tasks/${encodeURIComponent(projectId)}`,
          {
            signal: abortController.signal,
          },
        );
        if (!response.ok) {
          return;
        }

        const payload = (await response.json()) as
          | { tasks?: TaskMasterMentionTask[] }
          | TaskMasterMentionTask[];
        const tasks = Array.isArray(payload) ? payload : payload.tasks ?? [];

        const mapped: MentionableItem[] = tasks
          .filter((task) => isOpenTask(task.status))
          .map((task) => {
            const title = task.title || `Task ${task.id}`;
            return {
              id: String(task.id),
              title,
              type: 'task',
              value: title,
              subtitle: task.status || undefined,
            };
          });

        setTaskList(mapped);
      } catch (error) {
        if ((error as { name?: string })?.name === 'AbortError') {
          return;
        }
        console.error('Error fetching open tasks:', error);
      }
    };

    fetchOpenTasks();
    return () => {
      abortController.abort();
    };
  }, [selectedProject?.projectId]);

  useEffect(() => {
    const textBeforeCursor = input.slice(0, cursorPosition);
    const lastAtIndex = textBeforeCursor.lastIndexOf('@');

    if (lastAtIndex === -1) {
      setShowMentionDropdown(false);
      setAtSymbolPosition(-1);
      return;
    }

    const textAfterAt = textBeforeCursor.slice(lastAtIndex + 1);
    // Spaces stay legal in the query so multi-word titles like
    // "Task 138: Desktop bug" remain searchable; a newline ends it.
    if (textAfterAt.includes('\n')) {
      setShowMentionDropdown(false);
      setAtSymbolPosition(-1);
      return;
    }

    setAtSymbolPosition(lastAtIndex);
    setSelectedMentionIndex(-1);

    const query = textAfterAt.toLowerCase();

    // On a bare '@' (empty query) sessions/tasks would fill the top-15 slice
    // before a single file shows — surface files first so the picker reads as
    // the file picker it is ('@ for files').
    const orderedItems = query === ''
      ? mentionableItems.filter((mention) => mention.type === 'file')
          .concat(mentionableItems.filter((mention) => mention.type !== 'file'))
      : mentionableItems;

    const matchingMentions = orderedItems
      .filter(
        (mention) =>
          mention.title.toLowerCase().includes(query) ||
          (mention.subtitle && mention.subtitle.toLowerCase().includes(query)) ||
          mention.id.toLowerCase().includes(query),
      )
      .slice(0, 15);

    // A spaced query with no matches means the '@' was prose ("mail me
    // @some place"), not a mention attempt — close instead of holding the
    // dropdown open on every word.
    if (query.includes(' ') && matchingMentions.length === 0) {
      setShowMentionDropdown(false);
      setFilteredMentions([]);
      return;
    }

    setShowMentionDropdown(true);
    setFilteredMentions(matchingMentions);
  }, [input, cursorPosition, mentionableItems]);

  const activeMentions = useMemo(() => {
    if (!input || mentionTokens.length === 0) {
      return [];
    }
    return mentionTokens.filter((token) => input.includes(token));
  }, [mentionTokens, input]);

  const sortedMentions = useMemo(() => {
    if (activeMentions.length === 0) {
      return [];
    }
    const uniqueMentions = Array.from(new Set(activeMentions));
    return uniqueMentions.sort((mentionA, mentionB) => mentionB.length - mentionA.length);
  }, [activeMentions]);

  const mentionRegex = useMemo(() => {
    if (sortedMentions.length === 0) {
      return null;
    }
    const pattern = sortedMentions.map(escapeRegExp).join('|');
    return new RegExp(`(${pattern})`, 'g');
  }, [sortedMentions]);

  const mentionSet = useMemo(() => new Set(sortedMentions), [sortedMentions]);

  const renderInputWithMentions = useCallback(
    (text: string) => {
      if (!text) {
        return '';
      }
      if (!mentionRegex) {
        return text;
      }

      const parts = text.split(mentionRegex);
      return parts.map((part, index) =>
        mentionSet.has(part) ? (
          <span
            key={`mention-${index}`}
            className="-ml-0.5 rounded-md bg-blue-200/70 box-decoration-clone px-0.5 text-transparent dark:bg-blue-300/40"
          >
            {part}
          </span>
        ) : (
          <span key={`text-${index}`}>{part}</span>
        ),
      );
    },
    [mentionRegex, mentionSet],
  );

  const selectMention = useCallback(
    (mention: MentionableItem) => {
      const textBeforeAt = input.slice(0, atSymbolPosition);
      // The query runs from '@' to the cursor — it can span several words —
      // so everything after the cursor is preserved verbatim.
      const textAfterQuery = input.slice(cursorPosition);

      const value = `@${mention.value}`;
      const newInput = `${textBeforeAt}${value} ${textAfterQuery}`;
      const newCursorPosition = textBeforeAt.length + value.length + 1;

      if (textareaRef.current && !textareaRef.current.matches(':focus')) {
        textareaRef.current.focus();
      }

      setInput(newInput);
      setCursorPosition(newCursorPosition);
      setMentionTokens((previousMentions) =>
        previousMentions.includes(value) ? previousMentions : [...previousMentions, value],
      );

      setShowMentionDropdown(false);
      setAtSymbolPosition(-1);

      if (!textareaRef.current) {
        return;
      }

      requestAnimationFrame(() => {
        if (!textareaRef.current) {
          return;
        }
        textareaRef.current.setSelectionRange(newCursorPosition, newCursorPosition);
        if (!textareaRef.current.matches(':focus')) {
          textareaRef.current.focus();
        }
      });
    },
    [input, atSymbolPosition, cursorPosition, textareaRef, setInput],
  );

  const handleMentionsKeyDown = useCallback(
    (event: KeyboardEvent<HTMLTextAreaElement>): boolean => {
      if (!showMentionDropdown || filteredMentions.length === 0) {
        return false;
      }

      if (event.key === 'ArrowDown') {
        event.preventDefault();
        setSelectedMentionIndex((previousIndex) =>
          previousIndex < filteredMentions.length - 1 ? previousIndex + 1 : 0,
        );
        return true;
      }

      if (event.key === 'ArrowUp') {
        event.preventDefault();
        setSelectedMentionIndex((previousIndex) =>
          previousIndex > 0 ? previousIndex - 1 : filteredMentions.length - 1,
        );
        return true;
      }

      if (event.key === 'Tab' || event.key === 'Enter') {
        event.preventDefault();
        if (selectedMentionIndex >= 0) {
          selectMention(filteredMentions[selectedMentionIndex]);
        } else if (filteredMentions.length > 0) {
          selectMention(filteredMentions[0]);
        }
        return true;
      }

      if (event.key === 'Escape') {
        event.preventDefault();
        setShowMentionDropdown(false);
        return true;
      }

      return false;
    },
    [showMentionDropdown, filteredMentions, selectedMentionIndex, selectMention],
  );

  return {
    showMentionDropdown,
    filteredMentions,
    selectedMentionIndex,
    renderInputWithMentions,
    selectMention,
    setCursorPosition,
    handleMentionsKeyDown,
  };
}

// Backward-compatible alias for existing imports.
export const useFileMentions = useMentions;

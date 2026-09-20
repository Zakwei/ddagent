export type CodeEditorDiffInfo = {
  old_string?: string;
  new_string?: string;
  [key: string]: unknown;
};

export type CodeEditorFile = {
  name: string;
  path: string;
  // DB projectId; used by the editor to build `/api/file-tree/projects/:projectId/file`
  // URLs for reading and saving content.
  projectId?: string;
  diffInfo?: CodeEditorDiffInfo | null;
  // Optional line number to scroll to when opening the file from search or a link.
  line?: number;
  [key: string]: unknown;
};

export type CodeEditorSettingsState = {
  isDarkMode: boolean;
  wordWrap: boolean;
  minimapEnabled: boolean;
  showLineNumbers: boolean;
  fontSize: string;
};

/**
 * Native project-creation wizard (T27).
 *
 * Ports src/components/project-creation-wizard/* to React Native:
 * 2-step modal (Configure -> Confirm) with a server folder browser and an
 * optional GitHub clone workflow whose progress streams over SSE.
 */
import React, { useCallback, useEffect, useMemo, useState } from 'react';
import {
  ActivityIndicator,
  Modal,
  ScrollView,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import {
  AlertCircle,
  ChevronRight,
  Eye,
  EyeOff,
  Folder,
  FolderPlus,
  GitBranch,
  X,
} from 'lucide-react-native';
import { useTranslation } from 'react-i18next';
import { api } from '~shared/utils/api';
import { useTheme } from '../theme';
import { ActionSheet, type ActionSheetItem } from './ActionSheet';
import {
  authenticationLabel,
  getParentPath,
  isCloneWorkflow,
  isSshGitUrl,
  joinFolderPath,
  resolveCreateProjectError,
  shouldShowGithubAuthentication,
  validateWizardStep,
  type FolderSuggestion,
  type GithubCredential,
  type TokenMode,
} from '../lib/project-wizard';
import { streamCloneProgress } from '../lib/clone-stream';

type Colors = ReturnType<typeof useTheme>['colors'];

interface FolderBrowserModalProps {
  visible: boolean;
  colors: Colors;
  onClose: () => void;
  onSelect: (path: string) => void;
}

function FolderBrowserModal({ visible, colors, onClose, onSelect }: FolderBrowserModalProps) {
  const { t } = useTranslation();
  const [currentPath, setCurrentPath] = useState('~');
  const [folders, setFolders] = useState<FolderSuggestion[]>([]);
  const [showHidden, setShowHidden] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [newFolder, setNewFolder] = useState(false);
  const [newFolderName, setNewFolderName] = useState('');
  const [creating, setCreating] = useState(false);

  const browse = useCallback(async (path: string) => {
    setLoading(true);
    setError(null);
    try {
      const res = await (api.browseFilesystem as (p?: string) => ReturnType<typeof api.browseFilesystem>)(path);
      const body = await res.json();
      if (!res.ok) {
        setError(body?.error || `http-${res.status}`);
        return;
      }
      setCurrentPath(body?.path ?? path);
      setFolders(Array.isArray(body?.suggestions) ? body.suggestions : []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'failed');
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    if (visible) {
      setNewFolder(false);
      setNewFolderName('');
      void browse('~');
    }
  }, [visible, browse]);

  const visibleFolders = useMemo(
    () =>
      folders
        .filter((f) => showHidden || !f.name.startsWith('.'))
        .sort((a, b) => a.name.localeCompare(b.name)),
    [folders, showHidden],
  );
  const parent = getParentPath(currentPath);

  const submitNewFolder = async () => {
    const name = newFolderName.trim();
    if (!name || creating) return;
    setCreating(true);
    setError(null);
    try {
      const res = await api.createFolder(joinFolderPath(currentPath, name));
      const body = await res.json();
      if (!res.ok) {
        setError(body?.error || `http-${res.status}`);
        return;
      }
      setNewFolder(false);
      setNewFolderName('');
      await browse(body?.path ?? currentPath);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'failed');
    } finally {
      setCreating(false);
    }
  };

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onClose}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', alignItems: 'center', justifyContent: 'center', padding: 20 }}>
        <View style={{ backgroundColor: colors.card, borderRadius: 12, width: '100%', maxHeight: '80%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 14, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            <Text style={{ flex: 1, color: colors.foreground, fontWeight: '600' }}>Select Folder</Text>
            <TouchableOpacity onPress={() => setShowHidden((v) => !v)} hitSlop={8} style={{ padding: 6 }}>
              {showHidden ? <EyeOff color={colors.mutedForeground} size={18} /> : <Eye color={colors.mutedForeground} size={18} />}
            </TouchableOpacity>
            <TouchableOpacity onPress={() => setNewFolder((v) => !v)} hitSlop={8} style={{ padding: 6 }}>
              <FolderPlus color={colors.mutedForeground} size={18} />
            </TouchableOpacity>
            <TouchableOpacity onPress={onClose} hitSlop={8} style={{ padding: 6 }}>
              <X color={colors.mutedForeground} size={18} />
            </TouchableOpacity>
          </View>

          {newFolder && (
            <View style={{ flexDirection: 'row', gap: 8, paddingHorizontal: 12, paddingTop: 10 }}>
              <TextInput
                value={newFolderName}
                onChangeText={setNewFolderName}
                placeholder="New folder name"
                placeholderTextColor={colors.mutedForeground}
                autoCapitalize="none"
                autoCorrect={false}
                onSubmitEditing={() => void submitNewFolder()}
                style={{ flex: 1, backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8 }}
              />
              <TouchableOpacity onPress={() => void submitNewFolder()} style={{ justifyContent: 'center', paddingHorizontal: 10 }}>
                <Text style={{ color: colors.primary, fontWeight: '600' }}>{creating ? '…' : 'Create'}</Text>
              </TouchableOpacity>
              <TouchableOpacity onPress={() => { setNewFolder(false); setNewFolderName(''); }} style={{ justifyContent: 'center', paddingHorizontal: 6 }}>
                <Text style={{ color: colors.mutedForeground }}>Cancel</Text>
              </TouchableOpacity>
            </View>
          )}

          {error && <Text style={{ color: colors.destructive, paddingHorizontal: 12, paddingTop: 10 }}>{error}</Text>}

          <ScrollView style={{ maxHeight: 360 }} contentContainerStyle={{ padding: 8 }}>
            {loading && folders.length === 0 ? (
              <ActivityIndicator color={colors.primary} style={{ marginVertical: 24 }} />
            ) : (
              <>
                {parent !== null && (
                  <TouchableOpacity onPress={() => void browse(parent)} style={{ flexDirection: 'row', alignItems: 'center', gap: 8, padding: 10, borderRadius: 8 }}>
                    <Folder color={colors.mutedForeground} size={18} />
                    <Text style={{ color: colors.foreground }}>{'..'}</Text>
                  </TouchableOpacity>
                )}
                {visibleFolders.length === 0 && !loading && (
                  <Text style={{ color: colors.mutedForeground, textAlign: 'center', marginVertical: 20 }}>No subfolders found</Text>
                )}
                {visibleFolders.map((folder) => (
                  <View key={folder.path} style={{ flexDirection: 'row', alignItems: 'center' }}>
                    <TouchableOpacity onPress={() => void browse(folder.path)} style={{ flex: 1, flexDirection: 'row', alignItems: 'center', gap: 8, padding: 10, borderRadius: 8 }}>
                      <Folder color={colors.primary} size={18} />
                      <Text style={{ color: colors.foreground, flex: 1 }} numberOfLines={1}>{folder.name}</Text>
                    </TouchableOpacity>
                    <TouchableOpacity onPress={() => onSelect(folder.path)} style={{ paddingHorizontal: 10, paddingVertical: 8 }}>
                      <Text style={{ color: colors.primary, fontWeight: '600' }}>Select</Text>
                    </TouchableOpacity>
                  </View>
                ))}
              </>
            )}
          </ScrollView>

          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 12, borderTopWidth: 1, borderTopColor: colors.border }}>
            <Text style={{ flex: 1, color: colors.mutedForeground, fontSize: 12 }} numberOfLines={1}>{`Path: ${currentPath}`}</Text>
            <TouchableOpacity onPress={() => onSelect(currentPath)} style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 8 }}>
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>Use this folder</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

export interface ProjectWizardModalProps {
  visible: boolean;
  onClose: () => void;
  onCreated: () => void;
}

export default function ProjectWizardModal({ visible, onClose, onCreated }: ProjectWizardModalProps) {
  const { colors } = useTheme();
  const { t } = useTranslation();

  const [step, setStep] = useState<1 | 2>(1);
  const [workspacePath, setWorkspacePath] = useState('');
  const [githubUrl, setGithubUrl] = useState('');
  const [tokenMode, setTokenMode] = useState<TokenMode>('stored');
  const [selectedGithubToken, setSelectedGithubToken] = useState('');
  const [newGithubToken, setNewGithubToken] = useState('');
  const [tokens, setTokens] = useState<GithubCredential[]>([]);
  const [tokensLoading, setTokensLoading] = useState(false);
  const [tokensError, setTokensError] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [creating, setCreating] = useState(false);
  const [cloneProgress, setCloneProgress] = useState<string | null>(null);
  const [browserOpen, setBrowserOpen] = useState(false);
  const [tokenSheet, setTokenSheet] = useState(false);

  const showGithubAuth = shouldShowGithubAuthentication(githubUrl);
  const clone = isCloneWorkflow(githubUrl);

  useEffect(() => {
    if (!visible) {
      setStep(1);
      setWorkspacePath('');
      setGithubUrl('');
      setTokenMode('stored');
      setSelectedGithubToken('');
      setNewGithubToken('');
      setError(null);
      setCloneProgress(null);
      setCreating(false);
    }
  }, [visible]);

  useEffect(() => {
    if (!visible || !showGithubAuth) return;
    let cancelled = false;
    setTokensLoading(true);
    setTokensError(null);
    api
      .get('/settings/credentials?type=github_token')
      .then((res) => res.json())
      .then((body) => {
        if (cancelled) return;
        const list = (Array.isArray(body?.credentials) ? body.credentials : []).filter(
          (c: GithubCredential) => c?.is_active === true,
        );
        setTokens(list);
        if (list.length > 0 && !selectedGithubToken) {
          setSelectedGithubToken(String(list[0].id));
        }
      })
      .catch((err) => {
        if (!cancelled) setTokensError(err instanceof Error ? err.message : 'failed');
      })
      .finally(() => {
        if (!cancelled) setTokensLoading(false);
      });
    return () => {
      cancelled = true;
    };
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [visible, showGithubAuth]);

  const selectedTokenName = useMemo(() => {
    const found = tokens.find((tok) => String(tok.id) === selectedGithubToken);
    return found ? found.credential_name : null;
  }, [tokens, selectedGithubToken]);

  const authLabel = useMemo(() => {
    const label = authenticationLabel({
      tokenMode,
      selectedTokenName,
      newToken: newGithubToken,
      githubUrl,
    });
    switch (label.kind) {
      case 'ssh':
        return t('projectWizard.step3.sshKey', { defaultValue: 'SSH Key' });
      case 'stored':
        return t('projectWizard.step3.usingStoredToken', {
          name: label.name ?? 'Unknown',
          defaultValue: 'Using stored token: {{name}}',
        });
      case 'provided':
        return t('projectWizard.step3.usingProvidedToken', { defaultValue: 'Using provided token' });
      default:
        return t('projectWizard.step3.noAuthentication', { defaultValue: 'No authentication' });
    }
  }, [tokenMode, selectedTokenName, newGithubToken, githubUrl, t]);

  const handleNext = () => {
    const failure = validateWizardStep(workspacePath);
    if (failure) {
      setError(t('projectWizard.errors.providePath', { defaultValue: 'Please provide a workspace path.' }));
      return;
    }
    setError(null);
    setStep(2);
  };

  const handleCreate = async () => {
    const path = workspacePath.trim();
    setError(null);
    setCreating(true);
    setCloneProgress(null);

    if (!clone) {
      try {
        const res = await api.createProject({ path });
        const body = await res.json().catch(() => null);
        if (!res.ok || body?.success === false) {
          setError(resolveCreateProjectError(body, t('projectWizard.errors.failedToCreate', { defaultValue: 'Failed to create project.' })));
          setCreating(false);
          return;
        }
        onCreated();
        onClose();
      } catch (err) {
        setError(err instanceof Error ? err.message : 'failed');
      } finally {
        setCreating(false);
      }
      return;
    }

    streamCloneProgress(
      {
        path,
        githubUrl: githubUrl.trim(),
        tokenMode,
        selectedGithubToken: tokenMode === 'stored' ? selectedGithubToken : undefined,
        newGithubToken: tokenMode === 'new' ? newGithubToken : undefined,
      },
      {
        onProgress: (message) => setCloneProgress(message),
        onComplete: () => {
          setCreating(false);
          onCreated();
          onClose();
        },
        onError: (message) => {
          setCreating(false);
          setError(message || t('projectWizard.errors.failedToCreate', { defaultValue: 'Failed to create project.' }));
        },
      },
    );
  };

  const tokenItems: ActionSheetItem[] = tokens.map((tok) => ({
    label: tok.credential_name,
    onPress: () => setSelectedGithubToken(String(tok.id)),
  }));

  const modeButton = (mode: TokenMode, label: string) => {
    const active = tokenMode === mode;
    return (
      <TouchableOpacity
        key={mode}
        onPress={() => {
          setTokenMode(mode);
          if (mode === 'none') {
            setSelectedGithubToken('');
            setNewGithubToken('');
          }
        }}
        style={{
          flex: 1,
          alignItems: 'center',
          paddingVertical: 8,
          borderRadius: 8,
          backgroundColor: active ? colors.primary : colors.background,
          borderColor: colors.border,
          borderWidth: 1,
        }}
      >
        <Text style={{ color: active ? colors.primaryForeground : colors.foreground, fontSize: 12, fontWeight: '600' }}>{label}</Text>
      </TouchableOpacity>
    );
  };

  return (
    <Modal visible={visible} transparent animationType="slide" onRequestClose={() => { if (!creating) onClose(); }}>
      <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)', justifyContent: 'flex-end' }}>
        <View style={{ backgroundColor: colors.card, borderTopLeftRadius: 16, borderTopRightRadius: 16, maxHeight: '92%' }}>
          <View style={{ flexDirection: 'row', alignItems: 'center', padding: 16, borderBottomWidth: 1, borderBottomColor: colors.border }}>
            <FolderPlus color={colors.primary} size={20} />
            <Text style={{ flex: 1, color: colors.foreground, fontWeight: '700', fontSize: 16, marginLeft: 10 }}>
              {t('projectWizard.title', { defaultValue: 'New Project' })}
            </Text>
            <TouchableOpacity onPress={onClose} disabled={creating} hitSlop={8} style={{ padding: 6, opacity: creating ? 0.4 : 1 }}>
              <X color={colors.mutedForeground} size={20} />
            </TouchableOpacity>
          </View>

          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'center', gap: 8, paddingVertical: 10 }}>
            <Text style={{ color: step >= 1 ? colors.primary : colors.mutedForeground, fontWeight: '600', fontSize: 12 }}>
              {`1. ${t('projectWizard.steps.configure', { defaultValue: 'Configure' })}`}
            </Text>
            <ChevronRight color={colors.mutedForeground} size={14} />
            <Text style={{ color: step >= 2 ? colors.primary : colors.mutedForeground, fontWeight: '600', fontSize: 12 }}>
              {`2. ${t('projectWizard.steps.confirm', { defaultValue: 'Confirm' })}`}
            </Text>
          </View>

          {error && (
            <View style={{ flexDirection: 'row', gap: 8, alignItems: 'center', marginHorizontal: 16, marginBottom: 8, padding: 10, borderRadius: 8, backgroundColor: 'rgba(220,38,38,0.1)', borderWidth: 1, borderColor: colors.destructive }}>
              <AlertCircle color={colors.destructive} size={16} />
              <Text style={{ color: colors.destructive, flex: 1, fontSize: 12 }}>{error}</Text>
            </View>
          )}

          <ScrollView contentContainerStyle={{ padding: 16 }} keyboardShouldPersistTaps="handled">
            {step === 1 ? (
              <>
                <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 6 }}>
                  {t('projectWizard.step2.newPath', { defaultValue: 'Workspace path' })}
                </Text>
                <View style={{ flexDirection: 'row', gap: 8 }}>
                  <TextInput
                    value={workspacePath}
                    onChangeText={setWorkspacePath}
                    placeholder="/path/to/project/workspace"
                    placeholderTextColor={colors.mutedForeground}
                    autoCapitalize="none"
                    autoCorrect={false}
                    style={{ flex: 1, backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
                  />
                  <TouchableOpacity onPress={() => setBrowserOpen(true)} style={{ justifyContent: 'center', backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12 }}>
                    <Folder color={colors.primary} size={18} />
                  </TouchableOpacity>
                </View>
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 6 }}>
                  {t('projectWizard.step2.newHelp', { defaultValue: 'Absolute path on the server.' })}
                </Text>

                <Text style={{ color: colors.foreground, fontWeight: '600', marginTop: 18, marginBottom: 6 }}>
                  {t('projectWizard.step2.githubUrl', { defaultValue: 'GitHub repository (optional)' })}
                </Text>
                <TextInput
                  value={githubUrl}
                  onChangeText={setGithubUrl}
                  placeholder="https://github.com/username/repository"
                  placeholderTextColor={colors.mutedForeground}
                  autoCapitalize="none"
                  autoCorrect={false}
                  style={{ backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
                />
                <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 6 }}>
                  {t('projectWizard.step2.githubHelp', { defaultValue: 'Leave empty to create an empty project.' })}
                </Text>

                {showGithubAuth && (
                  <View style={{ marginTop: 18 }}>
                    <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 8 }}>
                      {t('projectWizard.step2.githubAuth', { defaultValue: 'GitHub authentication' })}
                    </Text>
                    <View style={{ flexDirection: 'row', gap: 8 }}>
                      {modeButton('stored', t('projectWizard.step2.storedToken', { defaultValue: 'Stored' }))}
                      {modeButton('new', t('projectWizard.step2.newToken', { defaultValue: 'New token' }))}
                      {modeButton('none', t('projectWizard.step2.nonePublic', { defaultValue: 'Public' }))}
                    </View>

                    {tokensLoading && (
                      <ActivityIndicator color={colors.primary} style={{ marginTop: 12 }} />
                    )}
                    {tokensError && <Text style={{ color: colors.destructive, fontSize: 12, marginTop: 10 }}>{tokensError}</Text>}

                    {tokenMode === 'stored' && !tokensLoading && (
                      tokens.length > 0 ? (
                        <TouchableOpacity onPress={() => setTokenSheet(true)} style={{ flexDirection: 'row', alignItems: 'center', marginTop: 12, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 12 }}>
                          <Text style={{ flex: 1, color: colors.foreground }} numberOfLines={1}>
                            {selectedTokenName || t('projectWizard.step2.selectTokenPlaceholder', { defaultValue: '-- Select a token --' })}
                          </Text>
                          <ChevronRight color={colors.mutedForeground} size={16} />
                        </TouchableOpacity>
                      ) : (
                        <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 10 }}>
                          {t('projectWizard.step2.noTokensHelp', { defaultValue: 'No stored tokens found. Use a new token or public clone.' })}
                        </Text>
                      )
                    )}

                    {tokenMode === 'new' && (
                      <TextInput
                        value={newGithubToken}
                        onChangeText={setNewGithubToken}
                        placeholder="ghp_xxxx…"
                        placeholderTextColor={colors.mutedForeground}
                        autoCapitalize="none"
                        autoCorrect={false}
                        secureTextEntry
                        style={{ marginTop: 12, backgroundColor: colors.background, color: colors.foreground, borderColor: colors.border, borderWidth: 1, borderRadius: 8, paddingHorizontal: 12, paddingVertical: 10 }}
                      />
                    )}
                    {tokenMode === 'none' && (
                      <Text style={{ color: colors.mutedForeground, fontSize: 12, marginTop: 10 }}>
                        {t('projectWizard.step2.publicRepoInfo', { defaultValue: 'Only works for public repositories.' })}
                      </Text>
                    )}
                  </View>
                )}
              </>
            ) : (
              <>
                <Text style={{ color: colors.foreground, fontWeight: '600', marginBottom: 10 }}>
                  {t('projectWizard.step3.reviewConfig', { defaultValue: 'Review configuration' })}
                </Text>
                <View style={{ backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 12, gap: 8 }}>
                  <View style={{ flexDirection: 'row', gap: 8 }}>
                    <Text style={{ color: colors.mutedForeground, fontSize: 12, width: 110 }}>{t('projectWizard.step3.path', { defaultValue: 'Path' })}</Text>
                    <Text style={{ color: colors.foreground, fontSize: 12, flex: 1 }}>{workspacePath.trim()}</Text>
                  </View>
                  {clone && (
                    <>
                      <View style={{ flexDirection: 'row', gap: 8 }}>
                        <Text style={{ color: colors.mutedForeground, fontSize: 12, width: 110 }}>{t('projectWizard.step3.cloneFrom', { defaultValue: 'Clone from' })}</Text>
                        <Text style={{ color: colors.foreground, fontSize: 12, flex: 1 }}>{githubUrl.trim()}</Text>
                      </View>
                      <View style={{ flexDirection: 'row', gap: 8 }}>
                        <Text style={{ color: colors.mutedForeground, fontSize: 12, width: 110 }}>{t('projectWizard.step3.authentication', { defaultValue: 'Authentication' })}</Text>
                        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6, flex: 1 }}>
                          {isSshGitUrl(githubUrl) ? <GitBranch color={colors.mutedForeground} size={14} /> : null}
                          <Text style={{ color: colors.foreground, fontSize: 12, flex: 1 }}>{authLabel}</Text>
                        </View>
                      </View>
                    </>
                  )}
                </View>

                <View style={{ marginTop: 14, backgroundColor: colors.background, borderColor: colors.border, borderWidth: 1, borderRadius: 8, padding: 12 }}>
                  {creating && cloneProgress ? (
                    <>
                      <Text style={{ color: colors.foreground, fontWeight: '600', fontSize: 12, marginBottom: 6 }}>
                        {t('projectWizard.step3.cloningRepository', { defaultValue: 'Cloning repository...' })}
                      </Text>
                      <Text style={{ color: colors.mutedForeground, fontSize: 11, fontFamily: 'monospace' }}>{cloneProgress}</Text>
                    </>
                  ) : (
                    <Text style={{ color: colors.mutedForeground, fontSize: 12 }}>
                      {clone
                        ? t('projectWizard.step3.newWithClone', { defaultValue: 'The repository will be cloned into the workspace path.' })
                        : t('projectWizard.step3.newEmpty', { defaultValue: 'An empty project will be created at the given path.' })}
                    </Text>
                  )}
                </View>
              </>
            )}
          </ScrollView>

          <View style={{ flexDirection: 'row', alignItems: 'center', justifyContent: 'flex-end', gap: 12, padding: 16, borderTopWidth: 1, borderTopColor: colors.border }}>
            <TouchableOpacity
              onPress={() => {
                if (creating) return;
                if (step === 2) {
                  setError(null);
                  setStep(1);
                } else {
                  onClose();
                }
              }}
              disabled={creating}
              style={{ padding: 8, opacity: creating ? 0.4 : 1 }}
            >
              <Text style={{ color: colors.mutedForeground }}>
                {step === 2 ? t('projectWizard.buttons.back', { defaultValue: 'Back' }) : t('projectWizard.buttons.cancel', { defaultValue: 'Cancel' })}
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={() => (step === 1 ? handleNext() : void handleCreate())}
              disabled={creating}
              style={{ backgroundColor: colors.primary, borderRadius: 8, paddingHorizontal: 16, paddingVertical: 10, opacity: creating ? 0.6 : 1 }}
            >
              <Text style={{ color: colors.primaryForeground, fontWeight: '600' }}>
                {creating
                  ? t(clone ? 'projectWizard.buttons.cloning' : 'projectWizard.buttons.creating', { defaultValue: clone ? 'Cloning...' : 'Creating...' })
                  : step === 1
                    ? t('projectWizard.buttons.next', { defaultValue: 'Next' })
                    : t('projectWizard.buttons.createProject', { defaultValue: 'Create Project' })}
              </Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>

      <FolderBrowserModal
        visible={browserOpen}
        colors={colors}
        onClose={() => setBrowserOpen(false)}
        onSelect={(path) => {
          setWorkspacePath(path);
          setBrowserOpen(false);
        }}
      />
      <ActionSheet
        visible={tokenSheet}
        title={t('projectWizard.step2.selectToken', { defaultValue: 'Select a token' })}
        items={tokenItems}
        onClose={() => setTokenSheet(false)}
      />
    </Modal>
  );
}

; DDAgent Windows installer — built by .github/workflows/flutter-release.yml
;   ISCC.exe /DAppVersion=0.8.0 /DVerTag=v0.8.0 packaging\windows\installer.iss
#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif
#ifndef VerTag
  #define VerTag "v" + AppVersion
#endif

[Setup]
; AppId pinned to the pre-rebrand value so upgrades keep the same uninstall entry.
AppId=ddagent
AppName=DDAgent
AppVersion={#AppVersion}
AppPublisher=DDAgent
AppPublisherURL=https://github.com/Zakwei/ddagent
DefaultDirName={autopf}\ddagent
DefaultGroupName=ddagent
OutputDir=..\..\..\release\flutter
OutputBaseFilename=ddagent-flutter-windows-x64-{#VerTag}-setup
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\ddagent_app.exe
; Language dialog preselects the Windows UI language (an upgrade reuses the
; language picked last time); silent installs skip the dialog.
ShowLanguageDialog=yes
LanguageDetectionMethod=uilanguage

; One entry per Flutter UI locale. Korean and Chinese ship with Inno Setup
; only since 6.5, so they are vendored under languages\.
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ja"; MessagesFile: "compiler:Languages\Japanese.isl"
Name: "ko"; MessagesFile: "languages\Korean.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "tr"; MessagesFile: "compiler:Languages\Turkish.isl"
Name: "zhCN"; MessagesFile: "languages\ChineseSimplified.isl"
Name: "zhTW"; MessagesFile: "languages\ChineseTraditional.isl"

[CustomMessages]
en.UpgradeCaption=Upgrade DDAgent %1 to %2
en.UpgradeReady=DDAgent %1 is installed and will be upgraded to %2. The old version is uninstalled first; your settings and local server configuration are kept.
en.UpgradeButton=&Upgrade
en.UpgradeMemo=Upgrade:
en.UpgradeKept=Settings and local server configuration are kept.
en.UpgradeUninstalling=Uninstalling DDAgent %1...
pl.UpgradeCaption=Aktualizacja DDAgent %1 do %2
pl.UpgradeReady=DDAgent %1 jest zainstalowany i zostanie zaktualizowany do wersji %2. Najpierw zostanie odinstalowana stara wersja; ustawienia i konfiguracja lokalnego serwera zostaną zachowane.
pl.UpgradeButton=&Aktualizuj
pl.UpgradeMemo=Aktualizacja:
pl.UpgradeKept=Ustawienia i konfiguracja lokalnego serwera zostaną zachowane.
pl.UpgradeUninstalling=Odinstalowywanie DDAgent %1...
de.UpgradeCaption=DDAgent %1 auf %2 aktualisieren
de.UpgradeReady=DDAgent %1 ist installiert und wird auf %2 aktualisiert. Die alte Version wird zuerst deinstalliert; Ihre Einstellungen und die Konfiguration des lokalen Servers bleiben erhalten.
de.UpgradeButton=&Aktualisieren
de.UpgradeMemo=Aktualisierung:
de.UpgradeKept=Einstellungen und Konfiguration des lokalen Servers bleiben erhalten.
de.UpgradeUninstalling=DDAgent %1 wird deinstalliert...
es.UpgradeCaption=Actualizar DDAgent %1 a %2
es.UpgradeReady=DDAgent %1 está instalado y se actualizará a %2. Primero se desinstalará la versión anterior; se conservarán tus ajustes y la configuración del servidor local.
es.UpgradeButton=&Actualizar
es.UpgradeMemo=Actualización:
es.UpgradeKept=Se conservan los ajustes y la configuración del servidor local.
es.UpgradeUninstalling=Desinstalando DDAgent %1...
fr.UpgradeCaption=Mettre à jour DDAgent %1 vers %2
fr.UpgradeReady=DDAgent %1 est installé et sera mis à jour vers %2. L'ancienne version est d'abord désinstallée ; vos paramètres et la configuration du serveur local sont conservés.
fr.UpgradeButton=&Mettre à jour
fr.UpgradeMemo=Mise à jour :
fr.UpgradeKept=Les paramètres et la configuration du serveur local sont conservés.
fr.UpgradeUninstalling=Désinstallation de DDAgent %1...
it.UpgradeCaption=Aggiorna DDAgent da %1 a %2
it.UpgradeReady=DDAgent %1 è installato e verrà aggiornato alla versione %2. La versione precedente viene prima disinstallata; le impostazioni e la configurazione del server locale vengono mantenute.
it.UpgradeButton=&Aggiorna
it.UpgradeMemo=Aggiornamento:
it.UpgradeKept=Le impostazioni e la configurazione del server locale vengono mantenute.
it.UpgradeUninstalling=Disinstallazione di DDAgent %1...
ja.UpgradeCaption=DDAgent %1 を %2 にアップグレード
ja.UpgradeReady=DDAgent %1 がインストールされています。%2 にアップグレードします。先に旧バージョンをアンインストールしますが、設定とローカルサーバーの構成は保持されます。
ja.UpgradeButton=アップグレード(&U)
ja.UpgradeMemo=アップグレード:
ja.UpgradeKept=設定とローカルサーバーの構成は保持されます。
ja.UpgradeUninstalling=DDAgent %1 をアンインストールしています...
ko.UpgradeCaption=DDAgent %1을(를) %2(으)로 업그레이드
ko.UpgradeReady=DDAgent %1이(가) 설치되어 있으며 %2(으)로 업그레이드됩니다. 이전 버전을 먼저 제거하지만 설정과 로컬 서버 구성은 유지됩니다.
ko.UpgradeButton=업그레이드(&U)
ko.UpgradeMemo=업그레이드:
ko.UpgradeKept=설정과 로컬 서버 구성은 유지됩니다.
ko.UpgradeUninstalling=DDAgent %1 제거 중...
ru.UpgradeCaption=Обновление DDAgent %1 до %2
ru.UpgradeReady=DDAgent %1 уже установлен и будет обновлён до версии %2. Сначала будет удалена старая версия; настройки и конфигурация локального сервера сохранятся.
ru.UpgradeButton=&Обновить
ru.UpgradeMemo=Обновление:
ru.UpgradeKept=Настройки и конфигурация локального сервера сохраняются.
ru.UpgradeUninstalling=Удаление DDAgent %1...
tr.UpgradeCaption=DDAgent %1 sürümünü %2 sürümüne yükselt
tr.UpgradeReady=DDAgent %1 yüklü ve %2 sürümüne yükseltilecek. Önce eski sürüm kaldırılır; ayarlarınız ve yerel sunucu yapılandırmanız korunur.
tr.UpgradeButton=&Yükselt
tr.UpgradeMemo=Yükseltme:
tr.UpgradeKept=Ayarlar ve yerel sunucu yapılandırması korunur.
tr.UpgradeUninstalling=DDAgent %1 kaldırılıyor...
zhCN.UpgradeCaption=将 DDAgent %1 升级到 %2
zhCN.UpgradeReady=已安装 DDAgent %1，将升级到 %2。将先卸载旧版本；您的设置和本地服务器配置会被保留。
zhCN.UpgradeButton=升级(&U)
zhCN.UpgradeMemo=升级：
zhCN.UpgradeKept=设置和本地服务器配置会被保留。
zhCN.UpgradeUninstalling=正在卸载 DDAgent %1...
zhTW.UpgradeCaption=將 DDAgent %1 升級至 %2
zhTW.UpgradeReady=已安裝 DDAgent %1，將升級至 %2。會先解除安裝舊版本；您的設定與本機伺服器設定會被保留。
zhTW.UpgradeButton=升級(&U)
zhTW.UpgradeMemo=升級：
zhTW.UpgradeKept=設定與本機伺服器設定會被保留。
zhTW.UpgradeUninstalling=正在解除安裝 DDAgent %1...

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{autoprograms}\DDAgent"; Filename: "{app}\ddagent_app.exe"
Name: "{autodesktop}\DDAgent"; Filename: "{app}\ddagent_app.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\ddagent_app.exe"; Description: "{cm:LaunchProgram,DDAgent}"; Flags: nowait postinstall skipifsilent

[Code]
// Upgrades: detect the previous install, say so in the wizard, and run its
// uninstaller silently before copying the new files so stale files from the
// old version don't linger. The uninstaller only removes what it installed in
// {app}, icons and its registry entry — user data (app settings, the local
// server bundle with its .env under %APPDATA%, ~/.ddagent) is never touched.
// The previous dir and selected tasks are read from the registry at startup,
// before the uninstall runs, so they carry over.
const
  UninstallKey = 'Software\Microsoft\Windows\CurrentVersion\Uninstall\ddagent_is1';

var
  PreviousVersion: String;
  PreviousUninstaller: String;

function ReadPreviousInstall(RootKey: Integer): Boolean;
begin
  Result := RegQueryStringValue(RootKey, UninstallKey, 'UninstallString', PreviousUninstaller);
  if Result then
  begin
    PreviousUninstaller := RemoveQuotes(PreviousUninstaller);
    if not RegQueryStringValue(RootKey, UninstallKey, 'DisplayVersion', PreviousVersion) then
      PreviousVersion := '?';
  end;
end;

function IsUpgrade: Boolean;
begin
  Result := PreviousUninstaller <> '';
end;

function InitializeSetup: Boolean;
begin
  if not ReadPreviousInstall(HKLM) then
    if not ReadPreviousInstall(HKCU) then
      Log('No previous DDAgent install found');
  Result := True;
end;

procedure InitializeWizard;
begin
  if IsUpgrade then
  begin
    WizardForm.Caption := FmtMessage(CustomMessage('UpgradeCaption'), [PreviousVersion, '{#AppVersion}']);
    WizardForm.ReadyLabel.Caption :=
      FmtMessage(CustomMessage('UpgradeReady'), [PreviousVersion, '{#AppVersion}']);
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if IsUpgrade and (CurPageID = wpReady) then
    WizardForm.NextButton.Caption := CustomMessage('UpgradeButton');
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  Result := '';
  if IsUpgrade then
    Result := CustomMessage('UpgradeMemo') + NewLine + Space + PreviousVersion + ' -> {#AppVersion}' +
      NewLine + Space + CustomMessage('UpgradeKept') + NewLine + NewLine;
  if MemoDirInfo <> '' then Result := Result + MemoDirInfo + NewLine + NewLine;
  if MemoTasksInfo <> '' then Result := Result + MemoTasksInfo + NewLine;
end;

// ssInstall runs after CloseApplications has stopped the running app, so the
// old files are unlocked. The uninstaller waits for its temp copy to finish.
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if (CurStep = ssInstall) and IsUpgrade and FileExists(PreviousUninstaller) then
  begin
    WizardForm.StatusLabel.Caption := FmtMessage(CustomMessage('UpgradeUninstalling'), [PreviousVersion]);
    if not Exec(PreviousUninstaller, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '',
      SW_HIDE, ewWaitUntilTerminated, ResultCode) or (ResultCode <> 0) then
      Log(Format('Previous uninstaller failed (code %d); installing over it', [ResultCode]));
  end;
end;

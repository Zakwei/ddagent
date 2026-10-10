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

[Tasks]
Name: "desktopicon"; Description: "Create a &desktop icon"; GroupDescription: "Additional icons:"; Flags: unchecked

[Files]
Source: "..\..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs ignoreversion

[Icons]
Name: "{autoprograms}\DDAgent"; Filename: "{app}\ddagent_app.exe"
Name: "{autodesktop}\DDAgent"; Filename: "{app}\ddagent_app.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\ddagent_app.exe"; Description: "Launch DDAgent"; Flags: nowait postinstall skipifsilent

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
    WizardForm.Caption := 'Upgrade DDAgent ' + PreviousVersion + ' to {#AppVersion}';
    WizardForm.ReadyLabel.Caption :=
      'DDAgent ' + PreviousVersion + ' is installed and will be upgraded to {#AppVersion}. ' +
      'The old version is uninstalled first; your settings and local server configuration are kept.';
  end;
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if IsUpgrade and (CurPageID = wpReady) then
    WizardForm.NextButton.Caption := '&Upgrade';
end;

function UpdateReadyMemo(Space, NewLine, MemoUserInfoInfo, MemoDirInfo, MemoTypeInfo,
  MemoComponentsInfo, MemoGroupInfo, MemoTasksInfo: String): String;
begin
  Result := '';
  if IsUpgrade then
    Result := 'Upgrade:' + NewLine + Space + PreviousVersion + ' -> {#AppVersion}' + NewLine +
      Space + 'Settings and local server configuration are kept.' + NewLine + NewLine;
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
    WizardForm.StatusLabel.Caption := 'Uninstalling DDAgent ' + PreviousVersion + '...';
    if not Exec(PreviousUninstaller, '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART', '',
      SW_HIDE, ewWaitUntilTerminated, ResultCode) or (ResultCode <> 0) then
      Log(Format('Previous uninstaller failed (code %d); installing over it', [ResultCode]));
  end;
end;

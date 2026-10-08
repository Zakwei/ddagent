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

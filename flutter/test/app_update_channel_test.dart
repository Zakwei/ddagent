import 'package:ddagent_app/features/system/data/app_update_channel.dart';
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:flutter_test/flutter_test.dart';

ReleaseAsset _asset(String name) =>
    ReleaseAsset(name: name, downloadUrl: 'https://example.test/$name');

void main() {
  group('channelForHost', () {
    test('Android is always supported, packaged or not', () {
      expect(
        channelForHost(AppUpdateHost.android, executablePath: '', packaged: false),
        AppUpdateChannel.android,
      );
    });

    test('a packaged Linux deb install maps to linuxDeb', () {
      expect(
        channelForHost(
          AppUpdateHost.linux,
          executablePath: '/opt/ddagent/ddagent_app',
          packaged: true,
        ),
        AppUpdateChannel.linuxDeb,
      );
    });

    test('a packaged Linux bundle maps to linuxBundle', () {
      expect(
        channelForHost(
          AppUpdateHost.linux,
          executablePath: '/home/u/ddagent/bundle/ddagent_app',
          packaged: true,
        ),
        AppUpdateChannel.linuxBundle,
      );
    });

    test('a packaged Windows Program Files install maps to windowsSetup', () {
      expect(
        channelForHost(
          AppUpdateHost.windows,
          executablePath: r'C:\Program Files\ddagent\ddagent_app.exe',
          packaged: true,
        ),
        AppUpdateChannel.windowsSetup,
      );
    });

    test('a packaged Windows portable install maps to windowsBundle', () {
      expect(
        channelForHost(
          AppUpdateHost.windows,
          executablePath: r'D:\apps\ddagent\ddagent_app.exe',
          packaged: true,
        ),
        AppUpdateChannel.windowsBundle,
      );
    });

    test('debug desktop builds never self-update', () {
      expect(
        channelForHost(
          AppUpdateHost.linux,
          executablePath: '/opt/ddagent/ddagent_app',
          packaged: false,
        ),
        AppUpdateChannel.unsupported,
      );
      expect(
        channelForHost(
          AppUpdateHost.windows,
          executablePath: r'C:\Program Files\ddagent\x.exe',
          packaged: false,
        ),
        AppUpdateChannel.unsupported,
      );
    });

    test('other hosts are unsupported', () {
      expect(
        channelForHost(AppUpdateHost.other, executablePath: '/whatever', packaged: true),
        AppUpdateChannel.unsupported,
      );
    });
  });

  group('selectAppUpdateAsset', () {
    final assets = [
      _asset('ddagent-flutter-linux-x64-v1.tar.gz'),
      _asset('ddagent-flutter-linux-x64-v1.deb'),
      _asset('ddagent-flutter-windows-x64-v1.zip'),
      _asset('ddagent-flutter-windows-x64-v1-setup.exe'),
      _asset('ddagent-flutter-android-v1.apk'),
    ];

    test('selects the suffix matching each channel', () {
      expect(selectAppUpdateAsset(assets, AppUpdateChannel.android)?.name, endsWith('.apk'));
      expect(selectAppUpdateAsset(assets, AppUpdateChannel.linuxDeb)?.name, endsWith('.deb'));
      expect(selectAppUpdateAsset(assets, AppUpdateChannel.linuxBundle)?.name, endsWith('.tar.gz'));
      expect(
        selectAppUpdateAsset(assets, AppUpdateChannel.windowsSetup)?.name,
        endsWith('-setup.exe'),
      );
      expect(selectAppUpdateAsset(assets, AppUpdateChannel.windowsBundle)?.name, endsWith('.zip'));
    });

    test('does not mistake the zip for the setup.exe', () {
      expect(
        selectAppUpdateAsset(assets, AppUpdateChannel.windowsSetup)?.name,
        isNot(endsWith('.zip')),
      );
    });

    test('returns null when nothing matches', () {
      expect(selectAppUpdateAsset(const [], AppUpdateChannel.android), isNull);
      expect(selectAppUpdateAsset(assets, AppUpdateChannel.unsupported), isNull);
    });
  });

  group('install-layout detection', () {
    test('isDebInstallExecutable', () {
      expect(isDebInstallExecutable('/opt/ddagent/ddagent_app'), isTrue);
      expect(isDebInstallExecutable('/usr/bin/ddagent'), isTrue);
      expect(isDebInstallExecutable('/home/u/ddagent/bundle/ddagent_app'), isFalse);
    });

    test('isWindowsInstallerExecutable', () {
      expect(isWindowsInstallerExecutable(r'C:\Program Files\ddagent\ddagent_app.exe'), isTrue);
      expect(isWindowsInstallerExecutable(r'C:\ProgramData\ddagent\app.exe'), isTrue);
      expect(isWindowsInstallerExecutable(r'D:\apps\ddagent\ddagent_app.exe'), isFalse);
    });
  });

  group('buildDesktopInstallPlan', () {
    test('Windows setup runs the installer silently with Restart Manager', () {
      final plan = buildDesktopInstallPlan(
        channel: AppUpdateChannel.windowsSetup,
        assetPath: r'C:\Users\u\AppData\ddagent-updates\setup.exe',
        executablePath: r'C:\Program Files\ddagent\ddagent_app.exe',
        relaunchPath: r'C:\Program Files\ddagent\ddagent_app.exe',
        pid: 42,
      );
      expect(plan.executable, r'C:\Users\u\AppData\ddagent-updates\setup.exe');
      expect(plan.arguments, kWindowsSetupArguments);
      expect(plan.scriptPath, isNull);
    });

    test('Windows bundle waits for the pid then unzips over the install dir', () {
      final plan = buildDesktopInstallPlan(
        channel: AppUpdateChannel.windowsBundle,
        assetPath: r'C:\Users\u\AppData\ddagent-updates\app.zip',
        executablePath: r'D:\apps\ddagent\ddagent_app.exe',
        relaunchPath: r'D:\apps\ddagent\ddagent_app.exe',
        pid: 42,
      );
      expect(plan.executable, 'powershell');
      expect(plan.arguments, contains('42'));
      expect(plan.arguments, contains(r'D:\apps\ddagent'));
      expect(plan.scriptPath, r'C:\Users\u\AppData\ddagent-updates\apply-update.ps1');
      expect(plan.scriptContent, contains('Expand-Archive'));
    });

    test('Linux deb installs via pkexec then relaunches', () {
      final plan = buildDesktopInstallPlan(
        channel: AppUpdateChannel.linuxDeb,
        assetPath: '/tmp/ddagent-updates/app.deb',
        executablePath: '/opt/ddagent/ddagent_app',
        relaunchPath: '/usr/bin/ddagent',
        pid: 42,
      );
      expect(plan.executable, 'sh');
      expect(plan.scriptPath, '/tmp/ddagent-updates/apply-update.sh');
      expect(plan.scriptContent, contains('pkexec dpkg -i'));
      expect(plan.arguments, contains('/usr/bin/ddagent'));
    });

    test('Linux bundle unpacks into the bundle parent then relaunches', () {
      final plan = buildDesktopInstallPlan(
        channel: AppUpdateChannel.linuxBundle,
        assetPath: '/tmp/ddagent-updates/app.tar.gz',
        executablePath: '/home/u/ddagent/bundle/ddagent_app',
        relaunchPath: '/home/u/ddagent/bundle/ddagent_app',
        pid: 42,
      );
      expect(plan.executable, 'sh');
      expect(plan.scriptContent, contains('tar -xzf'));
      // The tarball holds a top-level `bundle/`, so it extracts into its parent.
      expect(plan.arguments, contains('/home/u/ddagent'));
      expect(plan.arguments, contains('/home/u/ddagent/bundle/ddagent_app'));
    });

    test('rejects channels without a desktop installer', () {
      expect(
        () => buildDesktopInstallPlan(
          channel: AppUpdateChannel.android,
          assetPath: '/x',
          executablePath: '/x',
          relaunchPath: '/x',
          pid: 1,
        ),
        throwsArgumentError,
      );
    });
  });

  group('StagedUpdate', () {
    test('round-trips through JSON', () {
      const staged = StagedUpdate(
        version: '0.8.8',
        assetName: 'ddagent-flutter-linux-x64-v0.8.8.deb',
        path: '/tmp/ddagent-updates/app.deb',
        channel: AppUpdateChannel.linuxDeb,
      );
      final decoded = StagedUpdate.fromJson(staged.toJson());
      expect(decoded?.version, '0.8.8');
      expect(decoded?.channel, AppUpdateChannel.linuxDeb);
      expect(decoded?.path, '/tmp/ddagent-updates/app.deb');
    });

    test('rejects malformed or non-desktop entries', () {
      expect(StagedUpdate.fromJson(const {'version': '1.0.0'}), isNull);
      expect(
        StagedUpdate.fromJson(const {
          'version': '1.0.0',
          'assetName': 'a.apk',
          'path': '/x',
          'channel': 'android',
        }),
        isNull,
      );
    });
  });
}

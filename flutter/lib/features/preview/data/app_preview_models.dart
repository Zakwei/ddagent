import 'package:flutter/widgets.dart';

/// Frame family of a preview — mirrors the server's `AppPreviewPlatform`.
enum PreviewPlatform { mobile, web, desktop }

PreviewPlatform previewPlatformOf(Object? value) => switch (value) {
  'mobile' => PreviewPlatform.mobile,
  'desktop' => PreviewPlatform.desktop,
  _ => PreviewPlatform.web,
};

/// How the device bezel is drawn around the streamed page.
enum PreviewFrameStyle {
  /// iPhone-style: rounded bezel, Dynamic Island, home indicator.
  phoneIsland,

  /// Android-style: rounded bezel, centred punch-hole camera, gesture bar.
  phonePunchHole,

  /// Tablet: thin uniform bezel, no notch, home indicator.
  tablet,

  /// Browser window: tab strip + address bar above the page.
  browser,

  /// Desktop app window: title bar with traffic lights.
  desktopWindow,
}

/// One device preset the pane can frame an app in.
///
/// Ids match the server catalog (`server/modules/app-preview`) — the agent
/// passes them to `preview_open`; [width]/[height] are the page's CSS pixels
/// in portrait (phones/tablets) or the window's content size (web/desktop).
class PreviewDevice {
  const PreviewDevice({
    required this.id,
    required this.label,
    required this.platform,
    required this.width,
    required this.height,
    required this.style,
  });

  final String id;
  final String label;
  final PreviewPlatform platform;
  final int width;
  final int height;
  final PreviewFrameStyle style;

  bool get isMobile => platform == PreviewPlatform.mobile;

  /// Page viewport for the orientation (mobile frames rotate; others don't).
  Size viewportFor(bool landscape) => isMobile && landscape
      ? Size(height.toDouble(), width.toDouble())
      : Size(width.toDouble(), height.toDouble());
}

/// Device catalog — keep in sync with `DEVICE_CATALOG` on the server. The
/// first entry per platform is that platform's default.
const kPreviewDevices = <PreviewDevice>[
  PreviewDevice(
    id: 'iphone-15-pro',
    label: 'iPhone 15 Pro',
    platform: PreviewPlatform.mobile,
    width: 393,
    height: 852,
    style: PreviewFrameStyle.phoneIsland,
  ),
  PreviewDevice(
    id: 'iphone-se',
    label: 'iPhone SE',
    platform: PreviewPlatform.mobile,
    width: 375,
    height: 667,
    style: PreviewFrameStyle.phoneIsland,
  ),
  PreviewDevice(
    id: 'pixel-8',
    label: 'Pixel 8',
    platform: PreviewPlatform.mobile,
    width: 412,
    height: 915,
    style: PreviewFrameStyle.phonePunchHole,
  ),
  PreviewDevice(
    id: 'galaxy-s24',
    label: 'Galaxy S24',
    platform: PreviewPlatform.mobile,
    width: 360,
    height: 780,
    style: PreviewFrameStyle.phonePunchHole,
  ),
  PreviewDevice(
    id: 'ipad-pro-11',
    label: 'iPad Pro 11"',
    platform: PreviewPlatform.mobile,
    width: 834,
    height: 1194,
    style: PreviewFrameStyle.tablet,
  ),
  PreviewDevice(
    id: 'android-tablet',
    label: 'Android tablet 10"',
    platform: PreviewPlatform.mobile,
    width: 800,
    height: 1280,
    style: PreviewFrameStyle.tablet,
  ),
  PreviewDevice(
    id: 'web-laptop',
    label: 'Browser 1366×768',
    platform: PreviewPlatform.web,
    width: 1366,
    height: 768,
    style: PreviewFrameStyle.browser,
  ),
  PreviewDevice(
    id: 'web-desktop',
    label: 'Browser 1920×1080',
    platform: PreviewPlatform.web,
    width: 1920,
    height: 1080,
    style: PreviewFrameStyle.browser,
  ),
  PreviewDevice(
    id: 'desktop-window',
    label: 'Desktop window 1280×800',
    platform: PreviewPlatform.desktop,
    width: 1280,
    height: 800,
    style: PreviewFrameStyle.desktopWindow,
  ),
  PreviewDevice(
    id: 'desktop-large',
    label: 'Desktop window 1440×900',
    platform: PreviewPlatform.desktop,
    width: 1440,
    height: 900,
    style: PreviewFrameStyle.desktopWindow,
  ),
];

PreviewDevice? previewDeviceById(String? id) {
  if (id == null) return null;
  for (final d in kPreviewDevices) {
    if (d.id == id) return d;
  }
  return null;
}

PreviewDevice defaultPreviewDevice(PreviewPlatform platform) =>
    kPreviewDevices.firstWhere((d) => d.platform == platform);

/// Resolves the device a pane should render: explicit preset, else the
/// target's preset, else the target platform's default.
PreviewDevice resolvePreviewDevice({String? paneDevice, AppPreviewTarget? target}) =>
    previewDeviceById(paneDevice) ??
    previewDeviceById(target?.device) ??
    defaultPreviewDevice(target?.platform ?? PreviewPlatform.web);

/// A preview target registered on the server (by an agent over MCP or by the
/// user from the pane) — mirrors `AppPreviewTarget`.
class AppPreviewTarget {
  const AppPreviewTarget({
    required this.id,
    required this.url,
    required this.title,
    required this.platform,
    this.device,
    this.landscape = false,
    this.projectPath,
    this.note,
    this.reloadToken = 0,
    this.updatedAt,
  });

  final String id;
  final String url;
  final String title;
  final PreviewPlatform platform;
  final String? device;
  final bool landscape;
  final String? projectPath;
  final String? note;

  /// Incremented by `preview_reload`; a change means "refresh the page".
  final int reloadToken;
  final DateTime? updatedAt;

  static AppPreviewTarget? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final url = value['url'];
    if (id is! String || url is! String || id.isEmpty || url.isEmpty) return null;
    String? s(Object? v) => v is String && v.trim().isNotEmpty ? v : null;
    return AppPreviewTarget(
      id: id,
      url: url,
      title: s(value['title']) ?? url,
      platform: previewPlatformOf(value['platform']),
      device: s(value['device']),
      landscape: value['orientation'] == 'landscape',
      projectPath: s(value['projectPath']),
      note: s(value['note']),
      reloadToken: (value['reloadToken'] as num?)?.toInt() ?? 0,
      updatedAt: DateTime.tryParse(s(value['updatedAt']) ?? ''),
    );
  }
}

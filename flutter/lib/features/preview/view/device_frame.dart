import 'dart:async';

import 'package:ddagent_app/features/preview/data/app_preview_models.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Chrome colours shared by every frame style (always dark, like a real
/// device bezel — independent of the app theme, same as the Teal-login demo).
abstract final class _FrameColors {
  static const bezel = Color(0xFF111216);
  static const bezelEdge = Color(0xFF45474F);
  static const screen = Color(0xFF0B0B0C);
  static const statusFg = Colors.white;
  static const windowBar = Color(0xFF2B2D33);
  static const windowBarFg = Color(0xFFD7D8DC);
  static const windowEdge = Color(0xFF3A3C44);
  static const addressField = Color(0xFF1C1E24);
}

/// Natural (unscaled) size of a frame around a page of [viewport] pixels —
/// the pane uses it to scale the whole device to fit.
Size deviceFrameSize(PreviewDevice device, Size viewport) {
  switch (device.style) {
    case PreviewFrameStyle.phoneIsland:
    case PreviewFrameStyle.phonePunchHole:
      // Bezel padding plus the 2px edge border on each side.
      return Size(
        viewport.width + 2 * (_PhoneFrame.bezel + 2),
        viewport.height +
            2 * (_PhoneFrame.bezel + 2) +
            _PhoneFrame.statusHeight +
            _PhoneFrame.homeHeight,
      );
    case PreviewFrameStyle.tablet:
      return Size(
        viewport.width + 2 * (_TabletFrame.bezel + 2),
        viewport.height +
            2 * (_TabletFrame.bezel + 2) +
            _TabletFrame.statusHeight +
            _TabletFrame.homeHeight,
      );
    case PreviewFrameStyle.browser:
      return Size(
        viewport.width + 2,
        viewport.height + _WindowFrame.titleHeight + _WindowFrame.addressHeight + 2,
      );
    case PreviewFrameStyle.desktopWindow:
      return Size(viewport.width + 2, viewport.height + _WindowFrame.titleHeight + 2);
  }
}

/// Draws [device]'s chrome around [child], which must already be laid out at
/// the device viewport size. Phones get a status bar (live clock) above and a
/// home indicator below the page rather than over it, so nothing of the app
/// is hidden — web apps know nothing about safe areas.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    super.key,
    required this.device,
    required this.viewport,
    required this.child,
    this.title = '',
    this.url = '',
    this.loading = false,
  });

  final PreviewDevice device;
  final Size viewport;
  final Widget child;
  final String title;
  final String url;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final page = SizedBox.fromSize(size: viewport, child: child);
    return switch (device.style) {
      PreviewFrameStyle.phoneIsland => _PhoneFrame(viewport: viewport, island: true, child: page),
      PreviewFrameStyle.phonePunchHole => _PhoneFrame(
        viewport: viewport,
        island: false,
        child: page,
      ),
      PreviewFrameStyle.tablet => _TabletFrame(viewport: viewport, child: page),
      PreviewFrameStyle.browser => _WindowFrame(
        viewport: viewport,
        title: title,
        url: url,
        loading: loading,
        addressBar: true,
        child: page,
      ),
      PreviewFrameStyle.desktopWindow => _WindowFrame(
        viewport: viewport,
        title: title,
        url: url,
        loading: loading,
        addressBar: false,
        child: page,
      ),
    };
  }
}

// ─── Status bar bits ─────────────────────────────────────────────────────────

/// "9:41"-style clock that ticks every half minute (demo parity).
class _Clock extends StatefulWidget {
  const _Clock({required this.style});
  final TextStyle style;

  @override
  State<_Clock> createState() => _ClockState();
}

class _ClockState extends State<_Clock> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final h = now.hour % 12 == 0 ? 12 : now.hour % 12;
    return Text('$h:${now.minute.toString().padLeft(2, '0')}', style: widget.style);
  }
}

class _StatusIcons extends StatelessWidget {
  const _StatusIcons({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 5,
    children: [
      Icon(Icons.signal_cellular_alt, size: size, color: _FrameColors.statusFg),
      Icon(Icons.wifi, size: size, color: _FrameColors.statusFg),
      Icon(Icons.battery_full, size: size, color: _FrameColors.statusFg),
    ],
  );
}

// ─── Phone ───────────────────────────────────────────────────────────────────

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.viewport, required this.island, required this.child});

  static const double bezel = 12;
  static const double statusHeight = 44;
  static const double homeHeight = 24;

  final Size viewport;
  final bool island;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final portrait = viewport.height >= viewport.width;
    final outerRadius = portrait ? 58.0 : 48.0;
    final screenRadius = outerRadius - bezel;
    const statusStyle = TextStyle(
      color: _FrameColors.statusFg,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1,
    );
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(bezel),
          decoration: BoxDecoration(
            color: _FrameColors.bezel,
            borderRadius: BorderRadius.circular(outerRadius),
            border: Border.all(color: _FrameColors.bezelEdge, width: 2),
            boxShadow: const [
              BoxShadow(color: Color(0x40000000), blurRadius: 80, offset: Offset(0, 40)),
              BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 12)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(screenRadius),
            child: ColoredBox(
              color: _FrameColors.screen,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: statusHeight,
                    width: viewport.width,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(32, 14, 24, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _Clock(style: statusStyle),
                              const Spacer(),
                              _StatusIcons(size: island ? 15 : 14),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: island
                              ? Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  width: 120,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(top: 12),
                                  width: 18,
                                  height: 18,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  child,
                  SizedBox(
                    height: homeHeight,
                    width: viewport.width,
                    child: Center(
                      child: Container(
                        width: island ? 134 : 100,
                        height: island ? 5 : 4,
                        decoration: BoxDecoration(
                          color: _FrameColors.statusFg,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Side buttons (volume left, power right).
        Positioned(left: -5, top: 110, child: _sideButton(height: 36)),
        Positioned(left: -5, top: 170, child: _sideButton(height: 100)),
        Positioned(right: -5, top: 220, child: _sideButton(height: 120)),
      ],
    );
  }

  Widget _sideButton({required double height}) => Container(
    width: 4,
    height: height,
    decoration: BoxDecoration(
      color: _FrameColors.bezelEdge,
      borderRadius: BorderRadius.circular(2),
    ),
  );
}

// ─── Tablet ──────────────────────────────────────────────────────────────────

class _TabletFrame extends StatelessWidget {
  const _TabletFrame({required this.viewport, required this.child});

  static const double bezel = 18;
  static const double statusHeight = 24;
  static const double homeHeight = 20;

  final Size viewport;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const statusStyle = TextStyle(
      color: _FrameColors.statusFg,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1,
    );
    return Container(
      padding: const EdgeInsets.all(bezel),
      decoration: BoxDecoration(
        color: _FrameColors.bezel,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: _FrameColors.bezelEdge, width: 2),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 80, offset: Offset(0, 40)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: _FrameColors.screen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: statusHeight,
                width: viewport.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: const [
                      _Clock(style: statusStyle),
                      Spacer(),
                      _StatusIcons(size: 12),
                    ],
                  ),
                ),
              ),
              child,
              SizedBox(
                height: homeHeight,
                width: viewport.width,
                child: Center(
                  child: Container(
                    width: 180,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _FrameColors.statusFg,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Browser / desktop window ────────────────────────────────────────────────

class _WindowFrame extends StatelessWidget {
  const _WindowFrame({
    required this.viewport,
    required this.title,
    required this.url,
    required this.loading,
    required this.addressBar,
    required this.child,
  });

  static const double titleHeight = 36;
  static const double addressHeight = 36;

  final Size viewport;
  final String title;
  final String url;
  final bool loading;
  final bool addressBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    const barText = TextStyle(color: _FrameColors.windowBarFg, fontSize: 12, height: 1.2);
    return Container(
      decoration: BoxDecoration(
        color: _FrameColors.windowBar,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _FrameColors.windowEdge),
        boxShadow: const [
          BoxShadow(color: Color(0x40000000), blurRadius: 60, offset: Offset(0, 30)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: titleHeight,
              width: viewport.width,
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  _dot(const Color(0xFFFF5F57)),
                  _dot(const Color(0xFFFEBC2E)),
                  _dot(const Color(0xFF28C840)),
                  const SizedBox(width: 10),
                  if (addressBar)
                    Container(
                      height: 26,
                      constraints: BoxConstraints(maxWidth: viewport.width * 0.4),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: _FrameColors.addressField,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title.isEmpty ? url : title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: barText,
                      ),
                    )
                  else
                    Expanded(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: barText.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (addressBar) const Spacer() else const SizedBox(width: 58),
                ],
              ),
            ),
            if (addressBar)
              Container(
                height: addressHeight,
                width: viewport.width,
                color: const Color(0xFF24262C),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Icon(LucideIcons.arrowLeft, size: 16, color: _FrameColors.windowBarFg),
                    const SizedBox(width: 10),
                    const Icon(LucideIcons.arrowRight, size: 16, color: Color(0xFF6B6E78)),
                    const SizedBox(width: 10),
                    Icon(
                      loading ? LucideIcons.x : LucideIcons.refreshCw,
                      size: 16,
                      color: _FrameColors.windowBarFg,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 26,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: _FrameColors.addressField,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              url.startsWith('https://') ? LucideIcons.lock : LucideIcons.info,
                              size: 12,
                              color: const Color(0xFF8A8D97),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                url,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: barText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _dot(Color color) => Container(
    width: 12,
    height: 12,
    margin: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
  );
}

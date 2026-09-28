// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

const previewEmbedSupported = true;

const _viewType = 'ddagent-preview-iframe';
bool _registered = false;

void _register() {
  if (_registered) return;
  _registered = true;
  ui_web.platformViewRegistry.registerViewFactory(_viewType, (
    int _,
    Object? params,
  ) {
    final url = (params as Map?)?['url']?.toString() ?? 'about:blank';
    return html.IFrameElement()
      ..src = url
      // The URL carries ?token= — never leak it via Referer.
      ..referrerPolicy = 'no-referrer'
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
  });
}

/// iframe pointed at the preview proxy URL — `key` on [reloadTick] remounts
/// the platform view so reload produces a fresh document.
Widget previewEmbed({required String url, required int reloadTick}) {
  _register();
  return HtmlElementView(
    key: ValueKey('$url#$reloadTick'),
    viewType: _viewType,
    creationParams: {'url': url},
  );
}

import 'package:flutter/material.dart';

/// Non-web fallback: Flutter desktop/mobile has no in-tree webview plugin in
/// this app, so the embed renders nothing and the caller shows the
/// open-external hint instead.
const previewEmbedSupported = false;

Widget previewEmbed({required String url, required int reloadTick}) =>
    const SizedBox.shrink();

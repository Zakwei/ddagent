import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Image loaded through Dio — carries Bearer + x-api-key auth for the assets
/// API and resolves relative `/api/…` paths against the configured server.
class AuthImage extends ConsumerWidget {
  const AuthImage({super.key, required this.url, this.fit});

  final String url;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final base = ref.watch(serverBaseUrlProvider);
    final resolved = url.startsWith('http') ? url : '$base$url';
    return FutureBuilder<Uint8List>(
      future: _fetch(ref, resolved),
      builder: (context, snap) {
        if (snap.hasError) {
          return const Icon(Icons.broken_image_outlined);
        }
        if (!snap.hasData) {
          return const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
        }
        return Image.memory(snap.data!, fit: fit);
      },
    );
  }

  Future<Uint8List> _fetch(WidgetRef ref, String url) async {
    final res = await ref
        .read(dioProvider)
        .get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
    return Uint8List.fromList(res.data!);
  }
}

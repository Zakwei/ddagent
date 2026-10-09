import 'dart:async';

import 'package:dio/dio.dart';

/// Default idle bound for [downloadWithStallTimeout].
const Duration kDownloadStallTimeout = Duration(seconds: 60);

/// `dio.download` that fails when no bytes arrive for [stallTimeout].
///
/// Dio's `receiveTimeout` only bounds the wait for response headers — a body
/// that stops mid-stream (dropped Wi-Fi, stalled proxy) would hang the await
/// forever and with it every busy/progress UI waiting on it. Throws a
/// [DioException] of type [DioExceptionType.receiveTimeout] on a stall.
Future<void> downloadWithStallTimeout(
  Dio dio,
  String url,
  String savePath, {
  ProgressCallback? onReceiveProgress,
  bool deleteOnError = true,
  Duration stallTimeout = kDownloadStallTimeout,
}) async {
  final cancel = CancelToken();
  var stalled = false;
  Timer? watchdog;
  void arm() {
    watchdog?.cancel();
    watchdog = Timer(stallTimeout, () {
      stalled = true;
      cancel.cancel();
    });
  }

  arm();
  try {
    await dio.download(
      url,
      savePath,
      cancelToken: cancel,
      deleteOnError: deleteOnError,
      onReceiveProgress: (received, total) {
        arm();
        onReceiveProgress?.call(received, total);
      },
    );
  } on DioException catch (e) {
    if (!stalled) rethrow;
    throw DioException.receiveTimeout(timeout: stallTimeout, requestOptions: e.requestOptions);
  } finally {
    watchdog?.cancel();
  }
}

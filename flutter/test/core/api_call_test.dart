import 'package:ddagent_app/core/network/api_error.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Response<dynamic>> _ok(dynamic data) async =>
    Response<dynamic>(requestOptions: RequestOptions(), data: data, statusCode: 200);

void main() {
  // Callers only catch AppError — a raw decode throw would skip their
  // loading/busy reset and leave the UI spinning.
  test('apiCall maps a decode failure to ServerError', () async {
    await expectLater(
      apiCall(() => _ok('not a map'), (d) => (d as Map<String, dynamic>)['x']),
      throwsA(isA<ServerError>()),
    );
  });

  test('apiCallAsync maps an async decode failure to ServerError', () async {
    await expectLater(
      apiCallAsync<int>(() => _ok(<String, dynamic>{}), (d) async => throw StateError('storage')),
      throwsA(isA<ServerError>()),
    );
  });

  test('apiCall keeps AppErrors thrown by the decoder', () async {
    await expectLater(
      apiCall<int>(() => _ok(<String, dynamic>{}), (d) => throw const NetworkError('x')),
      throwsA(isA<NetworkError>()),
    );
  });

  test('apiCall unwraps the success envelope', () async {
    expect(await apiCall(() => _ok({'success': true, 'data': 7}), (d) => d as int), 7);
  });
}

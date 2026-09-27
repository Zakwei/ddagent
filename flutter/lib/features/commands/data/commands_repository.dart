import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/commands — slash-command catalog (`/list`) and execution (`/execute`).
class CommandsRepository {
  const CommandsRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> list(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/commands/list', data: body),
    (d) => d as Map<String, dynamic>,
  );

  Future<Map<String, dynamic>> execute(Map<String, dynamic> body) => apiCall(
    () => _dio.post<dynamic>('/api/commands/execute', data: body),
    (d) => d as Map<String, dynamic>,
  );
}

final commandsRepositoryProvider = Provider<CommandsRepository>(
  (ref) => CommandsRepository(ref.watch(dioProvider)),
);

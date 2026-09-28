import 'dart:typed_data';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/core/network/api_providers.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// /api/file-tree — filesystem browse, file list (respectGitignore), read/
/// write, regex search, create/rename/delete, multipart upload.
class FileTreeRepository {
  const FileTreeRepository(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> browseFilesystem({String? path}) => apiCall(
    () => _dio.get<dynamic>(
      '/api/file-tree/browse-filesystem',
      queryParameters: {'path': ?path},
    ),
    (d) => d as Map<String, dynamic>,
  );

  Future<void> createFolder(String path) => apiCall(
    () => _dio.post<dynamic>(
      '/api/file-tree/create-folder',
      data: {'path': path},
    ),
    (_) {},
  );

  /// Server returns a bare `FileTreeNode[]` array (depth-10, children inline).
  Future<List<FileTreeNode>> listFiles(
    String projectId, {
    bool respectGitignore = true,
  }) => apiCall(
    () => _dio.get<dynamic>(
      '/api/file-tree/projects/$projectId/files',
      queryParameters: {'respectGitignore': '$respectGitignore'},
    ),
    decodeFileTree,
  );

  Future<String> readFile(String projectId, String filePath) => apiCall(
    () => _dio.get<dynamic>(
      '/api/file-tree/projects/$projectId/file',
      queryParameters: {'filePath': filePath},
    ),
    (d) => d is String
        ? d
        : ((d as Map<String, dynamic>)['content'] ?? '').toString(),
  );

  /// Raw bytes variant of readFile (binary assets, downloads).
  Future<Uint8List> readFileBlob(String projectId, String path) => apiCall(
    () => _dio.get<dynamic>(
      '/api/file-tree/projects/$projectId/files/content',
      queryParameters: {'path': path},
      options: Options(responseType: ResponseType.bytes),
    ),
    (d) => d is Uint8List ? d : Uint8List.fromList((d as List).cast<int>()),
  );

  Future<void> saveFile(String projectId, String filePath, String content) =>
      apiCall(
        () => _dio.put<dynamic>(
          '/api/file-tree/projects/$projectId/file',
          data: {'filePath': filePath, 'content': content},
        ),
        (_) {},
      );

  /// Fixed-string search across project files (`q` = pattern).
  /// Server returns `{results: [{path,line,column,text}], truncated}`.
  Future<FileSearchResult> search(
    String projectId,
    String query, {
    int? limit,
  }) => apiCall(
    () => _dio.get<dynamic>(
      '/api/file-tree/projects/$projectId/search',
      queryParameters: {'q': query, 'limit': ?limit},
    ),
    decodeSearchResult,
  );

  Future<void> createFile(
    String projectId, {
    required String path,
    required String type,
    required String name,
  }) => apiCall(
    () => _dio.post<dynamic>(
      '/api/file-tree/projects/$projectId/files/create',
      data: {'path': path, 'type': type, 'name': name},
    ),
    (_) {},
  );

  Future<void> renameFile(
    String projectId, {
    required String oldPath,
    required String newName,
  }) => apiCall(
    () => _dio.put<dynamic>(
      '/api/file-tree/projects/$projectId/files/rename',
      data: {'oldPath': oldPath, 'newName': newName},
    ),
    (_) {},
  );

  Future<void> deleteFile(
    String projectId, {
    required String path,
    required String type,
  }) => apiCall(
    () => _dio.delete<dynamic>(
      '/api/file-tree/projects/$projectId/files',
      data: {'path': path, 'type': type},
    ),
    (_) {},
  );

  /// Multipart upload — caller builds the FormData (files + paths).
  Future<Map<String, dynamic>> upload(String projectId, FormData formData) =>
      apiCall(
        () => _dio.post<dynamic>(
          '/api/file-tree/projects/$projectId/files/upload',
          data: formData,
          options: Options(contentType: 'multipart/form-data'),
        ),
        (d) => d as Map<String, dynamic>,
      );
}

final fileTreeRepositoryProvider = Provider<FileTreeRepository>(
  (ref) => FileTreeRepository(ref.watch(dioProvider)),
);

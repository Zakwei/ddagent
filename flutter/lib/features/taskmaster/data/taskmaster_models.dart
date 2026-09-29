/// Domain models for /api/taskmaster. Tasks come straight from tasks.json and
/// evolve per taskmaster version, so decoders are defensive and keep `raw`.
library;

String _str(Object? v) => v?.toString() ?? '';

class TaskmasterTask {
  const TaskmasterTask({
    required this.id,
    this.title = '',
    this.description = '',
    this.status = 'pending',
    this.priority = 'medium',
    this.details = '',
    this.testStrategy = '',
    this.dependencies = const [],
    this.subtasks = const [],
    this.createdAt = '',
    this.updatedAt = '',
    this.raw = const {},
  });

  /// Task ids are numeric in practice but string-ish in some taskmaster
  /// versions — keep as Object to stay comparable via [idText].
  final Object id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final String details;
  final String testStrategy;
  final List<Object?> dependencies;
  final List<TaskmasterTask> subtasks;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic> raw;

  String get idText => id.toString();

  bool get isDone => status == 'done' || status == 'cancelled';

  static TaskmasterTask fromJson(Map<String, dynamic> json) => TaskmasterTask(
    id: json['id'] as Object? ?? '',
    title: _str(json['title']).isEmpty ? 'Untitled Task' : _str(json['title']),
    description: _str(json['description']),
    status: _str(json['status']).isEmpty ? 'pending' : _str(json['status']),
    priority: _str(json['priority']).isEmpty
        ? 'medium'
        : _str(json['priority']),
    details: _str(json['details']),
    testStrategy: _str(json['testStrategy'] ?? json['test_strategy']),
    dependencies: (json['dependencies'] as List?)?.cast<Object?>() ?? const [],
    subtasks: [
      for (final s in json['subtasks'] as List? ?? const [])
        if (s is Map) TaskmasterTask.fromJson(Map<String, dynamic>.from(s)),
    ],
    createdAt: _str(json['createdAt'] ?? json['created']),
    updatedAt: _str(json['updatedAt'] ?? json['updated']),
    raw: json,
  );
}

/// Shape of `GET /api/taskmaster/tasks/:projectId` — the server already
/// normalizes tagged/legacy tasks.json into a flat `tasks` list.
class TaskmasterStatus {
  const TaskmasterStatus({
    this.projectId = '',
    this.tasks = const [],
    this.currentTag = 'master',
    this.tasksByStatus = const {},
    this.message,
  });

  final String projectId;
  final List<TaskmasterTask> tasks;
  final String currentTag;
  final Map<String, int> tasksByStatus;
  final String? message;

  bool get hasTasksFile => message == null;

  static TaskmasterStatus fromJson(Map<String, dynamic> json) {
    // Tolerate tagged (`{master: {tasks: []}}`) payloads too.
    final rawList = json['tasks'] is List
        ? json['tasks'] as List
        : json['master'] is Map && json['master']['tasks'] is List
        ? json['master']['tasks'] as List
        : const <Object?>[];
    return TaskmasterStatus(
      projectId: _str(json['projectId']),
      tasks: [
        for (final t in rawList)
          if (t is Map) TaskmasterTask.fromJson(Map<String, dynamic>.from(t)),
      ],
      currentTag: _str(json['currentTag']).isEmpty
          ? 'master'
          : _str(json['currentTag']),
      tasksByStatus: {
        for (final e in (json['tasksByStatus'] as Map? ?? const {}).entries)
          e.key.toString(): (e.value as num?)?.toInt() ?? 0,
      },
      message: json['message']?.toString(),
    );
  }
}

class TaskmasterPrdTemplate {
  const TaskmasterPrdTemplate({
    required this.id,
    this.name = '',
    this.description = '',
    this.content = '',
    this.raw = const {},
  });

  final String id;
  final String name;
  final String description;
  final String content;
  final Map<String, dynamic> raw;

  static TaskmasterPrdTemplate fromJson(Map<String, dynamic> json) =>
      TaskmasterPrdTemplate(
        id: _str(json['id'] ?? json['name'] ?? json['fileName']),
        name: _str(json['name'] ?? json['id']),
        description: _str(json['description']),
        content: _str(json['content'] ?? json['template']),
        raw: json,
      );
}

/// Feature gate — `GET /api/taskmaster/installation-status`.
class TaskmasterConfig {
  const TaskmasterConfig({
    this.isReady = false,
    this.isInstalled = false,
    this.installPath,
    this.version,
    this.mcpConfigured = false,
    this.reason,
  });

  final bool isReady;
  final bool isInstalled;
  final String? installPath;
  final String? version;
  final bool mcpConfigured;
  final String? reason;

  static TaskmasterConfig fromJson(Map<String, dynamic> json) {
    final inst = json['installation'] as Map<String, dynamic>? ?? const {};
    final mcp = json['mcpServer'] as Map<String, dynamic>? ?? const {};
    return TaskmasterConfig(
      isReady: json['isReady'] == true,
      isInstalled: inst['isInstalled'] == true,
      installPath: inst['installPath']?.toString(),
      version: inst['version']?.toString(),
      mcpConfigured: mcp['hasMCPServer'] == true,
      reason: (inst['reason'] ?? json['error'])?.toString(),
    );
  }
}

class TaskmasterPrdFile {
  const TaskmasterPrdFile({
    required this.fileName,
    this.content = '',
    this.raw = const {},
  });

  final String fileName;
  final String content;
  final Map<String, dynamic> raw;

  static TaskmasterPrdFile fromJson(Map<String, dynamic> json) =>
      TaskmasterPrdFile(
        fileName: _str(json['fileName'] ?? json['name']),
        content: _str(json['content']),
        raw: json,
      );
}

/// Knowledge models — port of the server's knowledge feature types
/// (`/api/knowledge/*`). Plain immutable classes with hand-written
/// `fromJson` factories (same style as `mcp_models.dart`, no codegen).
library;

/// Priority of a memory or rule — drives ordering/badges in the UI.
enum KnowledgePriority {
  critical('critical'),
  high('high'),
  normal('normal'),
  low('low');

  const KnowledgePriority(this.wire);

  /// Wire name — identical to the enum name today, kept for one decode point.
  final String wire;

  /// Unknown/missing values fall back to [normal].
  static KnowledgePriority parse(Object? value) => switch (value) {
    'critical' => KnowledgePriority.critical,
    'high' => KnowledgePriority.high,
    'low' => KnowledgePriority.low,
    _ => KnowledgePriority.normal,
  };

  /// Display label — `critical → Critical`.
  String get label => switch (this) {
    KnowledgePriority.critical => 'Critical',
    KnowledgePriority.high => 'High',
    KnowledgePriority.normal => 'Normal',
    KnowledgePriority.low => 'Low',
  };
}

/// Kind of knowledge entry — the `entityType` on search, graph and history rows.
enum KnowledgeEntityType {
  memory('memory'),
  rule('rule'),
  skill('skill'),
  personal('personal');

  const KnowledgeEntityType(this.wire);

  final String wire;

  /// Unknown/missing values fall back to [memory].
  static KnowledgeEntityType parse(Object? value) => switch (value) {
    'rule' => KnowledgeEntityType.rule,
    'skill' => KnowledgeEntityType.skill,
    'personal' => KnowledgeEntityType.personal,
    _ => KnowledgeEntityType.memory,
  };

  /// Display label — `personal → Personal`.
  String get label => switch (this) {
    KnowledgeEntityType.memory => 'Memory',
    KnowledgeEntityType.rule => 'Rule',
    KnowledgeEntityType.skill => 'Skill',
    KnowledgeEntityType.personal => 'Personal',
  };
}

/// One memory row from `GET /api/knowledge/memories`.
class KbMemory {
  const KbMemory({
    required this.id,
    this.projectId,
    required this.title,
    required this.content,
    required this.memoryType,
    required this.priority,
    required this.source,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;

  /// Owning project, null for global rows.
  final String? projectId;
  final String title;
  final String content;
  final String memoryType;
  final KnowledgePriority priority;
  final String source;
  final List<String> tags;
  final String createdAt;
  final String updatedAt;

  factory KbMemory.fromJson(Map<String, dynamic> json) => KbMemory(
    id: '${json['id'] ?? ''}',
    projectId: json['projectId'] as String?,
    title: '${json['title'] ?? ''}',
    content: '${json['content'] ?? ''}',
    memoryType: '${json['memoryType'] ?? ''}',
    priority: KnowledgePriority.parse(json['priority']),
    source: '${json['source'] ?? ''}',
    tags: _stringList(json['tags']),
    createdAt: '${json['createdAt'] ?? ''}',
    updatedAt: '${json['updatedAt'] ?? ''}',
  );
}

/// One rule row from `GET /api/knowledge/rules`.
class KbRule {
  const KbRule({
    required this.id,
    this.projectId,
    required this.title,
    required this.content,
    required this.priority,
    this.enabled = false,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String? projectId;
  final String title;
  final String content;
  final KnowledgePriority priority;
  final bool enabled;
  final String createdAt;
  final String updatedAt;

  factory KbRule.fromJson(Map<String, dynamic> json) => KbRule(
    id: '${json['id'] ?? ''}',
    projectId: json['projectId'] as String?,
    title: '${json['title'] ?? ''}',
    content: '${json['content'] ?? ''}',
    priority: KnowledgePriority.parse(json['priority']),
    enabled: json['enabled'] == true,
    createdAt: '${json['createdAt'] ?? ''}',
    updatedAt: '${json['updatedAt'] ?? ''}',
  );
}

/// One skill row from `GET /api/knowledge/skills`.
class KbSkill {
  const KbSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.content,
    required this.category,
    required this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final String content;
  final String category;
  final String icon;
  final String createdAt;
  final String updatedAt;

  factory KbSkill.fromJson(Map<String, dynamic> json) => KbSkill(
    id: '${json['id'] ?? ''}',
    name: '${json['name'] ?? ''}',
    description: '${json['description'] ?? ''}',
    content: '${json['content'] ?? ''}',
    category: '${json['category'] ?? ''}',
    icon: '${json['icon'] ?? ''}',
    createdAt: '${json['createdAt'] ?? ''}',
    updatedAt: '${json['updatedAt'] ?? ''}',
  );
}

/// One personal-info row from `GET /api/knowledge/personal`.
class KbPersonal {
  const KbPersonal({
    required this.id,
    required this.key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String key;
  final String title;
  final String content;
  final String createdAt;
  final String updatedAt;

  factory KbPersonal.fromJson(Map<String, dynamic> json) => KbPersonal(
    id: '${json['id'] ?? ''}',
    key: '${json['key'] ?? ''}',
    title: '${json['title'] ?? ''}',
    content: '${json['content'] ?? ''}',
    createdAt: '${json['createdAt'] ?? ''}',
    updatedAt: '${json['updatedAt'] ?? ''}',
  );
}

/// One tag with its usage count from `GET /api/knowledge/tags`.
class KbTag {
  const KbTag({required this.id, required this.name, required this.count});

  final int id;
  final String name;
  final int count;

  factory KbTag.fromJson(Map<String, dynamic> json) => KbTag(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: '${json['name'] ?? ''}',
    count: (json['count'] as num?)?.toInt() ?? 0,
  );
}

/// One edge between two knowledge entities (`GET /api/knowledge/connections`).
class KbConnection {
  const KbConnection({
    required this.id,
    required this.sourceId,
    required this.sourceType,
    required this.targetId,
    required this.targetType,
    required this.relationship,
    this.weight = 1,
    required this.createdAt,
  });

  final String id;
  final String sourceId;
  final String sourceType;
  final String targetId;
  final String targetType;
  final String relationship;
  final double weight;
  final String createdAt;

  factory KbConnection.fromJson(Map<String, dynamic> json) => KbConnection(
    id: '${json['id'] ?? ''}',
    sourceId: '${json['sourceId'] ?? ''}',
    sourceType: '${json['sourceType'] ?? ''}',
    targetId: '${json['targetId'] ?? ''}',
    targetType: '${json['targetType'] ?? ''}',
    relationship: '${json['relationship'] ?? ''}',
    weight: (json['weight'] as num?)?.toDouble() ?? 1,
    createdAt: '${json['createdAt'] ?? ''}',
  );
}

/// One hit from `GET /api/knowledge/search`.
class KbSearchResult {
  const KbSearchResult({
    required this.entityType,
    required this.entityId,
    this.projectId,
    required this.title,
    required this.snippet,
    this.score = 1,
  });

  final KnowledgeEntityType entityType;
  final String entityId;
  final String? projectId;
  final String title;
  final String snippet;
  final double score;

  factory KbSearchResult.fromJson(Map<String, dynamic> json) => KbSearchResult(
    entityType: KnowledgeEntityType.parse(json['entityType']),
    entityId: '${json['entityId'] ?? ''}',
    projectId: json['projectId'] as String?,
    title: '${json['title'] ?? ''}',
    snippet: '${json['snippet'] ?? ''}',
    score: (json['score'] as num?)?.toDouble() ?? 1,
  );
}

/// One row from `GET /api/knowledge/history` — the content snapshot at write time.
class KbHistoryEntry {
  const KbHistoryEntry({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final KnowledgeEntityType entityType;
  final String entityId;
  final String title;
  final String content;
  final String createdAt;

  factory KbHistoryEntry.fromJson(Map<String, dynamic> json) => KbHistoryEntry(
    id: '${json['id'] ?? ''}',
    entityType: KnowledgeEntityType.parse(json['entityType']),
    entityId: '${json['entityId'] ?? ''}',
    title: '${json['title'] ?? ''}',
    content: '${json['content'] ?? ''}',
    createdAt: '${json['createdAt'] ?? ''}',
  );
}

/// Counters from `GET /api/knowledge/stats`.
class KbStats {
  const KbStats({
    this.memories = 0,
    this.rules = 0,
    this.skills = 0,
    this.personal = 0,
    this.connections = 0,
  });

  final int memories;
  final int rules;
  final int skills;
  final int personal;
  final int connections;

  factory KbStats.fromJson(Map<String, dynamic> json) => KbStats(
    memories: (json['memories'] as num?)?.toInt() ?? 0,
    rules: (json['rules'] as num?)?.toInt() ?? 0,
    skills: (json['skills'] as num?)?.toInt() ?? 0,
    personal: (json['personal'] as num?)?.toInt() ?? 0,
    connections: (json['connections'] as num?)?.toInt() ?? 0,
  );
}

/// One graph node — a knowledge entity, or an implicit `project` / `tag` hub,
/// plus its display label.
class KbGraphNode {
  const KbGraphNode({
    required this.id,
    required this.nodeType,
    required this.label,
    this.projectId,
    this.priority,
    this.icon,
  });

  final String id;

  /// Raw node type: `memory`/`rule`/`skill`/`personal`, plus the implicit
  /// `project` and `tag` hubs the server adds so the graph has structure.
  final String nodeType;
  final String label;
  final String? projectId;

  /// Raw priority wire name (`critical`/`high`/`normal`/`low`) when set.
  final String? priority;
  final String? icon;

  factory KbGraphNode.fromJson(Map<String, dynamic> json) => KbGraphNode(
    id: '${json['id'] ?? ''}',
    nodeType: '${json['nodeType'] ?? 'memory'}',
    label: '${json['label'] ?? ''}',
    projectId: json['projectId'] as String?,
    priority: json['priority'] as String?,
    icon: json['icon'] as String?,
  );
}

/// One graph edge between two [`KbGraphNode`] ids.
class KbGraphEdge {
  const KbGraphEdge({
    required this.id,
    required this.source,
    required this.target,
    required this.relationship,
    this.weight = 1,
  });

  final String id;
  final String source;
  final String target;
  final String relationship;
  final double weight;

  factory KbGraphEdge.fromJson(Map<String, dynamic> json) => KbGraphEdge(
    id: '${json['id'] ?? ''}',
    source: '${json['source'] ?? ''}',
    target: '${json['target'] ?? ''}',
    relationship: '${json['relationship'] ?? ''}',
    weight: (json['weight'] as num?)?.toDouble() ?? 1,
  );
}

/// Graph payload from `GET /api/knowledge/graph`.
class KbGraph {
  const KbGraph({
    this.nodes = const [],
    this.edges = const [],
    this.truncated = false,
    this.counts = const {},
  });

  final List<KbGraphNode> nodes;
  final List<KbGraphEdge> edges;

  /// True when the server capped the node/edge set.
  final bool truncated;

  /// Per-entity-type totals, before truncation.
  final Map<String, int> counts;

  factory KbGraph.fromJson(Map<String, dynamic> json) => KbGraph(
    nodes: _nodeList(json['nodes']),
    edges: _edgeList(json['edges']),
    truncated: json['truncated'] == true,
    counts: _intMap(json['counts']),
  );
}

/// Result of `POST /api/knowledge/scan` for one project.
class KnowledgeScanResult {
  const KnowledgeScanResult({
    required this.projectId,
    this.scanned = 0,
    this.imported = 0,
    this.updated = 0,
    this.skipped = 0,
    this.deleted = 0,
    this.files = const [],
  });

  final String projectId;
  final int scanned;
  final int imported;
  final int updated;
  final int skipped;
  final int deleted;

  /// Source files the scan read, relative to the project root.
  final List<String> files;

  factory KnowledgeScanResult.fromJson(Map<String, dynamic> json) => KnowledgeScanResult(
    projectId: '${json['projectId'] ?? ''}',
    scanned: (json['scanned'] as num?)?.toInt() ?? 0,
    imported: (json['imported'] as num?)?.toInt() ?? 0,
    updated: (json['updated'] as num?)?.toInt() ?? 0,
    skipped: (json['skipped'] as num?)?.toInt() ?? 0,
    deleted: (json['deleted'] as num?)?.toInt() ?? 0,
    files: _stringList(json['files']),
  );
}

List<String> _stringList(Object? value) => value is List
    ? [
        for (final e in value)
          if (e is String) e,
      ]
    : const [];

Map<String, int> _intMap(Object? value) => value is Map
    ? {for (final e in value.entries) '${e.key}': (e.value as num?)?.toInt() ?? 0}
    : const {};

List<KbGraphNode> _nodeList(Object? value) => value is List
    ? [
        for (final e in value)
          if (e is Map<String, dynamic>) KbGraphNode.fromJson(e),
      ]
    : const [];

List<KbGraphEdge> _edgeList(Object? value) => value is List
    ? [
        for (final e in value)
          if (e is Map<String, dynamic>) KbGraphEdge.fromJson(e),
      ]
    : const [];

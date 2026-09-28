/// Pure parsing helpers for orchestrator transcript payloads — port of the
/// defensive readers in `OrchestratorCards.tsx`. Dependency-free for tests.
class PlanStep {
  const PlanStep({
    required this.id,
    required this.type,
    required this.title,
    required this.dependsOn,
    this.enabled = true,
    this.command,
  });

  final String id;
  final String type;
  final String title;
  final List<String> dependsOn;
  final bool enabled;
  final String? command;

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'title': title,
    'dependsOn': dependsOn,
    'enabled': enabled,
    if (command != null) 'command': command,
  };

  PlanStep copyWith({bool? enabled}) => PlanStep(
    id: id,
    type: type,
    title: title,
    dependsOn: dependsOn,
    enabled: enabled ?? this.enabled,
    command: command,
  );
}

String? str(Object? value) =>
    value is String && value.trim().isNotEmpty ? value : null;

List<String> strList(Object? value) => value is List
    ? [
        for (final e in value)
          if ('$e'.trim().isNotEmpty) '$e',
      ]
    : const [];

num? numVal(Object? value) =>
    value is num ? value : num.tryParse(value?.toString() ?? '');

List<PlanStep> readSteps(Object? value) {
  if (value is! List) return const [];
  return [
    for (var i = 0; i < value.length; i++)
      if (value[i] is Map)
        () {
          final raw = Map<String, dynamic>.from(value[i] as Map);
          return PlanStep(
            id: str(raw['id']) ?? 'step-${i + 1}',
            type: str(raw['type']) ?? 'task',
            title: str(raw['title']) ?? 'Step ${i + 1}',
            dependsOn: strList(raw['dependsOn']),
            enabled: raw['enabled'] != false,
            command: str(raw['command']),
          );
        }(),
  ];
}

List<({String title, String summary})> readResults(Object? value) {
  if (value is! List) return const [];
  return [
    for (final r in value)
      if (r is Map)
        if (str(r['title']) != null && str(r['summary']) != null)
          (title: str(r['title'])!, summary: str(r['summary'])!),
  ];
}

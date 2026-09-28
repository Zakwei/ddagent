/// Domain models for /api/shared-context — mirrors server/modules/shared-context/shared-context.service.ts.
library;

String _str(Object? v) => v?.toString() ?? '';
String? _strOrNull(Object? v) => v?.toString();

class SharedContextDocument {
  const SharedContextDocument({
    this.content = '',
    this.updatedAt,
  });

  final String content;
  final String? updatedAt;

  static SharedContextDocument fromJson(Map<String, dynamic> j) => SharedContextDocument(
        content: _str(j['content']),
        updatedAt: _strOrNull(j['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'content': content,
        'updatedAt': updatedAt,
      };
}

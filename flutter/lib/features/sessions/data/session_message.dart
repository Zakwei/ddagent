/// Normalized session message — port of `NormalizedMessage` from
/// `src/stores/useSessionStore.ts` (server/adapters/types.js shape).
/// Fields are flat for parity; unused ones stay null.
class SessionMessage {
  const SessionMessage({
    required this.id,
    required this.sessionId,
    required this.timestamp,
    required this.provider,
    required this.kind,
    this.seq,
    this.runId,
    this.role,
    this.content,
    this.displayText,
    this.commandName,
    this.commandMessage,
    this.commandArgs,
    this.isLocalCommand = false,
    this.isLocalCommandStdout = false,
    this.isCompactSummary = false,
    this.images,
    this.files,
    this.toolName,
    this.toolInput,
    this.toolId,
    this.toolResult,
    this.isError = false,
    this.text,
    this.tokens,
    this.canInterrupt,
    this.requestId,
    this.context,
    this.status,
    this.summary,
    this.exitCode,
    this.actualSessionId,
    this.parentToolUseId,
    this.isFinal = false,
    this.sequence,
    this.rowid,
  });

  final String id;
  final String sessionId;
  final String timestamp;
  final String provider;
  final String kind;

  /// Per-run monotonic seq assigned to live WS events; REST rows carry none.
  final int? seq;

  /// Identifies the run that produced this live event; seq restarts per run.
  final String? runId;

  final String? role; // 'user' | 'assistant'
  final String? content;
  final String? displayText;
  final String? commandName;
  final String? commandMessage;
  final String? commandArgs;
  final bool isLocalCommand;
  final bool isLocalCommandStdout;
  final bool isCompactSummary;
  final List<Map<String, dynamic>>? images;
  final List<Map<String, dynamic>>? files;
  final String? toolName;
  final dynamic toolInput;
  final String? toolId;
  final Map<String, dynamic>? toolResult;
  final bool isError;
  final String? text;
  final int? tokens;
  final bool? canInterrupt;
  final String? requestId;

  /// Orchestrator/interactive prompt payload — `context.orchestratorKind`
  /// identifies status rows for cross-id dedupe.
  final Map<String, dynamic>? context;
  final String? status;
  final String? summary;
  final int? exitCode;
  final String? actualSessionId;
  final String? parentToolUseId;
  final bool isFinal;

  // Cursor-specific ordering
  final int? sequence;
  final int? rowid;

  bool get isLocalEcho => id.startsWith('local_');
  bool get isUserText => kind == 'text' && role == 'user';

  SessionMessage copyWith({
    String? id,
    String? timestamp,
    String? kind,
    String? role,
    String? content,
    int? seq,
    String? runId,
    Map<String, dynamic>? toolResult,
  }) => SessionMessage(
    id: id ?? this.id,
    sessionId: sessionId,
    timestamp: timestamp ?? this.timestamp,
    provider: provider,
    kind: kind ?? this.kind,
    seq: seq ?? this.seq,
    runId: runId ?? this.runId,
    role: role ?? this.role,
    content: content ?? this.content,
    displayText: displayText,
    commandName: commandName,
    commandMessage: commandMessage,
    commandArgs: commandArgs,
    isLocalCommand: isLocalCommand,
    isLocalCommandStdout: isLocalCommandStdout,
    isCompactSummary: isCompactSummary,
    images: images,
    files: files,
    toolName: toolName,
    toolInput: toolInput,
    toolId: toolId,
    toolResult: toolResult ?? this.toolResult,
    isError: isError,
    text: text,
    tokens: tokens,
    canInterrupt: canInterrupt,
    requestId: requestId,
    context: context,
    status: status,
    summary: summary,
    exitCode: exitCode,
    actualSessionId: actualSessionId,
    parentToolUseId: parentToolUseId,
    isFinal: isFinal,
    sequence: sequence,
    rowid: rowid,
  );

  static int? _int(dynamic v) => v is num ? v.toInt() : null;

  static List<Map<String, dynamic>>? _mapList(dynamic v) => v is List
      ? [
          for (final e in v)
            if (e is Map) Map<String, dynamic>.from(e),
        ]
      : null;

  factory SessionMessage.fromJson(Map<String, dynamic> j) => SessionMessage(
    id: j['id']?.toString() ?? '',
    sessionId: j['sessionId']?.toString() ?? '',
    timestamp: j['timestamp']?.toString() ?? '',
    provider: j['provider']?.toString() ?? '',
    kind: j['kind']?.toString() ?? 'text',
    seq: _int(j['seq']),
    runId: j['runId']?.toString(),
    role: j['role']?.toString(),
    content: j['content']?.toString(),
    displayText: j['displayText']?.toString(),
    commandName: j['commandName']?.toString(),
    commandMessage: j['commandMessage']?.toString(),
    commandArgs: j['commandArgs']?.toString(),
    isLocalCommand: j['isLocalCommand'] == true,
    isLocalCommandStdout: j['isLocalCommandStdout'] == true,
    isCompactSummary: j['isCompactSummary'] == true,
    images: _mapList(j['images']),
    files: _mapList(j['files']),
    toolName: j['toolName']?.toString(),
    toolInput: j['toolInput'],
    toolId: j['toolId']?.toString(),
    toolResult: j['toolResult'] is Map
        ? Map<String, dynamic>.from(j['toolResult'] as Map)
        : null,
    isError: j['isError'] == true,
    text: j['text']?.toString(),
    tokens: _int(j['tokens']),
    canInterrupt: j['canInterrupt'] is bool ? j['canInterrupt'] as bool : null,
    requestId: j['requestId']?.toString(),
    context: j['context'] is Map
        ? Map<String, dynamic>.from(j['context'] as Map)
        : null,
    status: j['status']?.toString(),
    summary: j['summary']?.toString(),
    exitCode: _int(j['exitCode']),
    actualSessionId: j['actualSessionId']?.toString(),
    parentToolUseId: j['parentToolUseId']?.toString(),
    isFinal: j['isFinal'] == true,
    sequence: _int(j['sequence']),
    rowid: _int(j['rowid']),
  );
}

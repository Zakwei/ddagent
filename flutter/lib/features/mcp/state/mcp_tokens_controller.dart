import 'dart:async';

import 'package:ddagent_app/core/network/api_error.dart';
import 'package:ddagent_app/features/mcp/data/mcp_models.dart';
import 'package:ddagent_app/features/mcp/data/mcp_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Token list state — port of the `McpServerTokens.tsx` locals.
class McpTokensState {
  const McpTokensState({
    this.tokens = const [],
    this.busy = false,
    this.freshToken,
    this.error,
  });

  final List<McpToken> tokens;

  /// Create-in-progress flag (`busy` in the web component).
  final bool busy;

  /// Plaintext of the just-created token — shown exactly once, dismissible.
  final String? freshToken;
  final String? error;

  McpTokensState copyWith({
    List<McpToken>? tokens,
    bool? busy,
    String? Function()? freshToken,
    String? Function()? error,
  }) => McpTokensState(
    tokens: tokens ?? this.tokens,
    busy: busy ?? this.busy,
    freshToken: freshToken != null ? freshToken() : this.freshToken,
    error: error != null ? error() : this.error,
  );
}

/// `/api/mcp/tokens` CRUD — bearer tokens for ddagent's own MCP endpoint
/// (`POST /mcp`), used by external tools like Claude Desktop or OpenClaw.
class McpTokensController extends Notifier<McpTokensState> {
  McpRepository get _repo => ref.read(mcpRepositoryProvider);

  @override
  McpTokensState build() {
    unawaited(Future.microtask(refresh));
    return const McpTokensState();
  }

  Future<void> refresh() async {
    try {
      final tokens = await _repo.tokens();
      if (ref.mounted) {
        state = state.copyWith(tokens: tokens, error: () => null);
      }
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }

  /// `create` — label defaults server-side to `mcp-client` when blank.
  Future<String?> create(String label, String scope) async {
    state = state.copyWith(busy: true);
    try {
      final token = await _repo.createToken(
        label: label.trim().isEmpty ? 'mcp-client' : label.trim(),
        scope: scope,
      );
      if (!ref.mounted) return null;
      state = state.copyWith(busy: false, freshToken: () => token);
      await refresh();
      return null;
    } on AppError catch (e) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, error: () => e.message);
      }
      return e.message;
    }
  }

  /// `revoke` — web fires without a confirm; same here.
  Future<void> revoke(String id) async {
    try {
      await _repo.revokeToken(id);
      await refresh();
    } on AppError catch (e) {
      if (ref.mounted) state = state.copyWith(error: () => e.message);
    }
  }

  void dismissFreshToken() => state = state.copyWith(freshToken: () => null);
}

final mcpTokensProvider = NotifierProvider.autoDispose(McpTokensController.new);

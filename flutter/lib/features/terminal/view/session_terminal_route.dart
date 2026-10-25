import 'dart:async';

import 'package:ddagent_app/core/widgets/app_spinner.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/terminal/state/session_terminal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// `/chat/:id` — every link that opens a session (board cards, scheduler
/// runs, notifications, `ddagent://chat/<id>`) lands here: the session is
/// resumed in a terminal tab and the route hands over to the screen that
/// shows it.
class SessionTerminalRoute extends ConsumerStatefulWidget {
  const SessionTerminalRoute({super.key, required this.sessionId});

  final String sessionId;

  @override
  ConsumerState<SessionTerminalRoute> createState() => _SessionTerminalRouteState();
}

class _SessionTerminalRouteState extends ConsumerState<SessionTerminalRoute> {
  @override
  void initState() {
    super.initState();
    unawaited(_open());
  }

  Future<void> _open() async {
    final result = await openSessionInTerminal(
      ProviderScope.containerOf(context, listen: false),
      widget.sessionId,
    );
    if (!mounted) return;
    final error = result.error;
    // Global: this route is replaced right away.
    if (error != null) AppToast.global(error, isError: true);
    context.go(result.route ?? '/workspace');
  }

  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: AppSpinner()));
}

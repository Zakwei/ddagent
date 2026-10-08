import 'dart:async';
import 'dart:convert';
import 'dart:ui' show PointerDeviceKind;

import 'package:ddagent_app/core/theme/app_theme.dart';
import 'package:ddagent_app/core/theme/breakpoints.dart';
import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/utils/clipboard.dart';
import 'package:ddagent_app/core/utils/selection_copy.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_dialog.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_markdown.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/core/widgets/auth_image.dart';
import 'package:ddagent_app/features/chat/state/pending_permissions.dart';
import 'package:ddagent_app/features/chat/state/transcript_controller.dart';
import 'package:ddagent_app/features/chat/state/transcript_tools_controller.dart';
import 'package:ddagent_app/features/chat/view/chat_utilities.dart';
import 'package:ddagent_app/features/chat/view/composer.dart';
import 'package:ddagent_app/features/chat/view/session_subheader.dart';
import 'package:ddagent_app/features/chat/view/tool_blocks.dart';
import 'package:ddagent_app/features/collab/role.dart';
import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/features/file_tree/data/file_saver.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_repository.dart';
import 'package:ddagent_app/features/misc/data/misc_repository.dart';
import 'package:ddagent_app/features/orchestrator/view/orchestrator_cards.dart';
import 'package:ddagent_app/features/sessions/data/session_message.dart';
import 'package:ddagent_app/features/sessions/data/sessions_repository.dart';
import 'package:ddagent_app/features/sessions/state/activity_poller.dart';
import 'package:ddagent_app/features/sessions/state/session_store.dart';
import 'package:ddagent_app/features/sessions/state/sessions_controller.dart';
import 'package:ddagent_app/features/sessions/view/session_list_row.dart';
import 'package:ddagent_app/features/settings/state/ui_preferences_controller.dart';
import 'package:ddagent_app/features/taskmaster/data/taskmaster_repository.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:ddagent_app/features/workspace/state/split_workspace.dart';
import 'package:ddagent_app/features/workspace/view/pane_header_metrics.dart';
import 'package:ddagent_app/features/workspace/view/pane_session_header.dart';
import 'package:ddagent_app/features/workspace/view/split_workspace_grid.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show ScrollDirection;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

/// Transcript pane for one session (T13): virtualized list of all
/// MessageKinds, top-of-list older-page loading, jump-to-bottom + unread
/// counter, presence announce (`{kind:'session'}`) while mounted.
class TranscriptView extends ConsumerStatefulWidget {
  const TranscriptView({
    required this.sessionId,
    this.projectId,
    this.projectPath,
    this.initialProvider,
    this.initialAccountId,
    this.dense = false,
    this.standalone = false,
    this.onOpenFile,
    super.key,
  });

  final String sessionId;
  final String? projectId;
  final String? projectPath;

  /// Draft (`/chat/new`) provider/account picked in the new-chat dialog — used
  /// until the session row resolves, so a fresh session mounts the composer on
  /// the chosen provider with the chosen account pre-selected.
  final String? initialProvider;
  final String? initialAccountId;

  /// In-pane editor open (web `onFileOpen`) — the workspace wires this to
  /// `openFileInEditor`; standalone routes fall back to `/editor`.
  final void Function(String path)? onOpenFile;

  /// `[data-split-rows="2"]` parity — the subheader collapses to a slim
  /// strip (no path/separators) when the split grid stacks two rows.
  final bool dense;

  /// True on the standalone `/chat/:id` route — the web renders the session
  /// inside `MainContent` with a `PaneSessionHeader` row on top, so the
  /// route adds the same header chrome (kept OUTSIDE the oc-chat theme,
  /// it's app chrome not chat chrome).
  final bool standalone;

  @override
  ConsumerState<TranscriptView> createState() => _TranscriptViewState();
}

class _TranscriptViewState extends ConsumerState<TranscriptView> {
  var _itemScroll = ItemScrollController();
  var _positions = ItemPositionsListener.create();

  // Intent, never inferred from item indices or layout/metrics changes.
  bool _following = true;
  bool _userScrollingDown = false;
  bool _pointerDown = false;
  bool _searchActive = false;
  bool _followScheduled = false;
  int _scrollGeneration = 0;
  double _viewportHeight = 0;
  (int, double, Object?)? _visibleAnchor;
  TranscriptToolsController? _toolsController;
  static const _tailHeight = 16.0;
  static const _scrollTolerance = 1.0;
  int _unread = 0;
  int _seenCount = 0;
  int _rowCount = 0;
  String _transcriptSelection = '';

  /// Composers keep their own node internally; this shared one is passed in
  /// so `focusFollowsPointer` can target the field from the pane level
  /// (web `textareaRef`).
  final _composerHoverFocus = FocusNode();

  /// First provider resolved from real data (session row or transcript tail).
  /// The composer is provider-keyed, so mounting it under the `claude`
  /// fallback before the session row loads would run its entire init twice —
  /// once for the guess, once for the real provider. `null` until known.
  String? _resolvedProvider;

  // T17.7 scroll anchoring — rows from the last build, used to resolve a
  // position index into a stable row key before layout catches up.
  List<Object> _lastRows = const [];

  @override
  void initState() {
    super.initState();
    _positions.itemPositions.addListener(_onPositionsChanged);
  }

  bool get _tailAligned {
    if (_viewportHeight <= 0) return false;
    final positions = _positions.itemPositions.value;
    final tail = positions.any((p) => p.index == _rowCount);
    if (!tail) return false;
    // Transcript shorter than the viewport: the tail can never reach the
    // bottom edge, so "everything visible" already means aligned. Without
    // this the correction loop jumps every frame forever.
    final topVisible = positions.any(
      (p) => p.index == 0 && p.itemLeadingEdge >= -_scrollTolerance / _viewportHeight,
    );
    if (topVisible) return true;
    return positions.any(
      (p) =>
          p.index == _rowCount &&
          (p.itemTrailingEdge - 1).abs() <= _scrollTolerance / _viewportHeight,
    );
  }

  void _onPositionsChanged() {
    if (!mounted) return;
    final visible = _positions.itemPositions.value.where(
      (p) => p.index < _rowCount && p.itemTrailingEdge > 0 && p.itemLeadingEdge < 1,
    );
    if (visible.isNotEmpty) {
      final first = visible.reduce((a, b) => a.index < b.index ? a : b);
      // Pixels from the row's top to the viewport BOTTOM, not the top-relative
      // itemLeadingEdge: the load-older chrome swap (button row ↔ 24px spinner)
      // moves the viewport's top edge while its bottom edge stays pinned to
      // the pane's bottom — bottom-distance survives the swap, top-distance
      // lands the anchor one chrome-height off.
      _visibleAnchor = (
        first.index,
        (1 - first.itemLeadingEdge) * _viewportHeight,
        first.index < _lastRows.length ? _rowKey(_lastRows[first.index]) : null,
      );
    }
    // Geometry can request a correction, but cannot change follow intent.
    if (!_tailAligned) _scheduleFollow();
  }

  void _setFollowing(bool value) {
    if (_following == value && (!value || _unread == 0)) return;
    setState(() {
      _following = value;
      if (value) _unread = 0;
    });
  }

  bool _onScrollNotification(ScrollNotification notification) {
    // Ignore nested code blocks and other scrollable message contents.
    if (notification.depth != 0 || notification.metrics.axis != Axis.vertical) {
      return false;
    }
    if (notification is UserScrollNotification) {
      _userScrollingDown = notification.direction == ScrollDirection.reverse;
      if (notification.direction == ScrollDirection.forward) {
        _setFollowing(false);
      }
    }
    // Updates from a drag (including its ballistic continuation) or wheel
    // carry user intent. jumpTo/layout corrections never set this flag.
    if (_userScrollingDown &&
        ((notification is ScrollUpdateNotification && (notification.scrollDelta ?? 0) > 0) ||
            (notification is OverscrollNotification && notification.overscroll > 0)) &&
        notification.metrics.extentAfter <= _scrollTolerance) {
      _setFollowing(true);
    }
    return false;
  }

  bool _onMetricsNotification(ScrollMetricsNotification notification) {
    if (notification.depth == 0 && notification.metrics.axis == Axis.vertical) {
      _scheduleFollow();
    }
    return false;
  }

  void _onPointerDown(PointerDownEvent _) => _pointerDown = true;

  void _onPointerUp(PointerEvent _) {
    if (!_pointerDown) return;
    _pointerDown = false;
    // Selection only pauses corrections; releasing must catch up even when
    // no more messages or metric notifications arrive.
    _scheduleFollow();
  }

  void _scheduleFollow() {
    if (!mounted || !_following || _pointerDown || _searchActive || _followScheduled) {
      return;
    }
    _followScheduled = true;
    final generation = _scrollGeneration;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _scrollGeneration) return;
      _followScheduled = false;
      if (!_following ||
          _pointerDown ||
          _searchActive ||
          !_itemScroll.isAttached ||
          _rowCount == 0 ||
          _viewportHeight <= _scrollTolerance ||
          _tailAligned) {
        return;
      }
      _userScrollingDown = false;
      // A fixed-height final row aligns the actual end, even when the last
      // message is taller than the viewport. No animation can outlive a new
      // user gesture or compete with streaming updates.
      _itemScroll.jumpTo(
        index: _rowCount,
        alignment: (1 - _tailHeight / _viewportHeight).clamp(0.0, 1.0),
      );
    });
    // addPostFrameCallback alone doesn't request a frame when called from
    // another post-frame listener. Corrections stop once the tail is visible.
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _scrollToIndex(int index) {
    if (!mounted || !_itemScroll.isAttached || index < 0 || index >= _rowCount) {
      return;
    }
    _userScrollingDown = false;
    _itemScroll.jumpTo(index: index);
  }

  /// Stable display identity for a transcript row — tool groups key on their
  /// first message, matching the ValueKey used by the itemBuilder.
  Object _rowKey(Object row) =>
      row is ToolGroup ? row.messages.first.id : (row as SessionMessage).id;

  int _indexOfRowKey(List<Object> rows, Object key) {
    for (var i = 0; i < rows.length; i++) {
      if (_rowKey(rows[i]) == key) return i;
    }
    return -1;
  }

  void _clearToolsCallback() {
    if (_toolsController?.onScrollToIndex == _scrollToIndex) {
      _toolsController?.onScrollToIndex = null;
    }
    _toolsController = null;
  }

  @override
  void didUpdateWidget(covariant TranscriptView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sessionId == widget.sessionId) return;
    _clearToolsCallback();
    _positions.itemPositions.removeListener(_onPositionsChanged);
    _positions = ItemPositionsListener.create();
    _positions.itemPositions.addListener(_onPositionsChanged);
    _itemScroll = ItemScrollController();
    _scrollGeneration++;
    _followScheduled = false;
    _following = true;
    _userScrollingDown = false;
    _pointerDown = false;
    _searchActive = false;
    _viewportHeight = 0;
    _visibleAnchor = null;
    _lastRows = const [];
    _rowCount = 0;
    _seenCount = 0;
    _unread = 0;
    _resolvedProvider = null;
  }

  @override
  void dispose() {
    _scrollGeneration++;
    _composerHoverFocus.dispose();
    _positions.itemPositions.removeListener(_onPositionsChanged);
    _clearToolsCallback();
    super.dispose();
  }

  /// `focusFollowsPointer` pref (web ChatInterface `onPointerEnter`) —
  /// hovering the chat pane gives its composer keyboard focus. Same
  /// commit-on-blur guard as the terminal side.
  void _onPanePointerEnter(PointerEnterEvent event) {
    if (event.kind != PointerDeviceKind.mouse) return;
    if (!ref.read(uiPreferencesProvider).focusFollowsPointer) return;
    if (hoverFocusBlockedByField()) return;
    _composerHoverFocus.requestFocus();
  }

  void _loadOlder() =>
      unawaited(ref.read(transcriptProvider(widget.sessionId).notifier).loadOlder());

  /// Web `loadAllMessages` — pull every remaining page in one go. The generic
  /// row-key anchor in build() keeps the viewport on the same row across the
  /// prepends this triggers.
  void _loadAll() => unawaited(ref.read(transcriptProvider(widget.sessionId).notifier).loadAll());

  void _openChangedFile(String path) {
    if (widget.projectId == null) return;
    ref.read(transcriptToolsProvider(widget.sessionId).notifier).closeReview();
    final open = widget.onOpenFile;
    if (open != null) {
      open(path);
      return;
    }
    context.go(
      '/editor?projectId=${widget.projectId}'
      '&file=${Uri.encodeComponent(path)}',
    );
  }

  /// ReviewFilesPanel.tsx — swapped in for the transcript while `reviewOpen`;
  /// Escape or × returns to chat.
  Widget _reviewPanel(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final tools = ref.watch(transcriptToolsProvider(widget.sessionId));
    final controller = ref.read(transcriptToolsProvider(widget.sessionId).notifier);
    final files = tools.reviewFiles;
    final review = Translations.of(context).chat.review;
    return Focus(
      autofocus: true,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
          controller.closeReview();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: LayoutBuilder(
        // Pane width, not window width — in split panes MediaQuery would
        // compute padding bigger than the tile and collapse the column.
        builder: (context, constraints) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _readingColumnPadding(constraints.maxWidth),
            vertical: 12,
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: c.card.withValues(alpha: 0.6),
              border: Border.all(color: c.border.withValues(alpha: 0.6)),
              borderRadius: AppRadii.borderLg,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.6))),
                  ),
                  child: Row(
                    spacing: 8,
                    children: [
                      Text(
                        !tools.reviewLoading && files.isNotEmpty
                            ? review.changedFilesCount(count: files.length)
                            : review.changedFiles,
                        style: t.labelSmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: c.foreground,
                        ),
                      ),
                      const Spacer(),
                      tools.reviewLoading
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _toolIcon(context, LucideIcons.refreshCw, controller.loadReviewFiles),
                      _toolIcon(context, LucideIcons.x, controller.closeReview),
                    ],
                  ),
                ),
                Expanded(child: _reviewBody(context, files)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _reviewBody(BuildContext context, List<Map<String, dynamic>> files) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final tools = ref.watch(transcriptToolsProvider(widget.sessionId));
    if (tools.reviewLoading && files.isEmpty) {
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2)),
            Text(
              i18n.settings.changelog.loading,
              style: t.labelSmall?.copyWith(fontSize: 12, color: c.mutedForeground),
            ),
          ],
        ),
      );
    }
    if (tools.reviewError) {
      return Center(
        child: SessionListEmptyState(
          icon: LucideIcons.triangleAlert,
          label: i18n.chat.changes.failedToLoad,
        ),
      );
    }
    if (files.isEmpty) {
      return Center(
        child: SessionListEmptyState(icon: LucideIcons.fileDiff, label: i18n.chat.changes.empty),
      );
    }
    return Opacity(
      opacity: tools.reviewLoading ? 0.6 : 1,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: files.length,
        itemBuilder: (_, i) => _reviewFileRow(context, files[i]),
      ),
    );
  }

  /// One ReviewFilesPanel row — basename over dirname, `subagent` badge and
  /// `x{edits}` count on the right.
  Widget _reviewFileRow(BuildContext context, Map<String, dynamic> f) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final path = f['path']?.toString() ?? f['file']?.toString() ?? '';
    final normalized = path.replaceAll('\\', '/');
    final slash = normalized.lastIndexOf('/');
    final basename = slash < 0 ? normalized : normalized.substring(slash + 1);
    final dirname = slash < 0 ? '' : normalized.substring(0, slash);
    final edits = (f['edits'] as num?)?.toInt() ?? 0;
    return InkWell(
      onTap: path.isEmpty ? null : () => _openChangedFile(path),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          spacing: 8,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    basename,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.labelSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: c.foreground,
                    ),
                  ),
                  if (dirname.isNotEmpty)
                    Text(
                      dirname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
                    ),
                ],
              ),
            ),
            if (f['subagent'] == true)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(color: c.muted, borderRadius: AppRadii.borderSm),
                child: Text(
                  Translations.of(context).chat.review.subagent,
                  style: t.labelSmall?.copyWith(fontSize: 9, color: c.mutedForeground),
                ),
              ),
            if (edits > 1)
              Text(
                'x$edits',
                style: t.labelSmall?.copyWith(fontSize: 10, color: c.mutedForeground),
              ),
          ],
        ),
      ),
    );
  }

  void _jumpToBottom() {
    _setFollowing(true);
    _scheduleFollow();
  }

  /// `.chat-messages-pane` content — the virtualized transcript column.
  Widget _messagesList(GroupedTranscript grouped, List<SessionMessage> messages) {
    final sessionId = widget.sessionId;
    // Pane width, not window width — MediaQuery measures the whole window, so
    // in split panes the padding outgrew the tile and collapsed the column
    // to zero (black transcript).
    return LayoutBuilder(
      builder: (context, constraints) {
        _viewportHeight = constraints.maxHeight;
        _scheduleFollow();
        final anchor = !_following && _viewportHeight > 0 ? _visibleAnchor : null;
        return NotificationListener<ScrollMetricsNotification>(
          onNotification: _onMetricsNotification,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            // SelectableText (EditableText) scrolls the viewport to reveal the
            // caret on every tap — in an index-anchored list that nudges the
            // whole transcript. Region selection selects plain Text instead.
            // The copy action is overridden: SelectionArea's default goes
            // through Clipboard.setData → navigator.clipboard, which does not
            // exist on the plain-HTTP deployment — copyText() falls back to
            // execCommand. (A DOM `copy`-event bridge can't help — the engine
            // preventDefaults the handled keydown.)
            child: Actions(
              actions: {
                CopySelectionTextIntent: CallbackAction<CopySelectionTextIntent>(
                  onInvoke: (_) {
                    unawaited(copyText(_transcriptSelection));
                    return null;
                  },
                ),
              },
              child: SelectionArea(
                onSelectionChanged: (content) {
                  _transcriptSelection = content?.plainText ?? '';
                  reportSelectionText(_transcriptSelection);
                },
                child: ScrollablePositionedList.builder(
                  key: ValueKey(sessionId),
                  itemScrollController: _itemScroll,
                  itemPositionsListener: _positions,
                  initialScrollIndex: anchor?.$1 ?? grouped.rows.length,
                  initialAlignment: anchor != null
                      ? 1 - anchor.$2 / _viewportHeight
                      : (_viewportHeight > 0
                            ? (1 - _tailHeight / _viewportHeight).clamp(0.0, 1.0)
                            : 0),
                  // `.chat-messages-pane .mx-auto { max-width: 900px }` — the transcript
                  // keeps a reading column instead of stretching edge to edge on wide
                  // panes.
                  padding: EdgeInsets.only(
                    top: 16,
                    left: _readingColumnPadding(constraints.maxWidth),
                    right: _readingColumnPadding(constraints.maxWidth),
                  ),
                  itemCount: grouped.rows.length + 1,
                  semanticChildCount: grouped.rows.length,
                  itemBuilder: (context, i) {
                    if (i == grouped.rows.length) {
                      return SizedBox(height: _tailHeight.clamp(0.0, _viewportHeight));
                    }
                    final row = grouped.rows[i];
                    if (row is ToolGroup) {
                      return ToolGroupTile(
                        key: ValueKey(row.messages.first.id),
                        group: row,
                        tileBuilder: (m) => MessageTile(
                          message: m,
                          sessionId: sessionId,
                          projectId: widget.projectId,
                          childrenMap: grouped.children,
                          onFileOpen: _openChangedFile,
                        ),
                      );
                    }
                    final m = row as SessionMessage;
                    final prevIdx = messages.indexWhere((x) => x.id == m.id);
                    return MessageTile(
                      key: ValueKey(m.id),
                      message: m,
                      previous: prevIdx > 0 ? messages[prevIdx - 1] : null,
                      sessionId: sessionId,
                      projectId: widget.projectId,
                      childrenMap: grouped.children,
                      onFileOpen: _openChangedFile,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _toolIcon(BuildContext context, IconData icon, VoidCallback? onPressed) {
    final m = paneHeaderMetrics(context);
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: m.icon, color: context.appColors.mutedForeground),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(width: m.hit, height: m.hit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = Translations.of(context);
    final sessionId = widget.sessionId;
    // Standalone `/chat/:id` mounts no workspace, so the running-session pulse
    // has to be kept alive here too (idempotent when WorkspaceScreen already
    // watches it).
    ref.watch(activityPollerProvider);
    // Mounting the presence provider announces {kind:'session', id}; dispose
    // clears it — wiring T12.4 to a real surface.
    ref.watch(presenceProvider((kind: 'session', id: sessionId)));
    final state = ref.watch(transcriptProvider(widget.sessionId));
    final messages = ref.watch(sessionMessagesProvider(sessionId));
    // Web parity: the provider comes from the session row (`selectedSession`),
    // never from the transcript tail — an empty or still-loading transcript
    // must not flip the banner, composer and quota section to the default
    // provider (T17.9).
    final detailsAsync = ref.watch(sessionDetailsProvider(sessionId));
    final details = detailsAsync.value;
    // Provider is the composer's identity key, so once we have seen the real
    // value we never fall back to the old `'claude'` guess: a flip would tear
    // the composer down and rebuild its whole `_init` for the correct provider.
    // While the row is still loading it stays empty, which defers the composer
    // instead of guessing; only a hard failure falls back to the default.
    final provider =
        _resolvedProvider ??
        ((details?.provider?.isNotEmpty ?? false) ? details!.provider! : null) ??
        messages.lastOrNull?.provider ??
        // A draft (`/chat/new`) with no session row yet falls back to the
        // provider the user picked in the new-chat dialog.
        (detailsAsync.hasError ? (widget.initialProvider ?? 'claude') : '');
    if (provider.isNotEmpty) _resolvedProvider = provider;
    // The route may carry no projectPath (deep links); the session row knows
    // the workspace path, and the banner renders it like the web's
    // `ocProjectPath`.
    final projectPath = widget.projectPath ?? details?.projectFullPath;
    final projectId = widget.projectId ?? details?.projectId;
    // T15.8/11 — group consecutive tool rows; nest subagent children.
    final grouped = groupToolRuns(messages);
    // The header owns the search/review state; wire match jumps back to this
    // virtualized list so "next match" scrolls the transcript.
    final toolsController = ref.read(transcriptToolsProvider(sessionId).notifier);
    if (_toolsController != toolsController) _clearToolsCallback();
    _toolsController = toolsController;
    toolsController.onScrollToIndex = _scrollToIndex;
    // Search navigation temporarily owns the viewport without clearing the
    // user's persistent follow preference. Closing search resumes following.
    _searchActive = ref.watch(transcriptToolsProvider(sessionId).select((s) => s.searchActive));
    _rowCount = grouped.rows.length;
    final hasMore = ref.watch(
      sessionMessageStoreProvider.select((s) => s[sessionId]?.hasMore ?? false),
    );
    final total = ref.watch(sessionMessageStoreProvider.select((s) => s[sessionId]?.total ?? 0));

    _lastRows = grouped.rows;

    // Detached-viewport correction: any history mutation that shifts or
    // rewrites rows (older-page prepends, dedupe removals, an id-regenerating
    // tail refresh) re-anchors to the first visible row, so the transcript
    // never slides out from under the reader. While following, the tail
    // correction owns the viewport instead; while a pointer is down the user
    // gesture wins and the next mutation re-evaluates.
    final anchor = !_following && !_pointerDown ? _visibleAnchor : null;
    if (anchor != null && _rowCount > 0) {
      final (idx, dy, key) = anchor;
      final moved =
          idx >= grouped.rows.length || (key != null && _rowKey(grouped.rows[idx]) != key);
      if (moved) {
        var target = key != null ? _indexOfRowKey(grouped.rows, key) : -1;
        if (target < 0) target = idx.clamp(0, _rowCount - 1);
        final generation = _scrollGeneration;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted &&
              generation == _scrollGeneration &&
              !_following &&
              _itemScroll.isAttached &&
              _viewportHeight > 0 &&
              target < _rowCount) {
            _userScrollingDown = false;
            _itemScroll.jumpTo(index: target, alignment: 1 - dy / _viewportHeight);
          }
        });
      }
    }

    if (messages.length > _seenCount && !_following) {
      _unread += messages.length - _seenCount;
    }
    _seenCount = messages.length;
    _scheduleFollow();

    // `.oc-chat` parity — the pane always renders the opencode TUI palette
    // (dark + monospace) regardless of the app light/dark mode.
    final chatPane = Theme(
      data: AppTheme.ocChat(),
      child: Scaffold(
        // React renders no app bar inside a chat pane — the `.oc-banner`
        // subheader is the chrome, and the transcript tools float over the
        // message list (ChatMessagesPane.tsx sticky pill).
        appBar: null,
        body: Stack(
          children: [
            Column(
              children: [
                // `.oc-banner` — provider · model · path · ctx gauge ·
                // quota, pinned above the transcript.
                SessionSubheader(
                  sessionId: sessionId,
                  provider: provider,
                  projectId: projectId,
                  projectPath: projectPath,
                  dense: widget.dense,
                  showMenuButton: widget.standalone,
                ),
                if (hasMore)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: state.loadingOlder
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.history, size: 16),
                                label: Text(i18n.chat.session.messages.loadOlder),
                                onPressed: _loadOlder,
                              ),
                              // Web LoadAllMessagesOverlay — one-shot load of
                              // every remaining page, with the total count.
                              TextButton.icon(
                                icon: const Icon(Icons.unfold_more, size: 16),
                                label: Text(i18n.chat.session.messages.loadAllCount(count: total)),
                                onPressed: _loadAll,
                              ),
                            ],
                          ),
                  ),
                if (state.olderError != null)
                  TextButton(
                    onPressed: _loadOlder,
                    child: Text(
                      i18n.chat.session.messages.retryLoadOlder(error: state.olderError ?? ''),
                    ),
                  ),
                Expanded(
                  // The tools/panel must resolve the oc-chat theme — this
                  // state's `context` sits ABOVE the Theme wrapper.
                  child: Builder(
                    builder: (context) => Stack(
                      children: [
                        Positioned.fill(
                          child:
                              ref.watch(
                                transcriptToolsProvider(sessionId).select((s) => s.reviewOpen),
                              )
                              ? _reviewPanel(context)
                              : state.loading && messages.isEmpty
                              ? const Center(child: CircularProgressIndicator())
                              : state.error != null && messages.isEmpty
                              ? Center(child: Text('${state.error}'))
                              : Listener(
                                  onPointerDown: _onPointerDown,
                                  onPointerUp: _onPointerUp,
                                  onPointerCancel: _onPointerUp,
                                  // A hover (no button) means the press ended
                                  // outside the list — never leave it stuck.
                                  onPointerHover: _onPointerUp,
                                  child: _messagesList(grouped, messages),
                                ),
                        ),
                        // Jump-to-bottom — floats over the transcript's
                        // bottom-right corner, clear of the composer below.
                        if (!_following)
                          Positioned(
                            right: 16,
                            bottom: 12,
                            child: FloatingActionButton.small(
                              onPressed: _jumpToBottom,
                              child: Badge.count(
                                count: _unread,
                                isLabelVisible: _unread > 0,
                                child: const Icon(Icons.arrow_downward),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                _PermissionBanner(
                  sessionId: sessionId,
                  projectId: widget.projectId,
                  provider: provider,
                ),
                // `.oc-composer` dock — px-2 sm:px-4, pb-2 sm:pb-4 md:pb-6
                // (+ safe-area). Compact/dense use the tight spacing.
                Builder(
                  builder: (ctx) {
                    final tight = context.breakpoint.isCompact || widget.dense;
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        tight ? 8 : 16,
                        0,
                        tight ? 8 : 16,
                        tight ? 8 : 16,
                      ),
                      // `ChatComposer.tsx` `mx-auto max-w-[54.25rem]` (868px)
                      // — the composer keeps the same reading column as the
                      // transcript instead of stretching edge to edge.
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 868),
                          // Defer the provider-keyed composer until the provider
                          // is known, so its init runs once instead of once per
                          // guess.
                          child: provider.isEmpty
                              ? const SizedBox.shrink()
                              : ChatComposer(
                                  sessionId: sessionId,
                                  projectId: projectId,
                                  projectPath: projectPath,
                                  provider: provider,
                                  initialAccountId: widget.initialAccountId,
                                  dense: widget.dense,
                                  focusNode: _composerHoverFocus,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
    final pane = MouseRegion(onEnter: _onPanePointerEnter, child: chatPane);
    if (!widget.standalone) return pane;
    return Column(
      children: [
        _standaloneHeader(provider, projectPath),
        Expanded(child: pane),
      ],
    );
  }

  /// SplitWorkspaceGrid pane-header chrome for the standalone `/chat/:id`
  /// route — same 28px `bg-muted/30` bar the workspace grid wraps panes in.
  Widget _standaloneHeader(String provider, String? projectPath) {
    final c = context.appColors;
    final details = ref.watch(sessionDetailsProvider(widget.sessionId)).value;
    final projectName = projectPath?.split('/').where((s) => s.isNotEmpty).lastOrNull;
    return Container(
      constraints: BoxConstraints(minHeight: paneHeaderMetrics(context).barHeight),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      decoration: BoxDecoration(
        color: c.muted.withValues(alpha: 0.3),
        border: Border(bottom: BorderSide(color: c.border.withValues(alpha: 0.5))),
      ),
      child: PaneSessionHeader(
        sessionId: widget.sessionId,
        title: details?.displayTitle ?? Translations.of(context).chat.session.fallbackTitle,
        projectName: projectName,
        provider: provider,
        action: details?.isRunning == true ? PaneAction.processing : PaneAction.idle,
        onChangeSession: () => context.go('/sessions'),
        // "Open full session" on an orchestrator card lands here with no back
        // stack — navigate to the parent orchestration session instead.
        onNavigateToSession: (targetId) {
          final params = <String, String>{
            if (widget.projectId != null) 'projectId': widget.projectId!,
            if (widget.projectPath != null) 'projectPath': widget.projectPath!,
          };
          context.go(Uri(path: '/chat/$targetId', queryParameters: params).toString());
        },
        // Parity with the web menu (SessionActionsMenu) — available on the
        // standalone route too, disabled mid-run / while awaiting permission.
        onChangeWorkspace: () => unawaited(_standaloneChangeWorkspace()),
        onRename: (name) => unawaited(_standaloneRename(name)),
        onArchive: () => unawaited(_standaloneDelete(hard: false)),
        onDelete: () => unawaited(_standaloneDelete(hard: true)),
      ),
    );
  }

  /// SessionWorkspaceDialog parity — rebind the session to another path.
  Future<void> _standaloneChangeWorkspace() async {
    final i18n = Translations.of(context);
    final running = ref.read(sessionDetailsProvider(widget.sessionId)).value?.isRunning == true;
    if (running) {
      AppToast.error(context, i18n.chat.session.finishRunBeforeWorkspaceChange);
      return;
    }
    final field = TextEditingController();
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AppDialog(
        title: i18n.sidebar.workspace.submit,
        content: AppInput(controller: field, autofocus: true, hint: '/path/to/project'),
        actions: [
          AppButton(
            variant: AppButtonVariant.ghost,
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(i18n.chat.orchestrator.summary.cancelTasks),
          ),
          AppButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(i18n.codeEditor.actions.save),
          ),
        ],
      ),
    );
    final path = field.text.trim();
    field.dispose();
    if (saved != true || path.isEmpty || !mounted) return;
    final err = await ref
        .read(sessionsProvider((null, null)).notifier)
        .changeWorkspace(widget.sessionId, path);
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
      return;
    }
    AppToast.show(context, i18n.sessions.toasts.workspaceChanged);
  }

  Future<void> _standaloneRename(String name) async {
    final err = await ref
        .read(sessionsProvider((null, null)).notifier)
        .rename(widget.sessionId, name);
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
    } else {
      ref.invalidate(sessionDetailsProvider(widget.sessionId));
    }
  }

  Future<void> _standaloneDelete({required bool hard}) async {
    final i18n = Translations.of(context);
    if (hard) {
      final ok = await AppDialog.confirm(
        context,
        title: i18n.common.browserUse.deleteSession,
        message: i18n.chat.session.deleteConfirm,
        confirmLabel: i18n.common.buttons.delete,
      );
      if (!ok) return;
    }
    final notifier = ref.read(sessionsProvider((null, null)).notifier);
    final err = await (hard
        ? notifier.hardDelete(widget.sessionId)
        : notifier.archive(widget.sessionId));
    if (!mounted) return;
    if (err != null) {
      AppToast.error(context, err);
      return;
    }
    AppToast.show(context, hard ? i18n.sessions.toasts.deleted : i18n.sessions.toasts.archived);
    context.go('/sessions');
  }
}

const _orchestratorIcons = {
  'routing': Icons.alt_route,
  'plan': Icons.map_outlined,
  'delegation': Icons.call_split,
  'summary': Icons.summarize_outlined,
  'user': Icons.person_outline,
};

/// One transcript row — dispatch on `kind` covering every MessageKind.
class MessageTile extends ConsumerWidget {
  const MessageTile({
    required this.message,
    required this.sessionId,
    this.projectId,
    this.previous,
    this.childrenMap = const {},
    this.onFileOpen,
    super.key,
  });

  final SessionMessage message;
  final SessionMessage? previous;
  final String sessionId;
  final String? projectId;

  /// Subagent children index from `groupToolRuns` (T15.8).
  final Map<String, List<SessionMessage>> childrenMap;

  /// Chat → in-pane editor open (web `onFileOpen`).
  final void Function(String path)? onFileOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final i18n = Translations.of(context);

    if (message.isLocalCommand || message.isLocalCommandStdout) {
      return _wrap(
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            message.isLocalCommand
                ? '! ${message.commandMessage ?? message.content ?? ''}'
                : (message.content ?? message.commandMessage ?? ''),
            style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
          ),
        ),
      );
    }

    if (message.isCompactSummary) {
      return _wrap(
        _card(
          cs,
          icon: Icons.compress,
          title: i18n.chat.message.compactedSummary,
          child: AppMarkdown(data: message.content ?? message.summary ?? '', selectable: false),
        ),
      );
    }

    switch (message.kind) {
      case 'text':
        return message.role == 'user' ? _userBubble(context, ref) : _assistantText(context);
      case 'stream_delta':
        return _assistantText(context, live: true);
      case 'thinking' || 'thought_delta':
        // Reasoning trigger — `ⓘ Thought for a few seconds ⌄` with the
        // chevron right after the label (Reasoning.tsx), not pushed to the
        // far edge of the column. `showThinking` pref hides the whole row.
        if (!ref.watch(uiPreferencesProvider).showThinking) {
          return const SizedBox.shrink();
        }
        return _wrap(
          _ReasoningRow(
            label: message.kind == 'thought_delta'
                ? i18n.chat.thinking.title
                : i18n.chat.thinking.thoughtFewSeconds,
            content: message.content ?? '',
          ),
        );
      case 'tool_use':
        return _wrap(
          ToolUseTile(message: message, childrenMap: childrenMap, onFileOpen: onFileOpen),
        );
      case 'tool_result':
        // Results with a matching tool_use are folded into its card
        // (`attachToolResults`); one without renders as its own row.
        final resultText = message.toolResult?['content']?.toString() ?? message.content ?? '';
        if (!message.isError && resultText.trim().isEmpty) return const SizedBox.shrink();
        return _wrap(ToolResultTile(message: message));
      case 'status':
        final orchKind = message.context?['orchestratorKind']?.toString();
        // Notices (live `notice: true` frames and history rows) carry their
        // line in `text`; empty and control rows render nothing.
        final statusText = message.status ?? message.text ?? message.content ?? '';
        if (orchKind == null && (statusText.isEmpty || statusText == 'token_budget')) {
          return const SizedBox.shrink();
        }
        if (orchKind != null) {
          return _wrap(
            OrchestratorCard(message: message, sessionId: sessionId, projectId: projectId),
          );
        }
        return _wrap(
          Row(
            children: [
              Icon(_orchestratorIcons[orchKind] ?? Icons.info_outline, size: 14, color: cs.outline),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  statusText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.outline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        );
      case 'error':
        return _wrap(
          _card(
            cs,
            color: cs.errorContainer,
            icon: Icons.error_outline,
            title: i18n.chat.messageTypes.error,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message.content ?? message.text ?? ''),
                TextButton(
                  onPressed: () {
                    final sent = ref
                        .read(transcriptProvider(sessionId).notifier)
                        .retryLastUserMessage();
                    if (!sent) AppToast.show(context, i18n.chat.message.resendHint);
                  },
                  child: Text(i18n.chat.session.messages.retry),
                ),
              ],
            ),
          ),
        );
      case 'complete':
        final exitCode = message.exitCode ?? 0;
        final failed = !message.aborted && exitCode != 0;
        final lineColor = failed ? cs.error : cs.outlineVariant;
        return _wrap(
          Row(
            children: [
              Expanded(child: Divider(color: lineColor)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  message.aborted
                      ? i18n.chat.message.runStopped
                      : failed
                      ? i18n.chat.message.runFailed(code: exitCode)
                      : i18n.chat.message.runComplete,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: failed ? cs.error : cs.outline,
                  ),
                ),
              ),
              Expanded(child: Divider(color: lineColor)),
            ],
          ),
        );
      case 'permission_request':
        return _permissionCard(context, ref);
      // Control events — the web transcript never renders these
      // (`useChatMessages.ts` skips stream_end/session_created).
      case 'stream_end' || 'session_created':
        return const SizedBox.shrink();
      case 'permission_cancelled':
        return const SizedBox.shrink();
      case 'interactive_prompt':
        final options = message.context?['options'];
        return _wrap(
          _card(
            cs,
            icon: Icons.help_outline,
            title: message.content ?? i18n.chat.permissionRequest.question,
            child: options is List
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final o in options)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(o is Map ? '${o['number'] ?? ''}. ${o['text'] ?? o}' : '$o'),
                        ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        );
      case 'task_notification':
        // A finished background task: `content` is its title, `status` how
        // it ended, `summary` its result. No session link — the server
        // reports the task's tool call, not a separate session.
        final taskStatus = message.status?.toLowerCase();
        final taskFailed = const {'failed', 'killed', 'error'}.contains(taskStatus);
        final statusLabel = switch (taskStatus) {
          null || '' => null,
          'failed' || 'error' => i18n.common.status.failed,
          'killed' => i18n.chat.message.taskKilled,
          'completed' => i18n.common.status.completed,
          _ => message.status,
        };
        final taskSummary = message.summary?.trim() ?? '';
        return _wrap(
          _card(
            cs,
            color: taskFailed ? cs.errorContainer : null,
            icon: taskFailed ? Icons.error_outline : Icons.notifications_outlined,
            title: i18n.common.notifications.codes.generic.info.title,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((message.content ?? '').isNotEmpty) Text(message.content!),
                if (statusLabel != null)
                  Text(
                    statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: taskFailed ? cs.error : cs.outline,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (taskSummary.isNotEmpty && taskSummary != message.content)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: AppMarkdown(data: taskSummary, selectable: false),
                  ),
              ],
            ),
          ),
        );
      default:
        return _wrap(
          Text(
            message.content ?? message.text ?? '[${message.kind}]',
            style: theme.textTheme.bodySmall,
          ),
        );
    }
  }

  Widget _wrap(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: MessageActions(message: message, child: child),
  );

  Widget _assistantText(BuildContext context, {bool live = false}) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final time = clockTime(message.timestamp);
    final muted = t.labelSmall?.copyWith(color: c.mutedForeground, fontSize: 12);
    return _wrap(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppMarkdown(data: message.content ?? '', selectable: false),
          if (live)
            const SizedBox(
              width: 10,
              height: 10,
              child: CircularProgressIndicator(strokeWidth: 1.5),
            ),
          MessageAttachments(message: message, projectId: projectId),
          // `▣ <provider> · <time>` — oc-assistant-footer from index.css.
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Row(
              spacing: AppSpacing.sm,
              children: [
                Text('▣', style: t.labelSmall?.copyWith(color: c.primary)),
                Text(
                  providerLabel(message.provider),
                  style: t.labelSmall?.copyWith(color: c.foreground, fontSize: 12),
                ),
                if (time.isNotEmpty) ...[Text('·', style: muted), Text(time, style: muted)],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// User turn — `.oc-user-body`: panel bg, 3px accent left border, 8/12
  /// padding, square corners (opencode UserMessage). The `mt-1` footer row
  /// holds the copy/task controls and the timestamp (MessageCopyControl +
  /// MessageTaskMasterControl parity).
  Widget _userBubble(BuildContext context, WidgetRef ref) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    final content = message.content ?? '';
    final time = clockTime(message.timestamp);
    final muted = t.labelSmall?.copyWith(color: c.mutedForeground);
    return _wrap(
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: c.card,
          border: Border(left: BorderSide(color: c.primary, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(content, style: t.bodyMedium?.copyWith(height: 1.55)),
            MessageAttachments(message: message, projectId: projectId),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 4,
                children: [
                  if (content.trim().isNotEmpty) ...[
                    _UserBubbleAction(
                      icon: Icons.copy_outlined,
                      tooltip: i18n.chat.codeBlock.copy,
                      onTap: () => unawaited(copyTextWithFeedback(context, content)),
                    ),
                    if (projectId != null)
                      _UserBubbleAction(
                        icon: Icons.add_task,
                        tooltip: i18n.chat.taskMaster.addToTask,
                        onTap: () => _saveAsTask(context, ref, content),
                      ),
                  ],
                  if (time.isNotEmpty) Text(time, style: muted),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `MessageTaskMasterControl` — the message becomes a medium-priority
  /// task: code fences stripped, title ≤ 80 chars.
  Future<void> _saveAsTask(BuildContext context, WidgetRef ref, String content) async {
    final i18n = Translations.of(context);
    final pid = projectId;
    if (pid == null) return;
    final plain = content
        .replaceAll(RegExp(r'```[\s\S]*?```'), '')
        .replaceAll(RegExp(r'`([^`]+)`'), r'$1')
        .replaceAll(RegExp(r'\n+'), ' ')
        .trim();
    final title = plain.isEmpty
        ? i18n.chat.taskMaster.defaultTaskTitle
        : plain.length <= 80
        ? plain
        : '${plain.substring(0, 77).trim()}...';
    try {
      await ref.read(taskmasterRepositoryProvider).addTask(pid, {
        'title': title,
        'description': content.trim(),
        'priority': 'medium',
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(i18n.chat.taskMaster.added)));
      }
    } on Object {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(i18n.tasks.createTask.error)));
      }
    }
  }

  Widget _permissionCard(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final i18n = Translations.of(context);
    final requestId = message.requestId;
    final toolName = (message.context?['toolName'] ?? message.toolName)?.toString() ?? '';
    final input = message.toolInput is Map
        ? Map<String, dynamic>.from(message.toolInput as Map)
        : message.context?['input'] is Map
        ? Map<String, dynamic>.from(message.context!['input'] as Map)
        : <String, dynamic>{};
    final isAskUser =
        toolName.toLowerCase().replaceAll(' ', '_') == 'askuserquestion' ||
        toolName.toLowerCase().replaceAll(' ', '_') == 'ask_user_question' ||
        input['questions'] is List;
    // Only live requests are answerable — restored/expired asks render as
    // read-only recaps so a dead ask never looks like it can be picked.
    final isPending =
        requestId != null && ref.watch(pendingPermissionsProvider).containsKey(requestId);
    final rememberEntry = message.context?['rememberEntry']?.toString();
    final rejectAlways = rejectAlwaysEntryOf(message.context);
    final isPlanExit = _isPlanExit(toolName);
    // Only Claude runs the edited input; ACP agents and OpenCode accept a bare
    // allow/deny, so "Edit & Allow" there would approve the original call.
    final canEditInput = message.provider == 'claude';
    // Pending questions are answered in the sticky _PermissionBanner above
    // the composer — rendering the panel inline too duplicated the ask on
    // screen. Once decided, this card reappears as the read-only recap.
    if (isAskUser && isPending) return const SizedBox.shrink();

    void decide({required bool allow, dynamic updatedInput, dynamic remember, String? feedback}) {
      if (requestId == null) return;
      ref
          .read(transcriptProvider(sessionId).notifier)
          .decidePermission(
            requestId,
            allow: allow,
            updatedInput: updatedInput,
            rememberEntry: remember,
            message: feedback,
          );
    }

    return _wrap(
      _card(
        cs,
        color: cs.tertiaryContainer,
        icon: Icons.lock_outline,
        title: isAskUser
            ? i18n.chat.permissionRequest.question
            : i18n.chat.permissionRequest.title(tool: toolName),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // A subagent's ask must not read as the main agent's.
            if (message.context?['agentId'] != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  i18n.chat.permissionRequest.subagent,
                  style: TextStyle(fontSize: 11, color: cs.outline),
                ),
              ),
            if (!isAskUser && (message.content ?? message.text ?? '').isNotEmpty)
              Text(message.content ?? message.text ?? ''),
            // What is being approved — the command, path, plan or input.
            if (!isAskUser) PermissionInputView(toolName: toolName, input: input),
            if (!isAskUser) const SizedBox(height: 8),
            // Server also enforces roleAtLeast('member') on this frame.
            RequireRole(
              minimum: 'member',
              fallback: Text(
                i18n.chat.permissionRequest.viewersCannotApprove,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.outline),
              ),
              child: requestId == null || !isPending
                  ? _decisionRecap(i18n, cs, input, isAskUser)
                  : isAskUser
                  ? AskUserQuestionPanel(
                      requestId: requestId,
                      input: input,
                      onDecision: (allow, updatedInput) =>
                          decide(allow: allow, updatedInput: updatedInput),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        FilledButton.tonal(
                          onPressed: () => decide(allow: true),
                          child: Text(i18n.chat.permissions.allow),
                        ),
                        if (rememberEntry != null)
                          Tooltip(
                            message: i18n.chat.permissions.addTo(entry: rememberEntry),
                            child: FilledButton.tonal(
                              onPressed: () => decide(allow: true, remember: rememberEntry),
                              child: Text(i18n.chat.permissions.always),
                            ),
                          ),
                        if (canEditInput)
                          TextButton(
                            onPressed: () => _editInputDialog(context, input).then((v) {
                              if (v != null) {
                                decide(allow: true, updatedInput: v);
                              }
                            }),
                            child: Text(i18n.chat.permissions.editAndAllow),
                          ),
                        if (rejectAlways != null)
                          TextButton(
                            onPressed: () => decide(allow: false, remember: rejectAlways),
                            child: Text(i18n.chat.permissions.alwaysDeny),
                          ),
                        TextButton(
                          onPressed: () async {
                            if (!isPlanExit) return decide(allow: false);
                            final feedback = await _askDenyFeedback(context);
                            if (feedback != null) {
                              decide(allow: false, feedback: feedback.isEmpty ? null : feedback);
                            }
                          },
                          child: Text(i18n.chat.permissions.deny),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Read-only state for a permission/question card whose request is no
  /// longer pending: the picked answers if we have them, otherwise an
  /// "expired" note — a dead ask must never render as tappable.
  Widget _decisionRecap(
    Translations i18n,
    ColorScheme cs,
    Map<String, dynamic> input,
    bool isAskUser,
  ) {
    final recap = i18n.chat.permissionRequest.recap;
    final questions = input['questions'] is List ? input['questions'] as List : const <dynamic>[];
    final answers = input['answers'] is Map ? input['answers'] as Map : const <dynamic, dynamic>{};
    final resolved = input['resolved'] == true;
    final muted = TextStyle(fontSize: 12, color: cs.outline);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final q in questions)
          if (q is Map)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q['header']?.toString() ??
                        q['question']?.toString() ??
                        i18n.chat.permissionRequest.question,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  if (q['header'] != null && q['question'] != null)
                    Text(q['question'].toString(), style: muted),
                  if ((q['planContent']?.toString() ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: PlanReviewPanel(
                        content: q['planContent'].toString(),
                        filePath: q['planFilePath']?.toString(),
                        initiallyExpanded: false,
                      ),
                    ),
                  if (answers[q['question']] != null)
                    Text(
                      '→ ${answers[q['question']]}',
                      style: TextStyle(fontSize: 12, color: cs.primary),
                    ),
                ],
              ),
            ),
        Text(switch (input['cancelReason']?.toString()) {
          'timeout' => recap.timedOut,
          'cancelled' => recap.cancelled,
          'auto-approved' => recap.autoApproved,
          'expired' || 'process-exited' || 'run-settled' => recap.expired,
          _ =>
            resolved
                ? isAskUser
                      ? (answers.isNotEmpty ? recap.answered : recap.skipped)
                      : recap.decided
                : recap.expired,
        }, style: muted),
      ],
    );
  }

  Future<Map<String, dynamic>?> _editInputDialog(BuildContext context, Map<String, dynamic> input) {
    final i18n = Translations.of(context);
    final ctrl = TextEditingController(text: const JsonEncoder.withIndent('  ').convert(input));
    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(i18n.chat.permissions.editInput),
        content: SizedBox(
          width: 480,
          child: TextField(
            controller: ctrl,
            maxLines: 12,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(i18n.chat.orchestrator.summary.cancelTasks),
          ),
          FilledButton(
            onPressed: () {
              try {
                final v = jsonDecode(ctrl.text);
                Navigator.pop(ctx, v is Map ? Map<String, dynamic>.from(v) : input);
              } on Object {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(i18n.chat.permissions.invalidJson)));
              }
            },
            child: Text(i18n.chat.permissions.allowWithChanges),
          ),
        ],
      ),
    );
  }

  static Widget _card(
    ColorScheme cs, {
    required IconData icon,
    required String title,
    required Widget child,
    Color? color,
  }) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: color ?? cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    ),
  );
}

/// Copy + raw view + timestamp tooltip — hover actions on each row (T13.7).
class MessageActions extends ConsumerStatefulWidget {
  const MessageActions({required this.message, required this.child, super.key});

  final SessionMessage message;
  final Widget child;

  @override
  ConsumerState<MessageActions> createState() => _MessageActionsState();
}

class _MessageActionsState extends ConsumerState<MessageActions> {
  /// Row actions follow the web transcript: hidden until the row is hovered
  /// (`.oc-footer-actions { opacity: 0 }`).
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final message = widget.message;
    final child = widget.child;
    final stamp = clockTime(message.timestamp);
    final i18n = Translations.of(context);
    final ttsState = ref.watch(ttsControllerProvider);
    final isSpeaking = ttsState.isSpeakingMessage(message.id);
    final textToSpeak = message.content ?? message.text ?? '';

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(
        message: stamp,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: child),
            AnimatedOpacity(
              duration: AppMotion.base,
              opacity: _hover ? 1 : 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (textToSpeak.trim().isNotEmpty)
                    IconButton(
                      icon: Icon(
                        isSpeaking ? Icons.stop : Icons.volume_up_outlined,
                        size: 14,
                        color: isSpeaking ? Theme.of(context).colorScheme.primary : null,
                      ),
                      tooltip: isSpeaking
                          ? i18n.chat.voice.stopSpeaking
                          : i18n.chat.voice.speakMessage,
                      padding: EdgeInsets.zero,
                      iconSize: 14,
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      onPressed: () {
                        if (isSpeaking) {
                          ref.read(ttsControllerProvider.notifier).stop();
                        } else {
                          unawaited(
                            ref.read(ttsControllerProvider.notifier).speak(message.id, textToSpeak),
                          );
                        }
                      },
                    ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 14),
                    padding: EdgeInsets.zero,
                    iconSize: 14,
                    onSelected: (v) async {
                      if (v == 'copy') {
                        await copyTextWithFeedback(context, message.content ?? message.text ?? '');
                      } else if (v == 'raw' && context.mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: SingleChildScrollView(
                              child: SelectableText(
                                const JsonEncoder.withIndent('  ').convert({
                                  'id': message.id,
                                  'kind': message.kind,
                                  'role': message.role,
                                  'provider': message.provider,
                                  'timestamp': message.timestamp,
                                  'seq': message.seq,
                                  'runId': message.runId,
                                  'content': message.content,
                                  'toolName': message.toolName,
                                  'toolInput': message.toolInput,
                                  'context': message.context,
                                }),
                                style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(i18n.chat.common.close),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'copy', child: Text(i18n.chat.codeBlock.copy)),
                      PopupMenuItem(value: 'raw', child: Text(i18n.chat.message.rawView)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Image attachments (data URL or `/api/assets/images/<file>`) + download
/// cards (`ChatMessageFiles` parity — global asset store first, then the
/// project files route for older sessions).
class MessageAttachments extends StatelessWidget {
  const MessageAttachments({required this.message, this.projectId, super.key});

  final SessionMessage message;
  final String? projectId;

  @override
  Widget build(BuildContext context) {
    final images = message.images ?? const [];
    final files = message.files ?? const [];
    if (images.isEmpty && files.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final img in images) _ImageThumb(image: img),
          for (final f in files) _AttachmentCard(file: f, projectId: projectId),
        ],
      ),
    );
  }
}

/// One downloadable file attachment — `ChatMessageFile` port: icon tile,
/// name + size/status line, download affordance with retry on failure.
class _AttachmentCard extends ConsumerStatefulWidget {
  const _AttachmentCard({required this.file, this.projectId});

  final Map<String, dynamic> file;
  final String? projectId;

  @override
  ConsumerState<_AttachmentCard> createState() => _AttachmentCardState();
}

class _AttachmentCardState extends ConsumerState<_AttachmentCard> {
  bool _downloading = false;
  bool _failed = false;

  String get _path => widget.file['path']?.toString() ?? '';

  String get _name {
    final name = widget.file['name']?.toString();
    if (name != null && name.isNotEmpty) return name;
    final base = _path.split(RegExp(r'[\\/]')).last;
    return base.isEmpty ? Translations.of(context).chat.attachments.attachedFile : base;
  }

  IconData get _icon {
    final name = _name.toLowerCase();
    final mime = widget.file['mimeType']?.toString() ?? '';
    if (mime.startsWith('text/') || RegExp(r'\.(md|txt|pdf|docx?)$').hasMatch(name)) {
      return LucideIcons.fileText;
    }
    if (RegExp(r'\.(zip|rar|7z|tar|gz)$').hasMatch(name)) {
      return LucideIcons.fileArchive;
    }
    if (RegExp(r'\.(js|jsx|ts|tsx|py|rb|go|rs|java|c|cpp|css|html|json|ya?ml)$').hasMatch(name)) {
      return LucideIcons.fileCode;
    }
    return LucideIcons.file;
  }

  String? get _size {
    final size = (widget.file['size'] as num?)?.toInt();
    if (size == null) return null;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).round()} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _download() async {
    if (_path.isEmpty || _downloading) return;
    final storedName = _path.split(RegExp(r'[\\/]')).last;
    if (storedName.isEmpty) return;
    setState(() {
      _downloading = true;
      _failed = false;
    });
    try {
      // Global attachment store first, then the project files route —
      // older sessions keep attachments inside the project directory.
      Uint8List? bytes;
      try {
        bytes = await ref.read(miscRepositoryProvider).downloadAssetFile(storedName);
      } on Object {
        bytes = null;
      }
      final projectId = widget.projectId;
      if (bytes == null && projectId != null) {
        bytes = await ref.read(fileTreeRepositoryProvider).readFileBlob(projectId, _path);
      }
      if (bytes == null) {
        if (mounted) setState(() => _failed = true);
        return;
      }
      final saved = await downloadBytes(
        _name,
        bytes,
        mime: widget.file['mimeType']?.toString() ?? 'application/octet-stream',
      );
      if (!mounted) return;
      final i18n = Translations.of(context);
      AppToast.show(
        context,
        saved == null
            ? i18n.chat.attachments.downloaded(name: _name)
            : i18n.chat.export.savedTo(path: saved),
      );
    } on Object {
      if (mounted) setState(() => _failed = true);
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);
    return Tooltip(
      message: i18n.chat.attachments.download(name: _name),
      child: InkWell(
        onTap: _path.isEmpty || _downloading ? null : _download,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 256,
          constraints: const BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: c.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: c.border.withValues(alpha: 0.5)),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: c.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_icon, size: 20, color: c.primary),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: t.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _failed
                          ? i18n.chat.attachments.downloadFailedRetry
                          : (_size ?? i18n.chat.attachments.fileAttachment),
                      style: t.labelSmall?.copyWith(
                        color: _failed ? Theme.of(context).colorScheme.error : c.mutedForeground,
                      ),
                    ),
                  ],
                ),
              ),
              _downloading
                  ? SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 1.5, color: c.mutedForeground),
                    )
                  : Icon(LucideIcons.download, size: 16, color: c.mutedForeground),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageThumb extends StatelessWidget {
  const _ImageThumb({required this.image});

  final Map<String, dynamic> image;

  @override
  Widget build(BuildContext context) {
    final data = image['data']?.toString();
    final path = image['path']?.toString() ?? '';
    final filename = path.split(RegExp(r'[\\/]')).last;
    final Widget thumb = data != null && data.startsWith('data:image')
        ? Image.memory(
            base64Decode(data.split(',').last),
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          )
        : AuthImage(url: '/api/assets/images/$filename', fit: BoxFit.cover);
    return GestureDetector(
      onTap: () => showDialog<void>(
        context: context,
        builder: (context) => Dialog(
          child: InteractiveViewer(
            child: data != null && data.startsWith('data:image')
                ? Image.memory(base64Decode(data.split(',').last))
                : AuthImage(url: '/api/assets/images/$filename'),
          ),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(width: 120, height: 120, child: thumb),
      ),
    );
  }
}

/// Sticky pending-approval banner above the composer
/// (PermissionRequestsBanner.tsx parity): one row per unanswered request with
/// Allow / Allow all / Reject, so approvals can't be scrolled past.
class _PermissionBanner extends ConsumerWidget {
  const _PermissionBanner({required this.sessionId, this.projectId, this.provider});

  final String sessionId;
  final String? projectId;
  final String? provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pending = ref.watch(sessionPendingPermissionsProvider(sessionId));
    if (pending.isEmpty) return const SizedBox.shrink();
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);

    // Only "Always" / "Always deny" remember the rule — a plain Allow (or
    // Allow all) must approve this one call and nothing more.
    void decide(
      PendingPermission p, {
      required bool allow,
      bool remember = false,
      String? feedback,
    }) => ref
        .read(transcriptProvider(sessionId).notifier)
        .decidePermission(
          p.requestId,
          allow: allow,
          rememberEntry: remember ? (allow ? p.rememberEntry : p.rejectAlwaysEntry) : null,
          message: feedback,
        );

    Future<void> reject(PendingPermission p) async {
      if (!_isPlanExit(p.toolName)) return decide(p, allow: false);
      final feedback = await _askDenyFeedback(context);
      if (feedback != null) {
        decide(p, allow: false, feedback: feedback.isEmpty ? null : feedback);
      }
    }

    bool isQuestion(PendingPermission p) {
      final n = p.toolName.toLowerCase().replaceAll(' ', '_');
      return n == 'askuserquestion' || n == 'ask_user_question' || p.input['questions'] is List;
    }

    final questions = [
      for (final p in pending)
        if (isQuestion(p)) p,
    ];
    final permissions = [
      for (final p in pending)
        if (!isQuestion(p)) p,
    ];

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: c.card,
        border: Border.all(color: const Color(0xFFF59E0B)),
        borderRadius: AppRadii.borderLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question asks answer one at a time — CLIs forward one request
          // per question and only send the next once this resolves, so the
          // banner shows a single panel; after Submit the follow-up
          // question slides in.
          if (questions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: AskUserQuestionPanel(
                key: ValueKey(questions.first.requestId),
                requestId: questions.first.requestId,
                input: questions.first.input,
                onDecision: (allow, updatedInput) {
                  final notifier = ref.read(transcriptProvider(sessionId).notifier);
                  notifier.decidePermission(
                    questions.first.requestId,
                    allow: allow,
                    updatedInput: updatedInput,
                  );
                  // ACP providers (command-code / Devin) answer a question with
                  // a picked option id only — typed free text cannot ride the
                  // ACP answer. End the blocked turn and send the text as the
                  // next turn instead, so the answer is applied right away
                  // rather than after the agent finishes guessing.
                  if (provider == 'commandcode' || provider == 'devin') {
                    final freeText = extractQuestionFreeText(questions.first.input, updatedInput);
                    if (freeText.isNotEmpty) {
                      notifier.answerQuestionWithText(freeText);
                    }
                  }
                },
              ),
            ),
          if (questions.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Text(
                i18n.chat.permissionRequest.moreQuestions(count: questions.length - 1),
                style: t.bodySmall?.copyWith(color: c.mutedForeground),
              ),
            ),
          for (final p in permissions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(LucideIcons.lock, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          p.context?['agentId'] != null
                              ? i18n.chat.permissionRequest.subagentNeedsApproval(tool: p.toolName)
                              : i18n.chat.permissionRequest.needsApproval(tool: p.toolName),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodySmall?.copyWith(color: c.foreground),
                        ),
                      ),
                      TextButton(
                        onPressed: () => decide(p, allow: true),
                        child: Text(i18n.chat.permissions.allow),
                      ),
                      if (p.rememberEntry != null)
                        Tooltip(
                          message: i18n.chat.permissions.addTo(entry: p.rememberEntry!),
                          child: TextButton(
                            onPressed: () => decide(p, allow: true, remember: true),
                            child: Text(i18n.chat.permissions.always),
                          ),
                        ),
                      if (p.rejectAlwaysEntry != null)
                        TextButton(
                          onPressed: () => decide(p, allow: false, remember: true),
                          child: Text(
                            i18n.chat.permissions.alwaysDeny,
                            style: TextStyle(color: c.destructive),
                          ),
                        ),
                      TextButton(
                        onPressed: () => unawaited(reject(p)),
                        child: Text(
                          i18n.chat.permissions.reject,
                          style: TextStyle(color: c.destructive),
                        ),
                      ),
                    ],
                  ),
                  // What is being approved — the command, path, plan or input.
                  Padding(
                    padding: const EdgeInsets.only(left: 22),
                    child: PermissionInputView(toolName: p.toolName, input: p.input),
                  ),
                ],
              ),
            ),
          if (permissions.length > 1)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  for (final p in permissions) {
                    decide(p, allow: true);
                  }
                },
                child: Text(i18n.chat.permissions.allowAll(count: permissions.length)),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal inset that keeps the transcript at the web's 900px reading
/// column (`.chat-messages-pane .mx-auto`), with the 12px gutter on narrow
/// panes.
double _readingColumnPadding(double width) {
  const gutter = 12.0;
  const column = 900.0;
  final side = (width - column) / 2;
  return side > gutter ? side : gutter;
}

/// 14px ghost action inside the user bubble footer (MessageCopyControl /
/// MessageTaskMasterControl parity).
class _UserBubbleAction extends StatelessWidget {
  const _UserBubbleAction({required this.icon, required this.tooltip, required this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(3),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Icon(icon, size: 12, color: context.appColors.mutedForeground),
      ),
    ),
  );
}

/// Collapsed reasoning row — `ⓘ label ⌄` with the chevron inline, expanding
/// to the thinking text (web `Reasoning` trigger).
class _ReasoningRow extends StatefulWidget {
  const _ReasoningRow({required this.label, required this.content});

  final String label;
  final String content;

  @override
  State<_ReasoningRow> createState() => _ReasoningRowState();
}

class _ReasoningRowState extends State<_ReasoningRow> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final style = t.bodySmall?.copyWith(color: c.mutedForeground, fontSize: 13);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: AppSpacing.sm,
              children: [
                // Reasoning.tsx trigger — BrainIcon, muted, hover→fg.
                Icon(LucideIcons.brain, size: 15, color: c.mutedForeground),
                Text(widget.label, style: style),
                Icon(
                  _open ? LucideIcons.chevronUp : LucideIcons.chevronDown,
                  size: 15,
                  color: c.mutedForeground,
                ),
              ],
            ),
          ),
        ),
        if (_open)
          Padding(
            padding: const EdgeInsets.only(left: 22, bottom: 10),
            child: AppMarkdown(data: widget.content, selectable: false),
          ),
      ],
    );
  }
}

bool _isPlanExit(String toolName) =>
    toolName.toLowerCase().replaceAll(RegExp('[ _]'), '') == 'exitplanmode';

/// Deny-with-feedback for a plan (ExitPlanMode): null when cancelled, else
/// the (possibly empty) text sent to the agent as the denial `message`.
Future<String?> _askDenyFeedback(BuildContext context) async {
  final i18n = Translations.of(context);
  final ctrl = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(i18n.chat.permissions.denyFeedbackTitle),
      content: SizedBox(
        width: 480,
        child: TextField(
          controller: ctrl,
          autofocus: true,
          minLines: 2,
          maxLines: 6,
          decoration: InputDecoration(
            hintText: i18n.chat.permissions.denyFeedbackHint,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(i18n.common.buttons.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(i18n.chat.permissions.deny),
        ),
      ],
    ),
  );
  return ok == true ? ctrl.text.trim() : null;
}

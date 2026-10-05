import 'package:ddagent_app/features/collab/state/presence_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';

const _avatarColors = [
  Color(0xFF0EA5E9),
  Color(0xFF10B981),
  Color(0xFFF59E0B),
  Color(0xFFF43F5E),
  Color(0xFF8B5CF6),
  Color(0xFF0891B2),
];

String _initials(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0].substring(0, parts[0].length.clamp(0, 2)).toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

/// Stacked initials of everyone present on the shared surface — port of
/// `PresenceAvatars`. Hover shows the username and what they are viewing.
class PresenceAvatars extends StatelessWidget {
  const PresenceAvatars({required this.roster, super.key});

  final List<PresenceEntry> roster;

  @override
  Widget build(BuildContext context) {
    if (roster.isEmpty) return const SizedBox.shrink();
    final t = Translations.of(context);
    final onSurface = Theme.of(context).colorScheme.surface;
    return Semantics(
      label: t.tasks.board.presence.online(count: roster.length),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < roster.length; i++)
            Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 2),
              child: Tooltip(
                message:
                    '${roster[i].username}'
                    '${roster[i].viewing == null ? '' : ' · ${roster[i].viewing!.kind}'}',
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: onSurface,
                  child: CircleAvatar(
                    radius: 11,
                    backgroundColor: _avatarColors[i % _avatarColors.length],
                    child: Text(
                      _initials(roster[i].username),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

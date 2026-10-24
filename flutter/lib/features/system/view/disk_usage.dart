import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/file_tree/data/file_tree_node.dart' show formatFileSize;
import 'package:ddagent_app/features/system/data/system_repository.dart';
import 'package:ddagent_app/features/system/state/system_providers.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Dismissed for this app run only — the banner returns after a reload.
class _LowDiskDismissed extends Notifier<bool> {
  @override
  bool build() => false;

  void dismiss() => state = true;
}

final _lowDiskDismissedProvider = NotifierProvider<_LowDiskDismissed, bool>(_LowDiskDismissed.new);

String _locationLabel(Translations t, String kind) => switch (kind) {
  'app' => t.settings.disk.app,
  'data' => t.settings.disk.data,
  _ => t.settings.disk.workspace,
};

/// Red strip above every shell screen while a server disk is low.
class LowDiskBanner extends ConsumerWidget {
  const LowDiskBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final low = ref.watch(diskUsageProvider).value?.where((v) => v.low).toList() ?? const [];
    if (low.isEmpty || ref.watch(_lowDiskDismissedProvider)) return const SizedBox.shrink();
    final t = Translations.of(context);
    final c = context.appColors;
    final v = low.first;
    return Material(
      color: c.destructive,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Row(
          spacing: AppSpacing.sm,
          children: [
            Icon(LucideIcons.hardDrive, size: 16, color: c.destructiveForeground),
            Expanded(
              child: Text(
                t.settings.disk.lowBanner(
                  free: formatFileSize(v.freeBytes),
                  paths: v.locations.map((l) => l.path).join(', '),
                ),
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: c.destructiveForeground),
              ),
            ),
            IconButton(
              tooltip: t.chat.common.close,
              visualDensity: VisualDensity.compact,
              icon: Icon(LucideIcons.x, size: 16, color: c.destructiveForeground),
              onPressed: () => ref.read(_lowDiskDismissedProvider.notifier).dismiss(),
            ),
          ],
        ),
      ),
    );
  }
}

/// Settings → About: free space per server disk, with what lives on it.
class DiskUsageBlock extends ConsumerWidget {
  const DiskUsageBlock({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final muted = tt.labelSmall?.copyWith(color: c.mutedForeground);
    final disk = ref.watch(diskUsageProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Row(
          spacing: AppSpacing.sm,
          children: [
            Icon(LucideIcons.hardDrive, size: 16, color: c.mutedForeground),
            Text(t.settings.disk.title, style: tt.titleSmall),
          ],
        ),
        switch (disk) {
          AsyncData(:final value) when value.isNotEmpty => Column(
            spacing: AppSpacing.md,
            children: [for (final v in value) _VolumeRow(volume: v)],
          ),
          // No spinner: an endless animation never settles and adds nothing for a sub-second fetch.
          AsyncLoading() => const SizedBox.shrink(),
          _ => Text(t.settings.disk.unavailable, style: muted),
        },
      ],
    );
  }
}

class _VolumeRow extends StatelessWidget {
  const _VolumeRow({required this.volume});

  final DiskVolume volume;

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final c = context.appColors;
    final tt = Theme.of(context).textTheme;
    final used = volume.totalBytes == 0
        ? 0.0
        : (volume.totalBytes - volume.freeBytes) / volume.totalBytes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.xs,
      children: [
        Text(
          t.settings.disk.free(
            free: formatFileSize(volume.freeBytes),
            total: formatFileSize(volume.totalBytes),
          ),
          style: tt.bodySmall?.copyWith(color: volume.low ? c.destructive : null),
        ),
        ClipRRect(
          borderRadius: AppRadii.borderMd,
          child: LinearProgressIndicator(
            value: used,
            minHeight: 6,
            backgroundColor: c.muted,
            color: volume.low ? c.destructive : c.primary,
          ),
        ),
        for (final l in volume.locations)
          Text(
            '${_locationLabel(t, l.kind)}: ${l.path}',
            style: tt.labelSmall?.copyWith(color: c.mutedForeground),
          ),
      ],
    );
  }
}

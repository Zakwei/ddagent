import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/features/voice/state/tts_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global voice picker for TTS read-aloud.
class AutoReadVoicePicker extends ConsumerWidget {
  const AutoReadVoicePicker({super.key, this.showPreview = true});

  final bool showPreview;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ttsState = ref.watch(ttsControllerProvider);
    final ctrl = ref.read(ttsControllerProvider.notifier);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);

    final currentVoice = ttsState.preferredVoice;
    final voices = ttsState.voices;
    final validVoice = voices.any((v) => v.id == currentVoice) ? currentVoice : '';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: DropdownButton<String>(
            value: validVoice,
            isExpanded: true,
            hint: Text(i18n.chat.voice.autoReadVoiceAuto, style: t.bodySmall),
            underline: const SizedBox.shrink(),
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(i18n.chat.voice.autoReadVoiceAuto, style: t.bodySmall),
              ),
              for (final v in voices)
                DropdownMenuItem(
                  value: v.id,
                  child: Text(v.name.isNotEmpty ? v.name : v.id, style: t.bodySmall),
                ),
            ],
            onChanged: (newVoice) {
              if (newVoice != null) {
                ctrl.setPreferredVoice(newVoice);
              }
            },
          ),
        ),
        if (showPreview) ...[
          const SizedBox(width: AppSpacing.xs),
          AppButton(
            variant: AppButtonVariant.ghost,
            size: AppButtonSize.sm,
            onPressed: () {
              ctrl.speak(
                'preview',
                i18n.chat.voice.autoReadPreview,
                voice: currentVoice.isNotEmpty ? currentVoice : null,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  ttsState.isSpeakingMessage('preview') ? Icons.stop : Icons.volume_up,
                  size: 16,
                  color: c.primary,
                ),
                const SizedBox(width: 4),
                Text(i18n.voice.preview),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

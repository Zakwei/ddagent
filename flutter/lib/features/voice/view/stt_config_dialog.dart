import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SttConfigDialog extends ConsumerStatefulWidget {
  const SttConfigDialog({super.key});

  static Future<void> show(BuildContext context) =>
      showDialog<void>(context: context, builder: (_) => const SttConfigDialog());

  @override
  ConsumerState<SttConfigDialog> createState() => _SttConfigDialogState();
}

class _SttConfigDialogState extends ConsumerState<SttConfigDialog> {
  late final TextEditingController _endpointCtrl;
  late final TextEditingController _apiKeyCtrl;
  late final TextEditingController _modelCtrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final config = ref.read(sttConfigProvider);
    _endpointCtrl = TextEditingController(text: config.endpointUrl ?? '');
    _apiKeyCtrl = TextEditingController();
    _modelCtrl = TextEditingController(text: config.model ?? '');
  }

  @override
  void dispose() {
    _endpointCtrl.dispose();
    _apiKeyCtrl.dispose();
    _modelCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final ok = await ref
        .read(sttConfigProvider.notifier)
        .save(
          endpointUrl: _endpointCtrl.text.trim().isEmpty ? null : _endpointCtrl.text.trim(),
          apiKey: _apiKeyCtrl.text.trim().isEmpty ? null : _apiKeyCtrl.text.trim(),
          model: _modelCtrl.text.trim().isEmpty ? null : _modelCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) {
      Navigator.of(context).pop();
      AppToast.show(context, 'Voice input settings saved');
    } else {
      AppToast.error(context, 'Failed to save STT configuration');
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(sttConfigProvider);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.mic, size: 20),
          const SizedBox(width: AppSpacing.xs),
          const Text('Voice input (STT)'),
          const Spacer(),
          if (config.configured)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: AppRadii.borderSm,
              ),
              child: const Text(
                'configured',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ),
        ],
      ),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Whisper-compatible /audio/transcriptions endpoint. Enables speech-to-text dictation in the composer.',
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(
              controller: _endpointCtrl,
              hint: 'Endpoint URL (e.g. https://api.openai.com/v1)',
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInput(
              controller: _apiKeyCtrl,
              hint: config.hasApiKey ? 'API Key (saved, enter to replace)' : 'API Key',
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInput(controller: _modelCtrl, hint: 'Model (e.g. whisper-1)'),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _saving,
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}

import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/core/widgets/app_button.dart';
import 'package:ddagent_app/core/widgets/app_input.dart';
import 'package:ddagent_app/core/widgets/app_toast.dart';
import 'package:ddagent_app/features/voice/state/stt_controller.dart';
import 'package:ddagent_app/i18n/strings.g.dart';
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
    final i18n = Translations.of(context);
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
      AppToast.show(context, i18n.voice.settingsSaved);
    } else {
      AppToast.error(context, i18n.voice.saveFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(sttConfigProvider);
    final c = context.appColors;
    final t = Theme.of(context).textTheme;
    final i18n = Translations.of(context);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.mic, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(i18n.settings.stt.title),
          const Spacer(),
          if (config.configured)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: AppRadii.borderSm,
              ),
              child: Text(
                i18n.settings.stt.configured,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
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
              i18n.settings.stt.description,
              style: t.bodySmall?.copyWith(color: c.mutedForeground),
            ),
            const SizedBox(height: AppSpacing.md),
            AppInput(controller: _endpointCtrl, hint: i18n.settings.stt.endpoint),
            const SizedBox(height: AppSpacing.sm),
            AppInput(
              controller: _apiKeyCtrl,
              hint: config.hasApiKey ? i18n.voice.apiKeySaved : i18n.settings.stt.apiKey,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppInput(controller: _modelCtrl, hint: i18n.settings.stt.model),
          ],
        ),
      ),
      actions: [
        AppButton(
          variant: AppButtonVariant.ghost,
          size: AppButtonSize.sm,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(i18n.common.buttons.cancel),
        ),
        AppButton(
          size: AppButtonSize.sm,
          loading: _saving,
          onPressed: _save,
          child: Text(i18n.settings.stt.save),
        ),
      ],
    );
  }
}

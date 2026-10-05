import 'package:ddagent_app/core/theme/tokens.dart';
import 'package:ddagent_app/features/settings/view/sections/browser_section.dart';
import 'package:ddagent_app/features/settings/view/sections/tasks_section.dart';
import 'package:flutter/material.dart';

/// Merged "Tools" section — groups the two optional agent capabilities that
/// used to live on their own tabs: TaskMaster task management (Tasks) and
/// guarded Playwright browser sessions (Browser).
class ToolsSection extends StatelessWidget {
  const ToolsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        TasksSettingsBlock(),
        SizedBox(height: AppSpacing.xl),
        BrowserSettingsBlock(),
      ],
    );
  }
}

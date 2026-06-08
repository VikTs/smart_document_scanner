import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:smart_documents_scanner/screens/settings/ai_settings/ai_settings_screen.dart';
import 'package:smart_documents_scanner/screens/settings/general_settings/general_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text("settings.title".tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsCard(
            icon: Icons.language,
            title: "settings.general.title".tr(),
            subtitle: "settings.general.subtitle".tr(),
            onTap: () => _open(context, const GeneralSettingsScreen()),
          ),

          const SizedBox(height: 12),

          _SettingsCard(
            icon: Icons.smart_toy,
            title: "settings.ai.title".tr(),
            subtitle: "settings.ai.subtitle".tr(),
            onTap: () => _open(context, const AISettingsScreen()),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

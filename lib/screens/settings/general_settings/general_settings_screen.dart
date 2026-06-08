import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/main.dart';
import 'package:smart_documents_scanner/screens/settings/general_settings/language_selector_widget.dart';
import 'package:smart_documents_scanner/screens/settings/general_settings/theme_selector_widget.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _storage = AppStorage();
    return Scaffold(
      appBar: AppBar(title: Text("settings.general.title".tr())),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LanguageSelector(currentLocale: context.locale, storage: _storage),

          const SizedBox(height: 12),

          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeController.mode,
            builder: (context, mode, _) {
              return ThemeSelector(
                storage: _storage,
                currentMode: mode,
                onChanged: (newMode) {
                  if (newMode != null) {
                    themeController.setTheme(newMode);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

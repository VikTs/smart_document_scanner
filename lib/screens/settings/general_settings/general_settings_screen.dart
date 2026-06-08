
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/screens/settings/general_settings/language_selector_widget.dart';

class GeneralSettingsScreen extends StatelessWidget {
  const GeneralSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings.general.title".tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LanguageSelector(
            currentLocale: context.locale,
          ),
        ],
      ),
    );
  }
}

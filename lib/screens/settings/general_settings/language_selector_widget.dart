import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.currentLocale,
    required this.storage,
  });

  final Locale currentLocale;
  final AppStorage storage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<Locale>(
          value: currentLocale,
          decoration: InputDecoration(
            labelText: "settings.language".tr(),
            border: InputBorder.none,
          ),
          items: const [
            DropdownMenuItem(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem(
              value: Locale('uk'),
              child: Text('Українська'),
            ),
          ],
          onChanged: (locale) {
            if (locale != null) {
              context.setLocale(locale);
              storage.saveLanguage(locale.languageCode);
            }
          },
        ),
      ),
    );
  }
}
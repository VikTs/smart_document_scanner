import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({
    super.key,
    required this.currentMode,
    required this.storage,
    required this.onChanged,
  });

  final ThemeMode currentMode;
  final AppStorage storage;
  final ValueChanged<ThemeMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<ThemeMode>(
          value: currentMode,
          decoration: InputDecoration(
            labelText: "settings.theme.title".tr(),
            border: InputBorder.none,
          ),
          items: [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('settings.theme.system'.tr()),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('settings.theme.light'.tr()),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('settings.theme.dark'.tr()),
            ),
          ],
          onChanged: (mode) {
            if (mode != null) {
              onChanged(mode);

              storage.saveThemeMode(mode);
            }
          },
        ),
      ),
    );
  }
}

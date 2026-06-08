import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class ThemeController {
  ThemeController(this._storage);

  final AppStorage _storage;

  final ValueNotifier<ThemeMode> mode =
      ValueNotifier(ThemeMode.system);

  Future<void> load() async {
    mode.value = await _storage.getThemeMode();
  }

  Future<void> setTheme(ThemeMode newMode) async {
    mode.value = newMode;
    await _storage.saveThemeMode(newMode);
  }
}
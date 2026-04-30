import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';

class AppStorage {
  final _storage = const FlutterSecureStorage();

  static const _apiKey = 'llm_api_key';
  static const _provider = 'llm_provider';

  Future<void> saveApiKey(String value) async {
    final trimmed = value.trim();
    await _storage.write(key: _apiKey, value: trimmed);
  }

  Future<String?> getApiKey() async {
    return await _storage.read(key: _apiKey);
  }

  Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }

  Future<void> saveProvider(AIProvider provider) async {
    await _storage.write(key: _provider, value: provider.name);
  }

  Future<AIProvider?> getProvider() async {
    final value = await _storage.read(key: _provider);
    if (value == null) return null;

    return AIProvider.values.firstWhere(
      (e) => e.name == value,
      orElse: () => defaultProvider,
    );
  }
}

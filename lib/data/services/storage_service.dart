import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';

class AppStorage {
  final _storage = const FlutterSecureStorage();

  static const _apiKey = 'llm_api_key';
  static const _provider = 'llm_provider';
  static const _privacyAccepted = 'privacy_accepted';
  static const _skipLeaveChatDialog = 'skip_leave_chat_dialog';
  static const _language = 'app_language';

  // Language

  Future<void> saveLanguage(String languageCode) async {
    await _storage.write(key: _language, value: languageCode);
  }

  Future<String?> getLanguage() async {
    return _storage.read(key: _language);
  }

  // Privacy

  Future<bool> hasAcceptedPrivacy() async {
    final value = await getAcceptedPrivacy();
    return value == 'true';
  }

  Future<String?> getAcceptedPrivacy() async {
    return _storage.read(key: _privacyAccepted);
  }

  Future<void> setPrivacyAccepted() async {
    await _storage.write(key: _privacyAccepted, value: 'true');
  }

  // Skip leave chat dialog

  Future<bool> getSkipLeaveChatDialog() async {
    return await _storage.read(key: _skipLeaveChatDialog) == "true"
        ? true
        : false;
  }

  Future<void> setSkipLeaveChatDialog(bool value) async {
    await _storage.write(key: _skipLeaveChatDialog, value: value.toString());
  }

  // API Key

  Future<void> saveApiKey(String value) async {
    await _storage.write(key: _apiKey, value: value.trim());
  }

  Future<String?> getApiKey() async {
    return _storage.read(key: _apiKey);
  }

  Future<bool> hasApiKey() async {
    final key = await getApiKey();
    return key != null && key.isNotEmpty;
  }

  // Provider

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

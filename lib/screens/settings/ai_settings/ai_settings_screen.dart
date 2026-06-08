import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/api_key/api_key_input_widget.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/provider_instructions_widget.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/provider_selector_widget.dart';

class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});

  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final _storage = AppStorage();

  AIProvider _selectedProvider = defaultProvider;
  String? _apiKey;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final apiKey = await _storage.getApiKey();
    var provider = await _storage.getProvider();

    if (provider == null) {
      provider = defaultProvider;
      await _storage.saveProvider(provider);
    }

    if (!mounted) return;

    setState(() {
      _selectedProvider = provider!;
      _apiKey = apiKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("settings.ai.title".tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProviderSelector(
            selectedProvider: _selectedProvider,
            onChanged: (value) {
              setState(() => _selectedProvider = value);
              _storage.saveProvider(value);
            },
          ),
          const SizedBox(height: 16),
          ProviderInstructions(provider: _selectedProvider),
          const SizedBox(height: 16),
          ApiKeyInput(apiKey: _apiKey),
        ],
      ),
    );
  }
}
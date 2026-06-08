import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';

class ProviderSelector extends StatelessWidget {
  final AIProvider selectedProvider;
  final ValueChanged<AIProvider> onChanged;

  const ProviderSelector({
    super.key,
    required this.selectedProvider,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DropdownButtonFormField<AIProvider>(
          value: selectedProvider,
          decoration: InputDecoration(
            labelText: "settings.ai_provider_label".tr(),
            border: InputBorder.none,
          ),
          items: [
            DropdownMenuItem(
              value: AIProvider.groq,
              child: Text("settings.ai_providers.groq".tr()),
            ),
            DropdownMenuItem(
              value: AIProvider.openai,
              child: Text("settings.ai_providers.openai".tr()),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              onChanged(value);
            }
          },
        ),
      ),
    );
  }
}

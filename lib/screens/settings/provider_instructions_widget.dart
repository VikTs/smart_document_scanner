import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';
import 'package:smart_documents_scanner/shared/link_text_span_widget.dart';

class ProviderInstructions extends StatelessWidget {
  final AIProvider provider;

  const ProviderInstructions({super.key, required this.provider});

  ({String label, String url}) _getConfig(AIProvider provider) {
    switch (provider) {
      case AIProvider.groq:
        return (
          label: "settings.ai_provider_platforms.groq".tr(),
          url: dotenv.env['GROQ_API_KEY_URL'] ?? "",
        );

      case AIProvider.openai:
        return (
          label: "settings.ai_provider_platforms.openai".tr(),
          url: dotenv.env['OPENAI_API_KEY_URL'] ?? "",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(provider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "settings.provider_instructions.title".tr(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(text: "settings.provider_instructions.step1".tr()),
                  LinkTextSpan(text: config.label, url: config.url),
                  TextSpan(
                    text:
                        "\n${"settings.provider_instructions.step2".tr()}"
                        "\n${"settings.provider_instructions.step3".tr()}",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

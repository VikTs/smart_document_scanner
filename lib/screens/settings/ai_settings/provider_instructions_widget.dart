import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smart_documents_scanner/core/models/ai_provider.dart';
import 'package:smart_documents_scanner/shared/link_text_span_widget.dart';

class ProviderInstructions extends StatelessWidget {
  final AIProvider provider;

  const ProviderInstructions({super.key, required this.provider});

  ({String label, String providerUrl, String billingUrl}) _getProviderConfig(
    AIProvider provider,
  ) {
    switch (provider) {
      case AIProvider.groq:
        return (
          label: "settings.ai_provider_platforms.groq".tr(),
          providerUrl: dotenv.env['GROQ_API_KEY_URL'] ?? "",
          billingUrl: dotenv.env['GROQ_API_KEY_BILLING'] ?? "",
        );

      case AIProvider.openai:
        return (
          label: "settings.ai_provider_platforms.openai".tr(),
          providerUrl: dotenv.env['OPENAI_API_KEY_URL'] ?? "",
          billingUrl: dotenv.env['OPENAI_API_KEY_BILLING'] ?? "",
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _getProviderConfig(provider);

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
                  LinkTextSpan(text: config.label, url: config.providerUrl),
                  TextSpan(
                    text:
                        "${"settings.provider_instructions.step2".tr()}"
                        "${"settings.provider_instructions.step3_part1".tr()}",
                  ),
                  LinkTextSpan(
                    text: "settings.provider_instructions.step3_part2".tr(),
                    url: config.billingUrl,
                  ),
                  TextSpan(
                    text: "settings.provider_instructions.step3_part3".tr(),
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

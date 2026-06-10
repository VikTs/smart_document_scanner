import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ApiKeyHeader extends StatelessWidget {
  final String? savedApiKey;
  final bool isEditMode;
  final VoidCallback onToggleEdit;

  const ApiKeyHeader({
    super.key,
    required this.savedApiKey,
    required this.isEditMode,
    required this.onToggleEdit,
  });

  String maskApiKey(String key) {
    if (key.length <= 6) {
      return '••••••';
    }

    return '${key.substring(0, 3)}••••••${key.substring(key.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    final hasKey = savedApiKey != null && savedApiKey!.isNotEmpty;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.key_rounded,
            size: 20,
            color: colorScheme.primary,
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "settings.api_key_label".tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                hasKey
                    ? maskApiKey(savedApiKey!)
                    : "settings.api_key.no_key_saved_message".tr(),
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),

if (isEditMode)
  const SizedBox.shrink()
else
FilledButton.tonal(
  onPressed: isEditMode ? null : onToggleEdit,
  child: Text(
    hasKey
        ? "settings.api_key.update_btn".tr()
        : "settings.api_key.add_btn".tr(),
  ),
),
      ],
    );
  }
}
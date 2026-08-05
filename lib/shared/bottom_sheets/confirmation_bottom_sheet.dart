import 'package:flutter/material.dart';

enum ConfirmationType { normal, destructive }

class ConfirmationBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;

  final String cancelText;
  final String confirmText;

  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  final ConfirmationType type;

  const ConfirmationBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.cancelText,
    required this.confirmText,
    required this.onCancel,
    required this.onConfirm,
    this.type = ConfirmationType.normal,
  });

  Color getConfirmColor(ColorScheme colorScheme) {
    switch (type) {
      case ConfirmationType.normal:
        return colorScheme.primary;

      case ConfirmationType.destructive:
        return colorScheme.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(cancelText),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getConfirmColor(colorScheme),
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

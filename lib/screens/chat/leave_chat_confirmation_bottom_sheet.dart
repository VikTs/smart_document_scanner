import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/shared/labeled_checkbox_widget.dart';

class LeaveChatConfirmationSheet extends StatefulWidget {
  final VoidCallback onCancel;
  final void Function(bool neverShowAgain) onConfirm;

  const LeaveChatConfirmationSheet({
    super.key,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  State<LeaveChatConfirmationSheet> createState() =>
      _LeaveChatConfirmationSheetState();
}

class _LeaveChatConfirmationSheetState
    extends State<LeaveChatConfirmationSheet> {
  bool _neverShowAgain = false;

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
              'chat.leave_chat_bottom_sheet.title'.tr(),
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'chat.leave_chat_bottom_sheet.subtitle'.tr(),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.7),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            LabeledCheckbox(
              value: _neverShowAgain,
              onChanged: (value) => setState(() => _neverShowAgain = value),
              label: 'chat.leave_chat_bottom_sheet.never_show_again'.tr(),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorScheme.primary,
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('chat.leave_chat_bottom_sheet.cancel'.tr()),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => widget.onConfirm(_neverShowAgain),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text('chat.leave_chat_bottom_sheet.leave'.tr()),
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

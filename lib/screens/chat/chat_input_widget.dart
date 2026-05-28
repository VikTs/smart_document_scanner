import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInput({super.key, required this.controller, required this.onSend});

  void _handleSubmit() {
    onSend();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                maxLength: 200,
                minLines: 1,
                maxLines: 3,
                controller: controller,
                onSubmitted: (_) => _handleSubmit(),
                decoration: InputDecoration(
                  counterText: "",
                  hintText: "chat.input_hint".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),

            ValueListenableBuilder(
              valueListenable: controller,
              builder: (_, _, _) {
                final isEnabled = controller.text.isNotEmpty;
                return IconButton(
                  onPressed: isEnabled ? _handleSubmit : null,
                  icon: Icon(
                    Icons.send,
                    color: isEnabled
                        ? colorScheme.iconPrimary
                        : colorScheme.iconDisabled,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

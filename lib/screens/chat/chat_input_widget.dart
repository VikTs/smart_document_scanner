
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => _handleSubmit(),
                decoration: InputDecoration(
                  hintText: "chat.input_hint".tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.send), onPressed: _handleSubmit),
          ],
        ),
      ),
    );
  }
}

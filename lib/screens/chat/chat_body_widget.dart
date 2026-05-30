import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/message.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/screens/chat/chat_input_widget.dart';

class ChatBody extends StatelessWidget {
  final String documentName;
  final List<Message> messages;
  final bool isLoading;
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatBody({
    super.key,
    required this.documentName,
    required this.messages,
    required this.isLoading,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.description_outlined,
                  size: 18,
                  color: colorScheme.iconTertiary,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    documentName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final msg = messages[index];

              return Align(
                alignment: msg.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: msg.isUser
                        ? colorScheme.messagePrimaryBackground
                        : colorScheme.messageSecondaryBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      color: msg.isUser
                          ? colorScheme.onMessagePrimary
                          : colorScheme.onMessageSecondary,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        if (isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),

        ChatInput(controller: controller, onSend: onSend),
      ],
    );
  }
}

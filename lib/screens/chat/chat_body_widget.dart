import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
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
            // Reverse the list so the chat opens at the latest message.
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (_, index) {
              final message = messages[messages.length - 1 - index];

              return Align(
                alignment: message.isUser
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: message.isUser
                        ? colorScheme.messagePrimaryBackground.withOpacity(0.9)
                        : colorScheme.messageSecondaryBackground.withOpacity(
                            0.9,
                          ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    message.value,
                    style: TextStyle(
                      color: message.isUser
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

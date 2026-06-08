import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/message.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/screens/chat/chat_input_widget.dart';

class ChatBody extends StatefulWidget {
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
  State<ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(covariant ChatBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messages.length != widget.messages.length ||
        oldWidget.isLoading != widget.isLoading) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
                    widget.documentName,
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
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (_, index) {
              final msg = widget.messages[index];

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
                        ? colorScheme.messagePrimaryBackground.withOpacity(0.9)
                        : colorScheme.messageSecondaryBackground.withOpacity(
                            0.9,
                          ),
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

        if (widget.isLoading)
          const Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),

        ChatInput(controller: widget.controller, onSend: widget.onSend),
      ],
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/message.dart';
import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/screens/chat/chat_input_widget.dart';

class DocumentChatScreen extends StatefulWidget {
  final DocumentData document;
  final llmService = LlmService();

  DocumentChatScreen({super.key, required this.document});

  @override
  State<DocumentChatScreen> createState() => _DocumentChatScreenState();
}

class _DocumentChatScreenState extends State<DocumentChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> messages = [];
  bool isLoading = false;
  bool isPreparingDocument = true;
  String? documentText;

  @override
  void initState() {
    super.initState();

    messages.add(Message(text: "chat.intro_message".tr(), isUser: false));
    _prepareDocument();
  }

  Future<void> _prepareDocument() async {
      final recognized = await recognizeText(
        bytes: widget.document.files[0].bytes,
      );

      setState(() {
        documentText = recognized.text;
        isPreparingDocument = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("chat.title".tr())),
      body: isPreparingDocument
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Text("📄 ${widget.document.name}"),
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
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.text,
                            style: TextStyle(
                              color: msg.isUser ? Colors.white : Colors.black87,
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

                ChatInput(controller: _controller, onSend: _send),
              ],
            ),
    );
  }

  Future<void> _send() async {
    final question = _controller.text.trim();
    if (question.isEmpty) return;

    setState(() {
      messages.add(Message(text: question, isUser: true));
      isLoading = true;
    });

    _controller.clear();

    try {
      final answer = await _askLLM(widget.document, question);
      messages.add(Message(text: answer, isUser: false));
    } catch (error) {
      messages.add(Message(text: "chat.error_message".tr(), isUser: false));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<String> _askLLM(DocumentData document, String question) async {
    final answer = await widget.llmService.askQuestion(
      question: question,
      documentText: documentText ?? "",
    );

    return answer;
  }
}

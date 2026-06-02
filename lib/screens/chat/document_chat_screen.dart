import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/message.dart';
import 'package:smart_documents_scanner/core/services/text_recognizion_service.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/chat/chat_body_widget.dart';
import 'package:smart_documents_scanner/screens/chat/leave_chat_confirmation_bottom_sheet.dart';
import 'package:smart_documents_scanner/screens/chat/setup_required_widget.dart';
import 'package:smart_documents_scanner/screens/settings/settings_screen.dart';
import 'package:smart_documents_scanner/shared/labeled_checkbox_widget.dart';

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
  bool isConfigured = true;

  String? documentText;

  @override
  void initState() {
    super.initState();

    messages.add(Message(text: "chat.intro_message".tr(), isUser: false));
    _checkConfigAndPrepare();
  }

  Future<void> _checkConfigAndPrepare() async {
    final storage = AppStorage();
    final key = await storage.getApiKey();
    final provider = await storage.getProvider();

    final configured = key != null && key.isNotEmpty && provider != null;

    if (!mounted) return;

    setState(() {
      isConfigured = configured;
    });

    if (!configured) {
      setState(() {
        isPreparingDocument = false;
      });
      return;
    }

    await _prepareDocument();
  }

  Future<void> _prepareDocument() async {
    final recognized = await TextRecognisionService.recognize(
      bytes: widget.document.files[0].bytes,
    );

    if (!mounted) return;

    setState(() {
      documentText = recognized.text;
      isPreparingDocument = false;
    });
  }

  void onSetupApiPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );

    _checkConfigAndPrepare();
  }

  Future<bool> _onPopRequested() async {
    if (messages.length <= 1) return true;

    final storage = AppStorage();
    final skipDialog = await storage.getSkipLeaveChatDialog();
    if (skipDialog) return true;

    if (!mounted) return true;

    final leave = await showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => LeaveChatConfirmationSheet(
        onCancel: () => Navigator.pop(context, false),
        onConfirm: (neverShowAgain) async {
          if (neverShowAgain) {
            await storage.setSkipLeaveChatDialog(true);
          }
          if (context.mounted) Navigator.pop(context, true);
        },
      ),
    );

    return leave ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await _onPopRequested();
        if (shouldPop && context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: Text("chat.title".tr())),
        body: isPreparingDocument
            ? const Center(child: CircularProgressIndicator())
            : !isConfigured
            ? SetupRequired(onPressed: onSetupApiPressed)
            : ChatBody(
                documentName: widget.document.name,
                messages: messages,
                isLoading: isLoading,
                controller: _controller,
                onSend: _send,
              ),
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
      final answer = await _askLLM(question);

      setState(() {
        messages.add(Message(text: answer, isUser: false));
      });
    } catch (_) {
      setState(() {
        messages.add(Message(text: "chat.error_message".tr(), isUser: false));
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<String> _askLLM(String question) async {
    if (documentText?.trim().isEmpty ?? true) {
      return "chat.no_readable_text_message".tr();
    }

    return await widget.llmService.askQuestion(
      question: question,
      documentText: documentText ?? "",
    );
  }
}


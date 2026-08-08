import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/services/text_recognizion_service.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/repository/messages_repository.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/chat/chat_body_widget.dart';
import 'package:smart_documents_scanner/screens/chat/setup_required_widget.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/ai_settings_screen.dart';

class DocumentChatScreen extends StatefulWidget {
  final DocumentData document;
  final LlmService llmService = LlmService();

  DocumentChatScreen({
    super.key,
    required this.document,
  });

  @override
  State<DocumentChatScreen> createState() =>
      _DocumentChatScreenState();
}

class _DocumentChatScreenState extends State<DocumentChatScreen> {
  final TextEditingController _controller =
      TextEditingController();

  final AppDatabase _database = AppDatabase();
  late final MessagesRepository _repository;

  bool isLoading = false;
  bool isPreparingDocument = true;
  bool isConfigured = true;

  String? documentText;

  @override
  void initState() {
    super.initState();

    _repository = MessagesRepository(_database);

    _checkConfigAndPrepare();
    _initializeChat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _database.close();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    final messages = await _repository.getMessages(
      widget.document.id,
    );

    if (messages.isNotEmpty) {
      return;
    }

    await _repository.addMessage(
      documentId: widget.document.id,
      value: 'chat.intro_message'.tr(),
      isUser: false,
    );
  }

  Future<void> _checkConfigAndPrepare() async {
    final storage = AppStorage();

    final key = await storage.getApiKey();
    final provider = await storage.getProvider();

    final configured =
        key != null && key.isNotEmpty && provider != null;

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
    final recognized =
        await TextRecognisionService.recognize(
      bytes: widget.document.files[0].bytes,
    );

    if (!mounted) return;

    setState(() {
      documentText = recognized.text;
      isPreparingDocument = false;
    });
  }

  Future<void> onSetupApiPressed() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AISettingsScreen(),
      ),
    );

    await _checkConfigAndPrepare();
  }

  Future<void> _send() async {
    final question = _controller.text.trim();

    if (question.isEmpty || isLoading) {
      return;
    }

    _controller.clear();

    await _repository.addMessage(
      documentId: widget.document.id,
      value: question,
      isUser: true,
    );

    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      final answer = await _askLLM(question);

      await _repository.addMessage(
        documentId: widget.document.id,
        value: answer,
        isUser: false,
      );
    } catch (_) {
      await _repository.addMessage(
        documentId: widget.document.id,
        value: 'chat.error_message'.tr(),
        isUser: false,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<String> _askLLM(String question) async {
    if (documentText?.trim().isEmpty ?? true) {
      return 'chat.no_readable_text_message'.tr();
    }

    return widget.llmService.askQuestion(
      question: question,
      documentText: documentText ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
      stream: _repository.watchMessages(
        widget.document.id,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final messages = snapshot.data!;

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) async {
            if (didPop) return;

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('chat.title'.tr()),
            ),
            body: isPreparingDocument
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : !isConfigured
                    ? SetupRequired(
                        onPressed: onSetupApiPressed,
                      )
                    : ChatBody(
                        documentName: widget.document.name,
                        messages: messages,
                        isLoading: isLoading,
                        controller: _controller,
                        onSend: _send,
                      ),
          ),
        );
      },
    );
  }
}
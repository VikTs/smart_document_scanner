import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_documents_scanner/core/models/ai_provider.dart';
import 'package:smart_documents_scanner/core/prompts/document_chat.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class LlmService {
  final storage = AppStorage();

  Future<String> sendToLLM(String prompt, {String? rules}) async {
    final apiKey = await storage.getApiKey();
    final providerConfig = await getProviderConfig();

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API key is not set");
    }

    if (providerConfig?.baseUrl == null || providerConfig?.model == null) {
      throw Exception("Provider is not set or configured");
    }

    final response = await http.post(
      Uri.parse(providerConfig!.baseUrl!),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": providerConfig.model,
        "messages": [
          if (rules != null) {"role": "system", "content": rules},
          {"role": "user", "content": prompt},
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data['choices']?[0]?['message']?['content'];
  }

  Future<({String? baseUrl, String? model})?> getProviderConfig() async {
    final provider = await storage.getProvider();
    if (provider == null) return null;

    switch (provider) {
      case AIProvider.groq:
        return (
          baseUrl: dotenv.env['GROQ_BASE_URL'],
          model: dotenv.env['GROQ_MODEL_NAME'],
        );

      case AIProvider.openai:
        return (
          baseUrl: dotenv.env['OPENAI_BASE_URL'],
          model: dotenv.env['OPENAI_MODEL_NAME'],
        );
    }
  }

  Future<String> askQuestion({
    required String question,
    required String documentText,
  }) async {
    final userPrompt = DocumentChatPrompt.userQuestion(
      documentText: documentText,
      question: question,
    );
    final contextRules = DocumentChatPrompt.contextRules;

    return await sendToLLM(userPrompt, rules: contextRules);
  }
}

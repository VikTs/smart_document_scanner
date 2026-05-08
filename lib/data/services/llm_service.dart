import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:smart_documents_scanner/core/models/ai_provider.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class LlmService {
  final storage = AppStorage();

  Future<String> sendToLLM(String prompt) async {
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
    final prompt =
        """
You are an AI assistant inside a document analysis app.
Your task is to answer user questions based ONLY on the provided document context.

Rules:
- Use ONLY the information from the context.
- Do NOT use external knowledge.
- If the answer is not in the context, clearly say that the document does not contain enough information to answer the question (max length of the answer - 40 symbols).
- Do not guess or hallucinate missing details.
- Be concise and clear.
- If appropriate, explain in simple terms.
- Always respond in the same language as the user's question.
- If the document context is empty, null, or contains no meaningful text, you must respond exactly: "Document contains no readable text"

Style:
- Be helpful and natural, like a document assistant.
- Prefer short and structured answers.
- If useful, use bullet points.

Context:
$documentText

Question:
$question
""";

    return await sendToLLM(prompt);
  }
}

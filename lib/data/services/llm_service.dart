import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LlmService {
  final apiUrl = dotenv.env['LLM_BASE_URL'] ?? "";

  Future<String> sendToLLM(String prompt) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer ${dotenv.env["LLM_API_KEY"]}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": dotenv.env["LLM_MODEL_NAME"],
        "messages": [
          {"role": "user", "content": prompt},
        ],
      }),
    );

    final data = jsonDecode(response.body);
    return data['choices']?[0]?['message']?['content'];
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

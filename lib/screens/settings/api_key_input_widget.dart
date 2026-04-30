import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

class ApiKeyInput extends StatefulWidget {
  final String? apiKey;
  const ApiKeyInput({super.key, required this.apiKey});

  @override
  State<ApiKeyInput> createState() => _ApiKeyInputState();
}

class _ApiKeyInputState extends State<ApiKeyInput> {
  final controller = TextEditingController();
  final llmService = LlmService();
  final storage = AppStorage();

  bool isLoading = true;
  bool isSaving = false;
  bool isTesting = false;
  bool isObscured = true;
  String? status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (!mounted) return;

    setState(() {
      controller.text = widget.apiKey ?? '';
      isLoading = false;
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    final value = controller.text.trim();

    if (value.isEmpty) {
      _showSnack("settings.empty_api_key_message".tr());
      return;
    }

    setState(() {
      isSaving = true;
      status = null;
    });

    try {
      await storage.saveApiKey(value);
      _showSnack("settings.api_key_success_message".tr());
    } catch (_) {
      _showSnack("settings.api_key_error_message".tr());
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> _test() async {
    setState(() {
      isTesting = true;
      status = null;
    });

    try {
      await llmService.sendToLLM("Reply with only word: OK");

      setState(() {
        status = "settings.connection_success_message".tr();
      });
    } catch (e) {
      setState(() {
        status = "settings.connection_error_message".tr();
      });
    } finally {
      if (mounted) {
        setState(() => isTesting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "settings.api_key_label".tr(),
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: controller,
                  obscureText: isObscured,
                  decoration: InputDecoration(
                    hintText: "settings.api_key_hint".tr(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => isObscured = !isObscured),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "settings.api_key_note".tr(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving ? null : _save,
                        child: isSaving
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text("settings.save_btn".tr()),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isTesting ? null : _test,
                        child: isTesting
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text("settings.test_btn".tr()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),

        if (status != null)
          Card(
            color: Colors.black.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(status!),
            ),
          ),
      ],
    );
  }
}

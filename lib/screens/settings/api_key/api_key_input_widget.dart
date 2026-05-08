import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/settings/api_key/api_key_editor_widget.dart';
import 'package:smart_documents_scanner/screens/settings/api_key/api_key_header_widget.dart';
import 'package:smart_documents_scanner/screens/settings/api_key/status_card_widget.dart';

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

  String? savedApiKey;

  bool isLoading = true;
  bool isSaving = false;
  bool isTesting = false;
  bool isEditMode = false;

  String? status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final key = await storage.getApiKey();

    if (!mounted) return;

    setState(() {
      savedApiKey = key;
      isLoading = false;
    });
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _save() async {
    final value = controller.text.trim();

    if (value.isEmpty) {
      _showSnack("settings.api_key.empty_message".tr());
      return;
    }

    setState(() {
      isSaving = true;
      status = null;
    });

    try {
      await storage.saveApiKey(value);

      if (!mounted) return;

      setState(() {
        savedApiKey = value;
        isEditMode = false;
        controller.clear();
      });

      _showSnack("settings.api_key.success_message".tr());
    } catch (_) {
      _showSnack("settings.api_key.error_message".tr());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _test() async {
    setState(() {
      isTesting = true;
      status = null;
    });

    try {
      await llmService.sendToLLM("Reply with only word: OK");

      if (!mounted) return;

      setState(() {
        status = "settings.connection_success_message".tr();
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        status = "settings.connection_error_message".tr();
      });
    } finally {
      if (mounted) {
        setState(() {
          isTesting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.withOpacity(0.15)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ApiKeyHeader(
                  isEditMode: isEditMode,
                  savedApiKey: savedApiKey,
                  onToggleEdit: () {
                    setState(() {
                      isEditMode = !isEditMode;

                      if (!isEditMode) {
                        controller.clear();
                      }
                    });
                  },
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: isEditMode
                      ? Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: ApiKeyEditor(
                            controller: controller,
                            onSave: _save,
                            isSaving: isSaving,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Colors.grey[700],
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          "settings.api_key_note".tr(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: (isTesting || savedApiKey == null)
                        ? null
                        : _test,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: isTesting
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text("settings.test_btn".tr()),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (status != null) ...[
          const SizedBox(height: 16),
          StatusCard(status: status),
        ],
      ],
    );
  }
}

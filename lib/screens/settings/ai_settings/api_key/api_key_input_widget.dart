import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/prompts/document_chat.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/shared/app_snackbar.dart';
import 'package:smart_documents_scanner/data/services/llm_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/api_key/api_key_editor_widget.dart';
import 'package:smart_documents_scanner/screens/settings/ai_settings/api_key/api_key_header_widget.dart';

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

  Future<void> _save() async {
    final value = controller.text.trim();

    if (value.isEmpty) {
      AppSnackbar.info(context, "settings.api_key.empty_message".tr());
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      await storage.saveApiKey(value);

      if (!mounted) return;

      setState(() {
        savedApiKey = value;
        isEditMode = false;
        controller.clear();
      });

      AppSnackbar.info(context, "settings.api_key.success_message".tr());
    } catch (_) {
      AppSnackbar.info(context, "settings.api_key.error_message".tr());
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      isTesting = true;
    });

    try {
      await llmService.sendToLLM(DocumentChatPrompt.testConnection);

      if (mounted) {
        AppSnackbar.success(
          context,
          "settings.connection_success_message".tr(),
        );
      }
    } catch (_) {
      if (mounted) {
        AppSnackbar.error(
          context,
          "settings.connection_error_message".tr(),
          duration: Duration(seconds: 7),
        );
      }
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: colorScheme.settingsSurface.withOpacity(0.15),
            ),
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

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: !isEditMode
                      ? Column(
                          children: [
                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: colorScheme.settingsSurface.withOpacity(
                                  0.08,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 18,
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Text(
                                      "settings.api_key_note".tr(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color:  colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
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
                                    : _testConnection,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: isTesting
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : Text("settings.test_btn".tr()),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

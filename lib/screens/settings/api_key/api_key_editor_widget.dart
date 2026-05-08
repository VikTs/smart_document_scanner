
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ApiKeyEditor extends StatefulWidget {
  final TextEditingController controller;
  final bool isSaving;
  final VoidCallback onSave;

  const ApiKeyEditor({
    super.key,
    required this.controller,
    required this.isSaving,
    required this.onSave,
  });

  @override
  State<ApiKeyEditor> createState() => _ApiKeyEditorState();
}

class _ApiKeyEditorState extends State<ApiKeyEditor> {
  bool isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: widget.controller,
          obscureText: isObscured,
          decoration: InputDecoration(
            hintText: "settings.api_key_hint".tr(),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            prefixIcon: const Icon(Icons.vpn_key_rounded),
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isObscured = !isObscured;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.isSaving ? null : widget.onSave,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: widget.isSaving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text("settings.save_btn".tr()),
          ),
        ),
      ],
    );
  }
}

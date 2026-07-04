import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/data/services/storage_service.dart';
import 'package:smart_documents_scanner/screens/privacy_policy/privacy_policy_content.dart';
import 'package:smart_documents_scanner/shared/labeled_checkbox_widget.dart';

class PrivacyPolicyDialog extends StatefulWidget {
  final AppStorage storage;

  const PrivacyPolicyDialog({super.key, required this.storage});

  static Future<void> show(
    BuildContext context, {
    required AppStorage storage,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => PrivacyPolicyDialog(storage: storage),
      ),
    );
  }

  @override
  State<PrivacyPolicyDialog> createState() => _PrivacyPolicyDialogState();
}

class _PrivacyPolicyDialogState extends State<PrivacyPolicyDialog> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("privacy_policy.title".tr()),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: PrivacyPolicyContent()
            ),

            const SizedBox(height: 12),

            LabeledCheckbox(
              value: _accepted,
              label: "privacy_policy.accept_checkbox".tr(),
              onChanged: (value) {
                setState(() {
                  _accepted = value;
                });
              },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                ),
                onPressed: _accepted
                    ? () async {
                        await widget.storage.setPrivacyAccepted();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                child: Text("privacy_policy.accept_btn".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/screens/privacy_policy/privacy_policy_content.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("privacy_policy.title".tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: const PrivacyPolicyContent(),
      ),
    );
  }
}
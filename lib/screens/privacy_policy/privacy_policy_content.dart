import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyContent extends StatelessWidget {
  const PrivacyPolicyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          _Section(
            title: "privacy_policy.section_1.title".tr(),
            text: "privacy_policy.section_1.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_2.title".tr(),
            text: "privacy_policy.section_2.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_3.title".tr(),
            text: "privacy_policy.section_3.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_4.title".tr(),
            text: "privacy_policy.section_4.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_5.title".tr(),
            text: "privacy_policy.section_5.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_6.title".tr(),
            text: "privacy_policy.section_6.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_7.title".tr(),
            text: "privacy_policy.section_7.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_8.title".tr(),
            text: "privacy_policy.section_8.text".tr(),
          ),
          _Section(
            title: "privacy_policy.section_9.title".tr(),
            text: "privacy_policy.section_9.text".tr(),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String text;

  const _Section({required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}

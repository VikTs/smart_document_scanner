import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/utils/string_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({required String text, required String url})
    : super(
        text: text,
        style: url.isUrl()
            ? const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              )
            : null,
        recognizer: url.isUrl() ? (TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.parse(url);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }) : null,
      );
}

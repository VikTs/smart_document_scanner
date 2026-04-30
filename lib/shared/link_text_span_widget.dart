import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextSpan extends TextSpan {
  LinkTextSpan({required String text, required String url, TextStyle? style})
    : super(
        text: text,
        style:
            style ??
            const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            final uri = Uri.parse(url);
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          },
      );
}

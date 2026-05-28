import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';

Rect mapImageRectToWidgetRect(Rect rect, Size imageSize, Size widgetSize) {
  final scale =
      (imageSize.width / imageSize.height >
          widgetSize.width / widgetSize.height)
      ? widgetSize.width / imageSize.width
      : widgetSize.height / imageSize.height;

  final displayedWidth = imageSize.width * scale;
  final displayedHeight = imageSize.height * scale;

  final offsetX = (widgetSize.width - displayedWidth) / 2;
  final offsetY = (widgetSize.height - displayedHeight) / 2;

  return Rect.fromLTWH(
    rect.left * scale + offsetX,
    rect.top * scale + offsetY,
    rect.width * scale,
    rect.height * scale,
  );
}

Future<List<RecognizedTextBox>> generateRecognizedTextBoxes(
  Uint8List bytes,
) async {
  final result = await recognizeText(bytes: bytes);

  return result.blocks
      .expand((b) => b.lines)
      .map((l) => RecognizedTextBox(text: l.text, rect: l.boundingBox))
      .toList();
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:easy_localization/easy_localization.dart';

class OcrOverlay extends StatelessWidget {
  final List<RecognizedTextBox> boxes;
  final Size imageSize;
  final Size widgetSize;
  final Rect Function(Rect rect, Size imageSize, Size widgetSize) scaleRect;

  const OcrOverlay({
    super.key,
    required this.boxes,
    required this.imageSize,
    required this.widgetSize,
    required this.scaleRect,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: boxes.map((box) {
        final scaled = scaleRect(box.rect, imageSize, widgetSize);

        return Positioned(
          left: scaled.left,
          top: scaled.top,
          width: scaled.width,
          height: scaled.height,
          child: GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: box.text));

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("document_details.text_copied_message".tr()),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue.withOpacity(0.9),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

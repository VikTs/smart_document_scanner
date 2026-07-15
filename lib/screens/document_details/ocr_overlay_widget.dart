import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';

class OcrOverlay extends StatelessWidget {
  final List<RecognizedTextBox> boxes;
  final Size imageSize;
  final Size widgetSize;
  final Rect Function(
    Rect rect,
    Size imageSize,
    Size widgetSize,
  ) scaleRect;

  const OcrOverlay({
    super.key,
    required this.boxes,
    required this.imageSize,
    required this.widgetSize,
    required this.scaleRect,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Stack(
        children: boxes.map((box) {
          final scaled = scaleRect(
            box.rect,
            imageSize,
            widgetSize,
          );

          return Positioned(
            left: scaled.left,
            top: scaled.top,
            width: scaled.width + 20,
            height: scaled.height + 5,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.topLeft,
              child: Text(
                box.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (scaled.height - 1).clamp(8, 32),
                  height: 1,
                ),
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
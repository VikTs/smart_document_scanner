import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';

class OcrOverlay extends StatelessWidget {
  final List<RecognizedTextBox> boxes;
  final double offsetX;
  final double offsetY;
  final double scale;

  const OcrOverlay({
    super.key,
    required this.boxes,
    required this.offsetX,
    required this.offsetY,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: Stack(
        children: boxes.map((box) {
          final rect = box.rect;
          final left = rect.left * scale + offsetX;
          final top = rect.top * scale + offsetY;
          final width = rect.width * scale;
          final height = rect.height * scale;

          final isVertical = box.rect.height > box.rect.width;
          final text = isVertical ? box.text.split('').join('\n') : box.text;
          final double fontSize = isVertical
              ? (width - 1).clamp(7, 16)
              : (height - 1).clamp(7, 16);
              
          return Positioned(
            left: left,
            top: top,
            width: width + 5,
            height: height + 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.topLeft,
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fontSize,
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

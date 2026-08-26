import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';

class OcrOverlay extends StatelessWidget {
  static const double _minFontSize = 6.0;
  static const double _maxFontSize = 16.0;

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
          final width = rect.width * scale + 8;
          final height = rect.height * scale + 1;

          final isVertical = rect.height > rect.width;

          final text = isVertical ? box.text.split('').join('\n') : box.text;

          final fontSize = _calculateFontSize(
            text: text,
            width: width,
            height: height,
            isVertical: isVertical,
          );

          return Positioned(
            left: left,
            top: top,
            width: width + 4,
            height: height,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.centerLeft,
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

  double _calculateFontSize({
    required String text,
    required double width,
    required double height,
    required bool isVertical,
  }) {
    var fontSize = math.min(height, _maxFontSize);

    while (fontSize > _minFontSize) {
      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(fontSize: fontSize, height: 1),
        ),
        maxLines: isVertical ? null : 1,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: isVertical ? width : double.infinity);

      final fitsWidth = painter.width <= width;
      final fitsHeight = painter.height <= height;

      if (fitsWidth && fitsHeight) {
        return fontSize;
      }

      fontSize -= 0.5;
    }

    return _minFontSize;
  }
}

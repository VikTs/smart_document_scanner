import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/shared/app_snackbar.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
              AppSnackbar.info(
                context,
                "document_details.text_copied_message".tr(),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: colorScheme.ocrBorder.withOpacity(0.9),
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

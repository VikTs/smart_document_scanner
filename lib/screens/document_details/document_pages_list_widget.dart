import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:smart_documents_scanner/core/services/text_recognizion_service.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/screens/document_details/ocr_overlay_widget.dart';
import 'package:smart_documents_scanner/shared/images/cached_image_widget.dart';

class DocumentPagesList extends StatefulWidget {
  final ScrollController controller;
  final List<DocumentFile> files;

  final double pageHeight;

  final bool isImageLoading;
  final Map<int, Size> imageSizes;

  final bool showOcr;
  final bool isOcrLoading;
  final Map<int, List<RecognizedTextBox>> ocrData;

  const DocumentPagesList({
    super.key,
    required this.controller,
    required this.files,
    required this.pageHeight,
    required this.isImageLoading,
    required this.imageSizes,
    required this.showOcr,
    required this.isOcrLoading,
    required this.ocrData,
  });

  @override
  State<DocumentPagesList> createState() => _DocumentPagesListState();
}

class _DocumentPagesListState extends State<DocumentPagesList> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      controller: widget.controller,
      itemCount: widget.files.length,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (_, index) {
        final file = widget.files[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            height: widget.pageHeight,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final widgetSize = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );

                final imageSize = widget.imageSizes[index];

                return Stack(
                  children: [
                    Center(
                      child: widget.isImageLoading
                          ? const CircularProgressIndicator()
                          : (imageSize == null
                                ? Text(
                                    "document_details.preview_error_message"
                                        .tr(),
                                  )
                                : CachedImage(
                                    key: ValueKey("document_details_${file.id}"),
                                    bytes: file.bytes,
                                    width: imageSize.width,
                                    height: imageSize.height,
                                    fit: BoxFit.contain,
                                  )),
                    ),

                    if (widget.showOcr &&
                        widget.ocrData[index] != null &&
                        imageSize != null)
                      Positioned.fill(
                        child: OcrOverlay(
                          boxes: widget.ocrData[index]!,
                          imageSize: imageSize,
                          widgetSize: widgetSize,
                          scaleRect:
                              TextRecognisionService.mapImageRectToWidgetRect,
                        ),
                      ),

                    if (widget.isOcrLoading)
                      Positioned.fill(
                        child: ColoredBox(
                          color: colorScheme.surface.withOpacity(0.4),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

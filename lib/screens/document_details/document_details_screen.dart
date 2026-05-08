import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/db/converters/document_file_type_converter.dart';
import 'package:smart_documents_scanner/screens/chat/document_chat_screen.dart';
import 'package:smart_documents_scanner/screens/document_details/delete_confirmation_sheet.dart';
import 'package:smart_documents_scanner/screens/document_details/document_actions_widget.dart';
import 'package:smart_documents_scanner/screens/document_details/ocr_overlay_widget.dart';
import 'package:smart_documents_scanner/core/ui/app_snackbar.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(List<DocumentFile>) onShare;

  const DocumentDetailsScreen({
    super.key,
    required this.document,
    required this.onDelete,
    required this.onShare,
  });

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  int currentIndex = 0;
  double pageHeight = 0;

  bool showOcr = false;
  bool isImageLoading = true;
  bool isOcrLoading = false;

  Map<int, List<RecognizedTextBox>> ocrData = {};
  Map<int, Size> imageSizes = {};

  void _showDeleteConfirmation(BuildContext context, String documentId) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return DeleteConfirmationSheet(
          onCancel: () => Navigator.pop(context),
          onConfirm: () {
            Navigator.pop(context);
            widget.onDelete(context, documentId);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageHeight = MediaQuery.of(context).size.height * 0.7;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentPage);
    _preloadImageSizes();
  }

  void _updateCurrentPage() {
    if (!mounted) return;

    final index = (_scrollController.offset / pageHeight).floor();
    final newIndex = index.clamp(0, widget.document.files.length - 1);

    if (newIndex != currentIndex) {
      setState(() => currentIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _preloadImageSizes() async {
    setState(() => isImageLoading = true);

    final Map<int, Size> sizes = {};
    final files = widget.document.files;

    for (int i = 0; i < files.length; i++) {
      try {
        final codec = await ui.instantiateImageCodec(files[i].bytes);
        final frame = await codec.getNextFrame();
        final image = frame.image;

        sizes[i] = Size(image.width.toDouble(), image.height.toDouble());
      } catch (e) {
        debugPrint("Image decode error page $i: $e");
        sizes[i] = const Size(1000, 1000);
      }
    }

    if (!mounted) return;

    setState(() {
      imageSizes = sizes;
      isImageLoading = false;
    });
  }

  Future<void> _handleRecognize() async {
    try {
      setState(() {
        showOcr = true;
        isOcrLoading = true;
      });

      final files = widget.document.files;

      for (int i = 0; i < files.length; i++) {
        final boxes = await _recognize(files[i].bytes);
        if (boxes.isEmpty) {
          AppSnackbar.warning(context, "home.document_recognision_error".tr());
        }

        if (!mounted) return;

        setState(() {
          ocrData[i] = boxes;
        });
      }
    } finally {
      if (mounted) {
        setState(() => isOcrLoading = false);
      }
    }
  }

  Future<List<RecognizedTextBox>> _recognize(Uint8List bytes) async {
    final result = await recognizeText(bytes: bytes);

    return result.blocks
        .expand((b) => b.lines)
        .map((l) => RecognizedTextBox(text: l.text, rect: l.boundingBox))
        .toList();
  }

  Rect _scaleRect(Rect rect, Size imageSize, Size widgetSize) {
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

  @override
  Widget build(BuildContext context) {
    final documentFiles = widget.document.files;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
        leading: const BackButton(),
      ),
      body: documentFiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: documentFiles.length,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (_, index) {
                    final file = documentFiles[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SizedBox(
                        height: pageHeight,
                        child: LayoutBuilder(
                          builder: (_, constraints) {
                            final widgetSize = Size(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            );

                            return Stack(
                              children: [
                                Center(
                                  child: isImageLoading
                                      ? const CircularProgressIndicator()
                                      : FittedBox(
                                          fit: BoxFit.contain,
                                          child: SizedBox(
                                            width: imageSizes[index]!.width,
                                            height: imageSizes[index]!.height,
                                            child: Image.memory(file.bytes),
                                          ),
                                        ),
                                ),

                                if (showOcr &&
                                    ocrData[index] != null &&
                                    imageSizes[index] != null)
                                  Positioned.fill(
                                    child: OcrOverlay(
                                      boxes: ocrData[index]!,
                                      imageSize: imageSizes[index]!,
                                      widgetSize: widgetSize,
                                      scaleRect: _scaleRect,
                                    ),
                                  ),

                                if (isOcrLoading)
                                  const Positioned.fill(
                                    child: ColoredBox(
                                      color: Colors.black26,
                                      child: Center(
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
                ),

                if (widget.document.files[0].type == DocumentFileType.image)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DocumentChatScreen(document: widget.document),
                          ),
                        );
                      },
                      child: Icon(Icons.chat),
                    ),
                  ),

                if (showOcr && !isOcrLoading && ocrData[0]?.isNotEmpty == true)
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 8,
                    child: SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'document_details.tap_to_copy_label'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                if (documentFiles.length > 1)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${currentIndex + 1}/${documentFiles.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: DocumentActions(
        document: widget.document,
        onDelete: _showDeleteConfirmation,
        onShare: widget.onShare,
        onRecognize: _handleRecognize,
      ),
    );
  }
}

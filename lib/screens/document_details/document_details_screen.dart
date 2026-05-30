import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/recognized_text.dart';
import 'package:smart_documents_scanner/core/services/text_recognizion_service.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc_extension.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_event.dart';
import 'package:smart_documents_scanner/screens/chat/document_chat_screen.dart';
import 'package:smart_documents_scanner/screens/document_details/delete_confirmation_sheet.dart';
import 'package:smart_documents_scanner/screens/document_details/document_actions_widget.dart';
import 'package:smart_documents_scanner/screens/document_details/document_pages_list_widget.dart';
import 'package:smart_documents_scanner/screens/document_details/info_banner_overlay_widget.dart';
import 'package:smart_documents_scanner/shared/app_snackbar.dart';
import 'package:smart_documents_scanner/screens/document_details/page_indicator_overlay_widget.dart';
import 'package:smart_documents_scanner/shared/editable_title_app_bar.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final String documentId;
  final void Function(BuildContext, String) onDelete;
  final void Function(List<DocumentFile>) onShare;

  const DocumentDetailsScreen({
    super.key,
    required this.documentId,
    required this.onDelete,
    required this.onShare,
  });

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final ScrollController _scrollController = ScrollController();

  DocumentData? document;

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

    _scrollController.addListener(() {
      _updateCurrentPage(document?.files.length ?? 1);
    });
  }

  void _updateCurrentPage(int pageNumber) {
    if (!mounted) return;

    final index = (_scrollController.offset / pageHeight).floor();
    final newIndex = index.clamp(0, pageNumber - 1);

    if (newIndex != currentIndex) {
      setState(() => currentIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadImageSizes(List<DocumentFile> files) async {
    setState(() => isImageLoading = true);

    final Map<int, Size> sizes = {};
    for (int i = 0; i < files.length; i++) {
      sizes[i] = await loadImageSize(files[i].bytes);
    }

    setState(() {
      imageSizes = sizes;
      isImageLoading = false;
    });
  }

  Future<void> _handleRecognize(List<DocumentFile> files) async {
    try {
      setState(() {
        showOcr = true;
        isOcrLoading = true;
      });

      for (int i = 0; i < files.length; i++) {
        final boxes = await TextRecognisionService.generateRecognizedTextBoxes(
          files[i].bytes,
        );

        if (boxes.isEmpty && mounted) {
          AppSnackbar.warning(context, "home.document_recognision_error".tr());
        }

        setState(() {
          ocrData[i] = boxes;
        });
      }
    } finally {
      setState(() => isOcrLoading = false);
    }
  }

  void onUpdateDocumentName(DocumentData? document, String newName) {
    if (document == null) return;
    if (newName == document.name) return;

    final updatedDocument = document.copyWith(name: newName);
    context.read<DocumentsBloc>().add(
      UpdateDocument(document: updatedDocument),
    );
  }

  void _loadDocument(BuildContext context) {
    final blocDocument = context.select(
      (DocumentsBloc bloc) => bloc.byId(widget.documentId),
    );

    if (blocDocument?.files.length != document?.files.length) {
      _loadImageSizes(blocDocument?.files ?? []);
    }
    if (blocDocument != null) {
      setState(() => document = blocDocument);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    _loadDocument(context);
    final documentFiles = document?.files;

    return Scaffold(
      appBar: EditableTitleAppBar(
        title: document?.name ?? "",
        onChanged: (String name) {
          onUpdateDocumentName(document, name);
        },
      ),
      body: documentFiles?.isEmpty == true
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                DocumentPagesList(
                  controller: _scrollController,
                  files: documentFiles!,
                  pageHeight: pageHeight,
                  isImageLoading: isImageLoading,
                  imageSizes: imageSizes,
                  showOcr: showOcr,
                  isOcrLoading: isOcrLoading,
                  ocrData: ocrData,
                ),

                if (isImage(documentFiles[0].extension) && document != null)
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
                                DocumentChatScreen(document: document!),
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
                    child: InfoBannerOverlay(
                      backgroundColor: colorScheme.overlayStrong,
                      textColor: colorScheme.textLight,
                      text: 'document_details.tap_to_copy_label',
                    ),
                  ),
                if (documentFiles.length > 1)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: PageIndicatorOverlay(
                      currentIndex: currentIndex,
                      total: documentFiles.length,
                      backgroundColor: colorScheme.overlayStrong,
                      textColor: colorScheme.textLight,
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: document != null
          ? DocumentActions(
              areActionsDisabled: isImageLoading || isOcrLoading,
              document: document!,
              onDelete: _showDeleteConfirmation,
              onShare: widget.onShare,
              onRecognize: _handleRecognize,
            )
          : SizedBox.shrink(),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:typed_data';

import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';
import 'package:smart_documents_scanner/shared/app_snackbar.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/screens/scan_camera/scan_camera_screen.dart';

class AddDocumentButton extends StatefulWidget {
  const AddDocumentButton({super.key});

  @override
  State<AddDocumentButton> createState() => _AddDocumentButtonState();
}

class _AddDocumentButtonState extends State<AddDocumentButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilledButton.icon(
      onPressed: _isLoading ? null : () => _showAddOptions(context),
      icon: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.loadingIndicator,
              ),
            )
          : const Icon(Icons.add),
      label: Text(
        _isLoading ? 'home.loading'.tr() : 'home.add_document_btn'.tr(),
        style: const TextStyle(fontSize: 16),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AddOptionTile(
                  icon: Icons.document_scanner,
                  title: "home.scan_document_btn".tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await _performAction(_scanDocument);
                  },
                ),
                _AddOptionTile(
                  icon: Icons.upload_file,
                  title: "home.upload_file_btn".tr(),
                  onTap: () async {
                    Navigator.pop(context);
                    await _performAction(_uploadFile);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _performAction(
    Future<void> Function(BuildContext) action,
  ) async {
    setState(() => _isLoading = true);
    try {
      await action(context);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _scanDocument(BuildContext context) async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
    );

    if (imagePath == null) return;

    final bytes = await imageToBytes(imagePath);
    final recognizedText = await recognizeText(imagePath: imagePath);
    final document = await generateDocument(bytes);

    if (!mounted) {
      return;
    }

    if (recognizedText.blocks.isEmpty) {
      AppSnackbar.warning(context, "home.document_recognision_error".tr());
    }

    if (document != null) {
      context.read<DocumentsBloc>().add(SaveDocument(document: document));
    }
  }

  Future<DocumentData?> generateDocument(
    Uint8List bytes, {
    DocumentFileExtension extension = DocumentFileExtension.jpg,
    String? documentName,
  }) async {
    final documentId = const Uuid().v1();
    try {
      final List<DocumentFile> files;
      if (extension == DocumentFileExtension.pdf) {
        files = await pdfToPages(documentId, bytes);
      } else {
        final fileData = DocumentFile(
          id: const Uuid().v1(),
          documentId: documentId,
          bytes: bytes,
          pageNumber: 1,
          extension: extension,
        );
        files = [fileData];
      }
      final document = DocumentData(
        id: documentId,
        createdAt: DateTime.now(),
        files: files,
        name: documentName ?? documentDefaultName,
      );
      return document;
    } catch (e) {
      if (mounted) {
        AppSnackbar.error(context, e.toString());
      }
    }
    return null;
  }

  Future<void> _uploadFile(BuildContext context) async {
    final result = await uploadFile();
    final bytes = result?.files.single.bytes;
    final extension = result?.names[0]?.split('.').last ?? 'jpg';

    if (result == null || bytes == null) return;

    final document = await generateDocument(
      bytes,
      extension: DocumentFileExtension.values.byName(extension),
      documentName: getFileNameWithoutExtension(result.names[0]),
    );

    if (!context.mounted) return;

    if (document != null) {
      context.read<DocumentsBloc>().add(SaveDocument(document: document));
    }
  }
}

class _AddOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AddOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}

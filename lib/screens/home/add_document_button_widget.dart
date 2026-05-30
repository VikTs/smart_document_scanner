import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/services/document_upload_service.dart';
import 'package:smart_documents_scanner/shared/bottom_sheets/add_document_bottom_sheet.dart';

class AddDocumentButton extends StatefulWidget {
  final void Function(DocumentData document) onDocumentCreated;

  const AddDocumentButton({super.key, required this.onDocumentCreated});

  @override
  State<AddDocumentButton> createState() => _AddDocumentButtonState();
}

class _AddDocumentButtonState extends State<AddDocumentButton> {
  bool _isLoading = false;

  void onShowAddDocumentBottomSheet() {
    showAddDocumentBottomSheet(
      context: context,
      onScan: () => _processAction(() => DocumentUploadService.scan(context)),
      onUpload: () => _processAction(DocumentUploadService.upload),
    );
  }

  Future<void> _processAction(Future<DocumentData?> Function() action) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final document = await action();

      if (document != null && mounted) {
        widget.onDocumentCreated(document);
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: _isLoading ? null : onShowAddDocumentBottomSheet,
      icon: _isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            )
          : const Icon(Icons.add),
      label: Text(
        _isLoading ? 'home.loading'.tr() : 'home.add_document_btn'.tr(),
      ),
    );
  }
}

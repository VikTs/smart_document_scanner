import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/services/document_upload.dart';

class AddDocumentButton extends StatefulWidget {
  final void Function(DocumentData document) onDocumentCreated;

  const AddDocumentButton({super.key, required this.onDocumentCreated});

  @override
  State<AddDocumentButton> createState() => _AddDocumentButtonState();
}

class _AddDocumentButtonState extends State<AddDocumentButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FilledButton.icon(
      onPressed: _isLoading ? null : () => _showAddOptions(context),
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

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: Text("home.scan_document_btn".tr()),
              onTap: () async {
                Navigator.pop(context);
                await _handle(() async {
                  final doc = await DocumentUploadService.scan(context);
                  if (doc != null) {
                    widget.onDocumentCreated(doc);
                  }
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text("home.upload_file_btn".tr()),
              onTap: () async {
                Navigator.pop(context);
                await _handle(() async {
                  final doc = await DocumentUploadService.upload();
                  if (doc != null) {
                    widget.onDocumentCreated(doc);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _handle(Future<void> Function() action) async {
    setState(() => _isLoading = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

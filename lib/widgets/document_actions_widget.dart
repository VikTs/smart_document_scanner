import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_documents_scanner/core/ui/app_snackbar.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';

class DocumentActions extends StatelessWidget {
  final Document document;

  const DocumentActions({super.key, required this.document});

  Future<void> _shareDocument(
    BuildContext context,
    Uint8List documentBytes,
  ) async {
    try {
      shareFile(documentBytes, "jpg");
    } catch (e) {
      AppSnackbar.warning(context, "Failed to share document".tr());
    }
  }

  void _deleteDocument(BuildContext context) {
    context.read<DocumentsBloc>().add(ClearDocument(id: document.id));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                _shareDocument(context, document.file);
              },
              icon: Icon(Icons.share, color: colorScheme.onPrimary),
              label: Text(
                'document_details.share_document_btn'.tr(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {
                _deleteDocument(context);
              },
              icon: Icon(Icons.delete, color: colorScheme.onError),
              label: Text(
                'document_details.delete_document_btn'.tr(),
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: colorScheme.errorContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

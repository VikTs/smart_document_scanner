import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/core/utils/date_utils.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_event.dart';
import 'package:smart_documents_scanner/screens/document_details/document_details_screen.dart';

class DocumentCardWidget extends StatelessWidget {
  final DocumentData document;
  const DocumentCardWidget({super.key, required this.document});

  void onDelete(BuildContext context, String documentId) {
    context.read<DocumentsBloc>().add(ClearDocument(id: documentId));
  }

  void onShare(List<DocumentFile> documentFiles) {
    final extension = documentFiles[0].extension.name;
    final Uint8List mergedFile = documentFiles[0].bytes;
    shareFile(mergedFile, extension);
  }

  Widget _buildFilePreview(DocumentFile file) {
    Uint8List bytes = file.bytes;
    DocumentFileExtension extension = file.extension;

    if (isImage(extension)) {
      return Image.memory(bytes, width: 50, height: 50, fit: BoxFit.cover);
    }

    IconData icon;
    Color color;

    switch (extension) {
      case DocumentFileExtension.pdf:
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return SizedBox(
      width: 50,
      height: 50,
      child: Icon(icon, size: 32, color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: context.read<DocumentsBloc>(),
            child: DocumentDetailsScreen(
              documentId: document.id,
              onDelete: onDelete,
              onShare: onShare,
            ),
          ),
        ),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _buildFilePreview(document.files[0]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      formatDate(
                        document.createdAt,
                        format: "dd/MM/yyyy hh:mm",
                      ),
                      style: textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              const Icon(Icons.open_in_new, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

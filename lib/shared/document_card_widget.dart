import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/utils/date_utils.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/screens/document_details/document_details_screen.dart';

class DocumentCardWidget extends StatelessWidget {
  final DocumentData document;
  const DocumentCardWidget({super.key, required this.document});

  void onDelete(BuildContext context, String documentId) {
    context.read<DocumentsBloc>().add(ClearDocument(id: documentId));
    Navigator.pop(context);
  }

  void onShare(List<DocumentFile> documentFiles) {
    final type = documentFiles[0].type;
    final extension = getExtensionFromType(type);
    final Uint8List mergedFile = documentFiles[0].bytes;
    shareFile(mergedFile, extension);
  }

  Widget _buildFilePreview(Uint8List file, String? name) {
    final ext = name?.split('.').last.toLowerCase();

    if (ext == 'jpg' || ext == 'jpeg' || ext == 'png') {
      return Image.memory(file, width: 50, height: 50, fit: BoxFit.cover);
    }

    IconData icon;
    Color color;

    switch (ext) {
      case 'pdf':
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
              document: document,
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              _buildFilePreview(document.files[0].bytes, document.name),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(document.name),
                  Text(
                    formatDate(document.createdAt, format: "dd/MM/yyyy hh:mm"),
                    style: textTheme.bodySmall,
                  ),
                ],
              ),
              Spacer(),
              const Icon(Icons.open_in_new, size: 14),
            ],
          ),
        ),
      ),
    );
  }
}

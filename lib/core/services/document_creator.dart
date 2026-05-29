import 'dart:typed_data';
import 'package:uuid/uuid.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';

class DocumentCreator {
  static Future<DocumentData?> create({
    required Uint8List bytes,
    required DocumentFileExtension extension,
    String? documentName,
  }) async {
    final documentId = const Uuid().v1();

    try {
      final List<DocumentFile> files;

      if (extension == DocumentFileExtension.pdf) {
        files = await pdfToPages(documentId, bytes);
      } else {
        files = [
          DocumentFile(
            id: const Uuid().v1(),
            documentId: documentId,
            bytes: bytes,
            pageNumber: 1,
            extension: extension,
          )
        ];
      }

      return DocumentData(
        id: documentId,
        createdAt: DateTime.now(),
        files: files,
        name: documentName ?? documentDefaultName,
      );
    } catch (e) {
      rethrow;
    }
  }
}
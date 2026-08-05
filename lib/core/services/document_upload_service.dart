import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/screens/scan_camera/scan_camera_screen.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:uuid/uuid.dart';

class DocumentUploadService {
  static Future<DocumentData?> scan(BuildContext context) async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
    );

    if (imagePath == null) return null;

    return createDocumentFromImagePath(imagePath);
  }

  static Future<DocumentData?> upload() async {
    final result = await uploadFile();
    if (result == null) return null;

    final bytes = result.files.single.bytes;
    if (bytes == null) return null;

    final extension = getFileExtension(result.names[0]!);

    return _createDocument(
      bytes: bytes,
      extension: extension,
      documentName: getFileNameWithoutExtension(result.names[0]),
    );
  }

  static Future<DocumentData?> createDocumentFromImagePath(
    String imagePath,
  ) async {
    final bytes = await imageToBytes(imagePath);
    final extension = getFileExtension(imagePath);
    final name = getFileNameWithoutExtension(imagePath);

    return _createDocument(bytes: bytes, extension: extension, documentName: name);
  }

  static Future<DocumentData?> _createDocument({
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
          ),
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

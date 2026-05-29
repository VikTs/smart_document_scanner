import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/core/services/document_creator.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/screens/scan_camera/scan_camera_screen.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';

class DocumentUploadService {
  static Future<DocumentData?> scan(BuildContext context) async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
    );

    if (imagePath == null) return null;

    final bytes = await imageToBytes(imagePath);

    final document = await DocumentCreator.create(
      bytes: bytes,
      extension: DocumentFileExtension.jpg,
    );

    return document;
  }

  static Future<DocumentData?> upload() async {
    final result = await uploadFile();
    if (result == null) return null;

    final bytes = result.files.single.bytes;
    if (bytes == null) return null;

    final extension = DocumentFileExtension.values.byName(
      result.names[0]!.split('.').last,
    );

    return DocumentCreator.create(
      bytes: bytes,
      extension: extension,
      documentName: getFileNameWithoutExtension(result.names[0]),
    );
  }
}

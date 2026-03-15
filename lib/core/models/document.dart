import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentData {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<DocumentFile> files;

  DocumentData({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.files,
  });
}
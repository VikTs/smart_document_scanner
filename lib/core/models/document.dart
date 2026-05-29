import 'package:smart_documents_scanner/data/db/app_database.dart';

const documentDefaultName = "Scanned document";

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

  DocumentData copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<DocumentFile>? files,
  }) {
    return DocumentData(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      files: files ?? this.files,
    );
  }
}

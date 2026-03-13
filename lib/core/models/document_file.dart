import 'dart:typed_data';

enum DocumentFileType { image, pdf }

class DocumentFile {
  final Uint8List bytes;
  final String name;
  final DocumentFileType type;
  final int? pageNumber;

  DocumentFile({
    required this.bytes,
    required this.name,
    required this.type,
    this.pageNumber,
  });
}
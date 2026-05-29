import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';

class DocumentFileExtensionConverter extends TypeConverter<DocumentFileExtension, int> {
  const DocumentFileExtensionConverter();

  @override
  DocumentFileExtension fromSql(int fromDb) {
    return DocumentFileExtension.values[fromDb];
  }

  @override
  int toSql(DocumentFileExtension value) {
    return value.index;
  }
}
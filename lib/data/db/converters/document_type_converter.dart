import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/models/document_type.dart';

class DocumentTypeConverter extends TypeConverter<DocumentType, String> {
  const DocumentTypeConverter();

  @override
  DocumentType fromSql(String fromDb) {
    return DocumentType.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => DocumentType.unknown,
    );
  }

  @override
  String toSql(DocumentType value) {
    return value.name;
  }
}
import 'package:drift/drift.dart';

enum DocumentFileType { image, pdf }

class DocumentFileTypeConverter extends TypeConverter<DocumentFileType, int> {
  const DocumentFileTypeConverter();

  @override
  DocumentFileType fromSql(int fromDb) {
    return DocumentFileType.values[fromDb];
  }

  @override
  int toSql(DocumentFileType value) {
    return value.index;
  }
}
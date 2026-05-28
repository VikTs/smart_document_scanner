import 'package:drift/drift.dart';

enum DocumentFileExtension { jpg, jpeg, png, pdf }

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
import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/converters/document_file_extension_converter.dart';
import 'package:smart_documents_scanner/data/db/tables/documents_table.dart';

class DocumentFiles extends Table {
  TextColumn get id => text()();

  TextColumn get documentId => text().references(
    Documents,
    #id,
    onDelete: KeyAction.cascade,
  )();

  BlobColumn get bytes => blob()();
  IntColumn get extension => integer().map(const DocumentFileExtensionConverter())();
  IntColumn get pageNumber => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
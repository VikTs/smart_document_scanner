import 'package:drift/drift.dart';

class DocumentFiles extends Table {
  TextColumn get id => text()();
  TextColumn get documentId => text()();
  BlobColumn get bytes => blob()();
  IntColumn get type => integer()();
  IntColumn get pageNumber => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

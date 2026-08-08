import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/tables/documents_table.dart';

class Messages extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().references(Documents, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get createdAt => dateTime()();
  TextColumn get value => text()();
  BoolColumn get isUser => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

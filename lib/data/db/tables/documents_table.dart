import 'package:drift/drift.dart';

class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  BlobColumn get file => blob()();
}

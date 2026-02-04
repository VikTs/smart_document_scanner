import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:smart_documents_scanner/data/db/converters/document_type_converter.dart';
import 'package:smart_documents_scanner/models/document_type.dart';

import 'tables/documents_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Documents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> clearTable(TableInfo table) {
    return transaction(() async {
        await delete(table).go();
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

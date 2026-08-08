import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:smart_documents_scanner/core/models/document_file_extension.dart';
import 'package:smart_documents_scanner/data/db/converters/document_file_extension_converter.dart';
import 'package:smart_documents_scanner/data/db/tables/document_files_table.dart';
import 'package:smart_documents_scanner/data/db/tables/messages_table.dart';

import 'tables/documents_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Documents, DocumentFiles, Messages])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<void> clearAll() async {
    await transaction(() async {
      await delete(documentFiles).go();
      await delete(documents).go();
    });
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.createTable(messages);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

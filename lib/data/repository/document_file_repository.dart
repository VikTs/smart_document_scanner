import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentFileRepository {
  final AppDatabase db;

  DocumentFileRepository(this.db);

  Future<List<DocumentFile>> getDocumentFiles(String documentId) async {
    final files =
        await (db.select(db.documentFiles)
              ..where((f) => f.documentId.equals(documentId))
              ..orderBy([(f) => OrderingTerm.asc(f.pageNumber)]))
            .get();

    return files;
  }

  Future<void> addDocumentFiles(List<DocumentFile> files) async {
    await db.transaction(() async {
      for (final file in files) {
        await db.into(db.documentFiles).insert(file);
      }
    });
  }
}

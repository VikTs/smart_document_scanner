import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentFileRepository {
  final AppDatabase db;

  DocumentFileRepository(this.db);

  Future<List<DocumentFile>> getDocumentFiles(String documentId) async {
    return (db.select(db.documentFiles)
          ..where((f) => f.documentId.equals(documentId))
          ..orderBy([(f) => OrderingTerm.asc(f.pageNumber)]))
        .get();
  }

  Future<void> addDocumentFiles(List<DocumentFile> files) async {
    await db.batch((batch) {
      batch.insertAll(db.documentFiles, files);
    });
  }
}

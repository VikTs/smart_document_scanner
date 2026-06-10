import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentsRepository {
  final AppDatabase db;

  DocumentsRepository(this.db);

  Future<List<DocumentData>> getDocuments() async {
    final query = db.select(db.documents)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);

    final documents = await query.get();

    final result = <DocumentData>[];

    for (final doc in documents) {
      final files =
          await (db.select(db.documentFiles)
                ..where((f) => f.documentId.equals(doc.id))
                ..orderBy([(f) => OrderingTerm.asc(f.pageNumber)]))
              .get();

      result.add(
        DocumentData(
          id: doc.id,
          name: doc.name,
          createdAt: doc.createdAt,
          files: files,
        ),
      );
    }

    return result;
  }

  Future<void> addDocument(DocumentData document) async {
    await db.transaction(() async {
      await db
          .into(db.documents)
          .insert(
            Document(
              id: document.id,
              name: document.name,
              createdAt: document.createdAt,
            ),
          );

      await db.batch((batch) {
        batch.insertAll(db.documentFiles, document.files);
      });
    });
  }

  Future<void> updateDocument(DocumentData document) async {
    await (db.update(
      db.documents,
    )..where((t) => t.id.equals(document.id))).write(
      Document(
        id: document.id,
        name: document.name,
        createdAt: document.createdAt,
      ),
    );
  }

  Future<void> clearDocuments() async {
    await db.clearAll();
  }

  Future<void> clearDocument(String id) async {
    await db.transaction(() async {
      await (db.delete(db.documents)..where((t) => t.id.equals(id))).go();
    });
  }
}

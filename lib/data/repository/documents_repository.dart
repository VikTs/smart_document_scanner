import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:uuid/uuid.dart';

class DocumentsRepository {
  final AppDatabase db;

  DocumentsRepository(this.db);

  Future<List<Document>> getDocuments() async {
    final rows = await (db.select(
      db.documents,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

    return rows;
  }

  Future<void> addDocument(Document document) async {
    await db
        .into(db.documents)
        .insert(
          DocumentsCompanion.insert(
            id: Uuid().v1(),
            type: document.type,
            documentDate: Value(document.documentDate),
            createdAt: document.createdAt,
            file: document.file,
            placeType: Value(document.placeType),
            totalAmount: Value(document.totalAmount),
            currency: Value(document.currency),
          ),
        );
  }

  Future<void> clearDocuments() async {
    db.clearTable(db.documents);
  }

  Future<void> clearDocument(String id) async {
    await (db.delete(db.documents)..where((tbl) => tbl.id.equals(id))).go();
  }
}

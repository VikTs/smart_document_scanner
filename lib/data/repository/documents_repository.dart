import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/repository/document_file_repository.dart';

class DocumentsRepository {
  final AppDatabase db;
  final DocumentFileRepository documentFileRepository;

  DocumentsRepository(this.db, this.documentFileRepository);

  Future<List<DocumentData>> getDocuments() async {
    final documents = await (db.select(
      db.documents,
    )..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

    final result = <DocumentData>[];

    for (final doc in documents) {
      final files = await documentFileRepository.getDocumentFiles(doc.id);

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
    final dbDocument = Document(
      id: document.id,
      name: document.name,
      createdAt: document.createdAt,
    );

    await db.into(db.documents).insert(dbDocument);
    await documentFileRepository.addDocumentFiles(document.files);
  }

  Future<void> updateDocument(DocumentData document) async {
    final dbDocument = Document(
      id: document.id,
      name: document.name,
      createdAt: document.createdAt,
    );

    await (db.update(
      db.documents,
    )..where((tbl) => tbl.id.equals(dbDocument.id))).write(dbDocument);
  }

  Future<void> clearDocuments() async {
    db.clearTable(db.documents);
  }

  Future<void> clearDocument(String id) async {
    await (db.delete(db.documents)..where((tbl) => tbl.id.equals(id))).go();
  }
}

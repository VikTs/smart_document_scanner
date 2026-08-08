import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:uuid/uuid.dart';

class MessagesRepository {
  final AppDatabase db;

  MessagesRepository(this.db);

  Future<List<Message>> getMessages(String documentId) {
    return (db.select(db.messages)
          ..where((message) => message.documentId.equals(documentId))
          ..orderBy([(message) => OrderingTerm.asc(message.createdAt)]))
        .get();
  }

  Future<void> addMessage({
    required String documentId,
    required String value,
    required bool isUser,
  }) async {
    await db
        .into(db.messages)
        .insert(
          MessagesCompanion.insert(
            id: const Uuid().v4(),
            documentId: documentId,
            createdAt: DateTime.now(),
            value: value,
            isUser: isUser,
          ),
        );
  }

  Stream<List<Message>> watchMessages(String documentId) {
    return (db.select(db.messages)
          ..where((message) => message.documentId.equals(documentId))
          ..orderBy([(message) => OrderingTerm.asc(message.createdAt)]))
        .watch();
  }

  Future<void> addMessages(List<Message> messages) async {
    await db.batch((batch) {
      batch.insertAll(db.messages, messages);
    });
  }
}

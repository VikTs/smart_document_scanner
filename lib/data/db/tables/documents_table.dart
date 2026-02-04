import 'package:drift/drift.dart';
import 'package:smart_documents_scanner/data/db/converters/document_type_converter.dart';

class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get type => text().map(const DocumentTypeConverter())();
  DateTimeColumn get createdAt => dateTime()();
  BlobColumn get file => blob()();
  DateTimeColumn get documentDate => dateTime().nullable()();

  // Id document
  DateTimeColumn get expirationDate => dateTime().nullable()();

  // Receipt
  TextColumn get placeType => text().nullable()();
  TextColumn get currency => text().nullable()();
  RealColumn get totalAmount => real().nullable()();
}

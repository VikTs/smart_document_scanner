import 'package:equatable/equatable.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

abstract class DocumentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class ClearDocuments extends DocumentsEvent {}

class ClearDocument extends DocumentsEvent {
  final String id;

  ClearDocument({required this.id});
}

class SaveScannedDocument extends DocumentsEvent {
  final Document document;

  SaveScannedDocument({required this.document});
}

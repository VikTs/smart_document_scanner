import 'package:equatable/equatable.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

abstract class DocumentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DocumentsInitial extends DocumentsState {}

class DocumentsLoading extends DocumentsState {}

class DocumentsLoaded extends DocumentsState {
  final List<Document> documents;

  DocumentsLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

class DocumentsEmpty extends DocumentsState {}

class DocumentsError extends DocumentsState {
  final String message;

  DocumentsError(this.message);

  @override
  List<Object?> get props => [message];
}

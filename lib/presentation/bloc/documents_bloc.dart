import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_documents_scanner/data/repository/documents_repository.dart';
import 'documents_event.dart';
import 'documents_state.dart';

class DocumentsBloc extends Bloc<DocumentsEvent, DocumentsState> {
  final DocumentsRepository repository;

  DocumentsBloc(this.repository) : super(DocumentsInitial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<SaveScannedDocument>(_onSaveScannedDocument);
    on<ClearDocuments>(_onClearDocuments);
    on<ClearDocument>(_onClearDocument);
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    emit(DocumentsLoading());

    try {
      final docs = await repository.getDocuments();

      if (docs.isEmpty) {
        emit(DocumentsEmpty());
      } else {
        emit(DocumentsLoaded(docs));
      }
    } catch (e) {
      emit(DocumentsError(e.toString()));
    }
  }

  Future<void> _onSaveScannedDocument(
    SaveScannedDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    await repository.addDocument(event.document);
    add(LoadDocuments());
  }

  Future<void> _onClearDocuments(
    ClearDocuments event,
    Emitter<DocumentsState> emit,
  ) async {
    await repository.clearDocuments();
    add(LoadDocuments());
  }

  Future<void> _onClearDocument(
    ClearDocument event,
    Emitter<DocumentsState> emit,
  ) async {
    await repository.clearDocument(event.id);
    add(LoadDocuments());
  }
}

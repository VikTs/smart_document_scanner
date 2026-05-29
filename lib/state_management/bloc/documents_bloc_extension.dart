import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_state.dart';

extension DocumentsBlocX on DocumentsBloc {
  DocumentData? byId(String id) {
    final state = this.state;

    if (state is DocumentsLoaded) {
      try {
        return state.documents.firstWhere((d) => d.id == id);
      } catch (_) {
        return null;
      }
    }

    return null;
  }
}
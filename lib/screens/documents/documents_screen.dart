import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/documents/documents_empty_widget.dart';
import 'package:smart_documents_scanner/screens/documents/documents_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _query = '';

  List<DocumentData> _filterDocuments(List<DocumentData> docs) {
    if (_query.isEmpty) return docs;

    return docs.where((doc) {
      final title = doc.name.toLowerCase();
      return title.contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("appBar.documents".tr())),
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DocumentsEmpty) {
            return const DocumentsEmptyWidget();
          }

          if (state is DocumentsError) {
            return Center(child: Text(state.message));
          }

          if (state is DocumentsLoaded) {
            final filteredDocs = _filterDocuments(state.documents);

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        _query = value.trim().toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: "documents.search_field_hint".tr(),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: DocumentsWidget(documents: filteredDocs)),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

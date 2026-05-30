import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/shared/bottom_sheets/add_document_bottom_sheet.dart';
import 'package:smart_documents_scanner/core/services/document_upload_service.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_event.dart';
import 'package:smart_documents_scanner/state_management/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/documents/documents_empty_widget.dart';
import 'package:smart_documents_scanner/screens/documents/documents_sort_button_widget.dart';
import 'package:smart_documents_scanner/screens/documents/documents_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _query = '';
  DocumentSortType _sortType = DocumentSortType.newOld;

  List<DocumentData> _processDocuments(List<DocumentData> docs) {
    var result = docs;

    if (_query.isNotEmpty) {
      result = result.where((doc) {
        return doc.name.toLowerCase().contains(_query);
      }).toList();
    }

    result.sort((a, b) {
      switch (_sortType) {
        case DocumentSortType.az:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());

        case DocumentSortType.za:
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());

        case DocumentSortType.oldNew:
          return a.createdAt.compareTo(b.createdAt);

        case DocumentSortType.newOld:
          return b.createdAt.compareTo(a.createdAt);
      }
    });

    return result;
  }

  void _onSortSelected(DocumentSortType type) {
    setState(() => _sortType = type);
  }

  void onDocumentCreated(DocumentData? document) {
    if (document != null) {
      context.read<DocumentsBloc>().add(SaveDocument(document: document));
    }
  }

  void onShowAddDocumentBottomSheet() {
    showAddDocumentBottomSheet(
      context: context,
      onScan: () async {
        final document = await DocumentUploadService.scan(context);
        onDocumentCreated(document);
      },
      onUpload: () async {
        final document = await DocumentUploadService.upload();
        onDocumentCreated(document);
      },
    );
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
            return DocumentsEmptyWidget(onDocumentCreated: onDocumentCreated);
          }

          if (state is DocumentsError) {
            return Center(child: Text(state.message));
          }

          if (state is DocumentsLoaded) {
            final docs = _processDocuments(state.documents);

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
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
                          ),
                          const SizedBox(width: 8),
                          DocumentsSortButton(
                            sortType: _sortType,
                            onSelected: _onSortSelected,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: DocumentsWidget(
                          documents: docs,
                          onDocumentCreated: onDocumentCreated,
                        ),
                      ),
                    ],
                  ),
                ),
                if (docs.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      shape: const CircleBorder(),
                      onPressed: onShowAddDocumentBottomSheet,
                      child: const Icon(Icons.post_add),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

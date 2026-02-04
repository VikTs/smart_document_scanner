import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/widgets/document_preview_card.dart';
import 'package:smart_documents_scanner/widgets/document_summary_card.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final Document document;

  const DocumentDetailsScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text("document_details.title".tr()),
        actions: const [Icon(Icons.more_vert)],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            "document_details.summary_title".tr(),
            style: textTheme.titleMedium,
          ),
          DocumentSummaryCard(document: document),
          const SizedBox(height: 16),
          DocumentPreviewCard(document: document),
          const SizedBox(height: 16),
          _DeleteDocumentButton(documentId: document.id),
        ],
      ),
    );
  }
}

class _DeleteDocumentButton extends StatelessWidget {
  final String documentId;
  const _DeleteDocumentButton({super.key, required this.documentId});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () {
        context.read<DocumentsBloc>().add(ClearDocument(id: documentId));
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete),
      label: Text(
        'document_details.delete_document_btn'.tr(),
        style: const TextStyle(fontSize: 16),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Color(0xFFF87171),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/widgets/document_actions_widget.dart';
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
      appBar: AppBar(title: Text("document_details.title".tr())),
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
          DocumentActions(document: document),
        ],
      ),
    );
  }
}

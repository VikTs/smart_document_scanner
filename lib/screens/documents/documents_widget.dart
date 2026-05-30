import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/screens/documents/documents_empty_widget.dart';
import 'package:smart_documents_scanner/screens/documents/document_card_widget.dart';

class DocumentsWidget extends StatelessWidget {
  final List<DocumentData> documents;
  final String? title;
  final GestureTapCallback? onViewAllTap;
  final bool shrinkWrap;
  final void Function(DocumentData) onDocumentCreated;

  const DocumentsWidget({
    super.key,
    required this.documents,
    this.title,
    this.onViewAllTap,
    this.shrinkWrap = false,
    required this.onDocumentCreated,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (documents.isEmpty) {
      return DocumentsEmptyWidget(
        onDocumentCreated: onDocumentCreated,
      );
    }

    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: documents.length + (title != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (title != null && index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(title!, style: textTheme.titleMedium),
                const Spacer(),
                if (onViewAllTap != null)
                  GestureDetector(
                    onTap: onViewAllTap,
                    child: Text(
                      "home.view_all_btn".tr(),
                      style: textTheme.labelMedium,
                    ),
                  ),
              ],
            ),
          );
        }

        final docIndex = title != null ? index - 1 : index;
        final document = documents[docIndex];

        return DocumentCardWidget(document: document);
      },
    );
  }
}

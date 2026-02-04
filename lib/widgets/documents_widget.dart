import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/widgets/document_card_widget.dart';
import 'package:smart_documents_scanner/widgets/empty_widget.dart';

class DocumentsWidget extends StatelessWidget {
  final List<Document> documents;
  final String? title;
  final GestureTapCallback? onViewAllTap;
  final bool shrinkWrap;

  const DocumentsWidget({
    super.key,
    required this.documents,
    this.title,
    this.onViewAllTap,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (documents.isEmpty) {
      return const DocumentsEmptyWidget();
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
                Spacer(),
                if (onViewAllTap != null)
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: onViewAllTap,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 4, 0, 4),
                      child: Text(
                        "home.view_all_btn".tr(),
                        style: textTheme.labelMedium,
                      ),
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

class DocumentsEmptyWidget extends StatelessWidget {
  const DocumentsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        imagePath: 'assets/images/documents.png',
        title: "documents.empty.title".tr(),
      ),
    );
  }
}

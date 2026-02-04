import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentsAmountWidget extends StatelessWidget {
  final List<Document> documents;
  const DocumentsAmountWidget({super.key, required this.documents});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorSchemeTheme = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorSchemeTheme.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.document_scanner_outlined,
                  color: colorSchemeTheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "home.scanned_documents_amount_title".tr(),
                style: textTheme.bodyMedium,
              ),

              const Spacer(),

              Text("${documents.length}", style: textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }
}

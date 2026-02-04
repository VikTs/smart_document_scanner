import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/screens/document_view_screen.dart';

class DocumentPreviewCard extends StatelessWidget {
  final Document document;

  const DocumentPreviewCard({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(
                document.file,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DocumentViewScreen(
                        imageBytes: document.file,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text("document_details.view_document_btn".tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

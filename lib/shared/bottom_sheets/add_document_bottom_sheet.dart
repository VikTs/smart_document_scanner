import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showAddDocumentBottomSheet({
  required BuildContext context,
  required Future<void> Function() onScan,
  required Future<void> Function() onUpload,
}) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.document_scanner),
              title: Text("home.scan_document_btn".tr()),
              onTap: () async {
                Navigator.pop(context);
                await onScan();
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload_file),
              title: Text("home.upload_file_btn".tr()),
              onTap: () async {
                Navigator.pop(context);
                await onUpload();
              },
            ),
          ],
        ),
      );
    },
  );
}
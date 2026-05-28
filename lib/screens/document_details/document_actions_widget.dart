import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentActions extends StatelessWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(List<DocumentFile>) onShare;
  final VoidCallback onRecognize;

  const DocumentActions({
    required this.document,
    required this.onDelete,
    required this.onShare,
    required this.onRecognize,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (isImage(document.files[0].extension))
              Expanded(
                child: _ActionItem(
                  icon: Icons.share_outlined,
                  label: "document_details.share_document_btn".tr(),
                  color: color,
                  onTap: () => onShare(document.files),
                ),
              ),
            const SizedBox(width: 12),
            if (isImage(document.files[0].extension))
              Expanded(
                child: _ActionItem(
                  icon: Icons.text_snippet_outlined,
                  label: "document_details.recognize_document_btn".tr(),
                  color: color,
                  onTap: onRecognize,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionItem(
                icon: Icons.delete_outline,
                label: "document_details.delete_document_btn".tr(),
                color: color,
                onTap: () => onDelete(context, document.id),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

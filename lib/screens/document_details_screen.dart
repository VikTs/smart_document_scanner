import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/core/utils/document_file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(Uint8List) onShare;

  const DocumentDetailsScreen({
    super.key,
    required this.document,
    required this.onDelete,
    required this.onShare,
  });

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<DocumentFile> documentFiles = widget.document.files;

    return Scaffold(
      appBar: AppBar(title: Text(widget.document.name), leading: BackButton()),
      body: documentFiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: documentFiles.length,
                    onPageChanged: (i) {
                      setState(() {
                        currentIndex = i;
                      });
                    },
                    itemBuilder: (_, index) {
                      final file = documentFiles[index];
                      return InteractiveViewer(
                        child: Image.memory(file.bytes, fit: BoxFit.contain),
                      );
                    },
                  ),
                ),
                _FilesThumbnails(
                  files: documentFiles,
                  currentIndex: currentIndex,
                  onTap: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
      bottomNavigationBar: _DocumentActions(
        document: widget.document,
        onDelete: widget.onDelete,
        onShare: widget.onShare,
      ),
    );
  }
}

class _FilesThumbnails extends StatelessWidget {
  final List<DocumentFile> files;
  final int currentIndex;
  final Function(int) onTap;

  const _FilesThumbnails({
    required this.files,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        scrollDirection: Axis.horizontal,
        itemCount: files.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          if (index == files.length) return SizedBox();

          final selected = index == currentIndex;
          final file = files[index];

          return GestureDetector(
            onTap: () => onTap(index),
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade300,
                  width: selected ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child:
                  file.type ==
                      0 // IMAGE
                  ? Image.memory(file.bytes, fit: BoxFit.cover)
                  : Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Text(
                          file.pageNumber != null
                              ? 'Page ${file.pageNumber}'
                              : 'PDF',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _DocumentActions extends StatelessWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(Uint8List) onShare;

  const _DocumentActions({
    required this.document,
    required this.onDelete,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.secondary;
    final files = pagesToPdf(document.files);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: _ActionItem(
                icon: Icons.share_outlined,
                label: "document_details.share_document_btn".tr(),
                color: color,
                onTap: () => onShare(files),
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

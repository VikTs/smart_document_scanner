import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/data/db/converters/document_file_type_converter.dart';

class DocumentDetailsScreen extends StatefulWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(List<DocumentFile>) onShare;

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
  final ScrollController _scrollController = ScrollController();
  int currentIndex = 0;
  double pageHeight = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    pageHeight = MediaQuery.of(context).size.height * 0.7;
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateCurrentPage);
  }

  void _updateCurrentPage() {
    if (!mounted) return;
    final index = (_scrollController.offset / pageHeight).floor();
    final newIndex = index.clamp(0, widget.document.files.length - 1);
    if (newIndex != currentIndex) {
      setState(() {
        currentIndex = newIndex;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final documentFiles = widget.document.files;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
        leading: const BackButton(),
      ),
      body: documentFiles.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                ListView.builder(
                  controller: _scrollController,
                  itemCount: documentFiles.length,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemBuilder: (_, index) {
                    final file = documentFiles[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: SizedBox(
                        height: pageHeight,
                        child: Image.memory(file.bytes, fit: BoxFit.contain),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${currentIndex + 1}/${documentFiles.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
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

class _DocumentActions extends StatelessWidget {
  final DocumentData document;
  final void Function(BuildContext, String) onDelete;
  final void Function(List<DocumentFile>) onShare;

  const _DocumentActions({
    required this.document,
    required this.onDelete,
    required this.onShare,
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
            if (document.files[0].type == DocumentFileType.image)
              Expanded(
                child: _ActionItem(
                  icon: Icons.share_outlined,
                  label: "document_details.share_document_btn".tr(),
                  color: color,
                  onTap: () => {onShare(document.files)},
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

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum DocumentsSort { newestFirst, oldestFirst }

class SortButton extends StatelessWidget {
  final DocumentsSort sort;
  final ValueChanged<DocumentsSort> onChanged;

  const SortButton(this.sort, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _openSortSheet(context),
      child: Container(
        height: 40,
        width: 40,
        alignment: Alignment.center,
        child: const Icon(Icons.tune_rounded, size: 20),
      ),
    );
  }

  void _openSortSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => _SortSheet(sort: sort, onChanged: onChanged),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final DocumentsSort sort;
  final ValueChanged<DocumentsSort> onChanged;

  const _SortSheet({required this.sort, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tile(context, "documents.sort.newest_first".tr(), DocumentsSort.newestFirst),
            _tile(context, "documents.sort.oldest_first".tr(), DocumentsSort.oldestFirst),
          ],
        ),
      ),
    );
  }

  Widget _tile(BuildContext context, String title, DocumentsSort value) {
    final theme = Theme.of(context);
    return RadioListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      title: Text(title, style: theme.textTheme.labelLarge),
      value: value,
      groupValue: sort,
      onChanged: (v) {
        onChanged(v!);
        Navigator.pop(context);
      },
    );
  }
}

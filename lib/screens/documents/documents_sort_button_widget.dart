import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

enum DocumentSortType { az, za, newOld, oldNew }

class DocumentsSortButton extends StatelessWidget {
  final DocumentSortType sortType;
  final ValueChanged<DocumentSortType> onSelected;

  const DocumentsSortButton({
    super.key,
    required this.sortType,
    required this.onSelected,
  });

  PopupMenuItem<DocumentSortType> _buildSortItem({
    required DocumentSortType value,
    required String label,
  }) {
    final isSelected = sortType == value;

    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: isSelected
                ? const Icon(Icons.check, size: 18)
                : const SizedBox(),
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DocumentSortType>(
      icon: const Icon(Icons.sort),
      onSelected: onSelected,
      itemBuilder: (context) => [
        _buildSortItem(
          value: DocumentSortType.newOld,
          label: "documents.sort.newOld".tr(),
        ),
        _buildSortItem(
          value: DocumentSortType.oldNew,
          label: "documents.sort.oldNew".tr(),
        ),
        _buildSortItem(
          value: DocumentSortType.az,
          label: "documents.sort.az".tr(),
        ),
        _buildSortItem(
          value: DocumentSortType.za,
          label: "documents.sort.za".tr(),
        ),
      ],
    );
  }
}

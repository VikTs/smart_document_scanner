import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/models/document_type.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/widgets/documents_sort_button.dart';
import 'package:smart_documents_scanner/widgets/documents_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  DocumentType? _selectedType;
  DocumentsSort _sort = DocumentsSort.newestFirst;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("appBar.documents".tr())),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TypeDropdown(
                  _selectedType,
                  (t) => setState(() => _selectedType = t),
                ),
                SortButton(_sort, (s) => setState(() => _sort = s)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: _DocumentsList(type: _selectedType, sort: _sort),
          ),
        ],
      ),
    );
  }
}

class _DocumentsList extends StatelessWidget {
  final DocumentType? type;
  final DocumentsSort sort;

  const _DocumentsList({required this.type, required this.sort});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentsBloc, DocumentsState>(
      builder: (context, state) {
        if (state is DocumentsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is DocumentsEmpty) {
          return const DocumentsEmptyWidget();
        }

        if (state is DocumentsLoaded) {
          var docs = state.documents;

          if (type != null) {
            docs = docs.where((d) => d.type == type).toList();
          }

          docs.sort(
            (a, b) => sort == DocumentsSort.newestFirst
                ? b.createdAt.compareTo(a.createdAt)
                : a.createdAt.compareTo(b.createdAt),
          );

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: DocumentsWidget(documents: docs),
          );
        }

        if (state is DocumentsError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox();
      },
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  final DocumentType? value;
  final ValueChanged<DocumentType?> onChanged;

  const _TypeDropdown(this.value, this.onChanged);

  String _title(DocumentType? type) {
    if (type == null) return "documents.filter.all".tr();
    return "document_types.${type.name}".tr();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DocumentType?>(
          value: value,
          isDense: true,
          dropdownColor: theme.colorScheme.surface,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),

          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.onSurface,
          ),

          items: [
            DropdownMenuItem(
              value: null,
              child: Text("documents.filter.all".tr()),
            ),
            ...DocumentType.values.map(
              (t) => DropdownMenuItem(value: t, child: Text(_title(t))),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

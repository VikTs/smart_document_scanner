import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_documents_scanner/models/document_type.dart';

import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/widgets/documents_widget.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorSchemeTheme = theme.colorScheme;
    final tabs = ['All', 'Receipts', 'Identities'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "appBar.documents".tr(),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          SizedBox(
            height: 48,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ToggleButtons(
                borderRadius: BorderRadius.circular(20),
                isSelected: List.generate(
                  tabs.length,
                  (index) => index == _selectedIndex,
                ),
                onPressed: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedColor: colorSchemeTheme.onPrimary,
                fillColor: colorSchemeTheme.primary,
                color: colorSchemeTheme.primary,
                constraints: const BoxConstraints(minWidth: 100, minHeight: 40),
                children: tabs.map((tab) => Text(tab.tr())).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<DocumentsBloc, DocumentsState>(
              builder: (context, state) {
                if (state is DocumentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DocumentsEmpty) {
                  return const DocumentsEmptyWidget();
                }

                if (state is DocumentsLoaded) {
                  final filteredDocuments = [
                    state.documents,
                    state.documents
                        .where((d) => d.type == DocumentType.receipt)
                        .toList(),
                    state.documents
                        .where((d) => d.type == DocumentType.idDocument)
                        .toList(),
                  ];

                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: filteredDocuments
                          .map((docs) => DocumentsWidget(documents: docs))
                          .toList(),
                    ),
                  );
                }

                if (state is DocumentsError) {
                  return Center(child: Text(state.message));
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';
import 'package:smart_documents_scanner/core/ui/app_snackbar.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/data/db/app_database.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/scan_camera_screen.dart';
import 'package:smart_documents_scanner/widgets/documents_amount_widget.dart';
import 'package:smart_documents_scanner/widgets/documents_widget.dart';
import 'package:smart_documents_scanner/widgets/empty_widget.dart';
import 'package:smart_documents_scanner/widgets/tab_bar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("appBar.home".tr(), style: const TextStyle(fontSize: 18)),
      ),
      body: BlocBuilder<DocumentsBloc, DocumentsState>(
        builder: (context, state) {
          if (state is DocumentsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DocumentsEmpty) {
            return const HomeEmptyWidget();
          }

          if (state is DocumentsLoaded) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    DocumentsAmountWidget(documents: state.documents),
                    const SizedBox(height: 12),
                    DocumentsWidget(
                      documents: state.documents.take(4).toList(),
                      title: "home.documents_title".tr(),
                      onViewAllTap: () {
                        TabBarWidget.of(context)?.goToTab(1);
                      },
                      shrinkWrap: true,
                    ),
                    const SizedBox(height: 12),
                    const _AddDocumentButton(),
                  ],
                ),
              ),
            );
          }

          if (state is DocumentsError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class HomeEmptyWidget extends StatelessWidget {
  const HomeEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        imagePath: 'assets/images/document_scanner.png',
        title: "home.empty.title".tr(),
        message: "home.empty.message".tr(),
        footer: const _AddDocumentButton(),
      ),
    );
  }
}

class _AddDocumentButton extends StatelessWidget {
  const _AddDocumentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => _showAddOptions(context),
      icon: const Icon(Icons.add),
      label: Text('home.add_document_btn'.tr(), style: TextStyle(fontSize: 16)),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _AddOptionTile(
                  icon: Icons.document_scanner,
                  title: "Scan document",
                  onTap: () {
                    Navigator.pop(context);
                    _scanDocument(context);
                  },
                ),
                _AddOptionTile(
                  icon: Icons.upload_file,
                  title: "Upload file",
                  onTap: () {
                    Navigator.pop(context);
                    _uploadFile(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _scanDocument(BuildContext context) async {
    final imagePath = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
    );

    if (imagePath == null) return;
    final file = await imageToBytes(imagePath);
    final recognizedText = await recognizeText(imagePath);

    final document = Document(
      id: const Uuid().v1(),
      createdAt: DateTime.now(),
      file: file,
      name: "DocScanner.jpg",
    );

    if (recognizedText.blocks.isEmpty) {
      AppSnackbar.warning(context, "home.document_recognision_error".tr());
    }

    context.read<DocumentsBloc>().add(SaveScannedDocument(document: document));
  }

  Future<void> _uploadFile(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      withData: true,
    );

    if (result == null) return;

    final bytes = result.files.single.bytes;
    if (bytes == null) return;

    final document = Document(
      id: const Uuid().v1(),
      createdAt: DateTime.now(),
      file: bytes,
      name: result.names[0] ?? "DocScanner",
    );

    context.read<DocumentsBloc>().add(SaveScannedDocument(document: document));
  }
}

class _AddOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _AddOptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}

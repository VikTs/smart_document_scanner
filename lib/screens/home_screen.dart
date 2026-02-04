import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:smart_documents_scanner/core/platform/text_recognizion.dart';
import 'package:smart_documents_scanner/core/ui/app_snackbar.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_bloc.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_event.dart';
import 'package:smart_documents_scanner/presentation/bloc/documents_state.dart';
import 'package:smart_documents_scanner/screens/scan_camera_screen.dart';
import 'package:smart_documents_scanner/widgets/documents_amount_widget.dart';
import 'package:smart_documents_scanner/widgets/documents_widget.dart';
import 'package:smart_documents_scanner/widgets/empty_widget.dart';

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
              padding: const EdgeInsets.all(16),
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
                      shrinkWrap: true,
                    ),
                    const SizedBox(height: 12),
                    const _ScanDocumentButton(),
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
        footer: const _ScanDocumentButton(),
      ),
    );
  }
}

class _ScanDocumentButton extends StatelessWidget {
  const _ScanDocumentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: () async {
        final imagePath = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (_) => const ScanCameraScreen()),
        );

        if (imagePath != null) {
          final file = await imageToBytes(imagePath);
          final text = await recognizeText(imagePath);

          if (text.blocks.isEmpty) {
            AppSnackbar.warning(
              context,
              "home.document_recognision_error".tr(),
            );
          }

          context.read<DocumentsBloc>().add(
            SaveScannedDocument(recognizedText: text, file: file),
          );
        }
      },
      icon: const Icon(Icons.document_scanner),
      label: Text(
        'home.scan_document_btn'.tr(),
        style: const TextStyle(fontSize: 16),
      ),
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}

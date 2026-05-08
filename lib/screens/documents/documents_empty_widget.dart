import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/screens/home/add_document_button_widget.dart';
import 'package:smart_documents_scanner/shared/empty_widget.dart';

class DocumentsEmptyWidget extends StatelessWidget {
  const DocumentsEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        imagePath: 'assets/images/documents.png',
        title: "documents.empty.title".tr(),
        message: "documents.empty.message".tr(),
        footer: const AddDocumentButton(),
      ),
    );
  }
}
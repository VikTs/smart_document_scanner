import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/document.dart';
import 'package:smart_documents_scanner/screens/home/add_document_button_widget.dart';
import 'package:smart_documents_scanner/shared/empty_widget.dart';

class HomeEmptyWidget extends StatelessWidget {
  final void Function(DocumentData document) onDocumentCreated;
  const HomeEmptyWidget({super.key, required this.onDocumentCreated});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EmptyWidget(
        imagePath: 'assets/images/document_scanner.png',
        title: "home.empty.title".tr(),
        message: "home.empty.message".tr(),
        footer: AddDocumentButton(onDocumentCreated: onDocumentCreated),
      ),
    );
  }
}
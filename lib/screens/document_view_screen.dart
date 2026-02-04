import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class DocumentViewScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const DocumentViewScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("document_view.title".tr())),
      body: Container(
        color: const Color(0xFF1E1E1E),
        child: Center(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 1,
            maxScale: 5,
            child: Image.memory(
              imageBytes,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

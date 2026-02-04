import 'dart:typed_data';
import 'package:flutter/material.dart';

class DocumentViewScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final String title;

  const DocumentViewScreen({
    super.key,
    required this.imageBytes,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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

import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

import 'package:smart_documents_scanner/core/models/recognized_text.dart';

class TextRecognisionService {
  static Future<RecognizedText> recognize({
    Uint8List? bytes,
    String? imagePath,
  }) async {
    if (bytes == null && imagePath == null) {
      throw ArgumentError('Either bytes or imagePath must be provided');
    }

    late final InputImage inputImage;

    if (imagePath != null) {
      inputImage = InputImage.fromFile(File(imagePath));
    } else {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ocr_temp.png');
      await file.writeAsBytes(bytes!);
      inputImage = InputImage.fromFilePath(file.path);
    }

    final recognizer = TextRecognizer();
    final recognizedText = await recognizer.processImage(inputImage);
    await recognizer.close();

    return recognizedText;
  }

  static Future<List<RecognizedTextBox>> generateRecognizedTextBoxes(
    Uint8List bytes,
  ) async {
    final result = await TextRecognisionService.recognize(bytes: bytes);

    return result.blocks
        .expand((b) => b.lines)
        .map((l) => RecognizedTextBox(text: l.text, rect: l.boundingBox))
        .toList();
  }

  static ({double scale, double offsetX, double offsetY})
  calculateImageTransform({required Size imageSize, required Size widgetSize}) {
    final imageAspectRatio = imageSize.width / imageSize.height;
    final widgetAspectRatio = widgetSize.width / widgetSize.height;

    final scale = imageAspectRatio > widgetAspectRatio
        ? widgetSize.width / imageSize.width
        : widgetSize.height / imageSize.height;

    return (
      scale: scale,
      offsetX: (widgetSize.width - imageSize.width * scale) / 2,
      offsetY: (widgetSize.height - imageSize.height * scale) / 2,
    );
  }
}

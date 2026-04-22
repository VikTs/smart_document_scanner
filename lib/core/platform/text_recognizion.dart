import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';

Future<RecognizedText> recognizeText({
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

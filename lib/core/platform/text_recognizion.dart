import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<RecognizedText> recognizeText(String imagePath) async {
  final inputImage = InputImage.fromFile(File(imagePath));

  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  final RecognizedText recognizedText = await textRecognizer.processImage(
    inputImage,
  );

  await textRecognizer.close();

  return recognizedText;
}

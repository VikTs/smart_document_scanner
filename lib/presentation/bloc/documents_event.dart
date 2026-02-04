import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

abstract class DocumentsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDocuments extends DocumentsEvent {}

class ClearDocuments extends DocumentsEvent {}

class ClearDocument extends DocumentsEvent {
  final String id;

  ClearDocument({required this.id});
}

class SaveScannedDocument extends DocumentsEvent {
  final RecognizedText recognizedText;
  final Uint8List file;

  SaveScannedDocument({required this.recognizedText, required this.file});
}

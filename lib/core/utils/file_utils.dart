import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Future<Uint8List> imageToBytes(String imagePath) async {
  final file = File(imagePath);
  return await file.readAsBytes();
}

Future<void> shareFile(
  Uint8List documentBytes,
  String extension, {
  String fileName = "Shared_document",
}) async {
  final dir = await getTemporaryDirectory();
  final tempFile = File('${dir.path}/$fileName.$extension');
  await tempFile.writeAsBytes(documentBytes);
  await Share.shareXFiles([XFile(tempFile.path)]);
}

Future<FilePickerResult?> uploadFile() async {
  return await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    withData: true,
  );
}

Future<Size> loadImageSize(Uint8List bytes) async {
  Size size;

  try {
    final codec = await ui.instantiateImageCodec(bytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    size = Size(image.width.toDouble(), image.height.toDouble());
  } catch (e) {
    debugPrint("Image decode error: $e");
    size = const Size(1000, 1000);
  }

  return size;
}

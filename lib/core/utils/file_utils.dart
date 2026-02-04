import 'dart:io';
import 'dart:typed_data';

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

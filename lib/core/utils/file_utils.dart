import 'dart:io';
import 'dart:typed_data';

Future<Uint8List> imageToBytes(String imagePath) async {
  final file = File(imagePath);
  return await file.readAsBytes();
}

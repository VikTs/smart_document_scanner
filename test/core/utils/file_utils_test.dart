import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/utils/file_utils.dart';

void main() {
  test('imageToBytes returns bytes from file', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final file = File('${tempDir.path}/test_image.bin');

    final expectedBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
    await file.writeAsBytes(expectedBytes);

    final result = await imageToBytes(file.path);

    expect(result, expectedBytes);

    await tempDir.delete(recursive: true);
  });

  test('imageToBytes throws if file does not exist', () async {
    final path = '/non/existing/file.png';

    expect(
      () => imageToBytes(path),
      throwsA(isA<FileSystemException>()),
    );
  });
}

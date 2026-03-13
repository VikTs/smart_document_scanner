
import 'dart:typed_data';

import 'package:pdfx/pdfx.dart';
import 'package:smart_documents_scanner/core/models/document_file.dart';

Future<List<DocumentFile>> pdfToPages(Uint8List data) async {
  final pdfDoc = await PdfDocument.openData(data);
  final pages = <DocumentFile>[];

  for (var i = 1; i <= pdfDoc.pagesCount; i++) {
    final page = await pdfDoc.getPage(i);

    final pageImage = await page.render(
      width: page.width,
      height: page.height,
      format: PdfPageImageFormat.png,
    );

    final bytes = pageImage?.bytes;

    if (bytes != null) {
      pages.add(
        DocumentFile(
          bytes: bytes,
          name: 'page_$i.png',
          type: DocumentFileType.pdf,
          pageNumber: i,
        ),
      );
    }

    await page.close();
  }

  await pdfDoc.close();
  return pages;
}

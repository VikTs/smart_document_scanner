import 'dart:typed_data';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:smart_documents_scanner/data/db/converters/document_file_extension_converter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sfpdf;
import 'package:uuid/uuid.dart';

import 'package:smart_documents_scanner/data/db/app_database.dart';

Uint8List pagesToPdf(List<DocumentFile> pages) {
  final outputPdf = sfpdf.PdfDocument();

  for (final page in pages) {
    final pdfPage = outputPdf.pages.add();

    final image = sfpdf.PdfBitmap(page.bytes);
    pdfPage.graphics.drawImage(
      image,
      Rect.fromLTWH(0, 0, pdfPage.size.width, pdfPage.size.height),
    );
  }

  final bytes = outputPdf.saveSync();
  outputPdf.dispose();
  return Uint8List.fromList(bytes);
}

Future<List<DocumentFile>> pdfToPages(String documentId, Uint8List data) async {
  final pdfDoc = await pdfx.PdfDocument.openData(data);
  if (pdfDoc.pagesCount > 5) {
    throw Exception("home.document_max_size_error".tr());
  }
  final pages = <DocumentFile>[];

  for (var i = 1; i <= pdfDoc.pagesCount; i++) {
    final page = await pdfDoc.getPage(i);

    final pageImage = await page.render(
      width: page.width,
      height: page.height,
      format: pdfx.PdfPageImageFormat.png,
    );

    final bytes = pageImage?.bytes;
    if (bytes != null) {
      pages.add(
        DocumentFile(
          id: const Uuid().v1(),
          documentId: documentId,
          bytes: bytes,
          extension: DocumentFileExtension.pdf,
          pageNumber: i,
        ),
      );
    }

    await page.close();
  }

  await pdfDoc.close();
  return pages;
}

bool isImage(DocumentFileExtension extension) {
  const imageExtensions = [
    DocumentFileExtension.jpg,
    DocumentFileExtension.jpeg,
    DocumentFileExtension.png,
  ];

  return imageExtensions.contains(extension);
}

String getFileNameWithoutExtension(String? name) {
  if (name == null) return "";

  return name.contains('.') ? name.substring(0, name.lastIndexOf('.')) : name;
}

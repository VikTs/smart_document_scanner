import 'package:smart_documents_scanner/models/document_type.dart';

bool isReceipt(List<String> lines) {
  return lines.any((l) => l.toUpperCase().contains('TOTAL'));
}

bool isIdDocument(List<String> lines) {
  return lines.any((l) => l.toUpperCase().contains('DATE OF BIRTH')) &&
      lines.length < 40;
}

DocumentType classifyDocument(List<String> lines) {
  if (isReceipt(lines)) return DocumentType.receipt;
  if (isIdDocument(lines)) return DocumentType.idDocument;

  return DocumentType.unknown;
}

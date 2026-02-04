import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/extractors/extractors.dart';
import 'package:smart_documents_scanner/models/document_type.dart';

void main() {
  group('Document classification', () {
    test('Should classify receipt when TOTAL is present', () {
      final lines = [
        'Supermarket XYZ',
        'Milk 2.50',
        'Bread 1.20',
        'TOTAL 3.70',
      ];

      final result = classifyDocument(lines);

      expect(result, DocumentType.receipt);
    });

    test('Should classify ID document when DATE OF BIRTH is present and lines < 40', () {
      final lines = [
        'Name: John Doe',
        'Date of Birth: 01/01/1990',
        'Nationality: IT',
      ];

      final result = classifyDocument(lines);

      expect(result, DocumentType.idDocument);
    });

    test('Should return unknown when no rules match', () {
      final lines = [
        'Random text',
        'Some notes',
        'Nothing useful here',
      ];

      final result = classifyDocument(lines);

      expect(result, DocumentType.unknown);
    });

    test('Should not classify ID document if too many lines', () {
      final lines = List.generate(
        50,
        (index) => index == 10 ? 'DATE OF BIRTH: 01/01/1990' : 'Line $index',
      );

      final result = classifyDocument(lines);

      expect(result, DocumentType.unknown);
    });

    test('Receipt has priority over ID document', () {
      final lines = [
        'Name: John Doe',
        'Date of Birth: 01/01/1990',
        'TOTAL 100.00',
      ];

      final result = classifyDocument(lines);

      expect(result, DocumentType.receipt);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/extractors/date_extractor.dart';

void main() {
  group('extractDates', () {
    test('parses numeric dates with different separators', () {
      final result = extractDates([
        'Date of birth: 12/05/1992',
        'Issued on 1992-05-12',
        'Valid until 12.05.1992',
      ]);

      expect(result, [
        DateTime(1992, 5, 12),
        DateTime(1992, 5, 12),
        DateTime(1992, 5, 12),
      ]);
    });

    test('parses dates with month names (day first)', () {
      final result = extractDates([
        'Issued: 25 Jan 2020',
      ]);

      expect(result, [
        DateTime(2020, 1, 25),
      ]);
    });

    test('parses dates with spaces as separators', () {
      final result = extractDates([
        'DOB 05 01 1990',
      ]);

      expect(result, [
        DateTime(1990, 1, 5),
      ]);
    });

    test('sorts extracted dates chronologically', () {
      final result = extractDates([
        'Expires: 2025-01-01',
        'Issued: 2020-01-01',
        'DOB: 1990-01-01',
      ]);

      expect(result, [
        DateTime(1990, 1, 1),
        DateTime(2020, 1, 1),
        DateTime(2025, 1, 1),
      ]);
    });

    test('ignores lines without valid dates', () {
      final result = extractDates([
        'Random text',
        'Passport number AB123456',
        'No date here',
      ]);

      expect(result, isEmpty);
    });
  });
}

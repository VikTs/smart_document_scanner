import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/extractors/extractors.dart';

void main() {
  group('extractPlaceType', () {
    test('Should extract restaurant', () {
      final lines = [
        'Welcome to our RESTAURANT',
        'Open daily',
      ];

      final result = extractPlaceType(lines);

      expect(result, 'restaurant');
    });

    test('Should extract cafe', () {
      final lines = [
        'Best Cafe in town',
        'Coffee & desserts',
      ];

      final result = extractPlaceType(lines);

      expect(result, 'cafe');
    });

    test('Should be case-insensitive', () {
      final lines = [
        'Modern HoTeL in city center',
      ];

      final result = extractPlaceType(lines);

      expect(result, 'hotel');
    });

    test('Should respect word boundaries', () {
      final lines = [
        'Marketplace for local farmers',
        'Great prices',
      ];

      final result = extractPlaceType(lines);

      expect(result, isNull);
    });

    test('Should extract first matched place type', () {
      final lines = [
        'Bar & Restaurant',
      ];

      final result = extractPlaceType(lines);

      expect(result, 'restaurant');
    });

    test('Should return null if no place type found', () {
      final lines = [
        'Invoice #12345',
        'Thank you for your purchase',
      ];

      final result = extractPlaceType(lines);

      expect(result, isNull);
    });

    test('Should match place type in middle of sentence', () {
      final lines = [
        'Thank you for visiting our cozy pub today',
      ];

      final result = extractPlaceType(lines);

      expect(result, 'pub');
    });
  });
}

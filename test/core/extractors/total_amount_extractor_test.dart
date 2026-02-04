import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/extractors/extractors.dart';

void main() {
  group('extractTotalAmount', () {
    test('Should extract total amount when TOTAL is present', () {
      final lines = [
        'Milk 2.50',
        'Bread 1.20',
        'TOTAL 3.70',
      ];

      final result = extractTotalAmount(lines);

      expect(result, 3.70);
    });

    test('Should ignore SUBTOTAL and TAX', () {
      final lines = [
        'SUBTOTAL 10.00',
        'TAX 2.00',
        'TOTAL 12.00',
      ];

      final result = extractTotalAmount(lines);

      expect(result, 12.00);
    });

    test('Should return max value among TOTAL candidates', () {
      final lines = [
        'TOTAL 15.00',
        'TOTAL 20.00',
      ];

      final result = extractTotalAmount(lines);

      expect(result, 20.00);
    });

    test('Should fallback to max number if TOTAL is missing', () {
      final lines = [
        'Item A 5.00',
        'Item B 7.50',
        'Item C 6.00',
      ];

      final result = extractTotalAmount(lines);

      expect(result, 7.50);
    });

    test('Should return null if no numbers found', () {
      final lines = [
        'Thank you for your visit',
        'See you again',
      ];

      final result = extractTotalAmount(lines);

      expect(result, isNull);
    });

    test('Should handle multiple numbers in one line', () {
      final lines = [
        'TOTAL 9.99 10.50',
      ];

      final result = extractTotalAmount(lines);

      expect(result, 10.50);
    });
  });

  group('extractCurrency', () {
    test('Should extract currency symbol', () {
      final lines = [
        'TOTAL 10.00 €',
      ];

      final result = extractCurrency(lines);

      expect(result, '€');
    });

    test('Should extract currency code', () {
      final lines = [
        'Total amount: 15.00 USD',
      ];

      final result = extractCurrency(lines);

      expect(result, 'USD');
    });

    test('Should be case-insensitive', () {
      final lines = [
        'total: 20.00 eur',
      ];

      final result = extractCurrency(lines);

      expect(result, 'eur');
    });

    test('Should return first matched currency', () {
      final lines = [
        'Prices in USD',
        'TOTAL 10.00 €',
      ];

      final result = extractCurrency(lines);

      expect(result, 'USD');
    });

    test('Should return null if currency not found', () {
      final lines = [
        'TOTAL 10.00',
      ];

      final result = extractCurrency(lines);

      expect(result, isNull);
    });
  });
}

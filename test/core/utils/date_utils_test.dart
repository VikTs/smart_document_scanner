import 'package:flutter_test/flutter_test.dart';
import 'package:smart_documents_scanner/core/utils/date_utils.dart';

void main() {
  test('Formats date with default format', () {
    final date = DateTime(2026, 2, 4); 
    final result = formatDate(date);
    expect(result, '04 Feb 2026');
  });

  test('Formats date with custom format', () {
    final date = DateTime(2026, 2, 4);
    
    final result1 = formatDate(date, format: 'yyyy-MM-dd');
    expect(result1, '2026-02-04');

    final result2 = formatDate(date, format: 'MM/dd/yyyy');
    expect(result2, '02/04/2026');

    final result3 = formatDate(date, format: 'EEEE, MMMM d, yyyy');
    expect(result3, 'Wednesday, February 4, 2026');
  });

  test('Handles single-digit day and month correctly', () {
    final date = DateTime(2026, 1, 5);
    final result = formatDate(date);
    expect(result, '05 Jan 2026');
  });
}

double? extractTotalAmount(List<String> lines) {
  final List<double> candidateTotals = [];
  final List<double> allNumbers = [];
  final totalRegex = RegExp(r'\d+[.,]\d{2}');

  for (final line in lines) {
    final text = line.toUpperCase();

    final matches = totalRegex.allMatches(text);
    final numbers = matches
        .map((m) => double.tryParse(m.group(0)!))
        .whereType<double>()
        .toList();

    allNumbers.addAll(numbers);

    if (_looksLikeTotal(text)) {
      candidateTotals.addAll(numbers);
    }
  }

  if (candidateTotals.isNotEmpty) {
    return candidateTotals.reduce((a, b) => a > b ? a : b);
  }

  if (allNumbers.isNotEmpty) {
    return allNumbers.reduce((a, b) => a > b ? a : b);
  }

  return null;
}

bool _looksLikeTotal(String text) {
  return text.contains('TOTAL') &&
      !text.contains('SUBTOTAL') &&
      !text.contains('TAX');
}

String? extractCurrency(List<String> lines) {
  final currencyRegex = RegExp(
    r'(\$|€|£|¥|₴|CHF|USD|EUR|GBP|JPY)',
    caseSensitive: false,
  );

  for (final line in lines) {
    final match = currencyRegex.firstMatch(line);
    
    if (match != null) return match.group(0);
  }

  return null;
}

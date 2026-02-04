import 'package:easy_localization/easy_localization.dart';

final _dateRegex = RegExp(
  r'\b('
  r'\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4}|'
  r'\d{4}[\/\-\.]\d{1,2}[\/\-\.]\d{1,2}|'
  r'\d{1,2}\s+\d{1,2}\s+\d{2,4}|'
  r'\d{1,2}\s*(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s*\d{2,4}|'
  r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*\s*\d{1,2},?\s*\d{2,4}'
  r')\b',
  caseSensitive: false,
);

List<DateTime> extractDates(List<String> lines) {
  List<DateTime> parsedDates = [];

  for (final line in lines) {
    final match = _dateRegex.firstMatch(line);
    if (match != null) {
      final rawDate = match.group(0)!;
      final parsed = _tryParseDate(rawDate);

      if (parsed != null) parsedDates.add(parsed);
    }
  }

  return parsedDates..sort((a, b) => a.compareTo(b));
}

DateTime? _tryParseDate(String input) {
  input = input.replaceAll(RegExp(r"[,'`]"), '').trim();

  try {
    return DateTime.parse(_normalizeDate(input));
  } catch (_) {}

  for (final format in [
    'd MMM yyyy',
    'MMM d yyyy',
    'd-MM-yyyy',
    'yyyy-MM-dd',
    'd/M/yyyy',
    'yyyy/M/d',
  ]) {
    try {
      return DateFormat(format).parseStrict(input);
    } catch (_) {}
  }

  return null;
}

String _normalizeDate(String input) {
  input = input
      .replaceAll(RegExp(r"[,'`]"), '')
      .replaceAll('.', '-')
      .replaceAll('/', '-')
      .replaceAll(RegExp(r'\s+'), '-');

  final parts = input.split('-');

  if (parts.length == 3 && parts[0].length <= 2) {
    return '${parts[2]}-${parts[1]}-${parts[0]}';
  }

  return input;
}

DateTime? extractDocumentDate(List<String> lines) {
  final documentDates = extractDates(lines);
  if (documentDates.length == 1) {
    return documentDates[0];
  }
  return null;
}

// Id documents only
DateTime? extractExpirationDate(List<String> lines) {
  final documentDates = extractDates(lines);

  if (documentDates.length > 1) {
    return documentDates.last;
  }
  return null;
}

const _placeType = [
  "restaurant",
  "cafe",
  "hotel",
  "bar",
  "pub",
  "store",
  "market",
];

String? extractPlaceType(List<String> lines) {
  for (final line in lines) {
    final text = line.toLowerCase();

    for (final type in _placeType) {
      final regex = RegExp(
        r'\b' + RegExp.escape(type) + r'\b',
        caseSensitive: false,
      );
      if (regex.hasMatch(text)) {
        return type;
      }
    }
  }

  return null;
}

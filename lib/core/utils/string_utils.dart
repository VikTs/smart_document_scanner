extension StringUrl on String {
  bool isUrl() {
    final uri = Uri.tryParse(this);
    return uri != null &&
        (uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https'));
  }
}
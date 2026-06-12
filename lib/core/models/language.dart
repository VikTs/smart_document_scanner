import 'package:flutter/rendering.dart';

enum AppLanguage {
  en(Locale('en')),
  uk(Locale('uk'));

  const AppLanguage(this.code);

  final Locale code;
}

final supportedLocales = [
  AppLanguage.en,
  AppLanguage.uk,
].map((e) => e.code).toList();

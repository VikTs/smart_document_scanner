import 'package:flutter/rendering.dart';

enum AppLanguage {
  en(Locale('en')),
  uk(Locale('uk')),
  de(Locale('de')),
  es(Locale('es')),
  fr(Locale('fr')),
  it(Locale('it'));

  const AppLanguage(this.code);

  final Locale code;
}

final supportedLocales = [
  AppLanguage.en,
  AppLanguage.uk,
  AppLanguage.de,
  AppLanguage.es,
  AppLanguage.fr,
  AppLanguage.it,
].map((e) => e.code).toList();

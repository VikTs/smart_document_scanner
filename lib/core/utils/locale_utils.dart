import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/models/language.dart';
import 'package:smart_documents_scanner/data/services/sim_country_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

Future<Locale> resolveLocale(Locale locale) async {
  for (final supported in supportedLocales) {
    if (supported.languageCode == locale.languageCode) {
      return supported;
    }
  }

  final simCountry = await SimCountry.getCountry();

  if (locale.countryCode == 'UA' || simCountry == 'UA') {
    return AppLanguage.uk.code;
  }

  return AppLanguage.en.code;
}

Future<Locale> getStartLocale() async {
  final storage = AppStorage();
  final savedLang = await storage.getLanguage();

  if (savedLang != null) {
    return Locale(savedLang);
  }

  return resolveLocale(WidgetsBinding.instance.platformDispatcher.locale);
}

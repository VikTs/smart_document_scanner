import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/data/services/sim_country_service.dart';
import 'package:smart_documents_scanner/data/services/storage_service.dart';

const supportedLocales = [Locale('en'), Locale('uk')];

Future<Locale> resolveLocale(Locale locale) async {
  for (final supported in supportedLocales) {
    if (supported.languageCode == locale.languageCode) {
      return supported;
    }
  }

  final simCountry = await SimCountry.getCountry();

  if (locale.countryCode == 'UA' || simCountry == 'UA') {
    return const Locale('uk');
  }

  return const Locale('en');
}

Future<Locale> getStartLocale() async {
  final storage = AppStorage();
  final savedLang = await storage.getLanguage();

  if (savedLang != null) {
    return Locale(savedLang);
  }

  return resolveLocale(WidgetsBinding.instance.platformDispatcher.locale);
}

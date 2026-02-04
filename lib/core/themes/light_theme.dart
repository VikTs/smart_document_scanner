import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,

  colorScheme: const ColorScheme.light(
    primary: Color(0xFF2F6BFF),
    onPrimary: Colors.white,
    secondary: Color(0xFF22C55E),
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Color(0xFF111827),
    error: Color(0xFFF44336),
    onError: Colors.white,
  ),

  scaffoldBackgroundColor: const Color(0xFFF3F5FB),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF2563EB),
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 1,
    shadowColor: Colors.black.withOpacity(0.05),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF2563EB),
    foregroundColor: Colors.white,
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      color: Color(0xFF111827),
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      letterSpacing: 0.1,
      color: Color(0xFF111827),
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),
);

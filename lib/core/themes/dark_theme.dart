import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,

  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF3B82F6),
    onPrimary: Colors.white,
    secondary: Color(0xFF22C55E),
    onSecondary: Colors.black,
    surface: Color(0xFF1E293B),
    onSurface: Color(0xFFE5E7EB),
    error: Color(0xFFF87171),
    onError: Colors.black,
  ),

  scaffoldBackgroundColor: const Color(0xFF0F172A),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF0F172A),
    foregroundColor: Color(0xFFE5E7EB),
  ),

  cardTheme: CardThemeData(
    color: const Color(0xFF1E293B),
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF3B82F6),
    foregroundColor: Colors.white,
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFFE5E7EB),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFFCBD5E1),
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
  ),
);

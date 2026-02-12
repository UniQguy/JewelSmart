import 'package:flutter/material.dart';

class AppTheme {
  static const Color gold = Color(0xFFD4AF37);
  static const Color black = Colors.black;

  static ThemeData get luxuryTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Setting this to transparent allows the Stacked background image to shine through
      scaffoldBackgroundColor: Colors.transparent,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.dark,
        background: black,
      ),
      // Clean, minimal text field theme
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: gold),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
      ),
    );
  }
}
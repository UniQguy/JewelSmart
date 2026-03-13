import 'package:flutter/material.dart';

class AppTheme {
  static const Color gold = Color(0xFFD4AF37);
  static const Color black = Colors.black;

  static ThemeData get luxuryTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      // Transparent background allows the MainWrapper's spatial depth to remain visible
      scaffoldBackgroundColor: Colors.transparent,

      colorScheme: ColorScheme.fromSeed(
        seedColor: gold,
        brightness: Brightness.dark,
        surface: black, // Using 'surface' instead of 'background' for M3 compliance
      ),

      // Global Typography: Precision & Elegance
      fontFamily: 'Cinzel',
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: gold, fontSize: 32, fontWeight: FontWeight.w200, letterSpacing: 5),
        bodyLarge: TextStyle(color: Colors.white, fontSize: 14, letterSpacing: 1),
        labelSmall: TextStyle(color: Colors.white38, fontSize: 8, letterSpacing: 3, fontWeight: FontWeight.bold),
      ),

      // Sleek Input Fields for Auth and Search
      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: gold, fontSize: 12),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: gold, width: 0.8)),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
        contentPadding: EdgeInsets.symmetric(vertical: 20),
      ),

      // Custom Button Theme for Cinematic Interactions
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: gold,
          side: const BorderSide(color: gold, width: 0.5),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          textStyle: const TextStyle(fontSize: 10, letterSpacing: 4, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        ),
      ),
    );
  }
}
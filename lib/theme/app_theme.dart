import 'package:flutter/material.dart';

class AppTheme {
  // Your colour palette — tweak these to your taste
  static const Color background = Color(0xFF1C1A17);
  static const Color surface = Color(0xFF2A2520);
  static const Color primary = Color(0xFF8B7355);
  static const Color accent = Color(0xFF6B8F71);
  static const Color textPrimary = Color(0xFFF2EDE4);
  static const Color textSecondary = Color(0xFF9E9488);

  static ThemeData get darkTheme {
    return ThemeData(
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: accent,
        surface: surface,
      ),
      // hint: you'll want to set default text styles here too
    );
  }
}
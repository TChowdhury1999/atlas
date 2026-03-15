import 'package:flutter/material.dart';

class AppTheme {
  // Your colour palette — tweak these to your taste
  static const Color background = Color(0xFF1C1A17);
  static const Color surface = Color(0xFF2A2520);
  static const Color primary = Color(0xFF8B7355);
  static const Color accent = Color(0xFF6B8F71);
  static const Color textPrimary = Color(0xFFF2EDE4);
  static const Color textSecondary = Color(0xFF9E9488);

  static const List<Color> lineColors = [
    Color(0xFF8B7355), // warm tan (mirrors primary)
    Color(0xFF6B8F71), // sage green (mirrors accent)
    Color(0xFFB5804E), // terracotta orange
    Color(0xFF7A9BAE), // dusty blue
    Color(0xFFC4A882), // sand
    Color(0xFF9C6B4E), // burnt sienna
    Color(0xFF5C7A68), // deep moss
    Color(0xFFAA8C6F), // camel
    Color(0xFF8FA89C), // slate teal
    Color(0xFFD4B896), // linen
  ];

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
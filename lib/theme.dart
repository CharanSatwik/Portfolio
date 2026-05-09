import 'package:flutter/material.dart';

class EditorialTheme {
  static const Color parchment = Color(0xFFF8F3EB);
  static const Color charcoal = Color(0xFF1A1A1A);
  static const Color electricBlue = Color(0xFF2563EB);
  static const Color grey = Color(0xFF9CA3AF);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: parchment,
      colorScheme: ColorScheme.light(
        surface: parchment,
        onSurface: charcoal,
        primary: electricBlue,
        onPrimary: parchment,
        secondary: grey,
        outline: charcoal.withValues(alpha: 0.1),
      ),
      textTheme: const TextTheme(
        // Hero Headlines
        displayLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 84,
          fontWeight: FontWeight.bold,
          height: 0.95,
          letterSpacing: -2,
          color: charcoal,
        ),
        // Section titles & branding
        displayMedium: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.1,
          color: charcoal,
        ),
        // Body copy
        bodyLarge: TextStyle(
          fontFamily: 'Newsreader',
          fontSize: 20,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: charcoal,
        ),
        // Small labels / Nav
        labelLarge: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: charcoal,
        ),
        // Metadata / Tags
        labelSmall: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: charcoal,
        ),
      ),
    );
  }
}

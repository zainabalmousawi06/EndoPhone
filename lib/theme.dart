import 'package:flutter/material.dart';

class AppTheme {
  // Calming palette inspired by the current home screen: soft sage, ocean teal, blush, and cream.
  static const Color sageGreen = Color(0xFF90CDA8);
  static const Color meadowGreen = Color(0xFF749B7D);
  static const Color oceanTeal = Color(0xFF5F9EA0);
  static const Color mistTeal = Color(0xFFBFD9DE);
  static const Color blushPink = Color(0xFFEBB7CB);
  static const Color softCream = Color(0xFFF3F5EF);
  static const Color warmSand = Color(0xFFE6BA63);
  static const Color deepBrown = Color(0xFF8F6A58);
  static const Color skyBlue = Color(0xFFD7E4E5);

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: sageGreen,
      colorScheme: ColorScheme.fromSeed(
        seedColor: oceanTeal,
        brightness: Brightness.light,
        primary: oceanTeal,
        secondary: mistTeal,
        tertiary: blushPink,
        surface: softCream,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: softCream,
          fontFamily: 'LexendGiga',
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: softCream,
        foregroundColor: deepBrown,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: deepBrown,
          fontFamily: 'LexendGiga',
        ),
      ),
      cardTheme: CardThemeData(
        color: softCream,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: oceanTeal,
          foregroundColor: softCream,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            fontFamily: 'LexendGiga',
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFEA6B5C),
        foregroundColor: Colors.white,
      ),
      iconTheme: const IconThemeData(color: deepBrown),
    );

    return base.copyWith(
      scaffoldBackgroundColor: sageGreen,
      listTileTheme: base.listTileTheme.copyWith(iconColor: deepBrown),
      dividerColor: Colors.white.withValues(alpha: 0.2),
    );
  }
}

import 'package:flutter/material.dart';

class AppColors {
  static const cream = Color(0xFFF6F1E7);
  static const creamSoft = Color(0xFFFBF7EE);
  static const sage = Color(0xFF8FA68E);
  static const sageDark = Color(0xFF5F7A5E);
  static const terracotta = Color(0xFFC58A6A);
  static const ink = Color(0xFF2C2A26);
  static const inkSoft = Color(0xFF5C584F);
  static const line = Color(0xFFE3DCCC);
}

class AppTheme {
  static ThemeData light() {
    const seed = AppColors.sage;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: AppColors.cream,
      primary: AppColors.sageDark,
      secondary: AppColors.terracotta,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.cream,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: AppColors.creamSoft,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.sageDark,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.creamSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.sageDark, width: 1.5),
        ),
      ),
      textTheme: const TextTheme(
        displaySmall: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
        headlineMedium: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
        titleLarge: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: AppColors.ink),
        bodyMedium: TextStyle(color: AppColors.inkSoft),
      ),
    );
  }
}

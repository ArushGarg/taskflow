import 'package:flutter/material.dart';

/// Central theme + color palette.
/// Palette is deliberately close to the reference screens supplied by
/// Whatbytes (soft purple primary, off-white background, pill-shaped
/// category tags) so the UI matches the mock without copying any assets.
class AppColors {
  AppColors._();

  static const primary = Color(0xFF7B7BF0);
  static const primaryDark = Color(0xFF6C63FF);
  static const background = Color(0xFFF7F7FB);
  static const cardBackground = Colors.white;
  static const textPrimary = Color(0xFF2D2D3A);
  static const textSecondary = Color(0xFF9494A6);

  static const priorityLow = Color(0xFF4CAF93);
  static const priorityMedium = Color(0xFFF6A93B);
  static const priorityHigh = Color(0xFFEF5A6F);

  static const tagPersonal = Color(0xFFF6A93B);
  static const tagWork = Color(0xFF7B7BF0);
  static const tagStudy = Color(0xFF6FCF97);
  static const tagOther = Color(0xFFB6B6C9);

  static const success = Color(0xFF4CAF93);
  static const error = Color(0xFFEF5A6F);
  static const divider = Color(0xFFECECF4);
}

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData.light();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        error: AppColors.error,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
        fontFamily: 'Roboto',
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle:
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
      ),
      useMaterial3: true,
    );
  }
}
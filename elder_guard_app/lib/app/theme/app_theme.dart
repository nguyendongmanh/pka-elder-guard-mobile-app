import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final baseTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.tealPrimary,
        primary: AppColors.tealPrimary,
        secondary: AppColors.tealSecondary,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.creamLight,
    );

    final textTheme = GoogleFonts.nunitoTextTheme(
      baseTheme.textTheme,
    ).apply(bodyColor: AppColors.textDark, displayColor: AppColors.textDark);

    return baseTheme.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.creamLight,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepTeal,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.tealPrimary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          textStyle: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
            fontSize: 22,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tealPrimary,
          textStyle: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFBF3).withValues(alpha: 0.9),
        hintStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textDark.withValues(alpha: 0.74),
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: AppColors.tealPrimary,
        suffixIconColor: AppColors.tealPrimary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.tealPrimary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.tealPrimary, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.deepTeal, width: 2.2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.error, width: 2.2),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Yellow & Black color tokens — WIA Census 2026 brand.
abstract final class AppColors {
  // Core brand
  static const primary = Color(0xFF1C1C1E);           // jet black
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFFC300);   // golden yellow
  static const onPrimaryContainer = Color(0xFF1C1C1E);
  static const primaryDim = Color(0xFF2D2D2F);         // dark grey for gradients
  static const navyDark = Color(0xFF1C1C1E);           // kept as alias

  static const secondary = Color(0xFFFFC300);          // golden yellow (FABs, accents)
  static const onSecondary = Color(0xFF1C1C1E);
  static const secondaryContainer = Color(0xFFFFF3C4);
  static const onSecondaryContainer = Color(0xFF664D00);

  static const tertiary = Color(0xFF22C55E);           // emerald — synced / success
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFFD1FAE5);
  static const onTertiaryContainer = Color(0xFF065F46);

  static const error = Color(0xFFDC2626);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFEE2E2);

  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF1C1C1E);
  static const onSurfaceVariant = Color(0xFF6B7280);
  static const surfaceContainerLow = Color(0xFFF5F5F5);
  static const surfaceContainer = Color(0xFFEEEEEE);
  static const surfaceContainerHigh = Color(0xFFE5E5E5);

  static const outline = Color(0xFFD1D5DB);
  static const outlineVariant = Color(0xFFE5E7EB);

  // Semantic aliases
  static const amber = Color(0xFFF59E0B);
  static const teal = Color(0xFF0EA5E9);
}

abstract final class AppTheme {
  static const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: Color(0xFF7F1D1D),
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF5F5F5),
    onInverseSurface: Color(0xFF1C1C1E),
    inversePrimary: AppColors.primaryContainer,
    surfaceTint: AppColors.primary,
  );

  static ThemeData get light {
    final baseText = GoogleFonts.interTextTheme();
    final headlineFont = GoogleFonts.plusJakartaSans();

    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorScheme,
      scaffoldBackgroundColor: AppColors.surfaceContainerLow,
      textTheme: baseText.copyWith(
        displayLarge: headlineFont.copyWith(fontWeight: FontWeight.w700),
        displayMedium: headlineFont.copyWith(fontWeight: FontWeight.w700),
        displaySmall: headlineFont.copyWith(fontWeight: FontWeight.w700),
        headlineLarge: headlineFont.copyWith(fontWeight: FontWeight.w700),
        headlineMedium: headlineFont.copyWith(fontWeight: FontWeight.w700),
        headlineSmall: headlineFont.copyWith(fontWeight: FontWeight.w600),
        titleLarge: headlineFont.copyWith(fontWeight: FontWeight.w600),
        titleMedium: headlineFont.copyWith(fontWeight: FontWeight.w600),
        titleSmall: headlineFont.copyWith(fontWeight: FontWeight.w500),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.secondary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        isDense: false,
        filled: false,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
          textStyle: GoogleFonts.inter(
              fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return Colors.white;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.onPrimary;
            }
            return AppColors.onSurface;
          }),
          side: WidgetStateProperty.all(
              BorderSide(color: AppColors.outline)),
        ),
      ),
    );
  }
}

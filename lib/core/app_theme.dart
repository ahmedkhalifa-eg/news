import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const Color darkBg = Color(0xFF141414);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color lightBg = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1B1B1B);
  static const Color pill = Color(0xFF808080);
  static const Color muted = Color(0xFF9A9A9A);
  static const Color drawerBody = Color(0xFF111111);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness b) {
    final isDark = b == Brightness.dark;
    final bg = isDark ? AppColors.darkBg : AppColors.lightBg;
    final fg = isDark ? Colors.white : Colors.black;
    final base = ThemeData(brightness: b, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        brightness: b,
        surface: bg,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: fg,
        displayColor: fg,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: fg, size: 22),
        titleTextStyle: GoogleFonts.inter(
          color: fg,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerColor: fg.withValues(alpha: 0.4),
    );
  }
}

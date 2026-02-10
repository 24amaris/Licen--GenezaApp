import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tema Geneza - Paletă elegantă: Grey, Beige, Navy, Black
class GenezaTheme {
  // ============================================================================
  // PALETA DE CULORI (4 culori principale)
  // ============================================================================
  
  /// Gri foarte deschis (aproape alb) - pentru text pe fundal închis
  static const Color lightGrey = Color(0xFFF1EFEC);
  
  /// Bej/Taupe deschis - pentru accente calde
  static const Color beige = Color(0xFFD4C9BE);
  
  /// Navy (albastru închis) - culoare principală accent
  static const Color navy = Color(0xFF123458);
  
  /// Negru profund - fundal principal
  static const Color deepBlack = Color(0xFF030303);
  
  // Variante derivate pentru UI
  static const Color navyLight = Color(0xFF1A4A78);  // Navy mai deschis
  static const Color navyDark = Color(0xFF0D2640);   // Navy mai închis
  
  /// Success - verde (păstrăm pentru feedback)
  static const Color success = Color(0xFF06D6A0);
  
  /// Error - roșu (păstrăm pentru feedback)
  static const Color error = Color(0xFFEF233C);

  // ============================================================================
  // TEMA FLUTTER
  // ============================================================================
  
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepBlack,
      primaryColor: navy,
      
      colorScheme: const ColorScheme.dark(
        primary: navy,
        secondary: beige,
        surface: navyDark,
        error: error,
      ),
      
      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: deepBlack,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightGrey,
        ),
        iconTheme: const IconThemeData(color: navy),
      ),
      
      // Card
      cardTheme: const CardThemeData(
        color: navyDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      
      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: lightGrey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: navy,
        ),
      ),
      
      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: navyDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navy),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: navy),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: beige, width: 2),
        ),
      ),
      
      // Icons
      iconTheme: const IconThemeData(
        color: navy,
        size: 24,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: lightGrey,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: lightGrey,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: lightGrey,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: beige,
        ),
      ),
    );
  }
}
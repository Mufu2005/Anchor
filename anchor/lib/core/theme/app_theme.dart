import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Your Palette
  static const Color voidBlack = Color(0xFF000000);
  static const Color deepTaupe = Color(0xFF5C4E4E);
  static const Color fogWhite = Color(0xFFD1D0D0);
  static const Color mutedTaupe = Color(0xFF988686);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidBlack,
      primaryColor: deepTaupe,
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.oswald( // For "ANCHOR" / Headers
          color: fogWhite,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        bodyMedium: GoogleFonts.robotoMono( // For details/data
          color: fogWhite,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.robotoMono( // For secondary text
          color: mutedTaupe, 
          fontSize: 12,
        ),
      ),

      // Card Theme (for your Task items)
      cardTheme: CardThemeData(
        color: deepTaupe,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF111827);       // Deep Slate Blue
  static const Color primaryLight = Color(0xFF1F2937);   // Lighter Slate
  static const Color primaryDark = Color(0xFF0B1220);    // Darkest Slate

  // Accent / Success
  static const Color accent = Color(0xFF4FD1C5);         // Soft teal accent
  static const Color accentLight = Color(0xFF7EE8D8);    // Light teal
  static const Color accentDark = Color(0xFF2EB6A8);     // Dark teal
  static const Color accentGlow = Color(0x334FD1C5);     // Accent glow overlay

  // Background & Surface
  static const Color background = Color(0xFF0F1724);     // Deep dark background
  static const Color surface = Color(0xFF182132);         // Card surface
  static const Color surfaceLight = Color(0xFF202A3E);    // Elevated surface
  static const Color surfaceRaised = Color(0xFF222D42);   // Raised surface
  static const Color surfacePressed = Color(0xFF12192A);  // Pressed surface
  static const Color surfaceGlass = Color(0x1AFFFFFF);    // Glass effect

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFC3CAD8);
  static const Color textMuted = Color(0xFF7D869A);

  // Shadows
  static const Color shadowLight = Color(0x334A5873);
  static const Color shadowDark = Color(0x99101828);

  // Status Colors
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Crowd Meter Colors
  static const Color crowdLow = Color(0xFF22C55E);       // Green - Empty
  static const Color crowdMedium = Color(0xFFEAB308);     // Yellow - Moderate
  static const Color crowdHigh = Color(0xFFF97316);       // Orange - High
  static const Color crowdFull = Color(0xFFEF4444);       // Red - Full

  // Gradient Presets
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF22C55E), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF223047), Color(0xFF172030)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F1724), Color(0xFF23344E), Color(0xFF0F1724)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF1B2435), Color(0xFF29364D), Color(0xFF1B2435)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

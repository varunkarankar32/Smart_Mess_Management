import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors
  static const Color primary = Color(0xFF0F172A);       // Deep Slate Blue
  static const Color primaryLight = Color(0xFF1E293B);   // Lighter Slate
  static const Color primaryDark = Color(0xFF020617);    // Darkest Slate

  // Accent / Success
  static const Color accent = Color(0xFF22C55E);         // Vibrant Green
  static const Color accentLight = Color(0xFF4ADE80);    // Light Green
  static const Color accentDark = Color(0xFF16A34A);     // Dark Green
  static const Color accentGlow = Color(0x3322C55E);     // Green glow overlay

  // Background & Surface
  static const Color background = Color(0xFF0A0E1A);     // Deep dark background
  static const Color surface = Color(0xFF121829);         // Card surface
  static const Color surfaceLight = Color(0xFF1A2235);    // Elevated surface
  static const Color surfaceGlass = Color(0x1AFFFFFF);    // Glass effect

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8C9);
  static const Color textMuted = Color(0xFF6B7280);

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
    colors: [Color(0xFF1A2235), Color(0xFF121829)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E3A5F), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF1A2235), Color(0xFF2A3245), Color(0xFF1A2235)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

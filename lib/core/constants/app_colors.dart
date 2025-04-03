import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF1565C0); // Deep Blue
  static const Color primaryDark = Color(0xFF0D47A1); // Darker Blue

  // Secondary Colors
  static const Color secondary = Color(0xFFD81B60); // Vibrant Pink
  static const Color secondaryDark = Color(0xFFAD1457); // Deep Pink

  // Accent Colors
  static const Color accent = Color(0xFF8E24AA); // Bright Purple
  static const Color accentDark = Color(0xFF6A1B9A); // Dark Purple

  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF); // Pure White
  static const Color backgroundDark = Color(0xFF121212); // Deep Black

  // Surface Colors (for cards, UI sections)
  static const Color surfaceLight = Color(0xFFF5F5F5); // Soft Grey
  static const Color surfaceDark = Color(0xFF1E1E1E); // Dark Grey
  static Color lightGrey = Colors.grey.shade100;
  static Color downVote = Colors.red.shade700;
  static Color upVote = Colors.green.shade700;

  // Text Colors
  static const Color textPrimary = Color(0xFF212121); // Blackish for Light Mode
  static const Color textPrimaryDark =
      Color(0xFFE0E0E0); // Light Grey for Dark Mode

  static const Color textSecondary = Color(0xFF757575); // Muted Grey
  static const Color textSecondaryDark = Color(0xFFBDBDBD); // Dim Grey

  static const Gradient buttonGradient = LinearGradient(
    colors: [
      Color(0xFF2196F3), // Premium Vibrant Blue
      Color(0xFF1976D2), // Deep Royal Blue
      Color(0xFF0D47A1), // Luxurious Navy Blue
    ],
  );

  static const Gradient backgroundGradient = LinearGradient(
    colors: [
      Color(0xFF1565C0),
      Color(0xFFD81B60),
    ],
    begin: Alignment.topLeft,
    end: Alignment.topRight,
  );

  static const Gradient containerGradient = LinearGradient(
    colors: [
      Color(0xFFF5F7FA), // Soft, warm off-white with a hint of blue
      Color(0xFFE8ECEF), // Light, neutral grey with a warm undertone
      Color(0xFFDCE2E6), // Subtle, modern grey-blue for depth
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static  Gradient circleGradient = LinearGradient(
    colors: [
      Colors.blue.shade400, Colors.purple.shade400,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

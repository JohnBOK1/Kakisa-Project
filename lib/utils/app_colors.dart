import 'package:flutter/material.dart';

class AppColors {
  // Primary tropical colors - matching React cyan/blue theme
  static const Color primary = Color(0xFF0891B2); // cyan-600
  static const Color primaryLight = Color(0xFF06B6D4); // cyan-500
  static const Color primaryDark = Color(0xFF0E7490); // cyan-700
  
  // Secondary colors
  static const Color secondary = Color(0xFF3B82F6); // blue-500
  static const Color secondaryLight = Color(0xFF60A5FA); // blue-400
  static const Color secondaryDark = Color(0xFF1D4ED8); // blue-700
  
  // Background gradients - matching React design
  static const Color backgroundGradientStart = Color(0xFFECFEFF); // cyan-50
  static const Color backgroundGradientEnd = Color(0xFFEFF6FF); // blue-50
  
  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);
  
  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // Tropical gradients - matching React design
  static const List<Color> tropicalGradient = [
    Color(0xFF06B6D4), // cyan-500
    Color(0xFF3B82F6), // blue-500
  ];
  
  static const List<Color> oceanGradient = [
    Color(0xFF0891B2), // cyan-600
    Color(0xFF1E40AF), // blue-700
  ];

  // Border and shadow
  static const Color borderColor = Color(0xFFE5E7EB); // gray-200
  static const Color shadowColor = Color(0x1A000000); // black with 10% opacity
}

class AppTextStyles {
  // Matching React typography
  static const TextStyle heading1 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: AppColors.grey800,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.grey800,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.grey800,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.grey800,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.grey600,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.grey600,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.grey500,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey500,
  );
}
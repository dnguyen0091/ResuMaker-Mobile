import 'package:flutter/material.dart';

class AppColor {
  // Theme Colors - Dark theme values
  static const Color backgroundDark = Color(0xFF343541); // Main background
  static const Color cardDark = Color(0xFF444654); // Chat bubbles
  static const Color textDark = Color(0xFFEFEFEF); // Primary text
  static const Color secondaryTextDark = Color(0xFFACACBE); // Secondary text
  static const Color borderDark = Color(0xFF565869); // Borders/dividers
  static const Color accentDark = Color(0xFF19C37D); // GPT accent (green)
  static const Color userBubbleDark = Color(0xFF202123); // User message background
  static const Color inputFieldDark = Color(0xFF40414F); // Input field background
  static const Color iconDark = Color(0xFFD9D9E3); // Icons
  
  // Default colors (equivalent to CSS variables)
  static const Color background = backgroundDark;
  static const Color card = cardDark;
  static const Color text = textDark;
  static const Color secondaryText = secondaryTextDark;
  static const Color border = borderDark;
  static const Color accent = accentDark;
  static const Color userBubble = userBubbleDark;
  static const Color inputField = inputFieldDark;
  static const Color icon = iconDark;
  static const double iconBrightness = 0.85; // Dark mode icon brightness
  
  // Primary and secondary colors
  static const Color primaryColor = Color(0xFF101014);
  static const Color secondaryColor = Color(0xFF1E1E1E);
  
  // Light theme colors - if you want to add them later
  static const Color backgroundLight = Colors.white;
  static const Color cardLight = Color(0xFFF7F7F8);
  static const Color textLight = Color(0xFF343541);
  static const Color secondaryTextLight = Color(0xFF444654);
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color accentLight = Color(0xFF19C37D); // Same accent color for both themes
}
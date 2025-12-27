import 'package:flutter/material.dart';

class AppColors {
  
  AppColors._();

  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color accentOrange = Color(0xFFFB8C00);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color errorRed = Color(0xFFE53935);
}

class AppStyles {
  AppStyles._();

  static const TextStyle headingStyle = TextStyle(
    fontSize: 22, 
    fontWeight: FontWeight.bold, 
    color: AppColors.textDark
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontSize: 16, 
    fontWeight: FontWeight.w600,
    color: AppColors.textDark 
  );
}
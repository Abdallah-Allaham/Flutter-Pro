import 'package:flutter/material.dart';

/// لوحة الألوان المنسقة والفاخرة للمشروع (Design System Token Colors).
class AppColors {
  AppColors._();

  // ألوان رئيسية (Harmonious Modern Palette)
  static const Color primary = Color(0xFF6366F1); // Indigo / Violet
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);
  
  static const Color secondary = Color(0xFF10B981); // Emerald Green
  static const Color accent = Color(0xFFF59E0B); // Amber / Gold

  // درجات الألوان الداكنة والخلفيات المعاصرة (Slate colors)
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);

  // ألوان النصوص والتفاصيل
  static const Color textPrimaryLight = Color(0xFF1E293B);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // ألوان التنبيهات والأخطاء
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // تدرجات لونية عصرية (Premium Gradients)
  static const Gradient primaryGradient = LinearGradient(
    colors: [primary, Color(0xFFEC4899)], // Indigo to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient darkGradient = LinearGradient(
    colors: [backgroundDark, Color(0xFF1E1E38)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

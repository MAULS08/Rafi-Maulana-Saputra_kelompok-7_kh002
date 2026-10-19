import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00796B)),
      scaffoldBackgroundColor: const Color(0xFFF2F4F4),
    );
  }
}

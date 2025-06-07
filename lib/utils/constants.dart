import 'package:flutter/material.dart';

// 🎨 Warna Tema
class AppColors {
  static const Color primary = Color(0xFF81C784); // Hijau cerah
  static const Color secondary = Color(0xFF4FC3F7); // Biru muda
  static const Color background = Color(0xFFF5F5F5); // Abu muda
  static const Color accentYellow = Color(0xFFFFF176); // Kuning muda
  static const Color pinkSoft = Color(0xFFF8BBD0); // Pink lembut
  static const Color white = Colors.white;
}

// 🔤 Font Styles
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Baloo',
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Baloo',
    fontSize: 16,
    color: Colors.black87,
  );

  static const TextStyle button = TextStyle(
    fontFamily: 'Baloo',
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );
}

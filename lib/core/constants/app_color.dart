import 'package:flutter/material.dart';

class AppColor {
  // 🎨 Ana Gradient Renkleri
  static const purple500 = Color(0xFFA855F7);
  static const purple600 = Color(0xFF9333EA);
  static const pink500 = Color(0xFFEC4899);
  static const pink600 = Color(0xFFDB2777);

  // 🌑 Background Renkleri
  static const slate950 = Color(0xFF020617);
  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const purple950 = Color(0xFF3B0764);
  static const purple900 = Color(0xFF581C87);
  static const purple800 = Color(0xFF6B21A8);

  // ✨ Accent & Detail Renkleri
  static const purple400 = Color(0xFFC084FC);
  static const purple300 = Color(0xFFD8B4FE);
  static const pink400 = Color(0xFFF472B6);
  static const green400 = Color(0xFF4ADE80);
  static const blue500 = Color(0xFF3B82F6);

  // 🌫️ Opacity Kullanımları (Glassmorphism için)
  static const white5 = Color.fromRGBO(255, 255, 255, 0.05);
  static const white10 = Color.fromRGBO(255, 255, 255, 0.10);
  static const white20 = Color.fromRGBO(255, 255, 255, 0.20);
  static const white30 = Color.fromRGBO(255, 255, 255, 0.30);
  static const white40 = Color.fromRGBO(255, 255, 255, 0.40);
  static const white50 = Color.fromRGBO(255, 255, 255, 0.50);
  static const white60 = Color.fromRGBO(255, 255, 255, 0.60);
  static const white80 = Color.fromRGBO(255, 255, 255, 0.80);
  static const white = Colors.white;

  // 🌈 Gradient Kombinasyonları
  static const LinearGradient mainGradient = LinearGradient(
    colors: [purple500, pink500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient hoverGradient = LinearGradient(
    colors: [purple600, pink600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [slate950, purple950, slate950],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [purple500, pink500, purple600],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // 💨 Shadow Renkleri
  static const purpleShadow20 = Color.fromRGBO(168, 85, 247, 0.20);
  static const purpleShadow30 = Color.fromRGBO(168, 85, 247, 0.30);
  static const purpleShadow50 = Color.fromRGBO(168, 85, 247, 0.50);
  static const purpleShadow60 = Color.fromRGBO(168, 85, 247, 0.60);
}
